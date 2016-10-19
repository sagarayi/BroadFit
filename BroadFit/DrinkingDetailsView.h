//
//  DrinkingDetailsView.h
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrinkingDetailsView : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *date;
@property int noOfGlasses;
@property (weak, nonatomic) IBOutlet UILabel *glassLabel;
- (IBAction)previousDate:(id)sender;
- (IBAction)nextDate:(id)sender;
- (IBAction)increaseNumberOfGlasses:(id)sender;
- (IBAction)decreaseNumberOfGlasses:(id)sender;

@end
