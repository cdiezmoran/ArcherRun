//
//  GameViewController.swift
//  Archer Run
//
//  Created by Carlos Diez on 6/28/16.
//  Copyright (c) 2016 Carlos Diez. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController, MPAdViewDelegate, GADRewardBasedVideoAdDelegate {
    
    var adView: MPAdView!
    var interstitial: GADInterstitial!

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
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(GameViewController.showInterstitial),
            name: "showInterstitial",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(GameViewController.showRewardVideoAd),
            name: "showRewardVideo",
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
        //Banner ad from mopub
        adView = MPAdView(adUnitId: "7a7cbbb929f843049d76cabc6bffc802", size: MOPUB_BANNER_SIZE)
        adView.delegate = self
        adView.frame = CGRectMake((view!.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2,
                                  view!.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                  MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
        view!.addSubview(adView)
        adView.hidden = true
        adView.loadAd()
        
        //Interstitial from admob
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1607117345046468/5914009238")
        //interstitial.delegate = self
        let request = GADRequest()
        request.testDevices = ["65bff9d7a2bfc4f181d7db7dafdfcfa2", "Simulator"]
        interstitial.loadRequest(request)
        
        //Reward video
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().loadRequest(GADRequest(), withAdUnitID: "ca-app-pub-1607117345046468/1983337237")
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
    
    func showInterstitial() {
        if interstitial.isReady {
            interstitial.presentFromRootViewController(self)
        }
    }
    
    func showRewardVideoAd() {
        if GADRewardBasedVideoAd.sharedInstance().ready {
            GADRewardBasedVideoAd.sharedInstance().presentFromRootViewController(self)
        }
    }
    
    func rewardBasedVideoAd(rewardBasedVideoAd: GADRewardBasedVideoAd!, didRewardUserWithReward reward: GADAdReward!) {
        //Give reward
        NSNotificationCenter.defaultCenter().postNotificationName("giveExtraChance", object: nil)
    }
    
    func rewardBasedVideoAdDidReceiveAd(rewardBasedVideoAd: GADRewardBasedVideoAd!) {
        print("RECIEVED REWARD AD!")
    }
    
    func rewardBasedVideoAd(rewardBasedVideoAd: GADRewardBasedVideoAd!, didFailToLoadWithError error: NSError!) {
        print("REWARD AD FAILED WITH ERROR: \(error.description)")
    }
    
    func rewardBasedVideoAdDidClose(rewardBasedVideoAd: GADRewardBasedVideoAd!) {
        NSNotificationCenter.defaultCenter().postNotificationName("giveExtraChance", object: nil)
    }
}
