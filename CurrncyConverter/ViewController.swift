//
//  ViewController.swift
//  CurrncyConverter
//
//  Created by Emin on 14.10.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var CAD: UILabel!
    @IBOutlet weak var CHF: UILabel!
    @IBOutlet weak var GBP: UILabel!
    @IBOutlet weak var JPY: UILabel!
    @IBOutlet weak var USD: UILabel!
    @IBOutlet weak var TRY: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func GETRATES(_ sender: Any) {
        
        //1) REQUEST & SESSİON
        //2) RESPONSE & DATA
        //3) PARSİNG & JSON SERİALİZATION
        
        let url = URL(string: "https://data.fixer.io/api/latest?access_key=95ee56ad4280e310767f07694164d533")
        
        let session = URLSession.shared
        
        //Closure
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
                alert.addAction(button)
                self.present(alert, animated: true)
            }else{
                //2
                if data != nil {
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                        //ASYNC
                        DispatchQueue.main.async {
                            if jsonResponse["success"] as? Int == 1{

                                let dic = jsonResponse["rates"] as? Dictionary<String,Double>
                                
                                // Para birimlerini ve ilgili UILabel'leri bir dictionary içinde tanımlayalım.
                                let currencyLabels: [String: UILabel] = [
                                    "CAD": self.CAD,
                                    "CHF": self.CHF,
                                    "GBP": self.GBP,
                                    "JPY": self.JPY,
                                    "USD": self.USD,
                                    "TRY": self.TRY
                                ]

                                // Dictionary'deki her bir para birimi ve ilgili UILabel'i döngüyle kontrol edelim.
                                for (currency, label) in currencyLabels {
                                    if let price = dic?[currency] {
                                        label.text = "\(currency): " + String(price)
                                    }
                                }
                                        

                            }
                            
                        }
                    }catch{
                        print("Hata")
                    }
                }
                
            }
        }
        task.resume()
    }
    
}

