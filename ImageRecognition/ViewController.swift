//
//  ViewController.swift
//  ImageRecognition
//
//  Created by Ashish Ashish on 12/5/19.
//  Copyright © 2019 Ashish Ashish. All rights reserved.
//

import UIKit
import CoreML
import Vision



class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var lblImage: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let modelMobileVnet = MobileNetV2().model
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //imgView.contentMode = .scaleToFill
            imageView.image = pickedImage
            
            guard let ciimage = CIImage(image: pickedImage) else {
                return;
            }
            
            getPrediction(image: ciimage)
            
            
            
        }
        picker.dismiss(animated: true, completion: nil)
        
        
    
    }
    
    func getPrediction(image : CIImage){
        guard let model = try? VNCoreMLModel(for: modelMobileVnet) else {return;}
        
        let request = VNCoreMLRequest(model: model){ (request, error ) in
            
            guard let result = request.results as? [VNClassificationObservation] else { return;}
            
            print(result)
            
            if let first = result.first{
                self.lblImage.text = String("\(first.identifier) \(first.confidence)")
            }
        }
        
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch{
            print(error)
        }
        
    }


    @IBAction func takeAPic(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
//        let imagePicker = UIImagePickerController()
//
//        imagePicker.delegate = self
//
//        let actionScript = UIAlertController(title: "Select Source of Image", message: "Photo Source", preferredStyle: .actionSheet)
//
//        actionScript.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
//
//            if( UIImagePickerController.isSourceTypeAvailable(.camera)){
//
//                imagePicker.sourceType = .camera
//                self.present(imagePicker, animated: true, completion: nil)
//            }
//        }))
//
//        actionScript.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
//
//            if( UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
//
//                imagePicker.sourceType = .photoLibrary
//                self.present(imagePicker, animated: true, completion: nil)
//            }
//        }))
//
//        actionScript.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.present(actionScript, animated: true, completion: nil)
        
        
        
    }
}

