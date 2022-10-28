//
//  SDSStyledTextField.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 01.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSStyledTextField.h"

@interface SDSStyledTextField ()
@property (nonatomic) BOOL didRegisterForNotifications;
@property (nonatomic, readwrite) BOOL invertedColors;
@property (nonatomic, readwrite) SDSTextStyleConfiguration *textStyle;
@end

@implementation SDSStyledTextField

- (void)setTextStyle:(SDSTextStyleConfiguration *)style {
    _textStyle = style;
    [self updateFontForTextStyle:style];
    [self registerForContentSizeCategoryChangeNotificationsIfNeeded];
}

- (void)applyTextStyle:(SDSTextStyle)style {
    [self applyTextStyle:style invertedColor:NO];
}

- (void)applyTextStyle:(SDSTextStyle)style invertedColor:(BOOL)inverted {
    [self applyTextStyle:style invertedColor:inverted fromStyleSheet:[SDSStyleSheet global]];
}

- (void)applyTextStyle:(SDSTextStyle)style invertedColor:(BOOL)inverted fromStyleSheet:(SDSStyleSheet *)styleSheet {
    self.invertedColors = inverted;
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
    [self setTextColor:[style.textColor valueForState:[self controlState] inverted:self.invertedColors]];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateFontForCurrentTextStyle];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateFontForCurrentTextStyle];
}

- (UIControlState)controlState {
    if (!self.isEnabled) {
        return UIControlStateDisabled;
    }

    if (self.isFirstResponder) {
        return UIControlStateSelected;
    }

    return self.highlighted ? UIControlStateHighlighted : UIControlStateNormal;
}

- (BOOL)becomeFirstResponder {
    BOOL superReturn = [super becomeFirstResponder];
    [self updateFontForCurrentTextStyle];
    return superReturn;
}

- (BOOL)resignFirstResponder {
    BOOL superReturn = [super resignFirstResponder];
    [self updateFontForCurrentTextStyle];
    return superReturn;
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFontForCurrentTextStyle) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self setDidRegisterForNotifications:YES];
}

- (void)stopObservingContentSizeCategoryChanges {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self setDidRegisterForNotifications:NO];
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    if (!self.textStyle || !self.font) {
        [super drawPlaceholderInRect:rect];
        return;
    }

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = self.textAlignment;
    paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.placeholder drawInRect:rect withAttributes:@{
                                                       NSFontAttributeName: self.font,
                                                       NSForegroundColorAttributeName: [self.textStyle.textColor valueForState:UIControlStateDisabled inverted:self.invertedColors],
                                                       NSParagraphStyleAttributeName: paragraph
                                                       }];
}

@end
