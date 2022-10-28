//
//  CUIInputControlContainerValidationStatusView.m
//  CircuitUI
//
//  Created by Marcel Voß on 02.08.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIInputControlContainerValidationStatusView.h"

#import "CUILabelBody2.h"
#import "CUIInputControlContainerValidationResult.h"
#import "NSBundle+Resources.h"
#import "CUISpacing.h"
#import "CUISemanticColor.h"
#import "CUIColorHelpers.h"
#import "CUIColorRef.h"
#import "NSLayoutAnchor+CUISpacing.h"
#import "CUISemanticColor.h"
#import "UIImage+Resources+Private.h"

@import SumUpUtilities;

@interface CUIInputControlContainerValidationStatusView ()

@property (nonatomic) UIImageView *stateImageView;
@property (nonatomic) CUILabelBody2 *reasonLabel;

@end

@implementation CUIInputControlContainerValidationStatusView

#pragma mark - Initializers

- (instancetype)initWithValidationResult:(CUIInputControlContainerValidationResult *)result {
    NSParameterAssert(result);

    self = [super initWithFrame:CGRectZero];
    if (self) {
        _result = result;

        [self configureSubviews];
    }
    return self;
}

#pragma mark - Configuration

- (void)configureSubviews {
    UIImageView *stateImageView = [UIImageView new];
    stateImageView.contentMode = UIViewContentModeScaleAspectFit;
    [stateImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self smp_addSubview:stateImageView withConstraints:@[
        [stateImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [stateImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [stateImageView.widthAnchor constraintEqualToConstant:CUISpacingMega]
    ]];

    CUILabelBody2 *reasonLabel = [CUILabelBody2 new];
    [reasonLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    reasonLabel.numberOfLines = 0;
    [self smp_addSubview:reasonLabel withConstraints:@[
        [stateImageView.bottomAnchor constraintLessThanOrEqualToAnchor:reasonLabel.bottomAnchor],
        [reasonLabel.leadingAnchor constraintEqualToAnchor:stateImageView.trailingAnchor spacing:CUISpacingByte],
        [reasonLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [reasonLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.bottomAnchor constraintEqualToAnchor:reasonLabel.bottomAnchor]
    ]];

    self.reasonLabel = reasonLabel;
    self.stateImageView = stateImageView;

    [self updateStateForResult];
}

- (void)setResult:(CUIInputControlContainerValidationResult *)result {
    _result = result;
    [self updateStateForResult];
}

- (void)updateStateForResult {
    BOOL validationSuccessful = self.result.success;

    NSString *imageName = validationSuccessful ? @"notification_icon_confirm" : @"notification_icon_alert";
    UIImage *stateImage = [UIImage cui_imageNamed:imageName];
    NSAssert(stateImage, @"image must not be nil.");

    self.stateImageView.image = [stateImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.stateImageView.tintColor = validationSuccessful ? CUISemanticColor.confirmColor : CUISemanticColor.alertColor;

    self.reasonLabel.text = self.result.reason;
    self.reasonLabel.variant = validationSuccessful ? CUILabelBodyVariantSuccess : CUILabelBodyVariantError;
}

@end
