//
//  UILabel+SDS.h
//  SDSDesignSystem
//
//  Created by Florian Schliep on 01.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import SDSDesignSystem.SDSTextStyleConfiguration;

// Expose private SDS API internally
@interface UILabel ()
@property (nonatomic) SDSTextStyleConfiguration *sds_textStyle;
@property (nonatomic, getter=sds_isScalingEnabled) BOOL sds_scalingEnabled;
@end
