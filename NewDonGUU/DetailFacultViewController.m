#import "DetailFacultViewController.h"
#import "Facultet.h"
#import "MarkdownParser.h"
#import "BookView.h"

@interface DetailFacultViewController ()
{
    BookView * _bookView;
}
@end

@implementation DetailFacultViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // парсю данные для текста
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
//        [self.webView loadRequest:
//         [NSURLRequest requestWithURL:
//          [NSURL URLWithString:
//           [NSString stringWithFormat:@"%@ipad/duf/index.html",
//            [[NSBundle mainBundle] resourceURL]]]]];
//        NSLog(@"%@", [NSString stringWithFormat:@"%@ipad/duf/index.html",  [[NSBundle mainBundle] resourceURL]]);
        
//        NSString * path = [NSString stringWithFormat:@"%@1", self.facultet.description];
//        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:path ofType:@"html"];
//        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
//        [self.webView loadHTMLString:htmlString baseURL:nil];
        
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                                                              pathForResource:path ofType:@"html"]isDirectory:NO]]];
//        NSString *resFolderPath = [[NSBundle mainBundle] resourcePath];
//        NSString * path = [NSString stringWithFormat:@"%@1", self.facultet.description];
//        NSError *err;
//        NSString *rectext = [NSString stringWithContentsOfFile:
//                             [NSString stringWithFormat: @"%@/%@.txt", resFolderPath, path] encoding:NSUTF8StringEncoding error:&err];
//        [self.webView loadHTMLString:rectext baseURL:[[NSBundle mainBundle] resourceURL]];

        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:self.facultet.description withExtension:@"html"]];
        [self.webView loadRequest:requestObj];
        
//        NSString *path = [NSString stringWithFormat:@"%@.html", self.facultet.description];// [[NSBundle mainBundle] pathForResource:self.facultet.description ofType:@"html"];
//        NSLog(@"%@", path);
//        [self.webView loadRequest:
//         [NSURLRequest requestWithURL:
//          [NSURL URLWithString:
//           [NSString stringWithFormat:@"%@ipad/duf/index.html",
//            [[NSBundle mainBundle] resourceURL]]]]];
    }
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.facultet.description ofType:@"txt"];
        NSString *text = [NSString stringWithContentsOfFile:path  encoding:NSUTF8StringEncoding error:NULL];
        self.bookMarkup = [[NSAttributedString alloc] initWithString:text];
        
        MarkdownParser * parser = [[MarkdownParser alloc] init];
        self.bookMarkup = [parser parseMarkdownFile:path];
        
        self.textView.backgroundColor = [UIColor colorWithWhite:0.87f
                                                      alpha:1.0f];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        _bookView = [[BookView alloc] initWithFrame:self.view.bounds];
        _bookView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _bookView.bookMarkup = self.bookMarkup;
        
        [self.textView addSubview:_bookView];
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

@end
