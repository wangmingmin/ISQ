#import <UIKit/UIKit.h>
#import "DWLog.h"
#import "DWMoviePlayerController.h"

@interface DWCustomPlayerViewController : UIViewController

@property (copy, nonatomic)NSString *videoId;
@property (copy, nonatomic)NSString *videoLocalPath;
@property (copy ,nonatomic)NSString *videoTitle;

@end
