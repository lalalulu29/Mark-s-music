//
//  RootViewController.swift
//  Mark's music
//
//  Created by Кирилл Любарских  on 11.04.2021.
//

import UIKit
import AVFoundation

class RootViewController: UIViewController {
    
    
    @IBOutlet weak var infoMusicView: UIView!
    @IBOutlet weak var tableWithMusic: UITableView!
    
    @IBOutlet weak var infoMusicImage: UIImageView!
    @IBOutlet weak var infoMusicLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var playAndPause: UIButton!
    
    
    var mySongs = [tracks]()
    
    let imageCache = NSCache<NSString, NSData>()
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        let network = NetworkProvider()
    
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {return}
        network.getMyTracksList(token: token) { (data) in
            let classDecode = DecodeRequests()
            classDecode.decodeTracksList(data: data) { [weak self] (myTracks) in
                guard let self = self else { return }
                self.mySongs = myTracks.tracks
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
        }
        
        infoMusicView.layer.backgroundColor = UIColor.systemGray6.cgColor
        
        
        
        infoMusicView.alpha = 0.99
        infoMusicLabel.text = ""
        
        
        
        
        table.contentInset = UIEdgeInsets(top: 0,
                                          left: 0,
                                          bottom: CGFloat(infoMusicView.frame.height),
                                          right: 0)
        table.scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: CGFloat(infoMusicView.frame.height),
                                                   right: 0)
        
    }
    
    


}
extension RootViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySongs.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyMusicTableViewCell
        
        
        let song = mySongs[indexPath.row]
        cell.MyMusicName.text = song.name
        
        cell.loadingImage.startAnimating()
        
        if song.picture_link != "" {
            if let cachedImage = imageCache.object(forKey: song.picture_link! as NSString) {
                DispatchQueue.main.async {
                    cell.loadingImage.stopAnimating()
                    cell.loadingImage.isHidden = true
                    DispatchQueue.main.async {
                        
                        cell.myMusicImage.image = UIImage(data: cachedImage as Data)
                    }
                }
            } else {
                let network = NetworkProvider()
                
                network.getMyTrackImage(link: song.picture_link!) { (data) in
                    self.imageCache.setObject(data as NSData, forKey: song.picture_link! as NSString)
                    DispatchQueue.main.async {
                        cell.loadingImage.stopAnimating()
                        cell.loadingImage.isHidden = true
                        DispatchQueue.main.async {
                            
                            cell.myMusicImage.image = UIImage(data: data)
                        }
                    }
                }
                
            }
        } else {
            cell.myMusicImage.image = UIImage(systemName: "music.note.list")
        }
        
        cell.myMusicImage.backgroundColor = .gray
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let song = mySongs[indexPath.row]
        
        infoMusicLabel.text = song.name
        
        if song.picture_link != "" {
            if let cachedImage = imageCache.object(forKey: song.picture_link! as NSString) {
                print("cache work!")
                DispatchQueue.main.async {
                    self.infoMusicImage.image = UIImage(data: cachedImage as Data)
                }
            } else {
                print("cache don't work")
                let network = NetworkProvider()
                
                network.getMyTrackImage(link: song.picture_link!) { (data) in
                    self.imageCache.setObject(data as NSData, forKey: song.picture_link! as NSString)
                    
                    DispatchQueue.main.async {
                        self.infoMusicImage.image = UIImage(data: data)
                    }
                }
                
            }
        } else {
            DispatchQueue.main.async {
                self.infoMusicImage.image = UIImage(systemName: "music.note.list")
            }
        }
        
        return indexPath
    }
    

    
    
    
}


extension RootViewController {
    
    @IBAction func previousMusic(_ sender: UIButton) {
        
    }
    @IBAction func pauseAndPlayMusic(_ sender: UIButton) {

    }
    @IBAction func nextMusic(_ sender: UIButton) {

    }
    
}


extension RootViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
}
