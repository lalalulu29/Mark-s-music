//
//  MyMusicTableViewCell.swift
//  Mark's music
//
//  Created by Кирилл Любарских  on 17.04.2021.
//

import UIKit

class MyMusicTableViewCell: UITableViewCell {
    @IBOutlet weak var myMusicImage: UIImageView!
    @IBOutlet weak var MyMusicArtistName: UILabel!
    @IBOutlet weak var MyMusicName: UILabel!
    @IBOutlet weak var loadingImage: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func downloadMusic(_ sender: UIButton) {
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //Возможно защита от багов при переиспользовании cell
        
        myMusicImage.image = nil
        MyMusicName.text = nil
        MyMusicArtistName.text = nil
        
        
    }
}
