//
//  SDSStyledButton.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 08.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSStyledButton+Private.h"
#import "UILabel+SDSTextStyle+Private.h"
#import "SDSShadowView.h"

@interface SDSStyledButton ()
@property (nonatomic, readwrite) SDSShadowView *backgroundView;
@property (nonatomic) BOOL didRegisterForNotifications;
@property (nonatomic) BOOL invertedColors;

@property (nonatomic, weak) UILabel *cachedTitleLabel;

@end

@implementation SDSStyledButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    NSAssert(self.buttonType == UIButtonTypeCustom, @"Instances of SDSStyledButton must use UIButtonTypeCustom");

    SDSShadowView *shadow = [[SDSShadowView alloc] initWithFrame:self.bounds];

    [self insertSubview:shadow atIndex:0];
    _backgroundView = shadow;

    self.backgroundColor = [UIColor clearColor];
}

- (UILabel *)titleLabel {
    // workaround for rdar://51294267
    // calling the getter of titleLabel from within titleRectForContentRect causes an infite loop
    // caching the titleLabel "fixes" this bug temporarily but makes a custom getter necessary
    if (!_cachedTitleLabel) {
        _cachedTitleLabel = [super titleLabel];
    }

    return _cachedTitleLabel;
}

+ (instancetype)buttonWithStyle:(SDSButtonStyle)buttonStyle {
    return [self buttonWithStyle:buttonStyle styleSheet:[SDSStyleSheet global]];
}

+ (instancetype)buttonWithStyle:(SDSButtonStyle)buttonStyle styleSheet:(SDSStyleSheet *)styleSheet {
    SDSStyledButton *button = [self new];

    [button applyButtonStyle:buttonStyle invertedColors:NO fromStyleSheet:styleSheet];

    return button;
}

- (BOOL)ignoreMinimumHeight {
    return NO;
}

- (void)setButtonStyle:(SDSButtonStyleConfiguration *)style {
    _buttonStyle = style;
    [self updateForButtonStyle:style];
    [self registerForContentSizeCategoryChangeNotificationsIfNeeded];
}

- (void)applyButtonStyle:(SDSButtonStyle)style {
    [self applyButtonStyle:style invertedColors:NO];
}

- (void)applyButtonStyle:(SDSButtonStyle)style invertedColors:(BOOL)invertedColors {
    [self applyButtonStyle:style invertedColors:invertedColors fromStyleSheet:SDSStyleSheet.global];
}

- (void)applyButtonStyle:(SDSButtonStyle)style invertedColors:(BOOL)invertedColors fromStyleSheet:(nonnull SDSStyleSheet *)styleSheet {
    SDSButtonStyleConfiguration *configuration = [styleSheet configurationForButtonStyle:style];
    self.invertedColors = invertedColors;

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
    SDSTextStyleConfiguration *textStyle = style.textStyle;

    self.imageView.contentMode = UIViewContentModeCenter;
    [self.backgroundView setShadow:style.shadow];
    self.titleLabel.sds_invertedColor = self.invertedColors;
    self.titleLabel.sds_textStyle = textStyle;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.2;
    for (NSNumber *controlStateNumber in @[@(UIControlStateNormal), @(UIControlStateDisabled), @(UIControlStateHighlighted), @(UIControlStateSelected)]) {
        UIControlState state = (UIControlState)controlStateNumber.unsignedIntegerValue;
        [self setTitleColor:[textStyle.textColor valueForState:state inverted:self.invertedColors] forState:state];
    }
    [self invalidateIntrinsicContentSize];
    [self updateForControlState:self.state];
}

- (void)registerForContentSizeCategoryChangeNotificationsIfNeeded {
    if (@available(iOS 9.0, *)) { /* continue below… */
    } else {
        // In order to keep behaviour between UILabel+SDSTextStyle and this text field class in sync
        // this does not support automating re-scaling before iOS 9.
        return;
    }

    if ([self didRegisterForNotifications]) {
        return;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateForCurrentButtonStyle) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self setDidRegisterForNotifications:YES];
}

- (void)stopObservingContentSizeCategoryChanges {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self setDidRegisterForNotifications:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.backgroundView) {
        self.backgroundView.frame = self.bounds;
        [self sendSubviewToBack:self.backgroundView];
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect titleRect = [super titleRectForContentRect:contentRect];

    // sometimes we use SDSStyledButton with multiline labels
    // overriding the titleRectForContentRect like we did below doesn't make sense in those cases
    // because the titleRect may need to be larger than the bounds so UIButton's resizing behavior works.
    if (self.cachedTitleLabel.numberOfLines != 1) {
        return titleRect;
    }

    if (CGRectGetHeight(titleRect) > CGRectGetHeight(self.bounds)) {
        CGRect intersection = CGRectIntersection(self.bounds, titleRect);
        if (!CGRectIsNull(intersection)) {
            NSNumber *inset = [self.buttonStyle.borderWidth valueForState:self.state];
            return CGRectInset(intersection, 0.0, inset.doubleValue);
        }
    }

    return titleRect;
}

#pragma mark - Control state

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateForControlState:self.state];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateForControlState:self.state];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateForControlState:self.state];
}

- (void)updateForControlState:(UIControlState)controlState {
    UIColor *bgColor = [self.buttonStyle.backgroundColor valueForState:controlState inverted:self.invertedColors];
    [self.backgroundView setBackgroundColor:bgColor];

    // we only apply the background color to the titleLabel if the color is opaque
    // we do so to improve scroll performance to avoid blended layers
    // non-opaque colors however would yield multiple overlayed areas with different opacity.
    CGFloat alpha;
    [bgColor getRed:nil green:nil blue:nil alpha:&alpha];
    BOOL bgColorIsOpaque = (bgColor != nil) && (alpha == 1);
    [self.titleLabel setOpaque:bgColorIsOpaque];
    [self.titleLabel setBackgroundColor:bgColorIsOpaque ? bgColor : [UIColor clearColor]];

    [self setTintColor:[self.buttonStyle.imageColor valueForState:controlState inverted:self.invertedColors]];

    [self.backgroundView.layer setBorderWidth:[[self.buttonStyle.borderWidth valueForState:controlState] doubleValue]];
    [self updatePaddingForControlState:controlState];

    if (self.buttonStyle.borderWidth && self.buttonStyle.borderColor) {
        [self.backgroundView.layer setBorderColor:[[self.buttonStyle.borderColor valueForState:controlState inverted:self.invertedColors] CGColor]];
    }

    [self.backgroundView setCornerRadius:[[self.buttonStyle.cornerRadius valueForState:controlState] doubleValue]];
    [self.backgroundView setControlState:controlState];
}

- (void)setMinimumHeight:(SDSStatefulScalar *)minimumHeight {
    _minimumHeight = minimumHeight;
    [self invalidateIntrinsicContentSize];
}

- (void)setVerticalPadding:(SDSStatefulScalar *)verticalPadding {
    _verticalPadding = verticalPadding;
    [self updatePaddingForControlState:self.state];
}

- (void)setHorizontalPadding:(SDSStatefulScalar *)horizontalPadding {
    _horizontalPadding = horizontalPadding;
    [self updatePaddingForControlState:self.state];
}

- (void)updatePaddingForControlState:(UIControlState)controlState {
    CGFloat paddingH = [[self.buttonStyle.paddingHorizontal valueForState:controlState] doubleValue];

    if (self.horizontalPadding) {
        paddingH = self.horizontalPadding.normal.doubleValue;
    }

    CGFloat paddingV = [[self.buttonStyle.paddingVertical valueForState:controlState] doubleValue];
    
    if (self.verticalPadding) {
        paddingV = self.verticalPadding.normal.doubleValue;
    }

    [self setContentEdgeInsets:UIEdgeInsetsMake(paddingV, paddingH, paddingV, paddingH)];
}

- (CGSize)intrinsicContentSize {
    CGSize superSize = [super intrinsicContentSize];
    if (self.ignoreMinimumHeight) {
        return superSize;
    }

    CGFloat minHeight = self.buttonStyle.minimumHeight.normal.doubleValue; // defaults to 0

    if (self.minimumHeight) {
        minHeight = self.minimumHeight.normal.doubleValue;
    }

    CGFloat width = superSize.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right;

    return CGSizeMake(width, MAX(superSize.height, minHeight));
}

@end
