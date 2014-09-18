//
//  FacultetTableViewCell.m
//  NewDonGUU
//
//  Created by Administrator on 31.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import "FacultetTableViewCell.h"

@implementation FacultetTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setFacultet:(Facultet *)facultet {
    f = facultet;
    self.nameFacultet.text = facultet.name;
    self.logoFacultet.image = [UIImage imageNamed:facultet.logotip];
}

- (Facultet *) facultet {
    return f;
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
