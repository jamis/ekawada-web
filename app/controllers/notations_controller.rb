class NotationsController < ApplicationController
  def show
    @notation = Notation.new(params[:id])
  end
end
