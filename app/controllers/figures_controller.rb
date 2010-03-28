class FiguresController < ApplicationController
  before_filter :find_figure, :only => %w(show edit update destroy)
  before_filter :ensure_can_alter_data, :only => %w(new create edit update destroy)

  def index
    @figures = Figure.order(:sort_name)
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
