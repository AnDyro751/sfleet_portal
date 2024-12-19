module ControllerMacros
  def login_user(with_content_type: false)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @request.env['devise.skip_jwt'] = true  # Saltamos JWT
      @request.env['Content-Type'] = 'application/json' if with_content_type
      @request.env['Accept'] = 'application/json' if with_content_type

      @request.env["CONTENT_TYPE"] = "application/json" if with_content_type
      @request.env["HTTP_ACCEPT"] = "application/json" if with_content_type

      user = create(:user)
      warden = @request.env['warden']
      allow(warden).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
      sign_in user
    end
  end
end
