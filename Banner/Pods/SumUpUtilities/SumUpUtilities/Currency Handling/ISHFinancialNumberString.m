//
//  ISHFinancialNumberString.m
//
//  Created by Felix Lamouroux on 17.01.12.
//  Copyright (c) 2012 iosphere GmbH. All rights reserved.
//

#import "ISHFinancialNumberString.h"

//the maximum digit of the receivedMoneyTextfield with decimal separator and the two cent digits
const NSInteger kISHFinancialNumberStringMaximumDigit = 20;


@implementation ISHFinancialNumberString
@synthesize decimalNumber;
@synthesize currentString;

- (id)init {
    self = [super init];
    
    if (self) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        decimalNumber = [NSDecimalNumber zero];
        currentString = @"";
        backSpaceString = @"";
        deleteString = @"";
        setOfValidCharacters = [NSSet setWithObjects:@"0", @"00", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",backSpaceString, nil];
    }
    
    return self;
}

- (BOOL)appendString:(NSString*)stringToAttach {    
    // we do not accept anything longer than 2 (but we except @"00")
    if (!stringToAttach || ([stringToAttach length] > 1 && ![stringToAttach isEqualToString:@"00"])) {
        return NO;
    }
    
    // if it is the delete string (delete button on keyboard), just reset display
    if ([stringToAttach isEqualToString:deleteString]) {
        [self clearAll];
        return NO;
    }
    
    // map decimal separator to @"00"
    if ([stringToAttach isEqualToString:[self.numberFormatter decimalSeparator]]) {
        stringToAttach = @"00";
    }
    
    // if is not a valid input string, call badCharacter method
    if (![setOfValidCharacters member:stringToAttach]) {
        return NO;
    }    
    
    
    // if the string is at max length and we did not push backspace the last char, it's an error
    if ([currentString length] >= kISHFinancialNumberStringMaximumDigit && 
        ![stringToAttach isEqualToString:backSpaceString]) {
        return NO;
    }
    
    NSDecimalNumber *currentDecimalNumber = [self decimalNumber];
    if (!currentDecimalNumber) {
        currentDecimalNumber = [NSDecimalNumber zero];
    }
    
    
    short digits = [self.numberFormatter maximumFractionDigits];
    // check if it is a backspace
    if ([stringToAttach isEqualToString:backSpaceString]) {
        // remove last character
        if (![currentDecimalNumber isEqualToNumber:[NSDecimalNumber zero]]) {
            currentDecimalNumber = [currentDecimalNumber decimalNumberByMultiplyingByPowerOf10:-1 withBehavior:[NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:digits raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO]];
        } else {
            // we can not backspace if it already is 0
            return NO;
        }
    } else {
        // no, it's not backspace
        // see if it is zero
        if ([stringToAttach isEqualToString:@"0"]) {
            // 0, multiply by 10
            currentDecimalNumber = [currentDecimalNumber decimalNumberByMultiplyingByPowerOf10:1];
        } else if ([stringToAttach isEqualToString:@"00"]) {
            // 00, multiply by 100
            currentDecimalNumber = [currentDecimalNumber decimalNumberByMultiplyingByPowerOf10:2];     
        } else {
            // 1-9, multiply by 10 and add the input number divided by 10^digits where digits are the number of digits displayed at the moment.
            NSDecimalNumber *numberToAdd = [[NSDecimalNumber decimalNumberWithString:stringToAttach] decimalNumberByMultiplyingByPowerOf10:-digits];
            currentDecimalNumber = [[currentDecimalNumber decimalNumberByMultiplyingByPowerOf10:1] decimalNumberByAdding:numberToAdd];
        }
    }
    
    if ([self maximumDecimalNumber] && [currentDecimalNumber compare:[self maximumDecimalNumber]] == NSOrderedDescending) {
        return NO;
    }
    
    [self setDecimalNumber:currentDecimalNumber];
    return YES;
}

- (void)setDecimalNumber:(NSDecimalNumber*)aDecimalNumber {
    [self setDecimalNumber:(NSDecimalNumber*)aDecimalNumber andText:nil];   
}

- (void)setDecimalNumber:(NSDecimalNumber*)aDecimalNumber andText:(NSString*)text {
    decimalNumber = aDecimalNumber;
    if (!text) {
        [self refreshText];
    } else {
        currentString = text;
    }
}

- (void)refreshText {
    currentString = [[self.numberFormatter stringFromNumber:[self decimalNumber]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)clearAll {
	[self setDecimalNumber:[NSDecimalNumber zero]];
}

- (void)deleteLastDigit {
	[self appendString:backSpaceString];
}

+ (NSDecimalNumber *)typicalMaximumDecimalNumberForAmounts {
    return [NSDecimalNumber decimalNumberWithMantissa:1 exponent:6 isNegative:NO];
}

@end
