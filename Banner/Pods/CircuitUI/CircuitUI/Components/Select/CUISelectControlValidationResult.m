//
//  CUISelectControlValidationResult.m
//  CircuitUI
//
//  Created by Marcel Voß on 07.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUISelectControlValidationResult.h"

@implementation CUISelectControlValidationResult

- (instancetype)initWithSuccess:(BOOL)success reason:(nullable NSString *)reason {
    self = [super init];
    if (self) {
        _success = success;
        _reason = [reason copy];
    }
    return self;
}

+ (instancetype)success {
    return [[[self class] alloc] initWithSuccess:YES reason:nil];
}

+ (instancetype)failureWithReason:(NSString *)reason {
    return [[[self class] alloc] initWithSuccess:NO reason:reason];
}

- (BOOL)isEqualToResult:(CUISelectControlValidationResult *)result {
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
