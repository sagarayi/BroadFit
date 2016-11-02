//
//  SlideViewController.h
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 18/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFSlideViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *menu;
- (id)initWithViewControllers:(NSArray *)viewControllers andMenuTitles:(NSArray *)menuTitles;
- (void) didfetchUserName:(NSString *)username;

@end
