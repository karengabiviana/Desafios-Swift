//
//  CUILabelLargeAmount.m
//  CircuitUI
//
//  Created by Hagi on 02.03.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "CUILabelLargeAmount.h"
#import "CUILabel+Private.h"

@implementation CUILabelLargeAmount

@dynamic adjustsFontSizeToFitWidth;
@dynamic numberOfLines;

- (void)cui_commonInit {
    super.adjustsFontSizeToFitWidth = YES;
    [super cui_commonInit];
}

- (SDSTextStyleConfiguration *)createTextStyleConfiguration {
    return CUITextStyleCreateLargeAmount(self.isStrikethrough);
}

- (CGFloat)cui_lineSpacing {
    return 4;
}

- (BOOL)cui_isStrikethrough {
    return self.isStrikethrough;
}

- (void)setStrikethrough:(BOOL)strikethrough {
    if (!strikethrough == !_strikethrough) {
        return;
    }

    _strikethrough = strikethrough;
    [self cui_updateTextStyle];
    [self cui_updateParagraphStyle];
}

@end
