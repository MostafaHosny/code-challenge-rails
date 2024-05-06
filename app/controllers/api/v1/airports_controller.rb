class API::V1::AirportsController < API::V1::BaseController
  def index
    airports = Airport.order('passenger_volume DESC NULLS LAST')
    airports = airports.by_country_codes(params[:countries]) if params[:countries].present?
    paginated_airports = paginate airports
    render json: AirportSerializer.render(paginated_airports)
  end
end
