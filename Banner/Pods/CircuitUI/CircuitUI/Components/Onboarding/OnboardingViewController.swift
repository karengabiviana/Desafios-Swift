//
//  OnboardingViewController.swift
//  CircuitUI
//
//  Created by Andrii Kravchenko on 09.07.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

import UIKit

#if canImport(CircuitUI_Private)

import CircuitUI_Private

/// OnboardingViewControllerDelegate is required to dismiss Onboarding when its Cancel or Finish button clicked
public protocol OnboardingViewControllerDelegate: AnyObject {
    func onboardingController(_ onboardingController: OnboardingViewController, didCancelAt slideIndex: Int)
    func onboardingControllerDidFinish(_ onboardingController: OnboardingViewController)
}

/// OnboardingViewController used for instantiating onboarding and incorporates swipable slides area and navigation buttons
public final class OnboardingViewController: ViewController {
    private enum Colors {
        static let pageIndicatorActive = CUIColorFromHex(ColorReference.CUIColorRefN100.rawValue)
        static let pageIndicatorInactive = CUIColorFromHex(ColorReference.CUIColorRefN40.rawValue)
    }

    private enum Position {
        case beginning
        case middle
        case end
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.accessibilityIdentifier = "onboarding_collection_view"
        collectionView.backgroundColor = SemanticColor.background
        collectionView.registerClass(TaxSettingsOnboardingCell.self)
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var cancelButton: ButtonKiloTertiary = {
        let button = ButtonKiloTertiary()
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()

    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = Colors.pageIndicatorInactive
        control.currentPageIndicatorTintColor = Colors.pageIndicatorActive
        control.isUserInteractionEnabled = false
        return control
    }()

    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = Spacing.mega.rawValue
        return stack
    }()

    private lazy var bottomElementsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pageControl, buttonsStack])
        stack.axis = .vertical
        stack.spacing = Spacing.giga.rawValue
        return stack
    }()

    private var collectionViewSize: CGSize = .zero {
        didSet {
            if oldValue != .zero, collectionViewSize != oldValue {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }

    private var slidePosition: Position {
        if pageControl.currentPage == slides.count - 1 {
            return .end
        } else if pageControl.currentPage == 0 {
            return .beginning
        } else {
            return .middle
        }
    }

    private let navigationButtons: OnboardingViewModel.NavigationButtons
    private let slides: [OnboardingViewModel.Slide]
    private weak var delegate: OnboardingViewControllerDelegate?

    public init(model: OnboardingViewModel, delegate: OnboardingViewControllerDelegate?) {
        slides = model.slides
        navigationButtons = model.navigationButtons
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = traitCollection.userInterfaceIdiom == .pad ? .formSheet : .popover

        setupCancelButton(with: model.navigationButtons.cancelTitle)
        setupPageControl(isVisible: model.isPageControlVisible, slidesCount: model.slides.count)
        if let firstSlide = model.slides.first {
            configureActionButtons(for: firstSlide.buttons)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewSize = collectionView.bounds.size
    }
}

// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TaxSettingsOnboardingCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let slide = slides[safe: indexPath.item] else {
            return cell
        }
        cell.configure(model: .init(image: slide.image, title: slide.title, subtitle: slide.subtitle))
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionViewSize
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        configureContainer(for: scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        configureContainer(for: scrollView)
    }
}

// MARK: - Configuration

private extension OnboardingViewController {

    func initializeView() {
        view.backgroundColor = SemanticColor.background
        setupNavigationBar()

        view.addSubview(cancelButton, with: [
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, spacing: .mega),
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, spacing: .mega)
        ])

        view.addSubview(collectionView, with: [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        if cancelButton.titleLabel?.text?.isEmpty == false {
            collectionView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, spacing: .mega).isActive = true
        } else {
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, spacing: .mega).isActive = true
        }

        view.addSubview(bottomElementsStack, with: [
            bottomElementsStack.topAnchor.constraint(equalTo: collectionView.bottomAnchor, spacing: .mega),
            bottomElementsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, spacing: .giga),
            bottomElementsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, spacing: -.giga),
            bottomElementsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, spacing: -.mega)
        ])
    }

    func setupNavigationButtons(_ buttons: OnboardingViewModel.NavigationButtons) {
        buttonsStack.arrangedSubviews.last?.removeFromSuperview()
        switch slidePosition {
        case .beginning:
            let singleNextButton = makeNextButton(title: buttons.nextTitle)
            buttonsStack.addArrangedSubview(singleNextButton)
        case .middle:
            let nextButton = makeNextButton(title: buttons.nextTitle)
            let previousButton = makePreviousButton(title: buttons.previousTitle)
            let stack = UIStackView(arrangedSubviews: [previousButton, UIView(), nextButton])
            stack.axis = .horizontal
            buttonsStack.addArrangedSubview(stack)
        case .end:
            let previousButton = makePreviousButton(title: buttons.previousTitle)
            let finishButton = makeFinishButton(title: buttons.finishTitle)
            let stack = UIStackView(arrangedSubviews: slides.count > 1 ? [previousButton, UIView(), finishButton] : [finishButton])
            stack.axis = .horizontal
            buttonsStack.addArrangedSubview(stack)
        }
    }

    func configureActionButtons(for buttons: [OnboardingViewModel.Slide.Button]) {
        setupNavigationButtons(navigationButtons)

        // dropLast() here keeps navigation buttons in place ("Previous"/"Next") and remove all custom buttons for this particular slide
        let previousSlideButtonsCount = buttonsStack.arrangedSubviews.dropLast().count
        buttonsStack.arrangedSubviews.dropLast().forEach { $0.removeFromSuperview() }

        for (buttonIndex, buttonModel) in buttons.enumerated() {
            let button = buttonModel.style.makeButton()
            button.tag = buttonIndex
            button.setTitle(buttonModel.title, for: .normal)
            button.addTarget(self, action: #selector(slideButtonAction(_:)), for: .touchUpInside)
            buttonsStack.insertArrangedSubview(button, at: 0)
        }
        if previousSlideButtonsCount != buttons.count {
            bottomElementsStack.layoutIfNeeded()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    func configureContainer(for scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let scrollableAreaWidth = scrollView.frame.width
        let horizontalCenter = scrollableAreaWidth / 2
        pageControl.currentPage = Int(xOffset + horizontalCenter) / Int(scrollableAreaWidth)
        guard let slide = slides[safe: pageControl.currentPage] else {
            return
        }
        configureActionButtons(for: slide.buttons)
    }

    func makeNextButton(title: String) -> UIButton {
        let button = ButtonGigaPrimary()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(scrollToNextSlide), for: .touchUpInside)
        return button
    }

    func makeFinishButton(title: String) -> UIButton {
        let button = ButtonGigaPrimary()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(finish), for: .touchUpInside)
        return button
    }

    func makePreviousButton(title: String) -> UIButton {
        let button = ButtonGigaSecondary()
        if traitCollection.userInterfaceIdiom == .phone {
            button.setImage(.cui_chevron_left_24, for: .normal)
        } else {
            button.setTitle(title, for: .normal)
        }
        button.addTarget(self, action: #selector(scrollToPreviousSlide), for: .touchUpInside)
        return button
    }

    func setupCancelButton(with title: String?) {
        cancelButton.setTitle(title, for: .normal)
        cancelButton.isHidden = title == nil
    }

    func setupPageControl(isVisible: Bool, slidesCount: Int) {
        pageControl.isHidden = !isVisible
        pageControl.numberOfPages = slidesCount
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

// MARK: - Actions

private extension OnboardingViewController {
    @objc
    func slideButtonAction(_ sender: UIButton) {
        guard let buttonModel = slides[safe: pageControl.currentPage]?.buttons[safe: sender.tag] else {
            return
        }
        buttonModel.action()
    }

    @objc
    func scrollToNextSlide() {
        guard slidePosition != .end else {
            return
        }
        pageControl.currentPage += 1
        scrollToCurrentPage()
    }

    @objc
    func scrollToPreviousSlide() {
        guard slidePosition != .beginning else {
            return
        }
        pageControl.currentPage -= 1
        scrollToCurrentPage()
    }

    func scrollToCurrentPage() {
        collectionView.scrollToItem(at: .init(row: pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }

    @objc
    func finish() {
        delegate?.onboardingControllerDidFinish(self)
    }

    @objc
    func cancel() {
        delegate?.onboardingController(self, didCancelAt: pageControl.currentPage)
    }
}

private extension OnboardingViewModel.Slide.Button.Style {
    func makeButton() -> DefaultButton {
        switch self {
        case .primary:
            return ButtonGigaPrimary()
        case .secondary:
            return ButtonGigaSecondary()
        case .tertiary:
            return ButtonGigaTertiary()
        }
    }
}

#endif
