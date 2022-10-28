//
//  CUILabelHeadline2.m
//  CircuitUI
//
//  Created by Florian Schliep on 22.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabelHeadline2.h"
#import "CUILabel+Private.h"

@implementation CUILabelHeadline2

- (SDSTextStyleConfiguration *)createTextStyleConfiguration {
    return CUITextStyleCreateHeadline2(self.variant);
}

- (CGFloat)cui_lineSpacing {
    return 2;
}

- (void)setVariant:(CUILabelHeadlineVariant)variant {
    _variant = variant;
    [self cui_updateTextStyle];
}

@end
