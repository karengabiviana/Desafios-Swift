//
//  CUILabelInteractive2.m
//  CircuitUI
//
//  Created by Illia Lukisha on 19/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabelInteractive2.h"
#import "CUILabel+Private.h"

@implementation CUILabelInteractive2

- (SDSTextStyleConfiguration *)createTextStyleConfiguration {
    return CUITextStyleCreateInteractive2(self.variant);
}

- (CGFloat)cui_lineSpacing {
    return 2;
}

- (void)setVariant:(CUILabelInteractiveVariant)variant {
    _variant = variant;
    [self cui_updateTextStyle];
}

@end
