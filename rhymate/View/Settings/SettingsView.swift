import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    VStack(alignment:.leading){
                        Text("This is a settings view")
                    }
                }
            }
            .navigationTitle("settings")
            .padding()
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .leading
            )
        }
    };
    
}

#Preview {
    SettingsView()
}
