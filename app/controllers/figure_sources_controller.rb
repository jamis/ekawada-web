class FigureSourcesController < ApplicationController
  respond_to :html, :js

  before_filter :find_figure

  def new
    @figure_source = @figure.figure_sources.build
    respond_with(@figure_source)
  end

  def create
    @figure_source = @figure.figure_sources.create(params[:figure_source])
    redirect_to(@figure)
  end

  private

  def find_figure
    @figure = Figure.find(params[:figure_id])
  end
end
