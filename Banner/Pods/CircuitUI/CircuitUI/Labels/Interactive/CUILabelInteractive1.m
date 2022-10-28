//
//  CUILabelInteractive1.m
//  CircuitUI
//
//  Created by Illia Lukisha on 19/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabelInteractive1.h"
#import "CUILabel+Private.h"

@implementation CUILabelInteractive1

- (SDSTextStyleConfiguration *)createTextStyleConfiguration {
    return CUITextStyleCreateInteractive1(self.variant);
}

- (CGFloat)cui_lineSpacing {
    return 4;
}

- (void)setVariant:(CUILabelInteractiveVariant)variant {
    _variant = variant;
    [self cui_updateTextStyle];
}

@end
