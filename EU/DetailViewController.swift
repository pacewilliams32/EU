//
//  DetailViewController.swift
//  EU
//
//  Created by Pace Williams on 2/16/22.
//

import UIKit

class DetailViewController: UITableViewController {

    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var capitalField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    

}
