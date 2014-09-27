//
//  ALGKeyboardFollowingController.m
//  ZoneWatcher
//
//  Created by Alexis Gallagher on 2014-04-14.
//  Copyright (c) 2014 Bloom FIlter. All rights reserved.
//

#import "ALGKeyboardFollowingController.h"

@interface ALGKeyboardFollowingController ()
@property (weak, nonatomic) UIView * followingView;
@property (weak, nonatomic) NSLayoutConstraint * constraint;
@end

@implementation ALGKeyboardFollowingController

- (instancetype)initWithView:(UIView *)followingView
                 bottomSpacerLayoutConstraint:(NSLayoutConstraint *)bottomSpacerConstraint
{
    self = [super init];
    if (self) {
      // assert: followingView has a window
      
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
  // ensure it has a window, so is in a view hierarchy
  if (self.followingView.window == nil) {
    return NO;
  }

  // ensure it's within the window's bounds (i.e., onscreen)
  if (!CGRectIntersectsRect([self.followingView.window convertRect:self.followingView.frame
                                                          fromView:self.followingView.superview],
                            self.followingView.window.bounds)) {
    return NO;
  }

  return YES;
//  // see if the view is the deepest subtree at its center
//  CGPoint center = self.followingView.layer.position;
//  CALayer * hitLayer = [self.followingView.layer hitTest:center];
//  // Q: is hitLayer a descendent of followingView.layer?
  
  
//  // ensure it is not hidden
//  if (self.followingView.hidden == YES) {
//    return NO;
//  }
  
  
  
  // ensure it's not occluded
  // FIXME: implement
  return YES;
}

@end
