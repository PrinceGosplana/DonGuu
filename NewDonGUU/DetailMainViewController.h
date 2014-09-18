//
//  DetailMainViewController.h
//  NewDonGUU
//
//  Created by Administrator on 02.04.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainNews;

@interface DetailMainViewController : UIViewController <UITextViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) MainNews * mainNews;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)backButtonPressed:(UIButton *)sender;

@end
