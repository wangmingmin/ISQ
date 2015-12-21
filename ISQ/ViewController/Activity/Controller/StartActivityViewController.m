//
//  StartActivityViewController.m
//  ISQ
//
//  Created by mac on 15-9-24.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "StartActivityViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "ZHPickView.h"
#import "ActivityDownIcon.h"
#import "CommentTextView.h"
#import "StartActivityPhotosView.h"
#import "DWVideoCompressController.h"
#import "DWUploadItem.h"
#import "DWTools.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "HMAC-SHA1.h"
#import "JGActionSheet.h"
#import "AssetHelper.h"

@interface StartActivityViewController ()<ZHPickViewDelegate,JGActionSheetDelegate,UITextViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UIAlertViewDelegate>{
    DoImagePickerController *imagePickerController;
    MBProgressHUD *HUD;
    MBProgressHUD *HUD1;
    CGFloat borderX;
    UILabel *titleLable;
    UITextField *titleTextField;
    
    UILabel *tagLabel;
    UITextField *tagTextField;
    
    UILabel *placeLabel;
    UITextField *placeTextFeild;
    
    UILabel *starLabel;
    UILabel *endLabel;
    ActivityDownIcon *startTimeBt;
    ActivityDownIcon *endTimeBt;
    UIView *view;
    UIFont *font;
    UIColor *color;
    UIButton *imgBt;
    UIButton *videoBt;
    UIView *mediaView;
    StartActivityPhotosView *photosView;
    NSString *theMediaType;
    
    NSString *downListTag;
    BOOL uploadSta;
    BOOL startTimeIsNull;
    BOOL endTimeIsNull;
    NSString *getVideoID;
    UILabel *tipLabel;
    UIView *alerView;
    UIImageView *succseImg;
    JGActionSheet *_currentAnchoredActionSheet;
    JGActionSheet *_simple;
    UIButton *hidDialog;
    DWUploader *uploader;
    
}

@property (nonatomic, weak) CommentTextView *textView;
@property (nonatomic, weak) StartActivityPhotosView *photosView;
@property (strong, nonatomic)NSString *videoPath;
@property(nonatomic,strong)ZHPickView *pickview;
@property(nonatomic,strong)NSIndexPath *indexPath;

@end

@implementation StartActivityViewController
@synthesize scrollView;
#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 838.00
#endif

#define iOS7 (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoPath = nil;
    theMediaType=@"___";
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemName:@"提交" target:self action:@selector(submit)];
    self.navigationItem.title=@"发起活动";
    
    
    borderX=UISCREENWIDTH*0.093333;
    font=[UIFont systemFontOfSize:16];
    color=[UIColor hexStringToColor:@"DBE1E3" alpha:1];
    self.scrollView.backgroundColor=color;
    
    self.scrollView.contentSize=CGSizeMake(UISCREENWIDTH, 800);
    
    //基本控件
    [self basicView];
    
    // 正文内容控件
    [self setupTextView];
    
    // 添加显示图片的相册控件
    [self setupPhotosView];
    
    //图片&视频选择按钮
    [self chooseButtonView];
    
    
}


// 正文内容控件
- (void)setupTextView
{
    startTimeIsNull=YES;
    endTimeIsNull=YES;

    UILabel *contentLable=[[UILabel alloc]init];
    contentLable.x=borderX;
    contentLable.y=endLabel.y+endLabel.height+25;
    contentLable.width=32;
    contentLable.height=35;
    contentLable.text=@"内容";
    contentLable.font=font;
    [view addSubview:contentLable];
    
    //创建输入控件
    CommentTextView *textView = [[CommentTextView alloc] init];
    textView.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    textView.x=contentLable.x+12+contentLable.width;
    textView.y=endLabel.y+endLabel.height+25;
    textView.width=UISCREENWIDTH-borderX*2-12-titleLable.width;
    textView.height=UISCREENWIDTH*0.32;
    textView.delegate = self;
    textView.backgroundColor=color;
    [view addSubview:textView];
    self.textView = textView;
    textView.layer.cornerRadius=2.5f;
    textView.layer.masksToBounds=YES;
    
    mediaView=[[UIView alloc]init];
    mediaView.x=textView.x;
    mediaView.y=textView.y+textView.height-3;
    mediaView.height=63;
    mediaView.width=textView.width;
    mediaView.backgroundColor=textView.backgroundColor;
    mediaView.layer.cornerRadius=2.5f;
    mediaView.layer.masksToBounds=YES;
    [view addSubview:mediaView];
    
    //设置提醒文字（占位文字）
    textView.placehoder = @"活动内容可以包含文字、图片和视频";
    
    // 设置字体
    textView.font = font;
    
    //键盘隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [view addGestureRecognizer:tapGestureRecognizer];
}

// 添加显示图片的相册控件
- (void)setupPhotosView
{
    photosView = [[StartActivityPhotosView alloc] init];
    photosView.width = self.textView.width;
    photosView.height = self.textView.height;
    photosView.y = 5;
    [mediaView addSubview:photosView];
    self.photosView = photosView;
}


-(void)chooseButtonView{
    
    //图片
    imgBt=[[UIButton alloc]init];
    imgBt.x=titleLable.x+12+titleLable.width;
    imgBt.y=mediaView.y+mediaView.height+20;
    imgBt.width=50;
    imgBt.height=50;
    imgBt.tag=100;
    [imgBt setImage:[UIImage imageNamed:@"chatBar_colorMore_video.png"] forState:UIControlStateNormal];
    //chatBar_colorMore_photoSelected.png
    
    [imgBt addTarget:self action:@selector(media:) forControlEvents:UIControlEventTouchUpInside];
    
    //视频
    videoBt=[[UIButton alloc]init];
    videoBt.x=imgBt.x+imgBt.width+15;
    videoBt.y=mediaView.y+mediaView.height+20;
    videoBt.width=50;
    videoBt.height=50;
    videoBt.tag=101;
    [videoBt addTarget:self action:@selector(media:) forControlEvents:UIControlEventTouchUpInside];
    [videoBt setImage:[UIImage imageNamed:@"chatBar_colorMore_video.png"] forState:UIControlStateNormal];
    [view addSubview:imgBt];
}

//提交
-(void)submit{
    
    
    if (titleTextField.text.length <= 0 ) {
        
        [self warning:@"请填写标题！"];
        
    }else if (tagTextField.text.length <= 0){
        [self warning:@"请填写活动标签!"];
    }else if (placeTextFeild.text.length <= 0){
        [self warning:@"请填写活动地点！"];
    }
    else if (startTimeIsNull){
        [self warning:@"请选择开始时间！"];
    }else if (endTimeIsNull){
        [self warning:@"请选择结束时间"];
    }
    else{
        //如果存在视频路径则上传到CC
        if(self.videoPath!=nil &&[theMediaType isEqualToString:@"video"]){
            
            //上传视频到CC
            [self addVideoFileToUpload];
            
        }else if ([theMediaType isEqualToString:@"image"]){
            
            
            //上传图片及信息
            [self sendInfoToServer:@"2" url:START_ACTIVITY_HTTP videoID:@""];
            
        }else{
            //上传信息
            [self sendInfoToServer:@"1" url:START_ACTIVITY_HTTP videoID:@""];
        }
        
    }
    

}



#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    
    if ([downListTag isEqualToString:@"stime"]) {
        startTimeIsNull=NO;
        
        [startTimeBt setTitle:[resultString substringToIndex:11] forState:UIControlStateNormal];
        [startTimeBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }else if([downListTag isEqualToString:@"etime"]){
        endTimeIsNull=NO;
        [endTimeBt setTitle:[resultString substringToIndex:11]  forState:UIControlStateNormal];
        [endTimeBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}



-(void)media:(UIButton*)btn{
    
    JGActionSheetSection *s1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"小视频", @"本地视频",@"拍照",@"手机相册"] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:@[s1,[JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleCancel]]];
    
    sheet.delegate = self;
    
    sheet.insets = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    [sheet showInView:self.navigationController.view animated:YES];
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        [sheet dismissAnimated:YES];
    }];
    
}


-(void)actionSheet:(JGActionSheet *)actionSheet pressedButtonAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            
            //小视频
            theMediaType = @"video";
            
            [self openCamera];
        break;
            
        case 1:
            
            //本地视频
            theMediaType=@"video";
            
            if ([theMediaType isEqualToString:@"video"]&&[photosView images].count<=0) {
                
                if(self.videoPath==nil){
                    
                    [self openAlbum];
               
                }else {
                    [self warning:@"你已经选择了一个视频文件了!"];
                    
                }
            }else {
                
                [self warning:@"图片和视频只能选其一哦!"];
            }
            break;
            
        case 2:
            //拍照
             theMediaType=@"image";
            if ([theMediaType isEqualToString:@"image"] &&self.videoPath==nil) {
            if ([photosView images].count<3) {
                
                [self snapImage];
            }else {
                
                [self warning:@"最多可选择3张图片上传哦！"];
                
            }
            }else {
                
                [self warning:@"图片和视频只能选其一哦，亲。"];
            }
            break;
        case 3:
            //相册选择
            
            theMediaType=@"image";
            if ([theMediaType isEqualToString:@"image"] &&self.videoPath==nil) {
                if([photosView images].count<3){
                    imagePickerController = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
                    imagePickerController.delegate = self;
                    imagePickerController.nResultType = DO_PICKER_RESULT_UIIMAGE;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"最多可选择3张图片上传哦！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    //最多选择3张
                    imagePickerController.nMaxCount = 3 - [photosView images].count;
                   
                    //4列相片显示
                    imagePickerController.nColumnCount = 4;
                    [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
                    
                }else {
                    
                    [self warning:@"最多可选择3张图片上传哦！"];
                }
            }else {
                
                [self warning:@"图片和视频只能选其一哦，亲。"];
            }

            break;
            
    }
    
    
}


/**
 *  打开照相机
 */
- (void)openCamera{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.mediaTypes = temp_MediaTypes;
        //视频拍摄最长时长为1分钟
        picker.videoMaximumDuration = 60;
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        picker.delegate = self;
    }
        
    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
}


//拍照
- (void) snapImage{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未发现相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - UITextViewDelegate
/**
 *  当用户开始拖拽scrollView时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)chooseTime:(UIButton*)btn{
    
    
    [_pickview remove];
    
    NSInteger theTag=btn.tag;
    
    if (theTag==102||theTag==103) {
        
        if (theTag==102) {
            downListTag=@"stime";
            
        }else{
            downListTag=@"etime";
            
        }
        
        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
        _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        
    }
    _pickview.delegate=self;
    [_pickview show];
}


/**
 *  选择本地视频
 */
- (void)openAlbum
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    DWVideoCompressController *imagePicker = [[DWVideoCompressController alloc] initWithQuality: DWUIImagePickerControllerQualityTypeMedium andSourceType:DWUIImagePickerControllerSourceTypePhotoLibrary andMediaType:DWUIImagePickerControllerMediaTypeMovie];
      imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:NO completion:^{}];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //图片文件时
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (image == nil)
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //添加图片
        [self.photosView addImage:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //当视频文件时
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        
        //保存拍摄视频
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSURL *recordedVideoURL= [info objectForKey:UIImagePickerControllerMediaURL];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:recordedVideoURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:recordedVideoURL
                                        completionBlock:^(NSURL *assetURL, NSError *error){}
             ];
        }
        
        NSURL *videoURL = recordedVideoURL;
        self.videoPath = [videoURL path];
        UIImageView *videoImg=[[UIImageView alloc]init];
        videoImg.x=30;
        videoImg.y=5;
        videoImg.width=70;
        videoImg.height=60;
        videoImg.image=[self getVideoThumbnail];
        
        UIImageView *videoImg2=[[UIImageView alloc]init];
        videoImg2.width=40;
        videoImg2.height=40;
        videoImg2.x=videoImg.width/2-20;
        videoImg2.y=videoImg.height/2-20;
        videoImg2.image=[UIImage imageNamed:@"mideoImg"];
        
        // 视频缩略图
        [videoImg addSubview:videoImg2];
        [mediaView addSubview:videoImg];
        
    }
    
        [picker dismissViewControllerAnimated:YES completion:^{}];
}

//用户取相机
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    ISQLog(@"取消相机");
}
#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    for ( UIImage *img in aSelected) {
        
        //添加图片
        [self.photosView addImage:img];
    }
    
    [ASSETHELPER clearData];
}

# pragma mark - processer
- (void)addVideoFileToUpload
{
    
    
    alerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 220, 150)];
    UIImageView *img=[[UIImageView alloc]init];
    img.width=60;
    img.height=40;
    img.x=alerView.width/2-30;
    img.y=5;
    img.image=[self getVideoThumbnail];
    
    HUD1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD1];
    
    HUD1.customView = alerView;
    HUD1.color=[UIColor whiteColor];
    // Set custom view mode
    HUD1.mode = MBProgressHUDModeCustomView;
    
    [HUD1 show:YES];
    
    // 进度条宽度
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.x=20;
    self.progressView.y=img.y+img.height+20;
    self.progressView.width=alerView.width-40-53;
    self.progressView.height=10;
    [self.progressView setProgressViewStyle:UIProgressViewStyleDefault];
    
    // 文件大小进度
    self.progressLabel = [[UILabel alloc] init];
    self.progressLabel.x=self.progressView.x+self.progressView.width+5;
    self.progressLabel.y=self.progressView.y-10;
    self.progressLabel.width=53;
    self.progressLabel.height=20;
    [self.progressLabel setNumberOfLines:1];
    [self.progressLabel setFont:[UIFont systemFontOfSize:10]];
    
    //成功图标
    succseImg=[[UIImageView alloc]init];
    succseImg.x=alerView.width/2-15;
    succseImg.y=self.progressLabel.y+20;
    succseImg.width=30;
    succseImg.height=30;
    
    
    //提示
    tipLabel=[[UILabel alloc]init];
    tipLabel.x=0;
    tipLabel.y=self.progressLabel.y+10+30+5+10;
    tipLabel.width=alerView.width;
    tipLabel.height=15;
    UIFont *font1=[UIFont fontWithName:@"Helvetica" size:10];
    tipLabel.font=font1;
    tipLabel.textAlignment=NSTextAlignmentCenter;
    
    
    hidDialog=[[UIButton alloc]init];
    hidDialog.width=50;
    hidDialog.height=20;
    hidDialog.x=alerView.width/2-hidDialog.width/2;
    hidDialog.backgroundColor=[UIColor lightGrayColor];
    hidDialog.y=tipLabel.y+tipLabel.height+10;
    [hidDialog addTarget:self action:@selector(hideDialog) forControlEvents:UIControlEventTouchUpInside];
    [hidDialog setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hidDialog setTitle:@"取消" forState:UIControlStateNormal];
    
    [alerView addSubview:hidDialog];
    [alerView addSubview:tipLabel];
    [alerView addSubview:self.progressView];
    [alerView addSubview:self.progressLabel];
    [alerView addSubview:img];
    
    
    NSString *videoTitle = titleTextField.text;
    NSString *videoTag = tagTextField.text;
    NSString *videoDescription =titleTextField.text;

    uploader = [[DWUploader alloc] initWithUserId:DWACCOUNT_USERID
                                                       andKey:DWACCOUNT_APIKEY
                                             uploadVideoTitle:videoTitle
                                             videoDescription:videoDescription
                                                     videoTag:videoTag
                                                    videoPath:self.videoPath
                                                    notifyURL:CC_TO_ISQ_SERVER];
    
    uploader.timeoutSeconds = 20;
    [uploader start];
    
    [self.progressLabel setText:[NSString stringWithFormat:@"%@M/%@M", @"0", @"0"]];
    __weak StartActivityViewController *weakSelf = self;
    uploader.progressBlock = ^(float progress, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        
        [weakSelf.progressLabel setText:[NSString stringWithFormat:@"%0.1fM/%0.1fM", (long)totalBytesWritten/1024.0/1024.0, (long)totalBytesExpectedToWrite/1024.0/1024.0]];
        [weakSelf.progressView setProgress:progress];
        
        
    };
    
    uploader.finishBlock = ^() {
        
      [hidDialog setTitle:@"确定" forState:UIControlStateNormal];
        
        //视频信息
        [self sendInfoToServer:@"3" url:START_ACTIVITY_HTTP videoID:getVideoID];
        
    };
    
    uploader.failBlock = ^(NSError *error) {
        //失败
        succseImg.image=[UIImage imageNamed:@"upload-status-fail"];
        [alerView addSubview:succseImg];
        tipLabel.text=@"上传失败！";
        uploadSta=NO;
        [hidDialog setTitle:@"确定" forState:UIControlStateNormal];
        
        
    };
    
    uploader.pausedBlock = ^(NSError *error) {
        
        //失败
        succseImg.image=[UIImage imageNamed:@"upload-status-fail"];
        [alerView addSubview:succseImg];
        tipLabel.text=@"上传失败！";
        uploadSta=NO;
        [hidDialog setTitle:@"确定" forState:UIControlStateNormal];
    };
    
    uploader.videoContextForRetryBlock = ^(NSDictionary *videoContext) {
        
         //上传完成后的返回内容
       
        if (videoContext[@"videoid"]) {
            
            getVideoID=videoContext[@"videoid"];
        }
    };
}


//基本控件
-(void)basicView{
    
    view=[[UIView alloc]init];
    view.width=self.scrollView.width;
    view.height=self.scrollView.height-10;
    view.x=0;
    view.y=10;
    view.backgroundColor=[UIColor whiteColor];
    
    
    //标题
    titleLable=[[UILabel alloc]init];
    titleLable.x=borderX;
    titleLable.y=25;
    titleLable.width=32;
    titleLable.height=35;
    titleLable.text=@"标题";
    titleLable.font=font;
    
    titleTextField=[[UITextField alloc]init];
    titleTextField.x=12+titleLable.x+titleLable.width;
    titleTextField.y=25;
    titleTextField.width=UISCREENWIDTH-borderX*2-12-titleLable.width;
    titleTextField.height=35;
    titleTextField.placeholder=@"给活动起个漂亮的名字吧！";
    titleTextField.backgroundColor=color;
    titleTextField.layer.cornerRadius=2.5f;
    titleTextField.layer.masksToBounds=YES;
    
    //标签
    tagLabel=[[UILabel alloc]init];
    tagLabel.x=borderX;
    tagLabel.y=25+titleLable.y+titleLable.height;
    tagLabel.width=32;
    tagLabel.height=35;
    tagLabel.text=@"标签";
    tagLabel.font=font;
    
    
    tagTextField=[[UITextField alloc]init];
    tagTextField.x=12+titleLable.x+titleLable.width;
    tagTextField.y=tagLabel.y;
    tagTextField.width=UISCREENWIDTH-borderX*2-12-titleLable.width;
    tagTextField.height=35;
    tagTextField.placeholder=@"输入活动有关标签!";
    tagTextField.backgroundColor=color;
    tagTextField.layer.cornerRadius=2.5f;
    tagTextField.layer.masksToBounds=YES;
    
    //地点
    placeLabel=[[UILabel alloc]init];
    placeLabel.x=borderX;
    placeLabel.y=25+tagLabel.y+tagLabel.height;
    placeLabel.width=32;
    placeLabel.height=35;
    placeLabel.text=@"地点";
    placeLabel.font=font;
    
    placeTextFeild=[[UITextField alloc]init];
    placeTextFeild.x=12+titleLable.x+titleLable.width;
    placeTextFeild.y=placeLabel.y;
    placeTextFeild.width=UISCREENWIDTH-borderX*2-12-titleLable.width;
    placeTextFeild.height=35;
    placeTextFeild.placeholder=@"输入活动地点！";
    placeTextFeild.backgroundColor=color;
    placeTextFeild.layer.cornerRadius=2.5f;
    placeTextFeild.layer.masksToBounds=YES;
    
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy年MM月dd日"];
    NSString * nowtime = [df stringFromDate:currentDate];
     //开始时间
    starLabel=[[UILabel alloc]init];
    starLabel.x=borderX;
    starLabel.y=25+placeLabel.y+placeLabel.height;
    starLabel.width=32*2;
    starLabel.height=35;
    starLabel.text=@"时间  从";
    starLabel.font=font;
    
    startTimeBt=[[ActivityDownIcon alloc]init];
    startTimeBt.x=12+titleLable.x+titleLable.width+32;
    startTimeBt.y=25+placeLabel.y+placeLabel.height;
    startTimeBt.width=UISCREENWIDTH-borderX*2-12-titleLable.width-32;
    startTimeBt.height=35;
    [startTimeBt setTitle:nowtime forState:UIControlStateNormal];
    [startTimeBt setImage:[UIImage imageNamed:@"down_dark.png"] forState:UIControlStateNormal];
    startTimeBt.titleLabel.font=font;
    startTimeBt.backgroundColor=color;
    [startTimeBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    startTimeBt.layer.cornerRadius=2.5f;
    startTimeBt.layer.masksToBounds=YES;
    startTimeBt.tag=102;
    [startTimeBt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [startTimeBt addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    
    //结束时间
    endLabel=[[UILabel alloc]init];
    endLabel.x=borderX;
    endLabel.y=25+starLabel.y+starLabel.height;
    endLabel.width=32*2;
    endLabel.height=35;
    endLabel.text=@"         到";
    endLabel.font=font;
    
    endTimeBt=[[ActivityDownIcon alloc]init];
    endTimeBt.x=12+titleLable.x+titleLable.width+32;
    endTimeBt.y=25+startTimeBt.y+startTimeBt.height;
    endTimeBt.width=UISCREENWIDTH-borderX*2-12-titleLable.width-32;
    endTimeBt.height=35;
    [endTimeBt setTitle:nowtime forState:UIControlStateNormal];
    [endTimeBt setImage:[UIImage imageNamed:@"down_dark.png"] forState:UIControlStateNormal];
    endTimeBt.tag=103;
    [endTimeBt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [endTimeBt addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    endTimeBt.titleLabel.font=font;
    endTimeBt.backgroundColor=color;
    [endTimeBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    endTimeBt.layer.cornerRadius=2.5f;
    endTimeBt.layer.masksToBounds=YES;
    
    [self.scrollView addSubview:view];
    [view addSubview:starLabel];
    [view addSubview:startTimeBt];
    [view addSubview:endTimeBt];
    [view addSubview:endLabel];
    [view addSubview:placeLabel];
    [view addSubview:placeTextFeild];
    [view addSubview:titleLable];
    [view addSubview:titleTextField];
    [view addSubview:tagLabel];
    [view addSubview:tagTextField];
    
}


-(void)dialog:(NSString *)str{
    
    UIAlertView *ale=[[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
    
    [ale show];
    
}

//视频缩略图
- (UIImage *)getVideoThumbnail
{
    
    UIImage *image = [DWTools getImage:self.videoPath atTime:1 Error:nil];
    
    return image;
}


#pragma mark - 将信息发到服务器
-(void)sendInfoToServer:(NSString*)type url:(NSString*)url videoID:(NSString*)videoID{
    
    NSUserDefaults *userInfo=[NSUserDefaults standardUserDefaults];
    AppDelegate *locationCityDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //类型判断 type(1-文字,2-图文,3-视频)
    NSString *encodedImageStr=@"";
    if ([type isEqualToString:@"1"]) {
        
        [self showHudInView:self.view hint:@"正在提交审核..."];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        
    }else if ([type isEqualToString:@"2"]){
        
        [self showHudInView:self.view hint:@"正在提交审核..."];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        for (UIImage *img in [photosView images]) {
            
            NSData *ImageData = UIImageJPEGRepresentation(img, 0.8f);
            NSString *base64 = [ImageData base64Encoding];
            encodedImageStr = [NSString stringWithFormat:@"%@,%@",base64,encodedImageStr];
        }
    }
    else if ([type isEqualToString:@"3"]){
        
        [self showHudInView:self.view hint:@"正在提交审核..."];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
    }
    
    
    NSMutableDictionary *parames=[NSMutableDictionary dictionary];
    
    parames[@"userAccount"]=[NSString stringWithFormat:@"%@",[userInfo objectForKey:userAccount]];
    parames[@"type"]=type;
    parames[@"title"]=[NSString stringWithFormat:@"%@",titleTextField.text];
    parames[@"tagID"]= [NSString stringWithFormat:@"%@",tagTextField.text];
    parames[@"detail"]=[NSString stringWithFormat:@"%@",self.textView.text];
    parames[@"videoID"]=videoID;
    parames[@"communityID"]=[userInfo objectForKey:userCommunityID];
    parames[@"location_x"]=[NSString stringWithFormat:@"%f" ,locationCityDelegate.theLo];
    parames[@"address"] = [NSString stringWithFormat:@"%@",placeTextFeild.text];
    parames[@"location_y"]=[NSString stringWithFormat:@"%f" ,locationCityDelegate.theLa];
    parames[@"image"]=encodedImageStr;
    parames[@"time"]= [NSString stringWithFormat:@"%@%@%@",startTimeBt.titleLabel.text,@"~",endTimeBt.titleLabel.text];
    
    [ISQHttpTool post:url contentType:nil params:parames success:^(id responseObj) {
        
        //成功
        succseImg.image=[UIImage imageNamed:@"upload-status-finish"];
        [alerView addSubview:succseImg];
        uploadSta=YES;
        tipLabel.text=@"上传成功！";
        if (responseObj) {
            
            [self hideHud];
            
            if([type isEqualToString:@"1"] ||[type isEqualToString:@"2"])
            
            [self.navigationController popViewControllerAnimated:YES];
            [self warning:@"上传成功，请等待审核。"];
        
        }
        
        
    } failure:^(NSError *error) {
        
        
        [self hideHud];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        
        NSLog(@"error---%@",error);
        [self warning:@"上传失败，请检查网络状况"];
    }];
    
}
//隐藏HUD
-(void)hideDialog{
    
    [HUD1 hide:YES];
    
    if ([hidDialog.titleLabel.text isEqualToString:@"确定"]) {
        
        [self.navigationController popViewControllerAnimated:YES];

    }else if ([hidDialog.titleLabel.text isEqualToString:@"取消"]){
        [uploader pause];
    }
}

//键盘隐藏

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    [self.scrollView endEditing:YES];
}

-(void)warning:(NSString *)warString2{
    
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode=MBProgressHUDModeText;
    
    HUD.labelText =[NSString stringWithFormat:@"%@",warString2];
    HUD.margin = 8.f;
    HUD.removeFromSuperViewOnHide = YES;
    
    [HUD hide:YES afterDelay:1.5];
}

-(void)viewWillDisappear:(BOOL)animated{
    
     [_pickview remove];
}

@end
