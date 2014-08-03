//
//  HotelProfileTransition.m
//  THC
//
//  Created by Nicolas Melo on 8/3/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "HotelProfileTransition.h"
#import "HotelProfileViewController.h"
#import "ExploreCasesContainerViewController.h"
#import "AggregateMapViewController.h"
#import "BuildingCalloutView.h"

#define TRANSITION_DURATION 1.0f

@interface HotelProfileTransition ()

@property (assign, nonatomic) BOOL isShowingHotelProfile;

@end

@implementation HotelProfileTransition

- (id)init {
    self = [super init];
    self.isShowingHotelProfile = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {

    self.isShowingHotelProfile = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {

    self.isShowingHotelProfile = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return TRANSITION_DURATION;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView* containerView = [transitionContext containerView];
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    HotelProfileViewController *hotelProfileVC = nil;
    ExploreCasesContainerViewController *exploreVC = nil;
    AggregateMapViewController *mapVC = nil;
    
    
    CGRect beginFrame;
    CGRect endFrame;
    
    UIView *move = nil;
    
    if (self.isShowingHotelProfile) {
        NSLog(@"Transitioning to hotel profile vc");
        
        exploreVC = (ExploreCasesContainerViewController *)fromVC;
        hotelProfileVC = (HotelProfileViewController *)toVC;
        mapVC = exploreVC.tabViewControllers[0];
        
        mapVC.currentCallout.imageView.layer.cornerRadius = 0;
        beginFrame = mapVC.currentCallout.imageView.frame;
        endFrame = hotelProfileVC.hotelImageView.frame;
        
        move = [mapVC.currentCallout.imageView snapshotViewAfterScreenUpdates:YES];
        move.frame = beginFrame;
        mapVC.currentCallout.alpha = 0;
        mapVC.view.alpha = 1;
        
        
        
    } else {
        NSLog(@"Transitioning back to MapView");
        
        exploreVC = (ExploreCasesContainerViewController *)toVC;
        hotelProfileVC = (HotelProfileViewController *)fromVC;
        mapVC = exploreVC.tabViewControllers[0];
        
        
        endFrame = mapVC.currentCallout.imageView.frame;
        beginFrame = hotelProfileVC.hotelImageView.frame;
        
        move = [hotelProfileVC.hotelImageView snapshotViewAfterScreenUpdates:YES];
        move.frame = beginFrame;
        mapVC.currentCallout.imageView.alpha = 0;
        mapVC.view.alpha = 1;
        
    }
    
    
    [containerView addSubview:move];
    [UIView animateWithDuration:TRANSITION_DURATION animations:^{
        NSLog(@"Animation...");
        move.frame = endFrame;
        fromVC.view.alpha = 0;
        toVC.view.alpha = 1;
        
        
    } completion:^(BOOL finished) {
        NSLog(@"Completion...");
        [move removeFromSuperview];
        [containerView addSubview:toVC.view];
        [transitionContext completeTransition: YES];
        
        if (self.isShowingHotelProfile) {
            hotelProfileVC.hotelImageView.alpha = 1;
        } else {
            mapVC.currentCallout.imageView.alpha = 1;
        }
        
        
    }];
    
    
}


@end
