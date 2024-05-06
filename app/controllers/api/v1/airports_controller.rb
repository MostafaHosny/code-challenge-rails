class API::V1::AirportsController < API::V1::BaseController
  def index
    airports = Airport.all
    airports = airports.by_country_codes(params[:countries]) if params[:countries].present?
    render json: AirportSerializer.render(airports)
  end
end
