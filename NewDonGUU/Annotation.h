//
//  Annotation.h
//  NewDonGUU
//
//  Created by Administrator on 28.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic, assign)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;

//- (id) initWith_lat:(float)lat lon:(float)lon title:(NSString *)tt subtitle:(NSString *)stt;
//- (Annotation *) addAnnotationlat_lat:(float)lat lon:(float)lon title:(NSString *)tt subtitle:(NSString *)stt;

@end
