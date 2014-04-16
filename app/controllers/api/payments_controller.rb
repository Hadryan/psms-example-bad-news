class Api::PaymentsController < ApiController
  def new
    news = News.find_random.first
    render text: news.body
  end

  private

  def payment_class
    MobilePayment
  end
end
