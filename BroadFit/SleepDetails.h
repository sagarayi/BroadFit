//
//  SleepDetails.h
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 17/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionHandler.h"
@interface SleepDetails : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *picker;
}
- (IBAction)day:(id)sender;

- (IBAction)night:(id)sender;

@end
