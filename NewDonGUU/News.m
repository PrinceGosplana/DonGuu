//
//  News.m
//  NewDonGUU
//
//  Created by Administrator on 03.04.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import "News.h"

@implementation News

- (id) initNewsWithData:(NSString *) t date: (NSDate *)date logotip:(NSData *)img description: (NSString *) desc indexCategory: (NSString *) indC
{
    self = [super init];
    if (self) {
        self.title = t;
        self.date = date;
        self.image = img;
        self.descriptionNews = desc;
        self.indexCategory = indC;
    }
    return self;
}
@end
