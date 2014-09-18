//
//  FacultetTableViewCell.h
//  NewDonGUU
//
//  Created by Administrator on 31.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facultet.h"

@interface FacultetTableViewCell : UITableViewCell
{
    Facultet * f;
}

@property (weak) Facultet * facultet;
@property (weak, nonatomic) IBOutlet UIImageView *logoFacultet;
@property (weak, nonatomic) IBOutlet UILabel *nameFacultet;

@end
