class HolidaysController < ApplicationController
  unloadable
  
  before_filter :authorize_global
  before_filter :parse_kind_setting
  
  def check_plugin_right
    right = (!Setting.plugin_mega_calendar['allowed_users'].blank? && Setting.plugin_mega_calendar['allowed_users'].include?(User.current.id.to_s) ? true : false)
    if !right
      flash[:error] = translate 'no_right'
      redirect_to({:controller => :welcome})
    end
  end

  def parse_kind_setting
	@kind_hash = {}
	Setting.plugin_mega_calendar['holiday_kind'].scan(/([^:]+):\s*([^,]+),?/u){|k,v| @kind_hash[k.to_s.strip] = v.to_s.strip }
  end

  def index
    limit = 20
    offset = 0
    @new_page = 1
    @last_page = 0
    if !params[:page].blank? && params[:page].to_i >= 1
      offset = params[:page].to_i * limit
      @new_page = params[:page].to_i + 1
      @last_page = params[:page].to_i - 1
    end
    @res = Holiday.limit(limit).offset(offset)
    @pagination = (Holiday.count.to_f / 20.to_f) > 1.to_f
  end

  def new
    #DO NOTHING
  end

  def show
    @holiday = Holiday.where(:id => params[:id]).first rescue nil
    if @holiday.blank?
      redirect_to(:controller => 'calendar', :action => 'index')
    end
  end

  def create
    @holiday = Holiday.new(params[:holiday])
    if @holiday.save
      redirect_to(:controller => 'calendar', :action => 'index')
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.api  { render_validation_errors(@holiday) }
      end
    end
  end

  def edit
    @holiday = Holiday.find(params[:id]) rescue nil
    if @holiday.blank?
      redirect_to(:controller => 'calendar', :action => 'index')
    end
  end

  def update
    @holiday = Holiday.find(params[:holiday][:id]) rescue nil
    @holiday.assign_attributes(params[:holiday])
    if @holiday.save
      redirect_to(:controller => 'calendar', :action => 'index')
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.api  { render_validation_errors(@holiday) }
      end
    end
  end

  def destroy
    holiday = Holiday.where(:id => params[:id]).first rescue nil
    holiday.destroy()
    redirect_to(:controller => 'calendar', :action => 'index')
  end
end
