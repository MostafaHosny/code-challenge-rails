require 'rails_helper'

RSpec.describe 'API::V1::Airports', type: :request do
  describe 'GET /index' do
    let(:munich) { create(:airport, :muc) }
    let(:frankfurt) { create(:airport, :fra) }
    let(:vienna) { create(:airport, :vie) }
    let(:zurich) { create(:airport, :zrh) }

    context 'when there is no country filter' do
      let(:total_airports) {4}
      
      before do
        munich
        frankfurt
        vienna
        zurich
      end

      it 'returns all airports' do
        json_get api_v1_airports_path
        expect(json.size).to eq(total_airports)
        expect(json.map { |airport| airport[:iata] }).to include(munich.iata)
      end
    end

    context 'when filtering by single country' do
      let(:germany) { 'Germany' }

      before do
        munich
        frankfurt
        vienna
      end

      it 'returns only airports from Germany' do
        json_get api_v1_airports_path, params: { countries: 'DE' }
        expect(json.map { |airport| airport[:country] }.uniq).to eq([germany])
      end
    end

    context 'when filtering by multiple countries' do
      let(:germany) { 'Germany' }
      let(:austria) { 'Austria' }
      let(:switzerland) { 'Switzerland' }

      before do
        munich
        frankfurt
        vienna
        zurich
      end

      it 'returns airports from Germany and Austria' do
        json_get api_v1_airports_path, params: { countries: ['DE', 'AT'] }
        expect(json.map { |airport| airport[:country] }).to include(germany, austria)
      end

      it 'does not include airports from other countries' do
        json_get api_v1_airports_path, params: { countries: ['DE', 'AT'] }
        expect(json.map { |airport| airport[:country] }).to_not include(switzerland)
      end
    end

    context 'with pagination' do
      let(:page) {1}
      let(:per_page) {3}
      
      before do
        munich
        frankfurt
        vienna
        zurich
      end

      it 'returns paginated results using api-pagination' do
        json_get api_v1_airports_path, params: { page: page, per_page: per_page }
        
        expect(json.size).to eq(3)
        expect(response.headers['X-Per-Page'].to_i).to eq(per_page)
        expect(response.headers['X-Page'].to_i).to eq(page)
        expect(response.headers['X-Total'].to_i).to eq(4)
      end
    end
  end
end
