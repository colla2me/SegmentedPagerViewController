//
//  PagerContentView.swift
//  Example-Swift
//
//  Created by samuel on 2019/4/5.
//  Copyright © 2019 samuel. All rights reserved.
//

import UIKit

protocol ViewPagerDataSource: class {
    
    func viewControllers(for viewPager: ViewPager) -> [PageContentViewController]
}

protocol ViewPagerDelegate: class {
    
    func viewPager(didShow childController: PageContentViewController, at index: Int)
    
    func viewPagerWillBeginDragging(_ scrollView: UIScrollView)
    
    func viewPagerDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
}

final class ViewPager: UIView {
    
    private let scrollView = UIScrollView()
    
    private var viewControllers: [UIViewController] = []
    
    private var viewControllersForScrolling: [UIViewController]?
    
    private var currentIndex = 0
    
    private var previousIndex = 0
    
    private var lastContentOffset: CGFloat = 0.0
    
    private var lastSize: CGSize = .zero
    
    weak var dataSource: ViewPagerDataSource?
    
    weak var delegate: ViewPagerDelegate?
    
    weak var parent: UIViewController?
    
    private(set) weak var visibleController: PageContentViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScrollView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lastSize = scrollView.bounds.size
        updateContentIfNeed()
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.constraintToSuperview()
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        backgroundColor = .white
    }
}

extension ViewPager {
    
    func reloadViewControllers() {
        guard let viewControllers = dataSource?.viewControllers(for: self), !viewControllers.isEmpty else {
            fatalError("viewControllers must not be nil")
        }
        
        guard let _ = parent else {
            fatalError("parent must not be nil")
        }
        
        self.viewControllers = viewControllers as! [UIViewController]
    }
    
    func reloadViewPager() {
        guard isViewLoaded else { return }
        
        for childController in viewControllers where childController.parent != nil {
            childController.beginAppearanceTransition(false, animated: false)
            childController.willMove(toParent: nil)
            childController.view.removeFromSuperview()
            childController.removeFromParent()
            childController.endAppearanceTransition()
        }
        
        reloadViewControllers()
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(viewControllers.count), height: scrollView.contentSize.height)
        if currentIndex >= viewControllers.count {
            currentIndex = viewControllers.count - 1
        }
        previousIndex = currentIndex
        scrollView.contentOffset = CGPoint(x: pageOffset(forChildAt: currentIndex), y: 0)
        updateContentIfNeed()
    }
    
    func updateContentIfNeed() {
        guard isViewLoaded else { // && !lastSize.equalTo(scrollView.bounds.size)
            return
        }
        guard scrollView.frame != .zero else { return }
        guard !viewControllers.isEmpty else { return }
        
        if lastSize.width != scrollView.bounds.size.width {
            lastSize = scrollView.bounds.size
            scrollView.contentOffset = CGPoint(x: pageOffset(forChildAt: currentIndex), y: 0)
        }
        lastSize = scrollView.bounds.size
        
        let pageViewControllers = viewControllersForScrolling ?? viewControllers
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(pageViewControllers.count), height: scrollView.contentSize.height)
        
        for (index, childController) in pageViewControllers.enumerated() {
            let pageOffset = self.pageOffset(forChildAt: index)
            if abs(scrollView.contentOffset.x - pageOffset) < scrollView.bounds.width {
                if childController.parent != nil {
                    childController.view.frame = CGRect(x: offset(forChildAt: index), y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
                    childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                } else {
                    childController.beginAppearanceTransition(true, animated: false)
                    parent?.addChild(childController)
                    childController.view.frame = CGRect(x: offset(forChildAt: index), y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
                    childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    scrollView.addSubview(childController.view)
                    childController.didMove(toParent: parent)
                    childController.endAppearanceTransition()
                }
            } else {
                if childController.parent != nil {
                    childController.beginAppearanceTransition(false, animated: false)
                    childController.willMove(toParent: nil)
                    childController.view.removeFromSuperview()
                    childController.removeFromParent()
                    childController.endAppearanceTransition()
                }
            }
        }
        
        let virtualPage = virtualPageFor(contentOffset: scrollView.contentOffset.x)
        currentIndex = pageFor(virtualPage: virtualPage)
        previousIndex = currentIndex
        
        let childController = pageViewControllers[currentIndex] as! PageContentViewController
        delegate?.viewPager(didShow: childController, at: currentIndex)
        visibleController = childController
    }
    
    func moveToViewController(at index: Int, animated: Bool = true) {
        guard isViewLoaded && currentIndex != index else {
            previousIndex = index
            return
        }
        
        if animated && abs(currentIndex - index) > 1 {
            var tmpViewControllers = viewControllers
            let currentChildVC = viewControllers[currentIndex]
            let fromIndex = currentIndex < index ? index - 1 : index + 1
            let fromChildVC = viewControllers[fromIndex]
            tmpViewControllers[currentIndex] = fromChildVC
            tmpViewControllers[fromIndex] = currentChildVC
            viewControllersForScrolling = tmpViewControllers
            scrollView.setContentOffset(CGPoint(x: pageOffset(forChildAt: fromIndex), y: 0), animated: false)
            isUserInteractionEnabled = !animated
            scrollView.setContentOffset(CGPoint(x: pageOffset(forChildAt: index), y: 0), animated: true)
        } else {
            isUserInteractionEnabled = !animated
            scrollView.setContentOffset(CGPoint(x: pageOffset(forChildAt: index), y: 0), animated: animated)
        }
    }
}

private extension ViewPager {
    
    var pageWidth: CGFloat {
        return scrollView.bounds.width
    }
    
    var isViewLoaded: Bool {
        return superview != nil && parent?.isViewLoaded == true
    }
    
    func canMove(to index: Int) -> Bool {
        return currentIndex != index && viewControllers.count > index
    }
    
    func pageOffset(forChildAt index: Int) -> CGFloat {
        return CGFloat(index) * pageWidth
    }
    
    func offset(forChildAt index: Int) -> CGFloat {
        return CGFloat(index) * pageWidth + (pageWidth - bounds.width) * 0.5
    }
    
    func offsetForChild(viewController: UIViewController) -> CGFloat {
        guard let index = viewControllers.index(of: viewController) else {
            fatalError("viewController out of bounds")
        }
        
        return offset(forChildAt: index)
    }
    
    func pageFor(contentOffset: CGFloat) -> Int {
        let result = virtualPageFor(contentOffset: contentOffset)
        return pageFor(virtualPage: result)
    }
    
    func virtualPageFor(contentOffset: CGFloat) -> Int {
        return Int((contentOffset + 1.5 * pageWidth) / pageWidth) - 1
    }
    
    func pageFor(virtualPage: Int) -> Int {
        if virtualPage < 0 {
            return 0
        }
        if virtualPage > viewControllers.count - 1 {
            return viewControllers.count - 1
        }
        return virtualPage
    }
    
    func moveTo(viewController: UIViewController, animated: Bool = true) {
        moveToViewController(at: viewControllers.index(of: viewController)!, animated: animated)
    }
}


extension ViewPager: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.viewPagerWillBeginDragging(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateContentIfNeed()
        lastContentOffset = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        viewControllersForScrolling = nil
        isUserInteractionEnabled = true
        updateContentIfNeed()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.viewPagerDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        visibleController?.scrollView?.setContentOffset(.zero, animated: true)
        return true
    }
}

