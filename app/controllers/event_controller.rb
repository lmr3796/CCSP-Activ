# encoding: utf-8
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
	@ps = Post.where(:event_id => @id).order("updated_at DESC")
	@dep_me = @deps.where(:dep_head => @user_id)
	@act_me = @acts.where(:act_head => @user_id)
	
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
	
	redirect_to :action => :manage_event
  end
  def destroy_depuser
	@d_id = params[:d_id]
	@dep_id = params[:dep_id]
	@d = UserDepartment.where(:user_id => @d_id, :department_id => @dep_id).first
	@d.destroy
	redirect_to :action => :show_dep_manage
  end
  def destroy_dep
	@d_id = params[:d_id]
	@d = Department.find(@d_id)
	@d.destroy
	@ds = UserDepartment.where(:department_id => @d_id)
	@ds.destroy_all
	@p = Post.where(:dep_id => @d_id)
	@p.destroy_all
	@acc = Accounting.where(:department_id => @d_id)
	@acc.destroy_all
	redirect_to :action => :manage_event
  end
  def destroy_actuser
	@d_id = params[:d_id]
	@act_id = params[:act_id]
	@a = UserActivity.where(:user_id => @d_id, :activity_id => @act_id).first
	@a.destroy
	redirect_to :action => :show_act_manage
  end
  def destroy_act
	@d_id = params[:d_id]
	@a = Activity.find(@d_id)
	@a.destroy
	@as = UserActivity.where(:activity_id => @d_id)
	@as.destroy_all
	@p = Post.where(:act_id => @d_id)
	@p.destroy_all
	@acc = Accounting.where(:activity_id => @d_id)
	@acc.destroy_all
	redirect_to :action => :manage_event
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
		flash[:notice] = "成員已經在此活動中囉。\n"
	else
		@a = UserEvent.new(:user_id => @u.id, :event_id => @id)
		@a.save
	end
	redirect_to :action => :manage_event
  end
  def create_depuser
	@dep_id = params[:dep_id]
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		flash[:notice] = "部門成員必須先加入此活動才行，請至新增活動成員將其加入。\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "部門成員必須先加入此活動才行，請至新增活動成員將其加入。\n"
		else
			@tt = UserDepartment.where(:user_id => @u.id, :department_id => @dep_id).first
			if @tt != nil
				flash[:notice] = "成員已經在此部門中囉。\n"
			else
				@a = UserDepartment.new(:user_id => @u.id, :department_id => @dep_id)
				@a.save
			end
		end
	end
	redirect_to :action => :show_dep_manage
  end
  def create_dep
	@dep_name = params[:dep_name]
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		flash[:notice] = "部門負責人必須先加入此活動才行，請至新增活動成員將其加入。\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "部門負責人必須先加入此活動才行，請至新增活動成員將其加入。\n"
		else
			@dep_head = @u.id
			@d = Department.new(:dep_name => @dep_name, :dep_head => @dep_head, :event_id => @id)
			@d.save
			@a = UserDepartment.new(:user_id => @dep_head, :department_id => @d.id)
			@a.save
		end
	end
	redirect_to :action => :manage_event
  end
  def edit_depname
	@dep_id = params[:e_id]		
	@dep_name_new = params[:dep_name_new]
	@d = Department.find(@dep_id)
	@d.dep_name = @dep_name_new
	@d.save
	redirect_to :action => :manage_event
  end	
  def edit_dephead
	@dep_id = params[:e_id]	
	@dep_head_new = params[:dep_head_new]
	@u = User.where(:email => @dep_head_new).first
	if @u == nil
		flash[:notice] = "部門負責人必須先加入此活動才行，請至新增活動成員將其加入。\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "部門負責人必須先加入此活動才行，請至新增活動成員將其加入。\n"
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
	redirect_to :action => :manage_event
  end	
  def show_dep
	@dep_id = params[:dep_id] || session[:dep_id]
	session[:dep_id] = @dep_id
	@d = Department.find(@dep_id)	
	@e = Event.find(@id)
	@uu = User.find(@user_id)
	@dep_head = User.find(@d.dep_head)
	@access_token = session[:access_token]
	@deps = @e.departments
	@acts = @e.activities
	@dep_type = session[:dep_type] || 0
	session[:dep_type]=0
	if @dep_type == 4 || @dep_type == 3 || @dep_type == 5 #forum(4)&calendar(3)&accounts(5),only members in the activity can see
		@tmp = UserDepartment.where(:user_id => @user_id,:department_id =>@d.id).first
		if @tmp != nil || (@user_id == @e.event_head)
			@see = 1
		else
			@see = 0
		end
		@depacc = @d.accountings
	elsif @dep_type == 0 #posts
		@ps = Post.where(:event_id => @id,:dep_id => @dep_id,:act_id => nil).order("updated_at DESC")
		@tmp = UserDepartment.where(:user_id => @user_id,:department_id =>@d.id).first
		if @tmp != nil 
			@see = 1
		else
			@see = 0
		end
	end
	@dep_me = @deps.where(:dep_head => @user_id)
	@act_me = @acts.where(:act_head => @user_id)
  end
  def show_dep_aboutus
	session[:dep_type]=1
	redirect_to :action => :show_dep
  end
  def show_dep_members
	session[:dep_type]=2
	redirect_to :action => :show_dep
  end
  def show_dep_calendar
	session[:dep_type]=3
	redirect_to :action => :show_dep
  end
  def show_dep_forum
	session[:dep_type]=4
	redirect_to :action => :show_dep
  end
  def show_dep_accounting
	session[:dep_type]=5
	redirect_to :action => :show_dep
  end
  def show_dep_manage
	session[:dep_type]=6
	@f = flash[:notice]	
	flash[:notice] = @f
	redirect_to :action => :show_dep
  end
  def create_actuser
	@act_id = params[:act_id]
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		flash[:notice] = "節目成員必須先加入此活動才行，請至新增活動成員將其加入。\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "節目成員必須先加入此活動才行，請至新增活動成員將其加入。\n"
		else
			@tt = UserActivity.where(:user_id => @u.id, :activity_id => @act_id).first
			if @tt != nil
				flash[:notice] = "成員已經此本節目中囉。\n"
			else
				@a = UserActivity.new(:user_id => @u.id, :activity_id => @act_id)
				@a.save
			end
		end
	end
	redirect_to :action => :show_act_manage
  end
  def create_act
	@act_name = params[:act_name]
	@email = params[:email]
	@u = User.where(:email => @email).first
	if @u == nil
		flash[:notice] = "節目負責人必須先加入此活動才行，請至新增活動成員將其加入。\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "節目負責人必須先加入此活動才行，請至新增活動成員將其加入。\n"
		else
			@act_head = @u.id
			@a = Activity.new(:act_name => @act_name, :act_head => @act_head, :event_id => @id)
			@a.save
			@a2 = UserActivity.new(:user_id => @act_head, :activity_id => @a.id)
			@a2.save
		end
	end
	redirect_to :action => :manage_event
  end
  def edit_actname
	@act_id = params[:e_id]		
	@act_name_new = params[:act_name_new]
	@a = Activity.find(@act_id)
	@a.act_name = @act_name_new
	@a.save
	redirect_to :action => :manage_event
  end	
  def edit_acthead
	@act_id = params[:e_id]	
	@act_head_new = params[:act_head_new]
	@u = User.where(:email => @act_head_new).first
	if @u == nil
		flash[:notice] = "節目負責人必須先加入此活動才行，請至新增活動成員將其加入。\n"
	else
		@t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
		if @t == nil
			flash[:notice] = "節目負責人必須先加入此活動才行，請至新增活動成員將其加入。\n"
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
	redirect_to :action => :manage_event
  end	
  def show_act
	@act_id = params[:act_id] || session[:act_id]
	session[:act_id] = @act_id
	@a = Activity.find(@act_id)	
	@e = Event.find(@id)
	@uu = User.find(@user_id)
	@access_token = session[:access_token]
	@deps = @e.departments
	@acts = @e.activities
	@act_head = User.find(@a.act_head)
	@act_type = session[:act_type] || 0
	session[:act_type]=0
	if @act_type == 4 || @act_type == 3 || @act_type == 5 #calendar(3)&forum(4)&account(5),only members in the activity can see
		@tmp = UserActivity.where(:user_id => @user_id,:activity_id =>@a.id).first
		if @tmp != nil || (@user_id == @e.event_head)
			@see = 1
		else
			@see = 0
		end	
		@actacc = @a.accountings
	elsif @act_type == 0 #posts
		@ps = Post.where(:event_id => @id,:act_id => @act_id,:dep_id => nil).order("updated_at DESC")
		@tmp = UserActivity.where(:user_id => @user_id,:activity_id =>@a.id).first
		if @tmp != nil 
			@see = 1
		else
			@see = 0
		end
	end
	session[:user_id] = @user_id
	@dep_me = @deps.where(:dep_head => @user_id)
	@act_me = @acts.where(:act_head => @user_id)
  end
  def show_act_aboutus
	session[:act_type]=1
	redirect_to :action => :show_act
  end
  def show_act_members
	session[:act_type]=2
	redirect_to :action => :show_act
  end
  def show_act_calendar
	session[:act_type]=3
	redirect_to :action => :show_act
  end
  def show_act_forum
	session[:act_type]=4
	redirect_to :action => :show_act
  end
  def show_act_accounting
	session[:act_type]=5
	redirect_to :action => :show_act
  end
  def show_act_manage
	session[:act_type]=8
	@f = flash[:notice]	
	flash[:notice] = @f
	redirect_to :action => :show_act
  end
  def show_act_light
	session[:act_type]=6
	redirect_to :action => :show_act
  end
  def show_act_script
	session[:act_type]=7
	redirect_to :action => :show_act
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
	@dep_me = @deps.where(:dep_head => @user_id)
	@act_me = @acts.where(:act_head => @user_id)
	@manage_type = session[:manage_type] || 0
	#session[:manage_type] = 0
  end
  def manage_user 
	session[:manage_type] = 1
	redirect_to :action => :manage
  end
  def manage_dep
	session[:manage_type] = 2
	redirect_to :action => :manage
  end
  def manage_act
	session[:manage_type] = 3
	redirect_to :action => :manage
  end
  def manage_event
	@a = flash[:notice]
	session[:manage_type] = 4
	flash[:notice] =  @a
	redirect_to :action => :manage
  end
  def members
	@e = Event.find(@id)
	@head = User.find(@e.event_head)
	@users = @e.users
	@new_user = User.new
	@deps = @e.departments
	@acts = @e.activities
	@uu = User.find(@user_id)
	@access_token = session[:access_token]
	@dep_me = @deps.where(:dep_head => @user_id)
	@act_me = @acts.where(:act_head => @user_id)
  end
  def aboutus
	@e = Event.find(@id)
	@head = User.find(@e.event_head)
	@users = @e.users
	@new_user = User.new
	@deps = @e.departments
	@acts = @e.activities
	@uu = User.find(@user_id)
	@access_token = session[:access_token]
	@dep_me = @deps.where(:dep_head => @user_id)
	@act_me = @acts.where(:act_head => @user_id)
  end
  def forum
	@e = Event.find(@id)
	@head = User.find(@e.event_head)
	@users = @e.users
	@new_user = User.new
	@deps = @e.departments
	@acts = @e.activities
	@uu = User.find(@user_id)
	@access_token = session[:access_token]
	@dep_me = @deps.where(:dep_head => @user_id)
	@act_me = @acts.where(:act_head => @user_id)
  end
  def calendar
	@e = Event.find(@id)
	@head = User.find(@e.event_head)
	@users = @e.users
	@new_user = User.new
	@deps = @e.departments
	@acts = @e.activities
	@uu = User.find(@user_id)
	@access_token = session[:access_token]
	@dep_me = @deps.where(:dep_head => @user_id)
	@act_me = @acts.where(:act_head => @user_id)
  end
  def accounting
	@e = Event.find(@id)
	@head = User.find(@e.event_head)
	@users = @e.users
	@new_user = User.new
	@deps = @e.departments
	@acts = @e.activities
	@uu = User.find(@user_id)
	@access_token = session[:access_token]
	@eacc = @e.accountings
	@dep_me = @deps.where(:dep_head => @user_id)
	@act_me = @acts.where(:act_head => @user_id)
  end
  def edit_event
	@e = Event.find(@id)
	@event_new_name = params[:event_new_name]
	@event_new_sub = params[:event_new_sub]
	@event_new_desc = params[:event_new_desc]
	@event_new_imgurl = params[:event_new_imgurl]
	@event_new_trailerurl = params[:event_new_trailerurl]
	if(@event_new_sub == "") 
		@event_new_sub = nil 
	end
	if(@event_new_desc == "") 
		@event_new_desc = nil 
	end
	if(@event_new_imgurl == "") 
		@event_new_imgurl = nil 
	end
	if(@event_new_trailerurl == "") 
		@event_new_trailerurl = nil 
	end
	@e.event_name = @event_new_name
	@e.event_subtitle = @event_new_sub
	@e.event_description = @event_new_desc
	@e.event_image_url = @event_new_imgurl
	@e.event_trailer_url = @event_new_trailerurl
	@e.save
	redirect_to :action => :manage_event
  end
  def edit_dep
	@d = Department.find(params[:e_id])
	@dep_new_name = params[:dep_new_name]
	@dep_new_sub = params[:dep_new_sub]
	@dep_new_desc = params[:dep_new_desc]
	@dep_new_imgurl = params[:dep_new_imgurl]
	if(@dep_new_sub == "") 
		@dep_new_sub = nil 
	end
	if(@dep_new_desc == "") 
		@dep_new_desc = nil 
	end
	if(@dep_new_imgurl == "") 
		@dep_new_imgurl = nil 
	end
	@d.dep_name = @dep_new_name
	@d.dep_subtitle = @dep_new_sub
	@d.dep_description = @dep_new_desc
	@d.dep_image_url = @dep_new_imgurl
	@d.save
	redirect_to :action => :show_dep_manage
  end
  def edit_act
	@a = Activity.find(params[:e_id])
	@act_new_name = params[:act_new_name]
	@act_new_sub = params[:act_new_sub]
	@act_new_desc = params[:act_new_desc]
	@act_new_imgurl = params[:act_new_imgurl]
	if(@act_new_sub == "") 
		@act_new_sub = nil 
	end
	if(@act_new_desc == "") 
		@act_new_desc = nil 
	end
	if(@act_new_imgurl == "") 
		@act_new_imgurl = nil 
	end
	@a.act_name = @act_new_name
	@a.act_subtitle = @act_new_sub
	@a.act_description = @act_new_desc
	@a.act_image_url = @act_new_imgurl
	@a.save
	redirect_to :action => :show_act_manage
  end
  def create_post
	@title = params[:post_title]
	@content = params[:post_content]
	@type = params[:type]
  	if @type == "dep"
		@dep_id = params[:e_id]
		@act_id = nil
	elsif @type == "act"
		@act_id = params[:e_id]
		@dep_id = nil
	end
	@p = Post.new(:event_id => @id, :dep_id => @dep_id, :act_id => @act_id, :title => @title, :content => @content, :user_id => @user_id)
	@p.save
	if @type == "dep"
		redirect_to :action => :show_dep
	elsif @type =="act"
		redirect_to :action => :show_act
	end
  end	
  def del_post
	@p_id = params[:p_id]
	@type = params[:type]
	@p = Post.find(@p_id)
	@p.destroy
	if @type == "dep"
		redirect_to :action => :show_dep
	elsif @type == "act"
		redirect_to :action => :show_act
	end
  end
  def edit_post
	@p_id = params[:e_id]
	@type = params[:type]
	@p = Post.find(@p_id)
	@content = params[:post_content]
	@p.content = @content
	@p.save
	if @type == "dep"
		redirect_to :action => :show_dep
	elsif @type == "act"
		redirect_to :action => :show_act
	end
  end
  def get_ajax
	@id = params[:id]
	@post = Post.find(@id)
	@c = @post.content
	render :text => @c
  end

  def save_dep_accounting
  	entry = Accounting.new(:title => params[:title], :balance => params[:balance], :receipt => params[:receipt], :comment => params[:comment], :event_id => session[:id], :department_id => session[:dep_id], :user_id => session[:user_id], :approved => false, :paid => false)
  	entry.save
  	redirect_to :action => :show_dep_accounting
  end

  def save_act_accounting
  	entry = Accounting.new(:title => params[:title], :balance => params[:balance], :receipt => params[:receipt], :comment => params[:comment], :event_id => session[:id], :activity_id => session[:act_id], :user_id => session[:user_id], :approved => false, :paid => false)
  	entry.save
  	redirect_to :action => :show_act_accounting
  end

  def acc_approve
        entry = Accounting.find(:first, :conditions => {:id => params[:accid]})
        entry.approved = true;
        entry.save
        redirect_to :action => :accounting
  end
  def acc_pay
        entry = Accounting.find(:first, :conditions => {:id => params[:accid]})
        entry.paid = true;
        entry.save
        redirect_to :action => :accounting
  end
  def edit_account_manager
	@email = params[:new_account_manager]
        @e = Event.find(@id)
	@u = User.where(:email => @email).first
        if @u == nil 
                flash[:notice] = "該成員必須先加入此活動才行，請至右側 管理->增刪活動成員 將其加入。\n"
        else
                @t = UserEvent.where(:user_id => @u.id,:event_id => @id).first
                if @t == nil 
                	flash[:notice] = "該成員必須先加入此活動才行，請至右側 管理->增刪活動成員 將其加入。\n"
                else
			@e.accounting_manager_id = @u.id
			@e.save
                end 
        end
	redirect_to :action => :accounting
		
  end
  def del_account
	@acc_id = params[:acc_id]
	@type = params[:type]
	@acc = Accounting.find(@acc_id)
	@acc.destroy
	if @type == "dep"
		redirect_to :action => :show_dep
	elsif @type == "act"
		redirect_to :action => :show_act
	end
  end

end
