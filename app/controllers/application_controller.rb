class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_breadcrumbs

  def add_breadcrumb(label, path = nil)
    @breadcrumbs << {
      label: label,
      path: path
    }
  end
  private
  def set_breadcrumbs
    @breadcrumbs = []
  end
end
