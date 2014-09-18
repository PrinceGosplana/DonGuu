//
//  HousingsViewController.m
//  NewDonGUU
//
//  Created by Administrator on 27.03.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import "HousingsViewController.h"
#import "RESideMenu.h"
#import "Annotation.h"

@interface HousingsViewController ()

@end

@implementation HousingsViewController

@synthesize corpMap, hostelsMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [corpMap setRegion: MKCoordinateRegionMake(CLLocationCoordinate2DMake(48.011386,37.806296),
                                               MKCoordinateSpanMake(0.015216,0.016393)) animated:YES];
    
    [corpMap setZoomEnabled:YES];
    CLLocationCoordinate2D corpus_1;
    corpus_1.latitude = 48.012463;
    corpus_1.longitude = 37.808732;
    
    Annotation * myAnnotation_1 = [[Annotation alloc] init];
    myAnnotation_1.coordinate = corpus_1;
    myAnnotation_1.title = @"Головний корпус №1";
    myAnnotation_1.subtitle = @"вул. Челюскінців, 163а, тел.: 302-80-32";
    [corpMap addAnnotation:myAnnotation_1];
    
    
    CLLocationCoordinate2D corpus_2;
    corpus_2.latitude = 48.011806;
    corpus_2.longitude = 37.810279;
    
    Annotation * myAnnotation_2 = [[Annotation alloc] init];
    myAnnotation_2.coordinate = corpus_2;
    myAnnotation_2.title = @"Навчальний корпус №2";
    myAnnotation_2.subtitle = @"пр. Б. Хмельницького, 108, тел.: 305-04-22";
    [corpMap addAnnotation:myAnnotation_2];

    
    CLLocationCoordinate2D corpus_3;
    corpus_3.latitude = 48.006408;
    corpus_3.longitude = 37.808554;
    
    Annotation * myAnnotation_3 = [[Annotation alloc] init];
    myAnnotation_3.coordinate = corpus_3;
    myAnnotation_3.title = @"Навчальний корпус №3";
    myAnnotation_3.subtitle = @"вул. Челюскінців, 157, тел.: 305-48-43";
    [corpMap addAnnotation:myAnnotation_3];

    
    CLLocationCoordinate2D corpus_3a;
    corpus_3a.latitude = 48.006808;
    corpus_3a.longitude = 37.808489;
    
    Annotation * myAnnotation_3a = [[Annotation alloc] init];
    myAnnotation_3a.coordinate = corpus_3a;
    myAnnotation_3a.title = @"Навчальний корпус №3a";
    myAnnotation_3a.subtitle = @"вул. Челюскінців, 157а, тел.: 305-48-43";
    [corpMap addAnnotation:myAnnotation_3a];
    
    
    CLLocationCoordinate2D corpus_4;
    corpus_4.latitude = 48.005612;
    corpus_4.longitude = 37.807405;
    
    Annotation * myAnnotation_4 = [[Annotation alloc] init];
    myAnnotation_4.coordinate = corpus_4;
    myAnnotation_4.title = @"Навчальний корпус №4";
    myAnnotation_4.subtitle = @"вул. Горького, 163, тел.: 305-37-65";
    [corpMap addAnnotation:myAnnotation_4];
    
    
    CLLocationCoordinate2D corpus_5;
    corpus_5.latitude = 48.017706;
    corpus_5.longitude = 37.806381;
    
    Annotation * myAnnotation_5 = [[Annotation alloc] init];
    myAnnotation_5.coordinate = corpus_5;
    myAnnotation_5.title = @"Навчальний корпус №5";
    myAnnotation_5.subtitle = @"пр. Миру, 10, тел.: 337-27-31";
    [corpMap addAnnotation:myAnnotation_5];
    
    
    CLLocationCoordinate2D corpus_6;
    corpus_6.latitude = 48.012124;
    corpus_6.longitude = 37.802443;
    
    Annotation * myAnnotation_6 = [[Annotation alloc] init];
    myAnnotation_6.coordinate = corpus_6;
    myAnnotation_6.title = @"Навчальний корпус №6";
    myAnnotation_6.subtitle = @"вул. Артема, 94, тел.: 3312-55-62";
    [corpMap addAnnotation:myAnnotation_6];


    corpMap.delegate = self;
    
    
    [hostelsMap setRegion: MKCoordinateRegionMake(CLLocationCoordinate2DMake(47.995936,37.780305),
                                                  MKCoordinateSpanMake(0.110951,0.263634)) animated:YES];
    
    [hostelsMap setZoomEnabled:YES];
    
    CLLocationCoordinate2D hostel_1;
    hostel_1.latitude = 48.01645;
    hostel_1.longitude = 37.859895;
    
    Annotation * myAnnotationH_1 = [[Annotation alloc] init];
    myAnnotationH_1.coordinate = hostel_1;
    myAnnotationH_1.title = @"Гуртожиток № 2";
    myAnnotationH_1.subtitle = @"пр. Миру, 65";
    [hostelsMap addAnnotation:myAnnotationH_1];
    
    
    CLLocationCoordinate2D hostel_2;
    hostel_2.latitude = 48.012642;
    hostel_2.longitude = 37.809541;
    
    Annotation * myAnnotationH_2 = [[Annotation alloc] init];
    myAnnotationH_2.coordinate = hostel_2;
    myAnnotationH_2.title = @"Гуртожиток № 3";
    myAnnotationH_2.subtitle = @"пр. Богдана Хмельницького, 110 в";
    [hostelsMap addAnnotation:myAnnotationH_2];
    
    
    CLLocationCoordinate2D hostel_3;
    hostel_3.latitude = 48.028574;
    hostel_3.longitude = 37.808376;
    
    Annotation * myAnnotationH_3 = [[Annotation alloc] init];
    myAnnotationH_3.coordinate = hostel_3;
    myAnnotationH_3.title = @"Гуртожиток № 4";
    myAnnotationH_3.subtitle = @"вул. Байдукова, 80";
    [hostelsMap addAnnotation:myAnnotationH_3];
    
    
    CLLocationCoordinate2D hostel_3a;
    hostel_3a.latitude = 47.952009;
    hostel_3a.longitude = 37.687345;
    
    Annotation * myAnnotationH_3a = [[Annotation alloc] init];
    myAnnotationH_3a.coordinate = hostel_3a;
    myAnnotationH_3a.title = @"Гуртожиток № 5";
    myAnnotationH_3a.subtitle = @"вул. Текстильщиків, 5 б";
    [hostelsMap addAnnotation:myAnnotationH_3a];
    
    
    CLLocationCoordinate2D hostel_4;
    hostel_4.latitude = 48.02696;
    hostel_4.longitude = 37.760902;
    
    Annotation * myAnnotationH_4 = [[Annotation alloc] init];
    myAnnotationH_4.coordinate = hostel_4;
    myAnnotationH_4.title = @"Гуртожиток № 6";
    myAnnotationH_4.subtitle = @"вул. Космонавтів, 1";
    [hostelsMap addAnnotation:myAnnotationH_4];
    
    
    CLLocationCoordinate2D hostel_5;
    hostel_5.latitude = 48.042482;
    hostel_5.longitude = 37.790321;
    
    Annotation * myAnnotationH_5 = [[Annotation alloc] init];
    myAnnotationH_5.coordinate = hostel_5;
    myAnnotationH_5.title = @"Гуртожиток № 7";
    myAnnotationH_5.subtitle = @"вул. Павла Поповича 35 б";
    [hostelsMap addAnnotation:myAnnotationH_5];
    
    
    hostelsMap.delegate = self;
    hostelsMap.alpha = 0.0f;
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    static NSString *defaultPinID = @"com.vhlamlab.pin";
    pinView = (MKPinAnnotationView *)[corpMap dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil ) pinView = [[MKAnnotationView alloc]
                                     initWithAnnotation:annotation reuseIdentifier:[annotation title]];
    
    pinView.canShowCallout = YES;
    pinView.image = [UIImage imageNamed:@"sm_logo.png"];
    return pinView;
}

- (IBAction)backToMenu:(UIBarButtonItem *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)selectedMapPressed:(UISegmentedControl *)sender {
    int select = self.mapSelector.selectedSegmentIndex;
    NSLog(@"%i", select);
    switch (select) {
        case 0:
            hostelsMap.alpha = 0.0f;
            corpMap.alpha = 1.0f;
            self.title = @"Корпуси";
            break;
        case 1:
            hostelsMap.alpha = 1.0f;
            corpMap.alpha = 0.0f;
            self.title = @"Гуртожитки";
            break;
        default:
            break;
    }
}
@end
