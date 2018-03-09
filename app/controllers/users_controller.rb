class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(index new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.activated.paginate page: params[:page]
  end

  def show
    @microposts = @user.microposts.swap.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.update.update_success"
      redirect_to @user
    else
      flash.now[:danger] = t "users.update.update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.destroy.notifi"
    else
      flash[:danger] = t "users.destroy.fail"
    end
    redirect_to users_url
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "users.logged_in_user.pls_login"
      redirect_to login_url
    end
  end

  def correct_user
    edirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def user_params
    params.require(:user).permit :email, :password, :password_confirmation, :name
  end

  def load_user
    @user = User.find_by id: params[:id]
    @user || render(file: "public/404.html", status: 404, layout: true)
  end
end
