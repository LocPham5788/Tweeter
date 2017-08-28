//
//  ShowAlertManager.swift
//  TweeterZalora
//
//  Created by Pham Tan Loc on 8/24/17.
//  Copyright © 2017 Pham Tan Loc. All rights reserved.
//

import Foundation
import UIKit

class ShowAlertManager: NSObject {
    
    /**
     Show error message in current present viewcontroller.
     
     - parameter presentedVC: Present viewcontroller, message: Text of error message.
     */
    static func showErrorMessageDialog(presentedVC: UIViewController, message: String) {
        let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancelAction)
        presentedVC.present(alert, animated: true, completion: nil)
    }
    
}
