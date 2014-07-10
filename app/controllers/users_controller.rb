class UsersController < Devise::RegistrationsController

  def profile
    @user = current_user
  end

  def index

    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

end