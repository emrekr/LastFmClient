//
//  UIView+Constraints.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

import UIKit

extension UIView {
    
    enum ConstraintType {
        case vertically,horizontally,all
    }
    
    /// Add constraints with visual format
    ///
    /// - Parameters:
    ///   - format: Visual format just change the view names with v0,v1,v2...
    ///   - views: Views for the constraints
    /// - Example:
    /// ``` self.view.addConstraints(_ format: "V:|-20-[v0]-20-|", views:contentView) ```
    func addConstraints(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: viewsDictionary))
    }
    
    /// This function calls the `func addConstraints(_ format: String, views: UIView...)` function and applies it to all subviews
    ///
    /// - Parameter format: Visual format just change the view names with v0,v1,v2...
    func addConstraintsToSubviews(_ format : String) {
        for subview in subviews {
            addConstraints(format, views: subview)
        }
    }
    
    /// Fill superview with given view
    ///
    /// - Parameters:
    ///   - constraint: An enum for constraint type
    ///   - ```  public enum constraintType { case vertical,horizontal,both }```
    ///   - view: Our subview
    ///   - space: Space between view and superview layout guide
    func fill(_ constraint : ConstraintType, with space : CGFloat? = nil) {
        guard let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        var spaceString = ""
        if let space = space {
            spaceString = "-\(space)-"
        }
        switch constraint {
        case .vertically:
            superview.addConstraints("V:|\(spaceString)[v0]\(spaceString)|", views: self)
        case .horizontally:
            superview.addConstraints("H:|\(spaceString)[v0]\(spaceString)|", views: self)
        case .all:
            superview.addConstraints("H:|\(spaceString)[v0]\(spaceString)|", views: self)
            superview.addConstraints("V:|\(spaceString)[v0]\(spaceString)|", views: self)
        }
    }
}
