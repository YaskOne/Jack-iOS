//
//  PickTimeViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 6/27/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

protocol TimePickerDelegate {
    func timePicked(date: Date)
}

class PickTimeViewController: APresentableViewController {

    var delegate: TimePickerDelegate?
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func validateTapped(_ sender: Any) {
        delegate?.timePicked(date: timePicker.date)
        dismiss(animated: true)
    }
    
}
