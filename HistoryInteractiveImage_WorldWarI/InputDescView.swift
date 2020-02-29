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
        textView.text = textViewText
        textView.isEditable = editMode
        view.backgroundColor = UIColor.clear
//        view.layer.cornerRadius = 12
        
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) ?? "Untitled"
        textViewText = updatedString
        
        return true
    }
//    func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let updatedString = (textView.text as NSString?)?.replacingCharacters(in: range, with: string) ?? "Untitled"
//        //        //changed
//
//        print("update")
//
//        textViewText = updatedString
//        // changeTextDel?.changedText(newText: updatedString, index: index)
//        return true
//    }
}
