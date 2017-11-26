//
//  ViewController.swift
//  ValueStepper
//
//  Created by Patrick Balestra on 02/18/2016.
//  Copyright (c) 2016 Patrick Balestra. All rights reserved.
//

import UIKit
import ValueStepper

class ViewController: UIViewController {

    @IBOutlet weak var stepper1: ValueStepper!
    @IBOutlet weak var stepper2: ValueStepper!
    @IBOutlet weak var stepper3: ValueStepper!
    @IBOutlet weak var stepper4: ValueStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Enabled a tap on the label to manually modify the value in a UIAlertController.
        stepper1.enableManualEditing = true

        // Set up currency number formatter.
        let moneyFormatter = NumberFormatter()
        moneyFormatter.numberStyle = .currency
        moneyFormatter.maximumFractionDigits = 0
        stepper3.numberFormatter = moneyFormatter
        
        stepper3.addTarget(self, action: #selector(ViewController.valueChanged3), for: .valueChanged)

        stepper4.tintColor = .white
        stepper4.disabledIconButtonColor = .white
        stepper4.disabledBackgroundButtonColor = UIColor(red: 43 / 255, green: 145 / 255, blue: 154 / 255, alpha: 1)
        stepper4.backgroundButtonColor = UIColor(red: 57 / 255, green: 193 / 255, blue: 204 / 255, alpha: 1)
        stepper4.highlightedBackgroundColor = UIColor(red: 43 / 255, green: 145 / 255, blue: 154 / 255, alpha: 1)
        stepper4.backgroundLabelColor = .clear
        stepper4.enableManualEditing = true
    }
    
    @IBAction func valueChanged1(_ sender: ValueStepper) {
        print("Stepper 1: \(sender.value)")
    }
    
    @IBAction func valueChanged2(_ sender: ValueStepper) {
        print("Stepper 2: \(sender.value)")
    }
    
    @objc func valueChanged3(_ sender: ValueStepper) {
        print("Stepper 3: \(sender.value)")
    }

    @IBAction func valueChanged4(_ sender: ValueStepper) {
        print("Stepper 4: \(sender.value)")
    }
}

