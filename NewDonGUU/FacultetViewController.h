//
//  FacultetViewController.h
//  NewDonGUU
//
//  Created by Administrator on 11.04.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
@class Facultet;

@interface FacultetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
//{
//    NSMutableArray * facultets;
//}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (nonatomic, copy) NSAttributedString * bookMarkup;

- (IBAction)backToMenu:(UIBarButtonItem *)sender;

@end
