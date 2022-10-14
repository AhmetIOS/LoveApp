//
//  ViewController.swift
//  Aşk Sözleri
//
//  Created by Ahmet Durmuş on 14.10.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var words = ["AŞK SÖZLERİ", "ANLAMLI SÖZLER","ACI SÖZLER", "AŞK SÖZLERİ", "ANLAMLI SÖZLER","ACI SÖZLER", "AŞK SÖZLERİ", "ANLAMLI SÖZLER","ACI SÖZLER","AŞK SÖZLERİ", "ANLAMLI SÖZLER","ACI SÖZLER","AŞK SÖZLERİ", "ANLAMLI SÖZLER","ACI SÖZLER"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        configureItems()
        
        title = "Aşk Sözleri"
    }
    
    private func configureItems () {
       
        print("b")
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "star.fill"),
                            style: .done,
                            target: self,
                            action: nil),
            UIBarButtonItem(image: UIImage(systemName: "gear"),
                            style: .done,
                            target: self,
                            action: nil)
        ]
    }

    @IBAction func favButtonTapped(_ sender: UIButton) {
        print("fav")
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bubbleCell") as! MainTableViewCell
        
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
    }
    
    
}

