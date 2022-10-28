//
//  SMPActivityIndicatorInterchangeView.m
//
//  Created by Florian Schliep on 01.10.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SMPActivityIndicatorInterchangeView.h"

#pragma mark - Class Extension

@interface SMPActivityIndicatorInterchangeView ()

@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) NSArray<NSLayoutConstraint *> *centeringConstraints;
@property (nonatomic, weak) NSArray<NSLayoutConstraint *> *fillingConstraints;

@end

#pragma mark - Implementation

@implementation SMPActivityIndicatorInterchangeView

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super initWithFrame:contentView.frame];
    if (self) {
        [self commonInit];
        [self setContentMode:SMPActivityIndicatorInterchangeViewContentModeCenter];
        // call setter deliberately in order to add contentView as subview
        [self setContentView:contentView];
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

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithContentView:nil];
}

- (void)commonInit {
    UIActivityIndicatorView *activityIndicator;
    if (@available(iOS 13.0, *)) {
        activityIndicator = [[UIActivityIndicatorView alloc] init];
    } else {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:activityIndicator];
    [NSLayoutConstraint activateConstraints:[self constraintsForCenteringAndSizeDefiningView:activityIndicator]];
    self.activityIndicator = activityIndicator;
}

- (CGSize)intrinsicContentSize {
    return self.contentView.intrinsicContentSize;
}

#pragma mark - Properties

- (void)setContentView:(UIView *)contentView {
    if (_contentView) {
        [_contentView removeFromSuperview];
    }

    _contentView = contentView;
    if (contentView) {
        contentView.hidden = self.activityIndicator.isAnimating;
        [self addSubview:contentView];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self applyConstraintsToContentViewBasedOnContentMode];
    }
}

- (void)setContentMode:(SMPActivityIndicatorInterchangeViewContentMode)contentMode {
    if (_contentMode == contentMode) {
        return;
    }

    _contentMode = contentMode;
    if (self.contentView) {
        [self applyConstraintsToContentViewBasedOnContentMode];
    }
}

- (void)applyConstraintsToContentViewBasedOnContentMode {
    if (self.centeringConstraints) {
        [NSLayoutConstraint deactivateConstraints:self.centeringConstraints];
        self.centeringConstraints = nil;
    }

    if (self.fillingConstraints) {
        [NSLayoutConstraint deactivateConstraints:self.fillingConstraints];
        self.fillingConstraints = nil;
    }

    switch (self.contentMode) {
        case SMPActivityIndicatorInterchangeViewContentModeCenter: {
            NSArray<NSLayoutConstraint *> *centeringConstraints = [self constraintsForCenteringAndSizeDefiningView:self.contentView];
            [NSLayoutConstraint activateConstraints:centeringConstraints];
            self.centeringConstraints = centeringConstraints;
            break;
        }

        case SMPActivityIndicatorInterchangeViewContentModeFill: {
            NSArray<NSLayoutConstraint *> *fillingConstraints = [self constraintsForFillingView:self.contentView];
            [NSLayoutConstraint activateConstraints:fillingConstraints];
            self.fillingConstraints = fillingConstraints;
            break;
        }

        default:
            NSAssert(NO, @"Attempted to set unknown content mode");
            break;
    }
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    self.activityIndicator.activityIndicatorViewStyle = activityIndicatorViewStyle;
}

- (void)setActivityIndicatorColor:(UIColor *)color {
    self.activityIndicator.color = color;
}

#pragma mark - Loading

- (void)startLoading {
    if (self.activityIndicator.isAnimating) {
        return;
    }

    self.contentView.hidden = YES;
    [self.activityIndicator startAnimating];
}

- (void)stopLoading {
    if (!self.activityIndicator.isAnimating) {
        return;
    }

    self.contentView.hidden = NO;
    [self.activityIndicator stopAnimating];
}

#pragma mark - Helpers

/// Returns constraints in order to center view and make sure we are large enough to fit it.
- (NSArray<NSLayoutConstraint *> *)constraintsForCenteringAndSizeDefiningView:(UIView *)view {
    return @[
        [view.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [view.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.heightAnchor constraintGreaterThanOrEqualToAnchor:view.heightAnchor],
        [self.widthAnchor constraintGreaterThanOrEqualToAnchor:view.widthAnchor]
    ];

}

/// Returns constraints in order fill the view on our edges
- (NSArray<NSLayoutConstraint *> *)constraintsForFillingView:(UIView *)view {
    return @[
        [view.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [view.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [view.topAnchor constraintEqualToAnchor:self.topAnchor],
        [view.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ];
}

@end
