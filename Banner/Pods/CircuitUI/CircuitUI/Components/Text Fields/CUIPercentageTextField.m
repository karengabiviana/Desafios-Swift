//
//  CUIPercentageTextField.m
//  CircuitUI
//
//  Created by Andrii Kravchenko on 27.06.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "CUIPercentageTextField.h"

#import "CUILabelBody1.h"
#import "CUISingleLineTextField+Private.h"
#import "CUISingleLineTextFieldAccessoryConfiguration.h"
#import "CUITextField+Private.h"
#import "CUITextStyle.h"

@interface CUIPercentageTextField () <UITextFieldDelegate>

@property (nonatomic, readonly) NSNumberFormatter *decimalFormatter;
@property (nonatomic, readonly) NSNumberFormatter *percentFormatter;

@end

@implementation CUIPercentageTextField

- (void)cui_commonInit {
    [super cui_commonInit];

    [self setKeyboardType:UIKeyboardTypeDecimalPad];
    [self setReturnKeyType:UIReturnKeyDone];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setSpellCheckingType:UITextSpellCheckingTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self configureFormatters];
    [self configureAccessoryViewForCurrentLocale];
}

- (void)configureFormatters {
    NSNumberFormatter *decimalFormatter = [NSNumberFormatter new];
    decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    _decimalFormatter = decimalFormatter;

    NSNumberFormatter *percentFormatter = [NSNumberFormatter new];
    percentFormatter.numberStyle = NSNumberFormatterPercentStyle;
    _percentFormatter = percentFormatter;
}

- (void)configureAccessoryViewForCurrentLocale {
    CUISingleLineTextFieldAccessoryConfiguration *config = [self accessoryConfigurationFrom:[self.percentFormatter stringFromNumber:self.value] accessorySymbol:self.decimalFormatter.percentSymbol];
    [self setAccessoryConfiguration:config];
}

- (NSDecimalNumber *)value {
    return [NSDecimalNumber decimalNumberWithDecimal:[self.decimalFormatter numberFromString:self.text].decimalValue];
}

- (void)setValue:(NSDecimalNumber *)value {
    self.text = [self.decimalFormatter stringFromNumber:value];
}

- (void)setMaximumFractionDigits:(NSUInteger)maximumFractionDigits {
    self.decimalFormatter.maximumFractionDigits = maximumFractionDigits;
}

- (NSUInteger)maximumFractionDigits {
    return self.decimalFormatter.maximumFractionDigits;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self configureAccessoryViewForCurrentLocale];
}

- (void)setPercentageLocale:(NSLocale *)percentageLocale {
    if ([percentageLocale isEqual:self.percentageLocale]) {
        return;
    }
    _percentageLocale = percentageLocale;

    self.decimalFormatter.locale = percentageLocale;
    self.percentFormatter.locale = percentageLocale;
    [self configureAccessoryViewForCurrentLocale];
    [self setValue:self.value];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSNumber *number = [self.decimalFormatter numberFromString:newString];

    if ([string isEqualToString:self.decimalFormatter.decimalSeparator]) {
        return ![textField.text containsString:self.decimalFormatter.decimalSeparator];
    } else if (number != nil) {
        textField.text = [self.decimalFormatter stringFromNumber:number];
    }
    return NO;
}

@end
