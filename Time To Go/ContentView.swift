//
//  ContentView.swift
//  Time To Go
//
//  Created by Joshua McKinnon on 2/7/2022.
//

import SwiftUI
import CoreData
import MapKit
import CoreLocationUI


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) var scenePhase

    @StateObject var locationManager = LocationManager()

    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        ZStack(alignment: .bottom) {
        Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .constant(.follow))
            //            .frame(width: 400, height: 300)
            .edgesIgnoringSafeArea(.all)
            VStack {
                if let locationJJM = locationManager.locationForMap {
                                    Text("**Current location:** \(locationJJM.latitude), \(locationJJM.longitude)")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(.gray)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Spacer()
                    LocationButton {
                                    locationManager.requestLocation()
                                }
                                .frame(width: 180, height: 40)
                                .cornerRadius(30)
                                .symbolVariant(.fill)
                                .foregroundColor(.white)
                            }
                            .padding()
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                locationManager.requestAlwaysAuthorization()
            }
        }

    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
