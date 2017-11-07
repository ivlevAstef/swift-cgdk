public struct Vehicle {
	let id: Int64
	let x: Double
	let y: Double
	
	let radius: Double
	
	let playerId: Int64
	let durability: Int
	let maxDurability: Int
	let maxSpeed: Double
	let visionRange: Double
	let squaredVisionRange: Double
	let groundAttackRange: Double
	let squaredGroundAttackRange: Double
	let aerialAttackRange: Double
	let squaredAerialAttackRange: Double
	let groundDamage: Int
	let aerialDamage: Int
	let groundDefence: Int
	let aerialDefence: Int
	let attackCooldownTicks: Int
	let remainingAttackCooldownTicks: Int
	let type: VehicleType
	let aerial: Bool
	let selected: Bool
	let groups: [Int]
	
	func getDistanceTo(x: Double, y: Double) -> Double {
		let xRange = x - self.x
		let yRange = y - self.y
		return sqrt(xRange * xRange + yRange * yRange)
	}
	
	func getDistanceTo(_ vehicle: Vehicle) -> Double {
		return getDistanceTo(x: vehicle.x, y: vehicle.y)
	}
}
