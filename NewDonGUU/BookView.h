//
//  BookView.h
//  TextKitMagazine
//
//  Created by Administrator on 26.03.14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookView : UIScrollView <UITextViewDelegate>

@property (nonatomic, copy) NSAttributedString *bookMarkup;

- (void)buildFrames;

@end
