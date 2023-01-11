//
//  ViewController.swift
//  Nhaccuathai
//
//  Created by Nguyen Dang Trong Thai on 1/6/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    
    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSongs()
        table.delegate = self
        table.dataSource = self
    }
    
    func configureSongs() {
        songs.append(Song(name: "Someone Like You",
                          artistName: "Adele",
                          imageName: "Nobita",
                          trackName: "Bai2"))
        songs.append(Song(name: "Ngu mot minh",
                          artistName: "HIEUTHUHAI",
                          imageName: "Xuka",
                          trackName: "Bai3"))
        songs.append(Song(name: "Taste",
                          artistName: "Tyga, Offset",
                          imageName: "Xeko",
                          trackName: "Bai4"))
    }
    
    // Table

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artistName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: song.imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //present the player
        let position = indexPath.row
        //songs
        guard let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController else {
            return
        }
        
        vc.songs = songs
        vc.position = position
        
        present(vc, animated: true)
    }
}

//model
struct Song {
    let name: String
    let artistName: String
    let imageName: String
    let trackName: String
}

struct PlaylistModel {
    let name: String
}

