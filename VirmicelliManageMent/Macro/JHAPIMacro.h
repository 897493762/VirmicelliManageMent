//
//  JHAPIMacro.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/4.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#ifndef JHAPIMacro_h
#define JHAPIMacro_h
#define BaseURLStr(urlStr)  [@"https://i.instagram.com/api/v1/" stringByAppendingString:urlStr]
//#define KCheckSmsCode           @"https://api.zgtjtt.com/api/message/checkSmsCode"
#define KUserLogin             BaseURLStr(@"accounts/login/")
#define KUserInfo(pk)          [NSString stringWithFormat:@"https://i.instagram.com/api/v1/users/%@/info/",pk]
#define KUserNameInfo(pk)          [NSString stringWithFormat:@"https://i.instagram.com/api/v1/users/%@/usernameinfo/",pk]

#define KFollowers(pk)          [NSString stringWithFormat:@"https://i.instagram.com/api/v1/friendships/%@/followers/?",pk]  //关注我

#define KFollowing(pk)          [NSString stringWithFormat:@"https://i.instagram.com/api/v1/friendships/%@/following/?",pk]  //我关注
#define KFeeduser(pk)          [NSString stringWithFormat:@"https://i.instagram.com/api/v1/feed/user/%@/?",pk]  //用户发的照片
#define KfeedLiked          BaseURLStr(@"feed/liked/?")  //获取我点赞的media
#define KMediaLikers(pk)          [NSString stringWithFormat:@"https://i.instagram.com/api/v1/media/%@/likers/?",pk]  //获取为media点赞的人
#define KMediaComments(pk)          [NSString stringWithFormat:@"https://i.instagram.com/api/v1/media/%@/comments/",pk]  //评论
#define KBlockedList             BaseURLStr(@"users/blocked_list/")  //我屏蔽了谁
#define KDiscoverAyml             BaseURLStr(@"discover/ayml/")  //推荐用户
#define KFbsearchPlaces             BaseURLStr(@"fbsearch/places/?")  //获取用户pk
#define KFbsearchLocation(pk)        [NSString stringWithFormat:@"https://i.instagram.com/api/v1/feed/location/%@/",pk]// 附近用户
#define KCreatFllow(pk)        [NSString stringWithFormat:@"https://i.instagram.com/api/v1/friendships/create/%ld/",pk]// 关注
#define KDestroyFloow(pk)      [NSString stringWithFormat:@"https://i.instagram.com/api/v1/friendships/destroy/%ld/",pk]// 取消关注
//#define KUsersearch             BaseURLStr(@"users/search?")  //搜索用户


#define KUsersearch             BaseURLStr(@"users/search?")  //搜索用户
#define KSearchUser(query)         [BaseURLStr(@"users/search?ig_sig_key_version=4") stringByAppendingString:[NSString stringWithFormat:@"&rank_token=%@&is_typeahead =true&query=%@",KRank_token,query]]   //搜索用户
#define KSearchTag(query)         [BaseURLStr(@"tags/search?") stringByAppendingString:[NSString stringWithFormat:@"&q=%@",query]]   //搜索tag
#define KSearchTagDetail(name)         [BaseURLStr(@"feed/tag/") stringByAppendingString:[NSString stringWithFormat:@"%@?rank_token=%@",name,KRank_token]]   //tag详情

#define KUserReels            BaseURLStr(@"feed/reels_tray/?")  //全部关注的帖子列表
#define KUserTimeline(pk)         [BaseURLStr(@"feed/timeline/?") stringByAppendingString:[NSString stringWithFormat:@"rank_token=%@&ranked_content=true",pk]]   //获取用户时间线
#define KUserDiscover            BaseURLStr(@"discover/explore/")  //搜索带有标签的帖子
#define KFeedsaved          BaseURLStr(@"feed/saved/?")  //;//收藏的图片
#define KMediaLike(pk)         [BaseURLStr(@"media/") stringByAppendingString:[NSString stringWithFormat:@"%@/like/",pk]]   //点赞
#define KMediaUnlike(pk)         [BaseURLStr(@"media/") stringByAppendingString:[NSString stringWithFormat:@"%@/unlike/",pk]]   //取消点赞
#define KMediasave(pk)         [BaseURLStr(@"media/") stringByAppendingString:[NSString stringWithFormat:@"%@/save/",pk]]   //收藏
#define KMediaUnsave(pk)         [BaseURLStr(@"media/") stringByAppendingString:[NSString stringWithFormat:@"%@/unsave/",pk]]   //取消收藏
#define KUserStory(pk)         [BaseURLStr(@"feed/user/") stringByAppendingString:[NSString stringWithFormat:@"%@/story/",pk]]   //获取用户故事列表
#define KUserShow(pk)         [BaseURLStr(@"friendships/show/") stringByAppendingString:[NSString stringWithFormat:@"%@/",pk]]   //用户的好友关系
#define KFeedtag(name)         [BaseURLStr(@"feed/tag/") stringByAppendingString:[NSString stringWithFormat:@"%@/?rank_token=%@",name,KRank_token]] //通过tag获取用户发的照片
#define KMediaInfo(pk)         [BaseURLStr(@"media/") stringByAppendingString:[NSString stringWithFormat:@"%@/info/",pk]]   //帖子详情

#endif /* JHAPIMacro_h */
