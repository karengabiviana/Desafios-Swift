//
//  SDSStatefulObject.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 09.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSStatefulObject+Private.h"

@implementation SDSStatefulObject

- (id)highlighted {
    return _highlighted ? : self.normal;
}

- (id)disabled {
    return _disabled ? : self.normal;
}

- (NSString *)documentationForValue:(id)obj {
    return [obj description];
}

- (NSString *)documentation {
    NSString *doc = [NSString stringWithFormat:@"normal: %@", [self documentationForValue:self.normal]];
    if (_highlighted) {
        doc = [doc stringByAppendingFormat:@" | highlighted: %@", [self documentationForValue:self.highlighted]];
    }
    if (_disabled) {
        doc = [doc stringByAppendingFormat:@" | disabled: %@", [self documentationForValue:self.disabled]];
    }
    return doc;
}

#if TARGET_OS_IOS
- (id)valueForState:(UIControlState)controlState {
    switch (controlState) {
        case UIControlStateNormal:
        case UIControlStateApplication:
        case UIControlStateReserved:
            return self.normal;

        case UIControlStateHighlighted:
        case UIControlStateSelected:
        case UIControlStateFocused:
            return self.highlighted;

        case UIControlStateDisabled:
            return self.disabled;
    }

    return self.normal;
}

#endif
@end

@implementation SDSStatefulString

- (instancetype)initWithNormal:(nullable NSString *)normal {
    self = [super init];
    if (self) {
        self.normal = normal ? : @"";
    }
    return self;
}
@end
