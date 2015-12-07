//
//  CommentController.m
//  ISQ
//
//  Created by Mac_SSD on 15/10/15.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "CommentController.h"
#import "CommentTextView.h"
#import "MBProgressHUD.h"
@interface CommentController (){
    MBProgressHUD *HUD;
    UIButton *sendBt;
}
@property (nonatomic, weak) CommentTextView *textView;
@end

@implementation CommentController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // 设置导航条内容
    [self setupNavBar];
    
    // 文本域
    [self setupTextView];
    
    //发送按钮
    [self setSendButton];
    
}


// 文本域
- (void)setupTextView
{
    
    [self.view addSubview:[UIView lineWidth:UISCREENWIDTH lineHeight:10 lineColor:[UIColor hexStringToColor:@"#F3F3F3" alpha:1.0f] lineX:0 lineY:64]];
    
   
    
    
    
    // 1.创建输入控件
    CommentTextView *textView = [[CommentTextView alloc] initWithFrame:CGRectMake(15, 35+64, UISCREENWIDTH-30, 185)];
    textView.backgroundColor=[UIColor hexStringToColor:@"#F3F3F3" alpha:1.0f];
    textView.layer.cornerRadius=2.0f;
    textView.layer.masksToBounds=YES;
    textView.delegate=self;
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 2.设置提醒文字（占位文字）
    textView.placehoder = @"说点什么吧！";
    
    // 3.设置字体
    textView.font = [UIFont systemFontOfSize:15];
}

// 设置导航条内容
- (void)setupNavBar
{
    self.title = @"我要评论";
    
     self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemName:@"取消" target:self action:@selector(toCancel)];
}



//发送按钮
-(void)setSendButton{
    
    sendBt=[[UIButton alloc]initWithFrame:CGRectMake(15, self.textView.origin.y+185+15, self.textView.size.width, 33)];
    sendBt.layer.cornerRadius=2.0f;
    sendBt.layer.masksToBounds=YES;
    sendBt.backgroundColor=[UIColor hexStringToColor:@"#3eb7f9" alpha:1.0f];
    [sendBt setEnabled:NO];
    [sendBt setTitle:@"提交" forState:UIControlStateNormal];
    [sendBt addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:  sendBt];
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length>0) {
        
        [sendBt setEnabled:YES];
    }
    
}

/**
 *  取消
 */
- (void)toCancel
{
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  发送
 */
- (void)send
{
    
    [self showHudInView:self.view hint:@"正在处理..."];
    NSMutableDictionary *parame=[NSMutableDictionary dictionary];
    parame[@"userAccount"]=[NSString stringWithFormat:@"%@",[user_info objectForKey:userAccount]];
    parame[@"content"]=self.textView.text;
    parame[@"activeID"]=self.activeID;
    
    [ISQHttpTool post:USER_COMMENT_HOT_ACTIVITY contentType:nil params:parame success:^(id responseObj) {
        
        [self hideHud];
        if (responseObj) {
            
            NSDictionary *dic=[[NSDictionary alloc]init];
            dic=responseObj;
            if (dic[@"msg"]) {
                [self warning:@"操作成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    } failure:^(NSError *error) {
        
         [self warning:@"操作失败！"];
        [self hideHud];
        
    }];
    
   
}
-(void)warning:(NSString *)warString2{
    
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode=MBProgressHUDModeText;
    
    HUD.labelText =[NSString stringWithFormat:@"%@",warString2];
    HUD.margin = 8.f;
    HUD.removeFromSuperViewOnHide = YES;
    
    [HUD hide:YES afterDelay:1.5];
}


@end
