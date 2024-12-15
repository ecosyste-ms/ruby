class Api::V1::IssuesController < Api::V1::ApplicationController
  def index
    scope = Issue.where(pull_request: false, state: 'open').includes(:project)
    scope = scope.good_first_issue

    if params[:sort].present? || params[:order].present?
      sort = params[:sort].presence || 'issues.created_at'
      if params[:order] == 'asc'
        scope = scope.order(Arel.sql(sort).asc.nulls_last)
      else
        scope = scope.order(Arel.sql(sort).desc.nulls_last)
      end
    else
      scope = scope.order('issues.created_at DESC')
    end

    @pagy, @issues = pagy(scope)
  end
end
