//
//  PagerSegmentedViewController.swift
//  Example-Swift
//
//  Created by samuel on 2019/4/5.
//  Copyright © 2019 samuel. All rights reserved.
//

import UIKit

@objc protocol PageContentViewController where Self: UIViewController {
    
    @objc optional var scrollView: UIScrollView { get }
}

class SegmentedPagerViewController: UIViewController {
    
    private var contentOffsetObservation: NSKeyValueObservation?
    private var mainScrollView: PagerScrollView!
    private(set) var viewPager: ViewPager!
    private let pagerHeader = PagerHeaderView()
    private let tabStripView = UIView()
    
    var segmentedControl: UIView! {
        didSet {
            oldValue?.removeFromSuperview()
            tabStripView.addSubview(segmentedControl)
            segmentedControl.constraintToSuperview()
        }
    }
    
    var headerView: UIView! {
        didSet {
            pagerHeader.config(headerView, viewPager: viewPager)
        }
    }
    
    var headerHeight: CGFloat = 200.0
    
    var tabStripHeight: CGFloat = 40.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPager()
        viewPager.reloadViewControllers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateContentSize()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLayoutConstraint.activate([
            pagerHeader.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: topLayoutLength),
            pagerHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagerHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagerHeader.heightAnchor.constraint(equalToConstant: headerHeight)
        ])
        
        let topConstraint = tabStripView.topAnchor.constraint(equalTo: pagerHeader.bottomAnchor)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        var safeAreaTopConstraint: NSLayoutConstraint!
        if #available(iOS 11, *) {
            safeAreaTopConstraint = tabStripView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor)
        } else {
            safeAreaTopConstraint = tabStripView.topAnchor.constraint(greaterThanOrEqualTo: topLayoutGuide.bottomAnchor)
        }
        NSLayoutConstraint.activate([
            topConstraint,
            safeAreaTopConstraint,
            tabStripView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabStripView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabStripView.heightAnchor.constraint(equalToConstant: tabStripHeight)
        ])
        
        NSLayoutConstraint.activate([
            viewPager.topAnchor.constraint(equalTo: tabStripView.bottomAnchor),
            viewPager.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewPager.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewPager.heightAnchor.constraint(equalToConstant: contentHeight)
        ])

        mainScrollView.contentSize = CGSize(width: view.bounds.width, height: topLayoutLength + headerHeight + tabStripHeight + contentHeight + 1)
    }

    func viewControllers(for pagerViewController: SegmentedPagerViewController) -> [PageContentViewController] {
        assertionFailure("viewControllers(for:) method must be overrided by subclass")
        return []
    }
    
    func segmentedPager(didShow childController: PageContentViewController, at index: Int) {}
    
    private func setupPager() {
        view.backgroundColor = .white
        mainScrollView = PagerScrollView(frame: view.bounds)
        mainScrollView.delegate = self
        mainScrollView.markAsScrollable = true
        view.addSubview(mainScrollView)
        if #available(iOS 11.0, *) {
            mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        viewPager = ViewPager()
        viewPager.parent = self
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(viewPager)
        
        pagerHeader.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(pagerHeader)
        
        tabStripView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(tabStripView)
        
        pagerHeader.layer.zPosition = -3
        viewPager.layer.zPosition = -2
        tabStripView.layer.zPosition = -1
    }
    
    private func updateContentSize() {
        mainScrollView.contentSize = CGSize(width: view.bounds.width, height: topLayoutLength + headerHeight + tabStripHeight + contentHeight + 1)
    }
}

private extension SegmentedPagerViewController {
    
    var topLayoutLength: CGFloat {
        let topLayoutLength: CGFloat
        if #available(iOS 11, *) {
            topLayoutLength = view.safeAreaInsets.top
        } else {
            topLayoutLength = topLayoutGuide.length
        }
        return topLayoutLength
    }
    
    var bottomLayoutLength: CGFloat {
        let bottomLayoutLength: CGFloat
        if #available(iOS 11, *) {
            bottomLayoutLength = view.safeAreaInsets.bottom
        } else {
            bottomLayoutLength = bottomLayoutGuide.length
        }
        return bottomLayoutLength
    }
    
    var pageWidth: CGFloat {
        return view.bounds.width
    }
    
    var pageHeight: CGFloat {
        return view.bounds.height - topLayoutLength - tabStripHeight - headerHeight
    }
    
    var contentHeight: CGFloat {
        return view.bounds.height - topLayoutLength - tabStripHeight
    }
}

extension SegmentedPagerViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView, isParent: Bool) {
        if isParent {
            let offsetY = scrollView.contentOffset.y
            let sillHeight: CGFloat = headerHeight
            if offsetY >= sillHeight {
                scrollView.contentOffset = CGPoint(x: 0, y: sillHeight)
                viewPager.visibleController?.scrollView?.markAsScrollable = true
                scrollView.markAsScrollable = false
            } else {
                if scrollView.markAsScrollable == false {
                    scrollView.contentOffset = CGPoint(x: 0, y: sillHeight)
                } else {}
            }
        } else {
            if scrollView.markAsScrollable == false {
                scrollView.contentOffset = .zero
            }
            let offsetY = scrollView.contentOffset.y
            if offsetY <= 0 {
                scrollView.contentOffset = .zero
                scrollView.markAsScrollable = false
                mainScrollView.markAsScrollable = true
            }
        }
    }
}

extension SegmentedPagerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === mainScrollView else { return }
        scrollViewDidScroll(scrollView, isParent: true)
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
}

extension SegmentedPagerViewController: ViewPagerDataSource, ViewPagerDelegate {
    
    func viewControllers(for viewPager: ViewPager) -> [PageContentViewController] {
        return viewControllers(for: self)
    }
    
    func viewPager(didShow childController: PageContentViewController, at index: Int) {
        contentOffsetObservation?.invalidate()
        guard let scrollView = childController.scrollView else { return }
        let keyValueObservation = scrollView.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let this = self else { return }
            guard change.newValue != change.oldValue else { return }
            this.scrollViewDidScroll(scrollView, isParent: false)
        })
        contentOffsetObservation = keyValueObservation
        
        if mainScrollView.contentOffset.y == 0 {
            scrollView.setContentOffset(.zero, animated: false)
        }
        
        segmentedPager(didShow: childController, at: index)
    }
    
    func viewPagerWillBeginDragging(_ scrollView: UIScrollView) {
        if mainScrollView.contentOffset.y > 0 && mainScrollView.contentOffset.y < headerHeight {
            mainScrollView.setContentOffset(.zero, animated: true)
        }
        mainScrollView.isScrollEnabled = false
    }
    
    func viewPagerDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        mainScrollView.isScrollEnabled = true
    }
}
