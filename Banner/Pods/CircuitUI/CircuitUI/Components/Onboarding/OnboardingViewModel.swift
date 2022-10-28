//
//  OnboardingViewModel.swift
//  CircuitUI
//
//  Created by Andrii Kravchenko on 13.08.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

import Foundation

/// OnboardingViewModel is used to initialise OnboardingViewController and contains slides-specific info, navigation buttons config
public struct OnboardingViewModel {
    /// Array of onboarding slides to display
    let slides: [Slide]
    /// Configuration for Next-Previous-Finish-Cancel buttons
    let navigationButtons: NavigationButtons
    /// Whether Page Control should be displayed between slides container and navigation buttons
    let isPageControlVisible: Bool

    public init(slides: [Slide],
                navigationButtons: NavigationButtons,
                isPageControlVisible: Bool) {
        self.slides = slides
        self.navigationButtons = navigationButtons
        self.isPageControlVisible = isPageControlVisible
    }
}

public extension OnboardingViewModel {
    /// Config model for each particular Onboarding slide
    struct Slide {
        /// Slide title
        let title: String
        /// Slide subtitle
        let subtitle: String
        /// Optional slide image which takes 33% of the container height
        let image: UIImage?
        /// Custom buttons array which optionally could be attached for each parrticular slide above navigation buttons
        let buttons: [Button]

        public init(title: String, subtitle: String, image: UIImage?, buttons: [Button]) {
            self.title = title
            self.subtitle = subtitle
            self.image = image
            self.buttons = buttons
        }
    }

    struct NavigationButtons {
        /// Optional cancel button title located on the top screen corner used to dismiss onboarding
        let cancelTitle: String?
        /// Previous button title used to navigate to the previous slide (used on all devices different from the iPhone. On iPhone `<` chevron is used instead)
        let previousTitle: String
        /// Next button title used to navigate to the next slide
        let nextTitle: String
        /// Finish button title used on the last slide
        let finishTitle: String

        public init(cancelTitle: String?,
                    previousTitle: String,
                    nextTitle: String,
                    finishTitle: String) {
            self.cancelTitle = cancelTitle
            self.previousTitle = previousTitle
            self.nextTitle = nextTitle
            self.finishTitle = finishTitle
        }
    }
}

public extension OnboardingViewModel.Slide {
    /// Slide-specific button config
    struct Button {
        /// Button title
        let title: String
        /// Button style (primary, secondary, tertiary)
        let style: Style
        /// Action closure to be called
        let action: () -> Void

        public init(title: String, style: Style, action: @escaping (() -> Void)) {
            self.title = title
            self.style = style
            self.action = action
        }
    }
}

public extension OnboardingViewModel.Slide.Button {
    enum Style {
        case primary
        case secondary
        case tertiary
    }
}
