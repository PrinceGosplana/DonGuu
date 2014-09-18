#import "SplashViewController.h"
#import "UIImage+SplashScreen.h"
#import "AppDelegate.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
           }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([UIScreen mainScreen].bounds.size.width == 320) {
        UIImage * image = [UIImage imageNamedCustom:@"Default"];
        self.imageView.image = image;
    }
}


@end
