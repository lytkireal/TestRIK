//
//  ListDetailViewController.swift
//  TestRIK
//
//  Created by macbook air on 30/07/2017.
//  Copyright © 2017 Lytkin Artem. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
  
  func listDetailViewControllerDidCancel(_
    controller: ListDetailViewController)
  
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishAdding checklist: Checklist)
  
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishEditing checklist: Checklist)
}


class ListDetailViewController: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  weak var delegate: ListDetailViewControllerDelegate?
  
  var checklistToEdit: Checklist?
  
  //-----------------------------------------------------------------------------------------------
  //                      *** View did load method ***
  //-----------------------------------------------------------------------------------------------
  //
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    if let checklist = checklistToEdit {
      title = "Edit Checklist"
      textField.text = checklist.name
      doneBarButton.isEnabled = true
    }
  }

  //-----------------------------------------------------------------------------------------------
  //                      *** giving control focus before scene comes visible (keyboard)***
  //-----------------------------------------------------------------------------------------------
  //
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Done button ***
  //-----------------------------------------------------------------------------------------------
  //
  @IBAction func done(){
    if let checklist = checklistToEdit {
      checklist.name = textField.text!
      delegate?.listDetailViewController(self,
                                         didFinishEditing: checklist)
      
    } else {
      let checklist = Checklist(name: textField.text!)
      delegate?.listDetailViewController(self, didFinishAdding: checklist)
    }
  }
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Cancel button ***
  //-----------------------------------------------------------------------------------------------
  //
  @IBAction func cancel(){
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  //-----------------------------------------------------------------------------------------------
  //                      *** user can not select the table cell with the text field ***
  //-----------------------------------------------------------------------------------------------
  //
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
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
}
