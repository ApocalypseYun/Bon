//
//  UserInfoViewController.swift
//  Bon
//
//  Created by Chris on 16/4/19.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit

class RemaingDataRateViewController: UIViewController {
    
    @IBOutlet weak var remainingDataRateImageView: UIImageView!
    
    let waveLoadingIndicator: WaveLoadingIndicator = WaveLoadingIndicator(frame: CGRectZero)
    
    override func viewDidLoad() {
        setWave()
    }
    
    // MARK: Get user balance, show it on another view
    
    func setWave() {
        
        remainingDataRateImageView.addSubview(waveLoadingIndicator)
        waveLoadingIndicator.frame = remainingDataRateImageView.bounds
        waveLoadingIndicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let remainingDataRate = BonUserDefaults.balance / 10
        waveLoadingIndicator.progress = remainingDataRate
    }
    
}
