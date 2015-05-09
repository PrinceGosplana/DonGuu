//
//  News.h
//  NewDonGUU
//
//  Created by Administrator on 03.04.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSDate * date;
@property (nonatomic, copy) NSData * image;
@property (nonatomic, copy) NSString * descriptionNews;
@property (nonatomic, copy) NSString * indexCategory;

- (id) initNewsWithData: (NSString *) t date: (NSDate *)date logotip:(NSData *)img description: (NSString *) desc indexCategory: (NSString *) indC;

@end
