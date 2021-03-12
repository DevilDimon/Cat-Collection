enum StringUtils {
	static func emojiFlag(from countryCode: String) -> String {
		let base: UInt32 = 127397
		var result = ""
		result.unicodeScalars += countryCode
				.uppercased()
				.unicodeScalars
				.compactMap { UnicodeScalar(base + $0.value) }
		return result
	}
}
