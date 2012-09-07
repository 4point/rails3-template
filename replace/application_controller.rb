class ApplicationController < ActionController::Base
  before_filter :authenticate_admin!
  layout :layout_by_resource
  protect_from_forgery

  protected

  def layout_by_resource
    if devise_controller?
      "devise_layout"
    else
      "application"
    end
  end
end
