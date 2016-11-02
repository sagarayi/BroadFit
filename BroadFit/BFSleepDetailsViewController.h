//
//  SleepDetails.h
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 17/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirebaseConnectionHandler.h"
#import "QuartzCore/QuartzCore.h"
@interface BFSleepDetailsViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *picker;
    UILabel *label;
}
- (IBAction)day:(id)sender;
- (IBAction)night:(id)sender;

@end
