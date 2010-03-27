class ConstructionsController < ApplicationController
  before_filter :find_figure, :only => %w(new create)
  before_filter :find_construction, :except => %w(new create)
  before_filter :ensure_can_alter_data, :only => %w(new create edit update destroy)

  def new
    redirect_to(figure_url(@figure, :anchor => "goto_new_construction"))
  end

  def create
    @construction = @figure.constructions.create(params[:construction].merge(:submitter_id => current_user))
    redirect_to(@construction)
  end

  def show
    redirect_to(figure_url(@construction.figure, :anchor => "goto_" + ActionController::RecordIdentifier.dom_id(@construction)))
  end

  def edit
  end

  def update
    @construction.update_attributes(params[:construction])
    redirect_to(@construction)
  end

  def destroy
    @construction.destroy
    redirect_to(@construction.figure)
  end

  private

    def find_figure
      @figure = Figure.find(params[:figure_id])
    end

    def find_construction
      @construction = Construction.find(params[:id], :include => :figure)
    end
end
