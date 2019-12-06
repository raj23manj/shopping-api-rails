module Response
  def json_response(object, status = :ok)
    render json: { data: object}, status: status
  end
  
  def json_response_error(object, status)
    render json: object, status: status
  end
end