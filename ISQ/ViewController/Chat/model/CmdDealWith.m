//
//  CmdDealWith.m
//  ISQ
//
//  Created by mac on 15-7-17.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "CmdDealWith.h"

@implementation CmdDealWith


+(void)cmdToDealWith:(NSString *)action:(NSString*)to_id{
    

    
    
    EMChatCommand *cmdChat = [[EMChatCommand alloc] init];
    cmdChat.cmd = action;
    EMCommandMessageBody *body = [[EMCommandMessageBody alloc] initWithChatObject:cmdChat];
    EMMessage *message  = [[EMMessage alloc] initWithReceiver:to_id bodies:@[body]];
    
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    
    NSDictionary *jsonStr=@{@"avatar":[user_info objectForKey:MYSELFHEADNAME],@"hxid":[user_info objectForKey:userAccount],@"nick":[user_info objectForKey:userNickname],@"action":action};
    
    message.ext=@{@"content":jsonStr};
    //        message.messageType = eConversationTypeGroupChat;// 设置为群聊消息
    //        message.messageType = eConversationTypeChatRoom;// 设置为聊天室消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];

}

+(void)cmdToDealWithGroup:(NSString *)action:(NSDictionary*)dic:(NSString*)groupOwner{
    
    NSMutableDictionary *jsonStr=[[NSMutableDictionary alloc]init];

    
    
    EMChatCommand *cmdChat = [[EMChatCommand alloc] init];
    cmdChat.cmd = action;
    EMCommandMessageBody *body = [[EMCommandMessageBody alloc] initWithChatObject:cmdChat];
    EMMessage *message  = [[EMMessage alloc] initWithReceiver:groupOwner bodies:@[body]];
    
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    
//    NSDictionary *jsonStr=@{@"avatar":[user_info objectForKey:MYSELFHEADNAME],@"hxid":[user_info objectForKey:userAccount],@"nick":[user_info objectForKey:userNickname],@"action":action};
    
    [jsonStr addEntriesFromDictionary:@{@"avatar":[user_info objectForKey:MYSELFHEADNAME],@"hxid":[user_info objectForKey:userAccount],@"nick":[user_info objectForKey:userNickname]}];
    [jsonStr addEntriesFromDictionary:dic];
    
    message.ext=@{@"content":jsonStr,@"groupId":dic[@"groupId"]};
//    //        message.messageType = eConversationTypeGroupChat;// 设置为群聊消息
//    //        message.messageType = eConversationTypeChatRoom;// 设置为聊天室消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];

    
}



@end
