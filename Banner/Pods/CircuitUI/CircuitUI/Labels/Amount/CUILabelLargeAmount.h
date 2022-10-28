//
//  CUILabelLargeAmount.h
//  CircuitUI
//
//  Created by Hagi on 02.03.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "CUILabel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Label implementing the Large-Amount and Large-Amount-Strikethrough
 * styles of Circuit UI Mobile.
 */
NS_SWIFT_NAME(LabelLargeAmount)
@interface CUILabelLargeAmount : CUILabel

/**
 *  Set to `YES` to add the strikethrough text attribute.
 *
 *  Defaults to `NO`.
 */
@property (nonatomic, getter=isStrikethrough) BOOL strikethrough;

#pragma mark - Unavailable

@property(nonatomic) BOOL adjustsFontSizeToFitWidth NS_UNAVAILABLE;
@property(nonatomic) NSInteger numberOfLines NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
