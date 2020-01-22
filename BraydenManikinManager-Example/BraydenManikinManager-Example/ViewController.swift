//
//  ViewController.swift
//  BraydenManikinManager-Example
//
//  Created by Mercher Olivier on 2020/01/22.
//  Copyright © 2020 innosonian. All rights reserved.
//

import UIKit
import BraydenManikinManager
import SwiftyJSON

class ViewController: UIViewController, BraydenManikinManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    
  
    
   
    
  
    var conenctedManikin:ManikinInfo?
    @IBOutlet weak var logView: UITextView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.braydenManager.getScannedPeripheral().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        if (self.braydenManager.getScannedPeripheral().count > 0) {
        let item = (self.braydenManager.getScannedPeripheral())[indexPath.item].advertisementData.localName
        cell.textLabel?.text = item
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.item
    }
    

    
    @IBOutlet weak var tableView: UITableView!
    
    var braydenManager = BraydenManikinManager()
    var selected = 0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.braydenManager.delegate = self
        self.braydenManager.scanManikin()
        self.tableView.delegate = self
        self.tableView.dataSource = self
     
    }
   
    func manikinConnected(manikin: ManikinInfo) {
        self.conenctedManikin = manikin
        logView.insertText("--- Connected to \(manikin.manikinName) ---\n")
      self.braydenManager.rtMode(manikin:  self.conenctedManikin!)

       }
  

    
    @IBAction func connect(_ sender: Any) {

        let connectedPeripheral = self.braydenManager.getScannedPeripheral()[selected]
        print("connecting to " + connectedPeripheral.advertisementData.localName!)
        self.braydenManager.connectManikin(peripheral: connectedPeripheral, manikinType: .BABY)

    }
    
    @IBAction func disconnect(_ sender: Any) {
        self.braydenManager.disconnectManikin(manikin: self.conenctedManikin!)
    }
    
    @IBAction func stop(_ sender: Any) {
        print("STOP \(self.braydenManager.getManikinConnectedList().count)")
        logView.insertText("--- Stop RT ---\n")
        if (self.braydenManager.getManikinConnectedList().count == 0) {
            return
        }
        self.braydenManager.stopRT(manikin: self.conenctedManikin!)
        self.braydenManager.postRawToAWSWith(manikinInfo: self.conenctedManikin!)
    }
    
    
    @IBAction func startBingBong(_ sender: Any) {
        print("START BINGBONG")
        logView.insertText("--- START BINGBONG ---\n")

                    self.braydenManager.rtMode(manikin:  self.conenctedManikin!)
        self.braydenManager.startBingBongVent(manikin:self.conenctedManikin!)
    }
    
    @IBAction func startRt(_ sender: Any) {
        print("START RT")
        self.braydenManager.startRT(mode: TrainningMode.CPR, manikin:  self.conenctedManikin!)
       self.braydenManager.startListeningManikin(manikin:  self.conenctedManikin!)
    }
    
    func uploadProgress(progress: Progress) {
    }
    
    func responseFromServer(data: JSON) {
        print("Response from calculation server")
        print(data)
        logView.insertText("Response from calculation server \n")
        logView.insertText("\(data)\n")
    }
    
    func statusReport(firmwareVersion: String, circuitVersion: String, battery: String, cond: String, status: String, led: String, pVersion: String) {
        print("Event : status report received")
        logView.insertText("Event : status report received\n")
        logView.insertText("FirmewareVersion: \(firmwareVersion), circuitVersion: \(circuitVersion), battery: \(battery), cond: \(cond), status: \(status), led: \(led), pVersion: \(pVersion) \n")
    }
    
    func rtDataReceive(c1: UInt8, c2: UInt8, c3: UInt8, c4: UInt8, c5: UInt8, c6: UInt8, c7: UInt8, c8: UInt8, c9: UInt8, c10: UInt8, cRate: UInt8, cCnt: UInt8, pos: UInt8, r1: UInt8, r2: UInt8, rSpd: UInt8, rCnt: UInt8, seq: UInt8) {
        print("Event : RT data received")
        logView.insertText("Event : RT data received\n")
        logView.insertText("c1: \(c1), c2 \(c2), c3 \(c3), c4 \(c4), c5 \(c5), c6 \(c6), c7 \(c7), c8 \(c8), c9 \(c9), c10 \(c10), cRate \(cRate), cCnt \(cCnt), pos \(pos), r1 \(r1), r2 \(r2), rSpd \(rSpd), rCnt \(rCnt), seq \(seq)\n")
        
    }
    
    func calibrationReport(cGnd: UInt8, cXmm: UInt8, cYmm: UInt8, rGnd: UInt8, xml: UInt8, yml: UInt8, cl: UInt8, ch: UInt8, rl: UInt8, rh: UInt8) {
        print("Event : Calibration event received")
        logView.insertText("Event : Calibration event received")
        logView.insertText("cGnd \(cGnd), cXmm \(cXmm), cYmm \(cYmm), rGnd \(rGnd), xml \(xml), yml \(yml), cl \(cl), ch \(ch), rl \(rl), rh \(rh) \n")
        
    }
    
    func rtPacketStore(hexArray: [UInt8]) {
        print("Event : PacketStored")
        logView.insertText("Event : PacketStored\n")
        logView.insertText("\(hexArray) \n")
    }
    
    func newScannedPeripheral() {
        print("Event : New device scanned !")
        logView.insertText("Event : New device scanned !\n")
        self.tableView.reloadData()
    }
    
    func rtDataReceiveSimplified(data: JSON) {
        print("Simplifyed RT Data")
        print(data)
        logView.insertText("Simplifyed RT Data \n")
        logView.insertText("\(data)\n")
    }
    
    
}

