//
//  BreakfastDetailsView.h
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFEatingDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;

- (IBAction)no:(id)sender;
- (IBAction)yes:(id)sender;

@end
