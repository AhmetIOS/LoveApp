//
//  SecondViewController.swift
//  Aşk Sözleri
//
//  Created by Ahmet Durmuş on 14.10.2022.
//

import UIKit
import FirebaseFirestore
import GoogleMobileAds

struct Message {
    let data: String
    let isFav: Bool
    let category: String
    let id: Int
}
class SecondViewController: UIViewController, GADFullScreenContentDelegate {

    private var interstitial: GADInterstitialAd?
    private let request = GADRequest()
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        //banner.adUnitID = "ca-app-pub-6480988528718917/6685959829"
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    
    @IBOutlet weak var isFavData: UILabel!
    @IBOutlet weak var secondUpView: UIView!
    @IBOutlet weak var secondDownView: UIView!
    @IBOutlet weak var mainData: UILabel!
    @IBOutlet weak var mainDataCount: UILabel!
    
    var number = 1
    var dataCount = 1
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView(name: secondUpView)
        shadowView(name: secondDownView)
        
        banner.rootViewController = self
        view.addSubview(banner)
        
      
        
        guard let title = navigationItem.title else {
            return
        }
        
        
        if title == "FAVORİLER" {
            query(name: title)
        } else {
            loadData(name: title)
            dataNumber(name: title)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        let statusBarHeight = statusBarSize.height
        banner.frame = CGRect(x: 0, y: 44+statusBarHeight+2, width: view.frame.size.width, height: 50)
        banner.translatesAutoresizingMaskIntoConstraints = true
    }
    
    private func dataNumber(name : String) {
        db.collection(name).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.dataCount = querySnapshot!.documents.count
                print(self.dataCount)
            }
        }
    }
   
    private func loadData(name: String) {
        let docRef = db.collection(name).document("\(number)")

        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            guard let dataDescription = document.data() else {
                return
            }
            guard let data = dataDescription["data"] as? String else {
                return
            }
            
            DispatchQueue.main.async {
                self.mainData.text = data
                self.mainDataCount.text = "\(self.number) / \(self.dataCount)"
                
            }
            
            
        }
    }
    
    public func query(name: String) {
        print("favoriler")
        self.messages = []
        let words = ["AŞK SÖZLERİ", "TATLI SÖZLER","ACI SÖZLER"]
        for item in words {
            db.collection(item).whereField("isFav", isEqualTo: true)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let doc = document.data()
                            guard let data = doc["data"] as? String else {
                                return
                            }
                            guard let category = doc["category"] as? String else {
                                return
                            }
                            guard let idNumber = doc["id"] as? Int else {
                                return
                            }
                            //print(doc)
                            let newMessage = Message(data: data, isFav: true, category: category, id: idNumber)
                            //print(newMessage)
                            self.messages.append(newMessage)
                            self.dataCount = self.messages.count
                            DispatchQueue.main.async {
                                self.mainData.text = self.messages[self.number-1].data
                                
                                self.mainDataCount.text = "\(self.number) / \(self.dataCount)"
                                print(self.messages)
                            }
                            
                            
                        }
                    }
            }
        }
        
        
       
    }
    
    private func shadowView(name: UIView) {
        
        name.layer.shadowOffset = CGSize(width: -1, height: 1)
        name.layer.shadowRadius = 1
        name.layer.shadowOpacity = 0.5
    }
   
  
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        print("share")
        
        
        let text = mainData.text
            let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any] , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func copyButtonTapped(_ sender: UIButton) {
        print("copy")
        
        //UIPasteboard.general.string = mainData.text
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        print("random")
        let randomInt = Int.random(in: 1..<dataCount+1)
        number = randomInt
        guard let title = navigationItem.title else {
            return
        }
        if title == "FAVORİLER" {
            
            mainData.text = messages[number].data
            mainDataCount.text = "\(number) / \(dataCount)"
            
        } else {
            loadData(name: title)
        }
        
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        print("fav")
        guard let title = navigationItem.title else {
            return
        }
        
        if title == "FAVORİLER" {
            
//            messages.remove(at: number)
//            dataCount = dataCount-1
            let isFav = messages[number-1].isFav
            let title = messages[number-1].category
            let id = messages[number-1].id
            print(title, id, isFav)
            print(messages[0])
            let ref = self.db.collection(title).document("\(id)")
            if isFav {
                
                ref.updateData([
                    "isFav": false
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                        self.isFaved(data: "Favorilerden Çıkarıldı")
                        if self.dataCount == 1 {
                            self.isFaved(data: "Favoriler Boş")
                        } else {
                            self.query(name: title)
                        }
                        
                    }
                }
            }
            
            
        } else {
            let docRef = db.collection(title).document("\(number)")

                    docRef.getDocument { (document, error) in
                        guard let document = document, document.exists else {
                            print("Document does not exist")
                            return
                        }
                        guard let dataDescription = document.data() else {
                            return
                        }
                        
                        guard let isFav = dataDescription["isFav"] as? Bool else {
                            return
                        }
                       
                        let ref = self.db.collection(title).document("\(self.number)")
                        if isFav {
                            
                            ref.updateData([
                                "isFav": false
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                    self.isFaved(data: "Favorilerden Çıkarıldı")
                                }
                            }
                        } else {
                            ref.updateData([
                                "isFav": true
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                    self.isFaved(data: "Favorilere Eklendi")
                                }
                            }
                            
                        }
                        
                    }
        }
        
        
    }
    
    private func isFaved(data: String) {
        
        isFavData.text = data
        isFavData.backgroundColor = .white
        isFavData.textColor = .black
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            self.isFavData.text = ""
            self.isFavData.backgroundColor = .white
            self.isFavData.textColor = .white
        } )
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        print("back")
        if number == 1 {
            number = dataCount+1
        }
        number = number-1
        
        guard let title = navigationItem.title else {
            return
        }
        
        if title == "FAVORİLER" {
            
            mainData.text = messages[number-1].data
            mainDataCount.text = "\(number) / \(dataCount)"
            
        } else {
            loadData(name: title)
        }
        if ( number % 5 == 0) {
            admobFullScreen()
        }
       
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        print("forward")
        print(number)
        if number == dataCount {
            number = 0
        }
        number = number+1
        
        guard let title = navigationItem.title else {
            return
        }
        if title == "FAVORİLER" {
            print(number)
            mainData.text = messages[number-1].data
            mainDataCount.text = "\(number) / \(dataCount)"
            
        } else {
            loadData(name: title)
        }
        if ( number % 5 == 0) {
           admobFullScreen()
        }
        

    }
    
   
    
     //to load data first time
//    private func sendData() {
//        // Add a new document in collection "cities"
//        guard let title = navigationItem.title else {
//            return
//        }
//        db.collection("AŞK SÖZLERİ").document("\(number)").setData([
//            "data": "\(messages[number-1].data)",
//            "isFav": false,
//            "category": "\(messages[number-1].category)",
//            "id": self.number
//        ]) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//        number = number + 1
//    }
    
}
