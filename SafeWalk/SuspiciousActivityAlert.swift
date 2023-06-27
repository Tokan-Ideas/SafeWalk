//
//  SuspiciousActivityAlert.swift
//  SafeWalk
//
//  Created by Riyad Sarsour on 6/26/23.
//

struct SuspiciousActivityAlert: View {
    @EnvironmentObject private var locationManager: LocationManager
    @State private var showAlert = false

    var body: some View {
        VStack {
            if locationManager.isSuspiciousActivityNearby {
                Text("Suspicious Activity Reported Nearby!")
                    .font(.headline)
                    .padding()

                if locationManager.isCloseToSuspiciousActivity {
                    Text("Confirm if activity is still present:")
                        .font(.subheadline)
                        .padding()

                    Button("Yes") {
                        // Handle confirmation logic when suspicious activity is confirmed
                    }
                    .padding()
                    .foregroundColor(.green)

                    Button("No") {
                        // Handle confirmation logic when suspicious activity is not present
                    }
                    .padding()
                    .foregroundColor(.red)
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Suspicious Activity Reported"), message: Text("Please be cautious and confirm if the activity is still present."), dismissButton: .default(Text("OK")))
        }
        .onReceive(locationManager.$isSuspiciousActivityNearby) { isSuspiciousActivityNearby in
            showAlert = isSuspiciousActivityNearby
        }
    }
}

