c_main() // initialization C data

let runner: Runner
if 3 == CommandLine.arguments.count {
  let args = CommandLine.arguments
  runner = Runner(host: args[0], port: args[1], token: args[2])
} else {
  runner = Runner(host: "127.0.0.1", port: "31001", token: "0000000000000000")
}

runner.run()
