#import "DetailFacultViewController.h"
#import "RESideMenu.h"
#import "Facultet.h"
#import "AppDelegate.h"
#import "FlipAnimationController.h"
#import "FacultetTableViewCell.h"
#import "FacultetViewController.h"
#import "MarkdownParser.h"
#import "BookView.h"

@interface FacultetViewController ()<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@end

@implementation FacultetViewController {
    FlipAnimationController *_flipAnimationController;
    BookView * _bookView;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _flipAnimationController = [FlipAnimationController new];
    }
    return self;
}

- (NSArray *) facults {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).facultets;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    facultets = [[NSMutableArray alloc] initWithCapacity:10];
//    facultets = [NSMutableArray arrayWithArray:((AppDelegate *)[[UIApplication sharedApplication] delegate]).facultets];
    self.navigationController.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        [self addContentToLeftSize:0];
//    }
    
}
#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {

    _flipAnimationController.reverse = operation == UINavigationControllerOperationPop;
    return _flipAnimationController;
}

- (void) viewDidLayoutSubviews{
    [_bookView buildFrames];
}

- (void)preferredContentSizeChanged:(NSNotification *)n {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self facults].count;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FacultetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    cell.facultet = [self facults][indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index %i",  (int)indexPath.row);
//    [self addContentToLeftSize:(int)indexPath.row];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // find the tapped cat
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Facultet * facultet = [self facults][indexPath.row];
        
        // provide this to the detail view
        [[segue destinationViewController] setFacultet:facultet];
    }
}

- (IBAction)backToMenu:(UIBarButtonItem *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

//- (void) addContentToLeftSize:(int) index {
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(512, 0, 512, 768)];
//
//    Facultet * facultet = [[self facults] objectAtIndex:index];
//    NSString * path;
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        path = [[NSBundle mainBundle] pathForResource:facultet.description ofType:@"html"];
//    }
//    else {
//        path = [[NSBundle mainBundle] pathForResource:facultet.description ofType:@"txt"];
//    }
////    NSString *path = [[NSBundle mainBundle] pathForResource:facultet.description ofType:@"txt"];
//    NSString *text = [NSString stringWithContentsOfFile:path
//                                               encoding:NSUTF8StringEncoding error:NULL];
//    self.bookMarkup = [[NSAttributedString alloc] initWithString:text];
//    
//    
//    MarkdownParser * parser = [[MarkdownParser alloc] init];
//    self.bookMarkup = [parser parseMarkdownFile:path];
//    
//    self.textView.backgroundColor = [UIColor colorWithWhite:0.87f alpha:1.0f];
//    [self setEdgesForExtendedLayout:UIRectEdgeNone];
//    _bookView = [[BookView alloc] initWithFrame:self.textView.bounds];
//    _bookView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _bookView.bookMarkup = self.bookMarkup;
////    NSLog(@"%@", _bookView.bookMarkup.description);
//    [view addSubview:_bookView];
//    [self.view addSubview:view];
//}
@end
