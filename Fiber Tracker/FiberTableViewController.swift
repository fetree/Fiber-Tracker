//
//  FiberTableViewController.swift
//  Fiber Tracker
//
//  Created by David Eisenbaum on 1/8/20.
//  Copyright © 2020 David Eisenbaum. All rights reserved.
//

import UIKit

class FiberTableViewController: UITableViewController {
    
    var fiberTimesArray : [FiberCDItem] = []
    
    let df = DateFormatter()
    
    //github test
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData(){
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let fiberTimes = try? context.fetch(FiberCDItem.fetchRequest()) as? [FiberCDItem]{
                self.fiberTimesArray = fiberTimes
                tableView.reloadData()
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fiberTimesArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = fiberTimesArray[indexPath.row].typeOfSupplement! + " taken at " + fiberTimesArray[indexPath.row].timeToString!
        
        return cell
    }
    
    // swipe to delete functionality
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let deletedItem = fiberTimesArray[indexPath.row]
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                context.delete(deletedItem)
                loadData()
            }
        }
    }
    
    @IBAction func addBarButton(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let fiber = FiberCDItem(context: context)
            
            // set date and time
            df.dateFormat = "MM-dd hh:mm a"
            df.amSymbol = "AM"
            df.pmSymbol = "PM"
            let dateString = df.string(from: Date())
            fiber.timeToString = dateString
            
            // set type of supplement
            fiber.typeOfSupplement = "Metamucil"
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            loadData()
        }
    }
    
}
