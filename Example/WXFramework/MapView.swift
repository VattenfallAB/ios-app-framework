//
//  MapView.swift
//  App framework
//
//  Created by Artur Gurgul on 02/09/2020.
//  Copyright © 2020 Winux-ORG. All rights reserved.
//

import UIKit
import MapKit
import SwiftUI


let mapView = MKMapView()

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}
