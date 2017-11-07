@_silgen_name("swift_api_main") func c_main()
@_silgen_name("swift_api_exit") func c_exit()

@_silgen_name("swift_api_rand") func rand32() -> Int32

/// math
@_silgen_name("swift_api_sqrt") func sqrt(_ value: Double) -> Double
@_silgen_name("swift_api_pow") func pow(_ base: Double, exponent: Double) -> Double
@_silgen_name("swift_api_sin") func sin(_ value: Double) -> Double
@_silgen_name("swift_api_cos") func cos(_ value: Double) -> Double
@_silgen_name("swift_api_tan") func tan(_ value: Double) -> Double
@_silgen_name("swift_api_asin") func asin(_ value: Double) -> Double
@_silgen_name("swift_api_acos") func acos(_ value: Double) -> Double
@_silgen_name("swift_api_atan") func atan(_ value: Double) -> Double
@_silgen_name("swift_api_atan2") func atan2(y: Double, x: Double) -> Double

@_silgen_name("swift_api_log") func log(_ value: Double) -> Double
@_silgen_name("swift_api_log2") func log2(_ value: Double) -> Double
@_silgen_name("swift_api_log10") func log10(_ value: Double) -> Double
@_silgen_name("swift_api_exp") func exp(_ value: Double) -> Double


func c_exit(_ msg: String) {
	print(msg)
	c_exit()
}

func rand() -> Int {
	return Int(rand32())
}
