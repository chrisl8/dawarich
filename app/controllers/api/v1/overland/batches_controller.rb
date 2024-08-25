# frozen_string_literal: true

class Api::V1::Overland::BatchesController < ApiController
  def create
    Overland::BatchCreatingJob.perform_later(batch_params, current_api_user.id)

    render json: { result: 'ok' }, status: :created
  end

  private

  def batch_params
    params.permit(locations: [:type, { geometry: {}, properties: {} }], batch: {})
  end
end
