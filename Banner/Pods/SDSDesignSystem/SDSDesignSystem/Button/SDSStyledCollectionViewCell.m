//
//  SDSStyledCollectionViewCell.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 19.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSStyledCollectionViewCell.h"
#import "SDSButtonStyleConfiguration.h"
#import "SDSShadowView.h"

@interface SDSStyledCollectionViewCell ()
@property (nonatomic) BOOL didRegisterForNotifications;
@property (nonatomic) SDSShadowView *shadowBackgroundView;
@property (nonatomic, readwrite) SDSButtonStyleConfiguration *buttonStyle;
@end

@implementation SDSStyledCollectionViewCell

- (SDSShadowView *)shadowBackgroundView {
    if (_shadowBackgroundView) {
        return _shadowBackgroundView;
    }
    NSAssert(self.backgroundView == nil, @"we expect the background view to be nil as this cell class uses the background view to render a shadow");
    _shadowBackgroundView = [[SDSShadowView alloc] initWithFrame:self.contentView.bounds];
    [_shadowBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.backgroundView = _shadowBackgroundView;
    return _shadowBackgroundView;
}

- (void)setBackgroundView:(UIView *)backgroundView {
    NSAssert([backgroundView isKindOfClass:[SDSShadowView class]], @"this cell class relies on the background view being a SDSShadowView view to render the background and style");
    [super setBackgroundView:backgroundView];
}

- (void)setButtonStyle:(SDSButtonStyleConfiguration *)style {
    _buttonStyle = style;
    [self updateForButtonStyle:style];
}

- (void)applyButtonStyle:(SDSButtonStyle)style {
    [self applyButtonStyle:style fromStyleSheet:[SDSStyleSheet global]];
}

- (void)applyButtonStyle:(SDSButtonStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet {
    SDSButtonStyleConfiguration *configuration = [styleSheet configurationForButtonStyle:style];

    if (configuration) {
        [self setButtonStyle:configuration];
    }
}

- (void)updateForCurrentButtonStyle {
    if (!self.buttonStyle) {
        return;
    }

    [self updateForButtonStyle:self.buttonStyle];
}

- (void)updateForButtonStyle:(SDSButtonStyleConfiguration *)style {
    [self invalidateIntrinsicContentSize];
    [self.shadowBackgroundView setShadow:style.shadow];
    [self updateForControlState:self.state];
}

#pragma mark - Control state

- (UIControlState)state {
    if (self.isHighlighted) {
        return UIControlStateHighlighted;
    }

    if (self.isSelected) {
        return UIControlStateSelected;
    }

    if (!self.isUserInteractionEnabled) {
        return UIControlStateDisabled;
    }

    return UIControlStateNormal;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateForControlState:self.state];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateForControlState:self.state];
}

- (void)updateForControlState:(UIControlState)controlState {
    [self.contentView.layer setBorderWidth:[[self.buttonStyle.borderWidth valueForState:controlState] doubleValue]];

    if (self.buttonStyle.borderWidth && self.buttonStyle.borderColor) {
        [self.contentView.layer setBorderColor:[[self.buttonStyle.borderColor valueForState:controlState] CGColor]];
    }

    CGFloat cornerRadius = [[self.buttonStyle.cornerRadius valueForState:controlState] doubleValue];
    [self.contentView.layer setCornerRadius:cornerRadius];
    [self.shadowBackgroundView setCornerRadius:cornerRadius];
    [self.shadowBackgroundView setControlState:controlState];
    [self.shadowBackgroundView setBackgroundColor:[self.buttonStyle.backgroundColor valueForState:controlState]];

    [self.contentView setClipsToBounds:NO];
    [self setClipsToBounds:NO];
}

@end

