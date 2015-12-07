//
//  GetVcard.m
//  ISQ
//
//  Created by mac on 15-5-22.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "GetVcard.h"
#import "pinyin.h"
@implementation GetVcard{
    
    NSMutableDictionary*index;

    NSArray *Frindsdata;
    NSString *vcard;
}


#pragma mark 获取通讯录内容
-(NSMutableDictionary*)getPersonInfo{
    //    str=str.Replace("abc","ABC");
    //建立一个字典，字典保存key是A-Z  值是数组
    index=[NSMutableDictionary dictionaryWithCapacity:0];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArrayDic = [NSMutableArray arrayWithCapacity:0];
    //取得本地通信录名柄
    ABAddressBookRef addressBook ;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)                                                 {
            
            dispatch_semaphore_signal(sema);
            
        });
        
    }else{
        
        
        addressBook = ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        
    }
    
    //取得本地所有联系人记录
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    if (results) {
        
        for(int i = 0; i < CFArrayGetCount(results); i++)
        {
            NSMutableDictionary *dicInfoLocal = [NSMutableDictionary dictionaryWithCapacity:0];
            ABRecordRef person = CFArrayGetValueAtIndex(results, i);
            //读取firstname
            NSString *first = (NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            if (first==nil) {
                first = @"";
            }
            
            
            NSString *last = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            if (last == nil) {
                last = @"";
            }
           
            ABMultiValueRef tmlphone =  ABRecordCopyValue(person, kABPersonPhoneProperty);
            NSString* telphone = (NSString*)ABMultiValueCopyValueAtIndex(tmlphone, 0);
            NSArray *special=@[@"-",@"(",@")",@"*",@"#",@";",@",",@"+",@"+86",@" ",@"()",@"[",@"]",@"'",@"\"",@"\\",@"/",@" ",@"."];
            
            NSString *strUrl=telphone;
            for (NSString *str  in special) {
                
                strUrl = [strUrl stringByReplacingOccurrencesOfString:str withString:@""];
                
            }
            
            if (strUrl == nil) {
                strUrl = @"00";
            }
            
                [dicInfoLocal setObject:last forKey:@"last"];
                [dicInfoLocal setObject:first forKey:@"first"];
                [dicInfoLocal setObject:strUrl forKey:@"telphone"];
            
            
            
            CFRelease(tmlphone);
            /*
             //获取的联系人单一属性:Email(s)
             
             ABMultiValueRef tmpEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
             
             NSString *email = (NSString*)ABMultiValueCopyValueAtIndex(tmpEmails, 0);
             [dicInfoLocal setObject:email forKey:@"email"];
             
             CFRelease(tmpEmails);
             if (email) {
             email = @"";
             }
             [dicInfoLocal setObject:email forKey:@"email"];
             */
            //修改
            /*
             if (first&&![first isEqualToString:@""]) {
             //不全的 多信息 多信息
             [self.dataArraydic addObject:dicInfoLocal];
             } */
            
            if ([first isEqualToString:@" "] == NO || [last isEqualToString:@" "]) {
                [self.dataArrayDic addObject:dicInfoLocal];
                // [self.dataArray addObject: [NSString stringWithFormat:@"%@ %@",first,last]];
            }
            
        }
        
        CFRelease(results);//new
        CFRelease(addressBook);//new
        

        NSString *strFirLetter = nil;
        
        for (NSDictionary*dic in self.dataArrayDic) {
            
            
            if ([dic[@"last"] length]>0) {
                
                strFirLetter = [self upperStr:[NSString stringWithFormat:@"%c",pinyinFirstLetter([dic[@"last"] characterAtIndex:0])]];
                
            }
            else if([dic[@"first"] length]>0&&[dic[@"last"] length]==0){
                
                strFirLetter = [self upperStr:[NSString stringWithFormat:@"%c",pinyinFirstLetter([dic[@"first"] characterAtIndex:0])]];
            }
            
            
            if ([[index allKeys]containsObject:strFirLetter]) {
                //判断index字典中，是否有这个key如果有，取出值进行追加操作
                [[index objectForKey:strFirLetter] addObject:dic];
                
            }else{
                
                NSMutableArray*tempArray=[NSMutableArray arrayWithCapacity:0];
                [tempArray addObject:dic];
                [index setObject:tempArray forKey:strFirLetter];
            }
            
        }
        
        [self.dataArray addObjectsFromArray:[index allKeys]];
    }else{
        
        
        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置中查看通讯录是否被允许访问！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [aler show];
        
    }
    
    
    
    return index;
}

#pragma  mark 字母转换大小写--6.0
-(NSString*)upperStr:(NSString*)str{
    
    //    //全部转换为大写
    NSString *upperStr1 = [str uppercaseStringWithLocale:[NSLocale currentLocale]];
    //    NSLog(@"upperStr1: %@", upperStr);
    //首字母转换大写
    //        NSString *capStr = [str capitalizedStringWithLocale:[NSLocale currentLocale]];
    //    NSLog(@"capStr: %@", capStr);
    //    // 全部转换为小写
    //    NSString *lowerStr = [str lowercaseStringWithLocale:[NSLocale currentLocale]];
    //    NSLog(@"lowerStr: %@", lowerStr);
    return upperStr1;
    
}

@end
