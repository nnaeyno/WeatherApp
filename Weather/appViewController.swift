//
//  appViewController.swift
//  Weather
//
//  Created by nn on 2/26/23.
//

import UIKit

struct City {
    let lat: Double
    let lon: Double
    let cityName: String
    let degreeAndDescription: String
    let cloudiness: String
    let humidity: String
    let windSpeed: String
    let windDirection: String
    let imageName: String
    let firtImg: String
    let secondImg: String
    let thirdImg: String
    let fourthImg: String
}

struct TableCity {
    let tempreture: String
    let imageName: String
    let hour: String
    let description: String
    let weekDay: String
}
struct Day {
    var day: String
    var hours: [TableCity]
}

class AppViewController: UIViewController {
    var cityNames = [String]()
    var cities = [String : City]()
    var currCity: City!
    let blurEffect = UIBlurEffect(style: .light)
    var blurVisualEffectView:UIVisualEffectView!
    var tableHours: [Day] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        self.view.addSubview(blurVisualEffectView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.stopLoader(loader: loader)
        }
    }
    
    @IBAction func refreshPage() {
        preconditionFailure("This method needs to be overridden")
    }
    
}

extension AppViewController{
  
    func loader() -> UIAlertController{
       
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let indicatorLoad = UIActivityIndicatorView(frame: alert.view.bounds)
        indicatorLoad.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indicatorLoad.hidesWhenStopped = true
        indicatorLoad.style = UIActivityIndicatorView.Style.large
        indicatorLoad.startAnimating()
        alert.view.tintColor = UIColor.clear
        alert.view.addSubview(indicatorLoad)
        present(alert, animated: true, completion: nil)
        return alert
    }
    
    func stopLoader(loader: UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
            self.blurVisualEffectView.removeFromSuperview()
            
        }
    }
    
}



