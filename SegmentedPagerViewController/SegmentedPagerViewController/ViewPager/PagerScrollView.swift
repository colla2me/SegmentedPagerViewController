//
//  PagerScrollView.swift
//  Example-Swift
//
//  Created by samuel on 2019/4/5.
//  Copyright © 2019 samuel. All rights reserved.
//

import UIKit

class PagerScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    private var otherGestureRecognizers: [UIGestureRecognizer]?
    
    init(frame: CGRect, otherGestureRecognizers: [UIGestureRecognizer]? = nil) {
        self.otherGestureRecognizers = otherGestureRecognizers
        super.init(frame: frame)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        isScrollEnabled = true
        isPagingEnabled = false
        backgroundColor = .white
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let _ = gestureRecognizer.view as? UIScrollView else {
            return false
        }
        
        if let otherGestureRecognizers = otherGestureRecognizers, otherGestureRecognizers.contains(otherGestureRecognizer) {
            return false
        }
        return true
    }
}

private var markAsScrollableKey: Void?
extension UIScrollView {
    
    var markAsScrollable: Bool {
        get {
            return (objc_getAssociatedObject(self, &markAsScrollableKey) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &markAsScrollableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
