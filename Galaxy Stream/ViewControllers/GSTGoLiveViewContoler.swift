//
//  ViewController.swift
//  Galaxy Stream
//
//  Created by Shashi Gupta on 10/04/25.
//

import UIKit
import AgoraRtcKit

class GSTGoLiveViewContoler: UIViewController {
    
    @IBOutlet weak var localView: UIView! // UI view for displaying the local video stream
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var remoteView: UIView! // UI view for displaying the remote video stream
    @IBOutlet weak var switchCameraButton: UIButton! // Button to switch between front and back cameras
    @IBOutlet weak var muteButton: UIButton! // Button to mute/unmute audio
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var audienceCountLabel: UILabel! // Label to display audience count
    @IBOutlet weak var cameraToggleButton: UIButton!
    
    // Instance of the Agora RTC engine
    var agoraKit: AgoraRtcEngineKit!
    
    // Track mute state
    private var isAudioMuted = false
    
    // Track audience count (including broadcaster)
    private var audienceCount = 1 // Start with 1 (self)
    
    private var isCameraOn = true
    
    private var localVideoPlaceholderImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Agora engine
        initializeAgoraVideoSDK()
        // Set up the user interface
        setupUI()
        // Start the local video preview
        setupLocalVideo()
        // Join an Agora channel
        joinChannel(token: GSTConstants.token, channelID: GSTConstants.channelName)
    }
    
    // Clean up resources when the view controller is deallocated
    deinit {
        agoraKit.stopPreview()
        agoraKit.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }
    
    // Initializes the Video SDK instance
    func initializeAgoraVideoSDK() {
        // Create an instance of AgoraRtcEngineKit and set the delegate
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: GSTConstants.appId, delegate: self)
    }
    
    // Sets up the UI layout for local and remote video views
    func setupUI() {
        self.remoteView.isHidden = true
        self.moreButton.isHidden = true
        self.loadingLabel.isHidden = false
        
        // Configure the switch camera button
        setupSwitchCameraButton()
        
        // Configure the mute button
        setupMuteButton()
        
        setUpMoreButton()
        
        handelMoreUI()
        
        // Configure the audience count label
        setupAudienceCountLabel()
        
        // Configure the cancel button
        setupCancelButton()
        
        // Configure the camera toggle button
        setupCameraToggleButton()
        
        // Configure the Video off placeholder
        setupLocalVideoPlaceholderImage()
    }
    
    // Configures and starts displaying the local video feed
    func setupLocalVideo() {
        // Enable video functionality (audio is enabled by default)
        agoraKit.enableVideo()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.view = localView
        videoCanvas.uid = 0  // UID 0 is assigned to the local user
        videoCanvas.renderMode = .hidden
        agoraKit.setupLocalVideo(videoCanvas)
        agoraKit.startPreview()
    }
    
    // Configure the mute button
    func setupMuteButton() {
        // Set initial button image for unmuted state
        updateMuteButtonAppearance()
        
        // Add a background for better visibility
        muteButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        muteButton.layer.cornerRadius = 20
        
        // Add action
        muteButton.addTarget(self, action: #selector(toggleMute), for: .touchUpInside)
    }
    
    // Configure the mute button
    func setupCancelButton() {
        
        // Add a background for better visibility
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        cancelButton.layer.cornerRadius = 20
        
        cancelButton.tintColor = .white
    }
    
    // Configure the audience count label
    func setupAudienceCountLabel() {
        // If you're using storyboard, you can set these properties in Interface Builder
        // This is just for reference if you're creating the label programmatically
        
        audienceCountLabel.textColor = .white
        audienceCountLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        audienceCountLabel.layer.cornerRadius = 12
        audienceCountLabel.clipsToBounds = true
        audienceCountLabel.textAlignment = .center
        audienceCountLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        // Set initial count
        updateAudienceCount()
    }
    
    // Update the audience count label
    func updateAudienceCount() {
        DispatchQueue.main.async {
            self.audienceCountLabel.text = "👥 \(self.audienceCount)"
            
            // Optional: Add a brief animation to highlight the change
            UIView.animate(withDuration: 0.2) {
                self.audienceCountLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.audienceCountLabel.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
    // Update mute button appearance based on current state
    func updateMuteButtonAppearance() {
        if isAudioMuted {
            // Muted state
            muteButton.setImage(UIImage(systemName: "mic.slash.fill"), for: .normal)
            muteButton.tintColor = .red
        } else {
            // Unmuted state
            muteButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            muteButton.tintColor = .white
        }
    }
    
    // Join the channel with specified options
    func joinChannel(token: String, channelID: String) {
        let options = AgoraRtcChannelMediaOptions()
        // In video calling, set the channel use-case to communication
        options.channelProfile = .liveBroadcasting
        // Set the user role as broadcaster (default is audience)
        options.clientRoleType = .broadcaster
        // Publish audio captured by microphone
        options.publishMicrophoneTrack = true
        // Publish video captured by camera
        options.publishCameraTrack = true
        // Auto subscribe to all audio streams
        options.autoSubscribeAudio = true
        // Auto subscribe to all video streams
        options.autoSubscribeVideo = true
        // If you set uid=0, the engine generates a uid internally; on success, it triggers didJoinChannel callback
        // Join the channel with a temporary token
        agoraKit.joinChannel(
            byToken: token,
            channelId: channelID,
            uid: 0,
            mediaOptions: options
        )
    }
    
    func setupRemoteVideo(uid: UInt, view: UIView?) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = view // Assign view for joining, set to nil for leaving
        videoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    // Configure the switch camera button
    func setupSwitchCameraButton() {
        // If you're using storyboard, you can set these properties in Interface Builder
        // This is just for reference if you're creating the button programmatically
        
        // Set button image or title
        switchCameraButton.setImage(UIImage(systemName: "camera.rotate"), for: .normal)
        switchCameraButton.tintColor = .white
        
        // Add a background for better visibility
        switchCameraButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        switchCameraButton.layer.cornerRadius = 20
        
        // Add action
        switchCameraButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
    }
    
    func setUpMoreButton() {
        
        // Add a background for better visibility
        moreButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        moreButton.layer.cornerRadius = 20
        
        moreButton.tintColor = .white
    }
    
    func handelMoreUI() {
        
        if !self.moreButton.isSelected {
            self.switchCameraButton.isHidden = true
            self.muteButton.isHidden = true
            self.cameraToggleButton.isHidden = true
        } else {
            self.switchCameraButton.isHidden = false
            self.muteButton.isHidden = false
            self.cameraToggleButton.isHidden = false
        }
    }
    
    // Action to switch between front and back cameras
    @objc func switchCamera() {
        // The switchCamera method returns 0 if successful
        let result = agoraKit.switchCamera()
        
        if result == 0 {
            // Camera switched successfully
            print("Camera switched successfully")
            
            // Optional: Add visual feedback like a brief animation
            UIView.animate(withDuration: 0.3) {
                self.switchCameraButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.switchCameraButton.transform = CGAffineTransform.identity
                }
            }
        } else {
            // Failed to switch camera
            print("Failed to switch camera, error code: \(result)")
        }
    }
    
    // Action to toggle mute/unmute audio
    @objc func toggleMute() {
        isAudioMuted = !isAudioMuted
        
        // Mute/unmute the local audio
        agoraKit.muteLocalAudioStream(isAudioMuted)
        
        // Update button appearance
        updateMuteButtonAppearance()
        
        // Optional: Add visual feedback
        UIView.animate(withDuration: 0.3) {
            self.muteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.muteButton.transform = CGAffineTransform.identity
            }
        }
        
        // Provide feedback about the action
        print("Local audio \(isAudioMuted ? "muted" : "unmuted")")
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func more(_ sender: UIButton) {
        self.moreButton.isSelected.toggle()
        self.handelMoreUI()
    }
}

// Extension for handling Agora SDK callbacks
extension GSTGoLiveViewContoler: AgoraRtcEngineDelegate {
    
    // Triggered when the local user successfully joins a channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("Successfully joined channel: \(channel) with UID: \(uid)")
        self.handelMoreUI()
        self.moreButton.isHidden = false
        self.loadingLabel.isHidden = true
    }
    
    // Triggered when a remote user joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        self.remoteView.isHidden = false
        setupRemoteVideo(uid: uid, view: remoteView)
    }
    
    // Triggered when a remote user leaves the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        
        // Decrement audience count when a user leaves
        audienceCount = max(1, audienceCount - 1) // Ensure count doesn't go below 1
        updateAudienceCount()
        
        print("Remote user \(uid) left, total audience: \(audienceCount)")
        
        self.remoteView.isHidden = true
        setupRemoteVideo(uid: uid, view: nil)
    }
    
    // Triggered when user count is updated (more accurate than tracking join/leave events)
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
        // Update audience count based on the stats
        // Note: This is more accurate as it includes all users (broadcasters and audience)
        let newCount = Int(stats.userCount)
        if newCount != audienceCount {
            audienceCount = newCount
            updateAudienceCount()
            print("User count updated from stats: \(audienceCount)")
        }
    }
}

// Switch local and remote view
extension GSTGoLiveViewContoler {
    
    func setupCameraToggleButton() {
        cameraToggleButton.setImage(UIImage(systemName: "video.fill"), for: .normal)
        cameraToggleButton.tintColor = .white
        cameraToggleButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        cameraToggleButton.layer.cornerRadius = 20
        cameraToggleButton.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)
    }
    
    @objc func toggleCamera() {
        isCameraOn.toggle()
        
        agoraKit.muteLocalVideoStream(!isCameraOn)
        
        if isCameraOn {
            // Resume local preview and rendering
            let videoCanvas = AgoraRtcVideoCanvas()
            videoCanvas.view = localView
            videoCanvas.uid = 0
            videoCanvas.renderMode = .hidden
            agoraKit.setupLocalVideo(videoCanvas)
            agoraKit.startPreview()
            localVideoPlaceholderImageView.isHidden = true
        } else {
            // Stop preview and clear local view
            agoraKit.stopPreview()
            let videoCanvas = AgoraRtcVideoCanvas()
            videoCanvas.view = nil
            videoCanvas.uid = 0
            videoCanvas.renderMode = .hidden
            agoraKit.setupLocalVideo(videoCanvas)
            localVideoPlaceholderImageView.isHidden = false
        }
        
        let iconName = isCameraOn ? "video.fill" : "video.slash.fill"
        cameraToggleButton.setImage(UIImage(systemName: iconName), for: .normal)
        
        print("Camera is now \(isCameraOn ? "ON" : "OFF")")
    }
    
    func setupLocalVideoPlaceholderImage() {
        
        // Setup placeholder image view
        localVideoPlaceholderImageView = UIImageView()
        localVideoPlaceholderImageView.image = UIImage(systemName: "video.slash.fill") // use your custom image if needed
        localVideoPlaceholderImageView.tintColor = .white
        localVideoPlaceholderImageView.contentMode = .scaleAspectFit
        localVideoPlaceholderImageView.translatesAutoresizingMaskIntoConstraints = false
        localVideoPlaceholderImageView.isHidden = true // initially hidden
        localView.addSubview(localVideoPlaceholderImageView)
        
        NSLayoutConstraint.activate([
            localVideoPlaceholderImageView.centerXAnchor.constraint(equalTo: localView.centerXAnchor),
            localVideoPlaceholderImageView.centerYAnchor.constraint(equalTo: localView.centerYAnchor),
            localVideoPlaceholderImageView.widthAnchor.constraint(equalToConstant: 50),
            localVideoPlaceholderImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
