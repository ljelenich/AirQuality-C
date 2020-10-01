//
//  DVMCitiesListViewController.swift
//  AirQuality ObjC
//
//  Created by LAURA JELENICH on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

import UIKit

class DVMCitiesListViewController: UIViewController {

    // MARK: - Properties
    var state: String?
    var country: String?
    var cities: [String] = [] {
        didSet {
            updateTableView()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        guard let state = state,let country = country else { return }
        DVMCityAirQualityController.fetchSupportedCities(inState: state, country: country) { (cities) in
            if let cities = cities {
                self.cities = cities
            }
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let country = country,
                let state = state,
                let destinationVC = segue.destination as? DVMCityDetailViewController
                else { return }
            
            let selectedCity = cities[indexPath.row]
            destinationVC.city = selectedCity
            destinationVC.state = state
            destinationVC.country = country
        }
    }
    
    // MARK: - Class Methods
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension DVMCitiesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let city = cities[indexPath.row]
        cell.textLabel?.text = city
        return cell
    }
}
