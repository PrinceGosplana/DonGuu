#import "NewsDetailViewController.h"
#import "News.h"
#import "NSString+HTML.h"
#import <FacebookSDK/FacebookSDK.h>

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

@synthesize news;

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

    NSLog(@"Lf %@", news.description );
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\{.+?\\}"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:NULL];
    NSMutableString * str = [[NSMutableString alloc]initWithString:news.descriptionNews];
    
    [regex replaceMatchesInString:str
                          options:0
                            range:NSMakeRange(0, [str length])
                     withTemplate:@""];
    NSLog(@"%@", str);

    
    [self setContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setContent {
    if (!news) {
        return;
    }
    
    UIView * contentView = [[UIView alloc] init];
    
    UIImageView * newsImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
    newsImg.image = [UIImage imageWithData:news.image];
    
    // удаляю из текста строки между тэгами {artsexylightbox  /artsexylightbox}
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\{.+?\\}"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:NULL];
    NSMutableString * str = [[NSMutableString alloc]initWithString:news.descriptionNews];
    
    [regex replaceMatchesInString:str
                          options:0
                            range:NSMakeRange(0, [str length])
                     withTemplate:@""];

    
    UITextView * txtview = [[UITextView alloc]initWithFrame:CGRectMake(0, 220, 320, 200)];
    [txtview setDelegate:self];
    [txtview setReturnKeyType:UIReturnKeyDone];
    [txtview setTag:1];
    [txtview setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [txtview setScrollEnabled:YES];
    txtview.text = [str stringByConvertingHTMLToPlainText];
    [txtview sizeToFit];
    [txtview setScrollEnabled:NO];
    
    CGRect contentRect = CGRectMake(0, 0, 320, txtview.frame.size.height + newsImg.frame.size.height);
    contentView.frame = contentRect;
    
    [contentView addSubview:newsImg];
    [contentView addSubview:txtview];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height)];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.scrollEnabled=YES;
    scrollView.userInteractionEnabled=YES;
    scrollView.delegate = self;
    [scrollView setContentSize:CGSizeMake(320, contentRect.size.height + 64)];
    
    
    [scrollView addSubview:contentView];
    [self.view addSubview:scrollView];
}
- (IBAction)shareBtn:(UIBarButtonItem *)sender {
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:@"https://itunes.apple.com/ua/app/dsum/id609518721?mt=8"];
    params.name = @"ДонГУУ";
    params.caption = @"Build great social apps and get more installs.";
    params.picture = [NSURL URLWithString:@"https://fbexternal-a.akamaihd.net/safe_image.php?d=AQAlXTLT5NzzYRsQ&w=116&h=116&url=http%3A%2F%2Fa2.mzstatic.com%2Fus%2Fr30%2FPurple2%2Fv4%2F31%2F8e%2F3c%2F318e3cf0-785a-094a-5ca4-0c6d4ac28c86%2Fmzl.yjjnbwsq.png&cfs=1"];
    params.description = @"Официальное приложение Донецкого государственного университета управления";
    
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"DonGUU", @"name",
                                       @"Build great social apps and get more installs.", @"caption",
                                       @"Официальное приложение Донецкого государственного университета управления", @"description",
                                       @"https://itunes.apple.com/ua/app/dsum/id609518721?mt=8", @"link",
                                       @"https://fbexternal-a.akamaihd.net/safe_image.php?d=AQAlXTLT5NzzYRsQ&w=116&h=116&url=http%3A%2F%2Fa2.mzstatic.com%2Fus%2Fr30%2FPurple2%2Fv4%2F31%2F8e%2F3c%2F318e3cf0-785a-094a-5ca4-0c6d4ac28c86%2Fmzl.yjjnbwsq.png&cfs=1", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
        
    }
    
}
// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
