//
//  MapOverlay.swift
//  SafeWalk
//
//  Created by Rahqi Sarsour on 10/30/23.
//

import SwiftUI
import MapKit

struct MapOverlayView: View {
    var locationManager = LocationManager.shared
    @Binding var searchResults: [MKMapItem]
    
    @Binding var searchText: String
    
    @State var showAddReport = false
    @State var reports: [Report]?
    
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            HStack(spacing: 10, content: {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.gray)
//                        .frame(minWidth: 0, alignment: .leading)
                    TextField("Search Maps", text: $searchText)
                        .font(.headline)
                        .background(.clear)
                        .foregroundStyle(.primary)
                        .shadow(radius: 10)
                        .controlSize(.large)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading, 10)
                        .padding(.trailing, 110)
                        .lineLimit(1)
                        .onChange(of: searchText, perform: { text in
                            print(self.searchText)
                        })
                        .onSubmit(of: .text, {
                            Task { await searchPlaces() }
                        })
                        
                
                //                .controlSize(.extraLarge)
            })
            .padding(.top, 15)
            
        }
            Spacer()
    }
    
    
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        
        //var res: [MKMapItem]?
        request.naturalLanguageQuery = self.searchText
        
        let results = try? await MKLocalSearch(request: request).start()
        self.searchResults = results?.mapItems ?? []
        
    }
}

        

//#Preview {
//    MapOverlayView(reports: [])
//}
