class SearchController < ApplicationController
   def index; end

   def query
     @query = params[:query]
     @results = resource.find(@query) unless @query.blank?
     respond_to do |f|
       f.html
       f.json { render json: @results }
     end
   end

   private

   def resource
     @resource ||= Search::Resource.new Rails.root.join('db', 'data.json')
   end

   def index
     form Search::Create
   end

   def create
     run Search::Create

     render action: :index
   end

  def process

  end
end
