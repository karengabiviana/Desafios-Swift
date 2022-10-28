//
//  CUICircleView.h
//  CircuitUI
//
//  Created by Victor Kachalov on 17.06.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

@import SDSDesignSystem;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface CUICircleView : UIView

#pragma mark - Unavailable

- (void)sds_applyBackgroundColorStyle:(nullable SDSColorStyle)style NS_SWIFT_NAME(apply(backgroundColorStyle:)) NS_UNAVAILABLE;
- (void)sds_applyBackgroundColorStyle:(nullable SDSColorStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(backgroundColorStyle:from:)) NS_UNAVAILABLE;
- (void)sds_applyBorderColorStyle:(nullable SDSColorStyle)style NS_SWIFT_NAME(apply(borderColorStyle:)) NS_UNAVAILABLE;
- (void)sds_applyBorderColorStyle:(nullable SDSColorStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(borderColorStyle:from:)) NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
