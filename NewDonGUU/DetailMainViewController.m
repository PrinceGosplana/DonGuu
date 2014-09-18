//
//  DetailMainViewController.m
//  NewDonGUU
//
//  Created by Administrator on 02.04.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import "DetailMainViewController.h"
#import "MainNews.h"
#import "NSString+HTML.h"
//#import "H"
@interface DetailMainViewController ()

@end

@implementation DetailMainViewController

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
    [self setContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setContent {
    if (! self.mainNews) {
        return;
    }
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIView * contentView = [[UIView alloc] init];
        
        UIImageView * newsImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 512, 400)];
        newsImg.image = [UIImage imageWithData:self.mainNews.image];
        [self.view addSubview:newsImg];
        
        UITextView * txtview = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 512, 704)];
        [txtview setDelegate:self];
        [txtview setReturnKeyType:UIReturnKeyDone];
        [txtview setTag:1];
        [txtview setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        [txtview setScrollEnabled:YES];
        txtview.text = self.mainNews.description;
        [txtview sizeToFit];
        [txtview setScrollEnabled:NO];

        CGRect contentRect = CGRectMake(0, 0, 512, txtview.frame.size.height);
        contentView.frame = contentRect;

        [contentView addSubview:txtview];

        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(512, 64, 512, 704)];
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.scrollEnabled=YES;
        scrollView.userInteractionEnabled=YES;
        scrollView.delegate = self;
        [scrollView setContentSize:CGSizeMake(512, contentRect.size.height)];
        
        
        [scrollView addSubview:contentView];
        [self.view addSubview:scrollView];

        self.titleLabel.text = self.mainNews.title;
    }
    else {
        UIView * contentView = [[UIView alloc] init];
        
        UIImageView * newsImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
        newsImg.image = [UIImage imageWithData:self.mainNews.image];
        
        UITextView * txtview = [[UITextView alloc]initWithFrame:CGRectMake(0, 220, 320, 200)];
        [txtview setDelegate:self];
        [txtview setReturnKeyType:UIReturnKeyDone];
        [txtview setTag:1];
        [txtview setFont:[UIFont fontWithName:@"Helvetica" size:18]];
        [txtview setScrollEnabled:YES];
        txtview.text = self.mainNews.description;
        [txtview sizeToFit];
        [txtview setScrollEnabled:NO];
        
        CGRect contentRect = CGRectMake(0, 0, 320, txtview.frame.size.height + newsImg.frame.size.height);
        contentView.frame = contentRect;
        
        [contentView addSubview:newsImg];
        [contentView addSubview:txtview];
        
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height)];
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.scrollEnabled=YES;
        scrollView.userInteractionEnabled=YES;
        scrollView.delegate = self;
        [scrollView setContentSize:CGSizeMake(320, contentRect.size.height + 64)];
        
        
        [scrollView addSubview:contentView];
        [self.view addSubview:scrollView];

    }
}


- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
