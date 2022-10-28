//
//  CUILabel.h
//  CircuitUI
//
//  Created by Florian Schliep on 22.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit;
@import SDSDesignSystem;

NS_ASSUME_NONNULL_BEGIN

typedef void (^CUIURLCompletion)(BOOL success) NS_SWIFT_NAME(URLCompletion);

/**
 * Base class for labels of CircuitUI. This class is not meant to be used directly, please only use its subclasses directly.
 */
@interface CUILabel : UILabel

/**
 * Creates a new instance and sets the given parameter as the label's `text`.
 */
- (instancetype)initWithText:(nullable NSString *)text NS_SWIFT_NAME(init(_:));

/**
 * Creates a new instance and sets the given parameter as the label's `text`.
 */
+ (instancetype)labelWithText:(nullable NSString *)text NS_SWIFT_UNAVAILABLE("Use -initWithText: instead.");

/**
 * The styled text that the label is displaying. This property cannot be set directly, but will be set when the `text`
 * property is set. For applications where the attributes of the string are required, please make sure that the `text`
 * property is first set, subsequently, the attributes of the label can be extracted from this property.
 */
@property (nonatomic, readonly) NSAttributedString *attributedString;

/**
 *  Valid values lie between 0.0 and 1.0 inclusive. The default value is 0.0.
 *  Hyphenation is attempted when the ratio of the text width (as broken without hyphenation) to the width of the
 *  line fragment is less than the hyphenation factor. When the paragraph’s hyphenation factor is 0.0,
 *  the layout manager’s hyphenation factor is used instead. When both are 0.0, hyphenation is disabled.
 *  This property detects the user-selected language by examining the first item in preferredLanguages.
 */
@property (nonatomic) float hyphenationFactor;

#pragma mark - Unavailable

@property (null_resettable, nonatomic, strong) UIFont *font NS_UNAVAILABLE;
@property (null_resettable, nonatomic, strong) UIColor *textColor NS_UNAVAILABLE;
@property (nullable, nonatomic, strong) UIColor *shadowColor NS_UNAVAILABLE;
@property (nonatomic) CGSize shadowOffset NS_UNAVAILABLE;
@property (nullable, nonatomic, copy) NSAttributedString *attributedText NS_UNAVAILABLE;
@property (nullable, nonatomic, strong) UIColor *highlightedTextColor NS_UNAVAILABLE;
@property (nonatomic, getter=isHighlighted) BOOL highlighted NS_UNAVAILABLE;
@property (nonatomic, getter=isEnabled) BOOL enabled NS_UNAVAILABLE;
@property (nonatomic, nullable) SDSTextStyleConfiguration *sds_textStyle NS_UNAVAILABLE;

- (void)sds_applyTextStyle:(SDSTextStyle)style NS_SWIFT_NAME(apply(textStyle:)) NS_UNAVAILABLE;
- (void)sds_applyTextStyle:(SDSTextStyle)style invertedColor:(BOOL) inverted NS_SWIFT_NAME(apply(textStyle:invertedColor:)) NS_UNAVAILABLE;
- (void)sds_applyTextStyle:(SDSTextStyle)style invertedColor:(BOOL)inverted fromStyleSheet:(SDSStyleSheet *) styleSheet NS_SWIFT_NAME(apply(textStyle:invertedColor:from:)) NS_UNAVAILABLE;
- (void)sds_applyTextStyleFromButtonStyle:(SDSButtonStyle)style NS_SWIFT_NAME(apply(textStyleFrom:)) NS_UNAVAILABLE;
- (void)sds_applyTextStyleFromButtonStyle:(SDSButtonStyle)style invertedColor:(BOOL)inverted NS_SWIFT_NAME(apply(textStyleFrom:invertedColor:)) NS_UNAVAILABLE;
- (void)sds_applyTextStyleFromButtonStyle:(SDSButtonStyle)style invertedColor:(BOOL)inverted fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(textStyleFrom:invertedColor:from:)) NS_UNAVAILABLE;
- (void)sds_stopObservingContentSizeCategoryChanges NS_SWIFT_NAME(stopObservingContentSizeCategoryChanges()) NS_UNAVAILABLE;
@property (nonatomic, getter=sds_isEnabled) BOOL sds_enabled NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
