//
//  UIView+Constraints.swift
//  Example-Swift
//
//  Created by samuel on 2019/4/6.
//  Copyright © 2019 samuel. All rights reserved.
//

private var topConstraintKey: Void?
private var bottomConstraintKey: Void?
private var leadingConstraintKey: Void?
private var trailingConstraintKey: Void?
private var widthConstraintKey: Void?
private var heightConstraintKey: Void?
private var centerXConstraintKey: Void?
private var centerYConstraintKey: Void?

import UIKit

internal extension UIView {
    
    func constraintToSuperview() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topConstraint = topAnchor.constraint(equalTo: superview.topAnchor)
        bottomConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        leadingConstraint = leadingAnchor.constraint(equalTo: superview.leadingAnchor)
        trailingConstraint = trailingAnchor.constraint(equalTo: superview.trailingAnchor)
    }
    
    func removeAllConstraints() {
        topConstraint = nil
        bottomConstraint = nil
        leadingConstraint = nil
        trailingConstraint = nil
        widthConstraint = nil
        heightConstraint = nil
    }
    
    var topConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &topConstraintKey) as? NSLayoutConstraint
        }
        
        set(constraint) {
            topConstraint?.isActive = false
            objc_setAssociatedObject(self, &topConstraintKey, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            constraint?.isActive = true
        }
    }
    
    var bottomConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &bottomConstraintKey) as? NSLayoutConstraint
        }
        
        set(constraint) {
            bottomConstraint?.isActive = false
            objc_setAssociatedObject(self, &bottomConstraintKey, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            constraint?.isActive = true
        }
    }
    
    var leadingConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &leadingConstraintKey) as? NSLayoutConstraint
        }
        
        set(constraint) {
            leadingConstraint?.isActive = false
            objc_setAssociatedObject(self, &leadingConstraintKey, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            constraint?.isActive = true
        }
    }
    
    var trailingConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &trailingConstraintKey) as? NSLayoutConstraint
        }
        
        set(constraint) {
            trailingConstraint?.isActive = false
            objc_setAssociatedObject(self, &trailingConstraintKey, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            constraint?.isActive = true
        }
    }
    
    var widthConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &widthConstraintKey) as? NSLayoutConstraint
        }
        
        set(constraint) {
            widthConstraint?.isActive = false
            objc_setAssociatedObject(self, &widthConstraintKey, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            constraint?.isActive = true
        }
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &heightConstraintKey) as? NSLayoutConstraint
        }
        
        set(constraint) {
            heightConstraint?.isActive = false
            objc_setAssociatedObject(self, &heightConstraintKey, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            constraint?.isActive = true
        }
    }
    
    var centerXConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &centerXConstraintKey) as? NSLayoutConstraint
        }
        
        set(constraint) {
            centerXConstraint?.isActive = false
            objc_setAssociatedObject(self, &centerXConstraintKey, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            constraint?.isActive = true
        }
    }
    
    var centerYConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &centerYConstraintKey) as? NSLayoutConstraint
        }
        
        set(constraint) {
            centerYConstraint?.isActive = false
            objc_setAssociatedObject(self, &centerYConstraintKey, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            constraint?.isActive = true
        }
    }
}
