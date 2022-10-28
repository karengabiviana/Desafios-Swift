//
//  ISHKeyboardAdjustingVC.m
//  Cashier
//
//  Created by Thomas Lange on 15.11.11.
//  Copyright (c) 2011 iosphere GmbH. All rights reserved.
//

#import "SMPKeyboardAdjustingVC.h"

#import "SMPMacroHelpers.h"

const CGFloat SMPKeyboardAdjustingViewToFocusMarginToBottomIPad = 24.0;
const CGFloat SMPKeyboardAdjustingViewToFocusMarginToBottomIPhone = 8.0;

@interface SMPKeyboardAdjustingVC ()

@property (nonatomic) CGPoint initialContentOffset;
@property (nonatomic) UIEdgeInsets initialContentInset;
@property (nonatomic) CGRect lastKnownKeyboardFrame;

@end

@implementation SMPKeyboardAdjustingVC

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self resetInitialInsetAndOffset];
    [self startListeningForKeyboardNotifications];
}

- (void)dealloc {
    [self stopListeningForKeyboardNotifications];
}

- (UIView *)viewToFocus {
    return nil;
}

- (CGFloat)spacingOfViewToFocusAndKeyboard {
    return SMP_UIDEVICE_IS_IPHONE ? SMPKeyboardAdjustingViewToFocusMarginToBottomIPhone : SMPKeyboardAdjustingViewToFocusMarginToBottomIPad;
}

- (void)startListeningForKeyboardNotifications {
    // avoid duplicates in observation
    [self stopListeningForKeyboardNotifications];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UIKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UIKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // UIKeyboardWillShowNotification allows nice animation together with Keyboard's, on iPad however we need the screen position of ViewController's view which is possibly presented modally in a FormSheet (not available before UIKeyboardDidShowNotification)
    if (SMP_UIDEVICE_IS_IPAD) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(UIKeyboardDidShowNotification:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
    }
}

- (void)stopListeningForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (CGSize)contentSizeForScrollView {
    UIView *focus = [self viewToFocus];

    if (!focus) {
        return self.scrollView.bounds.size;
    }

    return CGSizeMake(self.view.frame.size.width, [self.scrollView convertPoint:focus.frame.origin fromView:focus.superview].y + focus.frame.size.height + [self spacingOfViewToFocusAndKeyboard]);
}

#pragma mark UIKeyboardNotification methods

/*
 *   Please note: Show/hide notifications may be unbalanced. This is typically
 *   the case for custom keyboards, where multiple WhillShow/DidShow notifications
 *   are sent, and only the last pair contains the correct frame values.
 *
 *   There's also UIKeyboardDidChangeFrameNotification, but it is always followed
 *   by WillShow with the same frame information.
 */

- (void)UIKeyboardWillShowNotification:(NSNotification *)notification {
    CGRect keyboardFrame = [self keyboardFrameFromNotification:notification];
    NSTimeInterval keyboardAppearanceDuration = [self keyboardAnimationDurationFromNotification:notification];

    if (CGRectEqualToRect(keyboardFrame, self.lastKnownKeyboardFrame)) {
        return;
    }

    [self setupInitialOffsetAndInsetIfNeeded];

    if (SMP_UIDEVICE_IS_IPAD) {
        return;
    }

    [self animateKeyboardForFrame:keyboardFrame withAnimationDuration:keyboardAppearanceDuration];
}

- (void)UIKeyboardDidShowNotification:(NSNotification *)notification {
    if (!SMP_UIDEVICE_IS_IPAD) {
        return;
    }

    CGRect keyboardFrame = [self keyboardFrameFromNotification:notification];
    NSTimeInterval keyboardAppearanceDuration = [self keyboardAnimationDurationFromNotification:notification];

    if (CGRectEqualToRect(keyboardFrame, self.lastKnownKeyboardFrame)) {
        return;
    }

    [self animateKeyboardForFrame:keyboardFrame withAnimationDuration:keyboardAppearanceDuration];
}

- (void)UIKeyboardWillHideNotification:(NSNotification *)aNotification {
    if (CGRectEqualToRect(self.lastKnownKeyboardFrame, CGRectZero)) {
        return;
    }

    UIEdgeInsets contentInsets = self.initialContentInset;
    NSTimeInterval keyboardAppearanceDuration = [self keyboardAnimationDurationFromNotification:aNotification];

    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    self.scrollView.contentOffset = self.initialContentOffset;

    // call reset as subclasses may not call it in updateForCoveredFrame
    [self resetInitialInsetAndOffset];
    [self updateForKeyboardCoveringFrame:CGRectZero withAnimationDuration:keyboardAppearanceDuration];
}

#pragma mark - Keyboard Notification Helpers

- (CGRect)keyboardFrameFromNotification:(NSNotification *)notification {
    NSValue *rectValue = SMPSafeCast(notification.userInfo[UIKeyboardFrameEndUserInfoKey], [NSValue class]);
    return rectValue ? rectValue.CGRectValue : CGRectZero;
}

- (NSTimeInterval)keyboardAnimationDurationFromNotification:(NSNotification *)notification {
    NSNumber *animationDuration = SMPSafeCast(notification.userInfo[UIKeyboardAnimationDurationUserInfoKey], [NSNumber class]);
    return animationDuration.doubleValue;
}

- (void)setupInitialOffsetAndInsetIfNeeded {
    if (UIEdgeInsetsEqualToEdgeInsets(self.initialContentInset, UIEdgeInsetsZero) && CGPointEqualToPoint(self.initialContentOffset, CGPointZero)) {
        self.initialContentInset = self.scrollView.contentInset;
        self.initialContentOffset = self.scrollView.contentOffset;
    }
}

- (void)resetInitialInsetAndOffset {
    self.initialContentInset = UIEdgeInsetsZero;
    self.initialContentOffset = CGPointZero;
    self.lastKnownKeyboardFrame = CGRectZero;
}

- (void)animateKeyboardForFrame:(CGRect)keyboardFrame withAnimationDuration:(NSTimeInterval)duration {
    self.lastKnownKeyboardFrame = keyboardFrame;

    UIView *focus = [self viewToFocus];

    CGRect viewToFocusFrame = [self.view.window convertRect:focus.frame fromView:focus.superview];

    // convert self frame to window coordinates, frame is in superview's coordinates
    CGRect viewInWindowFrame = [self.view.window convertRect:self.view.frame fromView:self.view.superview];

    // calculate the area of viewInWindowFrame and viewToFocusFrame that is covered by keyboard
    CGRect coveredFrame = CGRectIntersection(viewInWindowFrame, keyboardFrame);
    CGRect coveredViewToFocusFrame = CGRectIntersection(viewToFocusFrame, keyboardFrame);

    // might be rotated, so convert it back
    coveredFrame = [self.view.window convertRect:coveredFrame toView:self.view.superview];

    // only if viewToFocus is (even partly) covered we apply scrolling logic
    if (focus && CGRectIsNull(coveredViewToFocusFrame)) {
        return;
    }

    [self updateForKeyboardCoveringFrame:coveredFrame withAnimationDuration:duration];
}

- (void)updateForKeyboardCoveringFrame:(CGRect)coveredFrame withAnimationDuration:(NSTimeInterval)duration {
    if (CGRectIsEmpty(coveredFrame)) {
        [self resetInitialInsetAndOffset];
        return;
    }

    UIEdgeInsets intialInsets = self.initialContentInset;

    // determine the bottom inset of the scroll view by determining which
    // portion of the scrollview is actually covered by the coveredFrame
    // the coveredFrame is with respect to the entire view, but the scrollview
    // might not reach all the way to the bottom and hence might be covered less.
    CGRect coveredFrameOfScrollView = CGRectIntersection([self.view convertRect:self.scrollView.frame fromView:self.scrollView.superview], coveredFrame);

    intialInsets.bottom = MAX(coveredFrameOfScrollView.size.height, self.initialContentInset.bottom);
    self.scrollView.contentInset = intialInsets;
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;

    UIView *focus = [self viewToFocus];
    // Convert to scroll view's coordinates again
    CGRect updatedViewToFocusFrame = [self.scrollView convertRect:focus.frame fromView:focus.superview];
    [self.scrollView setContentSize:[self contentSizeForScrollView]];
    updatedViewToFocusFrame = CGRectInset(updatedViewToFocusFrame, 0, -[self spacingOfViewToFocusAndKeyboard]);
    [self.scrollView scrollRectToVisible:updatedViewToFocusFrame animated:YES];
}

// MARK: - The below added functions are inherited from `SMPViewController`

#pragma mark - Rotation

/*
 *   YES is the default, but we leave it in here for clarity
 *   and to make this future-proof for possible superclass
 *   changes.
 *
 *   The iPhone app could statically disable all non-portrait
 *   orientations, but it does not, as this code is needed
 *   anyway for the SDK, so we run & test the same code in our
 *   app.
 *
 *   We must allow auto rotation to allow rotation to one of
 *   our supported orientations, should the SDK present one
 *   of our screens from an unsupported orientation.
 */
+ (BOOL)shouldAutorotateDefault {
    return YES;
}

+ (UIInterfaceOrientationMask)supportedInterfaceOrientationDefaults {
    return SMP_UIDEVICE_IS_IPAD ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return [[self class] shouldAutorotateDefault];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self class] supportedInterfaceOrientationDefaults];
}

#pragma mark - Appearance

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    _visible = NO;
    [super viewWillDisappear:animated];
}

#pragma mark - Dark Mode

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}

@end
