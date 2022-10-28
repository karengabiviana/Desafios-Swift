//
//  CUIStatusLine.h
//  CircuitUI
//
//  Created by Hagi on 04.10.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIStatusVariant.h"
@import SDSDesignSystem;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CUIStatusLineIcon) {
    CUIStatusLineIconAlert,
    CUIStatusLineIconConfirm,
    CUIStatusLineIconNotify,
    CUIStatusLineIconPaidOut,
    CUIStatusLineIconRefunded,
    CUIStatusLineIconTime,
    CUIStatusLineIconInfo
} NS_SWIFT_NAME(StatusLineIcon);

/**
 *  The Status Line component indicates a status through text, colors,
 *  and an icon.
 */
NS_SWIFT_NAME(StatusLine)
@interface CUIStatusLine : UIView

/**
 *  The icon to be displayed in a leading position.
 */
@property (nonatomic) CUIStatusLineIcon icon;
/**
 *  The text describing the applied status. Should be brief.
 */
@property (nonatomic) NSString *text;
/**
 *  The status determines the overall color scheme and appearance.
 */
@property (nonatomic) CUIStatusVariant variant;

/**
 *  Creates a new status line component. See properties for per-parameter
 *  documentation.
 */
- (instancetype)initWithIcon:(CUIStatusLineIcon)icon text:(NSString *)statusText variant:(CUIStatusVariant)variant NS_DESIGNATED_INITIALIZER NS_REFINED_FOR_SWIFT;

#pragma mark - Unavailable

@property (nullable, nonatomic, copy) UIColor *backgroundColor UI_APPEARANCE_SELECTOR NS_UNAVAILABLE;
@property (nonatomic, readonly, strong) CALayer *layer NS_UNAVAILABLE;

- (void)sds_applyBackgroundColorStyle:(nullable SDSColorStyle)style NS_SWIFT_NAME(apply(backgroundColorStyle:)) NS_UNAVAILABLE;
- (void)sds_applyBackgroundColorStyle:(nullable SDSColorStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(backgroundColorStyle:from:)) NS_UNAVAILABLE;
- (void)sds_applyBorderColorStyle:(nullable SDSColorStyle)style NS_SWIFT_NAME(apply(borderColorStyle:)) NS_UNAVAILABLE;
- (void)sds_applyBorderColorStyle:(nullable SDSColorStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(borderColorStyle:from:)) NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
