//
//  CUIStatusVariant.h
//  CircuitUI
//
//  Created by Igor Gorodnikov on 07.06.2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, CUIStatusVariant) {
    CUIStatusVariantTint,
    CUIStatusVariantConfirm,
    CUIStatusVariantNeutral,
    CUIStatusVariantNotify,
    CUIStatusVariantAlert,
    CUIStatusVariantPromo,
    CUIStatusVariantSpecial
} NS_SWIFT_NAME(StatusVariant);
