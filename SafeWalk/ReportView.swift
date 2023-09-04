//
//  ReportView.swift
//  SafeWalk
//
//  Created by Rahqi T. Sarsour on 6/28/23.
//

import SwiftUI
import Amplify
import AWSDataStorePlugin

import CoreLocation
import Combine


struct ReportView: View {
    @Environment(\.dismiss) var dismiss
    var coordinates: CLLocationCoordinate2D
    @State var reports: [Report]?
    @State var reportSupscription: AnyCancellable?
    
    @State var showBanner:Bool = false
    @State var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "Report Already Exists Nearby", detail: "Looks like someone saw the same thing as you nearby. You can update their report in the map.", level: .Error)
        
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

                    var exists  = false
                    self.reports?.forEach({ report in
                        if (report.reportType=="Police") {
                            exists = true
                            showBanner = true
                        }
                            
                    })

                    
                    if (!exists) {
                        let saveSink = Amplify.Publisher.create {
                            try await Amplify.DataStore.save(
                                Report(lastUpdatedByPhoneId: UIDevice.current.identifierForVendor!.uuidString, reportType: "Police", latitude: LocationManager.shared.lastKnownLocation?.coordinate.latitude.formatted(), longitude: LocationManager.shared.lastKnownLocation?.coordinate.longitude.formatted(), timeStamp: Date.now.formatted(), negatedCounter: 0)
                            )}.sink {
                                if case let .failure(error) = $0 {
                                    print("Error updating post - \(error.localizedDescription)")
                                }
                            } receiveValue: {
                                print("Updated the existing post: \($0)")
                            }
                    }
                    
                    if(!showBanner) {
                            dismiss()
                    }
                    
         
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

                    var exists  = false
                    self.reports?.forEach({ report in
                        if (report.reportType=="NoLights") {
                            exists = true
                            showBanner = true
                        }
                            
                    })

                    
                    if (!exists) {
                        let saveSink = Amplify.Publisher.create {
                            try await Amplify.DataStore.save(
                                Report(lastUpdatedByPhoneId: UIDevice.current.identifierForVendor!.uuidString, reportType: "NoLights", latitude: LocationManager.shared.lastKnownLocation?.coordinate.latitude.formatted(), longitude: LocationManager.shared.lastKnownLocation?.coordinate.longitude.formatted(), timeStamp: Date.now.formatted(), negatedCounter: 0)
                            )}.sink {
                                if case let .failure(error) = $0 {
                                    print("Error updating post - \(error.localizedDescription)")
                                }
                            } receiveValue: {
                                print("Updated the existing post: \($0)")
                            }
                    }
                    
                    if(!showBanner) {
                            dismiss()
                    }
                   
                    
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

                    var exists  = false
                    self.reports?.forEach({ report in
                        if (report.reportType=="SuspiciousActivity") {
                            exists = true
                            showBanner = true
                        }
                            
                    })

                    
                    if (!exists) {
                        let saveSink = Amplify.Publisher.create {
                            try await Amplify.DataStore.save(
                                Report(lastUpdatedByPhoneId: UIDevice.current.identifierForVendor!.uuidString, reportType: "SuspiciousActivity", latitude: LocationManager.shared.lastKnownLocation?.coordinate.latitude.formatted(), longitude: LocationManager.shared.lastKnownLocation?.coordinate.longitude.formatted(), timeStamp: Date.now.formatted(), negatedCounter: 0)
                            )}.sink {
                                if case let .failure(error) = $0 {
                                    print("Error updating post - \(error.localizedDescription)")
                                }
                            } receiveValue: {
                                print("Updated the existing post: \($0)")
                            }
                    }
                    
                    if(!showBanner) {
                            dismiss()
                    }
                   
                    
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

                    var exists  = false
                    self.reports?.forEach({ report in
                        if (report.reportType=="Construction") {
                            exists = true
                            showBanner = true
                        }
                            
                    })

                    
                    if (!exists) {
                        let saveSink = Amplify.Publisher.create {
                            try await Amplify.DataStore.save(
                                Report(lastUpdatedByPhoneId: UIDevice.current.identifierForVendor!.uuidString, reportType: "Construction", latitude: LocationManager.shared.lastKnownLocation?.coordinate.latitude.formatted(), longitude: LocationManager.shared.lastKnownLocation?.coordinate.longitude.formatted(), timeStamp: Date.now.formatted(), negatedCounter: 0)
                            )}.sink {
                                if case let .failure(error) = $0 {
                                    print("Error updating post - \(error.localizedDescription)")
                                }
                            } receiveValue: {
                                print("Updated the existing post: \($0)")
                            }
                    }
                    
                    if(!showBanner) {
                            dismiss()
                    }
                   
                    
                } label: {
                    VStack {
                        Image("ReportView_Construction")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("Closed Sidewalk")
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

                    var exists  = false
                    self.reports?.forEach({ report in
                        if (report.reportType=="FootTraffic") {
                            exists = true
                            showBanner = true
                        }
                            
                    })

                    
                    if (!exists) {
                        let saveSink = Amplify.Publisher.create {
                            try await Amplify.DataStore.save(
                                Report(lastUpdatedByPhoneId: UIDevice.current.identifierForVendor!.uuidString, reportType: "FootTraffic", latitude: LocationManager.shared.lastKnownLocation?.coordinate.latitude.formatted(), longitude: LocationManager.shared.lastKnownLocation?.coordinate.longitude.formatted(), timeStamp: Date.now.formatted(), negatedCounter: 0)
                            )}.sink {
                                if case let .failure(error) = $0 {
                                    print("Error updating post - \(error.localizedDescription)")
                                }
                            } receiveValue: {
                                print("Updated the existing post: \($0)")
                            }
                    }
                    
                    if(!showBanner) {
                            dismiss()
                    }
                    
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

        .banner(data: $bannerData, show: $showBanner)
    }
    
    
    private func getReports(coordinate: CLLocationCoordinate2D, completion: (() -> ())) {
        let reports = Report.keys
        Amplify.Publisher.create(
            Amplify.DataStore.observeQuery(
                for: Report.self,
                where: reports.longitude > coordinate.longitude + 0.01 && reports.longitude < coordinate.longitude - 0.01
                && reports.latitude < coordinate.latitude + 0.01 && reports.latitude > coordinate.latitude - 0.01
                && reports.negatedCounter < 2
            )
        )
        .sink {
            if case .failure(let error) = $0 {
                print("Error \(error)")
            }
        } receiveValue: { querySnapshot in
            
            self.reports = querySnapshot.items
            
        }
    }
}



//struct ReportView_Previews: PreviewProvider {
//    static var previews: some View {
//       ReportView()
//    }

//}
