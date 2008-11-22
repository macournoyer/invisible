resource "users" do
  get do # users.html.erb
    @users = User.all
  end
  
  get "new" # users/new.html.erb
  
  post do
    @user = User.new(params[:user])

    if @user.save
      redirect_to url(:users, @user)
    else
      render :template => "new"
    end
  end
  
  resource ":id" do
    before do
      @user = User.find(params[:id])
    end
    
    get         # users/user.html.erb
    get "edit"  # users/id/edit.html.erb
    
    put do
      if @user.update_attributes(params[:user])
        redirect_to url(:users, @user)
      else
        render :template => "edit"
      end
    end
    
    delete do
      @user.destroy
      redirect_to url(:users)
    end
  end
end