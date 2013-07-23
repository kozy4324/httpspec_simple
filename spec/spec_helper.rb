require 'webrick'
require 'httpspec_simple'

def server_start mount_procs = {}
    unless mount_procs.has_key?('/')
      mount_procs['/'] = Proc.new {|req, res| res.status = "200" }
    end
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
    begin
      yield
    ensure
      server_thread[:server].shutdown
    end
    captured
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
