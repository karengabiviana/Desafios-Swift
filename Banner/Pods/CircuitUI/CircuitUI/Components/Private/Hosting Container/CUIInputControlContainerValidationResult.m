//
//  CUIInputControlContainerValidationResult.m
//  CircuitUI
//
//  Created by Marcel Voß on 08.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIInputControlContainerValidationResult.h"

#import "CUITextFieldValidationResult.h"
#import "CUISelectControlValidationResult.h"

@implementation CUIInputControlContainerValidationResult

- (instancetype)initWithSuccess:(BOOL)success reason:(nullable NSString *)reason {
    self = [super init];
    if (self) {
        _success = success;
        _reason = [reason copy];
    }
    return self;
}

- (instancetype)initWithTextFieldValidationResult:(CUITextFieldValidationResult *)result {
    if (!result) {
        return nil;
    }

    return [self initWithSuccess:result.success reason:result.reason];
}

- (instancetype)initWithSelectValidationResult:(CUISelectControlValidationResult *)result {
    if (!result) {
        return nil;
    }

    return [self initWithSuccess:result.success reason:result.reason];
}

- (BOOL)isEqualToResult:(CUIInputControlContainerValidationResult *)result {
    return [result.reason isEqualToString:self.reason] && result.success == self.success;
}

- (BOOL)isEqual:(id)other {
    if (self == other) {
        return YES;
    }

    if (![other isKindOfClass:[self class]]) {
        return NO;
    }

    return [self isEqualToResult:other];
}

- (NSUInteger)hash {
    return self.reason.hash & self.success;
}

@end
