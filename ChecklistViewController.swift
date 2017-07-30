//
//  ViewController.swift
//  TestRIK
//
//  Created by macbook air on 04/07/2017.
//  Copyright © 2017 Lytkin Artem. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController,
                                ItemDetailViewControllerDelegate {
  //-------------------------------------------------------------------------------------------
  //my data model
  
  var checklist: Checklist!
  
  // This declares that items will hold an array of ChecklistItem objects
  // but it does not actually create that array.
  // At this point, items does not have a value yet.
  var items: [ChecklistItem]

  required init?(coder aDecoder: NSCoder) {
    
    // 1. Make sure the instance variable items has a proper value(a new array).
    items = [ChecklistItem]()
    
    // 2. To ensure the rest of the view controller is properly unfrozen from the storyboard
    super.init(coder: aDecoder)
    // coder - the label to refer to the parameter of super's init method
    // aDecoder - as that super's init method parameter value
    
    
    // 3. Method to deal a real work of loading the plist file.
    loadChecklistItems()
  }
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Implementation of ItemDetailViewControllerDelegate methods ***
  //-----------------------------------------------------------------------------------------------
  //
  // - cancel
  
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  // - done (finish adding)
  
  func itemDetailViewController(_ controller: ItemDetailViewController,
                                didFinishAdding item: ChecklistItem) {
    
    let newRowIndex = items.count
    items.append(item)
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    
    dismiss(animated: true, completion: nil)
    saveChecklistItems()
  }
  
  // - done (finish editing)
  
  func itemDetailViewController(_ controller: ItemDetailViewController,
                                didFinishEditing item: ChecklistItem) {
    
    if let index = items.index(of: item) { // this method returns to us index of item(ChecklistItem) in items array
      
      let indexPath = IndexPath(row: index, section: 0)
      
      if let cell = tableView.cellForRow(at: indexPath) {
        configureText(for: cell, with: item)
      }
    }
    dismiss(animated: true, completion: nil)
    saveChecklistItems()
  }
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Tell object ItemDetailViewController that
  //                          ChecklistViewController is now its delegate ***
  //-----------------------------------------------------------------------------------------------
  //
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 1
    if segue.identifier == "AddItem" {
      // 2
      let navigationController = segue.destination as! UINavigationController
      
      // 3
      let controller = navigationController.topViewController as! ItemDetailViewController
      
      // 4
      controller.delegate = self
      
    } else if segue.identifier == "EditItem" {
      // 2
      let navigationController = segue.destination as! UINavigationController
      
      // 3
      let controller = navigationController.topViewController as! ItemDetailViewController
      
      // 4
      controller.delegate = self
      
      // 5
      if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
        controller.itemToEdit = items[indexPath.row]
      }
    }
  }
  
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Necessary controller's methods ***
  //-----------------------------------------------------------------------------------------------
  //
  override func viewDidLoad() {
    super.viewDidLoad()
    title = checklist.name
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  //-----------------------------------------------------------------------------------------------

  
  //-----------------------------------------------------------------------------------------------
  //                      *** caller is tableview; caller's request is numberOfRowsInSection; 
  //                          return how many rows in section ***
  //-----------------------------------------------------------------------------------------------
  //
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  //-----------------------------------------------------------------------------------------------
  //
  
  //-----------------------------------------------------------------------------------------------
  //                      *** caller is tableview; caller's request is cellForRowAt; 
  //                          return cell to display row ***
  //-----------------------------------------------------------------------------------------------
  //
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    
    let item = items[indexPath.row]
    
    configureText(for: cell, with: item)
    
    //before return the cell, spot that this has checkmark or not
    configureCheckmark(for: cell, with: item)
    return cell
  }
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** This method processes tap on the cell ***
  //-----------------------------------------------------------------------------------------------
  //
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    
    if let cell = tableView.cellForRow(at: indexPath){
      
      let item = items[indexPath.row]
      
      item.toggleChecked()
      
      configureCheckmark(for: cell, with: item)
    }
    tableView.deselectRow(at: indexPath, animated: true)
    saveChecklistItems()
  }
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** "swipe-to-delete" method ***
  //-----------------------------------------------------------------------------------------------
  //
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {
    // 1 (in data model)
    items.remove(at: indexPath.row)
    
    // 2 (in view)
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
    saveChecklistItems()
  }
  //-----------------------------------------------------------------------------------------------

  //-----------------------------------------------------------------------------------------------
  //                      *** My own function that determine row has or doesn't a checked
  //                          and then sets checkmark to cell which show current row ***
  //-----------------------------------------------------------------------------------------------
  //
  func configureCheckmark(for cell: UITableViewCell,
                          with item: ChecklistItem){
    
    let label = cell.viewWithTag(1001) as! UILabel
    
    if item.checked {
      label.text = "√"
    } else {
      label.text = ""
    }
  }
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** This sets text for cell's label 
  //                          from the ChecklistItem's text ***
  //-----------------------------------------------------------------------------------------------
  //
  func configureText(for cell: UITableViewCell,
                     with item: ChecklistItem){
    
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
  }
  //-----------------------------------------------------------------------------------------------

  //-----------------------------------------------------------------------------------------------
  //                      *** Saving data in Documets folder in device ***
  //-----------------------------------------------------------------------------------------------
  //
  // Get full path to the Documents folder
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory,
                                          in: .userDomainMask)
    return paths[0]
  }
  
  // Construct the full path to file that will store the checklist items
  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklists.plist")
  }
  
  // Take the contents of the "items" array and in two steps convert it to
  // a block of binary data and then write this data to a file
  func saveChecklistItems(){
    // 1. our data is placed in NSMutableData object, which will write itself
    // to file specified by dataFilePath()
    let data = NSMutableData()
    // 2. NSKeyedArchiver is form of NSCoder that creates plist files, encodes the array and
    // all the ChecklistItems in it into some sort of binary data format that can be written to a file.
    let archiver = NSKeyedArchiver(forWritingWith: data)
    // 3
    archiver.encode(items, forKey: "ChecklistItems")
    // 4
    archiver.finishEncoding()
    // 5
    data.write(to: dataFilePath(), atomically: true)
  }
  //-----------------------------------------------------------------------------------------------

  //-----------------------------------------------------------------------------------------------
  //                      *** Loading ChecklistItems s ***
  //-----------------------------------------------------------------------------------------------
  //
  func loadChecklistItems(){
    // 1
    let path = dataFilePath()
    // 2
    if let data = try? Data(contentsOf: path) {
      // 3
      let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
      items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
      
      unarchiver.finishDecoding()
    }
  }
  //-----------------------------------------------------------------------------------------------
}

//-----------------------------------------------------------------------------------------------
//                      ***  ***
//-----------------------------------------------------------------------------------------------
//

//-----------------------------------------------------------------------------------------------






























