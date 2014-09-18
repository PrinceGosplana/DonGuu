//
//  DetailFacultViewController.h
//  NewDonGUU
//
//  Created by Administrator on 29.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@class Facultet;

@interface DetailFacultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, copy) NSAttributedString * bookMarkup;

@property (strong, nonatomic) Facultet * facultet;

@end
