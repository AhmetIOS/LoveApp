//
//  SecondViewController.swift
//  Aşk Sözleri
//
//  Created by Ahmet Durmuş on 14.10.2022.
//

import UIKit
import FirebaseFirestore
import GoogleMobileAds
import CoreData

struct Message {
    let data: String
}
class SecondViewController: UIViewController, GADFullScreenContentDelegate {

    private var interstitial: GADInterstitialAd?
    private let request = GADRequest()
    
    private var favItems = [FavItems]()
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
    
    var messages: [Message] = [
    Message(data: "Meğer hayat dediğin sadece gözlerinden ibaretmiş."),
    Message(data: "Seni yıldızlar sönene kadar seveceğim, sevgilim."),
    Message(data: "Unutulmak kadar acıdır bazen yaşamak."),
    Message(data: "Ben ağlarken yanımda yoksan, ben gülerken de gölge yapma."),
    Message(data: "Karakteri menfaatlerine göre şekillenen insanlar var."),
    Message(data: "Sen aklım ve kalbim arasında kalan en güzel çaresizliğimsin."),
    Message(data: "Ömrü bitene kadar sevmeli insan. Menfaatleri bitene kadar değil."),
    Message(data: "Bazen sana kırgın olduğumu unutup özlüyorum."),
    Message(data: "Bazıları göz yaşını siler, bazıları ise ağlatanı."),
    
    ]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
            dataNumber(name: title)
            if dataCount != 0 {
                
                getAllItems(order: number)
            } else {
               
                mainData.text = "FAVORİLERİZ BOŞ!! Lütfen beğendiğiniz sözleri ekranın sağ üstünde yer alan kalp işaretine basarak favorilerinize ekleyiniz!"
            }
            
            
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
       
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        banner.frame = CGRect(x: 0, y: 44+statusBarHeight+2, width: view.frame.size.width, height: 50)
        banner.translatesAutoresizingMaskIntoConstraints = true
    }
    
    private func dataNumber(name : String) {
        
        guard let title = navigationItem.title else {
            return
        }
        
        
        if title == "FAVORİLER" {
            
           getFavRecordsCount()
            
        } else {
            db.collection(name).getDocuments() { [self] (querySnapshot, err) in
                       if let err = err {
                           print("Error getting documents: \(err)")
                       } else {
                           self.dataCount = querySnapshot!.documents.count
                           print(self.dataCount)
                           self.mainDataCount.text = "\(number) / \(dataCount)"
                           //datacount
                       }
                   }
        }
        
       
    }
    
    func getFavRecordsCount() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavItems")
            do {
                let count = try context.count(for: fetchRequest)
                dataCount = count
            } catch {
                print(error.localizedDescription)
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

    
    private func shadowView(name: UIView) {
        
        name.layer.shadowOffset = CGSize(width: -1, height: 1)
        name.layer.shadowRadius = 1
        name.layer.shadowOpacity = 0.5
    }
    
    func getAllItems (order: Int) {
        
        do {
            favItems = try context.fetch(FavItems.fetchRequest())
          let model = favItems[order-1]
            print(order)
            print("model.data = \(String(describing: model.data))")
            guard let favData = model.data else {
                return
            }
            
            mainData.text = favData
            print(favData, number)
            mainDataCount.text = "\(number) / \(dataCount)"
          
        } catch {
            print(error)
        }
    }
    
    func createItem(data: String, category: String) {
        let newItem = FavItems(context: context)
        newItem.data = data
        newItem.category = category
        
        do {
            try context.save()
           
            deneme()
            
        } catch {
            
        }
    }
    
    func deneme() {
        var request = NSFetchRequest<NSFetchRequestResult>()
        request = FavItems.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let arrayOfData = try context.fetch(request)
            print(arrayOfData)
        } catch {
            // Handle the error!
        }
    }
    
    func deleteItem(item: FavItems) {
       
        context.delete(item)
        do {
            try context.save()
            guard let title = navigationController?.title else {
                return
            }
            dataNumber(name: title)
            if dataCount != 0 {
                isFaved(data: "Favorilerden Çıkarıldı!")
                number = number - 1
                            if number == 0 {
                                number = dataCount
                            }
                                getAllItems(order: number)
            } else {
                isFaved(data: "Favoriler Boş!!")
            }
            
            
            
        } catch {
            
        }
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
        
        UIPasteboard.general.string = mainData.text
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        print("random")
        guard let title = navigationItem.title else {
            return
        }
        if title == "FAVORİLER" {
            if dataCount != 0 {
                let randomInt = Int.random(in: 1..<dataCount+1)
                number = randomInt
                getAllItems(order: number)
            } else {
                isFaved(data: "Favoriler Boş!!")
            }
            
        } else {
            let randomInt = Int.random(in: 1..<dataCount+1)
            number = randomInt
            loadData(name: title)
        }
        
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        guard let data = mainData.text, let category = navigationController?.title else {
            return
        }
        if title == "FAVORİLER" {
            if dataCount != 0 {
                let item = favItems[number-1]
                deleteItem(item: item)
            } else {
                isFaved(data: "Favoriler Boş!!")
            }
            
        } else {
            createItem(data: data, category: category)
            isFaved(data: "Favorilere Eklendi!")
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
        
            if dataCount != 0 {
                backFunc()
            } else {
                isFaved(data: "Favoriler Boş!!")
            }
            
       
       
    }
    
    
    private func backFunc() {
        guard let title = navigationItem.title else {
            return
        }
        
        if title == "FAVORİLER" {
            number = number-1
            if number == 0 {
                number = dataCount
            }
            getAllItems(order: number)
  
            
        } else {
            if number == 1 {
                number = dataCount+1
            }
            number = number-1
            loadData(name: title)
        }
        if ( number % 5 == 0) {
            admobFullScreen()
        }
    }
    

    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        print("forward")
        
        if dataCount != 0 {
            forwardFunc()
        } else {
            isFaved(data: "Favoriler Boş!!")
        }
        

    }
    
    private func forwardFunc() {
        guard let title = navigationItem.title else {
            return
        }
        if title == "FAVORİLER" {
            number = number+1
            if number == dataCount+1 {
                number = 1
            }
            getAllItems(order: number)
            
            
        } else {
            if number == dataCount {
                number = 0
            }
            number = number+1
            loadData(name: title)
        }
        if ( number % 5 == 0) {
           admobFullScreen()
        }
    }
   
    
     //to load data first time
//    private func sendData() {
//        // Add a new document in collection "cities"
//        let no = 1...9
//        for i in no {
//            db.collection("ÖZÜR SÖZLERİ").document("\(i)").setData([
//                        "data": "\(messages[i-1].data)",
//
//                    ]) { err in
//                        if let err = err {
//                            print("Error writing document: \(err)")
//                        } else {
//                            print("Document successfully written!")
//                        }
//                    }
//        }
//
//    }
    
}
