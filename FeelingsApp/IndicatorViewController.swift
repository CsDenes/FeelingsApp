//
//  IndicatorViewController.swift
//  FeelingsApp
//
//  Created by Denes Csizmadia on 2017. 03. 11..
//  Copyright © 2017. Denes Csizmadia. All rights reserved.
//

import UIKit
import KDCircularProgress

class IndicatorViewController: UIViewController {
    
    
    @IBOutlet var progressHa: KDCircularProgress!

    @IBOutlet weak var testLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = "Happy"
        
        progressHa.animate(fromAngle: 0, toAngle: 240, duration: 5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
