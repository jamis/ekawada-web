class SourcesController < ApplicationController
  def index
    @sources = Source.order(:sorting)
  end
end
