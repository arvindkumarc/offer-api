class FyberResponse
  @response, @errors = ""
  def initialize(response, errors)
    @response = response
    @errors = errors
  end

  def response
    @response
  end

  def errors
    @errors
  end
end