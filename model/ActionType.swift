public enum ActionType: Int8, RawByteRepresentable {
	case unknown = -1
	case none = 0
	case clearAndSelect = 1
	case addToSelection = 2
	case deselect = 3
	case assign = 4
	case dismiss = 5
	case disband = 6
	case move = 7
	case rotate = 8
	case setupVehicleProduction = 9
}
