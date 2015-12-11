//
//  VideoDetailController_forSpring.m
//  ISQ
//
//  Created by 123 on 15/12/9.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "VideoDetailController_forSpring.h"
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
#import "ISQCommonFunc.h"
typedef NSInteger DWPLayerScreenSizeMode;

@interface VideoDetailController_forSpring (){
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
@property (strong, nonatomic)UITableView * tableView_videoDetails;
@property (weak, nonatomic) IBOutlet UIView *tabbarview;
@end

@implementation VideoDetailController_forSpring
@synthesize tableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicView];
    
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
    
    self.tableview.backgroundColor = self.view.backgroundColor;
    self.collectButton.layer.borderColor = self.shareButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.collectButton.layer.borderWidth = self.shareButton.layer.borderWidth = 0.8;
    
    self.collectButton.layer.cornerRadius = self.shareButton.layer.cornerRadius = self.voteButton.layer.cornerRadius = 3.0;
    self.collectButton.layer.masksToBounds = self.shareButton.layer.masksToBounds = self.voteButton.layer.masksToBounds = YES;

    if (UISCREENHEIGHT<600) {
        UIEdgeInsets edge = self.collectButton.imageEdgeInsets;
        edge.left = 0;
        edge.right = 25;
        edge.top = 5;
        edge.bottom = 5;
        self.collectButton.imageEdgeInsets = edge;
        self.shareButton.imageEdgeInsets = edge;
        
        edge = self.collectButton.titleEdgeInsets;
        edge.left = -5;
        self.collectButton.titleEdgeInsets = edge;
        self.shareButton.titleEdgeInsets = edge;
        self.collectButton.titleLabel.font = [UIFont systemFontOfSize:11];
        self.shareButton.titleLabel.font = [UIFont systemFontOfSize:11];
    }

    [self checkIfIsVoted];
    [self checkIfIsFollow];
    
    [self.player stop];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==0) {//首先进入页面判断是否允许播放
        if (buttonIndex==1) {
            AppDelegate *delget=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            
            if ([delget.isWIFI isEqualToString:@"WIFI"]){
                
                [self.player play];
                
            }else {
                
                [self.player stop];
                UIAlertView  *alerWIFI=[[UIAlertView alloc ]initWithTitle:@"流量使用提示" message:@"继续播放，运营商将收取流量费用"delegate:self cancelButtonTitle:@"停止播放" otherButtonTitles:@"继续播放", nil];
                alerWIFI.tag = 1;
                [alerWIFI show];
                
            }

        }else if (buttonIndex==0){
            [self.player stop];
        }

    }else if (alertView.tag==1){//再判断Wi-Fi
        if (buttonIndex == 0) {
            
            //停止播放
            [self.player stop];
            
            
        }else if (buttonIndex == 1){
            
            //继续播放
            [self.player play];
            
            
            if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
                
                
            } else {
                // 继续播放
                image = [UIImage imageNamed:@"player-pausebutton"];
                [self.player play];
            }

        }
    }
}

-(void)basicView{
    self.tableview.layer.borderWidth=0.5f;
    self.tableview.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
    self.voteButton.layer.borderWidth=0.5f;
    self.voteButton.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.5f].CGColor;
    //数据源
    data = [HotVideoModel objectWithKeyValues:_httpData];
    //cell的高度
    cellHeight=[[NSMutableArray alloc]init];
    //播放器的高度
    [cellHeight addObject:[NSString stringWithFormat:@"%f",UISCREENWIDTH*0.70006]];
    data = [HotVideoModel objectWithKeyValues:_httpData];
//    //点赞、分享、参加
//    [self foolBarView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.player stop];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"是否播放当前视屏" message:@"" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"播放", nil];
    alert.tag = 0;
    [alert show];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self initTableView_videoDetails];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.player stop];
}

-(void)initTableView_videoDetails
{
    if (self.tableView_videoDetails == nil) {
        CGFloat originY = self.tableview.frame.origin.y+[cellHeight[0] floatValue]+8;
        self.tableView_videoDetails = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, UISCREENWIDTH, self.view.frame.size.height-originY-50)];//50是storyboard中设置的底部view的高度
        self.tableView_videoDetails.delegate = self;
        self.tableView_videoDetails.dataSource = self;
        self.tableView_videoDetails.backgroundColor = [UIColor colorWithRed:226.0/255 green:235.0/255 blue:237.0/255 alpha:1];
        self.tableView_videoDetails.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.tableView_videoDetails];
        
    }
    
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
    self.player.shouldAutoplay = NO;
    _currentQuality = @"";
    [self addObserverForMPMoviePlayController];
    [self addTimer];
    
}


# pragma mark - 播放视频
- (void)loadPlayUrls
{
    //    //轻量数据存储(获取CC视频码)
    //    NSUserDefaults *saveData=[NSUserDefaults standardUserDefaults];
    __block BOOL isAllowPlay = NO;

    self.player.videoId = data.videoID;
    
    self.player.timeoutSeconds = 10;
    
    __weak VideoDetailController_forSpring *blockSelf = self;
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
        
        if (blockSelf.playUrls==nil) {
            isAllowPlay = NO;
        }
        blockSelf.playUrls = playUrls;
        [blockSelf.player prepareToPlay];
        
        if (isAllowPlay) {
            [blockSelf.player play];
        }else {
            [blockSelf.player stop];
        }
        
        //        [blockSelf resetViewContent];
    };
    
    [self.player startRequestPlayInfo];
    if (!isAllowPlay) {
        [self.player stop];
    }
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableview) {
        return 1;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableview) {
        return 1;
    }
    if (tableView == self.tableView_videoDetails && section==0) {
        return 1;
    }
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableview) {
        return [cellHeight[indexPath.row] floatValue];
    }
    
    //self.tableView_videoDetails
    if (indexPath.section==0) {
        return 150;
    }
    return 44;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView ==self.tableView_videoDetails && section == 0) {
        return 60;
    }
    if (tableView ==self.tableView_videoDetails && section == 1) {
        return 40;
    }

    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView ==self.tableView_videoDetails) {
        CGFloat height = section==0?60:45;
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, height)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        if (section ==0) {
            UILabel * labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, headerView.frame.size.width-105, 30)];
            labelTitle.text = [NSString stringWithFormat:@"歌舞：%@",self.title];
            labelTitle.textColor = [UIColor grayColor];
            [headerView addSubview:labelTitle];
            
            UILabel * labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, headerView.frame.size.width-105, height-5-30)];
            labelAddress.text = [NSString stringWithFormat:@"选送：%@",self.httpData[@"address"]];
            labelAddress.textColor = [UIColor lightGrayColor];
            labelAddress.font = [UIFont systemFontOfSize:14];
            [headerView addSubview:labelAddress];

            UILabel * voteLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerView.frame.size.width-95, 12, 30, 25)];
            voteLabel.text = @"票数";
            voteLabel.textColor = labelAddress.textColor;
            voteLabel.font = labelAddress.font;
            [headerView addSubview:voteLabel];
            
            UILabel * voteCount = [[UILabel alloc] initWithFrame:CGRectMake(voteLabel.frame.origin.x+voteLabel.frame.size.width, 0, headerView.frame.size.width-(voteLabel.frame.origin.x+5), 40)];
            voteCount.text = [NSString stringWithFormat:@"%ld",(long)[self.httpData[@"voteNum"] integerValue]];
            voteCount.textColor = [UIColor redColor];
            voteCount.font = [UIFont systemFontOfSize:20];
            [headerView addSubview:voteCount];

            UILabel * browseCount = [[UILabel alloc] initWithFrame:CGRectMake(voteLabel.frame.origin.x, 35, headerView.frame.size.width-voteLabel.frame.origin.x, 20)];
            browseCount.text =[NSString stringWithFormat:@"浏览数 %ld",(long)[self.httpData[@"viewNum"] integerValue]];
            browseCount.textColor = labelAddress.textColor;
            browseCount.font = [UIFont systemFontOfSize:12];
            [headerView addSubview:browseCount];

        }
        if (section ==1) {
            UILabel * labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, headerView.frame.size.height)];
            labelTitle.text = @"评论";
            labelTitle.textColor = [UIColor colorWithRed:51.0/255 green:167.0/255 blue:255.0/255 alpha:1];
            [headerView addSubview:labelTitle];
            
            UIButton * comment = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width-15-80, 8, 80, height-8*2)];
            [comment setTitle:@"我要评论" forState:UIControlStateNormal];
            comment.titleLabel.font = [UIFont systemFontOfSize:14];
            [comment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [comment setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            comment.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            comment.layer.borderWidth = 0.8;
            comment.layer.cornerRadius = 3.0;
            comment.layer.masksToBounds = YES;
            [comment addTarget:self action:@selector(onCommentBtnToComment:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:comment];
        }

        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(8, height-1, UISCREENWIDTH-8*2, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [headerView addSubview:line];

        return headerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView ==self.tableView_videoDetails && section==0) {
        return 8;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView ==self.tableView_videoDetails) {
        CGFloat height = 8;
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, height)];
        footerView.backgroundColor = [UIColor clearColor];
        return footerView;
    }
    return nil;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableview) {
        NSString *indentifier=@"";
        indentifier=[NSString stringWithFormat:@"VideoDetailPlayerCell%ld",(long)indexPath.row];
        plaCell=[tableview dequeueReusableCellWithIdentifier:indentifier];
        
        [plaCell addSubview:self.videoBackgroundView];
        [plaCell addSubview:self.overlayView];
        return plaCell;
    }
    
    NSString *indentifier=[NSString stringWithFormat:@"details%ld%ld",(long)indexPath.section,indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }else{
        for (UIView * sub in cell.contentView.subviews) {
            [sub removeFromSuperview];
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0 && indexPath.row == 0) {//
        UILabel * labelZuoCi = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 31)];
        labelZuoCi.text = @"作词";
        labelZuoCi.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:labelZuoCi];

    }
    if (indexPath.section==1) {//评论
        UILabel * noComment = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-10, 31)];
        noComment.text = @"暂无评论";
        noComment.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:noComment];
    }
    return cell;
}


-(void)foolBarView{
    NSArray *arrayNormalImg=[[NSArray alloc ]initWithObjects:@"join",@"clickz",@"share", nil];
    NSArray *arrayligtImg=[[NSArray alloc ]initWithObjects:@"joinSelected",@"clickzSelect",@"shareSelected", nil];
    
    if ([[NSString stringWithFormat:@"%@",data.join] isEqualToString:@"1"]) {
        
        self.collectButton.selected=YES;
        
    }
    if ([[NSString stringWithFormat:@"%@",data.like] isEqualToString:@"1"]) {
        
        self.voteButton.selected=YES;
        
        
    }
    
    [self.collectButton setImage:[UIImage imageNamed:arrayNormalImg[0]] forState:UIControlStateNormal];
    [self.collectButton setTitle:[NSString stringWithFormat:@"%@参加",data.joinNum] forState:UIControlStateNormal];
    [self.voteButton setTitle:[NSString stringWithFormat:@"%@点赞",data.likeNum] forState:UIControlStateNormal];
    
    [self.voteButton setImage:[UIImage imageNamed:arrayligtImg[1]] forState:UIControlStateSelected];
    [self.voteButton setImage:[UIImage imageNamed:arrayNormalImg[1]] forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:arrayligtImg[0]] forState:UIControlStateSelected];
    
    
}

#warning need to fix
-(void)refresh
{
    NSString * strUrl = [NSString stringWithFormat:@"%@activeID=%@&userAccount=%@",httpDetailServer,self.httpData[@"activeID"],[user_info objectForKey:userAccount]];
    [ISQHttpTool getHttp:strUrl contentType:nil params:nil success:^(id res) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:res options:NSJapaneseEUCStringEncoding error:nil];
        //        NSLog(@"resDic ************   %@",dic);
        NSDictionary * dataNeed = dic[@"retData"];
        self.httpData=dataNeed;
        data = [HotVideoModel objectWithKeyValues:_httpData];
        [self.tableView_videoDetails reloadData];
        [self checkIfIsVoted];
        [self checkIfIsFollow];
    } failure:^(NSError *erro) {
        
    }];

}

//关注
- (IBAction)collectAction:(UIButton*)sender {
    BOOL isCollect = [self.httpData[@"isCollect"] boolValue];
    if (!isCollect) {
        NSString * httpUrl = [NSString stringWithFormat:@"%@activeID=%@&userAccount=%@",followVideoServer,data.activeID,[user_info objectForKey:userAccount]];
        [ISQHttpTool getHttp:httpUrl contentType:nil params:nil success:^(id responseObj) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"关注已成功,可以在关注一栏查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObj options:NSJapaneseEUCStringEncoding error:nil];
            NSLog(@"dic attention = %@",dic);
            [self refresh];
            [self.delegate VideoDetailController_forSpringIsFinshedFollow];
            
        } failure:^(NSError *erro) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"关注失败咯，稍后请重新关注" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }];

    }else if (isCollect){
        NSString * httpUrl = [NSString stringWithFormat:@"%@activeID=%@&userAccount=%@",noFollowVideoServer,data.activeID,[user_info objectForKey:userAccount]];
        [ISQHttpTool getHttp:httpUrl contentType:nil params:nil success:^(id responseObj) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"取消关注已成功,该节目已移出关注一栏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObj options:NSJapaneseEUCStringEncoding error:nil];
            NSLog(@"dic attention = %@",dic);
            [self refresh];
            [self.delegate VideoDetailController_forSpringIsFinshedFollow];
            
        } failure:^(NSError *erro) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"取消关注失败咯，稍后请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }];

    }
}

-(void)checkIfIsFollow
{
    BOOL isCollect = [self.httpData[@"isCollect"] boolValue];
    if(!isCollect){//没有关注
        [self.collectButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.collectButton setImage:[UIImage imageNamed:@"clickz"] forState:UIControlStateNormal];
    }else {
        [self.collectButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.collectButton setImage:nil forState:UIControlStateNormal];
    }
}

//投一票
- (IBAction)voteAction:(UIButton*)sender {
//    NSMutableDictionary *Dic = [[NSMutableDictionary alloc] init];
//    Dic[@"activeID"] = data.activeID;

    //获取系统当前时间
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [dateFormatter stringFromDate:senddate];
    
    //约定的key
    NSString *key = @"michae12";
    
    //获取随机字符串
    NSString *randomString = [self ret5bitString];
    
    NSString*stringParams = [NSString stringWithFormat:@"%@CurrentTime=%@;userAccount=%@%@digest=%@",@"name=video_vote;QRAPID=kentop;QRAPName=kentop;",time,[user_info objectForKey:userAccount],@"&",randomString];
    //加密
    ISQCommonFunc *commonfunc = [[ISQCommonFunc alloc] init];
    NSString *text = [commonfunc encryptUseDES:stringParams key:key];
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *token = [data base64Encoding];
    NSString *name = @"video_vote";
    
    NSString *http = [NSString stringWithFormat:@"%@?name=%@&token=%@&activeID=%@",USER_HOT_VOTE,name,token,self.httpData[@"activeID"]];

    [ISQHttpTool post:http contentType:nil params:nil success:^(id responseObj) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"投票已成功,感谢您的投票" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];

        NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObj options:NSJapaneseEUCStringEncoding error:nil];
        NSLog(@"dic vote = %@",dic);
        [self refresh];
        [self.delegate VideoDetailController_forSpringIsFinshedRefresh];
    } failure:^(NSError *error) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"投票失败咯，稍后请重投" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

-(void)checkIfIsVoted
{
    BOOL isVoted = [self.httpData[@"voteRestTime"] boolValue];
    if(!isVoted){//没有投票
        self.voteButton.backgroundColor = [UIColor colorWithRed:51.0/255 green:167.0/255 blue:255.0/255 alpha:1];
        self.voteButton.userInteractionEnabled = true;
        [self.voteButton setTitle:@"我来投一票" forState:UIControlStateNormal];
    }else {
        self.voteButton.backgroundColor = [UIColor lightGrayColor];
        self.voteButton.userInteractionEnabled = false;
        [self.voteButton setTitle:@"已经投票" forState:UIControlStateNormal];
    }
}

//获取5位随机数
- (NSString *)ret5bitString{
    
    char datas[5];
    for (int x=0;x<5;datas[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:datas length:5 encoding:NSUTF8StringEncoding];
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

//评论
-(void)onCommentBtnToComment:(UIButton *)button
{
    NSMutableDictionary *Dic = [[NSMutableDictionary alloc] init];
    Dic[@"activeID"] = data.activeID;

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
