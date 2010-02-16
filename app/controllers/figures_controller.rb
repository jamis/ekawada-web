class FiguresController < ApplicationController
  def index
    @figures = Figure.order("updated_at DESC").limit(11).sort_by(&:common_name)
    @figures, @more = @figures[0,10], @figures[10]
  end

  def show
    @figure = Figure.find(params[:id])
  end

  def new
    @figure = Figure.new
  end

  def create
    @figure = Figure.create((params[:figure] || {}).merge(:submitter_id => current_user))
    redirect_to(@figure)
  end
end
