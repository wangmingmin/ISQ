//
//  VideoDetailController.m
//  ISQ
//
//  Created by Jun on 15/10/8.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "VideoDetailController.h"
#import "VideoDetailPlayerCell.h"
#import "GuessLikeCollectionCell.h"
#import "DWCustomPlayerViewController.h"
#import "DWPlayerMenuView.h"
#import "DWTableView.h"
#import "DWTools.h"
#import "Reachability.h"
#import "CommentController.h"
#import "MBProgressHUD.h"
#import "HotVideoModel.h"
#import "MainViewController.h"
#import "AppDelegate.h"


typedef NSInteger DWPLayerScreenSizeMode;
@interface VideoDetailController (){
    MBProgressHUD *HUD;
    VideoDetailPlayerCell *plaCell;
    GuessLikeCollectionCell *collectionCell;
    DWCustomPlayerViewController *playVC;
    HotVideoModel *data;
    NSMutableArray *cellHeight;
    UILabel *contentLabel;
    UIView *photosView;
    UIView *joinView;
    UILabel *numOfJoin;
    NSArray *imgUrlArray;
    UIImage *image ;
    NSDictionary *theLikeDic;
    NSDictionary *userDic;
    NSString *useraccount;
    NSMutableArray *phoneArray;
}

@property (strong, nonatomic)DWMoviePlayerController  *player;
@property (strong, nonatomic)NSString *currentQuality;
@property (strong, nonatomic)NSTimer *timer;
@property (strong, nonatomic)UIView *videoBackgroundView;
@property (strong, nonatomic)UITapGestureRecognizer *signelTap;
@property (strong, nonatomic)UILabel *videoStatusLabel;
@property (strong, nonatomic)NSDictionary *playUrls;
@property (strong, nonatomic)UILabel *durationLabel;
@property (strong, nonatomic)UILabel *currentPlaybackTimeLabel;
@property (strong, nonatomic)UISlider *durationSlider;
@property (strong, nonatomic)UIView *headerView;
@property (strong, nonatomic)UIView *footerView;
@property (strong, nonatomic)UIButton *playbackButton;
@property (strong, nonatomic)UIButton *fullButton;
@property (strong, nonatomic)UIView *overlayView;
@property (assign, nonatomic)BOOL hiddenAll;
@property (assign, nonatomic)NSInteger hiddenDelaySeconds;
@property (assign, nonatomic)NSTimeInterval historyPlaybackTime;


@end

@implementation VideoDetailController
@synthesize tableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicView];
    phoneArray = [[NSMutableArray alloc] init];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 16, 23)];
    [backButton setImage:[UIImage imageNamed:@"back_img"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonItem;
    [self playerView];
    // 加载播放器 必须第一个加载
    [self loadPlayer];
    // 加载播放器覆盖视图
    self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 0.70666 * UISCREENWIDTH)];
    self.overlayView.backgroundColor = [UIColor clearColor];

    [self loadFooterView];
    [self loadVideoStatusLabel];
    
    self.signelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelTap:)];
    self.signelTap.numberOfTapsRequired = 1;
    self.signelTap.delegate = self;
    [self.overlayView addGestureRecognizer:self.signelTap];
  
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        //停止播放
        [self.player pause];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else if (buttonIndex == 1){
        
        //继续播放
        [self.player play];
    }
}

-(void)basicView{
    self.tableview.layer.borderWidth=0.5f;
    self.tableview.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
    self.praiseButton.layer.borderWidth=0.5f;
    self.praiseButton.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.5f].CGColor;
    //数据源
    data = [HotVideoModel objectWithKeyValues:_httpData];
    //cell的高度
    cellHeight=[[NSMutableArray alloc]init];
    //播放器的高度
    [cellHeight addObject:[NSString stringWithFormat:@"%f",UISCREENWIDTH*0.70006]];
    //标题等信息
    [cellHeight addObject:[NSString stringWithFormat:@"72"]];
    data = [HotVideoModel objectWithKeyValues:_httpData];
    //内容
    [self theContent];
    [cellHeight addObject:@"35.0"];
    //参与人员
    [cellHeight addObject:[NSString stringWithFormat:@"28"]];
    [self joinPeople];
    

}

- (void)viewWillAppear:(BOOL)animated{

    AppDelegate *delget=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if ([delget.isWIFI isEqualToString:@"WIFI"]){
        
        [self.player play];
        
    }else {
        
        [self.player pause];
        UIAlertView  *alerWIFI=[[UIAlertView alloc ]initWithTitle:@"流量使用提示" message:@"继续播放，运营商将收取流量费用"delegate:self cancelButtonTitle:@"停止播放" otherButtonTitles:@"继续播放", nil];
        
        [alerWIFI show];
        
    }

}


-(void)viewDidAppear:(BOOL)animated{
    
   
    if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
      
        
    } else {
        // 继续播放
        image = [UIImage imageNamed:@"player-pausebutton"];
        [self.player play];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.player stop];
}
#pragma mark - scrollView delegate


/**
 *  滚动显示工具条
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
   
    if (self.hiddenAll) {
        [self showBasicViews];
        self.hiddenDelaySeconds = 5;
        
    }
}


- (void)loadFooterView
{
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.overlayView.frame.size.height + 20 - 64, self.overlayView.frame.size.width, 64)];
    self.footerView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2];
    [self.overlayView addSubview:self.footerView];
    logdebug(@"footerView: %@", NSStringFromCGRect(self.footerView.frame));
    
    /**
     *  NOTE: 由于各个view之间的坐标有依赖关系，所以以下view的加载顺序必须为：
     *  playbackButton -> currentPlaybackTimeLabel -> screenSizeView  -> durationLabel -> playbakSlider
     */
    
    // 播放按钮
    [self loadPlaybackButton];
    
    // 当前播放时间
    [self loadCurrentPlaybackTimeLabel];
    
    // 时间滑动条
    [self loadPlaybackSlider];
    // 视频总时间
    [self loadDurationLabel];
    
    //全屏按钮
    [self toFullScreen];
}
# pragma mark 播放按钮
- (void)loadPlaybackButton
{
    self.playbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect frame = CGRectZero;
    frame.origin.x = self.footerView.frame.origin.x + 8;
    frame.origin.y = self.footerView.frame.origin.y + 4;
    frame.size.width = 30;
    frame.size.height = 30;
    self.playbackButton.frame = frame;
    
    [self.playbackButton setImage:[UIImage imageNamed:@"player-playbutton"] forState:UIControlStateNormal];
    [self.playbackButton addTarget:self action:@selector(playbackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.playbackButton];
}
# pragma mark - 视频播放状态
- (void)loadVideoStatusLabel
{
    CGRect frame = CGRectZero;
    frame.size.height = 40;
    frame.size.width = 100;
    frame.origin.x = UISCREENWIDTH/2 - frame.size.width/2;
    frame.origin.y = (0.70666 * UISCREENWIDTH)/2 -20;
    
    self.videoStatusLabel = [[UILabel alloc] initWithFrame:frame];
    self.videoStatusLabel.textAlignment=NSTextAlignmentCenter;
    self.videoStatusLabel.text = @"正在加载...";
    self.videoStatusLabel.textColor = [UIColor whiteColor];
    self.videoStatusLabel.backgroundColor = [UIColor clearColor];
    self.videoStatusLabel.font = [UIFont systemFontOfSize:16];
    
    [self.overlayView addSubview:self.videoStatusLabel];
}

#pragma mark - 全屏播放

-(void)toFullScreen{
    
    self.fullButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect frame = CGRectZero;
    frame.origin.x = UISCREENWIDTH-30-8;
    frame.origin.y = self.footerView.frame.origin.y + 4;
    frame.size.width = 30;
    frame.size.height = 30;
    self.fullButton.frame = frame;
    
    [self.fullButton setImage:[UIImage imageNamed:@"player-full-button"] forState:UIControlStateNormal];
    [self.fullButton addTarget:self action:@selector(toFullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.fullButton];
    
    
}

//全屏播放
- (void)toFullScreenAction:(UIButton *)button
{
    
    [self.player pause];
    playVC=[[DWCustomPlayerViewController alloc]init];
    playVC.videoId=data.videoID;
    playVC.videoTitle=self.title;
    [playVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:playVC animated:NO];
   

}

# pragma mark - 加载播放器
- (void)loadPlayer
{
    CGRect frame = CGRectZero;
    
    frame = CGRectMake(0, 0, UISCREENWIDTH, UISCREENWIDTH*0.70600);
    
    
    self.videoBackgroundView = [[UIView alloc] initWithFrame:frame];
    self.videoBackgroundView.backgroundColor = [UIColor blackColor];
    
    logdebug(@"self.view.frame: %@ self.videoBackgroundView.frame: %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.videoBackgroundView.frame));
    
    self.player.scalingMode = MPMovieScalingModeAspectFit;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.view.backgroundColor = [UIColor clearColor];
    self.player.view.frame = self.videoBackgroundView.bounds;
    
    [self.videoBackgroundView addSubview:self.player.view];
    logdebug(@"self.player.view.frame: %@", NSStringFromCGRect(self.player.view.frame));
    
    [self loadPlayUrls];
}


# pragma mark 视频总时间
- (void)loadDurationLabel
{
    CGRect frame = CGRectZero;
    frame.size.width = 60;
    frame.size.height = 20;
    frame.origin.x = self.durationSlider.origin.x+self.durationSlider.size.width+8;
    frame.origin.y = self.footerView.frame.origin.y + 8;
    
    self.durationLabel = [[UILabel alloc] initWithFrame:frame];
    self.durationLabel.text = @"00:00:00";
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.backgroundColor = [UIColor clearColor];
    self.durationLabel.font = [UIFont systemFontOfSize:12];
    
    [self.overlayView addSubview:self.durationLabel];
}


- (void)playbackButtonAction:(UIButton *)button
{
    self.hiddenDelaySeconds = 5;
    
    if (!self.playUrls || self.playUrls.count == 0) {
        [self loadPlayUrls];
        return;
    }
    
 
    if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
        // 暂停播放
        image = [UIImage imageNamed:@"player-playbutton"];
        [self.player pause];
        
    } else {
        // 继续播放
        image = [UIImage imageNamed:@"player-pausebutton"];
        [self.player play];
    }
    
    [self.playbackButton setImage:image forState:UIControlStateNormal];
}

# pragma mark 当前播放时间
- (void)loadCurrentPlaybackTimeLabel
{
    CGRect frame = CGRectZero;
    frame.origin.x = self.playbackButton.frame.origin.x + self.playbackButton.frame.size.width + 8;
    frame.origin.y = self.footerView.frame.origin.y + 8;
    frame.size.width = 60;
    frame.size.height = 20;
    
    self.currentPlaybackTimeLabel = [[UILabel alloc] initWithFrame:frame];
    self.currentPlaybackTimeLabel.text = @"00:00:00";
    self.currentPlaybackTimeLabel.textColor = [UIColor whiteColor];
    self.currentPlaybackTimeLabel.font = [UIFont systemFontOfSize:12];
    self.currentPlaybackTimeLabel.backgroundColor = [UIColor clearColor];
    [self.overlayView addSubview:self.currentPlaybackTimeLabel];
    logdebug(@"currentPlaybackTimeLabel frame: %@", NSStringFromCGRect(self.currentPlaybackTimeLabel.frame));
}

-(void)playerView{
    
    _player = [[DWMoviePlayerController alloc] initWithUserId:DWACCOUNT_USERID key:DWACCOUNT_APIKEY];
    
    _currentQuality = @"";
    [self addObserverForMPMoviePlayController];
    [self addTimer];
    
}


# pragma mark - 播放视频
- (void)loadPlayUrls
{
    //    //轻量数据存储(获取CC视频码)
    //    NSUserDefaults *saveData=[NSUserDefaults standardUserDefaults];
    
    self.player.videoId = data.videoID;
    
    self.player.timeoutSeconds = 10;
    
    __weak VideoDetailController *blockSelf = self;
    self.player.failBlock = ^(NSError *error) {
        loginfo(@"error: %@", [error localizedDescription]);
        blockSelf.videoStatusLabel.hidden = NO;
        blockSelf.videoStatusLabel.text = @"加载失败";
    };
    
    self.player.getPlayUrlsBlock = ^(NSDictionary *playUrls) {
        // [必须]判断 status 的状态，不为"0"说明该视频不可播放，可能正处于转码、审核等状态。
        NSNumber *status = [playUrls objectForKey:@"status"];
        if (status == nil || [status integerValue] != 0) {
            NSString *message = [NSString stringWithFormat:@"%@ %@:%@",
                                 blockSelf.videoId,
                                 [playUrls objectForKey:@"status"],
                                 [playUrls objectForKey:@"statusinfo"]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        
        blockSelf.playUrls = playUrls;
        [blockSelf.player prepareToPlay];
        
        [blockSelf.player play];
        
//        [blockSelf resetViewContent];
    };
    
    [self.player startRequestPlayInfo];
}

# pragma mark 时间滑动条
- (void)loadPlaybackSlider
{
    CGRect frame = CGRectZero;
    frame.origin.x = self.currentPlaybackTimeLabel.frame.origin.x + self.currentPlaybackTimeLabel.frame.size.width + 8;
    frame.origin.y = self.footerView.frame.origin.y + 4;
    frame.size.width = UISCREENWIDTH- 2 * frame.origin.x;
    frame.size.height = 30;
    
    self.durationSlider = [[UISlider alloc] initWithFrame:frame];
    self.durationSlider.value = 0.0f;
    self.durationSlider.minimumValue = 0.0f;
    self.durationSlider.maximumValue = 1.0f;
    [self.durationSlider setMaximumTrackImage:[UIImage imageNamed:@"player-slider-inactive"]
                                     forState:UIControlStateNormal];
    [self.durationSlider setMinimumTrackImage:[UIImage imageNamed:@"player-slider-active"]
                                     forState:UIControlStateNormal];
    [self.durationSlider setThumbImage:[UIImage imageNamed:@"player-slider-handle"]
                              forState:UIControlStateNormal];
    [self.durationSlider addTarget:self action:@selector(durationSliderMoving:) forControlEvents:UIControlEventValueChanged];
    [self.durationSlider addTarget:self action:@selector(durationSliderDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.durationSlider];
    logdebug(@"self.durationSlider.frame: %@", NSStringFromCGRect(self.durationSlider.frame));
    
}

- (void)durationSliderMoving:(UISlider *)slider
{
    logdebug(@"self.durationSlider.value: %ld", (long)slider.value);
    if (self.player.playbackState != MPMoviePlaybackStatePaused) {
//        [self.player pause];
    }
    
    self.player.currentPlaybackTime = slider.value;
    self.currentPlaybackTimeLabel.text = [DWTools formatSecondsToString:self.player.currentPlaybackTime];
    self.historyPlaybackTime = self.player.currentPlaybackTime;
    
    
}

- (void)durationSliderDone:(UISlider *)slider
{
    logdebug(@"slider touch");
    if (self.player.playbackState != MPMoviePlaybackStatePlaying) {
        [self.player play];
    }
    self.currentPlaybackTimeLabel.text = [DWTools formatSecondsToString:self.player.currentPlaybackTime];
    self.historyPlaybackTime = self.player.currentPlaybackTime;
}

# pragma mark - 手势识别 UIGestureRecognizerDelegate
-(void)handleSignelTap:(UIGestureRecognizer*)gestureRecognizer
{
    if (self.hiddenAll) {
        [self showBasicViews];
        self.hiddenDelaySeconds = 5;
        
    } else {
        [self hiddenAllView];
        self.hiddenDelaySeconds = 0;
    }
}
# pragma mark - MPMoviePlayController Notifications
- (void)addObserverForMPMoviePlayController
{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    // MPMovieDurationAvailableNotification
    [notificationCenter addObserver:self selector:@selector(moviePlayerDurationAvailable) name:MPMovieDurationAvailableNotification object:self.player];
    
    // MPMovieNaturalSizeAvailableNotification
    
    // MPMoviePlayerLoadStateDidChangeNotification
    [notificationCenter addObserver:self selector:@selector(moviePlayerLoadStateDidChange) name:MPMoviePlayerLoadStateDidChangeNotification object:self.player];
    
    // MPMoviePlayerPlaybackDidFinishNotification
    [notificationCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player];
    
    // MPMoviePlayerPlaybackStateDidChangeNotification
    [notificationCenter addObserver:self selector:@selector(moviePlayerPlaybackStateDidChange) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.player];
    
    // MPMoviePlayerReadyForDisplayDidChangeNotification
}


- (void)moviePlayerDurationAvailable
{
    self.durationLabel.text = [DWTools formatSecondsToString:self.player.duration];
    self.currentPlaybackTimeLabel.text = [DWTools formatSecondsToString:0];
    self.durationSlider.minimumValue = 0.0;
    self.durationSlider.maximumValue = self.player.duration;
    logdebug(@"seconds %f maximumValue %f %@", self.player.duration, self.durationSlider.maximumValue, self.durationLabel.text);
}

- (void)moviePlayerLoadStateDidChange
{
    switch (self.player.loadState) {
        case MPMovieLoadStatePlayable:
            // 可播放
            logdebug(@"%@ playable", self.player.originalContentURL);
            self.videoStatusLabel.hidden = YES;
            break;
            
        case MPMovieLoadStatePlaythroughOK:
            // 状态为缓冲几乎完成，可以连续播放
            logdebug(@"%@ PlaythroughOK", self.player.originalContentURL);
            self.videoStatusLabel.hidden = YES;
            break;
            
        case MPMovieLoadStateStalled:
            // 缓冲中
            logdebug(@"%@ Stalled", self.player.originalContentURL);
            self.videoStatusLabel.hidden = NO;
            self.videoStatusLabel.text = @"正在加载...";
            break;
            
        default:
            
            break;
    }
}

- (void)moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    logdebug(@"accessLog %@", self.player.accessLog);
    logdebug(@"errorLog %@", self.player.errorLog);
    NSNumber *n = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([n intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            logdebug(@"PlaybackEnded");
            self.videoStatusLabel.hidden = YES;
            break;
            
        case MPMovieFinishReasonPlaybackError:
            logdebug(@"PlaybackError");
            self.videoStatusLabel.hidden = NO;
            self.videoStatusLabel.text = @"加载失败";
            break;
            
        case MPMovieFinishReasonUserExited:
            logdebug(@"ReasonUserExited");
            break;
            
        default:
            break;
    }
}

- (void)moviePlayerPlaybackStateDidChange
{
    logdebug(@"%@ playbackState: %ld", self.player.originalContentURL, (long)self.player.playbackState);
    
    switch ([self.player playbackState]) {
        case MPMoviePlaybackStateStopped:
            logdebug(@"movie stopped");
            [self.playbackButton setImage:[UIImage imageNamed:@"player-playbutton"] forState:UIControlStateNormal];
            break;
            
        case MPMoviePlaybackStatePlaying:
            [self.playbackButton setImage:[UIImage imageNamed:@"player-pausebutton"] forState:UIControlStateNormal];
            logdebug(@"movie playing");
            self.videoStatusLabel.hidden = YES;
            break;
            
        case MPMoviePlaybackStatePaused:
            [self.playbackButton setImage:[UIImage imageNamed:@"player-playbutton"] forState:UIControlStateNormal];
            logdebug(@"movie paused");
            self.videoStatusLabel.hidden = NO;
            self.videoStatusLabel.text = @"暂停";
            break;
            
        case MPMoviePlaybackStateInterrupted:
            [self.playbackButton setImage:[UIImage imageNamed:@"player-playbutton"] forState:UIControlStateNormal];
            logdebug(@"movie interrupted");
            self.videoStatusLabel.hidden = NO;
            self.videoStatusLabel.text = @"加载中。。。";
            break;
            
        case MPMoviePlaybackStateSeekingForward:
            logdebug(@"movie seekingForward");
            self.videoStatusLabel.hidden = YES;
            break;
            
        case MPMoviePlaybackStateSeekingBackward:
            logdebug(@"movie seekingBackward");
            self.videoStatusLabel.hidden = YES;
            break;
            
        default:
            break;
    }
}
- (void)hiddenTableViews
{
//    self.subtitleView.hidden = YES;
//    self.qualityView.hidden = YES;
//    self.screenSizeView.hidden = YES;
}

- (void)hiddenAllView
{
    
    
    self.playbackButton.hidden = YES;
    self.fullButton.hidden = YES;
    self.currentPlaybackTimeLabel.hidden = YES;
    self.durationLabel.hidden = YES;
    self.durationSlider.hidden = YES;

    self.headerView.hidden = YES;
    self.footerView.hidden = YES;
    
    self.hiddenAll = YES;
    
    
}

- (void)showBasicViews
{

    
    self.playbackButton.hidden = NO;
    self.fullButton.hidden = NO;
    self.currentPlaybackTimeLabel.hidden = NO;
    self.durationLabel.hidden = NO;
    self.durationSlider.hidden = NO;
    
//    self.volumeSlider.hidden = NO;
//    self.volumeView.hidden = NO;
    
    self.headerView.hidden = NO;
    self.footerView.hidden = NO;
    self.hiddenAll = NO;
    
}


# pragma mark - timer
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
}
- (void)removeTimer
{
    [self.timer invalidate];
}
- (void)timerHandler
{
    self.currentPlaybackTimeLabel.text = [DWTools formatSecondsToString:self.player.currentPlaybackTime];
    self.durationLabel.text = [DWTools formatSecondsToString:self.player.duration];
    self.durationSlider.value = self.player.currentPlaybackTime;
    
    self.historyPlaybackTime = self.player.currentPlaybackTime;
    
    if (!self.hiddenAll) {
        if (self.hiddenDelaySeconds > 0) {
            if (self.hiddenDelaySeconds == 1) {
                [self hiddenAllView];
            }
            self.hiddenDelaySeconds--;
        }
    }
}

- (void)backAction:(id)sender{
    
    logdebug(@"stop movie");
    [self.player prepareToPlay];
    self.player.currentPlaybackTime = self.player.duration;
    self.player.contentURL = nil;
    [self.player stop];
    
    [self removeAllObserver];
    [self removeTimer];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [cellHeight[indexPath.row] floatValue];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
   
    NSString *indentifier=@"";
    indentifier=[NSString stringWithFormat:@"VideoDetailPlayerCell%ld",(long)indexPath.row];
    plaCell=[tableview dequeueReusableCellWithIdentifier:indentifier];
    
    
    switch (indexPath.row) {
        case 0:
            
            [plaCell addSubview:self.videoBackgroundView];
            [plaCell addSubview:self.overlayView];
            break;
            
        case 1:
            
            [plaCell.userHeadImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MYHEADIMGURL,data.userFace]] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
            plaCell.activityTitle.text=data.title;
            plaCell.activityTime.font = [UIFont systemFontOfSize:14];
            plaCell.activityTime.text=[NSString stringWithFormat:@"时间：%@",data.uploadTime];
            plaCell.activityPlace.font = [UIFont systemFontOfSize:14];
            plaCell.activityPlace.text=[NSString stringWithFormat:@"地点：%@",data.address];
            
            break;
      
        case 2:
            contentLabel.x=55;
            contentLabel.y=1;
            [plaCell addSubview:contentLabel];
            break;
        case 3:
            plaCell.layer.borderWidth=0.7f;
            plaCell.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.6].CGColor;
            numOfJoin.x=8;
            numOfJoin.y=0;
            [plaCell addSubview:numOfJoin];
            
            break;
        case 4:
            joinView.x=15;
            joinView.y=1;
            [plaCell addSubview:joinView];
            
            break;

    }
    
    
    
    
    
    
    return plaCell;
   
    
   
}
#pragma  mark 内容
-(void)theContent{
    //内容
    contentLabel=[[UILabel alloc]init];
    contentLabel.width=UISCREENWIDTH-70;
    contentLabel.height=[UILabel getLabelHeight:data.detail theUIlabel:contentLabel].height+10;
    contentLabel.numberOfLines=0;
    contentLabel.font=[UIFont fontWithName:@"Helvetica" size:16];
    [cellHeight addObject:[NSString stringWithFormat:@"%f",contentLabel.height]];
    contentLabel.text=data.detail;
    
}
#pragma  mark 参与人员
-(void)joinPeople{
    
    
    
    numOfJoin=[[UILabel alloc]init];
    numOfJoin.width=200;
    numOfJoin.height=35;
    numOfJoin.text=[NSString stringWithFormat:@"%@ 人参加活动",data.joinNum];
    
    
    if (data.activeID) {
        joinView=[[UIView alloc]init];
        
        joinView.width=UISCREENWIDTH-30;
        NSMutableDictionary *parames=[NSMutableDictionary dictionary];
        
        parames[@"activeID"]=data.activeID;
        parames[@"userAccount"]=[NSString stringWithFormat:@"%@",[user_info objectForKey:userAccount]];
        
        [ISQHttpTool getHttp:@"http://121.41.18.126:8080/isqbms/getNearActiveDetail.from" contentType:nil params:parames success:^(id rect) {
            
            theLikeDic=[NSJSONSerialization JSONObjectWithData:rect options:NSJapaneseEUCStringEncoding error:nil];
            
            
            
            
            if (theLikeDic[@"nearActive"]) {
                
                //点赞、分享、参加
                [self foolBarView:theLikeDic[@"nearActive"]];
                
                
            }

            
            if (theLikeDic[@"userInfo"]) {
                
                
                int theX=0;
                int theY=0;
                NSArray *array = theLikeDic[@"userInfo"];
                for (int i = 0; i<array.count; i++) {
                    userDic = array[i];
                    if (theX/4>=1) {
                        
                        theX=0;
                        theY++;
                    }
                    UIButton *joinPeople=[[UIButton alloc]init];
                    joinPeople.width=(joinView.width/4-8);
                    joinPeople.height=17;
                    joinPeople.x= theX * joinPeople.width;
                    joinPeople.y=theY * (17+8)+3;
                    [joinPeople setTitle:userDic[@"userNickname"] forState:UIControlStateNormal];
                    [joinPeople setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    [joinPeople setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]] forState:UIControlStateHighlighted];
                    joinPeople.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:15];
                    theX++;
                    [joinView addSubview:joinPeople];
                    useraccount = [userDic objectForKey:@"userAccount"];
                    
                    [phoneArray addObject:[userDic objectForKey:@"userAccount"]];
                    joinPeople.tag = i;
                    
                    //如果是自己发起的活动
                    if (useraccount.length >5) {
                         numOfJoin.text=[NSString stringWithFormat:@"%@ 人参加活动%@ %@ %@",data.joinNum,@"(",@"点击昵称可与其电话联系",@")"];
                        [joinPeople addTarget:self action:@selector(callSender:) forControlEvents:UIControlEventTouchUpInside];
                        
                    }
                    
                }
                
                joinView.height=theY * (17+8)+3+17+8;
                joinView.height=theY * (17 +8)+3+17+8;
            }
            [cellHeight replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%f",joinView.height]];
            [self.tableview reloadData];
            
        } failure:^(NSError *erro) {
            
            
        }];
    }
    
}


- (void)callSender:(UIButton *)sender{

     NSString *phoneNum = [[NSString alloc] initWithFormat:@"%@",phoneArray[sender.tag]];
    NSLog(@"phoneNum--%@",phoneNum);
    
    
    //拨号
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNum]]];
}


-(void)foolBarView:(NSDictionary *)likeDic{
    
    
    NSArray *arrayNormalImg=[[NSArray alloc ]initWithObjects:@"join",@"clickz",@"share", nil];
    NSArray *arrayligtImg=[[NSArray alloc ]initWithObjects:@"joinSelected",@"clickzSelect",@"shareSelected", nil];
    
    if ([[NSString stringWithFormat:@"%@",likeDic[@"join"]] isEqualToString:@"1"]) {
        
        self.addButton.selected=YES;
        
    }
    if ([[NSString stringWithFormat:@"%@",likeDic[@"like"]] isEqualToString:@"1"]) {
        
        self.praiseButton.selected=YES;
        
        
    }
    
    [self.addButton setImage:[UIImage imageNamed:arrayNormalImg[0]] forState:UIControlStateNormal];
    [self.addButton setTitle:[NSString stringWithFormat:@"%@参加",likeDic[@"joinNum"]] forState:UIControlStateNormal];
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%@点赞",likeDic[@"likeNum"]] forState:UIControlStateNormal];
    
    [self.praiseButton setImage:[UIImage imageNamed:arrayligtImg[1]] forState:UIControlStateSelected];
    [self.praiseButton setImage:[UIImage imageNamed:arrayNormalImg[1]] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:arrayligtImg[0]] forState:UIControlStateSelected];
    
    
}

//参加
- (IBAction)addAction:(UIButton*)sender {
    
    
    [self loadJoinData];
    
    
}

//点赞
- (IBAction)praiseAction:(UIButton*)sender {
    sender.selected=!sender.selected;
    
    if (sender.selected) {
        
        //赞
        [self praise:sender];
        
        
    }else {
        
        //取消赞
        [self cancelPraise:sender];
        
        
        
    }
    
}

//分享
- (IBAction)shareAction:(id)sender {
    NSMutableDictionary *shareDic=[NSMutableDictionary dictionary];
    NSString *imageurls = data.image;
    imgUrlArray = [imageurls componentsSeparatedByString:@","];
    shareDic[@"img"]= imgUrlArray?imgUrlArray[0]:@"";
    shareDic[@"title"]=data.title;
    shareDic[@"desc"]=data.detail;
    shareDic[@"url"]=@"";
    
    [MainViewController theShareSDK:shareDic];
    
}


//参加
- (void)loadJoinData{
    
    NSMutableDictionary *joinDic = [[NSMutableDictionary alloc] init];
    joinDic[@"activeID"] = data.activeID;
    joinDic[@"userAccount"] = [user_info objectForKey:userAccount];
    [ISQHttpTool post:joininNearActive contentType:nil params:joinDic success:^(id responseObj) {
        
        NSString *joinData = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        
        if([joinData isEqualToString:@"Joined"]){
            
            [self showHint:@"您已经参加了哦，亲~"];
            
        }else{
            [self showHint:@"成功参与，嘻嘻~"];
            
            
            [self joinPeople];
            [self.addButton setTitle:[NSString stringWithFormat:@"%d参加",[data.joinNum intValue]+1] forState:UIControlStateNormal];
            self.addButton .selected=YES;
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self showHint:@"请稍后再试，谢谢~"];
    }];
    
}
//点赞
-(void)praise:(UIButton*)sender{
    
    NSMutableDictionary *clickzDic = [[NSMutableDictionary alloc] init];
    clickzDic[@"id"] = data.activeID;
    clickzDic[@"userAccount"] = [user_info objectForKey:userAccount];
    [ISQHttpTool post:activityClickz contentType:nil params:clickzDic success:^(id responseObj) {
        
        
        NSString *clickzData2 = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        
        if ([clickzData2 isEqualToString:@"ok"]) {
            
            
            if (theLikeDic[@"nearActive"]) {
                
                
                
                if ([[NSString stringWithFormat:@"%@",theLikeDic[@"nearActive"][@"like"]] isEqualToString:@"1"]) {
                    
                    
                    
                    //赞+1
                    [sender setTitle:[NSString stringWithFormat:@"%d点赞",[theLikeDic[@"nearActive"][@"likeNum"] intValue]] forState:UIControlStateNormal];
                    
                }else {
                    
                    
                    
                    //赞+1
                    [sender setTitle:[NSString stringWithFormat:@"%d点赞",[theLikeDic[@"nearActive"][@"likeNum"] intValue]+1] forState:UIControlStateNormal];
                    
                }
                
                
                
                
                
            }
            
            
        }
        
    } failure:^(NSError *error) {
        
        [self showHint:@"请稍后再试..."];
        
    }];
    
    ISQLog(@"赞");
}

//取消赞
-(void)cancelPraise:(UIButton *)sender{
    
    
    NSMutableDictionary *clickzDic = [[NSMutableDictionary alloc] init];
    clickzDic[@"id"] = data.activeID;
    clickzDic[@"userAccount"] = [user_info objectForKey:userAccount];
    [ISQHttpTool getHttp:cancelActivityClickz contentType:nil params:clickzDic success:^(id responseObject) {
        
        NSString *clickzData2 = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([clickzData2 isEqualToString:@"ok"]) {
            
            
            if (theLikeDic[@"nearActive"]) {
                
                
                
                
                if ([[NSString stringWithFormat:@"%@",theLikeDic[@"nearActive"][@"like"]] isEqualToString:@"1"]) {
                    
                    
                    //赞-1
                    [sender setTitle:[NSString stringWithFormat:@"%d点赞",[theLikeDic[@"nearActive"][@"likeNum"] intValue]-1] forState:UIControlStateNormal];
                    
                }else {
                    
                    
                    [sender setTitle:[NSString stringWithFormat:@"%d点赞",[theLikeDic[@"nearActive"][@"likeNum"] intValue]] forState:UIControlStateNormal];
                }
                
                
            }
            
            
        }
        
    } failure:^(NSError *erro) {
        
    }];
    
}



- (void)removeAllObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
