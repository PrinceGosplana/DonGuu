#import "MainViewController.h"
#import "MWFeedParser.h"
#import "DetailMainViewController.h"
#import "AppDelegate.h"
#import "MainNews.h"
#import "NSString+HTML.h"
#import "MarkdownParser.h"
#import "BookView.h"
#import "RFRateMe.h"

#define COUNT_VIEWS 4
#define kNumberOfDaysUntilShowAgain 14

@interface MainViewController ()

@end

@implementation MainViewController
{
    BookView * _bookView;
}
//@synthesize scrollViewNews;
@synthesize itemsToDisplay, arrayNewsTop;

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
    arrayNewsTop = [NSMutableArray array];
    self.warningImgView.alpha = 0.0f;

    
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"uk_UA"]];
    [formatter setDateFormat:@"d MMMM yyyy, H:mm"];

	parsedItems = [[NSMutableArray alloc] init];
	self.itemsToDisplay = [NSArray array];
    
    // Parse
    NSURL *feedURL = [NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_content&view=category&id=35%3Atop&format=feed&type=rss"];
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeAsynchronously;
	[feedParser parse];
    
    parsedNewsTop = [NSMutableArray array];

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        //create the scrollview with specific frame
        scrollView = [[ALScrollViewPaging alloc] initWithFrame:CGRectMake(0, 64, 700, 704)];
    }
    else {
        scrollView = [[ALScrollViewPaging alloc] initWithFrame:CGRectMake(0, 64, 320, 220)];
         [scrollView addPages:parsedNewsTop];

    }
        //add pages to scrollview
        [self.view addSubview:scrollView];
        [scrollView setHasPageControl:YES];
    
    // задаю данные в uiwebView

        self.webView.delegate = self;
        NSURL *urlStr;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            urlStr = [NSURL URLWithString:@"http://dsum-i-app-wp.byuro.in.ua/?page_id=32"];
            
            
        }
        else  if ([UIScreen mainScreen].bounds.size.height == 568){
            urlStr = [NSURL URLWithString:@"http://dsum-i-app-wp.byuro.in.ua/?page_id=147"];

        } else {
            urlStr = [NSURL URLWithString:@"http://dsum-i-app-wp.byuro.in.ua/?page_id=7"];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:urlStr];
        [self.webView loadRequest:request];
    
    
    //Определяю первую дату запуска программы
    BOOL rateCompleted = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstStart"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if (!rateCompleted ) {
        NSLog(@"First start");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstStart"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //сохраняю день первого запуска программы
        NSDate *now = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:[dateFormatter stringFromDate:now] forKey:@"FirstStartDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        //получаю день первого запуска программы и текущий день
        NSString *start = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstStartDate"];
        NSString *end = [dateFormatter stringFromDate:[NSDate date]];
        
        NSDate *startDate = [dateFormatter dateFromString:start];
        NSDate *endDate = [dateFormatter dateFromString:end];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
        NSLog(@"day before first start %ld", (long)[components day]);
        
        //если более 14 дней разницы (kNumberOfDaysUntilShowAgain), то прошу нас лайкнуть
        
        if ((long)[components day] >= kNumberOfDaysUntilShowAgain){
            [RFRateMe showRateAlert];
        }
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"page is loading");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finished loading");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><font size=-1 color='red'>An error occurred:<br>%@</font></center></html>",
							 error.localizedDescription];
	[self.webView loadHTMLString:errorString baseURL:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showLeftMenu:(UIBarButtonItem *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (void)updateTableWithParsedItems {
	self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
						   [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];

    if ([self.itemsToDisplay count]) {
        [arrayNewsTop removeAllObjects];
        // в массив заношу только первые 4 новости
        for (int i = 0; i < COUNT_VIEWS; ++i) {
            MWFeedItem *item = [self.itemsToDisplay objectAtIndex:i];
            if (item) {
                NSString * urlImage = [self returnURLimage:item.summary];
                NSURL *url = [NSURL URLWithString:urlImage];
                NSData *data = [NSData dataWithContentsOfURL:url];
                MainNews * mainNews = [[MainNews alloc] init];
                mainNews.title = item.title;
                mainNews.date = item.date;
                mainNews.image = data;
                
                // удаляю из текста строки между тэгами {artsexylightbox  /artsexylightbox}
                NSRegularExpression *regex = [NSRegularExpression
                                              regularExpressionWithPattern:@"\\{.+?\\}"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:NULL];
                NSMutableString * str = [[NSMutableString alloc]initWithString:item.summary];
                
                [regex replaceMatchesInString:str
                                      options:0
                                        range:NSMakeRange(0, [str length])
                                 withTemplate:@""];

                mainNews.description = [str stringByConvertingHTMLToPlainText];
                [arrayNewsTop addObject:mainNews];
            }
        }
        // если заполнен - сохраняю в память
            [self saveTuMemory:arrayNewsTop];
        
    }
    else {
        // если нет данных с инета заполняю из памяти
        [arrayNewsTop addObjectsFromArray: [self loadFromMemory]];
    }
        
    // заполняю MainViewController данными
    if ([arrayNewsTop count]) {
            for (int i = 0; i < COUNT_VIEWS; ++i) {
         MainNews * mainNews = [arrayNewsTop objectAtIndex:i];
        if (mainNews) {
            // создаю UIScrollView и заполняю его материалом
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                UIImage *img = [[UIImage alloc] initWithData:mainNews.image];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 700, 704)];
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 700, 500)];

                imageView.image = img;
                [view addSubview:imageView];
                
                view.userInteractionEnabled = YES;
                
                view.tag = i;
                
                UITapGestureRecognizer * tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNewsLink:)];
                [view addGestureRecognizer:tapImage];
                [parsedNewsTop addObject:view];
                
                UIImageView * hover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 500, 700, 204)];
                hover.backgroundColor = [UIColor blueColor];
                hover.alpha = 0.8f;
                [view addSubview:hover];
                
                UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 500, 660, 204)];
                titleLabel.text = mainNews.title;
                [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:34]];
                [titleLabel setTextAlignment:NSTextAlignmentCenter];
                [titleLabel setTextColor:[UIColor whiteColor]];
                titleLabel.numberOfLines = 0;
                [view addSubview:titleLabel];// The device is an iPhone or iPod touch.
                
            }
            else
            {
                UIImage *img = [[UIImage alloc] initWithData:mainNews.image];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
                imageView.image = img;
                [view addSubview:imageView];
                
                UIImageView * imageViewHover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
                imageViewHover.image = [UIImage imageNamed:@"hover.png"];
                [view addSubview:imageViewHover];
                view.userInteractionEnabled = YES;
                
                view.tag = i;
                
                UITapGestureRecognizer * tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNewsLink:)];
                [view addGestureRecognizer:tapImage];
                [parsedNewsTop addObject:view];
                
                UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 60)];
                titleLabel.text = mainNews.title;
                [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
                [titleLabel setTextAlignment:NSTextAlignmentCenter];
                [titleLabel setTextColor:[UIColor whiteColor]];
                titleLabel.numberOfLines = 0;
                [view addSubview:titleLabel];// The device is an iPhone or iPod touch.
                
                


            }
        }
    }
    }

    [scrollView addPages:parsedNewsTop];
    
    [scrollView setHasPageControl:YES];
}

// метод убрал, при его добавлении будет два скрола - картинка и текст
- (void) setContentByIndex:(int) index {
    if (textMainNews != nil) {
        [textMainNews removeFromSuperview];
    }
    MainNews * mainNews = [arrayNewsTop objectAtIndex:index];

    // удаляю из текста строки между тэгами {artsexylightbox  /artsexylightbox}
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\{.+?\\}"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:NULL];
    NSMutableString * str = [[NSMutableString alloc]initWithString:mainNews.description];
    
    [regex replaceMatchesInString:str
                          options:0
                            range:NSMakeRange(0, [str length])
                     withTemplate:@""];

    
    textMainNews = [[UITextView alloc]initWithFrame:CGRectMake(0, 400, 580, 304)];
    [textMainNews setDelegate:self];
    [textMainNews setReturnKeyType:UIReturnKeyDone];
    [textMainNews setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [textMainNews setScrollEnabled:YES];
    textMainNews.text = str;
    [textMainNews sizeToFit];
    [textMainNews setScrollEnabled:NO];
    
    contView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 580, scrollView.frame.size.height + textMainNews.frame.size.height)];
    [contView addSubview:scrollView];
    [contView addSubview:textMainNews];

    
    scrV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 580, 704)];
    scrV.showsVerticalScrollIndicator = YES;
    scrV.scrollEnabled=YES;
    scrV.userInteractionEnabled=YES;
    scrV.delegate = self;
    [scrV setContentSize:contView.frame.size];
    
    [scrV addSubview:contView];
    [self.view addSubview:scrV];
}


// сохраняет данные в память
- (void) saveTuMemory: (NSArray *)arr {
// созадю массивы для дальнейшего сохранения в память
    NSMutableArray * titileArray = [[NSMutableArray alloc] initWithCapacity:4];
    NSMutableArray * dateArray = [[NSMutableArray alloc] initWithCapacity:4];
    NSMutableArray * imageDataArray = [[NSMutableArray alloc] initWithCapacity:4];
    NSMutableArray * descriptionArray = [[NSMutableArray alloc] initWithCapacity:4];

    // заполняю массивы данными
    for (MainNews * news in arr) {
        // проверка на принадлежность классу MainNews
        if ([news isKindOfClass:[MainNews class]]) {
            [titileArray addObject:news.title];
            [dateArray addObject:news.date];
            [imageDataArray addObject:news.image];
            [descriptionArray addObject:news.description];
        }
    }

// сохраняю в память
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:titileArray forKey:@"titileArray"];
    [defs setObject:dateArray forKey:@"dateArray"];
    [defs setObject:imageDataArray forKey:@"imageDataArray"];
    [defs setObject:descriptionArray forKey:@"descriptionArray"];
    [defs synchronize];
    NSLog(@"Successfully saved");
}

// загружает данные из памяти
- (NSMutableArray *) loadFromMemory {
    
    NSMutableArray * returnNews = [[NSMutableArray alloc]initWithCapacity:4];
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    // созадю массивы, заполняя из памяти
    NSArray * titileArray = [[NSArray alloc] initWithArray:[defs arrayForKey:@"titileArray"]];
    NSArray * dateArray = [[NSArray alloc] initWithArray:[defs arrayForKey:@"dateArray"]];
    NSArray * imageDataArray = [[NSArray alloc] initWithArray:[defs arrayForKey:@"imageDataArray"]];
    NSArray * descriptionArray = [[NSArray alloc] initWithArray:[defs arrayForKey:@"descriptionArray"]];
    
       // заполняю массив объектом Новости
    [titileArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MainNews * mainNews = [[MainNews alloc] init];
        mainNews.title = titileArray[idx];
        mainNews.date = dateArray[idx];
        mainNews.image = imageDataArray[idx];
        mainNews.description = descriptionArray[idx];
        [returnNews addObject:mainNews];
    }];
//    NSLog(@"Successfully load");

    return returnNews;
}


- (void) tapNewsLink:(UITapGestureRecognizer *)sender {
//    NSLog(@"tag %i", sender.view.tag);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        DetailMainViewController * myDVC = (DetailMainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"detailMainViewController"];
        MainNews * mainNews = [arrayNewsTop objectAtIndex:sender.view.tag];
        [myDVC setMainNews:mainNews];
        [self presentViewController:myDVC animated:YES completion:nil];
}
    else {
//        [self pushNewController:sender.view.tag];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        DetailMainViewController * myDVC = (DetailMainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"detailMainViewController"];
        MainNews * mainNews = [arrayNewsTop objectAtIndex:sender.view.tag];
        [myDVC setMainNews:mainNews];
        [self presentViewController:myDVC animated:YES completion:nil];

    }
    
}

// функция с помощью регулярного выражения из текста возвращает адрес картинки
- (NSString *) returnURLimage: (NSString *) str {
    NSRegularExpression* regexSearch = [[NSRegularExpression alloc] initWithPattern:@"src\\s*?=\\s*?['\"]((.*?)['\"][\\s\\S]*?)+?" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *textCheckingResultMy = [regexSearch firstMatchInString:str options:0 range:NSMakeRange(0, str.length)];
    NSRange matchRangeMy = [textCheckingResultMy rangeAtIndex:1];
    NSString *matchMy = [str substringWithRange:matchRangeMy];
    // делаю это потому, что не смог доделать регулярное выражение и оно возвращает строку с " на конце, удаляю этот символ
    matchMy = [matchMy substringToIndex:[matchMy length] - 1];
    return matchMy;
}

#pragma mark - UIWebview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
//	NSLog(@"Parsed Feed Info: “%@”", info.title);
	self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    //	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
//	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
    
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
//        [self updateTableWithParsedItems];
        self.warningImgView.alpha = 1.0f;

    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateTableWithParsedItems];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
@end
