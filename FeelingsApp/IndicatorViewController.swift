//
//  IndicatorViewController.swift
//  FeelingsApp
//
//  Created by Denes Csizmadia on 2017. 03. 11..
//  Copyright © 2017. Denes Csizmadia. All rights reserved.
//

import UIKit
import KDCircularProgress
import SwiftSiriWaveformView
import CoreImage

class IndicatorViewController: UIViewController {
    
    @IBOutlet weak var faceImage: UIImageView!
    
    @IBOutlet weak var progressAn: KDCircularProgress!
    
    @IBOutlet weak var progressDi: KDCircularProgress!
    
    @IBOutlet weak var progressFe: KDCircularProgress!
    
    @IBOutlet weak var progressHa: KDCircularProgress!
    
    @IBOutlet weak var progressSa: KDCircularProgress!
    
    @IBOutlet weak var progressSu: KDCircularProgress!
    
    
    @IBOutlet weak var waveformView: SwiftSiriWaveformView!
    
    var timer:Timer?
    var change:CGFloat = 0.01

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeImage), name: Notification.Name("ChangeImage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeIndicators(_:)), name: NSNotification.Name(rawValue: "ChangeIndicators"), object: nil)
        
        
        self.waveformView.density = 1.0
        
        timer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(IndicatorViewController.refreshAudioView(_:)), userInfo: nil, repeats: true)
        
     
        
        
        
        let image = UIImage(named: "Dori.png")
        ImageProcessor.shared.detectFace(imageToDetect: image!)
        self.faceImage.layer.masksToBounds = true
        self.faceImage.layer.cornerRadius = faceImage.frame.size.width/3
        self.faceImage.layer.masksToBounds = true
        self.faceImage.image = ImageProcessor.shared.faceImage
        self.faceImage.fadeIn()
        
        
      //  WebService.PostImage(image: image!)
        
    }
    
    
    internal func refreshAudioView(_:Timer) {
        if self.waveformView.amplitude <= self.waveformView.idleAmplitude || self.waveformView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.waveformView.amplitude += self.change
    }
    
    
    
    func changeImage() {
        print("changeImage")
     //   self.faceImage.fadeOut()
      //  self.faceImage.alpha = 0.0
        //self.faceImage.image = ImageProcessor.shared.faceImage
        DispatchQueue.main.async(){
            self.faceImage.image = ImageProcessor.shared.faceViewImage
        }

        
      //  self.faceImage.fadeIn()
        
    }
    
    func changeIndicators(_ notification: NSNotification) {
        if let value = notification.userInfo?["an"] as? Double {
            progressAn.animate(toAngle: (value * 360), duration: 3) { completed in
                if completed {
                    print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
            }
        }
        
        if let value = notification.userInfo?["di"] as? Double {
            progressDi.animate(toAngle: (value * 360), duration: 3) { completed in
                if completed {
                    print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
            }
    }
        
        
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}

public extension UIView {
    
    /**
     Fade in a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeIn(withDuration duration: TimeInterval = 5.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 0.0
            })
        }

    
}



