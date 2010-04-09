class FiguresController < ApplicationController
  before_filter :find_figure, :only => %w(show edit update destroy)
  before_filter :ensure_can_alter_data, :only => %w(new create edit update destroy)

  def index
    @openings, @more_openings   = recent_figures(:openings)
    @endings, @more_endings     = recent_figures(:endings)
    @maneuvers, @more_maneuvers = recent_figures(:maneuvers)
    @figures, @more_figures     = recent_figures(:figures)
  end

  def figures
    @figures = Figure.figures.order(:sort_name)
    @title = "All Figures"
    render "all"
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

  def recent_figures(collection)
    list = Figure.send(collection).recent.limit(12)
    [list.first(11), list.length > 11 ? Figure.send(collection).count : false]
  end
end
