class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale, :set_translation_path
 
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_translation_path
    @path = Rails.application.routes.recognize_path(request.path)
    if @path[:locale] == 'es'
      @path[:locale] = 'en'
    elsif # path[:locale] == 'en'
      @path[:locale] = 'es'
    end

  end


  def reset
    session.delete :selected_addition
    session.delete :selected_acs_struct
    session.delete :selected_deck
    session.delete :selected_pool
    session.delete :selected_cover
    session.delete :selected_window
    session.delete :selected_door
    session.delete :selected_wall
    session.delete :selected_siding
    session.delete :selected_floor

    redirect_to root_url
  end

  private

  def current_project
    @current_project ||= Project.find_by_id(session[:project_id]) if session[:project_id]
  end
  helper_method :current_project

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end
end
