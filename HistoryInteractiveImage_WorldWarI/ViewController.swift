//
//  ViewController.swift
//  HistoryInteractiveImage_WorldWarI
//
//  Created by Zheng on 2/26/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import SwiftEntryKit


class IndToken: NSObject {
   // var pointPlace = CGPoint(x: 0, y: 0)
    var desc = ""
    var baseView = UIView()
}
protocol ReturnNewList: class {
    func returnList()
}

class ViewController: UIViewController, ChangedText, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageBottom: NSLayoutConstraint!
    @IBOutlet weak var imageTop: NSLayoutConstraint!
    @IBOutlet weak var imageLeft: NSLayoutConstraint!
    @IBOutlet weak var imageRight: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    var effectView = UIVisualEffectView()
    
    
    @IBAction func aboutPressed(_ sender: Any) {
        
        let newView = UIView()
        newView.layer.cornerRadius = 16
        newView.clipsToBounds = true
        
        let newImageView = UIImageView()
        newImageView.image = UIImage(named: "bridge logo-1")
        
        newView.addSubview(newImageView)
        newImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        var attributes = EKAttributes.centerFloat
        attributes.positionConstraints.size.height = .constant(value: 750)
        attributes.positionConstraints.size.width = .constant(value: 750)
        attributes.entryInteraction = .absorbTouches
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
//        attributes.roundCorners = .all(radius: 20)
        
        attributes.lifecycleEvents.willDisappear = {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.effectView.alpha = 0
//            }) {
//
//            }
            UIView.animate(withDuration: 0.3, animations: {
                self.effectView.alpha = 0
            }) { _ in
                self.effectView.removeFromSuperview()
            }
           
        }
        SwiftEntryKit.display(entry: newView, using: attributes)
        
        view.addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.5) {
            self.effectView.alpha = 1
        }
        
    }
    
    @IBOutlet weak var editToggle: UISegmentedControl!
    
    var minScale = CGFloat(0)
    
    var editingMode = false
    var deleteMode = false
    
    @IBAction func editChanged(_ sender: Any) {
        switch editToggle.selectedSegmentIndex {
        case 0:
            print("view mode")
            editingMode = false
            deleteButton.isHidden = true
            newButton.isHidden = true
            deleteMode = false
            deleteButton.setTitle("Delete", for: .normal)
            
        case 1:
            print("edit mode")
            editingMode = true
            deleteMode = false
            deleteButton.isHidden = false
            newButton.isHidden = false
        default:
        print("wrong")
        }
    }
    @IBOutlet weak var newButton: UIButton!
    weak var returnListNow: ReturnNewList?
    
    @IBAction func newPressed(_ sender: Any) {
        saveTokens()
    }
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deletePressed(_ sender: Any) {
        //deleteMode = !deleteMode
        if deleteMode == false {
            deleteMode = true
            deleteButton.setTitle("Back to normal mode", for: .normal)
        } else {
            deleteMode = false
            deleteButton.setTitle("Delete", for: .normal)
        }
    }
    
    
    func changedText(newText: String, index: Int) {
        print("check")
        print(newText)
        arrayOfTokens[index].desc = newText
    }
    
    let realm = try! Realm()
    var arrayOfTokens = [IndToken]()
    var realmArray: Results<TokenModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        effectView.effect = blurEffect
        view.addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        effectView.alpha = 0
        populateTokens()
        editToggle.selectedSegmentIndex = 0
        deleteButton.isHidden = true
        newButton.isHidden = true
        //updateMinZoomScaleForSize(view.bounds.size)
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnce))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        editingMode = false
        deleteMode = false
    }
//    func sortLists() {
//        realmArray = realmArray!.sorted(byKeyPath: "indexP", ascending: false)
//    }
    func saveTokens() {
        
        do {
            try realm.write {
                realm.deleteAll()
            }  
        } catch {
            print("Error DELETING TOKENS \(error)")
        }
        
        for singleToken in arrayOfTokens {
            let newRToken = TokenModel()
            newRToken.x = Float(singleToken.baseView.frame.origin.x + 50)
            newRToken.y = Float(singleToken.baseView.frame.origin.y + 50)
            newRToken.text = singleToken.desc
            do {
                try realm.write {
                    realm.add(newRToken)
                }
            } catch {
                print("Error saving category \(error)")
            }
        }
    }
    func populateTokens() {
        realmArray = realm.objects(TokenModel.self)
        guard let realmA = realmArray else { print("REALM ERROR"); return }
        for singleR in realmA {
            print("realm")
            let newToken = IndToken()
            newToken.desc = singleR.text
            
            var newView = UIView()
            
            var newPoint = CGPoint(x: CGFloat(singleR.x), y: CGFloat(singleR.y))
            
            newPoint.x -= 50
            newPoint.y -= 50
        
            let theSize = CGSize(width: 100, height: 100)
            newView.frame = CGRect(origin: newPoint, size: theSize)
            
            newToken.baseView = newView
            imageView.addSubview(newView)
            
            let tokenImage = UIImageView()
            newView.addSubview(tokenImage)
            
            tokenImage.image = UIImage(named: "Token")
            tokenImage.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            arrayOfTokens.append(newToken)
            
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("dismiss")
        returnListNow?.returnList()
    }
    
    @objc func tappedOnce(gr: UITapGestureRecognizer) {

        let touchPoint = gr.location(in: imageView)
        print(touchPoint)
        var hitTokenYes = false
        var hitTokenIndex = -1
        var tokenView = UIView()
        
        for (index, indexMatch) in arrayOfTokens.enumerated() {
            print("frame: \(indexMatch.baseView.frame)")
            if indexMatch.baseView.frame.contains(touchPoint) {
                hitTokenYes = true
                tokenView = indexMatch.baseView
                hitTokenIndex = index
            }
        }
        
        if editingMode == true {
            if deleteMode == false {
                if hitTokenYes == false {
                    let _ = addToken(location: touchPoint)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let popController = storyboard.instantiateViewController(withIdentifier: "InputDescView") as! InputDescView
                    popController.modalPresentationStyle = UIModalPresentationStyle.popover
                    //popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
                    popController.popoverPresentationController?.delegate = self
                    popController.popoverPresentationController?.sourceView = tokenView
                    popController.popoverPresentationController?.sourceRect = tokenView.bounds
                    popController.editMode = true
                    popController.changeTextDel = self
                    
                    popController.textViewText = arrayOfTokens[hitTokenIndex].desc
                    
                    returnListNow = popController
                    popController.index = hitTokenIndex
                    
                    self.present(popController, animated: true, completion: nil)
                }
            } else {
                if hitTokenYes == true {
                    tokenView.removeFromSuperview()
                    arrayOfTokens.remove(at: hitTokenIndex)
                }
            }
        } else {
            if hitTokenYes == true {
                            
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let popController = storyboard.instantiateViewController(withIdentifier: "InputDescView") as! InputDescView
                popController.modalPresentationStyle = UIModalPresentationStyle.popover

                //popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
                popController.popoverPresentationController?.delegate = self
                popController.popoverPresentationController?.sourceView = tokenView
                popController.popoverPresentationController?.sourceRect = tokenView.bounds
                
                popController.editMode = false
                popController.textViewText = arrayOfTokens[hitTokenIndex].desc
                
                
                self.present(popController, animated: true, completion: nil)
            }
        }
        
    
        
        
//            let DynamicView = UIView(frame: CGRectMake(touchPoint.x, touchPoint.y, 100, 100))
//            DynamicView.backgroundColor=UIColor.greenColor()
//            DynamicView.layer.cornerRadius=25
//            DynamicView.layer.borderWidth=2
//            self.view.addSubview(DynamicView)

    }

    func addToken(location: CGPoint) -> UIView {
        var newToken = IndToken()
        var newView = UIView()
        
       // print(location)
        var newPoint = location
        newPoint.x -= 50
        newPoint.y -= 50
    
        //let transformedPoint = newPoint.convert
        let theSize = CGSize(width: 100, height: 100)
        newView.frame = CGRect(origin: newPoint, size: theSize)
//        let transformedPoint = newView.convert(newPoint, to: imageView)
       // print(transformedPoint)
        
        //newView.frame.origin = transformedPoint
        
        newToken.baseView = newView
        imageView.addSubview(newView)
        
        let tokenImage = UIImageView()
        newView.addSubview(tokenImage)
        
        tokenImage.image = UIImage(named: "Token")
        tokenImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        arrayOfTokens.append(newToken)
        
        return newView
    }
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
        //print("sub")
      updateMinZoomScaleForSize(view.bounds.size)
    }
    
    func updateMinZoomScaleForSize(_ size: CGSize) {
      let widthScale = size.width / imageView.bounds.width
      let heightScale = size.height / imageView.bounds.height
      minScale = min(widthScale, heightScale)
        
      scrollView.minimumZoomScale = minScale
        print("Min: \(minScale)")
      scrollView.zoomScale = minScale
        
    scrollView.maximumZoomScale = 2
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset
//        currentScrollPos = offset
//      //  print(offset)
//    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
       // print("aasdasd")
        updateConstraintsForSize(view.bounds.size)
       // sampleLabel.transform = CGAffineTransform(scaleX: 1/scrollView.zoomScale, y: 1/scrollView.zoomScale)
        for token in arrayOfTokens {
            //token.pointPlace = currentScrollPos
//            let xDiff = currentScrollPos.x - oldScrollPos.x
//            let yDiff = currentScrollPos.y - oldScrollPos.y
//
//            token.baseView.frame.origin.x -= xDiff
//            token.baseView.frame.origin.y -= yDiff
            //print("orig new scale: \(scrollView.zoomScale)")
            let newScale = (1 / scrollView.zoomScale) * minScale
            //print("newS: \(newScale)")
            token.baseView.transform = CGAffineTransform(scaleX: newScale, y: newScale)
        }
        
    }

    //2
    func updateConstraintsForSize(_ size: CGSize) {
      //3
      let yOffset = max(0, (size.height - imageView.frame.height) / 2)
      imageTop.constant = yOffset
      imageBottom.constant = yOffset

      //4
      let xOffset = max(0, (size.width - imageView.frame.width) / 2)
      imageRight.constant = xOffset
      imageLeft.constant = xOffset

      view.layoutIfNeeded()
    }

}
extension ViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
class NonResizeView: UIView {
    override var transform: CGAffineTransform {
        get { return super.transform }
        set {
            print("sdsdfsdf")
            super.transform = newValue
            for v in subviews {
                v.transform = self.transform.inverted()
            }
        }
    }
}
