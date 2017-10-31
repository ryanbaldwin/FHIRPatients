//
//  EditPatientViewController+Interaction.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-08.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

extension EditPatientViewController {
    /// MARK: Controller navigationItem buttons
    @objc func cancelEditButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func doneEditButtonTapped(_ sender: UIBarButtonItem) {
        model.save()
        dismiss(animated: true)
    }
    
    /// MARK: Gender Control
    
    @IBAction func genderValueChanged(_ sender: UISegmentedControl) {
        model.gender = PatientModel.Gender(rawValue: sender.selectedSegmentIndex)
    }
    
    /// MARK: DatePicker
    func updateBirthdateTextField(_ date: Date) {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateStyle = .long
        birthdateTextField.text = formatter.string(from: date)
    }
    
    @IBAction func datePickerEditingDidBeging(_ sender: UIDatePicker) {
        updateBirthdateTextField(sender.date)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateBirthdateTextField(sender.date)
    }
    
    @IBAction func dateDoneTapped(_ sender: UIBarButtonItem) {
        updateBirthdateTextField(datePicker.date)
        model.dateOfBirth = datePicker.date
        birthdateTextField.resignFirstResponder()
    }
    
    @IBAction func dateCancelTapped(_ sender: UIBarButtonItem) {
        birthdateTextField.resignFirstResponder()
    }
    
    /// MARK: Textfields
    
    @IBAction func givenNameEditingChanged(_ sender: UITextField) {
        model.givenName = sender.text
    }
    
    @IBAction func familyNameEditingChanged(_ sender: UnderlinedTextField) {
        model.familyName = sender.text
    }
    
    @IBAction func addPhotoTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(makeTakePhotoAction())
        alertController.addAction(makeChoosePhotoAction())
        alertController.addAction(makeCancelPhotoAction())
        present(alertController, animated: true)
    }
    
    @IBAction func editPhotoTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(makeTakePhotoAction())
        alertController.addAction(makeChoosePhotoAction())
        alertController.addAction(makeDeletePhotoAction())
        alertController.addAction(makeCancelPhotoAction())
        present(alertController, animated: true)
    }
}

extension EditPatientViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    fileprivate func makeTakePhotoAction() -> UIAlertAction {
        return UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return
            }
            
            self.present(self.camera, animated: true)
        }
    }
    
    fileprivate func makeChoosePhotoAction() -> UIAlertAction {
        return UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.present(self.imagePicker, animated: true)
        }
    }
    
    fileprivate func makeDeletePhotoAction() -> UIAlertAction {
        return UIAlertAction(title: "Delete Photo", style: .destructive) { [unowned self] _ in
            self.model.image = nil
            self.bindImage(animated: true)
        }
    }
    
    fileprivate func makeCancelPhotoAction() -> UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            model.image = scale(image, toWidth: UIScreen.main.bounds.width)
            dismiss(animated: true) { [unowned self] in
                self.bindImage(animated: true)
            }
        }
    }
    
    private func scale(_ image: UIImage, toWidth newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let scaledWidth = newWidth
        let scaledHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: scaledWidth, height: scaledHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension EditPatientViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
