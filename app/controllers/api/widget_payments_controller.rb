class Api::WidgetPaymentsController < ApiController
  self.payment_class = CrossPlatformPayment

  def new
    amount       = payment.items_amount
    current_user = User.find(payment.user_id)

    records = News.find_random(amount).
      pluck(:id).map { |news_id| {user_id: current_user.id, news_id: news_id} }
    UserNews.create!(records)

    render nothing: true
  end
end
