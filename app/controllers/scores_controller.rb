class ScoresController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  TOKEN = Rails.application.credentials.api_unity_token

  before_action :set_score_register, only: [:show, :update, :destroy]  
  before_action :authenticate
  # GET /scores
  def index
    @scores = Score.all

    render json: @scores
  end

  # GET /scores/1
  def show
    render json: @score
  end

  # GET /scores/top10
  def getTop
    @id = params[:id]

    @scores = Score.all.sort{|a,b| b.score <=> a.score}
    render json: {"player_position": @scores.index{|a| a._id.to_s == @id}, "ranking": @scores[0..9]} 
  end

  # POST /scores
  def create
    @score = Score.new(score_params)

    if @score.save
      render json: @score, status: :created, location: @score
    else
      render json: @score.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /scores/1
  def update
    if @score.update(score_params)
      render json: @score
    else
      render json: @score.errors, status: :unprocessable_entity
    end
  end

  # DELETE /scores/1
  def destroy
    @score.destroy
  end

  private
    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        # Compare the tokens in a time-constant manner, to mitigate
        # timing attacks.
        ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_score
      @score = Score.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def score_params
      params.require(:score).permit(:localid, :score)
    end
end
