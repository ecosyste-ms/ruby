class IssuesController < ApplicationController
  def index
    scope = Issue.good_first_issue.includes(:project)

    if params[:sort].present? || params[:order].present?
      sort = sanitize_sort(Issue.sortable_columns, default: 'issues.created_at')
      if params[:order] == 'asc'
        scope = scope.order(sort.asc.nulls_last)
      else
        scope = scope.order(sort.desc.nulls_last)
      end
    else
      scope = scope.order('issues.created_at DESC')
    end

    @pagy, @issues = pagy(scope)
  end
end
