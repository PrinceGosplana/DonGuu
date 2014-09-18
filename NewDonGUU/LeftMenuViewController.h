//
//  LeftMenuViewController.h
//  NewDonGUU
//
//  Created by Administrator on 27.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface LeftMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>
{
    NSArray *images;
    NSArray *titles;
}
@end
