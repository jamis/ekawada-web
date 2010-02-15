class ConstructionsController < ApplicationController
  def show
    @construction = Construction.find(params[:id], :include => :figure)
    redirect_to(@construction.figure)
  end

  def edit
    @construction = Construction.find(params[:id], :include => :figure)
  end

  def update
    @construction = Construction.find(params[:id], :include => :figure)
    @construction.update_with_definition(params[:construction])
    redirect_to(@construction)
  end
end
