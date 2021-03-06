//
//  newItemVC.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/23/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit

///A View Controller that Manages the New Item View
class NewItemVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    let dataManager: FirebaseDataManager = FirebaseDataManager()
    var keyboardHandler : KeyboardHandler!
    
    @IBOutlet var itemNameField: UITextField!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var descField: UITextView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    var imageAdded: Bool = false;
    
    
    /**
     Opens Camera on tap

     - parameters:
     - sender: the object reference of the Button that called this function
 
     */
    @IBAction func addImgBtn(_ sender: Any) {
        openCamera()
    }
    
    /**
     creates a object of the sale item and uploads it to Firebase Database & Firebase Storage for image
     
     - parameters:
         - sender: the object reference of the Button that called this function
     */
    @IBAction func uploadItemBtn(_ sender: Any) {
        createAndUpload()
    }
    
    /**
     opens a camera view over the current view
     
     */
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    /**
     assigns the Image taking within the UIImagePickerController to a ImageView
     
     - parameters:
         -picker:   The controller object managing the image picker interface
         -info:     A dictionary containing the original image and the edited image, if an       image was picked; or a filesystem URL for the movie, if a movie was picked.
                    The dictionary also contains any relevant editing information. The keys for this dictionary are listed in Editing Information Keys.
     
     */
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        itemImageView.image = UIImage(data: (image .jpeg(.low))!)
        imageAdded = true;
        dismiss(animated:true, completion: nil)
                
    }
    
    /**
     Checks all fields within the NewItemVC is fulfilled. this function assists the createAndUpload function
     
     - Returns
         isCompleted: true if all fields have information editted by user
     */
    private func checkAllFieldsCompleted() -> Bool{
        var isCompleted = false;
        if(itemNameField.text!.characters.count > 0){
            if(descField.text!.characters.count > 0){
                if(priceField.text!.characters.count > 0){
                    if(imageAdded){
                        isCompleted = true;
                    }
                }
            }
        }
        return isCompleted
    }
    
    /**
     Description: Creates a SaleItem Object using the fields within the New Item View
     
     - Returns
         SaleItem: representation of the users inputted values
     */
    private func createNewItemObj() -> SaleItem {
        let newItem: SaleItem = SaleItem()
        if(checkAllFieldsCompleted()){
            newItem.category = "All"
            newItem.description = descField.text
            newItem.image =  itemImageView.image
            newItem.price = priceField.text
            newItem.name = itemNameField.text
        }
        return newItem
    }
    
    /**
     creates a sale item object and uploads it to Firebase database & storage
     */
    private func createAndUpload(){
        let newItem: SaleItem = createNewItemObj()
        dataManager.uploadSaleItemToAll(saleItem: newItem)
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action : #selector(didTapView(gesture:)))  
        view.addGestureRecognizer(tapGesture)
        keyboardHandler = KeyboardHandler.init(view: self)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler.addObservers()
     }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler.removeObservers()
    }

    
}







