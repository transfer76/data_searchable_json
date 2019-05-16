class SearchController < ApplicationController
   def index
     form Search::Create
   end

   def create
     run Search::Create

     render action: :index
   end

  def process; end
end
