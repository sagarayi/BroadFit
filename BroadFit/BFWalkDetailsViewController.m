//
//  WalkingDetailsView.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "BFWalkDetailsViewController.h"

@interface BFWalkDetailsViewController ()

@end

@implementation BFWalkDetailsViewController
@synthesize mapView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMapViewSetup];
    
    
}
- (void) initialMapViewSetup{
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
    _currentLocation = newLocation;
    if (_currentLocation != nil) {
        _longitude = [NSString stringWithFormat:@"%.8f", _currentLocation.coordinate.longitude];
        _latitude = [NSString stringWithFormat:@"%.8f", _currentLocation.coordinate.latitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *fetchLocationFailAlert = [UIAlertController
                                alertControllerWithTitle:@"FAILED"
                                message:@"Failed to get location"
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action){}];
    [fetchLocationFailAlert addAction:okButton];
    [self presentViewController:fetchLocationFailAlert animated:YES completion:nil];
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
    UIButton *button = (UIButton *)sender;
    if( [[button imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"play-button"]])
        [button setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    else
    {
        [_timer invalidate];
        [self calculateWalkingDetails];
        [button setImage:[UIImage imageNamed:@"play-button"] forState:UIControlStateNormal];
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

    int hourValue=[_hoursField.text intValue];
    int minutesValue=[_minutesField.text intValue];
    int secondsValue = [_secondsField.text intValue];
    int time = (int)(hourValue + (minutesValue/60));
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
        secondsValue  = secondsValue + [timeComponents[2]intValue];
        minutesValue = minutesValue + [timeComponents[1]intValue];
        hourValue = hourValue + [timeComponents[0]intValue];
    }
    NSString *duration = [NSString stringWithFormat:@"%d:%d:%d",hourValue,minutesValue,secondsValue];
    challengeDetails = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",noOfCalories],[NSString stringWithFormat:@"%d",noOfSteps],[NSString stringWithFormat:@"%@",duration],[NSString stringWithFormat:@"%d m",distance], nil];
            walkingDetails = @{
                               @"calories" : [NSString stringWithFormat:@"%d",noOfCalories],
                               @"distance" : [NSString stringWithFormat:@"%d",distance],
                               @"steps" : [NSString stringWithFormat:@"%d",noOfSteps],
                               @"duration" : [NSString stringWithFormat:@"%@ m",duration]
    
                               };
    [[NSUserDefaults standardUserDefaults] setObject:walkingDetails forKey:@"WalkingDetails"];
    FirebaseConnectionHandler *handlerObject = [FirebaseConnectionHandler sharedInstance];
    [handlerObject updateChallengeDetails:@"Walking" and:detailNames with:challengeDetails];
}
- (IBAction)stop:(id)sender {
    
    [_timer invalidate];
    _timer=nil;
    seconds=0;
    minutes=0;
    hours=0;
    [_playPauseButton setImage:[UIImage imageNamed:@"play-button"] forState:UIControlStateNormal];
    //Reset text feilds
    _minutesField.text = @"00";
    _secondsField.text = @"00";
    _hoursField.text = @"00";
    UIAlertController *submitDataAlert = [UIAlertController
                                          alertControllerWithTitle:@"SUBMIT Walking Details"
                                          message:@"Press Ok to submit data"
                                          preferredStyle:UIAlertControllerStyleAlert
                                          ];
    UIAlertAction *okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   [self calculateWalkingDetails];
                                   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                   UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
                                   [self.navigationController pushViewController:viewController animated:NO];
                               }
                               ];
    UIAlertAction *cancelButton = [UIAlertAction
                               actionWithTitle:@"CANCEL"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {}
                               ];
    [submitDataAlert addAction:okButton];
    [submitDataAlert addAction:cancelButton];
    [self presentViewController:submitDataAlert animated:YES completion:nil];

 
    
   
}
@end
