class DebtMailer < ActionMailer::Base
  default :from => "no-reply@debtpursuitapp.com"

  def notification_email(user, debt, action)
    @user = user
    @debt = debt
    @contact = @debt.partner(@user)
    @action = action
    @url = action == "deleted" ? nil : debt_url(@debt)
    mail :to => @user.email,
         :subject => I18n.t("mailers.debt_mailer.subject.#{@action}")
  end
end
