//
//  NewsViewController.m
//  DonGUU
//
//  Created by Administrator on 27.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "AppDelegate.h"
#import "FlipAnimationController.h"
#import <FacebookSDK/FacebookSDK.h>

#define MIN_COUNT_NEWS 30

@interface NewsViewController ()<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@end

@implementation NewsViewController
{
    FlipAnimationController *_flipAnimationController;
}

@synthesize itemsToDisplay, feed;
@synthesize scrollNavigation;

- (NSInteger) numberOfMenuItems {
    return [_items count];
}

- (NSString *) titleOfMenuByIndex:(int)i {
    return [_items objectAtIndex:i];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _flipAnimationController = [FlipAnimationController new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // массив, где хранятся картинки
    imgArray = [NSMutableArray arrayWithCapacity:5];

    [self.activityIndicator stopAnimating];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"uk_UA"]];
    [formatter setDateFormat:@"d MMMM yyyy, H:mm"];

    refreshControll = [[UIRefreshControl alloc] init];
    refreshControll.tintColor = [UIColor blueColor];
    [refreshControll addTarget:self action:@selector(updateTableData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControll];
    
    // массив задает назвния категорий новостей в нижнем скроле
     _items = @[@"Усi новини", @"Наука", @"Навчання", @"Мiжнародне спiвробiтництво", @"Студентське самоврядування", @"Спорт", @"Виховна робота"];
    
    self.title = [NSString stringWithFormat:@"%@", [_items firstObject]];
    parsedNews = [NSArray arrayWithArray:((AppDelegate *)[[UIApplication sharedApplication] delegate]).allNews]; // получаю данные из делегата
    _haveConnect = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).noConnection;

    // передаю в массив отсортированные по дате новости
    feed = [parsedNews sortedArrayUsingDescriptors:
                      [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]]; // сортирую по дате создания
    
    // инициализирую массив, в который передаю данные от парсера
    itemsToDisplay = [[NSMutableArray alloc] initWithCapacity:40];
    if ([feed count]) {
        // если есть инет и данные получены сохраняю их в память и удалив заполняю массив отображаемых новостей заново
        if ([feed count] > MIN_COUNT_NEWS) {
            [self saveTuMemory:feed];
        }
        
        [itemsToDisplay removeAllObjects];
        [itemsToDisplay addObjectsFromArray:feed];
    }
    else {
        // если данные с инета не получены получаю их из памяти
        feed = [NSArray arrayWithArray:[self loadFromMemory]];
        [itemsToDisplay addObjectsFromArray:feed];
    }
    self.navigationController.delegate = self;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // при старте сразу отображаю все новости и вывожу первую новость в списке справа на экране
        [self setContentByIndex:0];
    }
    infoCategory = [NSMutableArray arrayWithCapacity:6];
    allNews = [NSMutableArray arrayWithCapacity:40];
}

#pragma mark - Work with memory

// сохраняет данные в память
- (void) saveTuMemory: (NSArray *)arr {
    // созадю массивы для дальнейшего сохранения в память
    NSMutableArray * titileArray = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray * dateArray = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray * imageDataArray = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray * descriptionArray = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray * indexArray = [[NSMutableArray alloc] initWithCapacity:50];

    // заполняю массивы данными
    for (News * news in arr) {
        // проверка на принадлежность классу MainNews
        if ([news isKindOfClass:[News class]]) {
            [titileArray addObject:news.title];
            [dateArray addObject:news.date];
            [imageDataArray addObject:news.image];
            [descriptionArray addObject:news.description];
            [indexArray addObject:news.indexCategory];
            NSLog(@"news  %@", news.indexCategory);
        }
    }
    
    // сохраняю в память
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:titileArray forKey:@"titileNews"];
    [defs setObject:dateArray forKey:@"dateNews"];
    [defs setObject:imageDataArray forKey:@"imageDataNews"];
    [defs setObject:descriptionArray forKey:@"descriptionNews"];
    [defs setObject:indexArray forKey:@"indexNews"];
    [defs synchronize];
    NSLog(@"Successfully saved news");
}

// загружает данные из памяти
- (NSMutableArray *) loadFromMemory {
    
    NSMutableArray * returnNews = [[NSMutableArray alloc]initWithCapacity:6];
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    // созадю массивы, заполняя из памяти
    NSArray * titileArray = [[NSArray alloc] initWithArray:[defs arrayForKey:@"titileNews"]];
    NSArray * dateArray = [[NSArray alloc] initWithArray:[defs arrayForKey:@"dateNews"]];
    NSArray * imageDataArray = [[NSArray alloc] initWithArray:[defs arrayForKey:@"imageDataNews"]];
    NSArray * descriptionArray = [[NSArray alloc] initWithArray:[defs arrayForKey:@"descriptionNews"]];
    NSArray * indexArray = [[NSArray alloc] initWithArray:[defs arrayForKey:@"indexNews"]];

    // заполняю массив объектом Новости
    [titileArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        News * news = [[News alloc] init];
        news.title = titileArray[idx];
        news.date = dateArray[idx];
        news.image = imageDataArray[idx];
        news.description = descriptionArray[idx];
        news.indexCategory = indexArray[idx];
        [returnNews addObject:news];
    }];
    NSLog(@"Successfully load news");
    
    return returnNews;
}


#pragma mark - UINavigationControllerDelegate
// переход для iPhone
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {

    _flipAnimationController.reverse = operation == UINavigationControllerOperationPop;
    return _flipAnimationController;
}


- (NSString *) scrollView:(SBScrollNavigation *)scrollView titleForMenuIndex:(NSInteger) index {
    return [NSString stringWithFormat:@"Button %d",index];
}
- (void) scrollView:(SBScrollNavigation *)scrollView menuItemSelectedAtIndex:(NSInteger) index {
// выбор фильтра новостей
    [itemsToDisplay removeAllObjects];
    NSPredicate * predicate;
    switch (index) {
        case 0:
            // Все новости
            itemsToDisplay = [NSMutableArray arrayWithArray:feed];
            self.title = @"Усi новини";
            indexNews = 0;
            break;
        case 1:
           // Наука
            predicate = [NSPredicate predicateWithFormat:@"indexCategory = 'Наука'"];
            [itemsToDisplay addObjectsFromArray:[feed filteredArrayUsingPredicate:predicate]];
            self.title = @"Наука";
            indexNews = 1;
            break;
        case 2:
          // Учеба
            predicate = [NSPredicate predicateWithFormat:@"indexCategory = 'Навчання'"];
            [itemsToDisplay addObjectsFromArray:[feed filteredArrayUsingPredicate:predicate]];
            self.title = @"Навчання";
            indexNews = 2;
            break;
        case 3:
           // Международное сотрудничество
            predicate = [NSPredicate predicateWithFormat:@"indexCategory = 'Міжнародне співробітництво'"];
            [itemsToDisplay addObjectsFromArray:[feed filteredArrayUsingPredicate:predicate]];
            self.title = @"Мiжнародне спiвробiтництво";
            indexNews = 3;
            break;
        case 4:
           // Студенческое
            predicate = [NSPredicate predicateWithFormat:@"indexCategory = 'Студентське самоврядування'"];
            [itemsToDisplay addObjectsFromArray:[feed filteredArrayUsingPredicate:predicate]];
            self.title = @"Студентське самоврядування";
            indexNews = 4;
            break;
        case 5:
            // Спорт
            predicate = [NSPredicate predicateWithFormat:@"indexCategory = 'Спорт'"];
            [itemsToDisplay addObjectsFromArray:[feed filteredArrayUsingPredicate:predicate]];
            self.title = @"Спорт";
            indexNews = 5;
            break;
        case 6:
            // Воспитательная
            predicate = [NSPredicate predicateWithFormat:@"indexCategory = 'Виховна робота'"];
            [itemsToDisplay addObjectsFromArray:[feed filteredArrayUsingPredicate:predicate]];
            self.title = @"Виховна робота";
            indexNews = 6;
            break;
        default:
            break;
    }

    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Parsing

- (void) startParse {

    // новости с сайта
    formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    parsedItems = [[NSMutableArray alloc] init];
    [feedParser stopParsing];

    
    feedNews = [[NSMutableArray alloc] init];
    
    [feedNews insertObject:[NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_k2&amp;view=itemlist&amp;layout=category&amp;task=category&amp;id=2&amp;format=feed"] atIndex:0];
    [feedNews insertObject:[NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_k2&amp;view=itemlist&amp;layout=category&amp;task=category&amp;id=1&amp;format=feed"] atIndex:1];
    [feedNews insertObject:[NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_k2&amp;view=itemlist&amp;layout=category&amp;task=category&amp;id=6&amp;format=feed"] atIndex:2];
    [feedNews insertObject:[NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_k2&amp;view=itemlist&amp;layout=category&amp;task=category&amp;id=8&amp;format=feed"] atIndex:3];
    [feedNews insertObject:[NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_k2&amp;view=itemlist&amp;layout=category&amp;task=category&amp;id=7&amp;format=feed"] atIndex:4];
    [feedNews insertObject:[NSURL URLWithString:@"http://dsum.edu.ua/index.php?option=com_k2&amp;view=itemlist&amp;layout=category&amp;task=category&amp;id=5&amp;format=feed"] atIndex:5];
    
    for (int i = 0; i < [feedNews count]; i++) {
        feedParser = [[MWFeedParser alloc] initWithFeedURL:[feedNews objectAtIndex:i]];
        feedParser.delegate = self;
        feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
        feedParser.connectionType = ConnectionTypeAsynchronously;
        [feedParser parse];
    }
    
}

// Reset and reparse
- (void)refresh {
    if (_haveConnect) {
        self.title = @"Refreshing...";

        [allNews removeAllObjects];

    [self startParse];
        //
        self.tableView.userInteractionEnabled = NO;
        self.tableView.alpha = 0.3;
        [self.activityIndicator startAnimating];
        NSLog(@"-------------------------- Refresh -------------------------");
    }
}

//- (void) backgroundThread {
//    [self startParse];
//    
//	self.tableView.userInteractionEnabled = NO;
//	self.tableView.alpha = 0.3;
//    [self.activityIndicator startAnimating];
//    NSLog(@"-------------------------- Refresh -------------------------");
//
//}
//- (void)updateTableWithParsedItems {
//	self.arrayNewsWithIdexButton=   [parsedItems sortedArrayUsingDescriptors:
//						   [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];
////    [self.itemsToDisplay removeAllObjects];
////    [imgArray removeAllObjects];
////    [self.itemsToDisplay addObjectsFromArray:self.arrayNewsWithIdexButton];
//    self.tableView.userInteractionEnabled = YES;
//
//    
//    // загружаю изображения в массив
//    for (MWFeedItem *item in itemsToDisplay) {
//        NSString * urlImage = [self returnURLimage:item.summary];
//        NSURL *url = [NSURL URLWithString:urlImage];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *img = [[UIImage alloc] initWithData:data];
//        [imgArray addObject:img];
//    }
//    
//	[self.tableView reloadData];
//    NSLog(@"updateTableWithParsedItems");
//}

// функция с помощью регулярного выражения из текста возвращает адрес картинки
- (NSString *) returnURLimage: (NSString *) str {
//    NSLog(@"%@", str);
    NSRegularExpression* regexSearch = [[NSRegularExpression alloc] initWithPattern:@"src\\s*?=\\s*?['\"]((.*?)['\"][\\s\\S]*?)+?" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *textCheckingResultMy = [regexSearch firstMatchInString:str options:0 range:NSMakeRange(25, 150)]; // проверяю от 25 до 150 символа, т.к. в этом диапазоне есть ссылка на картинку
    NSRange matchRangeMy = [textCheckingResultMy rangeAtIndex:1];
    NSString *matchMy = [str substringWithRange:matchRangeMy];
    // делаю это потому, что не смог доделать регулярное выражение и оно возвращает строку с " на конце, удаляю этот символ
    matchMy = [matchMy substringToIndex:[matchMy length] - 1];
    return matchMy;
}

#pragma mark - Start new parsing

- (void)updateTableWithParsedItems {
//    [parsedItems removeAllObjects];
//    [itemsToDisplay removeAllObjects];
    newItemsToDisplay = [parsedItems sortedArrayUsingDescriptors: [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];
    
    
    if ([newItemsToDisplay count]) {
        for (MWFeedItem * item in newItemsToDisplay) {
            //            NSLog(@"%i - %@", indexNews, item.title);
            NSString * urlImage = [self returnURLimage:item.summary];
            NSURL *url = [NSURL URLWithString:urlImage];
            NSData *data = [NSData dataWithContentsOfURL:url];
            News * n = [[News alloc] initNewsWithData: item.title date: item.date logotip:data description:item.summary indexCategory:[infoCategory lastObject]];
            [allNews addObject:n];
        }
    }
    feed = [allNews sortedArrayUsingDescriptors:
            [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]]; // сортирую по дате создания
    [itemsToDisplay addObjectsFromArray:feed];
    [self updateDispayView:indexNews];
}

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
    self.tableView.userInteractionEnabled = YES;

    self.tableView.alpha = 1.0f;
    [self.activityIndicator stopAnimating];
    
//    [backgroundThread cancel];
}

// метод вызываю после обновления новостей, чтобы задать категорию отображаемых новостей
- (void) updateDispayView:(NSInteger) index {
    // выбор фильтра новостей
    [itemsToDisplay removeAllObjects];
    NSPredicate * predicate;
    switch (index) {
        case 0:
            // Все новости
            itemsToDisplay = [NSMutableArray arrayWithArray:feed];
            self.title = @"Усi новини";
            break;
        case 1:
            // Наука
            predicate = [NSPredicate predicateWithFormat:@"indexCategory = 'Наука'"];
            [itemsToDisplay addObjectsFromArray:[feed filteredArrayUsingPredicate:predicate]];
            self.title = @"Наука";
            break;
        case 2:
            // Учеба
            predicate = [NSPredicate predicateWithFormat:@"indexCategory = 'Навчання'"];
            [itemsToDisplay addObjectsFromArray:[feed filteredArrayUsingPredicate:predicate]];
            self.title = @"Навчання";
            break;
        case 3:
            // Международное сотрудничество
            predicate = [NSPredicate predicateWithFormat:@"indexCategory = 'Міжнародне співробітництво'"];
            [itemsToDisplay addObjectsFromArray:[feed filteredArrayUsingPredicate:predicate]];
            self.title = @"Мiжнародне спiвробiтництво";
            break;
        case 4:
            // Студенческое
            predicate = [NSPredicate predicateWithFormat:@"indexCategory = 'Студентське самоврядування'"];
            [itemsToDisplay addObjectsFromArray:[feed filteredArrayUsingPredicate:predicate]];
            self.title = @"Студентське самоврядування";
            [self.activityIndicator stopAnimating];
            break;
        case 5:
            // Спорт
            predicate = [NSPredicate predicateWithFormat:@"indexCategory = 'Спорт'"];
            [itemsToDisplay addObjectsFromArray:[feed filteredArrayUsingPredicate:predicate]];
            self.title = @"Спорт";
            break;
        case 6:
            // Воспитательная
            predicate = [NSPredicate predicateWithFormat:@"indexCategory = 'Виховна робота'"];
            [itemsToDisplay addObjectsFromArray:[feed filteredArrayUsingPredicate:predicate]];
            self.title = @"Виховна робота";
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}













#pragma mark -
#pragma mark Table view data source


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemsToDisplay.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"CellNews";

    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    News * news = [itemsToDisplay objectAtIndex:indexPath.row];
    
    // [parsedNews objectAtIndex:indexPath.row];// [self.arrayNewsWithIdexButton objectAtIndex:indexPath.row];
	if (news) {
		
		// Process
		NSString *itemTitle = news.title ? [news.title stringByConvertingHTMLToPlainText] : @"[No Title]";
		// Set
		cell.titleNews.font = [UIFont boldSystemFontOfSize:15];
		cell.titleNews.text = itemTitle;
		NSMutableString *subtitle = [NSMutableString string];
		if (news.date) [subtitle appendFormat:@"%@", [formatter stringFromDate:news.date]];
		cell.dateText.text = subtitle;
        cell.imageNews.image = [UIImage imageWithData:news.image];
	}
    NSLog(@"index %i", indexPath.row);
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"newsDetail"]) {
        // find the tapped cat
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        News * news = [itemsToDisplay objectAtIndex:indexPath.row];
        
        // provide this to the detail view
        [[segue destinationViewController] setNews:news];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index %i",  (int)indexPath.row);
    [self setContentByIndex:(int)indexPath.row];
    
}

- (IBAction)backToMenu:(UIBarButtonItem *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

//- (IBAction)selectCategoryNews:(UIButton *)sender {
//    curentCategoryNews = sender.tag;
//    [self.tableView reloadData];
//}

- (void) setContent: (int) index {

    News * news = [itemsToDisplay objectAtIndex:index];
    [self.textView setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [self.textView setScrollEnabled:YES];
    self.textView.text = [[news description] stringByConvertingHTMLToPlainText];
    [self.textView sizeToFit];
    [self.textView setScrollEnabled:NO];

    [self.contentView addSubview:self.textView];
    
    self.myScrollView.showsVerticalScrollIndicator = YES;
    self.myScrollView.delegate = self;
    self.myScrollView.scrollEnabled = YES;
    self.myScrollView.userInteractionEnabled = YES;
    [self.myScrollView setContentSize:self.textView.frame.size];
}

- (void) setContentByIndex:(int) index {
    if (textMainNews != nil) {
        [textMainNews removeFromSuperview];
    }
    News * news = [itemsToDisplay objectAtIndex:index];
    
    // удаляю из текста строки между тэгами {artsexylightbox  /artsexylightbox}
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\{.+?\\}"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:NULL];
    NSMutableString * str = [[NSMutableString alloc]initWithString:news.description];
    
    [regex replaceMatchesInString:str
                          options:0
                            range:NSMakeRange(0, [str length])
                     withTemplate:@""];
    // устанавливаю картинку новости в верхней части
    UIImageView * imgNews = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 512, 400)];
    UIImage * img = [UIImage imageWithData:news.image];
    imgNews.image = img;
    
    // текст новости снизу картинки
    textMainNews = [[UITextView alloc]initWithFrame:CGRectMake(0, imgNews.frame.size.height, 512, 654)];
    [textMainNews setDelegate:self];
    [textMainNews setReturnKeyType:UIReturnKeyDone];
    [textMainNews setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [textMainNews setScrollEnabled:YES];
    textMainNews.text = [str stringByConvertingHTMLToPlainText];;
    [textMainNews sizeToFit];
    [textMainNews setScrollEnabled:NO];
    
    // задаю контейнер для отображения новости
    contView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 512, imgNews.frame.size.height + textMainNews.frame.size.height)];
    [contView addSubview:imgNews];
    [contView addSubview:textMainNews];
    
    
    scrV = [[UIScrollView alloc] initWithFrame:CGRectMake(512, 64, 512, 654)];
    scrV.showsVerticalScrollIndicator = YES;
    scrV.scrollEnabled=YES;
    scrV.userInteractionEnabled=YES;
    scrV.delegate = self;
    [scrV setContentSize:contView.frame.size];
    
    [scrV addSubview:contView];
    [self.view addSubview:scrV];
    
}

#pragma mark - End refreshing
- (void) updateTableData {
    [self refresh];
    
    [self.tableView reloadData];
    [refreshControll endRefreshing];
}

#pragma mark - Share to Facebook
- (IBAction)shareBtnPressed:(UIBarButtonItem *)sender {
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:@"https://itunes.apple.com/ua/app/dsum/id609518721?mt=8"];
    params.name = @"ДонГУУ";
    params.caption = @"Build great social apps and get more installs.";
    params.picture = [NSURL URLWithString:@"https://fbexternal-a.akamaihd.net/safe_image.php?d=AQAlXTLT5NzzYRsQ&w=116&h=116&url=http%3A%2F%2Fa2.mzstatic.com%2Fus%2Fr30%2FPurple2%2Fv4%2F31%2F8e%2F3c%2F318e3cf0-785a-094a-5ca4-0c6d4ac28c86%2Fmzl.yjjnbwsq.png&cfs=1"];
    params.description = @"Официальное приложение Донецкого государственного университета управления";
    
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"DonGUU", @"name",
                                       @"Build great social apps and get more installs.", @"caption",
                                       @"Официальное приложение Донецкого государственного университета управления", @"description",
                                       @"https://itunes.apple.com/ua/app/dsum/id609518721?mt=8", @"link",
                                       @"https://fbexternal-a.akamaihd.net/safe_image.php?d=AQAlXTLT5NzzYRsQ&w=116&h=116&url=http%3A%2F%2Fa2.mzstatic.com%2Fus%2Fr30%2FPurple2%2Fv4%2F31%2F8e%2F3c%2F318e3cf0-785a-094a-5ca4-0c6d4ac28c86%2Fmzl.yjjnbwsq.png&cfs=1", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
        
    }
    

}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
