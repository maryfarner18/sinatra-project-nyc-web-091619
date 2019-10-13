require_relative 'config/environment'

use Rack::MethodOverride

use UsersController
use RestaurantsController
use VisitsController
run ApplicationController
