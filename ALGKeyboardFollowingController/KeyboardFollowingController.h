//
//  KeyboardFollowingController.h
//  ALGKeyboardFollowingController
//
//  Created by Alexis Gallagher on 2015-05-31.
//  Copyright (c) 2015 Bloom Filter. All rights reserved.
//

@import UIKit;

/**

 This controller uses Auto Layout to make a view automatically avoid the keyboard. It listens 
 for notifications of changes in the keyboard's frame, and animates a specified "following view" 
 to move in tandem with the keyboard.
 
 This is just a controller, not a view controller. To use it, just initialize it in the
 view controller's `viewDidLoad` method and save it in a strong property.
 To stop using it, just nil the property to destroy the controller. (You should manage this object's
 lifetime so it is identical to the lifetime of the following view.)
 
 # Subtleties which this controller may not handle properly

 ## device rotation while the keyboard is presented.

 ## suppression of keyboard-avoidance when the following view is no longer on screen
 
 Suppose your following view contains some text fields, and is contained by the root view
 of a LoginViewController, which presents a login screen. After the user logs in, you use a
 navigation controller to push AppViewController, which presents the application's main
 logic. Within the application logic, somewhere, some other control causes the keyboard to be 
 raised. This will generate a keyboard frame change notification. The potential problem: will this
 notification trigger changes in your LoginViewController, way back at the bottom of your 
 navigiation stack?
 
 To avoid this, the controller ignores keyboard change notifications that arrive when the following
 view is not onscreen. But it tries to determine if a view is onscreen automatically, by
 checking (1) if it's part of a UIWindow, (2) if it's rect intersects with the UIWindow, and (3)
 if it or any of its descendent views are the first responder. This automatic check is not 
 100% reliable. You could construct your navigation hierarchy in such way that it mistakenly
 concluded that an invisible following view was onscreen, and this would trigger unwanted
 animations when other controls raised the keyborad.
 
 The only surefire remedy to this would be to require the client to explicitly notify the controller
 when the following view behavior should be disabled and enabled, i..e, when the following view is
 going offscreen and going back onscreen.


 ## automatic lifetime management

 
 
 
 */

@interface KeyboardFollowingController : NSObject

/**
 
 Creates a controller which ensures that a given view always moves in alignment with the keyboard.
 
 @param followingView a view which you want to follow the keyboard. Not retained.
 
 @param bottomSpacerConstraint the NSLayoutConstraint that governs the vertical spacing between the bottom of the followingView and the bottom of the screen. You could said this to have a constant property of 0 in your storyboard, when the keyboard is not present. The controller will update the constant as needed when the keyboard assembly appars. Not retained.
 
 @discussion This controller does not retain the view or the constraint: the constraint must
 already be added to the view, and the view must already be in the view hierarchy.
 
 */
- (nonnull instancetype) initWithView:(nonnull UIView *)followingView
         bottomSpacerLayoutConstraint:(nonnull NSLayoutConstraint *)bottomSpacerConstraint;
@end
