//
//  NibView.swift
//  GoalFury
//
//  Created by Morten Hansen on 17/06/2018.
//  Copyright © 2018 GoalFury. All rights reserved.
//

import Foundation

protocol UIViewNibLoadable : NSObjectProtocol {
    static var nib: UINib { get }
    static var nibName: String { get }
    
    /**
     Identifies the view that will be the superview of the contents loaded from
     the Nib. Referenced in setupNib().
     - returns: Superview for Nib contents.
     */
    var nibContainerView: UIView? { get }
    
    func setupFromNib()
}
extension UIViewNibLoadable {
    static var nibName: String { return NSStringFromClass(self).components(separatedBy: ".").last! }
    static var nib: UINib { return UINib(nibName: nibName, bundle: nil) }
    
    var nib: UINib { return type(of: self).nib }
    
    var nibContainerView: UIView? { return nil }

    func setupFromNib() {
        guard let container = nibContainerView, let view = loadContainerViewFromNib() else { return }
        container.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }
    
    func isClassNibsFileOwner() -> Bool {
        return (nib.instantiate(withOwner: self, options: nil).first as? Self) == nil
    }
    
    func loadContainerViewFromNib() -> UIView? {
        return nib.instantiate(withOwner: self, options: nil).first as? UIView // swiftlint:disable:this force_cast
    }
}

// MARK: - UIView subclasses

@IBDesignable
class NibView : UIView, UIViewNibLoadable {
    
    var nibContainerView: UIView? { return self }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if !TARGET_INTERFACE_BUILDER
        self.setupFromNib()
        #endif
    }
    
    // MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if isClassNibsFileOwner() {
            self.setupFromNib()
        }
    }
    //Not called on File's Owner
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IB
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupFromNib()
    }
}
