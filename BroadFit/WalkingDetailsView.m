//
//  WalkingDetailsView.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "WalkingDetailsView.h"

@interface WalkingDetailsView ()

@end

@implementation WalkingDetailsView
@synthesize mapView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mapView setShowsUserLocation: YES];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    NSLog(@"NEW LOC:%@",newLocation);
    
    _currentLocation = newLocation;
    
    if (_currentLocation != nil) {
        _longitude = [NSString stringWithFormat:@"%.8f", _currentLocation.coordinate.longitude];
        _latitude = [NSString stringWithFormat:@"%.8f", _currentLocation.coordinate.latitude];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"FAILED"
                                message:@"Failed to get location"
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addOK = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action){}];
    [alert addAction:addOK];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Place";
    point.subtitle = @"Bangalore";
    [self.mapView addAnnotation:point];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)pause:(id)sender {
    
    if(!_timer)
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerCount) userInfo:nil repeats:YES];
    UIButton *btn = (UIButton *)sender;
    
    
    if( [[btn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"play-button"]])
    {
        [btn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        
        
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"play-button"] forState:UIControlStateNormal];
        [_timer invalidate];
        _timer=nil;
        
    }
}

- (void) TimerCount{
    
    seconds = seconds + 1;
    _secondsField.text = [NSString stringWithFormat:@"%i",seconds];
    if(seconds == 60){
        minutes = minutes +1;
        _minutesField.text = [NSString stringWithFormat:@"%i",minutes];
        seconds = 0;
    }
    if(minutes == 60){
        hours = hours +1;
        _hoursField.text = [NSString stringWithFormat:@"%i",hours];
        minutes = 0;
    }
    
}

- (void) calculateWalkingDetails{
    
    // CALCULATING INDIVIDUAL DETAILS
    //calories formula : Calories Burned (kcal) = METs x (WEIGHT_IN_KILOGRAM) x (DURATION_IN_HOUR)

    int hour=[_hoursField.text intValue];
    int min=[_minutesField.text intValue];
    int sec = [_secondsField.text intValue];
    int time = (int)(hour + (min/60));
    int distance = 5 * time;
    int noOfInches = distance*39370;
    int noOfSteps=(int)noOfInches/7;
    int noOfCalories=3.8 * 70 * (int)(seconds/3600);
    double currentSpeed=_currentLocation.speed;
    
    if(currentSpeed < 0)
    {
        currentSpeed=0;
    }
    
    // SETTING THE TEXT LABELS
    
    _totalSteps.text=[NSString stringWithFormat:@"Steps : %d",noOfSteps];
    _caloriesBurnt.text=[NSString stringWithFormat:@"Calories : %d cal",noOfCalories];
    _walkingSpeed.text=[NSString stringWithFormat:@"Speed : %.2f m/s",currentSpeed];
    
    // DETAILS TO PASS TO THE CONNECTION HANDLER
    NSArray *challengeDetails;
    NSArray *detailNames = [NSArray arrayWithObjects:@"calories",@"steps",@"duration",@"distance", nil];
    NSDictionary *walkingDetails;   // TO STORE DATA TO NSUSERDEFAULTS
    
   
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"WalkingDetails"] == nil){
        
        NSLog(@"NEW WALKING ENTRY");


    }else{
        
        NSDictionary *details  = [[NSUserDefaults standardUserDefaults] objectForKey:@"WalkingDetails"];
        
        noOfCalories = noOfCalories + [[details objectForKey:@"calories"]intValue];
        distance = distance + [[details objectForKey:@"distance"]intValue];
        noOfSteps = noOfSteps + [[details objectForKey:@"steps"]intValue];
        NSArray *timeComponents = [[details objectForKey:@"duration"] componentsSeparatedByString: @":"];
        sec  = sec + [timeComponents[2]intValue];
        min = min + [timeComponents[1]intValue];
        hour = hour + [timeComponents[0]intValue];
        


    }

    NSString *duration = [NSString stringWithFormat:@"%d:%d:%d",hour,min,sec];
    
    challengeDetails = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",noOfCalories],[NSString stringWithFormat:@"%d",noOfSteps],[NSString stringWithFormat:@"%@",duration],[NSString stringWithFormat:@"%d m",distance], nil];
            walkingDetails = @{
                               @"calories" : [NSString stringWithFormat:@"%d",noOfCalories],
                               @"distance" : [NSString stringWithFormat:@"%d",distance],
                               @"steps" : [NSString stringWithFormat:@"%d",noOfSteps],
                               @"duration" : [NSString stringWithFormat:@"%@ m",duration]
    
                               };

    [[NSUserDefaults standardUserDefaults] setObject:walkingDetails forKey:@"WalkingDetails"];

    ConnectionHandler *handlerObject = [ConnectionHandler sharedInstance];
    [handlerObject updateChallengeDetails:@"Walking" and:detailNames with:challengeDetails];
    
}
- (IBAction)stop:(id)sender {
    
    [_timer invalidate];
    _timer=nil;
    seconds=0;
    minutes=0;
    hours=0;
    
    [_playPauseButton setImage:[UIImage imageNamed:@"play-button"] forState:UIControlStateNormal];
    [self calculateWalkingDetails];

    _minutesField.text = @"00";
    _secondsField.text = @"00";
    _hoursField.text = @"00";
   
}
@end
