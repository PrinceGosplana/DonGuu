//
//  HousingsViewController.h
//  NewDonGUU
//
//  Created by Administrator on 27.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HousingsViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapSelector;

@property (weak, nonatomic) IBOutlet MKMapView *corpMap;
@property (weak, nonatomic) IBOutlet MKMapView *hostelsMap;

- (IBAction)backToMenu:(UIBarButtonItem *)sender;
- (IBAction)selectedMapPressed:(UISegmentedControl *)sender;

@end
