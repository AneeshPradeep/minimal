//
//  UIControl.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit

class ClosureAct {
    
    let closure: () -> ()
    
    init(attachTo: AnyObject, closure: @escaping () -> Void) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc func invoke() {
        closure()
    }
}

extension UIControl {
    
    func setOnlickListener(for event: UIControl.Event = .primaryActionTriggered, action: @escaping () -> Void) {
        let act = ClosureAct(attachTo: self, closure: action)
        addTarget(act, action: #selector(ClosureAct.invoke), for: event)
    }
}
