//
//  RectoratViewController.m
//  NewDonGUU
//
//  Created by Administrator on 27.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import "RectoratViewController.h"
#import "RESideMenu.h"

@interface RectoratViewController ()

@end

@implementation RectoratViewController

@synthesize rectoratWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *resFolderPath = [[NSBundle mainBundle] resourcePath];
    NSError *err;
    NSString *rectext = [NSString stringWithContentsOfFile:
                         [NSString stringWithFormat: @"%@/rect.txt", resFolderPath] encoding:NSUTF8StringEncoding error:&err];
    [rectoratWebView loadHTMLString:rectext baseURL:[[NSBundle mainBundle] resourceURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMenu:(UIBarButtonItem *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
@end
