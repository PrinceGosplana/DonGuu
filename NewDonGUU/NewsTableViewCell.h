#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsTableViewCell : UITableViewCell
{
    News * n;
}
@property (weak) News * news;
@property (weak, nonatomic) IBOutlet UILabel *titleNews;
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet UIImageView *imageNews;

@end
