//
//  UserInfoViewController.swift
//  Bon
//
//  Created by Chris on 16/4/19.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var remainFluxImageView: UIImageView!
    
    let waveLoadingIndicator: WaveLoadingIndicator = WaveLoadingIndicator(frame: CGRectZero)
    
    override func viewDidLoad() {
        setWave()
    }
    
    // MARK: Get user balance, show it on another view
    
    func setWave() {
        
        remainFluxImageView.addSubview(waveLoadingIndicator)
        waveLoadingIndicator.frame = remainFluxImageView.bounds
        waveLoadingIndicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let remainFluxRate = BonUserDefaults.remainFluxRate
        waveLoadingIndicator.progress = remainFluxRate
    }
    
}
