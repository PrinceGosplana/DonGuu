//
//  UniversityViewController.h
//  DonGUU
//
//  Created by Administrator on 27.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface UniversityViewController : UIViewController

@property (nonatomic, copy) NSAttributedString * bookMarkup;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
- (IBAction)backTap:(UIBarButtonItem *)sender;


@end
