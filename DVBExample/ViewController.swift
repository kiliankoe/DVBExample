//
//  ViewController.swift
//  DVBExample
//
//  Created by Kilian Költzsch on 27/02/2017.
//  Copyright © 2017 Kilian Koeltzsch. All rights reserved.
//

import UIKit
import DVB

class ViewController: UITableViewController {

    let STOP_NAME = "Albertplatz"

    var departures: [Departure]? {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))

        self.navigationItem.title = STOP_NAME
        refresh()
    }

    func refresh() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Departure.monitor(stopWithName: STOP_NAME) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            guard let response = result.success else { return }
            self.departures = response.departures
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let departures = departures else { return 0 }
        return departures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departureCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "departureCell")

        guard let departures = departures else { return cell }

        let departure = departures[indexPath.row]

        cell.textLabel?.text = "\(departure.line) \(departure.direction)"
        cell.detailTextLabel?.text = departure.fancyEta
        cell.detailTextLabel?.textColor = departure.state == .delayed ? .red : .black
//        cell.imageView?.image = UIImage(named: departure.mode.dvbIdentifier)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
