#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import "News.h"
#import "SQBA.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, MWFeedParserDelegate> {
    // Parsing
	MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	
	// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;

    NSMutableArray * imgArray;
    NSInteger indexNews;
    News * news;
    NSMutableArray * infoCategory; // храню информацию о категориях
    NSMutableArray * allNews; // храню все новости с категориями, этот массив передается в newsController
    NSTimer * timerStarnApp; // нужен чтобы стартовало приложение при отсутствии соединения с сетью
    NetworkStatus status;

}

- (void) startParse;
- (NSString *) stringFromStatus:(NetworkStatus)status;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSMutableArray * arrayNews;
@property (readonly, nonatomic) NSArray * facultets;
@property (nonatomic, strong) NSMutableArray * feed;
@property (nonatomic, strong) NSMutableDictionary *itemsDictionaryToDisplay;
@property (nonatomic, strong) NSArray * itemsToDisplay;
@property (nonatomic, strong) NSMutableArray * imgArray;
@property (nonatomic, strong) NSMutableArray * allNews;
@property (nonatomic) BOOL noConnection;
@property (nonatomic) BOOL isAppStart;
//@property (nonatomic) NetworkStatus * status;
//@property (nonatomic) NewsViewController * newsViewController;

@end
