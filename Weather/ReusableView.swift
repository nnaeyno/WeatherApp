//
//  ReusableView.swift
//  Weather
//
//  Created by nn on 2/23/23.
//

import UIKit

@IBDesignable
class ReusableView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            loadContentView()
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            loadContentView()
            setup()
        }
        
        override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            loadContentView()
            setup()
        }
        
        private func loadContentView() {
            let bundle = Bundle(for: Self.self)
            let className = String(describing: Self.self)
            bundle.loadNibNamed(className, owner: self, options: nil)
            
            addSubview(contentView)
            contentView.frame = bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        func setup() {
            
        }
        
}
