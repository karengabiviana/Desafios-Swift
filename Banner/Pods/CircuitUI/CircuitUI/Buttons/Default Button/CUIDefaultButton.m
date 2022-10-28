//
//  CUIDefaultButton.m
//  CircuitUI
//
//  Created by Florian Schliep on 02.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIDefaultButton.h"
#import "CUIButton+Private.h"
#import "CUIButtonStyle.h"
#import "CUIDefaultButton+DebugMenu.h"

@interface CUIDefaultButton ()

@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation CUIDefaultButton

- (instancetype)initWithVariant:(CUIButtonVariant)variant size:(CUIButtonSize)size {
    self = [super init];
    if (self) {
        _variant = variant;
        _size = size;
    }
    return self;
}

- (SDSButtonStyleConfiguration *)createButtonStyleConfiguration {
    SDSButtonStyleConfiguration *config = [SDSButtonStyleConfiguration buttonStyleConfigurationWithTextStyleConfiguration:CUIButtonDefaultStyleCreateTextStyle(self.variant, self.isDestructive)];
    config.minimumHeight = [SDSStatefulScalar statefulScalarWithValue:@(CUIButtonStyleMinHeight(self.size))];
    config.paddingHorizontal = [SDSStatefulScalar statefulScalarWithValue:@(CUIButtonStyleHorizontalPadding(self.size, self.variant, self.hasTitleInCurrentState))];
    config.borderWidth = [SDSStatefulScalar statefulScalarWithValue:@(CUIButtonStyleBorderWidth(self.variant))];

    return config;
}

- (BOOL)hasRoundedCorners {
    switch (self.variant) {
        case CUIButtonVariantTertiary:
            return NO;
        case CUIButtonVariantPrimary:
        case CUIButtonVariantSecondary:
            break; // attention: fallthrough!
    }

    return YES;
}

- (void)setVariant:(CUIButtonVariant)variant {
    _variant = variant;
    [self reloadButtonStyle];

    if ([[self class] __useBlackWhiteTheme]) {
        [self setTitle:[self titleForState:UIControlStateNormal] forState:UIControlStateNormal];
        [self setTitle:[self titleForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    }
}

- (void)setSize:(CUIButtonSize)size {
    _size = size;
    [self reloadButtonStyle];
    [self invalidateIntrinsicContentSize];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    if ([[self class] __useBlackWhiteTheme] && self.variant == CUIButtonVariantTertiary && title.length) {
        NSMutableAttributedString *normalString = [[NSMutableAttributedString alloc] initWithString:title];
        [normalString addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInt:1]
                             range:(NSRange){0,[normalString length]}];
        [self setAttributedTitle:normalString forState:state];
        return;
    }

    [super setTitle:title forState:state];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.isActivityIndicatorVisible) {
        [self bringSubviewToFront:_activityIndicatorView];
    }
}

- (BOOL)isActivityIndicatorVisible {
    return _activityIndicatorView.isAnimating;
}

- (void)startActivityIndicatorAnimation {
    if (self.isActivityIndicatorVisible) {
        return;
    }

    [self setUserInteractionEnabled:NO];

    UIActivityIndicatorView *loadingView = [UIActivityIndicatorView new];
    loadingView.hidesWhenStopped = YES;
    loadingView.userInteractionEnabled = NO;
    loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:loadingView];
    [NSLayoutConstraint activateConstraints:@[
        [loadingView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [loadingView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];
    _activityIndicatorView = loadingView;

    _activityIndicatorView.activityIndicatorViewStyle = [self activityIndicatorViewStyle];
    _activityIndicatorView.color = [self activityIndicatorTintColor];

    [[self titleLabel] setAlpha:0];

    [CATransaction lock];
    [CATransaction setDisableActions:YES];
    // the only solution that hide the image it is scale it to 0 size, hidden / alpha properties doesn't work.
    [self imageView].layer.transform = CATransform3DMakeScale(0, 0, 0);
    [CATransaction unlock];

    [self bringSubviewToFront:_activityIndicatorView];
    [_activityIndicatorView startAnimating];

    [self reloadButtonStyle];
}

- (void)stopActivityIndicatorAnimation {
    // nothing to do if activity indicator is not exist yet
    if (_activityIndicatorView == nil) {
        return;
    }

    [self setUserInteractionEnabled:YES];

    [_activityIndicatorView stopAnimating];

    [[self titleLabel] setAlpha:1];

    [CATransaction lock];
    [CATransaction setDisableActions:YES];
    // restore image to original size after manipulation in `startActivityIndicatorAnimation` function
    [self imageView].layer.transform = CATransform3DIdentity;
    [CATransaction unlock];

    [self reloadButtonStyle];

    [_activityIndicatorView removeFromSuperview];
    _activityIndicatorView = nil;
}

// MARK: - Misc

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    switch (self.variant) {
        case CUIButtonVariantTertiary:
            return UIActivityIndicatorViewStyleWhite;
        case CUIButtonVariantPrimary:
            return UIActivityIndicatorViewStyleWhite;
        case CUIButtonVariantSecondary:
            return UIActivityIndicatorViewStyleGray;
    }
}

- (UIColor *)activityIndicatorTintColor {
    switch (self.variant) {
        case CUIButtonVariantTertiary:
            return [UIColor blueColor];
        case CUIButtonVariantPrimary:
            return [UIColor whiteColor];
        case CUIButtonVariantSecondary:
            return [UIColor grayColor];
    }
}

// MARK: - Debug Menu

static NSString * _Nonnull CUIDefaultButtonUseBlackWhiteTheme = @"CUIDefaultButtonUseBlackWhiteTheme";

+ (BOOL)__useBlackWhiteTheme {
    return [[NSUserDefaults standardUserDefaults] boolForKey:CUIDefaultButtonUseBlackWhiteTheme];
}

+ (void)set__useBlackWhiteTheme:(BOOL)__useBlackWhiteTheme {
    [[NSUserDefaults standardUserDefaults] setBool:__useBlackWhiteTheme forKey:CUIDefaultButtonUseBlackWhiteTheme];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
