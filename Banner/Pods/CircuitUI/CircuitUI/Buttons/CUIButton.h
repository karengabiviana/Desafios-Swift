//
//  CUIButton.h
//  CircuitUI
//
//  Created by Florian Schliep on 01.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * Base class for buttons of CircuitUI. This class is not meant to be used directly, please only use its subclassess directly.
 */
@interface CUIButton : UIButton

@property (nonatomic, getter=isDestructive) BOOL destructive;
@property (nonatomic, getter=allowsMultilineTitle) BOOL allowMultilineTitle;
@property (nonatomic) BOOL adjustsFontSizeToFitWidth; 

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image;

+ (instancetype)buttonWithTitle:(NSString *)title;
+ (instancetype)buttonWithImage:(UIImage *)image;
+ (instancetype)buttonWithTitle:(nullable NSString *)title image:(nullable UIImage *)image;

#pragma mark - Unavailable

+ (instancetype)buttonWithType:(UIButtonType)buttonType NS_UNAVAILABLE;
+ (instancetype)buttonWithType:(UIButtonType)buttonType primaryAction:(nullable UIAction *)primaryAction NS_UNAVAILABLE;
+ (instancetype)systemButtonWithImage:(UIImage *)image target:(nullable id)target action:(nullable SEL)action NS_UNAVAILABLE;
+ (instancetype)systemButtonWithPrimaryAction:(nullable UIAction *)primaryAction NS_UNAVAILABLE;

- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state NS_UNAVAILABLE;
- (void)setTitleShadowColor:(nullable UIColor *)color forState:(UIControlState)state NS_UNAVAILABLE;

@property (null_resettable, nonatomic,strong) UIColor *tintColor UNAVAILABLE_ATTRIBUTE;
@property (nonatomic, strong) UIFont *font UNAVAILABLE_ATTRIBUTE;
@property (nonatomic) CGSize titleShadowOffset UNAVAILABLE_ATTRIBUTE;
@property (nonatomic) BOOL adjustsImageWhenHighlighted UNAVAILABLE_ATTRIBUTE;
@property (nonatomic) BOOL adjustsImageWhenDisabled UNAVAILABLE_ATTRIBUTE;


@end

NS_ASSUME_NONNULL_END
