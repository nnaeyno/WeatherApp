//
//  TableController.swift
//  Weather
//
//  Created by nn on 2/26/23.
//

import UIKit

class TableController: AppViewController{
    
    @IBOutlet weak var hourlyForecast: UITableView!
    
    override func viewDidLoad() {
        tableHours = cellController.shared.sectionedHours
        super.viewDidLoad()
        hourlyForecast.delegate = self
        hourlyForecast.dataSource = self
        registerCell()
        hourlyForecast.reloadData()
        
    }
    private func registerCell(){
        hourlyForecast.register(UINib(nibName: "tableCell", bundle: nil), forCellReuseIdentifier: "tableCell")
    }
    override func refreshPage() {
        blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        self.view.addSubview(blurVisualEffectView)
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.stopLoader(loader: loader)
        }
    }
    
}


extension TableController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableHours.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return tableHours[section].day
    }

    // Configure Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableHours[section].hours.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.systemPink
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = UIColor.white

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let mycell = hourlyForecast.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let model = tableHours[indexPath.section].hours[indexPath.row]
        
        if let cell = mycell as? tableCell {
  
            cell.configure(model: model) //sections unda gadaeces
            
        }

        return mycell
    }


}
