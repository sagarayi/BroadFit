//
//  DrinkingDetailsView.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "DrinkingDetailsView.h"
#import "ConnectionHandler.h"
@interface DrinkingDetailsView ()

@end

@implementation DrinkingDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (IBAction)previousDate:(id)sender {
}

- (IBAction)nextDate:(id)sender {
}
- (IBAction)increaseNumberOfGlasses:(id)sender
{
    _noOfGlasses=_glassLabel.text.intValue;
    
    _noOfGlasses++;
    
    _glassLabel.text=[NSString stringWithFormat:@"%d",_noOfGlasses];
}
- (IBAction)submitDetails:(id)sender
{
    _noOfGlasses=_glassLabel.text.intValue;
    
    ConnectionHandler * connection=[[ConnectionHandler alloc]init];
    [connection updateChallengeDetails:@"Drinking Water" and:@[@"NumberOfGlasses"] with:@[[NSString stringWithFormat:@"%d", _noOfGlasses]]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)decreaseNumberOfGlasses:(id)sender
{
    
    _noOfGlasses=_glassLabel.text.intValue;
    
    if(_noOfGlasses > 0)
        _noOfGlasses--;
    else
        _noOfGlasses=0;
    
    _glassLabel.text=[NSString stringWithFormat:@"%d",_noOfGlasses];
}
@end
