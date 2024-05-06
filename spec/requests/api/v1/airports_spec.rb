require 'rails_helper'

RSpec.describe "API::V1::Airports", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/airports/index"
      expect(response).to have_http_status(:success)
    end
  end

end
