//
//  PeopleViewController.swift
//  Star Wars Encyclopedia
//
//  Created by Madin Kim on 3/19/18.
//  Copyright © 2018 DINDIN. All rights reserved.
//

import UIKit

class PeopleViewController: UITableViewController {
    
    var people:[String] = []
    
    func dataLoading(urlInput: String) {
        
        StarWarsModel.getAllPeople(urlInput: urlInput, completionHandler: { // passing what becomes "completionHandler" in the 'getAllPeople' function definition in StarWarsModel.swift
            data, response, error in
            do {
                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let results = jsonResult["results"] as? NSArray {
                        for person in results {
                            let personDict = person as! NSDictionary
                            self.people.append(personDict["name"]! as! String)
                        }
                    }
                    // if next key is exists, run dataLoading function again with new url
                    // (using recursion)
                    if let nextPage = jsonResult["next"] {
                        if nextPage is NSNull {
                            print(nextPage)
                        } else {
                            print(nextPage)
                            self.dataLoading(urlInput: nextPage as! String)
                        }
                    } else {
                        print("\(error ?? "No next page key" as! Error)")
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Something went wrong")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataLoading(urlInput: "http://swapi.co/api/people")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // if we return - sections we won't have any sections to put our rows in
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the count of people in our data array
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a generic cell
        let cell = UITableViewCell()
        // set the default cell label to the corresponding element in the people array
        cell.textLabel?.text = people[indexPath.row]
        // return the cell so that it can be rendered
        return cell
    }

}

