require 'filters.rb'
require 'vpim'

Redmine::Plugin.register :mega_calendar do
  name 'Mega Calendar plugin'
  author 'Andreas Treubert'
  description 'Better calendar for redmine'
  version '1.7.0'
  url 'https://github.com/berti92/mega_calendar'
  author_url 'https://github.com/berti92'
  requires_redmine :version_or_higher => '3.0.1'
  permission :view_mega_calendar, { :calendar => [:get_saved_filters, :query_filter, :index, :form_holiday, :form_issue, :get_events] }
  permission :edit_mega_calendar, { :calendar => [:save_filters, :destroy_filter, :export, :change_holiday, :change_issue] }
  permission :view_holidays, { :holidays => [:index, :show] }     
  permission :edit_holydays, { :holidays => [:new, :create, :edit, :update, :destroy] }
  menu(:top_menu, :calendar, { :controller => 'calendar', :action => 'index' }, :caption => :calendar )
  menu(:top_menu, :holidays, { :controller => 'holidays', :action => 'index' }, :caption => :holidays )
  settings :default => {'display_empty_dates' => 0, 'displayed_type' => 'users', 'displayed_users' => User.where(["users.login IS NOT NULL AND users.login <> ''"]).collect {|x| x.id.to_s}, 'default_holiday_color' => 'D59235', 'default_event_color' => '4F90FF', 'sub_path' => '/', 'week_start' => '1', 'allowed_users' => User.where(["users.login IS NOT NULL AND users.login <> ''"]).collect {|x| x.id.to_s}}, :partial => 'settings/mega_calendar_settings'
end

Rails.configuration.to_prepare do
  require_dependency File.join( File.dirname(File.realpath(__FILE__)), 'lib', 'users_controller_patch' )
  require_dependency File.join( File.dirname(File.realpath(__FILE__)), 'lib', 'issues_controller_patch' )
end
