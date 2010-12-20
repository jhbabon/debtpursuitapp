class CommentMailer < ActionMailer::Base
  default :from => "no-reply@debtpursuitapp.com"

  def new_comment_email(user, comment)
    @user = user
    @comment = comment
    @contact = @comment.debt.partner(@user)
    @url = debt_url(@comment.debt)
    mail :to => @user.email,
         :subject => I18n.t("mailers.comment_mailer.subject")
  end
end
