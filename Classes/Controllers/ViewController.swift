//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by yusuf_kildan on 19/06/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var imagePicker: UIImagePickerController!
    fileprivate var predictions: [PredictionResult]! = []
    
    // MARK: - View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(didTapImageView(_:))))
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if let predictions = PredictionService.shared.predict(imageView.image!) {
            self.predictions = predictions
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapImageView(_ recognizer: UITapGestureRecognizer) {
        presentPhotoSourceSelection()
    }
    
    @IBAction func barButtonItemTapped(_ sender: UIBarButtonItem) {
        presentPhotoSourceSelection()
    }
    
    // MARK: - Source Selection
    
    func presentPhotoSourceSelection() {
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Choose From Library",
                                                style: UIAlertActionStyle.default,
                                                handler: { (_) in
                                                    self.presentImagePicker()
        }))
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            alertController.addAction(UIAlertAction(title: "Capture Photo",
                                                    style: UIAlertActionStyle.default,
                                                    handler: { (_) in
                                                        self.presentCamera()
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: UIAlertActionStyle.cancel,
                                                handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentImagePicker() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func presentCamera() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Configure Cell
    
    fileprivate func configure(TableViewCell cell: UITableViewCell, withIndexPath indexPath: IndexPath) {
        if indexPath.row >= predictions.count {
            return
        }
        
        let prediction = predictions[indexPath.row]
        
        cell.textLabel?.text = prediction.predictionText
        cell.detailTextLabel?.text = String(format: "%.02f",prediction.predictionProbablity)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        configure(TableViewCell: cell, withIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Results"
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        guard let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }
        
        imageView.image = chosenImage
        
        if let predictions = PredictionService.shared.predict(chosenImage.convertToPixelBuffer()!) {
            self.predictions = predictions
            self.tableView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


