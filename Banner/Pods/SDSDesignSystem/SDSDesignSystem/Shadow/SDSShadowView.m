//
//  SDSShadowView.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 25.07.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSShadowView.h"
#import "SDSCast.h"
#import "SDSStyleSheet.h"

@interface SDSShadowViewLayer : CALayer
- (void)smpSetCornerRadius:(CGFloat)cornerRadius;
@end

@interface SDSShadowView ()
@property (nonatomic, weak) UIView *outerBorderView;
@property (nonatomic, readonly) SDSShadowViewLayer *safeLayer;
@end

@implementation SDSShadowView

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
    _controlState = UIControlStateNormal;
    self.userInteractionEnabled = NO;
    self.clipsToBounds = NO;
    // the view needs a backgroundColor to draw a shadow
    self.backgroundColor = [UIColor whiteColor];

    UIView *borderView = [[UIView alloc] initWithFrame:CGRectZero];
    _outerBorderView = borderView;
    [borderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview:borderView];

    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self updateShadowPath];
}

- (void)setShadow:(SDSShadow *)shadow {
    _shadow = shadow;
    [self updateForCurrentStateAndShadow];
}

- (void)setControlState:(UIControlState)controlState {
    _controlState = controlState;
    [self updateForCurrentStateAndShadow];
}

- (void)updateForCurrentStateAndShadow {
    CGFloat oldBorderWidth = self.outerBorderView.layer.borderWidth;

    self.outerBorderView.layer.borderWidth = [[self.shadow.borderWidth valueForState:self.controlState] doubleValue];
    self.outerBorderView.layer.borderColor = ([self.shadow.borderColor valueForState:self.controlState] ? : [UIColor clearColor]).CGColor;
    self.layer.shadowColor = ([self.shadow.color valueForState:self.controlState] ? : [UIColor clearColor]).CGColor;
    self.layer.shadowOpacity = self.shadow.opacity ? [[self.shadow.opacity valueForState:self.controlState] doubleValue] : 1.0;
    self.layer.shadowRadius = [[self.shadow.blurRadius valueForState:self.controlState] doubleValue];
    self.layer.shadowOffset = CGSizeMake([[self.shadow.offsetX valueForState:self.controlState] doubleValue], [[self.shadow.offsetY valueForState:self.controlState] doubleValue]);

    if (self.shadow.spread) {
        // spread may depend on control state and affects the shadowPath
        [self updateShadowPath];
    }

    if (oldBorderWidth == self.outerBorderView.layer.borderWidth) {
        return;
    }

    [self setNeedsLayout];
    [self updateOuterBorderRadius];
    [self layoutIfNeeded];
}

- (void)applyCornerRadius:(SDSScalarType)scalar {
    [self applyCornerRadius:scalar fromStyleSheet:[SDSStyleSheet global]];
}

- (void)applyCornerRadius:(SDSScalarType)scalar fromStyleSheet:(SDSStyleSheet *)sheet {
    self.cornerRadius = [sheet scalarNormalValueForType:scalar];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self.safeLayer smpSetCornerRadius:cornerRadius];
    [self setNeedsLayout];
    [self updateOuterBorderRadius];
    [self layoutIfNeeded];
}

- (void)updateOuterBorderRadius {
    self.outerBorderView.layer.cornerRadius = self.cornerRadius + [self.shadow.borderWidth valueForState:self.controlState].doubleValue;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat inset = -1 * [self.shadow.borderWidth valueForState:self.controlState].doubleValue;
    self.outerBorderView.frame = CGRectInset(self.bounds, inset, inset);
}

- (void)updateShadowPath {
    CGFloat spreadInset = -1 *  [[self.shadow.spread valueForState:self.controlState] doubleValue];
    CGRect boundsWithSpread = CGRectInset(self.bounds, spreadInset, spreadInset);
    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:boundsWithSpread cornerRadius:self.layer.cornerRadius] CGPath]];
}

+ (Class)layerClass {
    return [SDSShadowViewLayer class];
}

- (SDSShadowViewLayer *)safeLayer {
    return safeCast(self.layer, [SDSShadowViewLayer class]);
}

@end

@implementation SDSShadowViewLayer

- (void)setCornerRadius:(CGFloat)cornerRadius {
    NSLog(@"WARNING: Use the cornerRadius property of SDSShadowView directly or the -applyCornerRadius: convenience method to change the corner radius.");
    [super setCornerRadius:cornerRadius];
}

- (void)smpSetCornerRadius:(CGFloat)cornerRadius {
    [super setCornerRadius:cornerRadius];
}

@end
