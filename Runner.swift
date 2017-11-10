public final class Runner {
	private let remoteProcessClient: RemoteProcessClient
	private let token: String
	
	public init(host: String, port: String, token: String) {
		self.remoteProcessClient = RemoteProcessClient(host: host, port: Int(port)!)
		self.token = token
	}
	
	public func run() {
		
		remoteProcessClient.write(token: token)
		remoteProcessClient.write(protocolVersion: 2)
		
		_ = remoteProcessClient.readTeamSize()
		let game = remoteProcessClient.readGameContext()
		
		let stategy = MyStrategy()
		
		while let playerContext = remoteProcessClient.readPlayerContext() {
			let player = playerContext.player
			let world = playerContext.world
			
			let move = Move()
			stategy.move(me: player, world: world, game: game, move: move)
			
			remoteProcessClient.write(move: move)
		}
		
		remoteProcessClient.close()
	}
}
