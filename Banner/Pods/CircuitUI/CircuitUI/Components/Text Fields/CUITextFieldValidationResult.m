//
//  CUITextFieldValidationResult.m
//  CircuitUI
//
//  Created by Marcel Voß on 31.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUITextFieldValidationResult.h"

@implementation CUITextFieldValidationResult

- (instancetype)initWithSuccess:(BOOL)success reason:(NSString *)reason {
    self = [super init];
    if (self) {
        _success = success;
        _reason = [reason copy];
    }
    return self;
}

+ (instancetype)successWithReason:(NSString *)reason {
    return [[[self class] alloc] initWithSuccess:YES reason:reason];
}

+ (instancetype)failureWithReason:(NSString *)reason {
    return [[[self class] alloc] initWithSuccess:NO reason:reason];
}

- (BOOL)isEqualToResult:(CUITextFieldValidationResult *)result {
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
