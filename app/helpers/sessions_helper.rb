module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    # self is a Ruby keyword that allows an object to refer to itself.
    # So self.current_user = user is calling the module's current_user=(user) method
    # which assigns the argument user to the variable @current_user
    # In your view, when you call current_user you're calling the current_user method which returns the @current_user variable
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  # These are referred to respectively as setters and getters.
  # def current_user=(user) is actually read as defining the method current_user= that takes an argument user
  def current_user=(user)
    @current_user = user
  end

  # def current_user defines a method current_user that takes no arguments.
  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  #check this is current_user and correct_user to edit profile
  def current_user?(user)
    user == current_user
  end

  # Check user is signed in or not
  def signed_in_user
    unless signed_in?
      store_location #user are not logged in than it store url location into session key return_to
      redirect_to signin_path, notice: 'Please Signin'
    end
  end

  #sign out user
  def sign_out
    current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  #Friendly forwording
  def redirect_back_or(user)
    redirect_to(session[:return_to] || user)
    session.delete(:return_to)
  end

  #store location(url) of user when he is hit protected url without login
  def store_location
    session[:return_to] = request.url if request.get?
  end

end
