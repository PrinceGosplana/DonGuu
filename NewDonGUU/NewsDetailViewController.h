#import <UIKit/UIKit.h>
@class News;

@interface NewsDetailViewController : UIViewController <UITextViewDelegate>

@property (weak) News * news;
//@property (weak, nonatomic) IBOutlet UIImageView *imgView;
//@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)shareBtn:(UIBarButtonItem *)sender;

@end
