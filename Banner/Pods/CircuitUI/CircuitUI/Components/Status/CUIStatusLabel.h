//
//  CUIStatusLabel.h
//  SDSDesignSystem
//
//  Created by Igor Gorodnikov on 20.08.2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabel.h"
#import "CUIStatusVariant.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Base class for various status components of CircuitUI. This class is not meant to be used directly, please only use its subclasses directly:
 *  - `CUIStatusBadge`
 *  - `CUIStatusPill`
 *
 *  You can also use `CUIStatusLine`, which isn't a direct subclass, but
 *  also includes a status label.
 */
NS_SWIFT_NAME(StatusLabel)
@interface CUIStatusLabel : CUILabel

@property (nonatomic) CUIStatusVariant variant;

/**
 * Creates a new instance and sets the given parameter as the label's `text`.
 */
- (instancetype)initWithText:(NSString *)text variant:(CUIStatusVariant)variant NS_SWIFT_NAME(init(text:variant:)) NS_DESIGNATED_INITIALIZER;

#pragma mark - Unavailable

@property (nullable, nonatomic, copy) UIColor *backgroundColor UI_APPEARANCE_SELECTOR NS_UNAVAILABLE;
@property (nonatomic, readonly, strong) CALayer *layer NS_UNAVAILABLE;
@property (nonatomic) NSTextAlignment textAlignment NS_UNAVAILABLE;
@property (nonatomic) NSInteger numberOfLines NS_UNAVAILABLE;
@property (nonatomic) BOOL adjustsFontSizeToFitWidth NS_UNAVAILABLE;

- (void)sds_applyBackgroundColorStyle:(nullable SDSColorStyle)style NS_SWIFT_NAME(apply(backgroundColorStyle:)) NS_UNAVAILABLE;
- (void)sds_applyBackgroundColorStyle:(nullable SDSColorStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(backgroundColorStyle:from:)) NS_UNAVAILABLE;
- (void)sds_applyBorderColorStyle:(nullable SDSColorStyle)style NS_SWIFT_NAME(apply(borderColorStyle:)) NS_UNAVAILABLE;
- (void)sds_applyBorderColorStyle:(nullable SDSColorStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(borderColorStyle:from:)) NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithText:(nullable NSString *)text NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

