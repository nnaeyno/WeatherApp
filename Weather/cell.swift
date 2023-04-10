//
//  cell.swift
//  Weather
//
//  Created by nn on 2/19/23.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import SwiftyJSON
import CoreLocation
import SwifterSwift
import SDWebImage


class cell: UICollectionViewCell {
    
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var degreeAndDescription: UILabel!
    @IBOutlet weak var image: UIImageView!
   

    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var cloudinessNum: UILabel!
    @IBOutlet weak var forGradien: UIView!
    @IBOutlet weak var forGradient: UIView!
    
    @IBOutlet weak var windspeed: UILabel!
    
    @IBOutlet weak var windDirection: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var once = true

    override func layoutSubviews() {
       super.layoutSubviews()
        if once {
            forGradient.layer.addSublayer(gradientLayer)
            setBlueGradientBackground()
            forGradient.cornerRadius = 20;
            bg.cornerRadius = 20;
            once = false
        }
     }
    
    let gradientLayer = CAGradientLayer()
    
    func setBlueGradientBackground(){
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = bg.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    /*
     @IBOutlet weak var bg: UIView!
     @IBOutlet weak var location: UILabel!
     @IBOutlet weak var degreeAndDescription: UILabel!
     @IBOutlet weak var image: UIImageView!
    

     @IBOutlet weak var cloudness: ContentCell!
     @IBOutlet weak var forGradient: UIView!
     
     @IBOutlet weak var windDirection: ContentCell!
     @IBOutlet weak var windSpeed: ContentCell!
     @IBOutlet weak var humidity: ContentCell!
     */
    func configure(model: City){
        location.text = model.cityName
        degreeAndDescription.text = model.degreeAndDescription
        image.sd_setImage(with: URL(string: url(from: model.imageName)))
        cloudinessNum.text = model.cloudiness
        humidity.text = model.humidity
        windspeed.text = model.windSpeed
        windDirection.text = model.windDirection
       
        
    }
    
    private func url(from id: String) -> String {
        return "https://openweathermap.org/img/wn/\(id)@2x.png"
    }
    
    
}


final class cellController: NSObject, CLLocationManagerDelegate {
    
    let APIKey = "b9f5c4ea5a82045954c1810f3cd910da"
    var lat = 11.1
    var lon = 11.1
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    var locationName = "None"
    var degreeAndDescription = "None"
    var image = "None"
    var status: CLAuthorizationStatus!
    var firstImg = "None"
    var secondImg = "None"
    var thirdImg = "None"
    var fourthImg = "None"
    var cloudnessNum = "None"
    var humidityNum = "None"
    var windNum = "None"
    var windDirection = "None"
    private static let directions = ["E", "NE", "N", "NW", "W", "SW", "S", "SE"]

    static var shared = cellController()
    let carousel = CarouselViewController()
    
    override init() {
        status = locationManager.authorizationStatus
        super.init()
//        let indicatorSize: CGFloat = 70
//        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height - indicatorSize)/2, width: indicatorSize, height: indicatorSize)
//
//        activityIndicator.backgroundColor = UIColor.black
//        view.addSubview(activityIndicator)
//
        locationManager.requestWhenInUseAuthorization()
        
        
//        activityIndicator.startAnimating()
        
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
//        activityIndicator.stopAnimating()
        
    }
    var tableContents = [TableCity]()
    func getFiveDayWeather(lat: Double, lon: Double) {
        Alamofire.request("https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(APIKey)").responseJSON{
            response in
            if let responseStr = response.result.value{
          
                let jsonResponse = JSON(responseStr)
                self.tableContents = [TableCity]()
                for i in 0..<jsonResponse["list"].count {
                    var weatherDescr = jsonResponse["list"][i]["weather"][0]["description"].string
                    let weatherIcon = jsonResponse["list"][i]["weather"][0]["icon"].string
                    let temp = String(format: "%.2f", (jsonResponse["list"][i]["main"]["temp"].doubleValue - 273.15))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let dateTime = jsonResponse["list"][i]["dt_txt"].string
                    let date = dateTime!.date(withFormat: "yyyy-MM-dd HH:mm:ss")
                    let dateFormatterForWeek = DateFormatter()
                    dateFormatterForWeek.dateFormat = "EEEE"
                    let formatter = DateFormatter()
                    formatter.dateFormat = "hh"
                    let weekDay = dateFormatterForWeek.string(from: date!)
                    let hour = formatter.string(from: date!)
                    var tmpWeather = TableCity(tempreture: temp, imageName: weatherIcon!, hour: hour, description: weatherDescr!, weekDay: weekDay)
     
                    self.tableContents.append(tmpWeather)
                  
                    
                }
            }
           
            self.sections(lat: lat, lon: lon)
        }
    }
    var sectionedHours = [Day]()
    func sections(lat: Double, lon: Double){
        if(tableContents.count == 0){
            return
        }
        var array = [TableCity]()
        var firstDay = Day(day:  tableContents[0].weekDay, hours: array)
        sectionedHours = [Day]()
        sectionedHours.append(firstDay)
        for weather in  tableContents {
            if(sectionedHours[sectionedHours.count-1].day != weather.weekDay){
                var weathers = [TableCity]()
                sectionedHours.append(Day(day: weather.weekDay, hours: weathers))
            }
                sectionedHours[sectionedHours.count-1].hours.append(weather)

        }

    }
    
    func getWeather(lat: Double, lon: Double, completion: @escaping ((Error?, Bool, City?) -> Void)){
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(APIKey)&unit=metric").responseJSON{
            
            //https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
            response in
//            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value{
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                let wind = jsonResponse["wind"]
                self.locationName = jsonResponse["name"].stringValue
                self.image = iconName //pod 'SDWebImage'
                self.degreeAndDescription = String(format: "%.2f", (jsonTemp["temp"].doubleValue - 273.15)) + "°C | " + jsonWeather["main"].stringValue
                self.firstImg = iconName  //shesacvlellia
                let jsonClouds = jsonResponse["clouds"]
                self.cloudnessNum = jsonClouds["all"].stringValue + "%"
                
                self.secondImg = iconName //shesacvlellia
                self.humidityNum = String(jsonTemp["humidity"].doubleValue) + "mm"
                
                self.thirdImg = iconName  //shesacvlellia
                self.windNum = String(wind["speed"].doubleValue) + "km/h"
                
                self.fourthImg = iconName  //shesacvlellia
                let degree = wind["deg"]
                self.windDirection = cellController.directions[((degree.rawValue as! Int + 22) % 360) / 45]
                var res = City(lat: lat, lon: lon, cityName: self.locationName, degreeAndDescription: self.degreeAndDescription, cloudiness: self.cloudnessNum, humidity: self.humidityNum, windSpeed: self.windNum, windDirection: self.windDirection, imageName: self.image, firtImg: self.firstImg, secondImg: self.secondImg, thirdImg: self.thirdImg, fourthImg: self.fourthImg)
                completion(nil, true, res)
            }
            self.getFiveDayWeather(lat: lat, lon: lon)
        }
        
        .resume()
//        return City(lat: lat, lon: lon, cityName: locationName, degreeAndDescription: degreeAndDescription, cloudiness: cloudnessNum, humidity: humidityNum, windSpeed: windNum, windDirection: windDirection, imageName: image, firtImg: firstImg, secondImg: secondImg, thirdImg: thirdImg, fourthImg: fourthImg)
    }
    
    /*
     struct TableCity {
         let tempreture: String
         let imageName: String
         let date: Date
         let description: String
     }
     */
  
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
       // print("AAAAAA4\n")
        status = locationManager.authorizationStatus
        locationManager.stopUpdatingLocation()
        getWeather(lat: lat, lon: lon) { error, success, city in
            if let error = error {
                // Handle the error here
                return
            }
            if success, let city = city {
               // Data was correctly retrieved - and safely unwrapped for good measure, do what you need with it
               // Example:
                self.carousel.save(value: self.locationName, city: city)
                self.carousel.pg.reloadData()
            }
        }
       
        //carousel.pg.reloadData()
    }
    struct Model {
        var loc: String
        var temp: String
    }

    
    public func getInfo() -> Model {
        return Model(loc: locationName, temp: degreeAndDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        lon = 0
        lat = 0
        //idk handle errors here
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
           
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
            status = manager.authorizationStatus
            break
            
        case .notDetermined:        // Authorization not determined yet.
           
            break
            
        default:
            break
        }
    }
    
}

extension cellController {
    
    
    func getLocation(forPlaceCalled name: String,
                     completion: @escaping(CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            guard let location = placemark.location else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }

            completion(location)
        }
    }
}



/*
 var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
 
 you can use > < and ==
 */
