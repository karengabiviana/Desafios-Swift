//
//  CUIDateSelectControlConfiguration.m
//  CircuitUI
//
//  Created by Roman Utrata on 20.04.2022.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "CUIDateSelectControlConfiguration.h"

@implementation CUIDateSelectControlConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        self.minDate = nil;
        self.maxDate = nil;
        self.dateFormatString = @"dd MMMM YYYY";
        self.locale = NSLocale.currentLocale;
        self.timeZone = NSTimeZone.localTimeZone;
    }
    return self;
}

@end
