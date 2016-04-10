class PlivoService
  include Plivo

  def initialize
    @AUTH_ID = ENV.fetch 'plivo_id'
    @AUTH_TOKEN = ENV.fetch 'plivo_auth_token'
    @plivo = RestAPI.new(@AUTH_ID, @AUTH_TOKEN)
  end

  def create_sip_endpoint(name, password)
    params = {
      'username' => name,
      'password' => password,
      'alias' => name
    }
    begin
      response = @plivo.create_endpoint(params)
      return  {
                sip_endpoint_id: response[1]['endpoint_id'],
                sip_endpoint: response[1]['username'] + '@phone.plivo.com',
                password: password
              }
    rescue Exception => e
      Rails.logger.debug e
      raise
    end
  end

  def create_application app_url, app_name
    params = {
      'answer_url' => "#{app_url}/forward",
      'answer_method' => 'GET',
      'hangup_url' => "#{app_url}/hangup",
      'hangup_method' => 'GET',
      'app_name' => app_name,
      'default_endpoint_app' => true
    }
    response = @plivo.create_application(params)
    response[1]['app_id']
  end

  def destroy_application *ids
    ids.each do |app_id|
      response = @plivo.delete_application({app_id: app_id})
      if response.status != 204
        Rails.logger.debug response["errors"]
        raise
      end
    end
  end

  def destroy_endpoints *ids
    ids.each do |endpoint_id|
      response = @plivo.delete_application({endpoint_id: app_id})
      if response.status != 204
        Rails.logger.debug response["errors"]
        raise
      end
    end
  end
end
