//
//  SDSStyledTextField.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 01.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSStyledTextView.h"

@interface SDSStyledTextView ()
@property (nonatomic) BOOL didRegisterForNotifications;
@property (nonatomic) SDSTextStyleConfiguration *textStyle;
@end

@implementation SDSStyledTextView

- (void)setTextStyle:(SDSTextStyleConfiguration *)style {
    _textStyle = style;
    [self updateFontForTextStyle:style];
    [self registerForContentSizeCategoryChangeNotificationsIfNeeded];
}

- (void)applyTextStyle:(SDSTextStyle)style {
    [self applyTextStyle:style fromStyleSheet:[SDSStyleSheet global]];
}

- (void)applyTextStyle:(SDSTextStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet {
    SDSTextStyleConfiguration *configuration = [styleSheet configurationForTextStyle:style];
    if (configuration) {
        [self setTextStyle:configuration];
    }
}

- (void)updateFontForCurrentTextStyle {
    [self updateFontForTextStyle:self.textStyle];
}

- (void)updateFontForTextStyle:(SDSTextStyleConfiguration *)style {
    [self setFont:style.scaledFont];
    [self setTextColor:style.textColor.normal];
}

- (void)registerForContentSizeCategoryChangeNotificationsIfNeeded {
    if (@available(iOS 9.0, *)) { /* continue below… */ } else {
        // In order to keep behaviour between UILabel+SDSTextStyle and this text field class in sync
        // this does not support automating re-scaling before iOS 9.
        return;
    }

    if ([self didRegisterForNotifications]) {
        return;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFontForCurrentTextStyle) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self setDidRegisterForNotifications:YES];
}

- (void)stopObservingContentSizeCategoryChanges {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self setDidRegisterForNotifications:NO];
}

@end
