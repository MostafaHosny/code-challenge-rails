class API::V1::AirportsController < API::V1::BaseController
  def index
    render json: Airport.last(10)
  end
end
