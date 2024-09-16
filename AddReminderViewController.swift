//
//  AddReminderViewController.swift
//  Reminders
//
//  Created by Calwin on 10/09/24.
//

import UIKit

class AddReminderViewController: UIViewController,UITextFieldDelegate {
    
    public var completion: ((String, String, Date)->Void)?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate=self
        bodyTextField.delegate=self
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(addBtnPressed))
        dateField.preferredDatePickerStyle = .wheels
        dateField.datePickerMode = .dateAndTime
    }
    
    @objc func addBtnPressed() {
        if let title=titleTextField.text,
           let body=bodyTextField.text{
            let date = dateField.date
            completion?(title, body, date)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
