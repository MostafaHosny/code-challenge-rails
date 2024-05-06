class API::V1::AirportsController < API::V1::BaseController
  def index
    airports = Airport.order('passenger_volume DESC NULLS LAST')
    airports = airports.by_country_codes(params[:countries]) if params[:countries].present?
    render json: AirportSerializer.render(airports)
  end
end
