//
// Created by Ivan Gaydamakin on 09.05.2021.
//


import UIKit

typealias EdgeClosure = (_ view: UIView, _ superview: UIView) -> [NSLayoutConstraint]
typealias LayoutOnEdgeClosure = (_ view: UIView) -> [NSLayoutConstraint]

extension UIView {

    func pin(on superview: UIView, _ callback: EdgeClosure) {
        superview.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(callback(self, superview))
    }

    func layoutOn(_ callback: LayoutOnEdgeClosure) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(callback(self))
    }

}

protocol LayoutGuideProvider {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutGuideProvider {
}

extension UILayoutGuide: LayoutGuideProvider {
}

extension UIView {
    var safeArea: LayoutGuideProvider {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide
        } else {
            return self
        }
    }
}