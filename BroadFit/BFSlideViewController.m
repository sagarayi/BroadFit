//
//  SlideViewController.m
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 18/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "BFSlideViewController.h"
#define kExposedWidth 200.0
#define kMenuCellID @"MenuCell"
#define CORNER_RADIUS 4
@interface BFSlideViewController ()
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSArray *menuTitles;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (nonatomic, assign) NSInteger indexOfVisibleController;

@property (nonatomic, assign) BOOL isMenuVisible;
@end

@implementation BFSlideViewController

@synthesize menu;


- (id)initWithViewControllers:(NSArray *)viewControllers andMenuTitles:(NSArray *)menuTitles
{
        NSAssert(self.viewControllers.count == self.menuTitles.count, @"There must be one and only one menu title corresponding to every view controller!");
        NSMutableArray *tempVCs = [NSMutableArray arrayWithCapacity:viewControllers.count];
        
        self.menuTitles = [menuTitles copy];
        for (UIViewController *vc in viewControllers)
        {
            if (![vc isMemberOfClass:[UINavigationController class]])
                [tempVCs addObject:[[UINavigationController alloc] initWithRootViewController:vc]];
            else
                [tempVCs addObject:vc];
            UIImage *image=[UIImage imageNamed:@"bar button"];
            UIBarButtonItem *revealMenuBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenuVisibility:)];
            [revealMenuBarButtonItem setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefaultPrompt];
//            [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenuVisibility:)];
//            [[[self.navigationController navigationBar]topItem]setLeftBarButtonItem:revealMenuBarButtonItem];
//
            UIViewController *topVC = ((UINavigationController *)tempVCs.lastObject).topViewController;
            topVC.navigationItem.leftBarButtonItems = [@[revealMenuBarButtonItem] arrayByAddingObjectsFromArray:topVC.navigationItem.leftBarButtonItems];
        }
        self.viewControllers = [tempVCs copy];
        self.menu.delegate=self;
        self.menu.dataSource=self;
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.indexOfVisibleController = 0;
    UIViewController *visibleViewController = self.viewControllers[0];
    visibleViewController.view.frame = [self offScreenFrame];
    [self addChildViewController:visibleViewController];
    [self.view addSubview:visibleViewController.view];
    self.isMenuVisible = NO;
//    if(!self.isMenuVisible)
//    {
//        self.menu.hidden=YES;
//        self.userImage.hidden=YES;
//        
//    }
    
    [self adjustContentFrameAccordingToMenuVisibility];
    [self.viewControllers[0] didMoveToParentViewController:self];
    self.menu.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.menu.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self showCenterViewWithShadow:NO withOffset:0];
    
    
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    self.menu.hidden=NO;
//    self.userImage.hidden=NO;
//   
//}
- (void)toggleMenuVisibility:(id)sender
{
    self.isMenuVisible = !self.isMenuVisible;
    [self adjustContentFrameAccordingToMenuVisibility];
}


- (void)adjustContentFrameAccordingToMenuVisibility
{
    UIViewController *visibleViewController = self.viewControllers[self.indexOfVisibleController];
    CGSize size = visibleViewController.view.frame.size;
    if (self.isMenuVisible)
    {
        [UIView animateWithDuration:0.2 animations:^{
            visibleViewController.view.frame = CGRectMake(kExposedWidth, 0, size.width, size.height);
        }];
        [self showCenterViewWithShadow:YES withOffset:-2];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            visibleViewController.view.frame = CGRectMake(0, 0, size.width, size.height);
        }];
        [self showCenterViewWithShadow:NO withOffset:0];
    }
    
}

- (void)replaceVisibleViewControllerWithViewControllerAtIndex:(NSInteger)index
{
    if (index == self.indexOfVisibleController) return;
    UIViewController *incomingViewController = self.viewControllers[index];
    incomingViewController.view.frame = [self offScreenFrame];
    UIViewController *outgoingViewController = self.viewControllers[self.indexOfVisibleController];
    CGRect visibleFrame = self.view.bounds;
    
    
    [outgoingViewController willMoveToParentViewController:nil];
    
    [self addChildViewController:incomingViewController];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self transitionFromViewController:outgoingViewController
                      toViewController:incomingViewController
                              duration:0.2 options:0
                            animations:^{
                                outgoingViewController.view.frame = [self offScreenFrame];
                                
                            }
     
                            completion:^(BOOL finished) {
                                [UIView animateWithDuration:0.2
                                                 animations:^{
                                                     [outgoingViewController.view removeFromSuperview];
                                                     [self.view addSubview:incomingViewController.view];
                                                     incomingViewController.view.frame = visibleFrame;
                                                     [[UIApplication sharedApplication] endIgnoringInteractionEvents]; // (16)
                                                 }];
                                [incomingViewController didMoveToParentViewController:self]; // (17)
                                [outgoingViewController removeFromParentViewController]; // (18)
                                self.isMenuVisible = NO;
                                self.indexOfVisibleController = index;
                            }];
   
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    UIViewController *centerViewController=self.viewControllers[self.indexOfVisibleController];
    if (value)
    {
        [centerViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [centerViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [centerViewController.view.layer setShadowOpacity:0.8];
        [centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    }
    else
    {
        [centerViewController.view.layer setCornerRadius:0.0f];
        [centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuCellID];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMenuCellID];
        }

    if([self.menuTitles[indexPath.row] isEqualToString:@"SignOut"]){
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"UserName"];
        
    }
    cell.textLabel.text = self.menuTitles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self replaceVisibleViewControllerWithViewControllerAtIndex:indexPath.row];
}

- (CGRect)offScreenFrame
{
    return CGRectMake(kExposedWidth, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

@end
