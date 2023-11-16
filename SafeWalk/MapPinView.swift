//
//  MapPinView.swift
//  SafeWalk
//
//  Created by Rahqi Sarsour on 11/12/23.
//

import SwiftUI
import MapKit

struct MapPinView: View {
    let annotation: GenericMapAnnotation
    let mapItem: MKMapItem?
    let coordinate: CLLocationCoordinate2D
    
    var body: some View {
//        MapAnnotation(coordinate: coordinate) {
            VStack {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
                    .background(.white)
                    .clipShape(Circle())

                Text(mapItem?.placemark.name ?? "")
                    .font(.footnote)
                    .fontWeight(.heavy)
                    .lineLimit(5)
                    .frame(width: 300)
            }
//            MapPin(coordinate: coordinate, tint: .red)
//        }
    }
}

//#Preview {
//    MapPinView()
//}
