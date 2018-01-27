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
import AudioKit


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
    
    
    //audio
    var audioTimer = Timer()
    let microphone = AKMicrophone()
    var tracker: AKAmplitudeTracker?
    var silence: AKBooster?
    let minimum: Double = 60
    let maximum: Double = 560

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //audio
        tracker = AKAmplitudeTracker(microphone)
        silence = AKBooster(tracker!, gain: 0)


        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeImage), name: Notification.Name("ChangeImage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeIndicators(_:)), name: NSNotification.Name(rawValue: "ChangeIndicators"), object: nil)
        
        
        self.waveformView.density = 1.0
        
       // timer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(IndicatorViewController.refreshAudioView(_:)), userInfo: nil, repeats: true)
        
     
        
        
        
//        let image = UIImage(named: "test.jpg")
//        ImageProcessor.shared.detectFace(imageToDetect: image!)
        self.faceImage.layer.masksToBounds = true
        self.faceImage.layer.cornerRadius = faceImage.frame.size.width/3
        self.faceImage.layer.masksToBounds = true
        self.faceImage.image = ImageProcessor.shared.faceImage
        self.faceImage.fadeIn()
//        
        
      //  setIndicators()
        
        
      //  WebService.PostImage(image: image!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        audioTimer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(IndicatorViewController.measure(_:)), userInfo: nil, repeats: true)
        AudioKit.output = silence
        AudioKit.start()
        microphone.start()
        tracker?.start()
    }
    
    
    
    
    
    internal func refreshAudioView(_:Timer) {
        if self.waveformView.amplitude <= self.waveformView.idleAmplitude || self.waveformView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.waveformView.amplitude += self.change
    }
    
    
    internal func measure(_:Timer) {
        if let amplitude = tracker?.amplitude {
        self.waveformView.amplitude = CGFloat(amplitude*10)
        }
    }
    
    
    
    
    
    
    func changeImage() {
        print("changeImage")

        DispatchQueue.main.async(){
            self.faceImage.fadeOut()
            self.faceImage.image = ImageProcessor.shared.faceViewImage
            self.faceImage.fadeIn()
        }

    }
    
    func changeIndicators(_ notification: NSNotification) {
        DispatchQueue.main.async(){
        if let value = notification.userInfo?["an"] as? Double {
            self.progressAn.animate(toAngle: (value * 360), duration: 1) { completed in
                if completed {
                    print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
            }
        }
        }
        
        DispatchQueue.main.async(){
        if let value = notification.userInfo?["di"] as? Double {
            self.progressDi.animate(toAngle: (value * 360), duration: 1) { completed in
                if completed {
                    print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
            }
    }
        }
        
        DispatchQueue.main.async(){
        if let value = notification.userInfo?["fe"] as? Double {
            self.progressFe.animate(toAngle: (value * 360), duration: 1) { completed in
                if completed {
                    print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
            }
        }
        }
        
        DispatchQueue.main.async(){
        if let value = notification.userInfo?["ha"] as? Double {
            self.progressHa.animate(toAngle: (value * 360), duration: 1) { completed in
                if completed {
                    print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
            }
        }
        }
        
        DispatchQueue.main.async(){
        if let value = notification.userInfo?["sa"] as? Double {
            self.progressSa.animate(toAngle: (value * 360), duration: 1) { completed in
                if completed {
                    print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
            }
        }
        }
        
        DispatchQueue.main.async(){
        if let value = notification.userInfo?["su"] as? Double {
            self.progressSu.animate(toAngle: (value * 360), duration: 1) { completed in
                if completed {
                    print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
            }
        }
    }
    }
    
    
    func setIndicators() {
        progressAn.animate(toAngle: 0, duration: 1, completion: nil)
        progressDi.animate(toAngle: 0, duration: 1, completion: nil)
        progressFe.animate(toAngle: 0, duration: 1, completion: nil)
        progressHa.animate(toAngle: 0, duration: 1, completion: nil)
        progressSa.animate(toAngle: 0, duration: 1, completion: nil)
        progressSu.animate(toAngle: 0, duration: 1, completion: nil)
    
        
        
        
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
    func fadeIn(withDuration duration: TimeInterval = 2.0) {
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



