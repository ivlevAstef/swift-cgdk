c_main() // initialization C data

let runner: Runner
if 4 == CommandLine.arguments.count {
  let args = CommandLine.arguments
  runner = Runner(host: args[1], port: args[2], token: args[3])
} else {
  runner = Runner(host: "127.0.0.1", port: "31001", token: "0000000000000000")
}

runner.run()
