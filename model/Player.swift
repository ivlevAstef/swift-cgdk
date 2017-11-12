public struct Player {
	let id: Int64
	let me: Bool
	let strategyCrashed: Bool
	let score: Int
	let remainingActionCooldownTicks: Int
  let remainingNuclearStrikeCooldownTicks: Int
  let nextNuclearStrikeVehicleId: Int64
  let nextNuclearStrikeTickIndex: Int
  let nextNuclearStrikeX:Double
  let nextNuclearStrikeY:Double
}
