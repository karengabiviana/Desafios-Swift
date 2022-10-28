//
//  ISHFinancialNumberString.h
//
//  Created by Felix Lamouroux on 17.01.12.
//  Copyright (c) 2012 iosphere GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ISHFinancialNumberString : NSObject {
    NSString *currentString;
    NSSet *setOfValidCharacters;
    
    NSString *backSpaceString;
    NSString *deleteString;
}

@property (strong, nonatomic) NSDecimalNumber *decimalNumber;
// set this property to limit input
@property (strong) NSDecimalNumber *maximumDecimalNumber;

/**
 *  Default is a currency formatter with current locale.
 *  You are strongly encouraged to set a reasonable locale on this formatter.
 *  Setting to nil will reset to default.
 *
 *  @return a number formatter
 */
@property (nonatomic, readonly) NSNumberFormatter *numberFormatter;

@property (readonly) NSString *currentString;
- (void)setDecimalNumber:(NSDecimalNumber *)aDecimalNumber andText:(nullable NSString *)text;
- (void)refreshText;
- (BOOL)appendString:(nullable NSString *)stringToAttach;
- (void)clearAll;
- (void)deleteLastDigit;

+ (NSDecimalNumber *)typicalMaximumDecimalNumberForAmounts;
@end

NS_ASSUME_NONNULL_END
