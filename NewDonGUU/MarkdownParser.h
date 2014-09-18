//
//  MarkdownParser.h
//  TextKitMagazine
//
//  Created by Administrator on 26.03.14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkdownParser : NSObject

- (NSAttributedString *) parseMarkdownFile: (NSString *) path;

@end
