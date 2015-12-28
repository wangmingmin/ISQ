//
//  ConstantFileld.h
//  ISQ
//
//  Created by mac on 15-3-12.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#ifndef ISQ_ConstantFileld_h
#define ISQ_ConstantFileld_h

#define UISCREENWIDTH  [UIApplication sharedApplication].keyWindow.frame.size.width//屏幕的宽度
#define UISCREENHEIGHT  [UIApplication sharedApplication].keyWindow.frame.size.height//屏幕的高度

#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue] //系统版本

#define BAIDUMAPKEY @"CLSf3H2zHic6Og0ljnTW0G6f"   //百度key 个人fCNjVFDlVp19AaZp9mUDhYYC  企业CLSf3H2zHic6Og0ljnTW0G6f
#define BAIDUIPLOCATIONKEY @"OLfGqbwREfteiCnKNoNkwDAj" //百度web-Kye
#define BAIDUIPLOCATIONURL @"http://api.map.baidu.com/location/ip"//百度IP定位

//本地》社区webview URL
#define sqWebViewURL @"http://dt.app.ai-shequ.cn:81/index.php?s=/Home/Aishequ/index/"
#define hornDetailURL @"http://dt.app.ai-shequ.cn:81/index.php?s=/Home/Aishequ/detail/"
#define shDetailURL @"http://dt.app.ai-shequ.cn:81/index.php?s=/Home/Business/business/"
#define MYROOMNUMBER @"http://dt.app.ai-shequ.cn:81/Home/Wuye/getUserWuye/ajax/"
#define CHOOSEMYROOM @"http://dt.app.ai-shequ.cn:81/Home/Wuye/setUserWuye/id/"
#define LOCATIONPROOPERTY @"http://dt.app.ai-shequ.cn:81/index.php?s=/Home/Property/property"
#define HOMETOPROPERTY @"http://dt.app.ai-shequ.cn:81/index.php?s=/Home/Property/login/uid/"

//app store中查询app
#define APP_URL @"http:itunes.apple.com/lookup?id=1022692110"

//用户
#define requestTheCodeURL @"http://web.app.wisq.cn:8080/json/user/"
//图片上传
#define upLoadMyImg @"http://web.app.wisq.cn:8080/servlet/upload"

//首页轮播图
#define getHomePic @"http://121.41.18.126:8080/isqbms/getHomePic.from"
//书记信箱
#define MESSAGEURL @"http://web.app.wisq.cn:8080/json/message/postmessage"

//获取信箱记录
#define getMessage  @"http://web.app.wisq.cn:8080/json/message/getmessage"

//定位到的社区信息请求
#define communityURL @"http://web.app.wisq.cn:8080/json/user/getcommunitygis"
//广告在没有外链的情况下显示的内容
#define WhenNoUrlAd @"http://dt.app.ai-shequ.cn:81/Home/Href/index/"


//用户信息存储字段
#define userAccount @"userAccount"   //电话
#define userPassword @"userPassword"   //密码
#define userNickname @"userNickname"//昵称
#define userGender @"userGender"//性别
#define userIntro @"userIntro"//签名
#define userCommunityID @"communityId"//社区id
#define userIsqCode @"userIsqCode"//社区号
#define userCityID @"cityId" //城市ID
#define MyUserID @"userId"//用户ID
#define MYHEADIMGURL @"http://web.app.wisq.cn:8080/avatar/"   
#define MYSELFHEADNAME @"MYSELFHEADNAME" //头像的地址

#define saveCommunityName @"saveCommunityName" //选择社区后保存名称
#define userCityName @"userCityName"//城市名
#define userCity_province @"userCity_province" //省份与城市
#define  alertcomment  @"http://web.app.wisq.cn:8080/json/hx/alertcomment"   //修改备注

#define AliasTypeForUM @"cn.aishequ.isq1" //友盟的别名类别
//图片url
#define theImgURL @"http://admin.app.ai-shequ.cn:81" //图片URL

//广告web url
#define theAdURL @"http://admin.app.ai-shequ.cn:81" //广告web url

//房产
#define realEstateURL @"http://m.fang.com/esf/wuhan/?cstype=ds&utm_source=hezuomwuhan&utm_medium=click&utm_term=glhwuhan&utm_content=asq&utm_campaign=20150510app"
//是百步亭社区的适合，获取找书记获取居委会数据
#define getJuweihuiList  @"http://121.41.18.126:8080/isqbms/getJuweihuiList.from"

//首页h5
#define RestaurantURL  @"http://webapp.wisq.cn/Restaurant/lists/location/" //美食
#define housekeepingURL  @"http://webapp.wisq.cn/Housekeeping/lists/"  //家政
#define MedicalURL  @"http://webapp.wisq.cn/Medical/lists/location/"  //医疗
#define tenementURL   @"http://webapp.wisq.cn/Yetopen"   //物业
#define discuss   @"http://webapp.wisq.cn/talk/"    //议事厅
#define officeURL  @"http://webapp.wisq.cn/office/lists/location/"  //居委会
#define communityNewThing @"http://webapp.wisq.cn/Communitynews/lists/cid/" //新鲜事

//设置>开关状态保存
#define notify_switch @"message_notify_switch"
#define Sound_switch @"theSound_switch"
#define Shating_switch @"theShating_switch"
#define detail_switch @"push_detail_switch"


//商户加盟电话
#define BUSINESSADDPHONE @"4009915247"

//IM 数据
//IM 好友及自身数据
#define IMFRIENDSDATA @"http://web.app.wisq.cn:8080/json/hx/hxlogin"
#define IMCACHEDATA @"IMCACHEDATA" //用于im数据缓存的字段
#define SEARCHFRIENDSURL @"http://web.app.wisq.cn:8080/json/hx/hxfriends" //定向搜索好友
#define IMGROUPIMG @"http://avatar.app.wisq.cn/group/" //群组头像
#define FINDNEIGBOR @"http://web.app.wisq.cn:8080/json/hx/getcu" //找邻居
#define ACCEPTFRIENDS @"http://web.app.wisq.cn:8080/json/hx/accept" //添加好友
#define FINDFRIENDS @"http://web.app.wisq.cn:8080/json/hx/vtf" //找朋友
#define FINDFRIENDSMESSAGE @"http://web.app.wisq.cn:8080/json/hx/sendm" //找朋友中的邀请短信
#define DELETEFRIEND @"http://web.app.wisq.cn:8080/json/hx/delf" //删除好友
//透传消息的action
#define CMD_ACTION_NOTICE_ADD @"add_friends"
#define CMD_ACTION_NOTICE_AGREE @"agree_friends"
#define CMD_ACTION_NOTICE_REFUSE @"refuse_friends"
#define CMD_ACTION_NOTICE_GROUP_JOIN @"group_join"               //加入
#define CMD_ACTION_NOTICE_GROUP_REQUEST @"group_request"        //请求加入
#define CMD_ACTION_NOTICE_GROUP_INVITATION @"group_invitation" //邀请加入
#define CMD_ACTION_NOTICE_GROUP_AGREE @"group_agree"          //同意
#define CMD_ACTION_NOTICE_GROUP_REFUSE @"group_refuse"        //拒绝
#define CMD_ACTION_NOTICE_GROUP_EXIT @"group_exit"           //退出

//NSNotificationCenter
#define AGREEINVITATIONFRIEND @"agreeInvitationFriend" //同意成为好友
#define UPDATEAPPLYCOUNT @"updateApplyCount" //刷新未读消息

/******************************重置密码*****************************/

/**
 *获取验证码
 */
#define getCode  @"http://web.app.wisq.cn:8080/json/user/getvcode"

/**
 *忘记密码
 */
#define forgetPassWord  @"http://web.app.wisq.cn:8080/json/user/apwd"

/**
 *修改密码
 */
#define changePassWord  @"http://web.app.wisq.cn:8080/json/user/changepwd"



/****************************活动模块*********************************/
/**
 *热门列表
 */
#define getHotList @"http://121.41.18.126:8080/isqbms/getSpecialList.from"

/**
 *附近列表
 */
#define getNearActiveList @"http://121.41.18.126:8080/isqbms/getNearActiveList.from"

/**
 *  上传活动
 */
#define START_ACTIVITY_HTTP @"http://121.41.18.126:8080/isqbms/addnearvideo.from"
/**
 *  用户评论热门活动
 */
#define USER_COMMENT_HOT_ACTIVITY @"http://121.41.18.126:8080/isqi bms/submitcomment.from"

/**
 *  热门活动详情页
 */
#define HOT_ACTIVITY_DETAIL @"http://121.41.18.126:8080/isqbms/getHotActiveDetail.from"

/**
 *  用户热门视频投票
 */
#define USER_HOT_VOTE @"http://121.40.65.121:8080/isqbms/uservideovote.from"

/**
 *  收藏活动接口
 */
#define ACTIVITY_COLLECTION @"http://121.41.18.126:8080/isqbms/addCollect.from"
/**
 *  附近活动详情
 */
#define NEAR_ACTIVITY_DEITALE @"http://121.41.18.126:8080/isqbms/getNearActiveDetail.from"
/**
 *  附近评论接口
 */
#define NEAR_COMMENT @"http://121.41.18.126:8080/isqbms/dueNearComment.from"

/**
 *  附近上传视频回调接口
 */
#define CC_TO_ISQ_SERVER @"http://121.41.18.126:8080/isqbms/getnearnotify.from"

/**
 *参与附近活动
 */
#define joininNearActive @"http://121.41.18.126:8080/isqbms/joininNearActive.from"

/**
 *我参与的活动
 */
#define getMyJoininActive @"http://121.41.18.126:8080/isqbms/getMyJoininActive.from"

/**
 *附近点赞
 */
#define activityClickz @"http://121.41.18.126:8080/isqbms/likeNearActive.from"

/**
 *附近取消点赞
 */
#define cancelActivityClickz @"http://121.41.18.126:8080/isqbms/cancelLikeNearActive.from"

/**
 *我发起的活动
 */
#define getLaunchActive  @"http://121.41.18.126:8080/isqbms/getLaunchActive.from"


/**
 *春晚展播
 */
#define getSpringVideoListServer @"http://121.41.18.126:8080/isqbms/getSpringVideoList.from?"
/**
 *春晚详情
 */
#define httpDetailServer @"http://121.41.18.126:8080/isqbms/getSpringVideoDetail.from?"

/**
 *春晚视频关注
 */
#define followVideoServer @"http://121.41.18.126:8080/isqbms/followSpringVideo.from?"
/**
 *春晚视频取消关注
 */
#define noFollowVideoServer @"http://121.41.18.126:8080/isqbms/noFollowSpringVideo.from?"

/**
 *获取所有省列表
 */
#define getAllProvince @"http://121.41.18.126:8080/isqbms/getAllProvince.from"
/**
 *获取所有城市列表（所选省）
 */
#define getCityByPid @"http://121.41.18.126:8080/isqbms/getCityByPid.from?"
/**
 *获取展播视屏（所选城市）
 */
#define getSpringVideoByPidOrCid @"http://121.41.18.126:8080/isqbms/getSpringVideoByPidOrCid.from"


#define user_info [NSUserDefaults standardUserDefaults]

#endif
