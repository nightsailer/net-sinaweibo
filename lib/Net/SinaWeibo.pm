package Net::SinaWeibo;
# ABSTRACT: A simple and lightweight OAuth api for SinaWeibo
use strict;
use warnings;
use base 'Net::SinaWeibo::OAuth';
use JSON;
use constant {
    SINA_SITE              =>  'http://api.t.sina.com.cn/',
    SINA_REQUEST_TOKEN_URL => 'http://api.t.sina.com.cn/oauth/request_token',
    SINA_AUTHORIZATION_URL => 'http://api.t.sina.com.cn/oauth/authorize',
    SINA_ACCESS_TOKEN_URL  => 'http://api.t.sina.com.cn/oauth/access_token',
    SINA_FORMAT            => 'json',
};
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
    post_status => {
        uri => 'statuses/update',
        method => 'POST',
        restricted => 1,
    },
    upload_status => {
        uri => 'statuses/upload',
        method => 'POST',
        restricted => 1,
        multi_part => 'pic',
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
    post_comment => {
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
    update_profile_image => {
        uri => 'account/update_profile_image',
        method => 'POST',
        restricted => 1,
        multi_part => 'image',
    },
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

sub new {
    my $class = shift;
    my %args = @_;
    my $client = $class->SUPER::new(
        consumer_key => $args{app_key},
        consumer_secret => $args{app_secret},
        request_token_path => SINA_REQUEST_TOKEN_URL,
        access_token_path => SINA_ACCESS_TOKEN_URL,
        authorize_path => SINA_AUTHORIZATION_URL,
        tokens => $args{tokens}
        );
    $client;
}

sub app_key { shift->consumer_key }

sub app_secret { shift->consumer_secret }

sub _build_api_proxy_sub {
    my ($api) = @_;
    return sub {
         my $self = shift;
         $self->last_api($api->{uri});
         my %params = @_;
         my $uri;
         if (exists $params{id}) {
            $uri = $api->{uri}.'/'.(delete $params{id});
         }
         else {
            $uri = $api->{uri};
         }
         if ($api->{multi_part}) {
             $params{'@'.$api->{multi_part}} = delete $params{ $api->{multi_part} };
         }
         $self->make_restricted_request($uri,$api->{method},%params);
    };
}

sub status_url {
    my ($self,$user_id,$status_id) = @_;

    return $self->{site}.'/'.$user_id.'/statuses/'.$status_id;
}
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

=encoding utf-8

=head1 SYNOPSIS
    
    # from sinaweibo app setting
    my $app_key = 'xxxx';
    my $app_key_secret = 'xxxxxxxxx';
    my $client = Net::SinaWeibo->new(
        app_key => $app_key,
        app_secret => $app_key_secret);
    # authorization
    my $callback_url = 'http://youdomain.com/app_callback';
    my $url = $client->get_authorize_url(callback_url => $callback_url);
    # or don't use callback_url,just like a desktop client.
    my $url = $client->get_authorize_url;
    # now $client hold the request_token, but you must authorize your app first.
    # let user go to visit the authorize url.
    say 'Please goto this url:',$url;

    # save these tokens to your file.
    Net::SinaWeibo->save_tokens('~/app/var/tokens/my.tokens',
        app_key => $app_key,
        app_key_secret => $app_key_secret,
        _request_token => $client->request_token->token,
        _request_token_secret => $client->request_token->secret,
        );

    # later,you can load tokens
    my %tokens = Net::SinaWeibo->load_tokens '~/app/var/tokens/my.tokens';

    # After user authorized,you can request access_token with the request token
    my $client = Net::SinaWeibo->new(
        app_key => $tokens{app_key},
        app_secret => $tokens{app_key_secret},
        tokens => {
            request_token => $tokens{_request_token},
            request_token_secret => $tokens{_request_token_secret},
        }
    );
    my $verifier = '5123876';
    my ($access_token,$access_token_secret) = $client->get_access_token(
        verifier => $verifier,
        );

    # now you can retrieve any restricted resources.
    my $friends = $client->friends;
    # any api can pass any specific parameters
    my $latest_mentions = $client->mentions since_id => 25892384,count => 10,page => 1;
    # upload also support.
    my $ok = $client->upload(status => 'Hello,this first image file', pic => 'images/demo.jpg');
    # profile image
    my $ok = update_profile_image(image => 'images/my_avatar.jpg');
    # enjoy!


=head1 DESCRIPTION

This is a lite OAuth client for SinaWeibo(http://t.sina.com.cn/).

=head1 METHODS

=head2 new(params)

    my $client = Net::SinaWeibo->new(
        app_key => 'sinaweibo_app_key',
        app_secret => 'sina_weibo_app_secret',
        # optional,you can pass access_token/request_token
        tokens => {
            access_token => 'xxxxxx',
            access_token_secret => 'xxxxxxxx',
            # or
            request_token => 'xxxxxxx',
            request_token_secret => 'xxxxx',
        }
    );

=head2 get_authorize_url(%params)

=head3 parameters

=over

=item callback_url

Url which service provider redirect end-user to after authorization.

=back

Get the URL to authorize a user as a URI object.

=head2 get_request_token

Request the request token and request token secret for this user.

This is called automatically by C<get_authorize_url> if necessary.


=head2 get_access_token(%params)

=head3 parameters

=over

=item verifier

Verfication code which SinaWeibo returns.

=item token

Request token object. Optional, if you has been set request_token.

=back

    my $access_token = $sina->get_access_token(verifier => '589893');
    # or
    my $access_token = $sina->get_access_token(verifier => '589893',token => $request_token);

Request the access token for this user.

The user must have authorized this app at the url given by
C<get_authorize_url> first.

Returns the access token but also sets
them internally so that after calling this method you can
immediately call a restricted method.

=head2 last_api

Get the last called api(uri)

=head2 last_api_error

Get the last api error hash ref. If the error message is not any valid error response,
will just return the raw response content.

=head2 load_tokens <file>

    my %tokens = Net::SinaWeibo->load_tokens('saved.tokens');

A convenience method for loading tokens from a config file.

Returns a hash with the token names suitable for passing to 
C<new()>.

Returns an empty hash if the file doesn't exist.

=cut

=head2 last_api_error_code

Get last api error_code, which return by provider. If provider reponse is
not valid JSON message, it's just the http status code.


=head2 last_api_error_subcode

Get detail error code about the api error (like 400 serial).


=head2 save_tokens <file> [token[s] hash]

    Net::SinaWeibo->save_tokens(
        consumer_token => 'xxxx',
        consumer_secret => 'xxxx',
        _request_token => 'xxxxxx',
        _request_token_secret => 'xxxxx',
        _access_token => 'xxxxx',
        _access_secret => 'xxxxx,
    )

A convenience method to save a hash of tokens out to the given file.

=cut

=head1 SinaWeibo API METHODS

Follow are generated proxy method for SinaWeibo API. 

Recent document please visit L<http://open.t.sina.com.cn/wiki/>

=head2   public_timeline

返回最新更新的20条微博消息。

    count: 每次返回的最大记录数，不能超过200，默认20.

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/public_timeline>

=head2   friends_timeline

=head2   home_timeline

返回用户所有关注用户最新n条微博信息。和用户“我的首页”返回内容相同。

    since_id: 微博信息ID. 只返回ID比since_id大（比since_id时间晚的）的微博信息内容。

    max_id: 微博信息ID. 返回ID不大于max_id的微博信息内容。

    count: 每次返回的最大记录数，不能超过200，默认20.

    page: 返回结果的页序号。注意：有分页限制。根据用户关注对象发表的数量，通常最多返回1,000条最新微博分页内容, 默认1

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/friends_timeline>

=head2  user_timeline

获取用户发布的微博信息列表

    id： 可选参数. 根据指定用户UID或微博昵称来返回微博信息。
    user_id： 可选参数. 用户UID，主要是用来区分用户UID跟微博昵称一样，产生歧义的时候，特别是在微博昵称为数字导致和用户Uid发生歧义。
    screen_name：可选参数.微博昵称，主要是用来区分用户UID跟微博昵称一样，产生歧义的时候。
    since_id：可选参数（微博信息ID）. 只返回ID比since_id大（比since_id时间晚的）的微博信息内容
    max_id: 可选参数（微博信息ID）. 返回ID不大于max_id的微博信息内容。
    count: 可选参数. 每次返回的最大记录数，最多返回200条，默认20。
    page： 可选参数. 分页返回。注意：最多返回200条分页内容。

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/user_timeline>

=head2  mentions

获取@当前用户的微博列表

    since_id. 可选参数. 返回ID比数值since_id大（比since_id时间晚的）的提到。
    max_id. 可选参数. 返回ID不大于max_id(时间不晚于max_id)的提到。
    count. 可选参数. 每次返回的最大记录数（即页面大小），不大于200，默认为20。
    page. 可选参数. 返回结果的页序号。注意：有分页限制。

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/mentions>

=head2  comments_timeline

获取当前用户发送及收到的评论列表

    since_id: 可选参数（评论ID）. 只返回ID比since_id大（比since_id时间晚的）的评论。
    max_id: 可选参数（评论ID）. 返回ID不大于max_id的评论。
    count: 可选参数. 每次返回的最大记录数，不大于200，默认20。
    page: 可选参数. 返回结果的页序号。注意：有分页限制。

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/comments_timeline>

=head2  comments_by_me

获取当前用户发出的评论

    since_id: 可选参数（评论ID）. 只返回ID比since_id大（比since_id时间晚的）的评论。
    max_id: 可选参数（评论ID）. 返回ID不大于max_id的评论。
    count: 可选参数. 每次返回的最大记录数，不大于200，默认20。
    page: 可选参数. 返回结果的页序号。注意：有分页限制。

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/comments_by_me>

=head2  comments_to_me

获取当前用户收到的评论

    since_id: 可选参数（评论ID）. 只返回ID比since_id大（比since_id时间晚的）的评论。
    max_id: 可选参数（评论ID）. 返回ID不大于max_id的评论。
    count: 可选参数. 每次返回的最大记录数，不大于200，默认20。
    page: 可选参数. 返回结果的页序号。注意：有分页限制。

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/comments_to_me>

=head2  comments

获取指定微博的评论列表

    id. 必选参数. 返回指定的微博ID
    count. 可选参数. 每次返回的最大记录数（即页面大小），不大于200，默认为20。
    page. 可选参数. 返回结果的页序号

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/comments>

=head2  status_counts

批量获取一组微博的评论数及转发数,一次请求最多获取100个。

    ids. 必填参数. 微博ID号列表，用逗号隔开

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/counts>

=head2  status_unread

获取当前用户未读消息数

    with_new_status 可选参数，默认为0。1表示结果包含是否有新微博，0表示结果不包含是否有新微博。
    since_id 可选参数 参数值为微博id，返回此条id之后，是否有新微博产生，有返回1，没有返回0

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/unread>


=head2  status_reset_count

未读消息数清零接口

    type 需要清零的计数类别，值为下列四个之一：1--评论数，2--@数，3--私信数，4--关注我的数。

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/reset_count>

=head2  emotions

表情接口，获取表情列表

    type：表情类别，可选参数，"face":普通表情，"ani"：魔法表情，"cartoon"：动漫表情；默认为"face"
    language：语言类别，可选参数，"cnname"简体，"twname"繁体；默认为"cnname"

L<http://open.t.sina.com.cn/wiki/index.php/Emotions>

=head2  show_status

根据ID获取单条微博信息内容

    id. 必须参数(微博信息ID)，要获取已发表的微博ID,如ID不存在返回空

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/show>

=head2 status_url($user_id,$status_id)

返回根据微博ID和用户ID生成的单条微博页面url

=head2  post_status

发布一条微博信息

    status. 必填参数， 要更新的微博信息。必须做URLEncode,信息内容不超过140个汉字,为空返回400错误。
    in_reply_to_status_id. 可选参数，@ 需要回复的微博信息ID, 这个参数只有在微博内容以 @username 开头才有意义。（即将推出）。
    lat. 可选参数，纬度，发表当前微博所在的地理位置，有效范围 -90.0到+90.0, +表示北纬。只有用户设置中geo_enabled=true时候地理位置才有效。(仅对受邀请的合作开发者开放)
    long. 可选参数，经度。有效范围-180.0到+180.0, +表示东经。(仅对受邀请的合作开发者开放)

如果没有登录或超过发布上限，将返回403错误.
如果in_reply_to_status_id不存在，将返回500错误.
系统将忽略重复发布的信息。每次发布将比较最后一条发布消息，如果一样将被忽略。因此用户不能连续提交相同信息。

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/update>

=head2  upload_status

上传图片并发布一条微博信息

    status. 必填参数， 要更新的微博信息。必须做URLEncode,信息内容不超过140个汉字。支持全角、半角字符。
    pic. 必填参数。仅支持JPEG,GIF,PNG图片,为空返回400错误。目前上传图片大小限制为<1M。
    lat. 可选参数，纬度，发表当前微博所在的地理位置，有效范围 -90.0到+90.0, +表示北纬。只有用户设置中geo_enabled=true时候地理位置才有效。(保留字段，暂不支持)
    long. 可选参数，经度。有效范围-180.0到+180.0, +表示东经。(保留字段，暂不支持)

如果使用的Oauth认证，图片参数pic不参与签名。

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/upload>

=head2  remove_status

删除一条微博信息

    id. 必须参数. 要删除的微博ID.

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/destroy>

=head2  retweet
=head2  repost_status

转发一条微博信息（可加评论）

    id 必填参数， 转发的微博ID
    status. 可选参数， 添加的转发信息。必须做URLEncode,信息内容不超过140个汉字。如不填则自动生成类似“转发 @author: 原内容”文字。

如果没有登录，将返回403错误.
转发的微博不存在，将返回500错误.
L<http://open.t.sina.com.cn/wiki/index.php/Statuses/repost>.

=head2  post_comment

对一条微博信息进行评论

    id 必填参数， 要评论的微博id
    comment. 必填参数， 评论内容。必须做URLEncode,信息内容不超过140个汉字。

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/comment>

=head2  remove_comment

删除当前用户的微博评论信息

    id. 必须参数. 要删除的评论ID.

如果评论不存在，将返回403错误.

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/comment_destroy>

=head2  batch_remove_comments

批量删除当前用户的微博评论信息

    ids 必选参数，想要删除评论的id，多个id之间用半角逗号分割，支持最多20个。

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/comment/destroy_batch>

=head2  reply_comment

回复微博评论信息

    id 必填参数， 要评论的微博id
    cid 必填参数， 要评论的评论id 如没有或非法则为对微博的评论
    comment. 必填参数， 评论内容。必须做URLEncode,信息内容不超过140个汉字

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/reply>

=head2  hot_users

获取系统推荐用户

    category: 分类，可选参数，返回某一类别的推荐用户，默认为 default。如果不在一下分类中，返回空列表：

        default:人气关注
        ent:影视名星
        hk_famous:港台名人
        model:模特
        cooking:美食&健康
        sport:体育名人
        finance:商界名人
        tech:IT互联网
        singer:歌手
        writer：作家
        moderator:主持人
        medium:媒体总编
        stockplayer:炒股高手

L<http://open.t.sina.com.cn/wiki/index.php/Users/hot>

=head2  show_user

根据用户ID获取用户资料（授权用户）

    id. 用户UID或微博昵称。
    user_id. 指定用户UID,主要是用来区分用户UID跟微博昵称一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义
    screen_name. 指定微博昵称，主要是用来区分用户UID跟微博昵称一样，产生歧义的时候。

ID或者昵称不存在返回400错误.

L<http://open.t.sina.com.cn/wiki/index.php/Users/show>

=head2  friends

获取当前用户关注对象列表及最新一条微博信息

    id. 用户UID或微博昵称。
    user_id. 指定用户UID,主要是用来区分用户UID跟微博昵称一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义
    screen_name. 指定微博昵称，主要是用来区分用户UID跟微博昵称一样，产生歧义的时候。
    cursor. 选填参数. 单页只能包含100个关注列表，为了获取更多则cursor默认从-1开始，通过增加或减少cursor来获取更多, 如果没有下一页，则next_cursor返回0
    count. 可选参数. 每次返回的最大记录数（即页面大小），不大于200,默认返回20。

如果没有提供cursor参数，将只返回最前面的100个关注列表。当以Json方式返回时，返回结构会稍有不同。

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/friends>

=head2  followers

获取当前用户粉丝列表及最新一条微博信息

    id. 用户UID或微博昵称。
    user_id. 指定用户UID,主要是用来区分用户UID跟微博昵称一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义
    screen_name. 指定微博昵称，主要是用来区分用户UID跟微博昵称一样，产生歧义的时候。
    cursor. 选填参数. 单页只能包含100个关注列表，为了获取更多则cursor默认从-1开始，通过增加或减少cursor来获取更多, 如果没有下一页，则next_cursor返回0
    count. 可选参数. 每次返回的最大记录数（即页面大小），不大于200,默认返回20。

如果没有提供cursor参数，将只返回最前面的100个列表.

L<http://open.t.sina.com.cn/wiki/index.php/Statuses/followers>

=head2  dm

获取当前用户最新私信列表

    since_id. 可选参数. 返回ID比数值since_id大（比since_id时间晚的）的私信。
    max_id. 可选参数. 返回ID不大于max_id(时间不晚于max_id)的私信。
    count. 可选参数. 每次返回的最大记录数（即页面大小），不大于200。
    page. 可选参数. 返回结果的页序号。注意：有分页限制。


L<http://open.t.sina.com.cn/wiki/index.php/Direct_messages>

=head2  dm_sent

获取当前用户发送的最新私信列表

    since_id. 可选参数. 返回ID比数值since_id大（比since_id时间晚的）的私信。
    max_id. 可选参数. 返回ID不大于max_id(时间不晚于max_id)的私信。
    count. 可选参数. 每次返回的最大记录数（即页面大小），不大于200。
    page. 可选参数. 返回结果的页序号。注意：有分页限制。

L<http://open.t.sina.com.cn/wiki/index.php/Direct_messages/sent>

=head2  send_dm

发送一条私信

    id: 必须参数. UID或微博昵称. 为了支持数字的微博昵称，需选填写下面2个参数screen_name或user_id:
    screen_name: 微博昵称
    user_id: 新浪UID
    text: 必须参数. 要发生的消息内容，需要做URLEncode，文本大小必须小于300个汉字.

L<http://open.t.sina.com.cn/wiki/index.php/Direct_messages/new>

=head2  remove_dm

删除一条私信

    id. 必填参数，要删除的私信主键ID.

L<http://open.t.sina.com.cn/wiki/index.php/Direct_messages/destroy>


=head2  batch_remove_dm

批量删除私信

    ids 必选参数，想要删除私信的id，多个id之间用半角逗号分割，支持最多20个。

L<http://open.t.sina.com.cn/wiki/index.php/Direct_messages/destroy_batch>

=head2  follow

关注某用户

    id: 要关注的用户UID或微博昵称
    user_id: 要关注的用户UID,主要是用在区分用户UID跟微博昵称一样，产生歧义的时候。
    screen_name: 要关注的微博昵称,主要是用在区分用户UID跟微博昵称一样，产生歧义的时候。


目前的最多关注2000人，失败则返回一条字符串的说明。如果已经关注了此人，则返回http 403的状态。关注不存在的ID将返回400。

L<http://open.t.sina.com.cn/wiki/index.php/Friendships/create>

=head2  unfollow

取消关注.成功则返回被取消关注人的资料，失败则返回一条字符串的说明。

    id. 必填参数. 要取消关注的用户UID或微博昵称
    user_id. 必填参数. 要取消关注的用户UID,主要是用在区分用户UID跟微博昵称一样，产生歧义的时候。
    screen_name. 必填参数. 要取消的微博昵称,主要是用在区分用户UID跟微博昵称一样，产生歧义的时候。

L<http://open.t.sina.com.cn/wiki/index.php/Friendships/destroy>

=head2  is_followed

获取两个用户关系的详细情况

以下参数可不填写，如不填，则取当前用户

    source_id. 源用户UID
    source_screen_name. 源微博昵称

下面参数必须选填一个:

    target_id. 要判断的目的用户UID
    target_screen_name. 要判断的目的微博昵称

如果源用户或目的用户不存在，将返回http的400错误.
返回的blocking表示source_id用户是否对target_id加黑名单，只对source_id是当前用户有效，即只能看到自己的阻止设置(blocking协议暂不支持返回)

L<http://open.t.sina.com.cn/wiki/index.php/Friendships/show>

=head2  get_friends_id_list

获取用户关注对象uid列表

    id. 用户UID或微博昵称。
    user_id. 指定用户UID,主要是用来区分用户UID跟微博昵称一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义
    screen_name. 指定微博昵称，主要是用来区分用户UID跟微博昵称一样，产生歧义的时候。
    cursor. 选填参数. 单页只能包含100个关注列表，为了获取更多则cursor默认从-1开始，通过增加或减少cursor来获取更多, 如果没有下一页，则next_cursor返回0
    count. 可选参数. 每次返回的最大记录数（即页面大小），不大于200,默认返回20。

如果没有提供cursor参数，将只返回最前面的5000个关注id

L<http://open.t.sina.com.cn/wiki/index.php/Friends/ids>

=head2  get_followers_id_list

获取用户粉丝对象uid列表

    id. 用户UID或微博昵称。
    user_id. 指定用户UID,主要是用来区分用户UID跟微博昵称一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义
    screen_name. 指定微博昵称，主要是用来区分用户UID跟微博昵称一样，产生歧义的时候。
    cursor. 选填参数. 单页只能包含100个关注列表，为了获取更多则cursor默认从-1开始，通过增加或减少cursor来获取更多, 如果没有下一页，则next_cursor返回0
    count. 可选参数. 每次返回的最大记录数（即页面大小），不大于200,默认返回20。

如果没有提供cursor参数，将只返回最前面的5000个粉丝id

L<http://open.t.sina.com.cn/wiki/index.php/Followers/ids>


=head2  update_privacy

设置隐私信息

    comment: 谁可以评论此账号的微薄。 0：所有人 1：我关注的人 默认为0
    message:谁可以给此账号发私信。0：所有人 1：我关注的人 默认为1
    realname 是否允许别人通过真实姓名搜索到我，值---0允许，1不允许，默认值1
    geo 发布微博，是否允许微博保存并显示所处的地理位置信息。值—0允许，1不允许，默认值0
    badge 勋章展现状态，值—1私密状态，0公开状态，默认值0

L<http://open.t.sina.com.cn/wiki/index.php/Account/update_privacy>

=head2  get_privacy

获取隐私信息

L<http://open.t.sina.com.cn/wiki/index.php/Account/get_privacy>


=head2  block_user

将某用户加入黑名单

必选参数（至少选一个）:

    user_id：要加入黑名单的用户ID。
    screen_name：要加入黑名单的用户微博昵称，可选。

user_id或screen_name若不存在返回400

L<http://open.t.sina.com.cn/wiki/index.php/Blocks/create>


=head2  unblock_user

将某用户移出黑名单

必选参数（至少选一个）:

    user_id：要删除黑名单的用户ID
    screen_name：要删除黑名单的用户昵称

L<http://open.t.sina.com.cn/wiki/index.php/Blocks/destroy>


=head2  is_blocked

某用户是否是黑名单用户

必选参数（至少选一个）:

    user_id：要检查的用户ID
    screen_name：要检查的用户昵称

L<http://open.t.sina.com.cn/wiki/index.php/Blocks/exists>

=head2  blocking

列出黑名单用户(输出用户详细信息)

    page. 页码，可选。.
    count. 一页大小，可选。.

L<http://open.t.sina.com.cn/wiki/index.php/Blocks/blocking>

=head2  blocking_id_list

列出分页黑名单用户（只输出id）

    page. 页码，可选。.
    count. 一页大小，可选。.

L<http://open.t.sina.com.cn/wiki/index.php/Blocks/blocking/ids>

=head2  tags

返回指定用户的标签列表

    user_id: 必填参数，查询用户的ID
    count: 可选参数. 每次返回的最大记录数（即页面大小），不大于200，默认为20。
    page: 可选参数. 返回结果的页序号。注意：有分页限制。

L<http://open.t.sina.com.cn/wiki/index.php/Tags>

=head2  add_tag

添加用户标签

    tags: 标签，必填参数，多个标签之间用逗号间隔

L<http://open.t.sina.com.cn/wiki/index.php/Tags/create>

=head2  tag_suggestions

返回用户感兴趣的标签

    page: 可选参数，页码，默认为1
    count: 可选参数，分页大小，默认为10

L<http://open.t.sina.com.cn/wiki/index.php/Tags/suggestions>


=head2  remove_tag

删除标签

    tag_id：标签ID，必填参数

L<http://open.t.sina.com.cn/wiki/index.php/Tags/destroy>

=head2  batch_remove_tags

批量删除标签

    ids：必选参数，要删除的tag id，多个id用半角逗号分割，最多20个。

L<http://open.t.sina.com.cn/wiki/index.php/Tags/destroy_batch>


=head2  verify_credentials

验证当前用户身份是否合法.

如果用户新浪通行证身份验证成功且用户已经开通微博则返回 http状态为 200；如果是不则返回401的状态和错误信息。此方法用了判断用户身份是否合法且已经开通微博。

L<http://open.t.sina.com.cn/wiki/index.php/Account/verify_credentials>


=head2  rate_limit_status

获取当前用户API访问频率限制

L<http://open.t.sina.com.cn/wiki/index.php/Account/rate_limit_status>


=head2  end_session

当前用户退出登录.清除已验证用户的session，退出登录，并将cookie设为null。主要用于widget等web应用场合。

L<http://open.t.sina.com.cn/wiki/index.php/Account/end_session>


=head2  update_profile

更改资料.

必须有一下参数中的一个或多个，参数值为字符串. 进一步的限制，请参阅下面的各个参数描述.

    name. 昵称，可选参数.不超过20个汉字
    gender 性别，可选参数. m,男，f,女。
    province 可选参数. 参考省份城市编码表
    city 可选参数. 参考省份城市编码表,1000为不限
    description. 可选参数. 不超过160个汉字.


L<http://open.t.sina.com.cn/wiki/index.php/Account/update_profile>

=head2 update_profile_image

更新用户头像

image.必须参数. 必须为小于700K的有效的GIF, JPG, 或 PNG 图片. 如果图片大于500像素将按比例缩放。

L<http://open.t.sina.com.cn/wiki/index.php/Account/update_profile_image>

=head2  favorites

获取当前用户的收藏列表

    page： 可选参数. 返回结果的页序号。注意：有分页限制。

L<http://open.t.sina.com.cn/wiki/index.php/Favorites>

=head2  add_favorite

添加收藏.

    id 必填参数， 要收藏的微博id

L<http://open.t.sina.com.cn/wiki/index.php/Favorites/create>

=head2  remove_favorite

删除当前用户收藏的微博信息

    id. 必须参数. 要删除的收藏微博信息ID.

L<http://open.t.sina.com.cn/wiki/index.php/Favorites/destroy>

=head2  batch_remove_favorites

批量删除收藏的微博信息

    ids 必选参数，想要删除收藏微博的id，多个id之间用半角逗号分割，支持最多20个。

L<http://open.t.sina.com.cn/wiki/index.php/Favorites/destroy_batch>


=head1 DEVELOPERS

The latest code for this module can be found at

L<http://github.com/nightsailer/net-sinaweibo.git>

Author blog: (Chinese)

L<http://nightsailer.com/>


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::SinaWeibo

You can also look for information at:

=over

=item Issues tracker: 

L<http://github.com/nightsailer/net-sinaweibo/issues>

=back

=head1 SEE ALSO

=over

=item SinaWeibo Developer Site

L<http://open.t.sina.com.cn/wiki/>

=item OAuth L<http://oauth.net/>

=item L<OAuth::Lite>

=item L<Net::OAuth>

=back