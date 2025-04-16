import SwiftUI
import Utilities

struct MenuAwardsScreen: View {
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible())
    ]
    
    let awardsFirst = [
        AwardModel(
            title: "Дипломы предприятия «Золотое шитье»",
            image: Image(.nagorodi001),
            bgColor: .black
        ),
        AwardModel(
            title: "Орден «Святой Софии»",
            image: Image(.nagorodi002)
        ),
        AwardModel(
            title: "Орден «Святой Равноапостольной кн. Ольги» III ст.",
            image: Image(.nagorodi003)
        ),
        AwardModel(
            title: "Орден «За высокое качество»",
            image: Image(.nagorodi004)
        ),
        AwardModel(
            title: "Орден «За выдающиеся достижения»",
            image: Image(.nagorodi005)
        ),
        AwardModel(
            title: "Орден «Св. Равноап. кн. Владимира» II ст.",
            image: Image(.nagorodi006)
        ),
        AwardModel(
            title: "«Лидер отрасли»",
            image: Image(.nagorodi007)
        )
    ]
    
    let awardsSecond = [
        AwardModel(
            title: "Медаль «За выдающиеся достижения»",
            image: Image(.nagorodi008)
        ),
        AwardModel(
            title: "Медаль «За выдающиеся достижения» 1994 г.",
            image: Image(.nagorodi009)
        ),
        AwardModel(
            title: "Медаль «За выдающиеся достижения» 2005 г.",
            image: Image(.nagorodi010)
        ),
        AwardModel(
            title: "Медаль «Золотая книга",
            image: Image(.nagorodi011)
        ),
        AwardModel(
            title: "Медаль «За выдающиеся достижения» 2004 г.",
            image: Image(.nagorodi012)
        ),
    ]
    
    var body: some View {
		ScrollView {
			LazyVGrid(columns: columns, spacing: 10) {
				ForEach(awardsFirst) { award in
					awardView(award)
				}
			}
			.padding(.horizontal, 16)
			
			HStack {
				Text("Наградные медали предприятия")
					.font(.system(size: 17, weight: .semibold))
				
				Spacer()
			}
			.padding(.top, 18)
			.padding(.horizontal, 16)
			
			LazyVGrid(columns: columns, spacing: 10) {
				ForEach(awardsSecond) { award in
					awardView(award)
				}
			}
			.padding(.horizontal, 16)
		}
        .navigationTitle("Награды")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func awardView(_ award: AwardModel) -> some View {
        VStack {
            ZStack {
                award.bgColor
                award.image
                    .resizable()
                    .scaledToFit()
            }
            
            Text(award.title)
                .multilineTextAlignment(.center)
                .font(.system(size: 12))
                .padding([.horizontal, .bottom], 8)
                .padding(.top, 4)
                .frame(height: 60, alignment: .center)
        }
        .frame(height: 168)
        .clipShape(.rect(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(0xE5E5EA), lineWidth: 1)
        }
    }
}

public struct AwardModel: Identifiable {
    public var id: String { title }
    let title: String
    let image: Image
    let bgColor: Color
    
    public init(
        title: String,
        image: Image,
        bgColor: Color = Color(0x780001)
    ) {
        self.title = title
        self.image = image
        self.bgColor = bgColor
    }
}

#Preview {
    NavigationStack {
        MenuAwardsScreen()
    }
}
