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

class GameViewController: UIViewController, GADRewardBasedVideoAdDelegate, GADBannerViewDelegate {
    
    //var adView: MPAdView!
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GameViewController.loadAds),
            name: NSNotification.Name(rawValue: "loadAds"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GameViewController.removeAdsOnGameOver),
            name: NSNotification.Name(rawValue: "removeAds"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GameViewController.showInterstitial),
            name: NSNotification.Name(rawValue: "showInterstitial"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GameViewController.showRewardVideoAd),
            name: NSNotification.Name(rawValue: "showRewardVideo"),
            object: nil)
        
        if let scene = StartScene(fileNamed:"StartScene") {
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .fill
            
            skView.presentScene(scene)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func loadAds() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.frame = CGRect(x: (view!.bounds.size.width - kGADAdSizeBanner.size.width) / 2,
                                      y: view!.bounds.size.height - kGADAdSizeBanner.size.height,
                                      width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height);
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-1607117345046468/9082311632"
        
        bannerView.rootViewController = self
        view!.addSubview(bannerView)
        
        bannerView.isHidden = true
        
        let bannerRequest = GADRequest()
        bannerRequest.testDevices = ["65bff9d7a2bfc4f181d7db7dafdfcfa2", "Simulator"]
        bannerView.load(bannerRequest)
        
        //Interstitial from admob
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1607117345046468/5914009238")
        let request = GADRequest()
        request.testDevices = ["65bff9d7a2bfc4f181d7db7dafdfcfa2", "Simulator"]
        interstitial.load(request)
        
        //Reward video
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-1607117345046468/1983337237")
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
        self.bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("ERROR LOADING BANNER AD: \(error.description)")
        self.bannerView.isHidden = true
    }
    
    func removeAdsOnGameOver() {
        if let _ = bannerView.superview {
            bannerView.removeFromSuperview()
        }
    }
    
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView!) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "pauseGame"), object: nil)
    }
    
    func showInterstitial() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    func showRewardVideoAd() {
        if GADRewardBasedVideoAd.sharedInstance().isReady {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd!, didRewardUserWith reward: GADAdReward!) {
        //Give reward
        print("REWARD WORKED!")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "giveExtraChance"), object: nil)
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd!) {
        print("RECIEVED REWARD AD!")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "receivedReward"), object: nil)
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd!, didFailToLoadWithError error: Error!) {
        print("REWARD AD FAILED")
    }
}
