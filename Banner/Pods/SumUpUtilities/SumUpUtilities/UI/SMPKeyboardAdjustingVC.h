//
//  SMPKeyboardAdjustingVC.h
//  Cashier
//
//  Created by Thomas Lange on 15.11.11.
//  Copyright (c) 2011 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * @class ISHKeyboardAdjustingVC
 * @abstract VC with integrated scrollview when the keyboard hides something
 */
@interface SMPKeyboardAdjustingVC : UIViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

/**
 *  The view you want to focus.
 *  Normally this would be a confirmation button that submits the data entered in the TextFields above
 */
@property (readonly, nonatomic, nullable) UIView *viewToFocus;

/**
 *  Custom space between viewToFocusWhenPresentKeyboard and keyboard
 *  optional, SMPKeyboardAdjustingViewToFocusMarginToBottom is used as fallback
 */
- (CGFloat)spacingOfViewToFocusAndKeyboard;

/**
 *   Called when keyboard appearance changes.
 *   Subclasses may override this method to fine-tune how they react to the keyboard.
 *
 *   @param coveredFrame The frame of the view controller's view covered by the
 *                     keyboard. When the keyboard is hidden, this frame is empty.
 */
- (void)updateForKeyboardCoveringFrame:(CGRect)coveredFrame withAnimationDuration:(NSTimeInterval)duration;

@property (nonatomic, readonly, getter=isVisible) BOOL visible;

@end

NS_ASSUME_NONNULL_END
