public struct World {
	let tickIndex: Int
	let tickCount: Int
	let width: Double
	let height: Double
	let players: [Player]
	let newVehicles: [Vehicle]
	let vehicleUpdates: [VehicleUpdate]
	let terrainByCellXY: [[TerrainType]]
	let weatherByCellXY: [[WeatherType]]
	let facilities: [Facility]
	
	var myPlayer: Player {
		return players.first{ $0.me }!
	}
	
	var opponentPlayer: Player {
		return players.first{ !$0.me }!
	}
}
