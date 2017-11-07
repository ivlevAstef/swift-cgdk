public typealias Byte = Int8

@_silgen_name("css_open") private func c_css_open(_ host: UnsafePointer<UInt8>, port: Int32) -> Int16
@_silgen_name("css_close") private func c_css_close(_ index: Int16) -> Void
@_silgen_name("css_send") private func c_css_send(_ index: Int16, _ buff: UnsafePointer<Byte>, len: UInt32)
@_silgen_name("css_read") private func c_css_read(_ index: Int16, _ buff: UnsafePointer<Byte>, len: UInt32)


final public class TCPClient {
	public let address: String
	public let port: Int32
	private var index: Int16 = -1
	
	public init(address: String, port: Int32) {
		self.address = address
		self.port = port
	}
	
	public func connect() -> Bool {
		index = c_css_open(address, port: port)
		return index >= 0
	}
	
	public func close() {
		assert(index >= 0)
		c_css_close(index)
	}
	
	public func write(bytes: [Byte]) {
		assert(index >= 0)
		c_css_send(index, bytes, len: UInt32(bytes.count))
	}
	
	public func readBytes(_ expectlen: Int) -> [Byte] {
		assert(index >= 0)
		var buff = [Byte](repeating: 0x0, count: expectlen)
		
		c_css_read(index, &buff, len: UInt32(expectlen))
		return buff
	}
}

public protocol RawByteRepresentable {
	init?(rawValue: Byte)
	
	var rawValue: Byte { get }
}

/// base function for read types
public extension TCPClient {
	
	public func readString() -> String {
		return String(cString: readByteArray().map{ UInt8(bitPattern: $0) })
	}
	
	public func write(string: String) {
		write(byteArray: string.utf8.map{ Byte(bitPattern: $0) })
	}
	
	
	
	public func readByte() -> Byte {
		return readBytes(1)[0]
	}
	
	public func write(byte: Byte) {
		write(bytes: [byte])
	}
	
	
	
	public func readBool() -> Bool {
		return readByte() != 0
	}
	
	public func write(bool value: Bool) {
		write(byte: Byte(value ? 1: 0))
	}
	
	
	
	public func readInt32() -> Int32 {
		return Int32(littleEndian: fromByteArray(readBytes(MemoryLayout<Int32>.size)))
	}
	
	public func write(int32 value: Int32) {
		write(bytes: toByteArray(value.littleEndian))
	}
	
	
	public func readInt() -> Int {
		return Int(readInt32())
	}
	
	public func write(int value: Int) {
		write(int32: Int32(value))
	}
	
	
	
	public func readLong() -> Int64 {
		return Int64(littleEndian: fromByteArray(readBytes(MemoryLayout<Int64>.size)))
	}
	
	public func write(long value: Int64) {
		write(bytes: toByteArray(value.littleEndian))
	}
	
	
	
	public func readDouble() -> Double {
		return fromByteArray(toByteArray(readLong())) as Double
	}
	
	public func write(double value: Double) {
		write(long: fromByteArray(toByteArray(value)) as Int64)
	}
	
	
	
	public func readByteArray() -> [Byte] {
		let count = readInt()
		if count <= 0 {
			return []
		}
		return readBytes(count)
	}
	
	public func write(byteArray: [Byte]) {
		if byteArray.isEmpty {
			write(int: -1)
			return
		}
		
		write(int: byteArray.count)
		write(bytes: byteArray)
	}
	
	
	
	public func readInts() -> [Int] {
		let count = readInt()
		if count <= 0 {
			return []
		}
		
		return (0..<count).map{ _ in readInt() }
	}
	
	public func write(ints: [Int]) {
		if ints.isEmpty {
			write(int: -1)
			return
		}
		
		write(int: ints.count)
		ints.forEach { write(int: $0) }
	}
	
	
	
	public func readInts2D() -> [[Int]] {
		let count = readInt()
		if count <= 0 {
			return []
		}
		
		return (0..<count).map{ _ in readInts() }
	}
	
	public func write(ints2D: [[Int]]) {
		if ints2D.isEmpty {
			write(int: -1)
			return
		}
		
		write(int: ints2D.count)
		ints2D.forEach { write(ints: $0) }
	}
	
	
	
	public func readEnum<T: RawByteRepresentable>() -> T? {
		return T.init(rawValue: readByte())
	}
	
	public func write<T: RawByteRepresentable>(enum value: T?) {
		write(byte: value?.rawValue ?? -1)
	}
	
	
	
	public func readNullableEnums<T: RawByteRepresentable>() -> [T?] {
		let count = readInt()
		if count <= 0 {
			return []
		}
		
		return (0..<count).map{ _ in readEnum() }
	}
	
	public func write<T: RawByteRepresentable>(enums: [T?]) {
		if enums.isEmpty {
			write(int: -1)
			return
		}
		
		write(int: enums.count)
		enums.forEach { write(enum: $0) }
	}
	
	
	
	public func readEnums<T: RawByteRepresentable>() -> [T] {
		let count = readInt()
		if count <= 0 {
			return []
		}
		
		return (0..<count).map{ _ in readEnum()! }
	}
	
	public func write<T: RawByteRepresentable>(enums: [T]) {
		if enums.isEmpty {
			write(int: -1)
			return
		}
		
		write(int: enums.count)
		enums.forEach { write(enum: $0) }
	}
	
	
	
	public func readNullableEnums2D<T: RawByteRepresentable>() -> [[T?]] {
		let count = readInt()
		if count <= 0 {
			return []
		}
		
		return (0..<count).map{ _ in readNullableEnums() }
	}
	
	public func write<T: RawByteRepresentable>(enums2D: [[T?]]) {
		if enums2D.isEmpty {
			write(int: -1)
			return
		}
		
		write(int: enums2D.count)
		enums2D.forEach { write(enums: $0) }
	}
	
	
	
	public func readEnums2D<T: RawByteRepresentable>() -> [[T]] {
		let count = readInt()
		if count <= 0 {
			return []
		}
		
		return (0..<count).map{ _ in readEnums() }
	}
	
	public func write<T: RawByteRepresentable>(enums2D: [[T]]) {
		if enums2D.isEmpty {
			write(int: -1)
			return
		}
		
		write(int: enums2D.count)
		enums2D.forEach { write(enums: $0) }
	}
}


private func toByteArray<T>(_ value: T) -> [Byte] {
	var value = value
	return withUnsafeBytes(of: &value) {  $0.map{ Byte(bitPattern:$0) } }
}

private func fromByteArray<T>(_ value: [Byte]) -> T {
	return value.withUnsafeBytes {
		$0.baseAddress!.load(as: T.self)
	}
}
