//
//  PlayerViewController.swift
//  Nhaccuathai
//
//  Created by Nguyen Dang Trong Thai on 1/6/23.
//
import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    public var position: Int = 0
    public var songs: [Song] = []
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblTimeDown: UILabel!
    @IBOutlet weak var lblTimeUp: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var sliderSong: UISlider!
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        btnPlay.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        btnPlay.tintColor = UIColor.systemIndigo
        
        super.viewDidLoad()
        
        configure()
    }
    
    func handleTimeConversion(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func handleTimeDown(_ seconds: Int) {
      let (h, m, s) = handleTimeConversion(seconds)
        
        if (h != 0) {
            lblTimeDown.text = String("\(h):\(m):\(s)")
        } else {
            lblTimeDown.text = String("\(m):\(s)")
        }
        
        if (h == 0 && m == 0 && s == 0) {
            handleNextSong()
        }
    }
    
    func handleTimeUp(_ seconds: Int) {
      let (h, m, s) = handleTimeConversion(seconds)
        
        if (h != 0) {
            lblTimeUp.text = String("\(h):\(m):\(s)")
        } else {
            lblTimeUp.text = String("\(m):\(s)")
        }
    }
    
    func configure() {
        //set up player
        let song = songs[position]
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
            guard let urlString = urlString else {
                print("urlString is nil")
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player else {
                print("player is nil")
                return
            }
            player.volume = 0.5
            player.play()

        }
        
        catch {
            print("error occurred")
        }
        
        //render UI
        imgView.image = UIImage(named: song.imageName)
        lblName.text = song.name
        lblArtist.text = song.artistName
        
        //action
        btnPlay.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(handleNextSong), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(handlePreviousSong), for: .touchUpInside)

        //slider volume
        sliderVolume.value = 1
        sliderVolume.addTarget(self, action: #selector(handleVolumeSlider(_:)), for: .valueChanged)

        //slider music
        sliderSong.maximumValue = Float(player!.duration)
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        
        sliderSong.addTarget(self, action: #selector(mappingSliderWithSong(_:)), for: .valueChanged)
    }
    
    @objc func handlePreviousSong() {
        if position > 0 {
            position = position - 1
            player?.stop()
            configure()
            btnPlay.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc func handleNextSong() {
        if position < (songs.count - 1) {
            position = position + 1
            player?.stop()
            configure()
            btnPlay.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc func handlePlayPause() {
        if player?.isPlaying == true {
            player?.pause()
            //show play btn
            btnPlay.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            btnPlay.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc func handleVolumeSlider(_ slider: UISlider) {
        let value = slider.value
        player?.volume = value
    }
    
    // slider music
    @objc func mappingSliderWithSong(_ sliderM: UISlider) {
        player?.currentTime = TimeInterval(sliderM.value)
    }
        
    @objc func updateSlider() {
        sliderSong.value = Float(player!.currentTime)
    
        let timeDown: Int = Int((player!.duration) - (player!.currentTime))
        let timeUp: Int = Int(player!.currentTime)
        
        handleTimeDown(timeDown)
        handleTimeUp(timeUp)
    }
    
    
    @IBAction func btnShuffle(_ sender: Any) {
        
    }
    
    @IBAction func btnInfinity(_ sender: Any) {
        
    }
    
    @IBAction func btnLike(_ sender: Any) {

    }
    
    @IBAction func btnList(_ sender: Any) {
        //mo danh sach
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if let player = player {
            player.stop()
        }
    }
}

    

