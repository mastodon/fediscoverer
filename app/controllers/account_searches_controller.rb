class AccountSearchesController < ApplicationController
  def show
    @actors = if params[:term].present?
      Actor.discoverable.search(params[:term]) .limit(100)
    else
      []
    end
  end
end
