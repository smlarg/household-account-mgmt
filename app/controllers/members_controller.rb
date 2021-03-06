class MembersController < ApplicationController
  # GET /members
  # GET /members.xml
  def index
    @members = Member.by_activity(:include_active => params[:active], :include_inactive => params[:inactive])

    if params[:search]
      @members = @members.find_by_keywords(params[:search])
    else
      #@members = @members.with_households.all
      @members = @members.with_households
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @members }
      format.csv { render :csv => @members }
    end
  end

  # GET /members/1
  # GET /members/1.xml
  def show
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/new
  # GET /members/new.xml
  def new
    @member = Member.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.xml
  def create
    #@member = Member.new(params[:member])
    @member = Member.new(member_params)
    
    respond_to do |format|
      if @member.save
        format.html { redirect_to(@member, :notice => 'Member was successfully created.') }
        format.xml  { render :xml => @member, :status => :created, :location => @member }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      #if @member.update_attributes(params[:member])
      if @member.update_attributes(member_params)
        format.html { redirect_to(@member, :notice => 'Member was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(members_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    
    def member_params
      params.require(:member).permit(:last_name, :first_name, :active, :email, :phone1, :phone2, :address1, :address2, :city, :state, :zip, :household_id)
    end
  
end
