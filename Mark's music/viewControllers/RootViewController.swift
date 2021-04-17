//
//  RootViewController.swift
//  Mark's music
//
//  Created by Кирилл Любарских  on 11.04.2021.
//

import UIKit

class RootViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = UserDefaults.standard.string(forKey: "token") else {return}
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RootViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "111"
        return cell
    }
    
    
}
