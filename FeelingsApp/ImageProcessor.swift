//
//  ImageProcessor.swift
//  FeelingsApp
//
//  Created by Denes Csizmadia on 2017. 03. 27..
//  Copyright © 2017. Denes Csizmadia. All rights reserved.
//

import Foundation
import UIKit

class ImageProcessor {
    static let shared = ImageProcessor()
    var faceImage : UIImage?
    var blackAndWhiteImage : UIImage?
    var faceViewImage : UIImage?
    

    
    
    func blackAndWhiteImage(image: UIImage) -> UIImage{
        let context = CIContext(options: nil)
        let ciImage = CoreImage.CIImage(image: image)!
        
        // Set image color to b/w
        let bwFilter = CIFilter(name: "CIColorControls")!
        bwFilter.setValuesForKeys([kCIInputImageKey:ciImage, kCIInputBrightnessKey:NSNumber(value: 0.0), kCIInputContrastKey:NSNumber(value: 1.1), kCIInputSaturationKey:NSNumber(value: 0.0)])
        let bwFilterOutput = (bwFilter.outputImage)!
        
        // Adjust exposure
        let exposureFilter = CIFilter(name: "CIExposureAdjust")!
        exposureFilter.setValuesForKeys([kCIInputImageKey:bwFilterOutput, kCIInputEVKey:NSNumber(value: 0.7)])
        let exposureFilterOutput = (exposureFilter.outputImage)!
        
        // Create UIImage from context
        let bwCGIImage = context.createCGImage(exposureFilterOutput, from: ciImage.extent)
        let resultImage = UIImage(cgImage: bwCGIImage!, scale: 1.0, orientation: image.imageOrientation)
        blackAndWhiteImage = resultImage
        return resultImage
    
        }

    
    func detectFace(imageToDetect: UIImage){
        
        let Rotatedimage = imageRotatedByDegrees(oldImage: imageToDetect, deg: 90)
        var image = Rotatedimage
        
        
        guard let personciImage = CIImage(image: image) else {
            return
        }
        

        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        
        if (faces?.count)! > 0 {
        if let face = faces?[0]{
            image = cropImage(imageToCrop: Rotatedimage, toRect: (face.bounds))
        }
                self.faceViewImage = image
        
        image = resizeImage(image: image, size: 299)!
        
            
        //test
            let dict = ["an": 1, "di": 1, "fe": 1, "ha": 1, "sa": 1, "su": 1]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeIndicators"), object: nil, userInfo: dict)
            
            
        }
        
        self.blackAndWhiteImage = blackAndWhiteImage(image: image)
        
        self.faceImage = image
      
       
        
    }
    
    
    func cropImage(imageToCrop:UIImage, toRect rect:CGRect) -> UIImage{
        
        let imageRef:CGImage = imageToCrop.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
    }
    
    func resizeImage(image: UIImage, size: CGFloat) -> UIImage? {
        
        let scale = size / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: size, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: size, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat(M_PI / 180))
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat(M_PI / 180)))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    
    
}
