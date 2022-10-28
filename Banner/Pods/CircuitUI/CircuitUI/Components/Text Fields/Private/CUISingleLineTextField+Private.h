//
//  CUISingleLineTextField+Private.h
//  SDSDesignSystem
//
//  Created by Marcel Voß on 06.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit;

#import "CUISingleLineTextField.h"

@class SDSTextStyleConfiguration;

@interface CUISingleLineTextField (Private) <UITextFieldDelegate>

- (void)updateFontForCurrentTextStyle;
- (SDSTextStyleConfiguration *)textStyleForCurrentState;
- (CUISingleLineTextFieldAccessoryConfiguration *)accessoryConfigurationFrom:(NSString *)referenceString accessorySymbol:(NSString *)accessorySymbol;

@end
