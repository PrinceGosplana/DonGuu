//
//  Facultet.h
//  NewDonGUU
//
//  Created by Administrator on 28.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Facultet : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * logotip;
@property (nonatomic, copy) NSString * description;

+ (id) facultetsWithData:(NSString *)nam logotip:(NSString *)logo description: (NSString *) desc;

@end
