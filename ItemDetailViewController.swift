//
//  ItemDetailViewController.swift
//  TestRIK
//
//  Created by macbook air on 18/07/2017.
//  Copyright © 2017 Lytkin Artem. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func itemDetailViewController(_ controller: ItemDetailViewController,
                             didFinishAdding item: ChecklistItem)
  func itemDetailViewController(_ controller: ItemDetailViewController,
                             didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

  weak var delegate: ItemDetailViewControllerDelegate?
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Get text from Text Field ***
  //-----------------------------------------------------------------------------------------------
  //
  @IBOutlet weak var textField: UITextField!
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Done bar button outlet ***
  //-----------------------------------------------------------------------------------------------
  //
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  //-----------------------------------------------------------------------------------------------
  
  // itemToEdit is optional version of ChecklistItem
  var itemToEdit: ChecklistItem?
  
  //-----------------------------------------------------------------------------------------------
  //                      *** if you tap on disclosure button ***
  //-----------------------------------------------------------------------------------------------
  //
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let item = itemToEdit {
      // item now contains the unwrapped value
      // of optional variable
      doneBarButton.isEnabled = true
      title = "Редактировать задачу"
      textField.text = item.text
      
    }
  }
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** user can not select the table cell with the text field ***
  //-----------------------------------------------------------------------------------------------
  //
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** giving control focus before scene comes visible (keyboard)***
  //-----------------------------------------------------------------------------------------------
  //
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  //-----------------------------------------------------------------------------------------------
  

  //-----------------------------------------------------------------------------------------------
  //                      *** Enable or disable the Done button 
  //                          dependging on whether the text field is empty or not ***
  //-----------------------------------------------------------------------------------------------
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    let oldText = textField.text! as NSString
    let newText = oldText.replacingCharacters(in: range, with: string) as NSString
    
    doneBarButton.isEnabled = (newText.length > 0)
    return true
  }
  //----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Done button ***
  //-----------------------------------------------------------------------------------------------
  //
  @IBAction func done(){
    if let item = itemToEdit {
      item.text = textField.text!
      delegate?.itemDetailViewController(self, didFinishEditing: item)
      
    } else {
      let item = ChecklistItem()
      item.text = textField.text!
      item.checked = false
    
      delegate?.itemDetailViewController(self, didFinishAdding: item)
    }
  }
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Cancel button ***
  //-----------------------------------------------------------------------------------------------
  //
  @IBAction func cancel(){
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  //-----------------------------------------------------------------------------------------------
  
  
  
}
