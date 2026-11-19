import SwiftUI

private enum AppTheme {
    static let background = Color(red: 0.055, green: 0.055, blue: 0.07)
    static let panel = Color(red: 0.12, green: 0.12, blue: 0.15)
    static let accent = Color(red: 1.0, green: 0.36, blue: 0.12)
    static let secondary = Color.white.opacity(0.62)
}

struct RootView: View {
    @State private var phone = ""
    @State private var otp = ""
    @State private var otpRequested = false
    @State private var loggedIn = false
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            if loggedIn { mainTabs } else { loginScreen }
        }
        .preferredColorScheme(.dark)
    }

    private var loginScreen: some View {
        ScrollView {
            VStack(spacing: 22) {
                Spacer(minLength: 44)
                Image(systemName: "crown.fill")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(AppTheme.accent)
                Text("ULTRA PRO")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .tracking(2)
                Text("KING NUMBER")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .tracking(4)
                    .foregroundStyle(AppTheme.accent)
                Text("Sign in with your mobile number")
                    .foregroundStyle(AppTheme.secondary)

                VStack(alignment: .leading, spacing: 14) {
                    Text("MOBILE NUMBER").font(.caption.bold()).foregroundStyle(AppTheme.secondary)
                    HStack(spacing: 10) {
                        Text("+91").foregroundStyle(.white.opacity(0.8))
                        TextField("Enter mobile number", text: $phone)
                            .keyboardType(.phonePad)
                    }
                    .padding()
                    .background(AppTheme.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    if otpRequested {
                        Text("OTP").font(.caption.bold()).foregroundStyle(AppTheme.secondary)
                        TextField("Enter OTP", text: $otp)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(AppTheme.background)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button {
                        if otpRequested {
                            // Demo navigation only. Real verification needs the owner's backend.
                            loggedIn = true
                        } else {
                            otpRequested = true
                        }
                    } label: {
                        Text(otpRequested ? "CONTINUE (DEMO)" : "REQUEST OTP")
                            .font(.headline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppTheme.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(phone.filter(\.isNumber).count < 10 || (otpRequested && otp.isEmpty))
                    .opacity(phone.filter(\.isNumber).count < 10 || (otpRequested && otp.isEmpty) ? 0.5 : 1)
                }
                .padding(20)
                .background(AppTheme.panel)
                .clipShape(RoundedRectangle(cornerRadius: 18))

                Text("Demo interface only. OTP delivery and verification are not connected.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.secondary)
                    .multilineTextAlignment(.center)
                Spacer(minLength: 30)
            }
            .padding(.horizontal, 22)
        }
    }

    private var mainTabs: some View {
        TabView(selection: $selectedTab) {
            dashboard.tag(0).tabItem { Label("Home", systemImage: "house.fill") }
            history.tag(1).tabItem { Label("History", systemImage: "clock.arrow.circlepath") }
            profile.tag(2).tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .tint(AppTheme.accent)
    }

    private var dashboard: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Welcome to").foregroundStyle(AppTheme.secondary)
                            Text("ULTRA PRO KING").font(.title2.bold())
                        }
                        Spacer()
                        Image(systemName: "crown.fill").font(.largeTitle).foregroundStyle(AppTheme.accent)
                    }
                    .padding(.top, 22)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("YOUR DASHBOARD").font(.caption.bold()).foregroundStyle(AppTheme.secondary)
                        Text("Your account services will appear here once the owner's authorized service API is connected.")
                            .foregroundStyle(.white)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    Label("Service connection pending", systemImage: "wifi.exclamationmark")
                        .foregroundStyle(AppTheme.accent)
                        .padding()
                }
                .padding(.horizontal, 20)
            }
            .background(AppTheme.background)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var history: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: "clock.arrow.circlepath").font(.system(size: 42)).foregroundStyle(AppTheme.accent)
                Text("No history yet").font(.title3.bold())
                Text("Activity will show here when the authorized backend is connected.")
                    .foregroundStyle(AppTheme.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppTheme.background)
            .navigationTitle("History")
        }
    }

    private var profile: some View {
        NavigationStack {
            List {
                Section("Account") {
                    Label("Mobile number: \(phone)", systemImage: "phone")
                    Label("Demo account", systemImage: "person")
                }
                Section {
                    Button(role: .destructive) {
                        loggedIn = false
                        otpRequested = false
                        otp = ""
                    } label: {
                        Label("Log out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .navigationTitle("Profile")
        }
    }
}
