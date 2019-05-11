//
//  PagerHeaderView.swift
//  Example-Swift
//
//  Created by samuel on 2019/4/5.
//  Copyright © 2019 samuel. All rights reserved.
//

import UIKit

class PagerHeaderView: UIView {
    
    private weak var lastHeaderView: UIView?
    private weak var viewPager: ViewPager?
    
    func config(_ headerView: UIView, viewPager: ViewPager) {
        if let lastHeaderView = lastHeaderView {
            lastHeaderView.removeAllConstraints()
            lastHeaderView.removeFromSuperview()
        }
        self.viewPager = viewPager
        addSubview(headerView)
        headerView.constraintToSuperview()
        lastHeaderView = headerView
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard let viewPager = viewPager else { return view }
        guard let childController = viewPager.visibleController else { return view }
        if view is UIControl { return view }
        
        if !(view?.gestureRecognizers?.isEmpty ?? true) {
            return view
        }
        return childController.scrollView
    }
}
