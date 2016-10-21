//
//  WalkingDetailsView.h
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapKit/MapKit.h"
#import "ConnectionHandler.h"

@interface WalkingDetailsView : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate> {
    CLLocationManager *locationManager;
    int seconds;
    int minutes;
    int hours;
}


@property (weak, nonatomic) IBOutlet UILabel *secondsField;
@property (weak, nonatomic) IBOutlet UILabel *hoursField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *minutesField;
@property CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UILabel *totalSteps;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UILabel *caloriesBurnt;
@property (weak, nonatomic) IBOutlet UILabel *walkingSpeed;
@property NSString *longitude;
@property NSString *latitude;
@property NSTimer *timer;

- (IBAction)pause:(id)sender;
- (IBAction)stop:(id)sender;

@end
