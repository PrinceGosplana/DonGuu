//
//  NewsViewController.h
//  DonGUU
//
//  Created by Administrator on 27.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "SBScrollNavigation.h"
#import "MWFeedParser.h"
//#import "AppDelegate.h"

@interface NewsViewController : UIViewController <SBScrollNavigationDelegate, MWFeedParserDelegate, UITextViewDelegate, UIScrollViewDelegate> {
    NSArray * _items;
//    NSMutableArray *feed_;

    // Parsing
	MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	
	// Displaying
	NSMutableArray *itemsToDisplay;
	NSDateFormatter *formatter;
    
    NSMutableArray * imgArray;
    NSArray * feed;// ссылки на новости
    NSArray *parsedNews; // хранятся все новости
    NSMutableArray * newsWithCategory; // группа новостей по категории
    UIRefreshControl * refreshControll;
    NSInteger curentCategoryNews;
    
    UIScrollView * scrV; // скрол для текста
    UIView * contView; // подложка под текст
    UITextView * textMainNews; // текст основной новости под картинкой
    
    NSMutableArray * infoCategory; // храню информацию о категориях
    NSMutableArray * allNews; // храню все новости с категориями, этот массив передается в newsController
    NSMutableArray * feedNews;
    NSArray * newItemsToDisplay;
    
    NSInteger indexNews; // индекс используется после refresh, чтобы знать категорию новостей, выводимых на экран
    NSInteger inde;
    
    NSThread *backgroundThread;

//    BOOL haveConnect;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *newsDetailView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic) UITextView * textNews;// текст новости
@property (nonatomic, weak) UIScrollView * scrollNews;

- (IBAction)backToMenu:(UIBarButtonItem *)sender;

@property (nonatomic, strong) NSMutableArray *itemsToDisplay;
@property (nonatomic, strong) NSArray * feed;


//@property (nonatomic, strong) NSDictionary * allNewsFromAppDelegate;
@property (nonatomic, strong) NSArray * arrayNewsWithIdexButton;
- (IBAction)shareBtnPressed:(UIBarButtonItem *)sender;

@property (nonatomic, strong) IBOutlet SBScrollNavigation * scrollNavigation;

@property (weak, nonatomic) IBOutlet UIToolbar *myToolbar;

@property (nonatomic) BOOL haveConnect;

@end
