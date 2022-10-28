//
//  CTAButton.m
//  CircuitUI
//
//  Created by Eduardo Domene on 15.12.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CTAButton.h"
#import "CUIButton+Private.h"
#import "CUIButtonStyle.h"

@implementation CTAButton

- (instancetype)initWithSize:(CUIButtonSize)size {
    self = [super init];
    if (self) {
        [self setSize:size];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title size:(CUIButtonSize)size {
    self = [super initWithTitle:title];
    if (self) {
        [self setTitle:title];
        [self setSize:size];
    }

    return self;
}

- (SDSButtonStyleConfiguration *)createButtonStyleConfiguration {
    SDSTextStyleConfiguration *textStyle;
    switch (_size) {
        case CUIButtonSizeGiga:
            textStyle = CTATextStyleGiga();
            break;
        case CUIButtonSizeKilo:
            textStyle = CTATextStyleKilo();
            break;
    }
    SDSButtonStyleConfiguration *config = [SDSButtonStyleConfiguration buttonStyleConfigurationWithTextStyleConfiguration:textStyle];
    return config;
}

- (void)setSize:(CUIButtonSize)size {
    _size = size;
    [self reloadButtonStyle];
    [self invalidateIntrinsicContentSize];
}

- (void)setTitle:(NSString *)title {
    [self setEnabledStateTitle:title];
    [self setDisabledStateTitle:title];
    [self invalidateIntrinsicContentSize];
}

- (void)setEnabledStateTitle:(NSString *)title {
    NSMutableAttributedString *normalString = [[NSMutableAttributedString alloc] initWithString:title];
    [normalString addAttribute:NSUnderlineStyleAttributeName
                         value:[NSNumber numberWithInt:1]
                         range:(NSRange){0,[normalString length]}];

    [self setAttributedTitle:normalString forState:UIControlStateNormal];
}

- (void)setDisabledStateTitle:(NSString *)title {
    NSMutableAttributedString *disabledString = [[NSMutableAttributedString alloc] initWithString:title];
    [self setAttributedTitle:disabledString forState:UIControlStateDisabled];
}

- (CGSize)intrinsicContentSize {
    CGSize labelSize = [self.titleLabel intrinsicContentSize];
    CGFloat width = labelSize.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right;
    CGFloat height = labelSize.height;
    return CGSizeMake(width, height);
}

@end
