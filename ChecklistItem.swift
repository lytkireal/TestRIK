//
//  ChecklistItem.swift
//  TestRIK
//
//  Created by macbook air on 13/07/2017.
//  Copyright © 2017 Lytkin Artem. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
  
  // it is used to restore "ChecklistItem"s that were saved to disk
  required init?(coder aDecoder: NSCoder) {
    // "?" is for when init? can potentially fail and return a nil value instead of a real object.
    
    text = aDecoder.decodeObject(forKey: "Text") as! String
    checked = aDecoder.decodeBool(forKey: "Checked")
    super.init()
  }
  
  // It doesn't do anything useful, but it keeps the compiler happy.
  override init(){
    // Put values into your instance variables and constants.
    checked = false
    
    super.init() // this method to initialize this object's superclass. 
    
    // Other initialization code, such as calling methods, goes here.
  }
  
  var text = ""
  var checked: Bool
  
  func toggleChecked(){
    checked = !checked
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(text, forKey: "Text")
    aCoder.encode(checked, forKey: "Checked")
  }

}
