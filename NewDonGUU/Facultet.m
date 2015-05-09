//
//  Facultet.m
//  NewDonGUU
//
//  Created by Administrator on 28.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import "Facultet.h"

@implementation Facultet

+ (id)facultetsWithData:(NSString *)nam logotip:(NSString *)logo description:(NSString *)desc {
    Facultet * facultet = [Facultet new];
    facultet.name = nam;
    facultet.logotip = logo;
    facultet.descriptionFacultet = desc;
    return facultet;
}
@end
