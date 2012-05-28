class EventController < ApplicationController
  before_filter :set_some_session_variable

  def set_some_session_variable
	@id = params[:id] || session[:id]
	@user_id = Integer(session[:user_id])
  end
  def index
	session[:id] = @id
	@e = Event.find(@id)
	@head = User.find(@e.event_head)
	@users = @e.users
	@new_user = User.new
	@deps = @e.departments
	@acts = @e.activities
	
	@uu = User.find(@user_id)
	@access_token = session[:access_token]
  end
  def destroy
	@d_id = params[:d_id]
	@a = UserEvent.where(:user_id => @d_id, :event_id => @id).first
	@a.destroy
	@e = Event.find(@id)
	#delete uesrs which attend any department in this event
	@d = @e.departments
	@d.each do |du|
		if du.dep_head == Integer(@d_id)
			du.dep_head = @e.event_head
			du.save
			@a = UserDepartment.where(:user_id => @e.event_head, :department_id => du.id).first
			if @a == nil
				@b = UserDepartment.new(:user_id => @e.event_head, :department_id => du.id)
				@b.save
			end
		end
		@dd = UserDepartment.where(:user_id => @d_id, :department_id => du.id).first
		if @dd != nil
			@dd.destroy
		end
	end
	#delete uesrs which attend any activity in this event
	@a = @e.activities
	@a.each do |au|
		if au.act_head == Integer(@d_id)
			au.act_head = @e.event_head
			au.save
			@a = UserActivity.where(:user_id => @e.event_head, :activity_id => au.id).first
			if @a == nil
				@b = UserActivity.new(:user_id => @e.event_head, :activity_id => au.id)
				@b.save
			end
		end
		@aa = UserActivity.where(:user_id => @d_id, :activity_id => au.id).first
		if @aa != nil
			@aa.destroy
		end
	end
	
	redirect_to :action => :manage
  end
  def destroy_depuser
	@d_id = params[:d_id]
	@dep_id = params[:dep_id]
	@d = UserDepartment.where(:user_id => @d_id, :department_id => @dep_id).first
	@d.destroy
	redirect_to :action => :manage
  end
  def destroy_dep
	@d_id = params[:d_id]
	@d = Department.find(@d_id)
	@d.destroy
	@ds = UserDepartment.where(:department_id => @d_id)
	@ds.destroy_all
	redirect_to :action => :manage
  end
  def destroy_actuser
	@d_id = params[:d_id]
	@act_id = params[:act_id]
	@a = UserActivity.where(:user_id => @d_id, :activity_id => @act_id).first
	@a.destroy
	redirect_to :action => :manage
  end
  def destroy_act
	@d_id = params[:d_id]
	@a = Activity.find(@d_id)
	@a.destroy
	@as = UserActivity.where(:activity_id => @d_id)
	@as.destroy_all
	redirect_to :action => :manage
  end
  def create
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		@u = User.new(:email => @email)
		@u.save
	end
	@t = UserEvent.where(:user_id => @u.id, :event_id => @id).first
	if @t != nil
		flash[:notice] = "user has already joined the event!\n"
	else
		@a = UserEvent.new(:user_id => @u.id, :event_id => @id)
		@a.save
	end
	redirect_to :action => :manage
  end
  def create_depuser
	@dep_id = params[:dep_id]
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		flash[:notice] = "dep user must join the event first!\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "dep user must join the event first!\n"
		else
			@tt = UserDepartment.where(:user_id => @u.id, :department_id => @dep_id).first
			if @tt != nil
				flash[:notice] = "user has already joined the department!\n"
			else
				@a = UserDepartment.new(:user_id => @u.id, :department_id => @dep_id)
				@a.save
			end
		end
	end
	redirect_to :action => :manage
  end
  def create_dep
	@dep_name = params[:dep_name]
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		flash[:notice] = "dep admin must join the event first!\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "dep admin must join the event first!\n"
		else
			@dep_head = @u.id
			@d = Department.new(:dep_name => @dep_name, :dep_head => @dep_head, :event_id => @id)
			@d.save
			@a = UserDepartment.new(:user_id => @dep_head, :department_id => @d.id)
			@a.save
		end
	end
	redirect_to :action => :manage
  end
  def edit_depname
	@dep_id = params[:e_id]		
	@dep_name_new = params[:dep_name_new]
	@d = Department.find(@dep_id)
	@d.dep_name = @dep_name_new
	@d.save
	redirect_to :action => :manage
  end	
  def edit_dephead
	@dep_id = params[:e_id]	
	@dep_head_new = params[:dep_head_new]
	@u = User.where(:email => @dep_head_new).first
	if @u == nil
		flash[:notice] = "dep admin must join the event first!\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "dep admin must join the event first!\n"
		else
			@d = Department.find(@dep_id)
			@d.dep_head = @u.id
			@d.save
			@a = UserDepartment.where(:user_id => @u.id, :department_id => @dep_id).first
			if @a == nil
				@b = UserDepartment.new(:user_id => @u.id, :department_id => @dep_id)
				@b.save
			end
		end
	end
	redirect_to :action => :manage
  end	
  def show_dep
	@dep_id = params[:dep_id]
	@d = Department.find(@dep_id)	
	@e = Event.find(@id)
	@uu = User.find(@user_id)
	@access_token = session[:access_token]
	@deps = @e.departments
	@acts = @e.activities
  end
  def create_actuser
	@act_id = params[:act_id]
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		flash[:notice] = "act user must join the event first!\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "act user must join the event first!\n"
		else
			@tt = UserActivity.where(:user_id => @u.id, :activity_id => @act_id).first
			if @tt != nil
				flash[:notice] = "user has already joined the activity!\n"
			else
				@a = UserActivity.new(:user_id => @u.id, :activity_id => @act_id)
				@a.save
			end
		end
	end
	redirect_to :action => :manage
  end
  def create_act
	@act_name = params[:act_name]
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		flash[:notice] = "act admin must join the event first!\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "act admin must join the event first!\n"
		else
			@act_head = @u.id
			@a = Activity.new(:act_name => @act_name, :act_head => @act_head, :event_id => @id)
			@a.save
			@a2 = UserActivity.new(:user_id => @act_head, :activity_id => @a.id)
			@a2.save
		end
	end
	redirect_to :action => :manage
  end
  def edit_actname
	@act_id = params[:e_id]		
	@act_name_new = params[:act_name_new]
	@a = Activity.find(@act_id)
	@a.act_name = @act_name_new
	@a.save
	redirect_to :action => :manage
  end	
  def edit_acthead
	@act_id = params[:e_id]	
	@act_head_new = params[:act_head_new]
	@u = User.where(:email => @act_head_new).first
	if @u == nil
		flash[:notice] = "act admin must join the event first!\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "act admin must join the event first!\n"
		else
			@d = Activity.find(@act_id)
			@d.act_head = @u.id
			@d.save
			@a = UserActivity.where(:user_id => @u.id, :activity_id => @act_id).first
			if @a == nil
				@b = UserActivity.new(:user_id => @u.id, :activity_id => @act_id)
				@b.save
			end
		end
	end
	redirect_to :action => :manage
  end	
  def show_act
	@act_id = params[:act_id]
	@a = Activity.find(@act_id)	
	@e = Event.find(@id)
	@uu = User.find(@user_id)
	@access_token = session[:access_token]
	@deps = @e.departments
	@acts = @e.activities
  end
  def manage
	@e = Event.find(@id)
	@head = User.find(@e.event_head)
	@users = @e.users
	@new_user = User.new
	@uu = User.find(@user_id)
	@access_token = session[:access_token]
	@deps = @e.departments
	@acts = @e.activities
  end
end
