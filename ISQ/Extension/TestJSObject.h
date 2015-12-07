//
//  TestJSObject.h
//  TestJSOC
//
//  Created by Mac_SSD on 15/11/17.
//  Copyright © 2015年 Mac_SSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

//创建一个实现了JSExport协议的协议
@protocol TestJSObjectProtocol <JSExport>

-(void)passShareParams:(NSString *)str;
@end

//协议
@interface TestJSObject : NSObject<TestJSObjectProtocol>

@end
