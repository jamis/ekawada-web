class FiguresController < ApplicationController
  before_filter :find_figure, :only => %w(show edit update destroy)

  def index
    @figures = Figure.order("updated_at DESC").limit(11).sort_by(&:canonical_name)
    @figures, @more = @figures[0,10], @figures[10]
  end

  def show
  end

  def new
    @figure = Figure.new
  end

  def create
    @figure = Figure.create((params[:figure] || {}).merge(:submitter_id => current_user))
    redirect_to(@figure)
  end

  def edit
  end

  def update
    @figure.update_attributes(params[:figure])
    redirect_to(@figure)
  end

  def destroy
    @figure.destroy
    redirect_to(root_url)
  end

  private

  def find_figure
    @figure = Figure.find(params[:id])
  end
end
