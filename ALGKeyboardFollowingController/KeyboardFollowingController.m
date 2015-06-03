//
//  KeyboardFollowingController.m
//  ZoneWatcher
//
//  Created by Alexis Gallagher on 2014-04-14.
//  Copyright (c) 2014 Bloom FIlter. All rights reserved.
//

#import "KeyboardFollowingController.h"

@import UIKit;

@interface KeyboardFollowingController ()
@property (weak, nonatomic) UIView * followingView;
@property (weak, nonatomic) NSLayoutConstraint * constraint;
@end

@implementation KeyboardFollowingController

- (nonnull instancetype)        initWithView:(nonnull UIView *)followingView
                bottomSpacerLayoutConstraint:(nonnull NSLayoutConstraint *)bottomSpacerConstraint;
{
  self = [super init];
  if (self) {
    // assert: followingView has a window
    NSAssert(followingView.window != nil,@"followingView must belong to a UIWindow");
    NSAssert(bottomSpacerConstraint !=nil ,@"bottomSpaceConstraint must not be nil");
    
    _followingView = followingView;
    _constraint = bottomSpacerConstraint;
    
    // register for notifications about the keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:followingView.window];
  }
  return self;
}


-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillChangeFrameNotification
                                                object:nil];
}

/// Repositions login-related fields to follow the keyboard
-(void)keyboardWillChangeFrame:(NSNotification*)notification
{
  // verify the view is onscreen, since we are only interested in notifications
  // about the keyboard in that case.
  //
  //
  if ([self isOnscreen]) {
    UIView * superview = self.followingView.superview;
    
    NSDictionary * userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve  = [userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    CGRect kbEndFrame = [superview convertRect:[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                                      fromView:self.followingView.window];
    CGRect kbBeginFrame = [superview convertRect:[[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue]
                                        fromView:self.followingView.window];
    
    CGFloat deltaKeyBoardOrigin = kbEndFrame.origin.y - kbBeginFrame.origin.y;
    
    self.constraint.constant -= deltaKeyBoardOrigin;
    [superview setNeedsUpdateConstraints];
    
    // (we use old school animation code since it's the only way legally to access
    // the animation curve used by the keyboard)
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [superview layoutIfNeeded];
    [UIView commitAnimations];
  }
}

- (BOOL) isOnscreen
{
  if (!self.followingView) {
    return NO;
  }
  
  // ensure it has a window, so is in a view hierarchy
  if (!self.followingView.window) {
    return NO;
  }
  
  // ensure it's within the window's bounds (i.e., onscreen)
  if (!CGRectIntersectsRect([self.followingView.window convertRect:self.followingView.frame
                                                          fromView:self.followingView.superview],
                            self.followingView.window.bounds))
  {
    return NO;
  }

  // if neither the following view, nor any of its descendants is the first responder,
  // then we assume it is not onscreen
  if (!([self.followingView isFirstResponder] ||
        [KeyboardFollowingController ALGKeyboardFollowingController_findFirstResponderBeneathView:self.followingView]
        )) {
    return NO;
  }

  return YES;
}


/**
 Does a depth-first search of the view's descendants to find the first responder
 
 :param:   view view whose descendants should be searched to find the first responder
 :return:  a descendent view which is the first responder, or nil.
 */
+ (UIView*)ALGKeyboardFollowingController_findFirstResponderBeneathView:(UIView*)view {
  // Search recursively for first responder
  for ( UIView *childView in view.subviews ) {
    if ([childView isFirstResponder])
    {
      return childView;
    }
    UIView *result = [KeyboardFollowingController ALGKeyboardFollowingController_findFirstResponderBeneathView:childView];
    if ( result ) {
      return result;
    }
  }
  return nil;
}

@end


