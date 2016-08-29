//
//  GameViewController.swift
//  Archer Run
//
//  Created by Carlos Diez on 6/28/16.
//  Copyright (c) 2016 Carlos Diez. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, MPAdViewDelegate {
    
    var adView: MPAdView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(GameViewController.loadAds),
            name: "loadAds",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(GameViewController.removeAdsOnGameOver),
            name: "removeAds",
            object: nil)
        
        if let scene = StartScene(fileNamed:"StartScene") {
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .Fill
            
            skView.presentScene(scene)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func loadAds() {
        adView = MPAdView(adUnitId: "7a7cbbb929f843049d76cabc6bffc802", size: MOPUB_BANNER_SIZE)
        adView.delegate = self
        adView.frame = CGRectMake((view!.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2,
                                  view!.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                  MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
        view!.addSubview(adView)
        adView.hidden = true
        adView.loadAd()
    }
    
    func adViewDidLoadAd(view: MPAdView!) {
        //show ad
        adView.hidden = false
    }
    
    func adViewDidFailToLoadAd(view: MPAdView!) {
        //hide ad
        adView.hidden = true
    }
    
    func removeAdsOnGameOver() {
        if let _ = adView.superview {
            adView.stopAutomaticallyRefreshingContents()
            adView.removeFromSuperview()
        }
    }
    
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
    func willPresentModalViewForAd(view: MPAdView!) {
        //Pause game
        NSNotificationCenter.defaultCenter().postNotificationName("pauseGame", object: nil)
    }
}
