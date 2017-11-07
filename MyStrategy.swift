public final class MyStrategy: Strategy {
	public init() {
	}
	
	public func move(me: Player, world: World, game: Game, move: Move) {
		
		if world.tickIndex == 0 {
			move.action = .clearAndSelect
			move.right = world.width
			move.bottom = world.height
			return
		}
		
		if world.tickIndex == 1 {
			move.action = .move
			move.x = world.width / 2.0
			move.y = world.height / 2.0
		}
	}
}
