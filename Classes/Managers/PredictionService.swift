//
//  PredictionService.swift
//  CoreMLDemo
//
//  Created by yusuf_kildan on 19/06/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit
import CoreML

class PredictionService {
    
    fileprivate var model = Inceptionv3()
    
    // MARK: - Singleton
    
     static let shared = PredictionService()
    
    // MARK: - Prediction Result
    
    func predict(_ image:UIImage) -> [PredictionResult]? {
        guard let buffer = image.convertToPixelBuffer() else {
            return nil
            
        }
        
        if let prediction = try? model.prediction(image: buffer) {
            return self.getPredictionResults(from: prediction)
        }
        
        return nil
    }
    
    func predict(_ input: CVPixelBuffer) -> [PredictionResult]? {
        if let prediction = try? model.prediction(image: input) {
            return self.getPredictionResults(from: prediction)
        }
        
        return nil
    }
    
    fileprivate func getPredictionResults(from output: Inceptionv3Output) -> [PredictionResult] {
        let sortedProbs = output.classLabelProbs.sorted(by: {$0.1 > $1.1})
        
        var predictions : [PredictionResult] = []
        for (key, value) in sortedProbs[0..<10] {
            
            predictions.append(PredictionResult(predictionText: key, predictionProbablity: value))
        }
        
        return predictions
    }
}

