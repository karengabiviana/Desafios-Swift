//
//  CUIDefaultButton+DebugMenu.h
//  CircuitUI
//
//  Created by Florian Schliep on 08.06.22.
//

#import "CUIDefaultButton.h"

/**
 * ⚠️⚠️⚠️
 * This API exposes temporary, internal functionality to the Merchant App's debu menu.
 * Do not use this API. It may be removed or changed at any time and is not considered part of the stable, semantically versioned API.
 * ⚠️⚠️⚠️
 */

@interface CUIDefaultButton (DebugMenu)

@property (class, nonatomic) BOOL __useBlackWhiteTheme;

@end
