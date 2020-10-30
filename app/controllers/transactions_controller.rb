class TransactionsController < ApplicationController
  before_action :except => :all_households do
     @household = Household.find(params[:household_id])
  end

  def all_households
    @transactions = Transaction.includes(:household => [:members]).order("id DESC").paginate(:page => params[:page], :per_page => 30)

    respond_to do |format|
      format.html # index.html.erb
      format.csv  { render :csv => @transactions }
    end
  end

  # GET /households/:id/transactions
  # GET /households/:id/transactions.xml
  def index
     @transactions = Transaction.for_household(params[:household_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transactions }
      format.csv  { render :csv => @transactions }
    end
  end

  # GET /households/:id/transactions/1
  # GET /households/:id/transactions/1.xml
  def show
    @transaction = Transaction.for_household(params[:household_id]).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /households/:id/transactions/new
  # GET /households/:id/transactions/new.xml
  def new
    @transaction = Transaction.for_household(params[:household_id]).new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /households/:id/transactions/1/edit
  def edit
    @transaction = Transaction.for_household(params[:household_id]).find(params[:id])
  end

  # POST /households/:id/transactions
  # POST /households/:id/transactions.xml
  def create
    #@transaction = Transaction.for_household(params[:household_id]).new(params[:transaction])
    #@transaction = Transaction.for_household(household_params).new(transaction_params)
    @transaction = Transaction.for_household(params[:household_id]).new(who_knows.to_h)
    # I have no idea why I had to do .to_h here, but no where else, but rails5.0 says rails5.1 won't allow otherwise
    # (It seems unrelated to the sketch below, because it showed up with all other iterations)
    
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to(@household, :notice => 'Household transaction was successfully created.') }
        format.xml  { render :xml => @transaction, :status => :created, :location => @transaction }
      else
        format.html { render :template => 'households/show' }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /households/:id/transactions/1
  # PUT /households/:id/transactions/1.xml
  def update
    @transaction = Transaction.for_household(params[:household_id]).find(params[:id])
    #@transaction = Transaction.for_household(household_params).find(household_params)

    respond_to do |format|
      #if @transaction.update_attributes(params[:transaction])
      if @transaction.update_attributes(who_knows)
        format.html { redirect_to(household_transaction_url(@household, @transaction), :notice => 'Household transaction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /households/:id/transactions/1
  # DELETE /households/:id/transactions/1.xml
  def destroy
    raise Exception.new("deleting transactions is not allowed")
    @transaction = Transaction.for_household(params[:household_id]).find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to(household_transactions_url(@houshold)) }
      format.xml  { head :ok }
    end
  end
  
  private
    
    #def household_params
    #  params.permit(:household_id, :id)
    #end
    
    def transaction_params_per
      params.permit(:transaction).permit(:credit, :amount, :message, :void, :these)
      #params.permit(:transaction).permit(:credit, :amount, :message, :void, :these)
    end
    
    def transaction_params_req
      params.require(:transaction).permit(:credit, :amount, :message, :void, :these)
      #params.permit(:transaction).permit(:credit, :amount, :message, :void, :these)
    end
    
    def who_knows
      if params.has_key?(:transaction) and not params[:transaction].empty? #this has become insane, but it works maybe?
        params.require(:transaction).permit(:credit, :amount, :message, :void, :these)
      else
        {}
      end
    end
        
    
end
