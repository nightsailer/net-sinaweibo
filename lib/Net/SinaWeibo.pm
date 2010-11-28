package Net::SinaWeibo;
# ABSTRACT: Simple and lightweight OAuth api for SinaWeibo
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
        method => 'GET',
        restricted => 0,
    },
    home_timeline => {
        uri => 'statuses/public_timeline',
        method => 'GET',
        restricted => 0,
    },
    friends_timeline => {
        uri => 'statuses/friends_timeline',
        method => 'GET',
        restricted => 1,
    },
    user_timeline => {
        uri => 'statuses/user_timeline',
        method => 'GET',
        restricted => 1,
    },
    mentions => {
        uri => 'statuses/mentions',
        method => 'GET',
        restricted => 1,
    },
    comments_timeline => {
        uri => 'statuses/comments_timeline',
        method => 'GET',
        restricted => 1,
    },
    comments_by_me => {
        uri => 'statuses/comments_by_me',
        method => 'GET',
        restricted => 1,
    },
    comments_to_me => {
        uri => 'statuses/comments_to_me',
        method => 'GET',
        restricted => 1,
    },
    comments => {
        uri => 'statuses/comments',
        method => 'GET',
        restricted => 1,
    },
    status_counts => {
        uri => 'statuses/counts',
        method => 'GET',
        restricted => 1,
    },
    status_unread => {
        uri => 'statuses/unread',
        method => 'GET',
        restricted => 1,
    },
    status_reset_count => {
        uri => 'statuses/reset_count',
        method => 'POST',
        restricted => 1,
    },
    emotions => {
        uri => 'statuses/emotions',
        method => 'GET',
        restricted => 0,
    },
    show_status => {
        uri => 'statuses/show',
        method => 'GET',
        restricted => 1,
    },
    update_status => {
        uri => 'statuses/update',
        method => 'POST',
        restricted => 1,
    },
    upload_status => {
        uri => 'statuses/upload',
        method => 'POST',
        restricted => 1,
    },
    remove_status => {
        uri => 'statuses/destroy',
        method => 'POST',
        restricted => 1,
    },
    repost_status => {
        uri => 'statuses/repost',
        method => 'POST',
        restricted => 1,
    },
    retweet => {
        uri => 'statuses/repost',
        method => 'POST',
        restricted => 1,
    },
    comment => {
        uri => 'statuses/comment',
        method => 'POST',
        restricted => 1,
    },
    remove_comment => {
        uri => 'statuses/comment_destroy',
        method => 'POST',
        restricted => 1,
    },
    batch_remove_comments => {
        uri => 'statuses/comment/destroy_batch',
        method => 'POST',
        restricted => 1,
    },
    reply_comment => {
        uri => 'statuses/reply',
        method => 'POST',
        restricted => 1,
    },
    hot_users => {
        uri => 'users/hot',
        method => 'GET',
        restricted => 1,
    },
    show_user => {
        uri => 'users/show',
        method => 'GET',
        restricted => 1,
    },
    friends => {
        uri => 'statuses/friends',
        method => 'GET',
        restricted => 1,
    },
    followers => {
        uri => 'statuses/followers',
        method => 'GET',
        restricted => 1,
    },
    dm => {
        uri => 'direct_messages',
        method => 'GET',
        restricted => 1,
    },
    dm_sent => {
        uri => 'direct_messages/sent',
        method => 'GET',
        restricted => 1,
    },
    send_dm => {
        uri => 'direct_messages/new',
        method => 'POST',
        restricted => 1,
    },
    remove_dm => {
        uri => 'direct_messages/destroy',
        method => 'POST',
        restricted => 1,
    },
    batch_remove_dm => {
        uri => 'direct_messages/destroy_batch',
        method => 'POST',
        restricted => 1,
    },
    follow => {
        uri => 'friendships/create',
        method => 'POST',
        restricted => 1,
    },
    unfollow => {
        uri => 'friendships/destroy',
        method => 'POST',
        restricted => 1,
    },
    is_followed => {
        uri => 'friendships/show',
        method => 'GET',
        restricted => 1,
    },
    get_friends_id_list => {
        uri => 'friends/ids',
        method => 'GET',
        restricted => 1,
    },
    get_followers_id_list => {
        uri => 'followers/ids',
        method => 'GET',
        restricted => 1,
    },
    update_privacy => {
        uri => 'account/update_privacy',
        method => 'POST',
        restricted => 1,
    },
    get_privacy => {
        uri => 'account/get_privacy',
        method => 'POST',
        restricted => 1,
    },
    block_user => {
        uri => 'blocks/create',
        method => 'POST',
        restricted => 1,
    },
    unblock_user => {
        uri => 'blocks/destroy',
        method => 'POST',
        restricted => 1,
    },
    is_blocked => {
        uri => 'blocks/exists',
        method => 'POST',
        restricted => 1,
    },
    blocking => {
        uri => 'blocks/blocking',
        method => 'GET',
        restricted => 1,
    },
    blocking_id_list => {
        uri => 'blocks/blocking/ids',
        method => 'GET',
        restricted => 1,
    },
    tags => {
        uri => 'tags',
        method => 'GET',
        restricted => 1,
    },
    add_tag => {
        uri => 'tags/create',
        method => 'POST',
        restricted => 1,
    },
    tag_suggestions => {
        uri => 'tags/suggestions',
        method => 'GET',
        restricted => 1,
    },
    remove_tag => {
        uri => 'tags/destroy',
        method => 'POST',
        restricted => 1,
    },
    batch_remove_tags => {
        uri => 'tags/destroy_batch',
        method => 'POST',
        restricted => 1,
    },
    verify_credentials => {
        uri => 'account/verify_credentials',
        method => 'GET',
        restricted => 1,
    },
    rate_limit_status => {
        uri => 'account/rate_limit_status',
        method => 'GET',
        restricted => 1,
    },
    end_session => {
        uri => 'account/end_session',
        method => 'POST',
        restricted => 1,
    },
    # update_profile_image => {
    #     uri => 'account/update_profile_image',
    #     method => 'POST',
    #     restricted => 1,
    # },
    update_profile => {
        uri => 'account/update_profile',
        method => 'POST',
        restricted => 1,
    },
    favorites => {
        uri => 'favorites',
        method => 'GET',
        restricted => 1,
    },
    add_favorite => {
        uri => 'favorites/create',
        method => 'POST',
        restricted => 1,
    },
    remove_favorite => {
        uri => 'favorites/destroy',
        method => 'POST',
        restricted => 1,
    },
    batch_remove_favorites => {
        uri => 'favorites/destroy_batch',
        method => 'POST',
        restricted => 1,
    },
);



# workaround for Sina API, its response not exists this now.
sub callback_confirmed { 1 }

sub _build_url {
    my (%params) = @_;
    my $url = delete $params{url};
    my $id  = delete $params{id};
    return defined($id) ? (url => SINA_SITE.$url.'/'.($id).'.'.SINA_FORMAT)
        : (url => SINA_SITE.$url.'.'.SINA_FORMAT);
}

sub _build_api_proxy_sub {
    my ($api) = @_;
    if ($api->{restricted}) {
        return sub {
             my $self = shift;
             my %params = ( http_method => 'GET', _build_url(@_, url => $api->{uri}) );
             my $response = $self->make_restricted_request(delete $params{url},$api->{method},@_);
             decode_json $response->content;
        }
    }
    else {
        return sub {
            my $self = shift;
            my %params = ( http_method => 'GET', _build_url(@_,url => $api->{uri} ) );
            my $response = $self->make_general_request(delete $params{url},$api->{method},@_);
            decode_json $response->content;
        }
    }
}

sub status_url { SINA_SITE.'/'.shift().'/statuses/'.shift() }

# auto compile api proxy method
sub import {
    shift;
    no strict 'refs';
    foreach my $k (keys %SINA_API) {
        *{__PACKAGE__.'::'.$k } = _build_api_proxy_sub($SINA_API{$k});
    }
}
1;
__END__

=head1 SYNOPSIS

=head1 DESCRIPTION
