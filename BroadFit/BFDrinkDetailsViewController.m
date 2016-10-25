//
//  DrinkingDetailsView.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "BFDrinkDetailsViewController.h"
#import "ConnectionHandler.h"
@interface BFDrinkDetailsViewController ()

@end

@implementation BFDrinkDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)increaseNumberOfGlasses:(id)sender
{
    _noOfGlasses=_glassLabel.text.intValue;
    
    _noOfGlasses++;
    
    _glassLabel.text=[NSString stringWithFormat:@"%d",_noOfGlasses];
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

- (IBAction)submitDetails:(id)sender
{
    _noOfGlasses=_glassLabel.text.intValue;
    ConnectionHandler * connection=[[ConnectionHandler alloc]init];
    [connection updateChallengeDetails:@"Drinking Water" and:@[@"NumberOfGlasses"] with:@[[NSString stringWithFormat:@"%d", _noOfGlasses]]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
