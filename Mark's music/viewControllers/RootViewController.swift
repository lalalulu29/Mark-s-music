//
//  RootViewController.swift
//  Mark's music
//
//  Created by Кирилл Любарских  on 11.04.2021.
//

import UIKit
import AVKit
import MediaPlayer

class RootViewController: UIViewController {
    
    
    @IBOutlet weak var infoMusicView: UIView!
    @IBOutlet weak var tableWithMusic: UITableView!
    
    @IBOutlet weak var infoMusicImage: UIImageView!
    @IBOutlet weak var infoMusicLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var playAndPause: UIButton!
    
    
    
    var mySongs = [tracks]()
    let imageCache = NSCache<NSString, NSData>()
    let network = NetworkProvider()
    
    var numberSongPlayNow = 0
    
    override func viewDidLoad() {
        
       
        
        super.viewDidLoad()
        
        
        
        
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
        
        setupMediaPlayer()
        
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
        
        if Player != nil, Player.isPlaying == true {
            Player.stop()
        }
        
        let avkit = WorkWithAVKit()
        numberSongPlayNow = indexPath.row
        let song = mySongs[numberSongPlayNow]
        
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
        
        
        network.getMyMusic(link: "https://music.mark99.ru/api/getTrack",
                           songHash: song.hash) { [weak self] data in
            avkit.readyPlaySong(songData: data)
            Player.delegate = self
            
            
            Player.play()
            DispatchQueue.main.async {
                self!.playAndPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
            
            
            
            
        }
        
        return indexPath
    }
    
    
    
    
    
}


extension RootViewController {
    
    @IBAction func previousMusic(_ sender: UIButton) {
        if numberSongPlayNow == 0 {return}
        if Player != nil, Player.isPlaying == true {
            Player.stop()
            DispatchQueue.main.async {
                self.playAndPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
        numberSongPlayNow -= 1
        let song = mySongs[numberSongPlayNow]
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
        
        let avkit = WorkWithAVKit()
        network.getMyMusic(link: "https://music.mark99.ru/api/getTrack",
                           songHash: song.hash) { [weak self] data in
            avkit.readyPlaySong(songData: data)
            Player.delegate = self
            Player.play()
            DispatchQueue.main.async {
                self!.playAndPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        }
    }
    
    @IBAction func pauseAndPlayMusic(_ sender: UIButton) {
        if Player != nil, Player.isPlaying == true {
            Player.stop()
            DispatchQueue.main.async {
                self.playAndPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        } else if Player == nil{
            
            let song = mySongs[self.numberSongPlayNow]
            
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
            
            let avkit = WorkWithAVKit()
            network.getMyMusic(link: "https://music.mark99.ru/api/getTrack",
                               songHash: song.hash) { [weak self] data in
                avkit.readyPlaySong(songData: data)
                Player.delegate = self
                Player.play()
                DispatchQueue.main.async {
                    self!.playAndPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                }
                
                
                
                
            }
        } else if Player != nil, Player.isPlaying == false {
            Player.play()
            DispatchQueue.main.async {
                
                self.playAndPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        }
        
    }
    @IBAction func nextMusic(_ sender: UIButton) {
        if Player == nil {
            numberSongPlayNow = -1
        }
        if mySongs.count == numberSongPlayNow + 1 {return}
        numberSongPlayNow += 1
        if Player != nil, Player.isPlaying == true {
            Player.stop()
            DispatchQueue.main.async {
                self.playAndPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
        let song = mySongs[numberSongPlayNow]
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
        
        let avkit = WorkWithAVKit()
        network.getMyMusic(link: "https://music.mark99.ru/api/getTrack",
                           songHash: song.hash) { [weak self] data in
            avkit.readyPlaySong(songData: data)
            Player.delegate = self
            Player.play()
            DispatchQueue.main.async {
                self!.playAndPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        }
    }
    
}


extension RootViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if mySongs.count == numberSongPlayNow + 1 {return}
        numberSongPlayNow += 1
        if Player != nil, Player.isPlaying == true {
            Player.stop()
            DispatchQueue.main.async {
                self.playAndPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
        let song = mySongs[numberSongPlayNow]
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
        
        let avkit = WorkWithAVKit()
        network.getMyMusic(link: "https://music.mark99.ru/api/getTrack",
                           songHash: song.hash) { [weak self] data in
            avkit.readyPlaySong(songData: data)
            Player.delegate = self
            Player.play()
            DispatchQueue.main.async {
                self!.playAndPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        }
    }
}


extension RootViewController {
    func setupMediaPlayer() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { event in
            if Player != nil {
                DispatchQueue.main.async {
                    self.playAndPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                }
                Player.play() }
            
            return .success
        }
        commandCenter.pauseCommand.addTarget { event in
            Player.pause()
            DispatchQueue.main.async {
                self.playAndPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
            return .success
        }
        commandCenter.nextTrackCommand.addTarget { event in
            
            return .success
           
        }
        
    }
}
