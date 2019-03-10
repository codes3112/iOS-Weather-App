//
//  WeatherTableViewController.swift
//  myWeatherApp
//
//  Created by sneha arora on 2018-08-30.
//  Copyright © 2018 sneha arora. All rights reserved.
// SwiftyJson


import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    //instantiating data object to use in table views
    var forecastData = [Weather]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* //calling function forecast from Weather Model in viewDidLoad when function forecast used string as parameter
        Weather.forecast(withLocation: "37.8267,-122.4233"){
            (results:[Weather]) in
            for result in results{
                print("\(result)\n\n")
            }
        } */
        searchBar.delegate = self
        updateWeatherForLocation(location: "New York")

        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty{
            //update Weather Location
            updateWeatherForLocation(location: locationString)
        }
    }
    
    func updateWeatherForLocation (location:String){
        CLGeocoder().geocodeAddressString(location){ (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil{
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion:{(results:[Weather]?)
                        in
                        if let weatherData = results{
                          self.forecastData = weatherData
                            
                    //user interface need to be performed on the main thread as they happen asynchronously
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                        
                    })
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forecastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding:.day, value:section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let weatherObject = forecastData[indexPath.section] // changed row to section as same data was getting repeated in row
        cell.textLabel?.text = weatherObject.summary
        cell.detailTextLabel?.text = "\(Int((weatherObject.temperature)-32)*5/9) ºC"
        cell.imageView?.image = UIImage(named: weatherObject.icon)

        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
