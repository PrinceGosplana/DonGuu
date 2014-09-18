//
//  ContactViewController.m
//  NewDonGUU
//
//  Created by Administrator on 27.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import "ContactViewController.h"
#import "RESideMenu.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.webVIew loadRequest:
         [NSURLRequest requestWithURL:
          [NSURL URLWithString:
           [NSString stringWithFormat:@"%@/iPad.html",
            [[NSBundle mainBundle] resourceURL]]]]];

    }
    else {
        [self.webVIew loadRequest:
     [NSURLRequest requestWithURL:
      [NSURL URLWithString:
       [NSString stringWithFormat:@"%@/iPhone.html",
        [[NSBundle mainBundle] resourceURL]]]]];
    }
    
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
