//
//  CUIStatusLabel.m
//  CircuitUI
//
//  Created by Igor Gorodnikov on 20.08.2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIStatusLabel.h"

#import "CUILabel+Private.h"
#import "CUIStatusVariantColors.h"

@implementation CUIStatusLabel

@dynamic backgroundColor;
@dynamic layer;
@dynamic textAlignment;
@dynamic numberOfLines;
@dynamic adjustsFontSizeToFitWidth;

- (instancetype)initWithText:(NSString *)text variant:(CUIStatusVariant)variant {
    self = [super initWithText:text];
    if (self) {
        self.variant = variant;
    }

    return self;
}

- (void)cui_commonInit {
    NSAssert([self class] != CUIStatusLabel.class, @"CUIStatusLabel may not be used directly. Please use one of its subclasses. See class documentation.");
    [super cui_commonInit];

    [self setTextAlignment:NSTextAlignmentCenter];
    self.clipsToBounds = YES;
}

- (SDSTextStyleConfiguration *)createTextStyleConfiguration {
    return CUITextStyleCreateStatusComponent(self.variant);
}

- (UIColor *)createBackgroundColor:(CUIStatusVariant)variant {
    return CUITintColorFromStatusVariant(variant);
}

- (CGFloat)cui_lineSpacing {
    return 2;
}

- (void)setVariant:(CUIStatusVariant)variant {
    _variant = variant;
    [self cui_updateTextStyle];
    super.backgroundColor = [self createBackgroundColor:variant];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureCornerRadius];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self configureCornerRadius];
}

- (void)configureCornerRadius {
    super.layer.cornerRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0;
}

@end
