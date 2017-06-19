//
//  PredictionResult.swift
//  CoreMLDemo
//
//  Created by yusuf_kildan on 19/06/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit

class PredictionResult {
    var predictionText: String
    var predictionProbablity: Double
    
    // MARK: - Constructors
    
    init(predictionText: String, predictionProbablity: Double) {
        self.predictionText = predictionText
        self.predictionProbablity = predictionProbablity
    }
}

