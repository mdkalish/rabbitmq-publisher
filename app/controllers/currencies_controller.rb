class CurrenciesController < ApplicationController
  helper_method :currencies
  private
  def currencies
    @currencies ||= Currency.all
  end
end
