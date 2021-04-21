class ScoreRegistersController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  TOKEN = Rails.application.credentials.api_unity_token

  before_action :set_score_register, only: [:show, :update, :destroy]  
  before_action :authenticate

  # GET /score_registers
  def index
    @score_registers = ScoreRegister.all

    render json: @score_registers
  end

  # GET /score_registers/1
  def show
    render json: @score_register
  end

  # GET /scores/top10
  def getTop
    @id = params[:id]

    @scores = ScoreRegister.all.sort{|a,b| b.score <=> a.score}
    render json: {"player_position": @scores.index{|a| a._id.to_s == @id}, "ranking": @scores[0..9]} 
  end

  # POST /score_registers
  def create
    @score_register = ScoreRegister.new(score_register_params)

    if @score_register.save
      render json: @score_register, status: :created, location: @score_register
    else
      render json: @score_register.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /score_registers/1
  def update
    if @score_register.update(score_register_params)
      render json: @score_register
    else
      render json: @score_register.errors, status: :unprocessable_entity
    end
  end

  # DELETE /score_registers/1
  def destroy
    @score_register.destroy
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
    def set_score_register
      @score_register = ScoreRegister.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def score_register_params
      params.require(:score_register).permit(:username, :score)
    end
end
