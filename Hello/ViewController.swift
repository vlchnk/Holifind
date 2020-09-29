//
//  ViewController.swift
//  Hello
//
//  Created by volchonok on 27.09.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var monthTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var outLabel: UILabel!
    
    var holiday: String = ""
    
    @IBAction func outBtn(_ sender: UIButton) {
        
        guard let day = dateTF.text, let month = monthTF.text, let year = yearTF.text else { return }
        
        let url = URL(string: "https://holidayapi.com/v1/holidays?pretty&key=<API key>&country=RU&year=\(year)&month=\(month)&day=\(day)")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                
                guard json!["status"] as! Int == 200  else {
                    return
                }
                let posts = json?["holidays"] as? [[String: Any]] ?? []
                guard posts.count > 0 else {
                    return
                }

                self.holiday = posts[0]["name"] as! String
                print("This day is \(String(describing: self.holiday))")
                
            } catch {
                print(error)
            }
        }).resume()
        
        outLabel.text = self.holiday
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}

