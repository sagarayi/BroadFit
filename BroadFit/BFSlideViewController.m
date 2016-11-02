//
//  SlideViewController.m
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 18/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "BFSlideViewController.h"
#import "FirebaseConnectionHandler.h"
#define kExposedWidth 200.0
#define kMenuCellID @"MenuCell"
#define CORNER_RADIUS 4
@interface BFSlideViewController ()
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSArray *menuTitles;

@property (nonatomic, assign) NSInteger indexOfVisibleController;

@property (nonatomic, assign) BOOL isMenuVisible;
@property UIPanGestureRecognizer *gestureRecognizer;
@property UITapGestureRecognizer *tapRecognizer;
@end

@implementation BFSlideViewController

@synthesize menu,gestureRecognizer,tapRecognizer;

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
        UIBarButtonItem *revealMenuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenuVisibility:)];
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
//    gestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(toggleMenuVisibility:)];
//    [gestureRecognizer setMaximumNumberOfTouches:1];
//    [gestureRecognizer setMinimumNumberOfTouches:1];
//    [gestureRecognizer setDelegate:self];
//    
    
    tapRecognizer = [[UITapGestureRecognizer alloc]
                     initWithTarget:self
                     action:@selector(toggleMenuVisibility:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    
    self.indexOfVisibleController = 0;
    UIViewController *visibleViewController = self.viewControllers[0];
    visibleViewController.view.frame = [self offScreenFrame];
    [self addChildViewController:visibleViewController];
    [self.view addSubview:visibleViewController.view];
    self.isMenuVisible = NO;
    [self adjustContentFrameAccordingToMenuVisibility];
    [self.viewControllers[0] didMoveToParentViewController:self];
    self.menu.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.menu.separatorStyle = UITableViewCellSeparatorStyleNone;
    FirebaseConnectionHandler *handler = [FirebaseConnectionHandler new];
    handler.delegate =self;
    [handler fetchUserName];
    
}
- (void) didfetchUserName:(NSString *)username{
    if([username isKindOfClass:[NSNull class]] || username == NULL)
        _usernameLabel.text=@"username";
    else
        _usernameLabel.text = username;
}
- (void)toggleMenuVisibility:(id)sender // (9)
{
    UIViewController *visibleViewController = self.viewControllers[self.indexOfVisibleController];
   
    if(![sender isKindOfClass:[UIBarButtonItem class]])
    {
        
        if([(UIGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
            //        UIView *childView = nil;
            
            if (!self.isMenuVisible) {
                self.isMenuVisible=YES;
                [visibleViewController.view addGestureRecognizer:tapRecognizer];

            }
            
            else {
                self.isMenuVisible=NO;
                [visibleViewController.view removeGestureRecognizer:tapRecognizer];

            }
            
        }
    }
    else
    {
        self.isMenuVisible = !self.isMenuVisible;
    }
    
    //
    [self adjustContentFrameAccordingToMenuVisibility];
}
-(void)viewDidAppear:(BOOL)animated
{
    UIViewController *visibleViewController = self.viewControllers[self.indexOfVisibleController];
    [visibleViewController.view addGestureRecognizer:gestureRecognizer];
    [visibleViewController.view addGestureRecognizer:tapRecognizer];
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
    [incomingViewController.view addGestureRecognizer:gestureRecognizer];
    [incomingViewController.view addGestureRecognizer:tapRecognizer];
    UIViewController *outgoingViewController = self.viewControllers[self.indexOfVisibleController];
    CGRect visibleFrame = self.view.bounds;
    
    
    [outgoingViewController willMoveToParentViewController:nil];
    
    [self addChildViewController:incomingViewController];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self transitionFromViewController:outgoingViewController
                      toViewController:incomingViewController
                              duration:0.1 options:0
                            animations:^{
                                outgoingViewController.view.frame = [self offScreenFrame];
                                
                            }
     
                            completion:^(BOOL finished) {
                                [UIView animateWithDuration:0.1
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
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
        
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
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
