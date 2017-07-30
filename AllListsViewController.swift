//
//  AllListsViewController.swift
//  TestRIK
//
//  Created by macbook air on 28/07/2017.
//  Copyright © 2017 Lytkin Artem. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController,
                              ListDetailViewControllerDelegate {
  //-----------------------------------------------------------------------------------------------
  //                      *** data model ***
  //-----------------------------------------------------------------------------------------------
  //
  var lists: Array<Checklist>
  
  required init?(coder aDecoder: NSCoder) {
    // 1
    lists = [Checklist]()
    
    // 2
    super.init(coder: aDecoder)
    
    // 3
    var list = Checklist(name: "Английский")
    lists.append(list)
    
    list = Checklist(name: "iOS")
    lists.append(list)
    
    list = Checklist(name: "Планирование")
    lists.append(list)
    
    list = Checklist(name: "Здоровье")
    lists.append(list)
  }
  //-----------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    return lists.count
    }

  //-----------------------------------------------------------------------------------------------
  //                      *** Create cell for tableView ***
  //-----------------------------------------------------------------------------------------------
  //
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = makeCell(for: tableView)
    
    // Configure the cell...
    
    let checklist = lists[indexPath.row]
    cell.textLabel!.text = checklist.name
    cell.accessoryType = .detailDisclosureButton
    
    return cell
  }
  
  func makeCell(for: UITableView) -> UITableViewCell {
    let cellIdentifier = "Cell"
    
    if let cell =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
      
      return cell
    
    } else {
      
      return UITableViewCell(style: .default,
                             reuseIdentifier: cellIdentifier)
    }
  }
  
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Show check list when row is tapped ***
  //-----------------------------------------------------------------------------------------------
  //
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    
    let checklist = lists[indexPath.row]
    performSegue(withIdentifier: "ShowChecklist", sender: checklist)
  }
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Prepare-for-segue ***
  //-----------------------------------------------------------------------------------------------
  //
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "ShowChecklist" {
      
      let controller = segue.destination as! ChecklistViewController
      controller.checklist = sender as! Checklist
      
    } else if segue.identifier == "AddChecklist" {
      
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! ListDetailViewController
      
      controller.delegate = self
      controller.checklistToEdit = nil
    }
  }
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Implementation of ItemDetailViewControllerDelegate methods ***
  //-----------------------------------------------------------------------------------------------
  //
  // - cancel
  
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  // - done (finish adding)
  
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishAdding checklist: Checklist) {
    
    let newRowIndex = lists.count
    lists.append(checklist)
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    
    dismiss(animated: true, completion: nil)
    //saveChecklistItems()
  }
  
  // - done (finish editing)
  
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishEditing checklist: Checklist) {
    
    if let index = lists.index(of: checklist) { // this method returns to us index of list(Checklist) in lists array
      
      let indexPath = IndexPath(row: index, section: 0)
      
      if let cell = tableView.cellForRow(at: indexPath) {
        cell.textLabel!.text = checklist.name
      }
    }
    dismiss(animated: true, completion: nil)
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
    lists.remove(at: indexPath.row)
    
    // 2 (in view)
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
  //-----------------------------------------------------------------------------------------------

  //-----------------------------------------------------------------------------------------------
  //                      *** to edit checklist ***
  //-----------------------------------------------------------------------------------------------
  //
  override func tableView(_ tableView: UITableView,
                          accessoryButtonTappedForRowWith indexPath: IndexPath) {
    
    let navigationController = storyboard!.instantiateViewController(
                                            withIdentifier: "ListDetailNavigationController")
                                                as! UINavigationController
    
    let controller = navigationController.topViewController as! ListDetailViewController
    
    controller.delegate = self
    
    let checklist = lists[indexPath.row]
    controller.checklistToEdit = checklist
    
    present(navigationController, animated: true, completion: nil)
  }
  //-----------------------------------------------------------------------------------------------
}
//-----------------------------------------------------------------------------------------------
//                      ***  ***
//-----------------------------------------------------------------------------------------------
//

//-----------------------------------------------------------------------------------------------
