//
//  LocationDetailView.swift
//  SafeWalk
//
//  Created by Rahqi Sarsour on 11/1/23.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @Binding var getDirections: Bool
    
    @State private var lookAroundScene: MKLookAroundScene?
    
    var body: some View {
        VStack {
            HStack() {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(mapSelection?.placemark.name ?? "")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        
                        Spacer()
                        
                        Button {
                            show.toggle()
                            mapSelection = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.gray, Color(.systemGray6))
                        }
                        .padding(5)
                    }
                    
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }
                .padding()
                
            }
            
            if #available(iOS 17.0, *) {
                if let scene = lookAroundScene {
                    LookAroundPreview(initialScene: scene)
                        .cornerRadius(12)
                        .frame(idealHeight: 200)
                        .padding()
                } else {
                    ContentUnavailableView("No preview available", systemImage: "eye.slash")
                }
            } else {
                // Older Versions Options of Somethin
                Spacer()
                Text("Look Around Feature Unavailable")
                    .font(.headline)
                Spacer()
            }
            
            
            HStack(alignment: .bottom) {
                Button {
                    if let mapSelection {
                        mapSelection.openInMaps()
                    }
                } label: {
                    Text("Open in Maps")
                        .controlSize(.large)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(.green)
                        
                }
                .controlSize(.large)
                .padding()
                .frame(maxWidth: .infinity)

                Button {
                    getDirections = true
                    show = false
                } label: {
                    Text("In Map Directions Coming Soon")
                        .controlSize(.large)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(.blue)
//                        .controlSize(.large)
//                        .padding()
//                        .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
                .padding()
                .frame(maxWidth: .infinity)


            }
        }
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { newValue in
            fetchLookAroundPreview()
        }
    }
    
    func fetchLookAroundPreview() {
        if let mapSelection {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
}

//#Preview {
//    LocationDetailView()
//}
