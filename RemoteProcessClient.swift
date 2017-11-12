public enum MessageType: Int8, RawByteRepresentable {
	case unknownMessage = 0
	case gameOver
	case authenticationToken
	case teamSize
	case protocolVersion
	case gameContext
	case playerContext
	case moveMessage
}


public class RemoteProcessClient {
	fileprivate let tc: TCPClient // просто для короткой запись, ибо писал в блокноте
	
	fileprivate var previousFacilityById: [Int64: Facility] = [:]
	fileprivate var previousFacilities: [Facility] = []
	
	fileprivate var previousPlayerById: [Int64: Player] = [:]
	fileprivate var previousPlayers: [Player] = []
	
	fileprivate var terrainByCellXY: [[TerrainType]] = []
	fileprivate var weatherByCellXY: [[WeatherType]] = []
	
	public init(host: String, port: Int) {
		tc = TCPClient(address: host, port: Int32(port))
		if !tc.connect() {
			c_exit("Can't connect to host: \(host) port: \(port)")
		}
	}
	
	public func close() {
		tc.close()
	}
	
	public func write(token: String) {
		tc.write(enum: MessageType.authenticationToken)
		tc.write(string: token)
	}
	
	public func write(protocolVersion: Int) {
		tc.write(enum: MessageType.protocolVersion)
		tc.write(int: protocolVersion)
	}
	
	public func readTeamSize() -> Int {
		ensureMessageType(tc.readEnum()!, .teamSize)
		return tc.readInt()
	}
	
	public func readGameContext() -> Game {
		ensureMessageType(tc.readEnum()!, .gameContext)
		return readModelGame()
	}
	
	
	public func readPlayerContext() -> PlayerContext? {
		let messageType: MessageType = tc.readEnum()!
		if messageType == .gameOver {
			return nil
		}
		
		ensureMessageType(messageType, .playerContext)
		return readModelPlayerContext()
	}
	
	public func write(move: Move) {
		tc.write(enum: MessageType.moveMessage)
		writeModel(move: move)
	}
}


/// Функции чтения моделей
extension RemoteProcessClient {
	fileprivate func readModelFacility() -> Facility {
		let flag = tc.readByte()
		if 0 == flag {
			c_exit("Can't read facility")
		}
		
		if 127 == flag {
			return previousFacilityById[tc.readLong()]!
		}
		
		let facility = Facility(
			id: tc.readLong(),
			type: tc.readEnum()!,
			ownerPlayerId: tc.readLong(),
			left: tc.readDouble(),
			top: tc.readDouble(),
			capturePoints: tc.readDouble(),
			vehicleType: tc.readEnum()!,
			productionProgress: tc.readInt()
		)
		previousFacilityById[facility.id] = facility;
		return facility;
	}
	
	fileprivate func readModelFacilities() -> [Facility] {
		let count = tc.readInt()
		if count < 0 {
			return previousFacilities
		}
		
		let facilities = (0..<count).map { _ in readModelFacility() }
		previousFacilities = facilities
		return facilities
	}
	
	fileprivate func readModelGame() -> Game {
		if !tc.readBool() {
			c_exit("Can't read game")
		}
		
		return Game(
			randomSeed: tc.readLong(),
			tickCount: tc.readInt(),
			worldWidth: tc.readDouble(),
			worldHeight: tc.readDouble(),
			fogOfWarEnabled: tc.readBool(),
			victoryScore: tc.readInt(),
			facilityCaptureScore: tc.readInt(),
			vehicleEliminationScore: tc.readInt(),
			actionDetectionInterval: tc.readInt(),
			baseActionCount: tc.readInt(),
			additionalActionCountPerControlCenter: tc.readInt(),
			maxUnitGroup: tc.readInt(),
			terrainWeatherMapColumnCount: tc.readInt(),
			terrainWeatherMapRowCount: tc.readInt(),
			plainTerrainVisionFactor: tc.readDouble(),
			plainTerrainStealthFactor: tc.readDouble(),
			plainTerrainSpeedFactor: tc.readDouble(),
			swampTerrainVisionFactor: tc.readDouble(),
			swampTerrainStealthFactor: tc.readDouble(),
			swampTerrainSpeedFactor: tc.readDouble(),
			forestTerrainVisionFactor: tc.readDouble(),
			forestTerrainStealthFactor: tc.readDouble(),
			forestTerrainSpeedFactor: tc.readDouble(),
			clearWeatherVisionFactor: tc.readDouble(),
			clearWeatherStealthFactor: tc.readDouble(),
			clearWeatherSpeedFactor: tc.readDouble(),
			cloudWeatherVisionFactor: tc.readDouble(),
			cloudWeatherStealthFactor: tc.readDouble(),
			cloudWeatherSpeedFactor: tc.readDouble(),
			rainWeatherVisionFactor: tc.readDouble(),
			rainWeatherStealthFactor: tc.readDouble(),
			rainWeatherSpeedFactor: tc.readDouble(),
			vehicleRadius: tc.readDouble(),
			tankDurability: tc.readInt(),
			tankSpeed: tc.readDouble(),
			tankVisionRange: tc.readDouble(),
			tankGroundAttackRange: tc.readDouble(),
			tankAerialAttackRange: tc.readDouble(),
			tankGroundDamage: tc.readInt(),
			tankAerialDamage: tc.readInt(),
			tankGroundDefence: tc.readInt(),
			tankAerialDefence: tc.readInt(),
			tankAttackCooldownTicks: tc.readInt(),
			tankProductionCost: tc.readInt(),
			ifvDurability: tc.readInt(),
			ifvSpeed: tc.readDouble(),
			ifvVisionRange: tc.readDouble(),
			ifvGroundAttackRange: tc.readDouble(),
			ifvAerialAttackRange: tc.readDouble(),
			ifvGroundDamage: tc.readInt(),
			ifvAerialDamage: tc.readInt(),
			ifvGroundDefence: tc.readInt(),
			ifvAerialDefence: tc.readInt(),
			ifvAttackCooldownTicks: tc.readInt(),
			ifvProductionCost: tc.readInt(),
			arrvDurability: tc.readInt(),
			arrvSpeed: tc.readDouble(),
			arrvVisionRange: tc.readDouble(),
			arrvGroundDefence: tc.readInt(),
			arrvAerialDefence: tc.readInt(),
			arrvProductionCost: tc.readInt(),
			arrvRepairRange: tc.readDouble(),
			arrvRepairSpeed: tc.readDouble(),
			helicopterDurability: tc.readInt(),
			helicopterSpeed: tc.readDouble(),
			helicopterVisionRange: tc.readDouble(),
			helicopterGroundAttackRange: tc.readDouble(),
			helicopterAerialAttackRange: tc.readDouble(),
			helicopterGroundDamage: tc.readInt(),
			helicopterAerialDamage: tc.readInt(),
			helicopterGroundDefence: tc.readInt(),
			helicopterAerialDefence: tc.readInt(),
			helicopterAttackCooldownTicks: tc.readInt(),
			helicopterProductionCost: tc.readInt(),
			fighterDurability: tc.readInt(),
			fighterSpeed: tc.readDouble(),
			fighterVisionRange: tc.readDouble(),
			fighterGroundAttackRange: tc.readDouble(),
			fighterAerialAttackRange: tc.readDouble(),
			fighterGroundDamage: tc.readInt(),
			fighterAerialDamage: tc.readInt(),
			fighterGroundDefence: tc.readInt(),
			fighterAerialDefence: tc.readInt(),
			fighterAttackCooldownTicks: tc.readInt(),
			fighterProductionCost: tc.readInt(),
			maxFacilityCapturePoints: tc.readDouble(),
			facilityCapturePointsPerVehiclePerTick: tc.readDouble(),
			facilityWidth: tc.readDouble(),
			facilityHeight: tc.readDouble(),
      baseTacticalNuclearStrikeCooldown: tc.readInt(),
      tacticalNuclearStrikeCooldownDecreasePerControlCenter:tc.readInt(),
      maxTacticalNuclearStrikeDamage: tc.readDouble(),
      tacticalNuclearStrikeRadius: tc.readDouble(),
      tacticalNuclearStrikeDelay: tc.readInt()
		)
	}
	
	fileprivate func writeModel(move: Move) {
		tc.write(bool: true)
		
		tc.write(enum: move.action)
		tc.write(int: move.group)
		tc.write(double: move.left)
		tc.write(double: move.top)
		tc.write(double: move.right)
		tc.write(double: move.bottom)
		tc.write(double: move.x)
		tc.write(double: move.y)
		tc.write(double: move.angle)
	  tc.write(double: move.factor)
		tc.write(double: move.maxSpeed)
		tc.write(double: move.maxAngularSpeed)
		tc.write(enum: move.vehicleType)
		tc.write(long: move.facilityId)
    tc.write(long:move.vehicleId);
	}
	
	fileprivate func readModelPlayer() -> Player {
		let flag = tc.readByte()
		if 0 == flag {
			c_exit("Can't read facility")
		}
		
		if 127 == flag {
			return previousPlayerById[tc.readLong()]!
		}
		
		let player = Player(
			id: tc.readLong(),
			me: tc.readBool(),
			strategyCrashed: tc.readBool(),
			score: tc.readInt(),
			remainingActionCooldownTicks: tc.readInt(),
      remainingNuclearStrikeCooldownTicks: tc.readInt(),
      nextNuclearStrikeVehicleId: tc.readLong(),
      nextNuclearStrikeTickIndex:tc.readInt(),
      nextNuclearStrikeX: tc.readDouble(),
      nextNuclearStrikeY: tc.readDouble()
		)
		previousPlayerById[player.id] = player
		return player
	}
	
	fileprivate func readModelPlayers() -> [Player] {
		let count = tc.readInt()
		if count < 0 {
			return previousPlayers
		}
		
		let players = (0..<count).map { _ in readModelPlayer() }
		previousPlayers = players
		return players
	}
	
	fileprivate func readModelPlayerContext() -> PlayerContext {
		if !tc.readBool() {
			c_exit("Can't read player context")
		}
		
		return PlayerContext(
			player: readModelPlayer(),
			world: readModelWorld()
		)
	}
	
	fileprivate func readModelVehicle() -> Vehicle {
		if !tc.readBool() {
			c_exit("Can't read vehicle")
		}
		
		return Vehicle(
			id: tc.readLong(),
			x: tc.readDouble(),
			y: tc.readDouble(),
			radius: tc.readDouble(),
			playerId: tc.readLong(),
			durability: tc.readInt(),
			maxDurability: tc.readInt(),
			maxSpeed: tc.readDouble(),
			visionRange: tc.readDouble(),
			squaredVisionRange: tc.readDouble(),
			groundAttackRange: tc.readDouble(),
			squaredGroundAttackRange: tc.readDouble(),
			aerialAttackRange: tc.readDouble(),
			squaredAerialAttackRange: tc.readDouble(),
			groundDamage: tc.readInt(),
			aerialDamage: tc.readInt(),
			groundDefence: tc.readInt(),
			aerialDefence: tc.readInt(),
			attackCooldownTicks: tc.readInt(),
			remainingAttackCooldownTicks: tc.readInt(),
			type: tc.readEnum()!,
			aerial: tc.readBool(),
			selected: tc.readBool(),
			groups: tc.readInts()
		)
	}
	
	fileprivate func readModelVehicles() -> [Vehicle] {
		let count = tc.readInt()
		if count < 0 {
			c_exit("Can't read vehicles")
		}
		
		return (0..<count).map { _ in readModelVehicle() }
	}
	
	fileprivate func readModelVehicleUpdate() -> VehicleUpdate {
		if !tc.readBool() {
			c_exit("Can't read vehicle update")
		}
		
		return VehicleUpdate(
			id: tc.readLong(),
			x: tc.readDouble(),
			y: tc.readDouble(),
			durability: tc.readInt(),
			remainingAttackCooldownTicks: tc.readInt(),
			selected: tc.readBool(),
			groups: tc.readInts()
		)
	}
	
	fileprivate func readModelVehicleUpdates() -> [VehicleUpdate] {
		let count = tc.readInt()
		if count < 0 {
			c_exit("Can't read vehicle update")
		}
		
		return (0..<count).map { _ in readModelVehicleUpdate() }
	}
	
	fileprivate func readModelWorld() -> World {
		if !tc.readBool() {
			c_exit("Can't read world")
		}
		
		func readModelTerranByCellXY() -> [[TerrainType]] {
			if terrainByCellXY.isEmpty {
				terrainByCellXY = tc.readEnums2D();
			}
			return terrainByCellXY
		}
		
		func readModelWeatherByCellXY() -> [[WeatherType]] {
			if weatherByCellXY.isEmpty {
				weatherByCellXY = tc.readEnums2D();
			}
			return weatherByCellXY
		}
		
		return World(
			tickIndex: tc.readInt(),
			tickCount: tc.readInt(),
			width: tc.readDouble(),
			height: tc.readDouble(),
			players: readModelPlayers(),
			newVehicles: readModelVehicles(),
			vehicleUpdates: readModelVehicleUpdates(),
			terrainByCellXY: readModelTerranByCellXY(),
			weatherByCellXY: readModelWeatherByCellXY(),
			facilities: readModelFacilities()
		)
	}
}

/// Вспомогательные функции
extension RemoteProcessClient {
	
	fileprivate func ensureMessageType(_ actualType: MessageType, _ expectedType: MessageType) {
		if actualType != expectedType {
			c_exit("message type not equals: actual: \(actualType) expected: \(expectedType)")
		}
	}
}
