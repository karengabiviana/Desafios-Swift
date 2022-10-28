//
//  CUICurrencyTextField.m
//  CircuitUI
//
//  Created by Marcel Voß on 02.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUICurrencyTextField.h"

#import "CUILabelBody1.h"
#import "CUISingleLineTextField+Private.h"
#import "CUISingleLineTextFieldAccessoryConfiguration.h"
#import "CUITextField+Private.h"
#import "CUITextStyle.h"

@import SumUpUtilities;

@interface CUICurrencyTextField () <UITextFieldDelegate>

@property (nonatomic, readonly) ISHFinancialNumberString *numberString;
@property (nonatomic, readonly) NSNumberFormatter *currencyFormatter;

@end

@implementation CUICurrencyTextField

- (void)cui_commonInit {
    [super cui_commonInit];

    [self setKeyboardType:UIKeyboardTypeNumberPad];
    [self setReturnKeyType:UIReturnKeyDone];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setSpellCheckingType:UITextSpellCheckingTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    _numberString = [ISHFinancialNumberString new];
    [self setCurrencyLocale:[NSLocale currentLocale]];
    [self setValue:[NSDecimalNumber zero]];
}

- (void)setCurrencyLocale:(NSLocale *)currencyLocale {
    if ([currencyLocale isEqual:_currencyLocale]) {
        return;
    }

    _currencyLocale = currencyLocale;
    [self configureNumberFormatters];
    [self configureAccessoryViewForCurrentLocale];

    // as we have changed our currency formatting, we have to manually perform
    // a formatting cycle, to update our string accordingly for the new locale.
    [self setValue:self.value];
}

- (void)configureNumberFormatters {
    [self.noCurrencySymbolNumberFormatter setLocale:self.currencyLocale];
    [self.noCurrencySymbolNumberFormatter setCurrencySymbol:@""];

    NSNumberFormatter *currencyFormatter = [NSNumberFormatter new];
    currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    currencyFormatter.locale = self.currencyLocale;
    _currencyFormatter = currencyFormatter;
}

- (NSNumberFormatter *)noCurrencySymbolNumberFormatter {
    NSNumberFormatter *formatter = self.numberString.numberFormatter;
    NSParameterAssert(formatter);
    return formatter;
}

- (NSString *)text {
    return self.numberString.decimalNumber.stringValue;
}

- (void)setText:(NSString *)text {
    if (!text.length) {
        return;
    }

    [super setText:text];

    // we have to send this action manually, as our text field always
    // returns NO within shouldChangeCharactersInRange:replacementString:
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    [self updateFontForCurrentTextStyle];
}

- (NSDecimalNumber *)value {
    return self.numberString.decimalNumber;
}

- (void)setValue:(NSDecimalNumber *)value {
    [self.numberString setDecimalNumber:value];

    if (self.value) {
        [self setText:[[self.noCurrencySymbolNumberFormatter stringFromNumber:self.value] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
}

- (NSDecimalNumber *)maximumValue {
    return self.numberString.maximumDecimalNumber;
}

- (void)setMaximumValue:(NSDecimalNumber *)maximumValue {
    [self.numberString setMaximumDecimalNumber:maximumValue];
}

- (NSString *)placeholder {
    NSAssert(NO, @"placeholder is unavailable in CUICurrencyTextField.");
    return @"";
}

- (void)setPlaceholder:(NSString *)placeholder {
    NSAssert(NO, @"setPlaceholder is unavailable in CUICurrencyTextField.");
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self configureAccessoryViewForCurrentLocale];
}

- (NSUInteger)maximumNumberOfCharacters {
    NSAssert(NO, @"maximumNumberOfCharacters is not implemented for CUICurrencyTextField; use maximumDecimalNumber instead.");
    return 0;
}

- (void)setMaximumNumberOfCharacters:(NSUInteger)maximumNumberOfCharacters {
    NSAssert(NO, @"setMaximumNumberOfCharacters: is not implemented for CUICurrencyTextField; use setMaximumDecimalNumber: instead.");
}

- (void)setTreatZeroAsPlaceholder:(BOOL)treatZeroAsPlaceholder {
    if (!treatZeroAsPlaceholder == !_treatZeroAsPlaceholder) {
        return;
    }

    _treatZeroAsPlaceholder = treatZeroAsPlaceholder;
    [self updateFontForCurrentTextStyle];
}

- (void)configureAccessoryViewForCurrentLocale {
    CUISingleLineTextFieldAccessoryConfiguration *config = [self accessoryConfigurationFrom:[self.currencyFormatter stringFromNumber:@1] accessorySymbol:self.currencyFormatter.currencySymbol];
    [self setAccessoryConfiguration:config];
}

- (void)inputString:(NSString *)string {
    [self.numberString appendString:string];
    [self setValue:self.numberString.decimalNumber];
}

- (SDSTextStyleConfiguration *)textStyleForCurrentState {
    if (self.treatZeroAsPlaceholder && [self.value isEqualToNumber:[NSDecimalNumber zero]]) {
        return CUITextStyleCreateBody1(CUILabelBodyVariantSubtle, NO);
    }

    return [super textStyleForCurrentState];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self inputString:string];

    // by calling -inputString: we actually changed the characters ourselves,
    // so we don't want the textfield to do it "again" (with non-validated input)
    return NO;
}

@end
