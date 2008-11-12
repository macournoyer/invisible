require "invisible/reloader"

use Invisible::Reloader, self
use Rack::ShowExceptions
use Rack::CommonLogger
use Rack::Lint