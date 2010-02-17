class ConstructionsController < ApplicationController
  before_filter :find_figure, :only => %w(new create)
  before_filter :find_construction, :except => %w(new create)

  def new
    redirect_to(figure_url(@figure, :anchor => "new_construction"))
  end

  def create
    @construction = @figure.create_construction_from(params[:construction].merge(:submitter_id => current_user))
    redirect_to(@construction)
  end

  def show
    redirect_to(figure_url(@construction.figure, :anchor => ActionController::RecordIdentifier.dom_id(@construction)))
  end

  def edit
  end

  def update
    @construction.update_with_definition(params[:construction])
    redirect_to(@construction)
  end

  private

    def find_figure
      @figure = Figure.find(params[:figure_id])
    end

    def find_construction
      @construction = Construction.find(params[:id], :include => :figure)
    end
end
