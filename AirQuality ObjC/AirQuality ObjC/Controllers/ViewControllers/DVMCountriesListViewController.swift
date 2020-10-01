//
//  DVMCountriesListViewController.swift
//  AirQuality ObjC
//
//  Created by LAURA JELENICH on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

import UIKit

class DVMCountriesListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    // MARK: - Properties
       var countries: [String] = [] {
           didSet {
               updateTableView()
           }
       }

       // MARK: - Lifecycle
       override func viewDidLoad() {
           super.viewDidLoad()
           tableView.delegate = self
           tableView.dataSource = self
           DVMCityAirQualityController.fetchSupportedCountries { (countries) in
            if let countries = countries {
                self.countries = countries
            }
           }
       }
       
       // MARK: - Navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toStatesVC" {
               guard let indexPath = tableView.indexPathForSelectedRow,
                   let destinationVC = segue.destination as? DVMStatesListViewController
                   else { return }
               let selectedCountry = countries[indexPath.row]
               destinationVC.country = selectedCountry
           }
       }
       
       // MARK: - Helper Functions
       func updateTableView() {
           DispatchQueue.main.async {
               self.tableView.reloadData()
           }
       }
   }

   // MARK: - TableView DataSource/Delegate
extension DVMCountriesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country
        return cell
    }
}

