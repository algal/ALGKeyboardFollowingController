//
//  ALGKeyboardFollowingController.h
//  ZoneWatcher
//
//  Created by Alexis Gallagher on 2014-04-14.
//  Copyright (c) 2014 Bloom FIlter. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A controller object which keeps a given view aligned with the keyboard, by listening for
 keyboard frame change notifications, and animating the view in tandem with the keyboard.
 
 This is just a controller, not a view controller. To use it, just initialize it in the 
 view controller's viewDidLoad method and save it in a strong property.
 To stop using it, just nil the property to destroy the controller.
 
 */

@interface ALGKeyboardFollowingController : NSObject

/**
 
 Creates a controller which ensures that a given view always moves in alignment with the keyboard.
 
 @param followingView a view which you want to follow the keyboard. Not retained.
 
 @param bottomSpacerConstraint the NSLayoutConstraint that governs the vertical spacing between the bottom of the followingView and the bottom of the screen. You could said this to have a constant property of 0 in your storyboard, when the keyboard is not present. The controller will update the constant as needed when the keyboard assembly appars. Not retained.
 
 @discussion This controller does not retain the view or the constraint: the constraint must
 already be added to the view, and the view must already be in the view hierarchy.
 
 */
- (instancetype)        initWithView:(UIView *)followingView
        bottomSpacerLayoutConstraint:(NSLayoutConstraint *)bottomSpacerConstraint;
@end
