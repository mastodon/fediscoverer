class Fasp::AccountSearch::V0::SearchesController < Fasp::ApiController
  def show
    @limit = params[:limit] ? params[:limit].to_i : 20
    @page = params[:page] ? params[:page].to_i : 1

    if params[:language].present?
      actors = Actor.discoverable.posts_in_language(params[:language])
      @accounts = actors.search(params[:term])
    else
      @accounts = Actor.discoverable.search(params[:term])
    end


    @total = @accounts.count
    @results = @accounts
      .limit(@limit)
      .offset((@page - 1) * @limit)

    set_pagination_headers
    render json: @results.map(&:uri)
  end

  private

  def set_pagination_headers
    if @limit * @page < @total
      next_page_url = fasp_account_search_v0_search_url(term: params[:term], limit: @limit, page: @page + 1)
      headers["Link"] = "<#{next_page_url}>; rel=next"
    end
  end
end
