//
//  DrinkingDetailsView.h
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFDrinkDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *glassLabel;
@property int noOfGlasses;

- (IBAction)increaseNumberOfGlasses:(id)sender;
- (IBAction)decreaseNumberOfGlasses:(id)sender;
@end
