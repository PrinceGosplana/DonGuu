#import "AppDelegate.h"
#import "Facultet.h"
#import "News.h"
#import "MainViewController.h"

#define TIME_START_APP 10

@implementation AppDelegate {
    NSArray * _facultets;
}

@synthesize itemsDictionaryToDisplay; // словарь, где хранится информация, ключ - индекс кнопки минус один из NewsViewControlelr
@synthesize feed; // массив с ссылками но новости с сайта
@synthesize itemsToDisplay;
@synthesize imgArray; // массив с картинками
@synthesize allNews;

- (NSArray *) facultets {
    return _facultets;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    
    [SQBA startWithApiKey:@"ZSEAXEGGOZUVUL83BN4W"];
    // Override point for customization after application launch.
    _facultets = @[
                   [Facultet facultetsWithData:@"Факультет менеджменту" logotip:@"menegement.jpg" description:@"fuck_1"],
                   [Facultet facultetsWithData:@"Факультет державного управлiння" logotip:@"gosupr.jpg" description:@"fuck_2"],
                   [Facultet facultetsWithData:@"Факультет економiки" logotip:@"economika.jpg" description:@"fuck_3"],
                   [Facultet facultetsWithData:@"Облiково-фiнансовий факультет" logotip:@"oia.jpg" description:@"fuck_4"],
                   [Facultet facultetsWithData:@"Факультет права i соцiального управлiння" logotip:@"pravo.jpg" description:@"fuck_5"],
                   [Facultet facultetsWithData:@"Центр пiслядiпломної освiти" logotip:@"poslediplomnoe.jpg" description:@"fuck_6"],
                   [Facultet facultetsWithData:@"Центр довузівської підготовки" logotip:@"dovuzovka.jpg" description:@"fuck_7"],
                   [Facultet facultetsWithData:@"Центр навчання іноземних громадян" logotip:@"inostrannie.jpg" description:@"fuck_8"],
                   ];
    indexNews = 1;
    // style the navigation bar
    UIColor* navColor = [UIColor colorWithRed:0 green:0 blue:1.0f alpha:1.0f];
    [[UINavigationBar appearance] setBarTintColor:navColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
    // make the status bar white
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self startParse];
    self.noConnection = YES;

    // проверка соединения с интернетом
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    status = [reach currentReachabilityStatus];
//    NSLog(@" status %d", status);
    if (0 == status) {
        self.noConnection = NO; // -----------------
        UIViewController * rootViewController = self.window.rootViewController;
        UIStoryboard * storyboard = rootViewController.storyboard;
        UINavigationController * navigationController =
        [storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
        self.window.rootViewController = navigationController;

    }
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Reachability" message:[self stringFromStatus:status] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//
//    
    timerStarnApp = [NSTimer scheduledTimerWithTimeInterval:TIME_START_APP
                                                               target:self
                                                             selector:@selector(timerStartApp)
                                                             userInfo:nil
                                                              repeats:NO];
    return YES;
}

- (NSString *)stringFromStatus:(NetworkStatus)statusCon {
    NSString * string;
    switch (statusCon) {
        case NotReachable:{
            string  = @"Not Reachable";
            // если нет связи - запускаю основное меню
//            UIViewController * rootViewController = self.window.rootViewController;
//            UIStoryboard * storyboard = rootViewController.storyboard;
//            UINavigationController * navigationController =
//            [storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
//            self.window.rootViewController = navigationController;
        }
            break;
        case ReachableViaWiFi:
            string  = @"Reachable via WiFi";
            break;
        case ReachableViaWWAN:
            string  = @"Reachable via WWAN";
            break;
        default:
            string = @"Unknown";
            break;
    }
    return string;
}

- (void) startParse {
    infoCategory = [NSMutableArray arrayWithCapacity:6];
    allNews = [NSMutableArray arrayWithCapacity:50];
    
    // новости с сайта
    formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    parsedItems = [[NSMutableArray alloc] init];
    self.itemsDictionaryToDisplay = [NSMutableDictionary dictionary];

    
    feed = [[NSMutableArray alloc] init];
    
    [feed insertObject:[NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_k2&amp;view=itemlist&amp;layout=category&amp;task=category&amp;id=2&amp;format=feed"] atIndex:0];
    [feed insertObject:[NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_k2&amp;view=itemlist&amp;layout=category&amp;task=category&amp;id=1&amp;format=feed"] atIndex:1];
    [feed insertObject:[NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_k2&amp;view=itemlist&amp;layout=category&amp;task=category&amp;id=6&amp;format=feed"] atIndex:2];
    [feed insertObject:[NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_k2&amp;view=itemlist&amp;layout=category&amp;task=category&amp;id=8&amp;format=feed"] atIndex:3];
    [feed insertObject:[NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_k2&amp;view=itemlist&amp;layout=category&amp;task=category&amp;id=7&amp;format=feed"] atIndex:4];
    [feed insertObject:[NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_k2&amp;view=itemlist&amp;layout=category&amp;task=category&amp;id=5&amp;format=feed"] atIndex:5];


    for (int i = 0; i < [feed count]; i++) {
        feedParser = [[MWFeedParser alloc] initWithFeedURL:[feed objectAtIndex:i]];
        feedParser.delegate = self;
        feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
        feedParser.connectionType = ConnectionTypeAsynchronously;
        [feedParser parse];
    }

}

#pragma mark -
#pragma mark Parsing

// Reset and reparse
- (void)refresh {
	[parsedItems removeAllObjects];
	[feedParser stopParsing];
	[feedParser parse];
}

- (void)updateTableWithParsedItems {
	itemsToDisplay = [parsedItems sortedArrayUsingDescriptors: [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];
    

    if ([itemsToDisplay count]) {
        self.noConnection = NO;
        for (MWFeedItem * item in itemsToDisplay) {
//            NSLog(@"%i - %@", indexNews, item.title);
            NSString * urlImage = [self returnURLimage:item.summary];
            NSURL *url = [NSURL URLWithString:urlImage];
            NSData *data = [NSData dataWithContentsOfURL:url];
            News * n = [[News alloc] initNewsWithData: item.title date: item.date logotip:data description:item.summary indexCategory:[infoCategory lastObject]];
            [allNews addObject:n];
            NSLog(@"n %@", n.indexCategory);
        }
        ++indexNews;
    }
//    else {
//        UIViewController * rootViewController = self.window.rootViewController;
//        UIStoryboard * storyboard = rootViewController.storyboard;
//        UINavigationController * navigationController =
//        [storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
//        self.window.rootViewController = navigationController;
//    }

    
    // 6 - количество категорий новостей, как только получили данные со всех категорий запускаю основной экран
//    if (indexNews >= 7) {
//        self.noConnection = YES; // когда новости заполнены устанавливаю флаг в "нет соединения" и стартует приложение с новыми данными
//        [self startApp];
//    }
}

- (void) timerStartApp {
    if (timerStarnApp != nil)
    {
        [timerStarnApp invalidate];
        timerStarnApp = nil;
        if ( 0 == status ) {
            self.noConnection = NO;
        } else {
            self.noConnection = YES;
        }
        
    }
    if (!self.isAppStart) {
        [self startApp];
    }
}

- (void) startApp {
        // при наличии медленного инета или если сайт не отвечает приложение стартует через 10 сек
//    if (2 == status) {
//        self.noConnection = NO; // -----------------
        self.isAppStart = YES;
        UIViewController * rootViewController = self.window.rootViewController;
        UIStoryboard * storyboard = rootViewController.storyboard;
        UINavigationController * navigationController =
        [storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
        self.window.rootViewController = navigationController;
//    }
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
    [parsedItems removeAllObjects];
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
    [infoCategory addObject:info.title];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
    [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
}

// функция с помощью регулярного выражения из текста возвращает адрес картинки
- (NSString *) returnURLimage: (NSString *) str {
    NSString * search = [str substringWithRange:NSMakeRange(25, 100)];
    NSRegularExpression* regexSearch = [[NSRegularExpression alloc] initWithPattern:@"src\\s*?=\\s*?['\"]((.*?)['\"][\\s\\S]*?)+?" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *textCheckingResultMy = [regexSearch firstMatchInString:search options:0 range:NSMakeRange(0, [search length])];
    NSRange matchRangeMy = [textCheckingResultMy rangeAtIndex:1];
    NSString *matchMy = [search substringWithRange:matchRangeMy];
    // делаю это потому, что не смог доделать регулярное выражение и оно возвращает строку с " на конце, удаляю этот символ
    matchMy = [matchMy substringToIndex:[matchMy length] - 1];
//    NSLog(@"%@", matchMy);
    return matchMy;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   // empty
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
