//
//  ReportView.swift
//  SafeWalk
//
//  Created by Rahqi T. Sarsour on 6/28/23.
//

import SwiftUI
import Amplify
import AWSDataStorePlugin

struct ReportView: View {
    @Environment(\.dismiss) var dismiss
    //@State private var isSheetPresented = false
    var body: some View {
        HStack(alignment: .center) {
            Text("Update Map").font(.title).fontWeight(.heavy)
        }
        
        VStack(alignment: .center, content: {
            Spacer()
            HStack(content: {
                Spacer()
                Button {
                    
         
                    let saveSink = Amplify.Publisher.create {
                        try await Amplify.DataStore.save(
                            Report(lastUpdatedByPhoneId: nil, reportType: "Police", latitude: LocationManager.shared.lastKnownLocation?.coordinate.latitude.formatted(), longitude: LocationManager.shared.lastKnownLocation?.coordinate.longitude.formatted(), timeStamp: Date.now.formatted(), negatedCounter: 0)
                        )}.sink {
                            if case let .failure(error) = $0 {
                                print("Error updating post - \(error.localizedDescription)")
                            }
                        } receiveValue: { 
                            print("Updated the existing post: \($0)")
                            
                        }
                    dismiss()
                } label: {
                    VStack() {
                        Image("ReportView_Police")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("Police")
                            .font(.subheadline)
                    }
                }
                
                Spacer()
                Button {
                    print("No Lights")
                    let saveSink = Amplify.Publisher.create {
                        try await Amplify.DataStore.save(
                            Report(lastUpdatedByPhoneId: nil, reportType: "NoLights", latitude: LocationManager.shared.lastKnownLocation?.coordinate.latitude.formatted(), longitude: LocationManager.shared.lastKnownLocation?.coordinate.longitude.formatted(), timeStamp: Date.now.formatted(), negatedCounter: 0)
                        )}.sink {
                            if case let .failure(error) = $0 {
                                print("Error updating post - \(error.localizedDescription)")
                            }
                        } receiveValue: {
                            print("Updated the existing post: \($0)")
                            
                        }
                    dismiss()
                } label: {
                    VStack {
                        Image("ReportView_NoLights")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("No Street Lights")
                            .font(.subheadline)
                    }
                }
                Spacer()
                
            })
            .padding(.top, 20)
            Spacer()
            HStack(content: {
                Spacer()
                Button {
                    print("Suspicious Activity")
                    let saveSink = Amplify.Publisher.create {
                        try await Amplify.DataStore.save(
                            Report(lastUpdatedByPhoneId: nil, reportType: "SuspiciousActivity", latitude: LocationManager.shared.lastKnownLocation?.coordinate.latitude.formatted(), longitude: LocationManager.shared.lastKnownLocation?.coordinate.longitude.formatted(), timeStamp: Date.now.formatted(), negatedCounter: 0)
                        )}.sink {
                            if case let .failure(error) = $0 {
                                print("Error updating post - \(error.localizedDescription)")
                            }
                        } receiveValue: {
                            print("Updated the existing post: \($0)")
                            
                        }
                    dismiss()
                } label: {
                    VStack {
                        Image("ReportView_Suspicious")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("Suspicious Activity")
                            .font(.subheadline)
                    }
                }
                Spacer()
                Button {
                    print("Construction or closed Sidewalk")
                    let saveSink = Amplify.Publisher.create {
                        try await Amplify.DataStore.save(
                            Report(lastUpdatedByPhoneId: nil, reportType: "Construction", latitude: LocationManager.shared.lastKnownLocation?.coordinate.latitude.formatted(), longitude: LocationManager.shared.lastKnownLocation?.coordinate.longitude.formatted(), timeStamp: Date.now.formatted(), negatedCounter: 0)
                        )}.sink {
                            if case let .failure(error) = $0 {
                                print("Error updating post - \(error.localizedDescription)")
                            }
                        } receiveValue: {
                            print("Updated the existing post: \($0)")
                            
                        }
                    dismiss()
                } label: {
                    VStack {
                        Image("ReportView_Construction")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("Construction/Closed Sidewalk")
                            .font(.subheadline)
                    }
                }
                Spacer()
            })
            Spacer()
            HStack(content: {
                Spacer()
                Button {
                    print("Busy Area")
                    let saveSink = Amplify.Publisher.create {
                        try await Amplify.DataStore.save(
                            Report(lastUpdatedByPhoneId: nil, reportType: "FootTraffic", latitude: LocationManager.shared.lastKnownLocation?.coordinate.latitude.formatted(), longitude: LocationManager.shared.lastKnownLocation?.coordinate.longitude.formatted(), timeStamp: Date.now.formatted(), negatedCounter: 0)
                        )}.sink {
                            if case let .failure(error) = $0 {
                                print("Error updating post - \(error.localizedDescription)")
                            }
                        } receiveValue: {
                            print("Updated the existing post: \($0)")
                            
                        }
                    dismiss()
                } label: {
                    VStack {
                        Image("ReportView_Crowded")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("High Foot Traffic")
                    }
                }
                Spacer()
    
            })
            Spacer()
            HStack(alignment: .bottom, content: {
                Button("Close") {
                    dismiss()
                }
            })
            .padding()
            
        })
        .padding()
    }
}

//#Preview {
//    ReportView()
//}
