//
//  SDSStyledCollectionViewCell.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 19.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSStyledCollectionViewCell_h
#define SDSStyledCollectionViewCell_h

#import "SDSStyleSheet.h"

NS_ASSUME_NONNULL_BEGIN

typedef SDSButtonStyle SDSCellStyle;

/**
 *   A UICollectionView subclass supporting the styling via SDSCellStyle from SDSStyleSheets.
 *   @note It uses the backgroundView to render the SDSCellStyle. Attempting to set a custom
 *   backgroundView throws an assertion.
 */
NS_SWIFT_NAME(StyledCollectionViewCell)
@interface SDSStyledCollectionViewCell : UICollectionViewCell

/**
 *   Applies the non-font parts of a style configuration (colors, shadows...) of the given cell style as provided by the global
 *   stylesheet to the cell.
 *
 *   @param style The style to apply to the cell. It must be present in the global stylesheet to take effect.
 */
- (void)applyButtonStyle:(SDSCellStyle)style NS_SWIFT_NAME(apply(buttonStyle:));

/**
 *   Applies the non-font parts of a style configuration (colors, shadows...) of the given cell style as provided by the given
 *   stylesheet to the cell
 *
 *   @param style The style to apply to the cell. It must be present in the given stylesheet to take effect.
 *
 *   @param styleSheet The stylesheet defining the text style configuration.
 */
- (void)applyButtonStyle:(SDSCellStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(buttonStyle:from:));

- (void)updateForControlState:(UIControlState)controlState NS_REQUIRES_SUPER;

/// The button style configuration applied via applyButtonStyle.
@property (nonatomic, nullable, readonly) SDSButtonStyleConfiguration *buttonStyle;
@property (nonatomic, readonly) UIControlState state;

@end

NS_ASSUME_NONNULL_END

#endif
