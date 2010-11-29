package Net::SinaWeibo::OAuth;
# ABSTRACT: Internal OAuth wrapper round OAuth::Lite::Consumer
use strict;
use warnings;
use Carp;
use Data::Dumper;
use base 'OAuth::Lite::Consumer';
use OAuth::Lite::AuthMethod qw(:all);
use List::MoreUtils qw(any);
use HTTP::Request::Common;
use OAuth::Lite::Util qw(normalize_params);
use constant {
    SINA_SITE               =>  'http://api.t.sina.com.cn',
    SINA_REQUEST_TOKEN_PATH => '/oauth/request_token',
    SINA_AUTHORIZATION_PATH => '/oauth/authorize',
    SINA_ACCESS_TOKEN_PATH  => '/oauth/access_token',
    SINA_FORMAT             => 'json',
};
sub new {
    my ($class,%args) = @_;
    my $tokens = delete $args{tokens};
    my $self = $class->SUPER::new(
        site => SINA_SITE,
        request_token_path => SINA_REQUEST_TOKEN_PATH,
        access_token_path  => SINA_ACCESS_TOKEN_PATH,
        authorize_path     => SINA_AUTHORIZATION_PATH,
        %args
        );
    if ($tokens->{request_token} && $tokens->{request_token_secret}) {
        $self->request_token(OAuth::Lite::Token->new(
            token  => $tokens->{request_token},
            secret => $tokens->{request_token_secret},
            ));
    }
    if ($tokens->{access_token} && $tokens->{access_token_secret}) {
        $self->access_token(OAuth::Lite::Token->new(
            token  => $tokens->{access_token},
            secret => $tokens->{access_token_secret}, 
            ));
    }
    $self;
}

sub make_restricted_request {
    my ($self,$url,$method,%params) = @_;
    my %multi_parts = ();
    if ($method eq 'POST') {
        foreach my $param (keys %params) {
            next unless substr($param,0,1) eq '@';
            $multi_parts{substr($param,1) } = [delete $params{$param}];
        }
    }
    my $res = $self->request(
        method => $method,
        url => SINA_SITE.'/'.$url.'.'.SINA_FORMAT,
        token => $self->access_token,
        params => \%params,
        multi_parts => { %multi_parts }
        );
    unless ($res->is_success) {
        croak $res->decoded_content || $res->content;
    }
    $res->decoded_content || $res->content;
}
sub load_tokens {
    my $class  = shift;
    my $file   = shift;
    my %tokens = ();
    return %tokens unless -f $file;

    open(my $fh, $file) || die "Couldn't open $file: $!\n";
    while (<$fh>) {
        chomp;
        next if /^#/;
        next if /^\s*$/;
        next unless /=/;
        s/(^\s*|\s*$)//g;
        my ($key, $val) = split /\s*=\s*/, $_, 2;
        $tokens{$key} = $val;
    }
    close($fh);
    return %tokens;
}

sub save_tokens {
    my $class  = shift;
    my $file   = shift;
    my %tokens = @_;

    my $max    = 0;
    foreach my $key (keys %tokens) {
        $max   = length($key) if length($key)>$max;
    }

    open(my $fh, ">$file") || die "Couldn't open $file for writing: $!\n";
    foreach my $key (sort keys %tokens) {
        my $pad = " "x($max-length($key));
        print $fh "$key ${pad}= ".$tokens{$key}."\n";
    }
    close($fh);
}

sub get_authorize_url {
    my ($self,%args) = @_;
    my $token = $args{token} || $self->request_token;
    unless ($token) {
        $token = $self->get_request_token or
            Carp::croak "Can't find request token";
    }
    $args{token} = $token;
    $self->url_to_authorize(%args);
}

# override method to support multipart-form
sub gen_oauth_request {

    my ($self, %args) = @_;

    my $method  = $args{method} || $self->{http_method};
    my $url     = $args{url};
    my $content = $args{content};
    my $token   = $args{token};
    my $extra   = $args{params} || {};
    my $realm   = $args{realm}
                || $self->{realm}
                || $self->find_realm_from_last_response
                || '';
    my $multi_parts  = $args{multi_parts} || {};

    if (ref $extra eq 'ARRAY') {
        my %hash;
        for (0...scalar(@$extra)/2-1) {
            my $key = $extra->[$_ * 2];
            my $value = $extra->[$_ * 2 + 1];
            $hash{$key} ||= [];
            push @{ $hash{$key} }, $value;
        }
        $extra = \%hash;
    }
    my $headers = $args{headers} || {};
    # 
    # if (defined $headers) {
    #     if (ref($headers) eq 'ARRAY') {
    #         $headers = HTTP::Headers->new(@$headers);
    #     } else {
    #         $headers = $headers->clone;
    #     }
    # } else {
    #     $headers = HTTP::Headers->new;
    # }
    croak 'headers is not valid HASH REF.' unless ref $headers eq 'HASH';

    my @send_data_methods = qw/POST PUT/;
    my @non_send_data_methods = qw/GET HEAD DELETE/;

    my $is_send_data_method = any { $method eq $_ } @send_data_methods;

    # my $auth_method = $self->{auth_method};
    # $auth_method = AUTH_HEADER
    #     if ( !$is_send_data_method && $auth_method eq POST_BODY );
    # 
    # if ($auth_method eq URL_QUERY) {
    #     if ( $is_send_data_method && !$content ) {
    #         Carp::croak
    #             qq(You must set content-body in case you use combination of URL_QUERY and POST/PUT http method);
    #     } else {
    #         if ( $is_send_data_method ) {
    #             if ( my $hash = $self->build_body_hash($content) ) {
    #                 $extra->{oauth_body_hash} = $hash;
    #             }
    #         }
    #         my $query = $self->gen_auth_query($method, $url, $token, $extra);
    #         $url = sprintf q{%s?%s}, $url, $query;
    #     }
    # } elsif ($auth_method eq POST_BODY) {
    #     my $query = $self->gen_auth_query($method, $url, $token, $extra);
    #     $content = $query;
    #     $headers->header('Content-Type', q{application/x-www-form-urlencoded});
    # } else {
    #     my $origin_url = $url;
    #     my $copied_params = {};
    #     for my $param_key ( keys %$extra ) {
    #         next if $param_key =~ /^x?oauth_/;
    #         $copied_params->{$param_key} = $extra->{$param_key};
    #     }
    #     if ( keys %$copied_params > 0 ) {
    #         my $data = normalize_params($copied_params);
    #         if ( $is_send_data_method && !$content ) {
    #             $content = $data;
    #         } else {
    #             $url = sprintf q{%s?%s}, $url, $data;
    #         }
    #     }
    #     if ( $is_send_data_method ) {
    #         if ( my $hash = $self->build_body_hash($content) ) {
    #             $extra->{oauth_body_hash} = $hash;
    #         }
    #     }
    #     my $header = $self->gen_auth_header($method, $origin_url,
    #         { realm => $realm, token => $token, extra => $extra });
    #     $headers->header( Authorization => $header );
    # }
    my $origin_url = $url;
    my $copied_params = {};
    for my $param_key ( keys %$extra ) {
        next if $param_key =~ /^x?oauth_/;
        $copied_params->{$param_key} = $extra->{$param_key};
    }
    if ( keys %$copied_params > 0 ) {
        my $data = normalize_params($copied_params);
        $url = sprintf q{%s?%s}, $url, $data unless $is_send_data_method;
    }
    # if ( keys %$copied_params > 0 ) {
    #     my $data = normalize_params($copied_params);
    #     if ( $is_send_data_method && !$content ) {
    #         $content = $data;
    #     } else {
    #         $url = sprintf q{%s?%s}, $url, $data;
    #     }
    # }
    # if ( $is_send_data_method ) {
    #     if ( my $hash = $self->build_body_hash($content) ) {
    #         $extra->{oauth_body_hash} = $hash;
    #     }
    # }
    my $header = $self->gen_auth_header($method, $origin_url,
        { realm => $realm, token => $token, extra => $extra });
    # $headers->header( Authorization => $header );
    $headers->{Authorization} = $header;
    if ($method eq 'GET') {
        GET $url,%$headers;
    }
    elsif ($method eq 'POST') {
        if ( keys %$multi_parts) {
            POST $url,{ %$extra, %$multi_parts },'Content-Type' => 'form-data',%$headers;
        }
        else {
            POST $url,$extra,%$headers;
        }
    }
    else {
        Carp::croak 'unsupport http_method:'.$method;
    }
    # if ( $is_send_data_method ) {
    #     $headers->header('Content-Type', q{application/x-www-form-urlencoded})
    #         unless $headers->header('Content-Type');
    #     $headers->header('Content-Length', bytes::length($content) );
    # }
    # $req = HTTP::Request->new( $method, $url, $headers, $content ); 
}
1;
__END__

=head1 SYNOPSIS

=head1 DESCRIPTION

