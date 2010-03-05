class IllustrationsController < ApplicationController
  def create
    @illustration = Illustration.process_to_holding(params[:illustration])
    render :layout => false
  end
end
