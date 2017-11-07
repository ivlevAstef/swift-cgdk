public protocol Strategy {
	func move(me: Player, world: World, game: Game, move: Move)
}
