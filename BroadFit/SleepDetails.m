//
//  SleepDetails.m
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 17/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "SleepDetails.h"

@interface SleepDetails ()

@end

@implementation SleepDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    int hours = (int)[picker selectedRowInComponent:0];
    int minutes = (int) [picker selectedRowInComponent:1];
    int seconds = (int) [picker selectedRowInComponent:2];
    NSString *message = [NSString stringWithFormat:@"You slept for %d hours, %d minutes and %d seconds",hours,minutes,seconds];
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"MORNING SLEEP DETAILS"
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addOK = [UIAlertAction
                            actionWithTitle:@"SUBMIT"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action){
                            
                                [picker selectRow:0 inComponent:0 animated:YES];
                                [picker selectRow:0 inComponent:1 animated:YES];
                                [picker selectRow:0 inComponent:2 animated:YES];
                                ConnectionHandler *handler = [ConnectionHandler sharedInstance];
                                
                                NSString *duration = [NSString stringWithFormat:@"%d:%d:%d",hours,minutes,seconds];
                                NSArray *details= [NSArray arrayWithObjects:@"DAY", nil];
                                NSArray *durationArray = [NSArray arrayWithObjects:duration, nil];
                                [handler updateChallengeDetails:@"Sleeping" and:details with:durationArray];
                                [self.navigationController popViewControllerAnimated:YES];
                            
                            }];
    UIAlertAction *addCancel = [UIAlertAction
                                actionWithTitle:@"CANCEL"
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction *action){}];
    [alert addAction:addOK];
    [alert addAction:addCancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (IBAction)night:(id)sender {
    
    int hours = (int)[picker selectedRowInComponent:0];
    int minutes = (int) [picker selectedRowInComponent:1];
    int seconds = (int) [picker selectedRowInComponent:2];
    NSString *message = [NSString stringWithFormat:@"You slept for %d hours, %d minutes and %d seconds",hours,minutes,seconds];
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"NIGHT SLEEP DETAILS"
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addOK = [UIAlertAction
                            actionWithTitle:@"SUBMIT"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action){
                            
                                [picker selectRow:0 inComponent:0 animated:YES];
                                [picker selectRow:0 inComponent:1 animated:YES];
                                [picker selectRow:0 inComponent:2 animated:YES];
                                ConnectionHandler *handler = [ConnectionHandler sharedInstance];
                            
                                NSString *duration = [NSString stringWithFormat:@"%d:%d:%d",hours,minutes,seconds];
                                NSArray *details= [NSArray arrayWithObjects:@"NIGHT", nil];
                                NSArray *durationArray = [NSArray arrayWithObjects:duration, nil];
                                [handler updateChallengeDetails:@"Sleeping" and:details with:durationArray];
                                [self.navigationController popViewControllerAnimated:YES];

                            
                                
                            }];
    UIAlertAction *addCancel = [UIAlertAction
                                actionWithTitle:@"CANCEL"
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction *action){}];
    [alert addAction:addOK];
    [alert addAction:addCancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}



@end
