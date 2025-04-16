import Constants
import MapKit
import SwiftUI

struct MenuContactsScreen: View {
	
	@State private var position = MapCameraPosition.automatic
	
    var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			VStack(alignment: .leading, spacing: 5) {
        		Text("Адрес")
					.font(.system(size: 17, weight: .semibold))
				
				Text(verbatim: "Мы находимся на Украине по адресу: 25006, г.Кропивницкий, ул.Михайловская, 73, ХПП\u{00A0}«Золотое шитье».")
        	}
			
			divider
			
			VStack(alignment: .leading, spacing: 5) {
				Text("Телефон")
					.font(.system(size: 17, weight: .semibold))
				// TODO: Add link
				Text("+38 (050) 525-45-67")
					.underline()
					.foregroundStyle(Color(0x871A1A))
			}
			
			divider
			
			VStack(alignment: .leading, spacing: 5) {
				Text("Сайт")
					.font(.system(size: 17, weight: .semibold))
				Text("www.zolotoe-shitvo.kr.ua")
					.underline()
					.tint(Color(0x871A1A))
			}
			
			divider
			
			VStack(alignment: .leading, spacing: 5) {
				Text("Email")
					.font(.system(size: 17, weight: .semibold))
				// TODO: Add link
				Text("info@zolotoe-shitvo.kr.ua")
					.underline()
					.tint(Color(0x871A1A))
			}
			
			divider
			
			Map(position: $position, interactionModes: []) {
				Marker("ХПП «Золотое шитье»", coordinate: MapConstants.coordinate)
					.tint(Color(0x871A1A))
			}
			.mapStyle(.hybrid)
			.cornerRadius(16)
			.onAppear {
				withAnimation {
					position = .region(MapConstants.region)
				}
			}
			.onTapGesture {
				guard UIApplication.shared.canOpenURL(MapConstants.url!) else { return }
				UIApplication.shared.open(MapConstants.url!)
			}
			
			HStack { Spacer() }
        }
		.padding(.horizontal, 16)
		.padding(.top, 16)
    }
	
	private var divider: some View {
		Rectangle()
			.fill(Color(0xC6C6C8))
			.frame(height: 0.5)
	}
}

#Preview {
    NavigationStack {
        MenuContactsScreen()
    }
}
