//
//  PhoneInput.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

struct PhoneInput: View {
    @ObservedObject private var phoneNumber = PhoneInputObserver()
    @State private var place: String = "🇻🇳" + "+84"
    @State private var searchRegion: String = ""
    @State private var isPresentPicker = false
    @State var isPushWebView: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, content: {
                Text("Nhập số điện thoại").bold()
                HStack {
                    Button(action: {
                        isPresentPicker.toggle()
                    }, label: {
                        HStack {
                            Text(place)
                                .padding(.leading, 10)
                                .foregroundColor(.red)
                        }
                    })
                    Rectangle()
                        .frame(width: 1, height: 45.scaleH)
                        .foregroundColor(Color(hex: "#34ADB1"))
                    TextField("000-000-000", text: $phoneNumber.phoneNumber)
                        .padding(.leading, 10)
                }
                .frame(width: 300.scaleW, alignment: .center)
                .overlay(RoundedRectangle(cornerRadius: 45.scaleH)
                    .stroke(Color(hex: "#34ADB1"), lineWidth: 1))
                Spacer()
            })

            VStack(alignment: .center, spacing: nil, content: {
                LinkedText("Bằng việc chọn tiếp tục, bạn đã đồng ý với https://www.hackingwithswift.com/articles/216/complete-guide-to-navigationview-in-swiftui của CoCo", linkName: "Điều khoản & Điều kiện")
                    .font(.system(size: 12))
                NavigationLink(
                    destination: VerifiCode(phoneNumber: phoneNumber.phoneNumber),
                    label: {
                        Text("Tiep Tuc")
                            .foregroundColor(.white)
                            .frame(width: 300.scaleW, height: 25.scaleH, alignment: .center)
                            .padding(.all, 10)
                            .background( phoneNumber.isReadyToPush == true ? Color(hex: "#34ADB1"): Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 25.scaleH))
                            .allowsHitTesting(phoneNumber.isReadyToPush)
                    })
            })
            Spacer().frame(height: 50.scaleH)
        }
        .sheet(isPresented: $isPresentPicker, content: {
            pickerPlaceView()
        })
        .onAppear(perform: {
            let content = UNMutableNotificationContent()
            content.title = "Feed the cat"
            content.subtitle = "It looks hungry"
            content.sound = UNNotificationSound.default

            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
        })
    }

    func pickerPlaceView() -> some View {
        return VStack {
            HStack(alignment: .center, spacing: nil, content: {
                Text(place)
                    .foregroundColor(.red)
                Spacer()
                TextField("Search Region", text: $searchRegion)
                    .frame(width: 150, alignment: .center)
                Spacer()
                Button(action: {
                    isPresentPicker.toggle()
                }, label: {
                    Text("Done")
                })
            })

            if searchRegion.isEmpty {
                Picker(selection: $place, label: Text("Place"), content: {
                    ForEach(areaCodes, id: \.place) { i in
                        Text(i.regionName + ": " + i.place)
                    }
                })
            } else {
                List {
                    let places = areaCodes.filter { (RegionFlag) -> Bool in
                        RegionFlag.regionName.contains(searchRegion)
                    }

                    ForEach(places, id: \.regionName) { i in
                        Button(action: {
                            searchRegion = ""
                            place = i.place
                        }, label: {
                            Text("\(i.regionName)")
                        })
                    }
                }
            }
        }
    }
}

struct PhoneInput_Previews: PreviewProvider {
    static var previews: some View {
        PhoneInput()
    }
}
