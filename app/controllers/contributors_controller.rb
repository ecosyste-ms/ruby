class ContributorsController < ApplicationController
  def index
    scope = Contributor.display.order('projects_count DESC')
    @pagy, @contributors = pagy(scope)
  end

  def show
    @contributor = Contributor.find(params[:id])
  end
end