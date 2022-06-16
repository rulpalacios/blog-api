class ApplicationController < ActionController::API
  rescue_from Exception do |e|
    # alert to logger
    render json: { error: e.message }, status: :internal_error
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
