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
            VStack(alignment: .center) {
                Text("Add Report").font(.title).fontWeight(.heavy)
                Text("See something new? Put it on the map.").font(.subheadline).fontWeight(.light)
            }
        }
        
        VStack(alignment: .center, content: {
            Spacer()
            HStack(content: {
                Spacer()
                Button {
//Report(id: "D4181B37-995F-47F5-9EF6-D56424D23B43", lastUpdatedByPhoneId: Optional("07F37803-5305-44D6-9A5A-48B3F29266BD"), reportType: Optional("Police"), latitude: Optional("40.727155"), longitude: Optional("-74.06269"), timeStamp: Optional("10/3/2023, 8:11 PM"), negatedCounter: Optional(1), createdAt: Optional(Amplify.Temporal.DateTime(foundationDate: 2023-10-04 00:11:33 +0000)), updatedAt: Optional(Amplify.Temporal.DateTime(foundationDate: 2023-10-04 00:22:38 +0000)))
//               LONG     -74.06269
//               LAT     40.727155
                    // Work Cords: Optional(<+40.72780268,-74.03566148> +/- 35.00m (speed -1.00 mps / course -1.00) @ 10/4/23, 1:23:55 PM Eastern Daylight Time)

                    var exists  = false
                    
  
                    self.reports?.forEach({ report in
                        print(report)
                        if (report.reportType=="Police") {
                            guard let lat = report.latitude else {exists=true; return;}
                            guard let long = report.longitude else {exists=true; return;}
//                            print(CLLocationDegrees(long)!)
//                            print(CLLocationDegrees(lat)!)
//                            print(coordinates.longitude)
//                            print(coordinates.latitude)
//                            print("FUCK")
//                            print((CLLocationDegrees(long)!  < coordinates.longitude + 0.005 && CLLocationDegrees(long)!  > coordinates.longitude - 0.005 && CLLocationDegrees(lat)! < coordinates.latitude + 0.005 && CLLocationDegrees(lat)! > coordinates.latitude - 0.005))
                            if (CLLocationDegrees(long)!  < coordinates.longitude + 0.001 && CLLocationDegrees(long)!  > coordinates.longitude - 0.001 && CLLocationDegrees(lat)! < coordinates.latitude + 0.001 && CLLocationDegrees(lat)! > coordinates.latitude - 0.001) {
                                exists = true
                                showBanner = true
                            }
                            
                        }
                            
                    })

                    
                    if (!exists) {
//                        print("FUCK NO EXISTS")
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
                            guard let lat = report.latitude else {return;}
                            guard let long = report.longitude else {return;}
                            if (CLLocationDegrees(long)!  < coordinates.longitude + 0.001 && CLLocationDegrees(long)!  > coordinates.longitude - 0.001 && CLLocationDegrees(lat)! < coordinates.latitude + 0.001 && CLLocationDegrees(lat)! > coordinates.latitude - 0.001) {
                                exists = true
                                showBanner = true
                            }
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
                            guard let lat = report.latitude else {return;}
                            guard let long = report.longitude else {return;}
                            if (CLLocationDegrees(long)!  < coordinates.longitude + 0.001 && CLLocationDegrees(long)!  > coordinates.longitude - 0.001 && CLLocationDegrees(lat)! < coordinates.latitude + 0.001 && CLLocationDegrees(lat)! > coordinates.latitude - 0.001) {
                                exists = true
                                showBanner = true
                            }
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
                            guard let lat = report.latitude else {return;}
                            guard let long = report.longitude else {return;}
                            if (CLLocationDegrees(long)!  < coordinates.longitude + 0.001 && CLLocationDegrees(long)!  > coordinates.longitude - 0.001 && CLLocationDegrees(lat)! < coordinates.latitude + 0.001 && CLLocationDegrees(lat)! > coordinates.latitude - 0.001) {
                                exists = true
                                showBanner = true
                            }
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
                            guard let lat = report.latitude else {return;}
                            guard let long = report.longitude else {return;}
                                                        print(CLLocationDegrees(long)!)
                                                        print(CLLocationDegrees(lat)!)
                                                        print(coordinates.longitude)
                                                        print(coordinates.latitude)
                            if (CLLocationDegrees(long)!  < coordinates.longitude + 0.001 && CLLocationDegrees(long)!  > coordinates.longitude - 0.001 && CLLocationDegrees(lat)! < coordinates.latitude + 0.001 && CLLocationDegrees(lat)! > coordinates.latitude - 0.001) {
                                exists = true
                                showBanner = true
                            }
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
        .banner(data: $bannerData, show: $showBanner)
    

        
    }
    
    
    private func getReports(coordinate: CLLocationCoordinate2D, completion: (() -> ())) {
        let reports = Report.keys
        Amplify.Publisher.create(
            Amplify.DataStore.observeQuery(
                for: Report.self,
                where: reports.longitude > coordinate.longitude + 0.005 && reports.longitude < coordinate.longitude - 0.005
                && reports.latitude < coordinate.latitude + 0.005 && reports.latitude > coordinate.latitude - 0.005
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
