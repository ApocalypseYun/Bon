//
//  BonAlert.swift
//  Bon
//
//  Created by Chris on 16/4/18.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit
import Foundation

class BonAlert {
    
    class func alert(title: String, message: String?, dismissTitle: String, inViewController viewController: UIViewController?, withDismissAction dismissAction: (() -> Void)?) {
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let action: UIAlertAction = UIAlertAction(title: dismissTitle, style: .default) { action -> Void in
                if let dismissAction = dismissAction {
                    dismissAction()
                }
            }
            alertController.addAction(action)
            
            viewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func alertSorry(message: String?, inViewController viewController: UIViewController?, withDismissAction dismissAction: @escaping () -> Void) {
        alert(title: NSLocalizedString("Sorry", comment: ""), message: message, dismissTitle: NSLocalizedString("OK", comment: ""), inViewController: viewController, withDismissAction: dismissAction)
    }
    
    class func alertSorry(message: String?, inViewController viewController: UIViewController?) {
        alert(title: NSLocalizedString("Sorry", comment: ""), message: message, dismissTitle: NSLocalizedString("OK", comment: ""), inViewController: viewController, withDismissAction: nil)
    }
    
    class func textInput(title: String, placeholder: String?, oldText: String?, dismissTitle: String, inViewController viewController: UIViewController?, withFinishedAction finishedAction: ((_ text: String) -> Void)?) {
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            
            alertController.addTextField { (textField) -> Void in
                textField.placeholder = placeholder
                textField.text = oldText
            }
            
            let action: UIAlertAction = UIAlertAction(title: dismissTitle, style: .default) { action -> Void in
                if let finishedAction = finishedAction {
                    if let textField = alertController.textFields?.first, let text = textField.text {
                        finishedAction(text)
                    }
                }
            }
            alertController.addAction(action)
            
            viewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func textInput(title: String, message: String?, placeholder: String?, oldText: String?, confirmTitle: String, cancelTitle: String, inViewController viewController: UIViewController?, withConfirmAction confirmAction: ((_ text: String) -> Void)?, cancelAction: (() -> Void)?) {
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertController.addTextField { (textField) -> Void in
                textField.placeholder = placeholder
                textField.text = oldText
            }
            
            let _cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { action -> Void in
                cancelAction?()
            }
            alertController.addAction(_cancelAction)
            
            let _confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .default) { action -> Void in
                if let textField = alertController.textFields?.first, let text = textField.text {
                    confirmAction?(text)
                }
            }
            alertController.addAction(_confirmAction)
            
            viewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func confirmOrCancel(title: String, message: String, confirmTitle: String, cancelTitle: String, inViewController viewController: UIViewController?, withConfirmAction confirmAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { action -> Void in
                cancelAction()
            }
            alertController.addAction(cancelAction)
            
            let confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .default) { action -> Void in
                confirmAction()
            }
            alertController.addAction(confirmAction)
            
            viewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
}
