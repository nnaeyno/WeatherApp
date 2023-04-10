//
//  ViewController.swift
//  Weather
//
//  Created by nn on 2/13/23.
//

import UIKit
import HSCycleGalleryView
import CoreData
import MapKit

class CarouselViewController: AppViewController, HSCycleGalleryViewDelegate {
 
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var blurview: UIVisualEffectView!
    @IBOutlet var error: ErrorView!
    @IBOutlet weak var addButton: UIButton!
    var text: String?

       
       
    // - Constants
//    private let locationManager = cellController()
    
    @IBAction func addFromPopUp(_ sender: Any){
        if(textField.text == nil || textField.text!.isEmpty || cities.keys.contains(textField.text!)){
//            print("asdasd\n")
//            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
//
//            present(alert, animated: true, completion: nil)
        } else {
            add(textField.text);
            animateScaleOut(desiredView: popUpView)
            animateScaleOut(desiredView: blurview)
            textField.text = ""
        }
    }
    @IBAction func addCity(_ sender: Any) {
        animateScaleIn(desiredView: blurview)
        animateScaleIn(desiredView: popUpView)
    }
    
    func add(_ city: String?){
        
        cellController.shared.getLocation(forPlaceCalled: city!) { location in
            guard let location = location else {
                //here show error
                return
            }
            cellController.shared.getWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { error, success, cityy in
                if let error = error {
                    // Handle the error here
                    return
                }
                if success, let cityy = cityy {
                   // Data was correctly retrieved - and safely unwrapped for good measure, do what you need with it
                   // Example:
                    self.save(value: city!, city: cityy)
                    
                }
            }
            
            
          
            //check if in data
            //check if valid (or empty)
            
            //save(value: city!)
        }
        
    }
    func changePageControl(currentIndex: Int) {
        Controller.currentPage = currentIndex
    }
    
    @IBOutlet weak var Controller: UIPageControl!
    
    @IBAction func pageController(_ sender: Any) {
        
    }
    
    func numberOfItemInCycleGalleryView(_ cycleGalleryView: HSCycleGalleryView) -> Int {
        let count: Int
        if(cities.count != 0){
            count = cities.count
        } else {
            count = 1
        }
         //in our case num of locations will be needed here
        Controller.numberOfPages = count
        Controller.isHidden = !(count > 1)
        return count
    }
    
    func cycleGalleryView(_ cycleGalleryView: HSCycleGalleryView, cellForItemAtIndex index: Int) -> UICollectionViewCell {
        let cell = cycleGalleryView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath(item: index, section: 0)) as! cell
        
        if(cellController.shared.status == .denied || cellController.shared.status == .restricted){
            error.isHidden = false
            
        } else {
            error.isHidden = true
        }
        //cell.configure(self.cities[self.cityNames[index]])
        if(index < cityNames.count){
            print(cities[cityNames[index]]!.cityName + "  count\n")
            cell.configure(model: cities[cityNames[index]]!)
        }
        
        return cell
    }
    
    func animateScaleIn(desiredView: UIView) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        desiredView.center = backgroundView.center
        desiredView.isHidden = false
        
        desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        desiredView.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
//            desiredView.transform = CGAffineTransform.identity
        }
    }
    
        /// Animates a view to scale out remove from the display
    func animateScaleOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            desiredView.alpha = 0
        }, completion: { (success: Bool) in
            desiredView.removeFromSuperview()
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            
        }, completion: { _ in
            
        })
    }
    
    
    @IBOutlet weak var pager: UIView!
    
    let pg = HSCycleGalleryView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("something")
        // Do any additional setup after loading the view.
        blurview.bounds = self.view.bounds
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.9, height: self.view.bounds.height*0.4)
        popUpView.layer.cornerRadius = 5
        pg.register(nib: UINib(nibName: "cell", bundle: nil), forCellReuseIdentifier: "cell")
        pg.delegate = self
        pager.addSubview(pg)
        retieveValues()
        
        
    }
}
extension CarouselViewController{
    
    func save(value: String, city: City) {
       
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Entity", in: context) else { return }
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            newValue.setValue(value, forKey: "city")
            //cities.append(City(lat: <#T##Double#>, lon: <#T##Double#>, cityName: <#T##String#>))
            self.cityNames.append(value)
            self.cities[value] = city
            do {
                try context.save()
                print("saved!")
            } catch {
                print("not saved")
            }
        }
        
        pg.reloadData()
        
    }
    
    func retieveValues() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
            
            do {
                let results = try context.fetch(fetchRequest)
                for result in results{
                    if let value = result.city {
                        //logic
                        
                        cellController.shared.getLocation(forPlaceCalled: value) { location in
                            guard let location = location else {
                                //here show error
                                return
                            }
                            cellController.shared.getWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { error, success, cityy in
                                if let error = error {
                                    // Handle the error here
                                    return
                                }
                                if success, let cityy = cityy {
                                   // Data was correctly retrieved - and safely unwrapped for good measure, do what you need with it
                                   // Example:
                                    self.cityNames.append(value)
                                    self.cities[value] = cityy
                                    self.pg.reloadData()
                                    
                                }
                            }
                        }
                        
                    }
                }
                
            } catch {
                print("error retrieving")
            }
        }
        
    }
}


//
//@IBAction func showInputAlert(){
//    let alert = UIAlertController(title: "Add City",
//                                  message: "Enter city name you wish to add",
//                                  preferredStyle: .alert
//    )
//    alert.addTextField{ [unowned self] textField in
//        textField.placeholder = "City"
//        textField.keyboardType = .namePhonePad
//        textField.addTarget(self, action: #selector(self.nameChanged(textField:)), for: .editingChanged)
//    }
//    addAction = UIAlertAction(title: "Add", style: .default, handler: { [unowned self] _ in
//        let first = nameText?.first
//        add(text: nameText!, number: numberText!, first: first!)
//
//    })
//    alert.addAction(addAction)
//    addAction.isEnabled = false
//    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//    present(alert, animated: true, completion: nil)
//}
//
//var startIndexPath: IndexPath!
//@objc func nameChanged(textField: UITextField){
//    nameText = textField.text
//    activateButton()
//}
//@objc func numberChanged(textField: UITextField){
//    numberText = textField.text
//    activateButton()
//}
//
//private func activateButton() {
//    if nameText?.isEmpty == false && numberText?.isEmpty == false {
//        addAction.isEnabled = true
//    } else {
//        addAction.isEnabled = false
//    }
//}
extension UIAlertController{
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.tintColor = UIColor.red
    }
 }
