class Api::PaymentsController < ApiController
  self.payment_class = MobilePayment

  def new
    news = News.find_random.first
    render text: news.body
  end
end
