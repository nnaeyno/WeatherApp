//
//  tableCell.swift
//  Weather
//
//  Created by nn on 3/4/23.
//

import UIKit
import SDWebImage

class tableCell: UITableViewCell {

    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var hour: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(model: TableCity){
        temp.text = "\(model.tempreture)°C"
        img.sd_setImage(with: URL(string: url(from: model.imageName)))
        hour.text = model.hour + ":00"
        desc.text = model.description
       
        
    }
    private func url(from id: String) -> String {
        return "https://openweathermap.org/img/wn/\(id)@2x.png"
    }
    
}
