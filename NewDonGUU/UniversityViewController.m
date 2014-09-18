//
//  UniversityViewController.m
//  DonGUU
//
//  Created by Administrator on 27.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import "UniversityViewController.h"
#import "MarkdownParser.h"
#import "BookView.h"

@interface UniversityViewController ()
{
    BookView * _bookView;
}

@end

@implementation UniversityViewController

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
    // программно устанавливаю картинку на задний фон
//    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar.png"]
//                                                      forBarMetrics:UIBarMetricsDefault];
        
        // cкрывает navigationBar
//        self.navigationController.navigationBar.hidden = YES;
//        self.navigationController.navigationBar.clipsToBounds = NO;
//}

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 1024, 704)];
        webView.backgroundColor = [UIColor whiteColor];
        NSString *resFolderPath = [[NSBundle mainBundle] resourcePath];
        NSError *err;
        NSString *rectext = [NSString stringWithContentsOfFile:
                             [NSString stringWithFormat: @"%@/univeriPad.txt", resFolderPath] encoding:NSUTF8StringEncoding error:&err];
        [webView loadHTMLString:rectext baseURL:[[NSBundle mainBundle] resourceURL]];

        [self.view addSubview:webView];

    }
    else {
    // парсю данные для текста
        NSString *path = [[NSBundle mainBundle] pathForResource:@"univer" ofType:@"txt"];
        NSString *text = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding error:NULL];
        self.bookMarkup = [[NSAttributedString alloc] initWithString:text];
        
        
        MarkdownParser * parser = [[MarkdownParser alloc] init];
        self.bookMarkup = [parser parseMarkdownFile:path];
        
        self.view.backgroundColor = [UIColor colorWithWhite:0.87f
                                                      alpha:1.0f];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        _bookView = [[BookView alloc] initWithFrame:self.view.bounds];
        _bookView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _bookView.bookMarkup = self.bookMarkup;
        
        [self.view addSubview:_bookView];
        // Do any additional setup after loading the view.
    }

    
    
}

- (void) viewDidLayoutSubviews{
    [_bookView buildFrames];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backTap:(UIBarButtonItem *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
@end
