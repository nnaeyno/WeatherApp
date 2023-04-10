//
//  ErrorView.swift
//  Weather
//
//  Created by nn on 2/23/23.
//

import UIKit

class ErrorView: ReusableView {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var reload: UIButton!
    @IBOutlet weak var label: UILabel!
    
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setup() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        layer.colors = [UIColor.systemPink.cgColor, UIColor.white.cgColor]
        bg.layer.addSublayer(layer)
    }
    
    /*
     // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
