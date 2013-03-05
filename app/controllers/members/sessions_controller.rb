#encoding: UTF-8
class Members::SessionsController < Devise::SessionsController
  
  
  layout "member" 
  
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :allow_params_authentication!, :only => :create

  # GET /resource/sign_in
  def new
    resource = build_resource
    clean_up_passwords(resource)
    serialize_options(resource)
    if current_member
      respond_with(resource, serialize_options(resource))
    else
      flash[:notice] = "用户名或密码不合法！"
      redirect_to "/sign_in"
    end

  end

  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(auth_options)
    session[:current_nick_name] = current_member.nick_name
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    redirect_to params[:go_url] and return if params[:go_url]
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.any(*navigational_formats) { redirect_to redirect_path }
      format.all do
        head :no_content
      end
    end
  end

  protected

  def serialize_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { :methods => methods, :only => [:password] }
  end

  def auth_options
    #    { :scope => resource_name, :recall => "#{controller_path}#new" }
    { :scope => resource_name, :recall => "#{controller_path}#new" }
  end
  
  
end
