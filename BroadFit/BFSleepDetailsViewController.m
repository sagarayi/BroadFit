//
//  SleepDetails.m
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 17/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "BFSleepDetailsViewController.h"

@interface BFSleepDetailsViewController ()

@end

@implementation BFSleepDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add Time Picker to Select the Hours, minutes and seconds slept
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    picker.dataSource = self;
    picker.delegate = self;
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, picker.frame.size.height / 2 - 15, 75, 30)];
    hourLabel.text = @"hour";
    [picker addSubview:hourLabel];
    UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + (picker.frame.size.width / 3), picker.frame.size.height / 2 - 15, 75, 30)];
    minsLabel.text = @"min";
    [picker addSubview:minsLabel];
    UILabel *secsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + ((picker.frame.size.width / 3) * 2), picker.frame.size.height / 2 - 15, 75, 30)];
    secsLabel.text = @"sec";
    [picker addSubview:secsLabel];
    [self.view addSubview:picker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return 24;
    return 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *columnView = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width/3 - 35, 30)];
    columnView.text = [NSString stringWithFormat:@"%lu", (long) row];
    columnView.textAlignment = NSTextAlignmentLeft;
    return columnView;
}

- (IBAction)day:(id)sender {
    
    [self submitSleepDetails:@"DAY"];
}

- (IBAction)night:(id)sender {
    
    [self submitSleepDetails:@"NIGHT"];
}

- (void) submitSleepDetails:(NSString *)time{
    
    NSString * alertTitle = [NSString stringWithFormat:@"%@ SLEEP DETAILS",time];
    int hours = (int)[picker selectedRowInComponent:0];
    int minutes = (int) [picker selectedRowInComponent:1];
    int seconds = (int) [picker selectedRowInComponent:2];
    NSString *alertMessage = [NSString stringWithFormat:@"You slept for %d hours, %d minutes and %d seconds",hours,minutes,seconds];
    UIAlertController *alertForSleepDetails = [UIAlertController
                                alertControllerWithTitle:alertTitle
                                message:alertMessage
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction
                            actionWithTitle:@"SUBMIT"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action){
                                
                                [picker selectRow:0 inComponent:0 animated:YES];
                                [picker selectRow:0 inComponent:1 animated:YES];
                                [picker selectRow:0 inComponent:2 animated:YES];
                                ConnectionHandler *handler = [ConnectionHandler sharedInstance];
                                
                                NSString *duration = [NSString stringWithFormat:@"%d:%d:%d",hours,minutes,seconds];
                                NSArray *details= [NSArray arrayWithObjects:time, nil];
                                NSArray *durationArray = [NSArray arrayWithObjects:duration, nil];
                                [handler updateChallengeDetails:@"Sleeping" and:details with:durationArray];
                                [self.navigationController popViewControllerAnimated:YES];
                                
                                
                                
                            }];
    UIAlertAction *cancelButton = [UIAlertAction
                                actionWithTitle:@"CANCEL"
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction *action){}];
    [alertForSleepDetails addAction:okButton];
    [alertForSleepDetails addAction:cancelButton];
    [self presentViewController:alertForSleepDetails animated:YES completion:nil];

    
    
    
}

@end
