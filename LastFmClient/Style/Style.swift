//
//  Style.swift
//  LastFmClient
//
//  Created by Emre Kuru on 21.07.2025.
//

import UIKit

struct Style<View: UIView> {
    let apply: (View) -> Void

    func apply(to view: View) {
        apply(view)
    }
}

extension UIView {
    convenience init<V>(style: Style<V>) {
        self.init(frame: .zero)
        apply(style)
    }
    
    func apply<V>(_ style: Style<V>) {
        guard let view = self as? V else {
            return
        }
        style.apply(to: view)
    }
    
    @discardableResult
    func style<V>(_ style: Style<V>) -> V {
        guard let view = self as? V else {
            return self as! V
        }
        style.apply(to: view)
        return view
    }}

