//
//  InputView.swift
//  HistoryInteractiveImage_WorldWarI
//
//  Created by Zheng on 2/26/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit
protocol ChangedText: class {
    func changedText(newText: String, index: Int)
}
class InputDescView: UIViewController, UITextViewDelegate, ReturnNewList {
    
    
    
    
    var editMode = false
    var index = 0
    
    weak var changeTextDel: ChangedText?
    
    var textViewText = ""
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.isEditable = editMode
        
    }
    func returnList() {
        print("ret")
        changeTextDel?.changedText(newText: textViewText, index: index)
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//
//        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
//        //changed
//        changeTextDel?.changedText(newText: <#T##String#>, index: <#T##Int#>)
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? "Untitled"
        //        //changed
         changeTextDel?.changedText(newText: updatedString, index: index)
        return true
    }
}
