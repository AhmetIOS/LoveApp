//
//  ViewController.swift
//  Aşk Sözleri
//
//  Created by Ahmet Durmuş on 14.10.2022.
//

import UIKit
import GoogleMobileAds



class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var words = ["AŞK SÖZLERİ", "TATLI SÖZLER","ACI SÖZLER", "AŞK SÖZLERİ", "TATLI SÖZLER","ACI SÖZLER", "AŞK SÖZLERİ", "TATLI SÖZLER","ACI SÖZLER", "AŞK SÖZLERİ", "TATLI SÖZLER","ACI SÖZLER"]
    
    private var interstitial: GADInterstitialAd?
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        //banner.adUnitID = "ca-app-pub-6480988528718917/6685959829"
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
       
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        let statusBarHeight = statusBarSize.height
        banner.frame = CGRect(x: 0, y: 44+statusBarHeight+2, width: view.frame.size.width, height: 50)
        banner.translatesAutoresizingMaskIntoConstraints = true
    }
    
    private func configureItems () {
       
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "star.fill"),
                            style: .done,
                            target: self,
                            action: nil),
//            UIBarButtonItem(image: UIImage(systemName: "gearshape.2.fill"),
//                            style: .done,
//                            target: self,
//                            action: nil)
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

