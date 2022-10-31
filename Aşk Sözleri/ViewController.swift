//
//  ViewController.swift
//  Aşk Sözleri
//
//  Created by Ahmet Durmuş on 14.10.2022.
//

import UIKit
import GoogleMobileAds
import StoreKit



class ViewController: UIViewController, GADFullScreenContentDelegate {

    private var interstitial: GADInterstitialAd?
    private let request = GADRequest()
    
    @IBOutlet weak var tableView: UITableView!
    
    var words = ["AŞK SÖZLERİ", "TATLI SÖZLER","ACI SÖZLER", "EFSANE SÖZLER", "ÖZÜR SÖZLERİ","ROMANTİK SÖZLER", "TEŞEKKÜR SÖZLERİ", "AŞK SÖZLERİ", "TATLI SÖZLER","ACI SÖZLER", "EFSANE SÖZLER", "ÖZÜR SÖZLERİ","ROMANTİK SÖZLER", "TEŞEKKÜR SÖZLERİ"]
    
//   var number = 1
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        //banner.adUnitID = "ca-app-pub-6480988528718917/6685959829"dasd
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        banner.rootViewController = self
        view.addSubview(banner)
        
        let request = GADRequest()
            GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                                        request: request,
                              completionHandler: { [self] ad, error in
                                if let error = error {
                                  print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                  return
                                }
                                interstitial = ad
                              }
            )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        configureItems()

        title = "Aşk Sözleri"
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        banner.frame = CGRect(x: 0, y: 44+statusBarHeight+2, width: view.frame.size.width, height: 50)
        banner.translatesAutoresizingMaskIntoConstraints = true
    }
    
    @objc func rateApp() {

        if #available(iOS 10.3, *) {
                
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                DispatchQueue.main.async {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
            
            
        
        } else {

            let appID = "1137397744"
            let urlStr = "https://itunes.apple.com/app/id\(appID)" // (Option 1) Open App Page
            //let urlStr = "https://itunes.apple.com/app/id\(appID)?action=write-review" // (Option 2) Open App Review Page
            
            guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }
            

                UIApplication.shared.open(url, options: [:], completionHandler: nil)

        }
    }
    
    private func admobFullScreen() {
        
            GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                                        request: request,
                              completionHandler: { [self] ad, error in
                                if let error = error {
                                  print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                  return
                                }
                                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
                                
                              }
            )
        
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
          } else {
            print("Ad wasn't ready")
          }

    }
    
    private func configureItems () {
       
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "star.fill"),
                            style: .done,
                            target: self,
                            action: #selector(rateApp)),

        ]
    }

    @IBAction func favButtonTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "secondView") as! SecondViewController
        
        let backItem = UIBarButtonItem()
            backItem.title = "Geri"
            navigationItem.backBarButtonItem = backItem
        
        vc.title = "FAVORİLER"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func adMobActivate() {
        
        let adNumber = UserDefaults.standard.value(forKey: "adNumber") as? Int ?? 0
        UserDefaults.standard.set((adNumber+1), forKey: "adNumber")
        if ( adNumber % 5 == 0) {
            admobFullScreen()
        }
        print(adNumber)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bubbleCell") as! MainTableViewCell
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = bgColorView
        
        cell.mainLabel.text = words[indexPath.row]
        cell.mainView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.mainView.layer.shadowRadius = 1
        cell.mainView.layer.shadowOpacity = 0.5
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("a")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "secondView") as! SecondViewController
        
        let backItem = UIBarButtonItem()
            backItem.title = "Geri"
            navigationItem.backBarButtonItem = backItem
        
        vc.title = words[indexPath.row]
        
        adMobActivate()
       
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

