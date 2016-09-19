//
//  UsedDataRateViewController.swift
//  Bon
//
//  Created by Chris on 16/4/19.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit

class UsedDataRateViewController: UIViewController {
    
    @IBOutlet weak var usedDataRateImageView: UIImageView!
    
    @IBOutlet weak var usedDataLabel: UILabel!
    let waveLoadingIndicator: WaveLoadingIndicator = WaveLoadingIndicator(frame: CGRect.zero)
    
    override func viewDidLoad() {
        //view.backgroundColor = UIColor.whiteColor()
        setWave()
    }
    
    var usedData: Double = 0.0 {
        didSet {
            usedDataLabel.text = BonFormat.formatData(usedData)
            usedData = usedData / (1024 * 1024 * 1024)
        }
    }
    
    var balance: Double = 0.0
    // MARK: Get user balance, show it on another view
    
    func setWave() {
        
        usedDataRateImageView.addSubview(waveLoadingIndicator)
        waveLoadingIndicator.frame = usedDataRateImageView.bounds
        waveLoadingIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        usedData = BonUserDefaults.usedData
        balance = BonUserDefaults.balance
        
        let usedDataRate = usedData / balance
        waveLoadingIndicator.progress = usedDataRate <= 1 ? usedDataRate : 1
        
    }
    
}
