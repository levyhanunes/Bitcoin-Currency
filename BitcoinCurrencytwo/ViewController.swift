//
//  ViewController.swift
//  BitcoinCurrencytwo
//
//  Created by user195476 on 5/18/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate,
UIPickerViewDataSource {
    

    
    // MARK:- outlet
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var price: UILabel!
    
    // MARK:- variable
    
    let apiKey = "Yjc2ZDc0MGFlMDFhNDdmMGI2YmNmNzE0ZTA4ZmM1ZmQ"
    
    let curruncies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        fetchData(url: baseUrl)
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
              return 1
           }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
             // retorno o numero de moedas para fazer a conversao.
            return curruncies.count
         }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            // retorna o titulo para a selacao
            return curruncies[row]
         }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
               fetchData(url: url)
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: curruncies[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    

    func fetchData(url: String) {
        
        let url = URL(string: url)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-ba-key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    
            if let data = data {
                //let dataString = String(data: data, encoding: .utf8)
                self.parseJSON(json: data)
            }else {
                print("error")
                
            }
        }
        
        task.resume()
        
            
    }
        
    func parseJSON(json: Data){
       
        do {
            if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                       print(json)
            if let askValue = json["ask"] as? NSNumber {
                print(askValue)
                 //.currency
                
            let numberFormatter = NumberFormatter()
                numberFormatter.locale = Locale(identifier: "pt_BR")
                numberFormatter.minimumFractionDigits = 2
                //numberFormatter.positiveFormat = "#0.000,00"
                numberFormatter.numberStyle = .decimal
            
            //let askvalueString = "\(askValue)"
                DispatchQueue.main.async {
                    
                    let price = numberFormatter.string(from: askValue)
                    self.price.text = price
                    
                    //self.bitcoinLabelValue.text = askvalueString
            }
                print("success")
                        } else {
                
                            print("error")
                        }
                    }
                } catch {

                    print("error parsing json: \(error)")
                }
        }
        
    }
