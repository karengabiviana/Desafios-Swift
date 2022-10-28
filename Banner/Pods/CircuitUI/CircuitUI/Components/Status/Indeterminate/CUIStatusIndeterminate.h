//
//  CUIStatusIndeterminate.h
//  CircuitUI
//
//  Created by Victor Kachalov on 17.06.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "CUIStatusVariant.h"

@import SDSDesignSystem;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 *  The Status Indeterminate component indicates a status through color
 */
NS_SWIFT_NAME(StatusIndeterminate)
@interface CUIStatusIndeterminate : UIView
/**
 *  The status determines the overall color scheme and appearance.
 */
@property (nonatomic) CUIStatusVariant variant;
/**
 *  Creates a new status indeterminate component. See properties for per-parameter
 *  documentation.
 */
- (instancetype)initWithVariant:(CUIStatusVariant)variant NS_DESIGNATED_INITIALIZER NS_REFINED_FOR_SWIFT;

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
