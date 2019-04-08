//
//  UIViewController+Extension.swift
//  MyMovies
//
///  Created by MAC Consultant on 04/01/19.
//  Copyright © 2019 Aldo. All rights reserved.
//

import UIKit

extension UIViewController {
    //Show an alert to user before leave loggin out
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
       
        TheDBUser.logout { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Leaving MyMovies App", message: "Are you sure you want to log out?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true)
                    
                    
                }
                
            }
        }
    }
    
}
