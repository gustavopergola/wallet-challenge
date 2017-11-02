class UserController < ApplicationController
  
  # GET /user/index
  def index
  	@users = User.all
  	render json: @users, status: 200
  end

  # POST /user/create
  def create
  	@user = User.new(user_params)
  	if @user.save
  	  @user.password_digest = "not-shown"
      render json: @user, status: 201
    else
      render json: @user.errors, status: 422
    end
  end

  # POST /user/login
  def login
  	#TODO -> implement token based login
  	user = User.find_by(:id_nat => params[:id_nat])
  	if user && user.authenticate(params[:password])
  		@token = User.new_token
  		user.update(:login_token => @token)
  	    render json: @token, status: 200
  	else
   		render json: nil , status: 401
  	end
  end

  private
	# don't trust the scary internet
	def user_params
	  params.require(:user).permit(:name, :password, :password_confirmation, :id_nat)
	end
end
