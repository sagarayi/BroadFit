//
//  TableCell.h
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 07/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell

@property (strong,nonatomic) IBOutlet UILabel *challengeName;
@property (strong,nonatomic) IBOutlet UILabel *numberOfParticipants;
@property (strong,nonatomic) IBOutlet UIImageView *thumbimage;

@end
