//
//  CUINumericTextField.m
//  CircuitUI
//
//  Created by Illia Lukisha on 05/08/2022.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "CUINumericTextField.h"
#import "CUISingleLineTextField+Private.h"
#import "CUITextField+Private.h"
#import "CUILabelBody1.h"
#import "CUITextStyle.h"

static const NSInteger CUINumericTextFieldPlusMinusToolbarTag = 12345;

@interface CUINumericTextField () <UITextFieldDelegate>

@property (nonatomic, readonly) NSNumberFormatter *decimalFormatter;
@property (nonatomic, getter=isNegative) BOOL negative;

@end

@implementation CUINumericTextField

- (void)cui_commonInit {
    [super cui_commonInit];
    [self setReturnKeyType:UIReturnKeyDone];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setSpellCheckingType:UITextSpellCheckingTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _decimalFormatter = [NSNumberFormatter new];
    [_decimalFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    // Ensures we aren't rounding when cutting the fraction digits
    // 0.1129 -> 0.112 for maxFractionDigits == 3
    // -0.1129 -> -0.112 for maxFractionDigits == 3
    [_decimalFormatter setRoundingMode:NSNumberFormatterRoundDown];
    [_decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    _minimumValue = [NSDecimalNumber zero];
    _maximumValue = [NSDecimalNumber maximumDecimalNumber];
    [self setMaximumFractionDigits:0];
    [self updateToolbar];
    [self setValue:[NSDecimalNumber zero]];
}

- (NSString *)text {
    return super.text;
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

- (void)setValue:(NSDecimalNumber *)value {
    if (![self isInsideBounds:value]) {
        return;
    }
    _value = value;
    [self setNegative: [value compare:[NSDecimalNumber zero]] == NSOrderedAscending];
    [self setText:[self.decimalFormatter stringFromNumber:value]];
}

- (void)setValueFromInput:(NSDecimalNumber *)value {
    NSDecimalNumber* adjustedValue;
    // When the initial value was zero, we still want to allow to start typing negative numbers.
    NSComparisonResult expectedOrder = self.isNegative ? NSOrderedDescending : NSOrderedAscending;
    if ([value compare:[NSDecimalNumber zero]] == expectedOrder) {
        adjustedValue = [self negate:value];
    } else {
        adjustedValue = value;
    }
    if (![self isInsideBounds:adjustedValue]) {
        return;
    }
    _value = adjustedValue;
    [self setText:[self.decimalFormatter stringFromNumber:adjustedValue]];
}

- (BOOL)isInsideBounds:(NSDecimalNumber*)value {
    // minValue ≤ value ≤ maxValue
    if ([value compare:self.maximumValue] == NSOrderedDescending ||
        [value compare:self.minimumValue] == NSOrderedAscending) {
        return NO;
    }
    return YES;
}

- (void)setMaximumFractionDigits:(NSUInteger)maximumFractionDigits {
    self.decimalFormatter.maximumFractionDigits = maximumFractionDigits;
    [self setKeyboardType: maximumFractionDigits == 0 ? UIKeyboardTypeNumberPad : UIKeyboardTypeDecimalPad];
    [self setValue:self.value];
}

- (void)setMaximumValue:(NSDecimalNumber *)maximumValue {
    NSAssert([maximumValue compare:self.minimumValue] == NSOrderedDescending, @"Maximum value should be higher than minimum value.");
    _maximumValue = maximumValue;
    if ([self.value compare:self.maximumValue] != NSOrderedAscending) {
        [self setValue:self.minimumValue];
    }
}

- (void)setMinimumValue:(NSDecimalNumber *)minimumValue {
    NSAssert([minimumValue compare:self.maximumValue] == NSOrderedAscending, @"Minimum value should be lower than maximum value.");
    _minimumValue = minimumValue;
    [self updateToolbar];
    if ([self.value compare:self.minimumValue] == NSOrderedAscending) {
        [self setValue:minimumValue];
    }
}

- (NSUInteger)maximumFractionDigits {
    return self.decimalFormatter.maximumFractionDigits;
}

- (NSString *)placeholder {
    return [super placeholder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
}

- (NSUInteger)maximumNumberOfCharacters {
    return [super maximumNumberOfCharacters];
}

- (void)setMaximumNumberOfCharacters:(NSUInteger)maximumNumberOfCharacters {
    [super setMaximumNumberOfCharacters:maximumNumberOfCharacters];
}

- (void)setTreatZeroAsPlaceholder:(BOOL)treatZeroAsPlaceholder {
    if (!treatZeroAsPlaceholder == !_treatZeroAsPlaceholder) {
        return;
    }

    _treatZeroAsPlaceholder = treatZeroAsPlaceholder;
    [self updateFontForCurrentTextStyle];
}

- (SDSTextStyleConfiguration *)textStyleForCurrentState {
    if (self.treatZeroAsPlaceholder && [self.value isEqual:@0]) {
        return CUITextStyleCreateBody1(CUILabelBodyVariantSubtle, NO);
    }

    return [super textStyleForCurrentState];
}

- (void)updateToolbar {
    if ([self.minimumValue compare:@0] == NSOrderedAscending && !self.keyboardAccessoryView) {
        UIToolbar *toolbar = [UIToolbar new];
        toolbar.tag = CUINumericTextFieldPlusMinusToolbarTag;
        [toolbar setBarStyle:UIBarStyleDefault];
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        if (@available(iOS 13.0, *)) {
            UIBarButtonItem *plusMinus = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus.forwardslash.minus"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleSign)];
            [toolbar setItems:@[plusMinus, spacer]];
        } else {
            UIBarButtonItem *plusMinus = [[UIBarButtonItem alloc] initWithTitle:@"+/-" style:UIBarButtonItemStylePlain target:self action:@selector(toggleSign)];
            [toolbar setItems:@[plusMinus, spacer]];
        }
        [toolbar sizeToFit];
        [self setKeyboardAccessoryView:toolbar];
    } else if (self.keyboardAccessoryView && self.keyboardAccessoryView.tag == CUINumericTextFieldPlusMinusToolbarTag) {
        [self setKeyboardAccessoryView:nil];
    }
}

-(void)toggleSign {
    // Used if only 0 is entered at the moment
    self.negative = !self.isNegative;
    [self setValueFromInput:[self negate:self.value]];
}

-(NSDecimalNumber *)negate:(NSDecimalNumber *)number {
    NSDecimalNumber* minusOne = [NSDecimalNumber decimalNumberWithMantissa: 1
                                                                  exponent: 0
                                                                isNegative: YES];
    return [number decimalNumberByMultiplyingBy:minusOne];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([string isEqualToString:self.decimalFormatter.decimalSeparator]) {
        return ![textField.text containsString:self.decimalFormatter.decimalSeparator];
    } else {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *stringWithoutGroupingSeparators = [newString stringByReplacingOccurrencesOfString:self.decimalFormatter.groupingSeparator withString:@""];
        NSNumber *number = [self.decimalFormatter numberFromString:stringWithoutGroupingSeparators];
        // We are doing one cycle of formatting to get read of tail.
        NSNumber *roundedNumber = [self.decimalFormatter numberFromString:[self.decimalFormatter stringFromNumber:number]];
        [self setValueFromInput:[NSDecimalNumber decimalNumberWithDecimal:roundedNumber.decimalValue]];
    }
    return NO;
}

@end
