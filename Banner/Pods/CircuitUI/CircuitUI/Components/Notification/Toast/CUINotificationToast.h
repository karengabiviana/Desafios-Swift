//
//  CUINotificationToast.h
//  CircuitUI
//
//  Created by Anuraag Shakya on 01.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CUINotificationToastVariant) {
    CUINotificationToastVariantNeutral,
    CUINotificationToastVariantConfirm,
    CUINotificationToastVariantNotify,
    CUINotificationToastVariantAlert
} NS_SWIFT_NAME(NotificationToastVariant);

typedef NS_ENUM(NSUInteger, CUINotificationToastDismissCause) {
    CUINotificationToastDismissCauseClose,
    CUINotificationToastDismissCauseCTA,
    CUINotificationToastDismissCauseProgrammatic
 } NS_SWIFT_NAME(NotificationToastDismissCause);

typedef NS_ENUM(NSUInteger, CUINotificationToastTransition) {
    CUINotificationToastTransitionNone,
    CUINotificationToastTransitionSlideIn
 } NS_SWIFT_NAME(NotificationToastTransition);

typedef void(^CUINotificationToastDismissResultBlock)(CUINotificationToastDismissCause);

NS_SWIFT_NAME(NotificationToast)
@interface CUINotificationToast : UIView

@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) CUINotificationToastVariant variant;

/**
 Create a simple notification toast without CTA or dismiss button.

 When this initializer is used, both the presentation and dismissal are the responsibility of the caller, there
 won't be buttons on the toast for dismissal based on user interaction.

 Use the initializer with the CTA parameters (`actionTitle`, `dismissResultBlock`) if it needs to be presented above a view
 and needs to be able to be dismissed by user interaction.
 */
- (instancetype)initWithTitle:(nullable NSString *)title subtitle:(NSString *)subtitle variant:(CUINotificationToastVariant)variant;

/**
 Create a notification toast with CTA and dismiss button.

 This type of notification should only be used for presentation above a view (see `showInView`). If the toast is needed in-line or will be
 manually used and inserted into the call hierarchy, use the initializer without the CTA parameters (`actionTitle`, `dismissResultBlock`).

 @warning If you add a notification created by this initializer manually to a view hierarchy, your view hierarchy needs to be prepared for
 the notification being removed upon dismiss or CTA button presses and adjust accordingly.

 @param actionTitle The title of the CTA
 @param dismissResultBlock The block that will be called after the notification toast is dismissed with the cause of the dismissal
 */
- (instancetype)initWithTitle:(nullable NSString *)title subtitle:(NSString *)subtitle variant:(CUINotificationToastVariant)variant actionTitle:(NSString *)actionTitle dismissResultBlock:(CUINotificationToastDismissResultBlock)dismissResultBlock;

/**
 Create a notification toast with dismiss button.

 This type of notification should only be used for presentation above a view (see `showInView`). If the toast is needed in-line or will be
 manually used and inserted into the call hierarchy, use the initializer without `dismissResultBlock`.

 @param dismissResultBlock The block that will be called after the notification toast is dismissed with the cause of the dismissal
 */
- (instancetype)initWithTitle:(nullable NSString *)title subtitle:(NSString *)subtitle variant:(CUINotificationToastVariant)variant dismissResultBlock:(CUINotificationToastDismissResultBlock)dismissResultBlock;

- (void)addLinkInSubtitleWithURL:(NSURL *)url toSubstring:(NSString *)substring;
- (void)addLinkInSubtitleWithURL:(NSURL *)url toRange:(NSRange)range;
/// Deprecated, use `showInView` instead
- (void)floatAboveView:(UIView *)containerView __deprecated_msg("use `showInView` instead");
/**
 Present the notification toast in a view.

 The notification toast can float above content, when the message is referring to the whole page.
 This method positions the notification toast at the bottom of the screen with the CircuitUI defined alignment and spacing to the bottom.
 */
- (void)showInView:(UIView *)containerView;
/**
 Present the notification toast in a view with a specified transition.

 The notification toast can float above content, when the message is referring to the whole page.
 This method positions the notification toast at the bottom of the screen with the CircuitUI defined alignment and spacing to the bottom.
 */
- (void)showInView:(UIView *)containerView transition:(CUINotificationToastTransition)transition;
/**
 Dismiss the previously presented (`showInView`) toast.

 The dismissal will remove the toast from the view hierarchy and call the `dismissResultBlock` if availalbe with the `.programmatic` dismiss cause.
 */
- (void)dismiss;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
