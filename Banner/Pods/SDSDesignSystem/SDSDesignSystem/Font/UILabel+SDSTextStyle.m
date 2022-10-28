//
//  UILabel+SDSTextStyle.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 01.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "UILabel+SDSTextStyle.h"
#import "SDSTextStyleConfiguration+Private.h"
#import "SDSScalableFont+Private.h"
#import <objc/runtime.h>

@implementation UILabel (SDSTextStyle)

- (void)setSds_textStyle:(SDSTextStyleConfiguration *)style {
    objc_setAssociatedObject(self, @selector(sds_textStyle), style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self sds_updateFontForStyle:style];
    [self sds_registerForNotificationsIfNeeded];
}

- (SDSTextStyleConfiguration *)sds_textStyle {
    return objc_getAssociatedObject(self, @selector(sds_textStyle));
}

- (void)setSds_invertedColor:(BOOL)inverted {
    objc_setAssociatedObject(self, @selector(sds_invertedColor), @(inverted), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sds_invertedColor {
    return [objc_getAssociatedObject(self, @selector(sds_invertedColor)) boolValue];
}

- (void)sds_applyTextStyle:(SDSTextStyle)style {
    [self sds_applyTextStyle:style invertedColor:NO];
}

- (void)sds_applyTextStyle:(SDSTextStyle)style invertedColor:(BOOL)inverted {
    [self sds_applyTextStyle:style
               invertedColor:inverted
              fromStyleSheet:[SDSStyleSheet global]];
}

- (void)sds_applyTextStyle:(SDSTextStyle)style invertedColor:(BOOL)inverted fromStyleSheet:(SDSStyleSheet *)styleSheet {
    [self sds_applyTextStyleConfiguration:[styleSheet configurationForTextStyle:style] invertedColor:inverted];
}

- (void)sds_applyTextStyleFromButtonStyle:(SDSButtonStyle)style {
    [self sds_applyTextStyleFromButtonStyle:style invertedColor:NO];
}

- (void)sds_applyTextStyleFromButtonStyle:(SDSButtonStyle)style invertedColor:(BOOL)inverted {
    [self sds_applyTextStyleFromButtonStyle:style invertedColor:inverted fromStyleSheet:SDSStyleSheet.global];
}

- (void)sds_applyTextStyleFromButtonStyle:(SDSButtonStyle)style invertedColor:(BOOL)inverted fromStyleSheet:(SDSStyleSheet *)styleSheet {
    [self sds_applyTextStyleConfiguration:[styleSheet configurationForButtonStyle:style].textStyle invertedColor:inverted];
}

- (void)sds_applyTextStyleConfiguration:(SDSTextStyleConfiguration *)configuration invertedColor:(BOOL)inverted {
    [self setSds_invertedColor:inverted];
    if (configuration) {
        [self setSds_textStyle:configuration];
    }
}

- (void)sds_updateFontForCurrentStyle {
    [self sds_updateFontForStyle:self.sds_textStyle];
}

- (void)sds_updateFontForStyle:(SDSTextStyleConfiguration *)style {
    [self setFont:[self sds_isScalingEnabled] ? style.scaledFont : style.baseFont.baseFont];
    UIControlState state = self.sds_enabled ? UIControlStateNormal : UIControlStateDisabled;
    [self setTextColor:[style.textColor valueForState:state inverted:[self sds_invertedColor]]];
    [self setHighlightedTextColor:[style.textColor valueForState:UIControlStateHighlighted inverted:[self sds_invertedColor]]];
}

- (void)setSds_enabled:(BOOL)enabled {
    objc_setAssociatedObject(self, @selector(sds_isEnabled), @(!!enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self sds_updateFontForCurrentStyle];
}

- (BOOL)sds_isEnabled {
    NSNumber *setValue = objc_getAssociatedObject(self, @selector(sds_isEnabled));
    // if not actively set the default should be true
    return (setValue == nil) || [setValue boolValue];
}

- (void)setSds_scalingEnabled:(BOOL)enabled {
    objc_setAssociatedObject(self, @selector(sds_isScalingEnabled), @(!!enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self sds_updateFontForCurrentStyle];
    enabled ? [self sds_registerForNotificationsIfNeeded] : [self sds_stopObservingContentSizeCategoryChangesIfNeeded];
}

- (BOOL)sds_isScalingEnabled {
    NSNumber *setValue = objc_getAssociatedObject(self, @selector(sds_isScalingEnabled));
    // if not actively set the default should be true
    return (setValue == nil) || [setValue boolValue];
}

#pragma mark - Notifications

- (void)sds_setDidRegisterForNotifications:(BOOL)flag {
    objc_setAssociatedObject(self, @selector(sds_didRegisterForNotifications), @(flag), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)sds_didRegisterForNotifications {
    return [objc_getAssociatedObject(self, @selector(sds_didRegisterForNotifications)) boolValue];
}

- (void)sds_registerForNotificationsIfNeeded {
    if (@available(iOS 9.0, *)) { /* continue below… */
    } else {
        // Automatic observation of notifications are not supported before iOS 9
        // as this would require the label to manually remove itself as an observer.
        return;
    }

    if ([self sds_didRegisterForNotifications]) {
        return;
    }

    if (![self sds_isScalingEnabled]) {
        return;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sds_updateFontForCurrentStyle) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self sds_setDidRegisterForNotifications:YES];
}

- (void)sds_stopObservingContentSizeCategoryChangesIfNeeded {
    if (![self sds_didRegisterForNotifications]) {
        return;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self sds_setDidRegisterForNotifications:NO];
}

@end
