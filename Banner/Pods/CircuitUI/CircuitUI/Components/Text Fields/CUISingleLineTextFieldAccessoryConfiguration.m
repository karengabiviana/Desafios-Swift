//
//  CUISingleLineTextFieldAccessoryConfiguration.m
//  CircuitUI
//
//  Created by Marcel Voß on 17.08.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUISingleLineTextFieldAccessoryConfiguration.h"

@import UIKit;

@implementation CUISingleLineTextFieldAccessoryConfiguration

- (instancetype)initWithAccessoryView:(UIView *)accessoryView position:(CUISingleLineTextFieldAccessoryPosition)position {
    return [self initWithAccessoryView:accessoryView position:position respectSemanticContentDirection:YES];
}

- (instancetype)initWithAccessoryView:(UIView *)accessoryView position:(CUISingleLineTextFieldAccessoryPosition)position respectSemanticContentDirection:(BOOL)respectSemanticContentDirection {
    self = [super init];
    if (self) {
        _accessoryView = accessoryView;
        _position = position;
        _respectSemanticContentDirection = respectSemanticContentDirection;
    }
    return self;
}

- (BOOL)isEqualToAccessoryConfiguration:(CUISingleLineTextFieldAccessoryConfiguration *)accessoryConfiguration {
    return self.position == accessoryConfiguration.position &&
    self.respectSemanticContentDirection == accessoryConfiguration.respectSemanticContentDirection &&
    [self.accessoryView isEqual:accessoryConfiguration.accessoryView];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }

    if (![other isKindOfClass:[self class]]) {
        return NO;
    }

    return [self isEqualToAccessoryConfiguration:other];
}

- (NSUInteger)hash {
    return self.accessoryView.hash & self.position & self.respectSemanticContentDirection;
}

@end
