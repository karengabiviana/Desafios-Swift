//
//  CUIButton.m
//  CircuitUI
//
//  Created by Florian Schliep on 01.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIButton+Private.h"
#import "UILabel+SDS.h"
#import "CUIButtonStyle.h"

@interface CUIButton ()
@property (nonatomic) SDSButtonStyleConfiguration *buttonStyle;
@property (nonatomic, weak) UILabel *cachedTitleLabel;
@end

@implementation CUIButton

@dynamic tintColor;
@dynamic imageView;
@dynamic adjustsImageWhenHighlighted;
@dynamic adjustsImageWhenDisabled;
@dynamic font;
@dynamic titleShadowOffset;

#pragma mark - Instantiation

+ (instancetype)buttonWithTitle:(NSString *)title {
    return [self buttonWithTitle:title image:nil];
}

+ (instancetype)buttonWithImage:(UIImage *)image {
    return [self buttonWithTitle:nil image:image];
}

+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image {
    return [[self alloc] initWithTitle:title image:image];
}

- (instancetype)initWithFrame:(CGRect)frame primaryAction:(UIAction *)primaryAction {
    self = [super initWithFrame:frame primaryAction:primaryAction];
    if (self) {
        [self cui_commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self cui_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self cui_commonInit];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title image:nil];
}

- (instancetype)initWithImage:(UIImage *)image {
    return [self initWithTitle:nil image:image];
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self cui_commonInit];
        [self setTitle:title forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
    }
    return self;
}

- (void)cui_commonInit {
    NSAssert([self class] != CUIButton.class, @"CUIButton may not be used directly. Please use one of its subclasses.");
    NSAssert(self.buttonType == UIButtonTypeCustom, @"Instances of CUIButton must use UIButtonTypeCustom");

    [self setAdjustsImageWhenHighlighted:NO];
    [self setAdjustsImageWhenDisabled:NO];
    [self reloadButtonStyle];
    [self updateCornerRadius];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateForCurrentButtonStyle) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

#pragma mark - Styling

- (UILabel *)titleLabel {
    // workaround for rdar://51294267
    // calling the getter of titleLabel from within titleRectForContentRect causes an infite loop
    // caching the titleLabel "fixes" this bug temporarily but makes a custom getter necessary
    if (!_cachedTitleLabel) {
        _cachedTitleLabel = [super titleLabel];
    }

    return _cachedTitleLabel;
}

- (void)reloadButtonStyle {
    self.buttonStyle = [self createButtonStyleConfiguration];
}

- (void)setButtonStyle:(SDSButtonStyleConfiguration *)style {
    _buttonStyle = style;
    [self updateForButtonStyle:style];
}

- (void)updateForCurrentButtonStyle {
    if (!self.buttonStyle) {
        return;
    }

    [self updateForButtonStyle:self.buttonStyle];
}

- (void)updateForButtonStyle:(SDSButtonStyleConfiguration *)style {
    SDSTextStyleConfiguration *textStyle = style.textStyle;

    [self imageView].contentMode = UIViewContentModeCenter;
    [self titleLabel].sds_textStyle = textStyle;
    for (NSNumber *controlStateNumber in @[@(UIControlStateNormal), @(UIControlStateDisabled), @(UIControlStateHighlighted), @(UIControlStateSelected)]) {
        UIControlState state = (UIControlState)controlStateNumber.unsignedIntegerValue;
        [self setTitleColor:[textStyle.textColor valueForState:state inverted:NO] forState:state];
    }
    [self invalidateIntrinsicContentSize];
    [self updateForControlState:self.state];
}

- (BOOL)hasTitleInCurrentState {
    return [self titleForState:self.state].length > 0;
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

- (void)setDestructive:(BOOL)destructive {
    _destructive = destructive;
    [self reloadButtonStyle];
}

- (void)updateForControlState:(UIControlState)controlState {
    UIColor *bgColor = [self.buttonStyle.backgroundColor valueForState:controlState inverted:NO];
    [self setBackgroundColor:bgColor];

    // we only apply the background color to the titleLabel if the color is opaque
    // we do so to improve scroll performance to avoid blended layers
    // non-opaque colors however would yield multiple overlayed areas with different opacity.
    CGFloat alpha;
    [bgColor getRed:nil green:nil blue:nil alpha:&alpha];
    BOOL bgColorIsOpaque = (bgColor != nil) && (alpha == 1);
    [[self titleLabel] setOpaque:bgColorIsOpaque];
    [[self titleLabel] setBackgroundColor:bgColorIsOpaque ? bgColor : [UIColor clearColor]];

    [self setTintColor:[self.buttonStyle.textStyle.textColor valueForState:controlState inverted:NO]];

    [self updatePaddingForControlState:controlState];

    [self.layer setBorderColor:[[self.buttonStyle.borderColor valueForState:controlState inverted:NO] CGColor]];
    [self.layer setBorderWidth:[[self.buttonStyle.borderWidth valueForState:controlState] doubleValue]];
}

#pragma mark - Layout

- (BOOL)hasRoundedCorners {
    return YES;
}

- (void)updatePaddingForControlState:(UIControlState)controlState {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    if (self.hasTitleInCurrentState) {
        CGFloat paddingH = [[self.buttonStyle.paddingHorizontal valueForState:controlState] doubleValue];
        CGFloat paddingV = [[self.buttonStyle.paddingVertical valueForState:controlState] doubleValue];
        if (self.currentImage == nil) {
            contentInsets = UIEdgeInsetsMake(paddingV, paddingH, paddingV, paddingH);
        } else {
            switch (self.effectiveUserInterfaceLayoutDirection) {
                case UIUserInterfaceLayoutDirectionLeftToRight:
                    imageInsets = UIEdgeInsetsMake(0., -CUIButtonStyleInnerPadding, 0., 0.);
                    contentInsets = UIEdgeInsetsMake(paddingV, paddingH + (CUIButtonStyleInnerPadding/2), paddingV, paddingH);
                    break;
                case UIUserInterfaceLayoutDirectionRightToLeft:
                    imageInsets = UIEdgeInsetsMake(0., 0., 0., -CUIButtonStyleInnerPadding);
                    contentInsets = UIEdgeInsetsMake(paddingV, paddingH, paddingV, paddingH + (CUIButtonStyleInnerPadding/2));
                    break;
            }
        }
    }

    self.contentEdgeInsets = contentInsets;
    self.imageEdgeInsets = imageInsets;
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

- (UIView *)viewForLastBaselineLayout {
    return self.cachedTitleLabel;
}

- (CGSize)intrinsicContentSize {
    CGSize superSize = [super intrinsicContentSize];
    CGFloat minHeight = self.buttonStyle.minimumHeight.normal.doubleValue; // defaults to 0
    CGFloat width = superSize.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right;
    CGFloat height = MAX(superSize.height, minHeight);
    if (!self.hasTitleInCurrentState) {
        // without a title, we want a circular shape
        width = height;
    }

    // buttons seems to always be 0.5 taller than the intrinsic content size,
    // so we'll substract 0.5 to arrive at an even number
    return CGSizeMake(width, height - 0.5);
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self updateCornerRadius];
}

- (void)updateCornerRadius {
    if (self.hasRoundedCorners) {
        // The corner radius should normally lead to a pill with semi-circles on the left and right side.
        // When the width is smaller than the height, this would lead to a rendering bug, where the two semi-circles are clipped.
        // The best we can do is to round the top and bottom sides, by setting the corner-radius to half of the smaller of the two sides.
        self.layer.cornerRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
    } else {
        self.layer.cornerRadius = 0.;
    }
}

#pragma mark - Content

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self reloadButtonStyle];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self reloadButtonStyle];
}

- (BOOL)allowsMultilineTitle {
    return [self titleLabel].numberOfLines == 0;
}

- (void)setAllowMultilineTitle:(BOOL)allowMultilineTitle {
    [self titleLabel].numberOfLines = allowMultilineTitle ? 0 : 1;
    [self titleLabel].textAlignment = allowMultilineTitle ? NSTextAlignmentCenter : NSTextAlignmentNatural;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    [self titleLabel].adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
    [self titleLabel].minimumScaleFactor = adjustsFontSizeToFitWidth ? 0.5 : 0.;
}

- (BOOL)adjustsFontSizeToFitWidth {
    return [self titleLabel].adjustsFontSizeToFitWidth;
}

@end
