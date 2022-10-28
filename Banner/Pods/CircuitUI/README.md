# Circuit UI

[Circuit UI (Mobile)](https://sumupteam.atlassian.net/wiki/spaces/DEV/pages/1521388736/Design+System+Focus+Group) is SumUp’s design system and component library, this is the implementation of it for iOS.

If you are looking for documentation of its predecessor, **SDSDesignSystem**, please find its [README here](Archive/SDSDesignSystem-README.md).

## Integration

Circuit UI is distributed as [SumUp-internal](https://github.com/sumup/cocoapods-specs) Cocoapod, please see the [CircuitUI.podspec](CircuitUI.podspec) file for exact specifications.

### Requirements

* Xcode 13 or later
* Deployment Target iOS 12 or later

## Contribution, Help and Release Steps

Please refer to the [Contribution README](CONTRIBUTION.md).

## Overview

Circuit UI provides components (ready-to-use building blocks for native user interfaces), primitives (values you can use for stylistic purposes) as well as an icon library.
All types use the `CUI` prefix and their respective Swift names are the same as ObjC, just without the prefix.

### Component Types

* [Labels](#Labels)
* [Buttons](#Buttons)
* [Text Fields](#Text-Fields)
    * [Single Line](#Single-Line)
    * [Currency](#Currency)
    * [Multi Line](#Multi-Line)
* [Bottom Navigation](#Bottom-Navigation)
    * [Default](#Default)
    * [Contextual](#Contextual)
* [Status](#Status)
    * [Pill](#Pill)
    * [Badge](#Badge)
    * [Line](#Line)
    * [Indeterminate](#Indeterminate)
* [Notification](#Notification)
    * [Banner](#Banner)
    * [Toast](#Toast)
    * [Modal](#Modal)
    * [Fullscreen](#Fullscreen)
* [Select](#Select)
* [Avatar](#Avatar)
* [Tabs](#Tabs)
* [List Item](#List-Item)

_Missing a component? Check the [Component Status Page](https://sumupteam.atlassian.net/wiki/spaces/DEV/pages/3066823136/Component+status) or the [Contribution README](CONTRIBUTION.md)._

#### Usage in XIB/Storyboard files

You can use Circuit UI components directly in your XIB/Storyboard files without any code by setting the appropriate class name in the Identity Inspector:

![](README-resources/Label-Storyboard.png)

Please note that you'll need to use the Objective-C class name, even if your code is in Swift.

If you connect your `IBOutlet` to code, remember to use the correct class name in code (instead of `UILabel`, `UIButton`, …), as you will otherwise not see the correct API in code completion.

### Primitive Types

* [Spacing](#Spacing)
* [Semantic Color](#Semantic-Color)

### Icon Library

Circuit UI provides a collection of commonly needed image assets, curated by the brand design team.
They are exposed as an extension on `UIImage`, which allows for type-safe convenient access:
```swift
let image = UIImage.cui_account_24
// …
button.setImage(.cui_archive_24, for: .normal)
```
As they are all prefixed with `cui_`, you can easily filter for them in code-completion. A full list is available in [`UIImage+CUILibrary.h`](CircuitUI/Icon%20Library/UIImage+CUILibrary.h) as well as the Eunomia sample app.

All assets are provided as vectors. The suffix indicates the intrinsic canvas size and different versions may be optimized for different display sizes.

## Sample App

The Xcode project includes a sample app, [Eunomia](Eunomia/), which gives you an overview of all available APIs and how they can be used. 

#### Install Eunomia from [App Center](https://install.appcenter.ms/orgs/sumup/apps/eunomia-1/distribution_groups/ucars-public/):

[<img width=300 src='https://user-images.githubusercontent.com/3989307/144458001-08a8946a-d1d8-47e9-ab9e-b740e8689e69.png'>](https://install.appcenter.ms/orgs/sumup/apps/eunomia-1/distribution_groups/ucars-public/)

![](README-resources/Eunomia-Screenshot-1.png) ![](README-resources/Eunomia-Screenshot-2.png) ![](README-resources/Eunomia-Screenshot-3.png) ![](README-resources/Eunomia-Screenshot-4.png) ![](README-resources/Eunomia-Screenshot-5.png)

## Migration Guide

If you are migrating from SDSDesignSystem to Circuit UI, please find the [Migration Guide here](MigrationGuide.md) with an overview of the major changes and example code.

## Primitives

### Spacing

Circuit UI provides a set of constants to be used for spacings in user interfaces. They are defined using the `CUISpacing` type, which is a typdef/typealias for `CGFloat`. Due to this, in ObjC, you can use `CUISpacing` in all places where `CGFloat` is accepted. In Swift, you can use the `.rawValue` accessor to get the `CGFloat` value or use a convenience helper that Circuit UI provides, such as for `NSLayoutAnchor` etc.

##### *Objective-C*

```objc
[button.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor spacing:CUISpacingBit].active = YES;
```

##### *Swift*

```swift
button.leadingAnchor.constraint(equalTo: view.leadingAnchor, spacing: .bit).isActive = true
```

### Semantic-Color

Circuit UI provides a set of semantically named colors. While most of the time, our components should provide the styling you need out of the box, there will be cases where you will need to use colors manually to style your UI.
A common use-case, for example, is tinting images from our icon library to fit your use-case.

```swift
imageView.image = UIImage.cui_battery_24
imageView.tintColor = isBatteryLow ? SemanticColor.alert : SemanticColor.body
```

## Components

### Labels

Circuit UI provides subclasses of `UILabel` for each typography style, following the naming scheme: `CUILabel<StyleName>`

#### Variants

Some typography styles have multiple variants. For those cases, the respective subclass will contain a `variant` property.

##### *Objective-C*
```objc
CUILabelBody1 *label = [CUILabelBody1 labelWithText:@"Sample"];
label.variant = CUILabelBodyVariantSuccess;
```

##### *Swift*
```swift
let label = LabelBody1("Sample")
label.variant = .success
```

#### Link Styles

The [`Link-1` and `Link-2`](https://www.figma.com/file/lgvQDus1CRKC7heaA1EzkR/Circuit-UI-Mobile?node-id=2153%3A4974) styles are considered sub-styles of `Body-1` and `Body-2` respectively. Hence, you can use the `CUILabelBody1` and `CUILabelBody2` classes to create your labels and the `-addLinkWithURL:toSubstring:` API to apply these styles.

#### Restrictions

Circuit UI is responsible for styling labels and it should not be necessary to modify the appearance yourself. Due to this, some properties commonly used for styling are unavailable and will be controlled internally by the implementation. Please refer to [this declaration](CircuitUI/Labels/CUILabel.h#L29) for an overview.

### Buttons

Circuit UI provides two sizes of buttons, **Giga** and **Kilo**. Each button size is available as **Primary, Secondary and Tertiary variant**. Each of those types of button has a destructive appearance (in order to indicate a destructive action in a UI, such as "Delete"), which you can enable using the `destructive` Boolean property.

While each size and variant combination has a dedicated subclass for convenience (e.g. `CUIButtonGigaPrimary` or `CUIButtonKiloTertiary`), you can also use the `CUIDefaultButton` base class directly in cases where your button type is not known at compile time.

##### *Objective-C*
```objc
CUIDefaultButton *button = [[CUIDefaultButton alloc] initWithVariant:CUIButtonVariantSecondary size:CUIButtonSizeKilo];
```

##### *Swift*
```swift
let button = DefaultButton(variant: .secondary, size: .kilo)
```

#### On-Colored-Background Buttons

Circuit UI provides a second, dedicated base class for buttons (`CUIButtonOnColoredBackground`), meant to be used exclusively on colored backgrounds (see [usage guidelines](https://www.figma.com/file/lgvQDus1CRKC7heaA1EzkR/Circuit-UI-Mobile?node-id=606%3A3084)).

The structure is similar to the default button type, where you can either use the base class or one of its subclasses (e.g. `CUIButtonOnColoredBackgroundDarkPrimary` or `CUIButtonOnColoredBackgroundLightSecondary`).

Please refer to the code documentation for information about the features and especially the restrictions of this button type.

#### Convenience API

Circuit UI provides convenience initializers for buttons, to support the most common usages without boilerplate code:

##### *Objective-C*
```objc
CUIButtonKiloPrimary *button = [CUIButtonKiloPrimary buttonWithTitle:@"Title goes here"];
```

##### *Swift*
```swift
let button = ButtonGigaSecondary(title: "Title does here", image: UIImage(named: "…"))
```

#### Restrictions

Circuit UI is responsible for styling buttons and it should not be necessary to modify the appearance yourself. Due to this, some properties and methods commonly used for styling are unavailable and will be controlled internally by the implementation. Please refer to [this declaration](CircuitUI/Buttons/CUIButton.h#L28) for an overview.

### Text Fields

Circuit UI provides three different kinds of text fields for different use-cases. While they all inherit from the same base class, you should only use the subclasses (listed below) directly; the base class is considered an implementation detail that mainly serves a common API for all use-cases.

All text fields offer some convenience helpers out of the box, such as `maximumNumberOfCharacters` and `inputValidation`. As all classes also inherit from `UIControl`, so you can expect control events and other features of `UIControl` to work. Access to the underlying textfields `inputAccessoryView` is available by setting the `keyboardAccessoryView` property on any text field. A helper method, `addDismissToolbarToKeyboard()`, is available and will show a simple `inputAccessoryView` containing a system `.done` button, which will dismiss the keyboard for the given textfield.

#### Single Line

`CUISingleLineTextField` is the most commonly needed text field, allowing single-line text input as well as displaying an optional accessory view. The class conforms to `UITextInputTraits`, so its API is extremely close to `UITextField` and is almost a drop-in replacement.

```swift
let textField = SingleLineTextField(title: "Product name", subtitle: nil)
textField.placeholder = "Enter your product's name here"
textField.addDismissToolbarToKeyboard()
```

#### Currency

`CUICurrencyTextField` is a special kind of single line text field, specifically designed for the input of monetary values.

```swift
 let textField = CurrencyTextField(title: "Product Price", subtitle: "Net price to be displayed in your online store")
 textField.currencyLocale = merchantLocale

// …

let enteredAmount = textField.value
```

#### Multi Line

The `CUIMultiLineTextField` class should be used for multi line text input, similar to `UITextView`. 

```swift
let textField = MultiLineTextField(title: "Product Description", subtitle: nil)
textField.placeholder = "Enter a description for your product"
textField.minimumNumberOfLines = 5
```

### Bottom Navigation

Circuit UI implements the available bottom navigation styles using a container view controller, similar to UIKit's `UITabBarController`. The tab bar controller will use the [`tabBarItem`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621175-tabbaritem) of each child view controller to compose the tab bar's content. `NavigationController` is designed to accompany the `TabBarController` and is supporting `hidesBottomBarWhenPushed` flag the same way system would work. We **strongly recommend** you to migrate your code, to make use of the new NavigationController, as we will extend its functionality over the time.


```swift
let controller = PlainTabBarController()
controller.viewControllers = [
    MyViewController1(),
    MyViewController2()
]
```

#### Default

The default bottom navigation style is implemented in the `PlainTabBarController` class.

#### Contextual

The "contextual" bottom navigation style is implemented in the `FloatingTabBarController` class.

### Status

#### Pill

Circuit UI implements the Status Pill component using the `CUIStatusPill` class, allowing you to apply its variants using the `variant` property.

```swift
let pill = StatusPill(text: "Yay, success!", variant: .confirm)
view.addSubview(pill)
```

#### Badge

The Status Badge component works really similar to the [Pill](#Pill) documented above. The only difference is that you create an instance of the `CUIStatusBadge` class.

#### Line

The Status Line component is different to the above-mentioned Pill and Badge because it also adds an icon that call-sites can specify. The icon will always be tinted so that it contrasts the status color.

```swift
let model = StatusLineModel(icon: .confirm, text: "Confirm", variant: .confirm)
let line = StatusLine(model: model)
view.addSubview(line)
```

#### Indeterminate

The Status Indeterminate component displays a dot indicator, colored depending on the selected `variant`.

```swift
let model = StatusIndeterminateModel(variant: .confirm)
let Indeterminate = StatusIndeterminate(model: model)
view.addSubview(Indeterminate)
```

### Notification

#### Banner

The Banner Notification component is available through the `CUINotificationBannerView` class, which is a simple `UIView` you can add to any view hierarchy you need it in. The view is self-sizing in height and flexible in width.

```swift
let buttonConfig = NotificationBannerView.ButtonConfiguration(title: "callToActionText",
                                                              buttonType: .primary) {
    // ...
}
let config = NotificationBannerView.Configuration(title: "title",
                                                  body: "body",
                                                  buttonConfiguration: buttonConfig,
                                                  image: UIImage(named: "image"),
                                                  variant: .promotional)

let notificationBannerView = NotificationBannerView(configuration: config)
```

#### Toast

The Toast Notification component is available through the `CUINotificationToast` class, which is a simple `UIView` you can add to any view hierarchy you need it in. The component is self-sizing and you should not apply any sizing constraints to it.

```swift
let notification = NotificationToast(title: "Don't panic!", subtitle: "Did you pack your towel?", variant: .alert)
view.addSubview(notification)
```

#### Modal

The Modal Notification component, `NotificationModalViewController`, is a `UIViewController` you can present modally. The view controller manages its own presentation, so you should avoid manipulating properties related to its transition/presentation.

##### *Swift*
```swift
let destructive = NotificationContentView.Action(title: "Delete", style: .destructive) {
    // ...
}
let cancel = NotificationContentView.Action(title: "Cancel", style: .cancel) {
    // ...
}
let configuration = NotificationModalViewController.Configuration(title: "Title",
                                                                  body: "Body text",
                                                                  actions: [destructive, cancel])
let modal = NotificationModalViewController(configuration: configuration)
present(modal, animated: true)
```

##### *Objective-C*
```objc
CUINotificationContentViewAction *confirm = [[CUINotificationContentViewAction alloc] initWithTitle:@"OK"
                                                                                              style:CUINotificationContentViewActionStyleDefault
                                                                                             action:^{ // ...
}];
CUINotificationContentViewAction *cancel = [[CUINotificationContentViewAction alloc] initWithTitle:@"Cancel"
                                                                                             style:CUINotificationContentViewActionStyleCancel
                                                                                            action:^{ // ...
}];
CUINotificationModalViewConfiguration *configuration = [[CUINotificationModalViewConfiguration alloc] initWithTitle:@"Title"
                                                                                                               body:@"Body text"
                                                                                                            actions:@[confirm, cancel]
                                                                                                              image:nil
                                                                                                             layout:CUINotificationContentViewLayoutAutomatic];
CUINotificationModalViewController *vc = [[CUINotificationModalViewController alloc] initWithConfiguration:configuration];

[self presentViewController:vc animated:YES completion:nil];
```

#### Fullscreen

The Fullscreen Notification component works really similar to the [Modal](#Modal) documented above. The only difference is that you create an instance of the `NotificationContentView` class, which is a `UIView` you need to add to your view hierarchy and manage its presentation.

##### *Swift*
```swift
let confirm = NotificationContentView.Action(title: "OK") {
    // ...
}
let cancel = NotificationContentView.Action(title: "Cancel", style: .cancel) {
    // ...
}
let configuration = NotificationContentView.Configuration(title: "Title",
                                                          body: "Body text",
                                                          actions: [confirm, cancel])
let notificationView = NotificationContentView(configuration: configuration)

// Add notificationView to the view hierarchy
view.addSubview(notificationView)
```

##### *Objective-C*
```objc
CUINotificationContentViewAction *confirm = [[CUINotificationContentViewAction alloc] initWithTitle:@"OK"
                                                                                              style:CUINotificationContentViewActionStyleDefault
                                                                                             action:^{ // ...
}];

CUINotificationContentViewAction *cancel = [[CUINotificationContentViewAction alloc] initWithTitle:@"Cancel"
                                                                                             style:CUINotificationContentViewActionStyleCancel
                                                                                            action:^{ // ...
}];

CUINotificationContentViewConfiguration *configuration = [[CUINotificationContentViewConfiguration alloc] initWithTitle:@"Title"
                                                                                                                   body:@"Body text"
                                                                                                                actions:@[confirm, cancel]
                                                                                                                  image:nil
                                                                                                                 layout:CUINotificationContentViewLayoutAutomatic];
CUINotificationContentView *notificationView = [[CUINotificationContentView alloc] initWithConfiguration:configuration];

// Add notificationView to the view hierarchy
[self.view addSubview:notificationView];
```

### Select

The Select component of Circuit UI is available through the `CUISelectControl` class, which is a `UIControl` that allows the selection of an option from an array of strings passed to it. As it inherits from `UIControl`, you can expect control events and other features of `UIControl` to work.

```swift
let shippingOptions = ["Delivery", "Pick-Up"]
let picker = SelectControl(options: shippingOptions)
picker.placeholder = "Choose a shipping method"
picker.title = "Shipping Method"

// …

let selectedOption = shippingOptions[picker.selectedOptionIndex]
```

The Select component is available in two different sizes, `giga` and `kilo`. You can either use the `size` property to modify the size or use one of its convenience subclass, `CUISelectControlGiga` and `CUISelectControlKilo`.

### Avatar

The Avatar component of Circuit UI is available through the `AvatarControl` class, which is a `UIControl` that is typically used to display image input. As it inherits from `UIControl`, you can expect control events and other features of `UIControl` to work.

```swift
let avatarControl = AvatarControl(variant: .identity(.profile), size: .yotta)
avatarControl.addTarget(self, action: #selector(showImagePicker(_:)), for: .touchUpInside)
```

### Tabs

Circuit UI implements the tabs component using a container view controller, `SegmentedTabViewController`. The view controller will use the [`title`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621364-title) of each child view controller to compose the segmented control.

```swift
let tabViewController = SegmentedTabViewController(style: .paging, viewControllers: [
    MyViewController1(),
    MyViewController2()
])
```

### List Item

The List Item component provides easy-to-configure table view & collection view cells. They are classified into "Action" and "Navigation" items, both of which are available as single- or multiline variants. The main difference between collection view & table view cells, is between how separators are implemented. You can have `fullWidth`, `inset` or `none` separator variant inside of collection view cells, while you should use standard separators implementation for table views. Collection view cells aren't supporting readable content width, so it's your layout's responsibility to provide the correct frame for the cell.

```swift
let actionItemConfig = ListContentConfigurationAction.singleLine(
    leadingElement: .image(.cui_visa_24, contentMode: .scaleAspectFit),
    leadingText: "VISA Payment",
    trailingText: "$20.00")

// register a cell, based on one or more configurations;
// you can call this repeatedly if you create more configs
tableView.register(actionCellConfigs: [actionItemConfig])

// dequeue a cell before display
let actionCell = tableView.dequeueReusableCell(configuration: actionItemConfig, indexPath: indexPath)
actionCell.applyConfiguration(actionItemConfig)
```
