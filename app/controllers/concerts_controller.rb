class ConcertsController < ApplicationController
  before_action :set_concert, only: [:show, :edit, :update, :destroy]
  after_action only: [:index] { paginate :concerts }

  def index
    filters, sorting, page = params.except(:sort, :page), params[:sort], params[:page]
    @concerts = Concert.filter(filters).sort(sorting).page(page)
  end

  def show
  end

  def create
    @concert = Concert.new concert_params

    if @concert.save
      render action: 'show', status: :created, location: @concert
    else
      render json: @concert.errors, status: :unprocessable_entity
    end
  end

  def update
    if @concert.update concert_params
      render action: 'show', status: :ok, location: @concert
    else
      render json: @concert.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @concert.destroy
    head :no_content
  end

private
  def set_concert
    @concert = Concert.find params[:id]
  end

  def concert_params
    params.require(:concert).permit(:where, :year)
  end
end