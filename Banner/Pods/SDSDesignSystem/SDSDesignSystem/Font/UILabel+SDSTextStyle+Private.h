//
//  UILabel+SDSTextStyle+Private.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 08.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef UILabel_SDSTextStyle_Private_h
#define UILabel_SDSTextStyle_Private_h

@interface UILabel (SDSTextStyle)
@property (nonatomic, nullable) SDSTextStyleConfiguration *sds_textStyle;
@property (nonatomic, getter=sds_isScalingEnabled) BOOL sds_scalingEnabled;
@property (nonatomic) BOOL sds_invertedColor;
@end

#endif
