//
//  RootViewController.h
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 18/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *menu;
- (id)initWithViewControllers:(NSArray *)viewControllers andMenuTitles:(NSArray *)menuTitles;

@end
