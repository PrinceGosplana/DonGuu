//
//  MainViewController.h
//  DonGUU
//
//  Created by Administrator on 27.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "MWFeedParser.h"
#import "ALScrollViewPaging.h"
#import "RESideMenu.h"

@interface MainViewController : UIViewController <MWFeedParserDelegate, UIWebViewDelegate, UITextViewDelegate, UIScrollViewDelegate> {
    // Parsing
	MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	
	// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
    
    NSMutableArray *parsedNewsTop;
    //    MWFeedParser *newsParserTop;
    ALScrollViewPaging *scrollView;
    
    NSMutableArray * arrayNewsTop;

    UIWebView * myWebWiew;
    UIScrollView * scrV; // скрол для текста
    UIView * contView; // подложка под текст
    UITextView * textMainNews; // текст основной новости под картинкой
}
@property (nonatomic, copy) NSAttributedString * bookMarkup;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UIImageView *warningImgView;

@property (weak, nonatomic) IBOutlet UIScrollView *mainNewsScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainNewsContentView;
@property (weak, nonatomic) IBOutlet UIView *mainImageView;


@property (weak, nonatomic) IBOutlet UITextView *textView; // в iPad отображает текст новости
@property (nonatomic, strong) NSArray *itemsToDisplay;
@property (nonatomic, strong) NSMutableArray * arrayNewsTop;



- (IBAction)showLeftMenu:(UIBarButtonItem *)sender;

@end
