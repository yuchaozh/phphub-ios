//
//  BaseTabBarViewController.m
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "EssentialListViewController.h"
#import "TopicListContainerViewController.h"
#import "WiKiListViewController.h"

@interface BaseTabBarViewController () {
	// Four separate navigation controller for four tabs
    UINavigationController *_essentialNC;
    UINavigationController *_forumNC;
    UINavigationController *_wikiNC;
    UINavigationController *_meNC;
}
// create a timer to refresh unread counts
@property (nonatomic) NSTimer *refreshUnreadCountTimer;
@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// init local notification
	// name: UpdateNoticeCount
	// function: updateNoticeCount
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNoticeCount:) name:UpdateNoticeCount object:nil];
    
    self.delegate = self;
    self.view.backgroundColor = RGB(242, 242, 242);
    [self setupTabBarItems];
    [self setupTabBarStyle];
    [self createRefreshUnreadCountTimer];
}

/**
 *  create refresh unread counts timer which runs every 30mins
 */
- (void)createRefreshUnreadCountTimer {
    if (!self.refreshUnreadCountTimer) {
        self.refreshUnreadCountTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(checkNoticeCount) userInfo:nil repeats:YES];
    }
}

- (void)checkNoticeCount {
    [[CurrentUser Instance] checkNoticeCount];
}

/**
 *  Get unread count from notification and update the badge of the tab
 *
 *  @param notification UpdateNoticeCount notification
 */
- (void)updateNoticeCount:(NSNotification *)notification {
    NSNumber *unreadCount = notification.userInfo[@"unreadCount"];
	// if unreadCount > 0 update badgate value
    _meNC.tabBarItem.badgeValue = unreadCount.integerValue > 0 ? unreadCount.stringValue : nil;
}


- (void)setupTabBarItems {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 0.0, -6.0, 0.0);

    EssentialListViewController *essentialListVC = [[EssentialListViewController alloc] init];
	// set navigation controller for Essential List tab
    _essentialNC = [[UINavigationController alloc] initWithRootViewController:essentialListVC];
	// set unselected image and selected image for Essential List tab
    _essentialNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"essential_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"essential_selected_icon.png"]];
    _essentialNC.tabBarItem.imageInsets = insets;
    
    TopicListContainerViewController *topicListContainerVC = [[TopicListContainerViewController alloc] init];
    _forumNC = [[UINavigationController alloc] initWithRootViewController:topicListContainerVC];
    _forumNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"forum_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"forum_selected_icon.png"]];
    _forumNC.tabBarItem.imageInsets = insets;
    
    WiKiListViewController *wikiListVC = [[WiKiListViewController alloc] init];
    _wikiNC = [[UINavigationController alloc] initWithRootViewController:wikiListVC];
    _wikiNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"wiki_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"wiki_selected_icon.png"]];
    _wikiNC.tabBarItem.imageInsets = UIEdgeInsetsMake(7.0, 0.0, -7.0, 0.0);;
    
    _meNC = [[UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    _meNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"me_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"me_selected_icon.png"]];
    _meNC.tabBarItem.badgeValue = nil;
    _meNC.tabBarItem.imageInsets = insets;
	
	// TODO: ???
    NSArray *controllers = @[_essentialNC, _forumNC, _wikiNC, _meNC];
    [self setViewControllers:controllers];
    
}

- (void)setupTabBarStyle {
    // for shouldSelectViewController, enabling animation for tabbar item clicked.
    [self setDelegate:self];
    
    // White background
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud"]];
}

#pragma mark - Delegate - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setDuration:0.25];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:
                                  kCAMediaTimingFunctionEaseIn]];
    [self.view.window.layer addAnimation:animation forKey:@"fadeTransition"];
    
    return YES;
}

- (void)pushToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (UINavigationController *)self.selectedViewController;
        [navigation pushViewController:viewController animated:animated];
    }
}

- (void)presentToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    if([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (UINavigationController *)self.selectedViewController;
        [navigation presentViewController:viewController animated:animated completion:completion];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
