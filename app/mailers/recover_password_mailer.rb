require 'mailjet'

class RecoverPasswordMailer < ApplicationMailer
  default from: 'danmiranda.io@outlook.com'

  def recover_password_email
    @user = User.find_by(email: params[:email]) unless params[:email].nil?
    @user = User.find_by(nickname: params[:nickname]) unless params[:nickname].nil?
    mail(
      to: @user.email,
      subject: 'Password recover request',
      delivery_method_options: {
        api_key: 'fb19726401ba30331720d519dcaed35c',
        secret_key: '18d796d341d5bf9d1842d7ec5650795f',
        version: 'v3.1',
        TemplateID: 2939645 }
    ) unless @user.nil?
  end
end
