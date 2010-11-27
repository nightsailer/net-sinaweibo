package Net::SinaWeibo;
# ABSTRACT
use strict;
use warnings;
use base qw(Net::OAuth::Simple);
use JSON;
use constant {
    SINA_SITE              =>  'http://api.t.sina.com.cn/',
    SINA_REQUEST_TOKEN_URL => 'http://api.t.sina.com.cn/oauth/request_token',
    SINA_AUTHORIZATION_URL => 'http://api.t.sina.com.cn/oauth/authorize',
    SINA_ACCESS_TOKEN_URL  => 'http://api.t.sina.com.cn/oauth/access_token',
    SINA_FORMAT            => 'json',
};

sub new {
     return shift->SUPER::new(
             tokens => { @_ },
             protocol_version => '1.0a',
             urls => {
                 request_token_url => SINA_REQUEST_TOKEN_URL,
                 authorization_url => SINA_AUTHORIZATION_URL,
                 access_token_url =>  SINA_ACCESS_TOKEN_URL,
             },
         );
}
# SINA SDK API
our %SINA_API = (
    public_timeline => {
        uri => 'statuses/public_timeline',
        restricted => 0,
    },
    home_timeline => {
        uri => 'statuses/public_timeline',
        restricted => 0,
    },
    home_timeline => {
        uri => 'statuses/public_timeline',
        restricted => 0,
    },
);

# auto compile api proxy method
sub import {
    shift;
    no strict 'refs';
    foreach my $m (keys %SINA_API) {
        my $api = $SINA_API{$m};
        my $url = $api->{uri};
        if ($api->{restricted}) {
            *{__PACKAGE__.'::'.$m } = sub { decode_json(shift->_make_restricted_request(url => $url,@_)) };
        }
        else {
            *{__PACKAGE__.'::'.$m } = sub { decode_json(shift->_make_general_request(url => $url,@_)) };
        }
    }
}

# workaround for Sina API, its response not include this now.
sub callback_confirmed { 1 }

sub _build_url {
    my (%params) = @_;
    my $url = delete $params{url};
    my $id  = delete $params{id};
    return $params{id} ? (url => SINA_SITE.$url.'/'.(delete $params{id}).'.'.SINA_FORMAT)
        : (url => SINA_SITE.$url.'.'.SINA_FORMAT);
}

sub _make_restricted_request {
    my $self = shift;
    my $response = $self->make_restricted_request(_build_url(@_));
    decode_json $response->content;
}

sub _make_general_request {
    my $self = shift;
    my $response = $self->make_general_request(_build_url(@_));
    decode_json $response->content;
}

1;
__END__


=head1 NAME

Net::SinaWeibo - Simple OAuth SDK for SinaWeibo

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

=head1 COPYRIGHT

