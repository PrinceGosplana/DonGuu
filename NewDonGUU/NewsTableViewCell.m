#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setNews:(News *)news {
    n = news;
    self.titleNews.text = news.title;
    self.dateText.text = [NSString stringWithFormat:@"%@",news.date] ;
    self.imageNews.image = [UIImage imageWithData:news.image];
}

- (News *) news {
    return n;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
