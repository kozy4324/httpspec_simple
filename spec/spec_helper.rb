require 'webrick'
require 'httpspec_simple'

def server_start mount_procs = {}
    captured = []
    server_thread = Thread.new do
      server = WEBrick::HTTPServer.new(
        Port: 10080,
        Logger: WEBrick::Log.new('/dev/null'),
        AccessLog: [],
        StartCallback: Proc.new { Thread.main.wakeup }
      )
      mount_procs.each {|path, proc|
        server.mount_proc(path) {|req, res|
          captured.push(req.request_uri.to_s)
          proc.call(req, res)
        }
      }
      Thread.current[:server] = server
      server.start
    end
    Thread.stop
    yield
    server_thread[:server].shutdown
    captured
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
