//
//  HomeViewController.swift
//  MatchUpApp
//
//  Created by Tianhui Zhou on 8/23/20.
//  Copyright © 2020 Tianhui Zhou. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBAction func startGame(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SecondViewSegue", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

