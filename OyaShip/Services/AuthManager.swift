import SwiftUI
import CryptoKit
import Security

/// Stellar wallet auth — Ed25519 keypair, Keychain storage, Friendbot funding.
@MainActor
class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var publicKey: String?
    @Published var secretKey: String?
    @Published var userRole: String?
    @Published var userId: String?
    @Published var balance: String = "0"

    private let keychainPublicKey  = "oyaship.stellar.public"
    private let keychainSecretKey  = "oyaship.stellar.secret"

    init() {
        if let pub = keychainLoad(keychainPublicKey),
           let sec = keychainLoad(keychainSecretKey) {
            publicKey       = pub
            secretKey       = sec
            isAuthenticated = true
        }
    }

    // MARK: - Wallet creation

    func createWallet() async {
        let privateKey = Curve25519.Signing.PrivateKey()
        let rawPrivate  = Data(privateKey.rawRepresentation)
        let rawPublic   = Data(privateKey.publicKey.rawRepresentation)

        let pub = stellarEncode(version: 6 << 3, payload: rawPublic)   // G...
        let sec = stellarEncode(version: 18 << 3, payload: rawPrivate) // S...

        keychainSave(key: keychainPublicKey, value: pub)
        keychainSave(key: keychainSecretKey, value: sec)

        publicKey       = pub
        secretKey       = sec

        await fundViaFriendbot(pub)
        isAuthenticated = true
    }

    // MARK: - Balance

    func fetchBalance() async {
        guard let pub = publicKey else { return }
        let urlStr = "https://horizon-testnet.stellar.org/accounts/\(pub)"
        guard let url = URL(string: urlStr),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let balances = json["balances"] as? [[String: Any]] else { return }

        if let xlm = balances.first(where: { $0["asset_type"] as? String == "native" }),
           let amount = xlm["balance"] as? String {
            balance = amount
        }
    }

    // MARK: - Role & sign out

    func setRole(_ role: String) { userRole = role }

    func signOut() {
        keychainDelete(keychainPublicKey)
        keychainDelete(keychainSecretKey)
        isAuthenticated = false
        publicKey = nil; secretKey = nil
        userRole = nil; userId = nil; balance = "0"
    }

    // MARK: - Stellar StrKey encoding

    private func stellarEncode(version: UInt8, payload: Data) -> String {
        var data = Data([version]) + payload
        let crc  = crc16(data)
        data    += Data([UInt8(crc & 0xFF), UInt8((crc >> 8) & 0xFF)])
        return base32Encode(data)
    }

    private func crc16(_ data: Data) -> UInt16 {
        var crc: UInt16 = 0x0000
        for byte in data {
            crc ^= UInt16(byte) << 8
            for _ in 0..<8 {
                crc = (crc & 0x8000) != 0 ? (crc << 1) ^ 0x1021 : crc << 1
            }
        }
        return crc
    }

    private func base32Encode(_ data: Data) -> String {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
        var result = ""; var buffer = 0; var bitsLeft = 0
        for byte in data {
            buffer = (buffer << 8) | Int(byte); bitsLeft += 8
            while bitsLeft >= 5 {
                bitsLeft -= 5
                let idx = (buffer >> bitsLeft) & 0x1F
                result.append(alphabet[alphabet.index(alphabet.startIndex, offsetBy: idx)])
            }
        }
        if bitsLeft > 0 {
            let idx = (buffer << (5 - bitsLeft)) & 0x1F
            result.append(alphabet[alphabet.index(alphabet.startIndex, offsetBy: idx)])
        }
        return result
    }

    // MARK: - Friendbot

    private func fundViaFriendbot(_ address: String) async {
        let urlStr = "https://friendbot.stellar.org?addr=\(address)"
        guard let url = URL(string: urlStr) else { return }
        _ = try? await URLSession.shared.data(from: url)
    }

    // MARK: - Keychain

    private func keychainSave(key: String, value: String) {
        let data = value.data(using: .utf8)!
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    private func keychainLoad(_ key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne,
        ]
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func keychainDelete(_ key: String) {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword, kSecAttrAccount: key]
        SecItemDelete(query as CFDictionary)
    }
}
