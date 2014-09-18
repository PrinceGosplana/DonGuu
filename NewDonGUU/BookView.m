//
//  BookView.m
//  TextKitMagazine
//
//  Created by Administrator on 26.03.14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "BookView.h"

@implementation BookView {
    NSLayoutManager * _layoutManager;
    UITextView *textView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)buildFrames {
    // create the text storage
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.bookMarkup];
    
    // create the layout manager
    _layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:_layoutManager];
    
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        NSRange range = NSMakeRange(0, 0);
//        NSUInteger containerIndex = 0;
//        while (NSMaxRange(range) < _layoutManager.numberOfGlyphs) {
//            // 1
//            CGRect textViewRect = [self frameForViewAtIndex:containerIndex];
//            // 2
//            CGSize containerSize = CGSizeMake(textViewRect.size.width, textViewRect.size.height - 16.0f);
//            NSTextContainer* textContainer = [[NSTextContainer alloc] initWithSize:containerSize];
//            [_layoutManager addTextContainer:textContainer];
//            
//            // 3
//            textView = [[UITextView alloc] initWithFrame:textViewRect textContainer:textContainer];
//            [self addSubview:textView];
//            containerIndex++;
//            // 4
//            range = [_layoutManager glyphRangeForTextContainer:textContainer];
//        }
//        self.contentSize = CGSizeMake((self.bounds.size.width/2) * (CGFloat)containerIndex, self.bounds.size.height);
//        self.pagingEnabled = YES;
//    }
//    else
//    {
//      create a container
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(self.bounds.size.width, FLT_MAX)];
        [_layoutManager addTextContainer:textContainer];
        
        // create a view
        textView = [[UITextView alloc] initWithFrame:self.bounds textContainer:textContainer];
        textView.scrollEnabled = YES;
//    }
    
    textView.delegate = self;
    
    // добавляю жест, чтобы не выезжала клавиатура
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn)];
    [textView addGestureRecognizer:tap];
    [self addSubview:textView];
    
}

// отменяю использование клавиатуры
- (void) textFieldShouldReturn
{
    [textView resignFirstResponder];
}


- (CGRect)frameForViewAtIndex:(NSUInteger)index {
    CGRect textViewRect = CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height);
    textViewRect = CGRectInset(textViewRect, 10.0, 20.0);
    textViewRect = CGRectOffset(textViewRect,(self.bounds.size.width / 2) * (CGFloat)index, 0.0);
    return textViewRect;
}
@end
