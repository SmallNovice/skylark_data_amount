require 'jwt'
require 'rest-client'
require 'skylark_projects'
require 'pry'

class SkylarkService
  attr_reader :appid, :appsecret, :namespace_id, :host

  def initialize
    project_name = SkylarkProjects.project_name
    @namespace_id = SkylarkProjects.choose_project(project_name)[:namespace_id]
    @appid = SkylarkProjects.choose_project(project_name)[:appid]
    @appsecret = SkylarkProjects.choose_project(project_name)[:appsecret]
    @host = SkylarkProjects.choose_project(project_name)[:host]
  end


  def get_form(form_id)
    RestClient::Request.execute(
      method: :get,
      url: get_form_url(form_id),
      headers: authorization_token,
      timeout: 3
    )
  end

  #a = SkylarkService.new.query_data(517,-1,'2022-02-01 00:00','2022-02-28 23:59')
  #a = SkylarkService.new.query_data(1115,-12,'2022-03-18 00:00','2022-03-18 23:59')
  def query_data_form(form_id, data_id, start, end_data)
    RestClient::Request.execute(
      method: :get,
      url: query_data_url_form(form_id, data_id, start, end_data),
      headers: authorization_token,
      timeout: 3
    )
  end

  def query_data_flow(form_id, data_id, start, end_data)
    RestClient::Request.execute(
      method: :get,
      url: query_data_url_flow(form_id, data_id, start, end_data),
      headers: authorization_token,
      timeout: 3
    )
  end

  def query_data_flow_before(form_id, data_id, end_data)
    RestClient::Request.execute(
      method: :get,
      url: query_data_url_flow_before(form_id, data_id, end_data),
      headers: authorization_token,
      timeout: 3
    )
  end

  def query_data_form_after(form_id, data_id, start_data)
    RestClient::Request.execute(
      method: :get,
      url: query_data_url_form_after(form_id, data_id, start_data),
      headers: authorization_token,
      timeout: 3
    )
  end

  def query_data_form_before(form_id, data_id, end_data)
    RestClient::Request.execute(
      method: :get,
      url: query_data_url_form_before(form_id, data_id, end_data),
      headers: authorization_token,
      timeout: 3
    )
  end

  def query_data_flow_after(flow_id, data_id, start_data)
    RestClient::Request.execute(
      method: :get,
      url: query_data_url_flow_after(flow_id, data_id, start_data),
      headers: authorization_token,
      timeout: 3
    )
  end


  def get_form_data(form_id, page = 1, per_page = 100)
    RestClient::Request.execute(
      method: :get,
      url: get_form_data_url(form_id ,page, per_page),
      headers: authorization_token,
      timeout: 3
    )
  end

  def get_upload_token(user_id)
    RestClient::Request.execute(
      method: :get,
      url: upload_token_url(user_id),
      headers: authorization_token,
      timeout: 3
    )
  end

  #'query' => {2652 => 1}
  def search_form_response(form_id, payload, page = 1, per_page = 24)
    RestClient::Request.execute(
      method: :get,
      url: search_form_response_url(form_id, page, per_page),
      payload: payload,
      headers: authorization_token,
      timeout: 3
    )
  end

  def upload_file_to_qiniu(file, token)
    RestClient::Request.execute(
      method: :post,
      url: 'https://up.qbox.me/',
      payload: {
        'token': token,
        'x:key': 1593586993541,
        'file': file
      }
    )
  end

  #a = SkylarkService.new.get_article(510)
  def get_articles(categorie_id)
    RestClient::Request.execute(
      method: :get,
      url: get_articles_url(categorie_id),
      headers: authorization_token,
      timeout: 3
    )
  end

  def get_article(categorie_id)
    RestClient::Request.execute(
      method: :get,
      url: get_articles_url(categorie_id),
      headers: authorization_token,
      timeout: 3
    )
  end

  def get_response(response_id)
    RestClient::Request.execute(
      method: :get,
      url: get_response_url(response_id),
      headers: authorization_token,
      timeout: 3
    )
  end

  def get_response_url(response_id)
    "#{@host}/api/v4/responses/#{response_id}"
  end

  def update_response(response_id, entries_attributes = [])
    payload =
      {
        response: {
          entries_attributes: entries_attributes
        }
      }
    update_form_response(9, response_id, payload)
  end

  def update_form_response(form_id, response_id, params = {})
    RestClient::Request.execute(
      method: :put,
      url: update_form_response_url(form_id, response_id),
      headers: authorization_token,
      payload: params,
      timeout: 3
    )
  end

  def get_flow_journeys(flow_id, page = 1, per_page = 100)
    RestClient::Request.execute(
      method: :get,
      url: get_flow_url(flow_id, page, per_page),
      headers: authorization_token,
      timeout: 3
    )
  end

  def get_flow(flow_id)
    RestClient::Request.execute(
      method: :get,
      url: get_flow_u(flow_id),
      headers: authorization_token,
      timeout: 3
    )
  end

  private

  def authorization_token
    { Authorization: "#{@appid}:#{encode_secret}" }
  end

  def encode_secret
    JWT.encode(
      {
        namespace_id: @namespace_id,
      },
      @appsecret,
      'HS256',
      typ: 'JWT', alg: 'HS256'
    )
  end

  def get_form_url(form_id)
    "#{@host}/api/v4/forms/#{form_id}"
  end

  def upload_token_url(user_id)
    "#{@host}/api/v4/attachments/uptoken?purpose=create_responses&user_id=#{user_id}"
  end

  def update_form_response_url(form_id, response_id)
    "#{@host}/api/v4/forms/#{form_id}/responses/#{response_id}"
  end

  def search_form_response_url(form_id, page, per_page)
    "#{@host}/api/v4/forms/#{form_id}/responses/search?page=#{page}&per_page=#{per_page}"
  end

  def query_xi_shu_flow_url(flow_id)
    "#{@host}/api/v4/yaw/flows/#{flow_id}/journeys"
  end

  def get_form_data_url(form_id, page, per_page)
    "#{@host}/api/v4/forms/#{form_id}/responses?page=#{page}&per_page=#{per_page}"
  end

  def get_flow_url(flow_id, page, per_page)
    "#{@host}/api/v4/yaw/flows/#{flow_id}/journeys?page=#{page}&per_page=#{per_page}"
  end

  def get_flow_u(flow_id)
    "#{@host}/api/v4/yaw/flows/#{flow_id}"
  end

  def  query_data_url_form(form_id, data_id, start, end_data)
    "#{@host}/api/v4/forms/#{form_id}/responses/search.json?query[#{data_id}][lft]=#{start}&query[#{data_id}][rgt]=#{end_data}"
  end

  def  query_data_url_flow(flow_id, data_id, start, end_data)
    "#{@host}/api/v4/yaw/flows/#{flow_id}/journeys/search.json?query[#{data_id}][lft]=#{start}&query[#{data_id}][rgt]=#{end_data}"
  end

  def  query_data_url_form_before(form_id, data_id, end_data)
    "#{@host}/api/v4/forms/#{form_id}/responses/search.json?query[#{data_id}][rgt]=#{end_data}"
  end

  def  query_data_url_flow_before(flow_id, data_id, end_data)
    "#{@host}/api/v4/yaw/flows/#{flow_id}/journeys/search.json?query[#{data_id}][rgt]=#{end_data}"
  end

  def get_articles_url(categorie_id)
    "#{@host}/api/v4/categories/#{categorie_id}/pages"
  end

  def get_article_url(categorie_id, page_id)
    "#{@host}/api/v4/categories/#{categorie_id}/pages/#{page_id}"
  end

  def query_data_url_flow_after(flow_id, data_id, start_data)
    "#{@host}/api/v4/yaw/flows/#{flow_id}/journeys/search.json?query[#{data_id}][lft]=#{start_data}"
  end
  def query_data_url_form_after(form_id, data_id, start_data)
    "#{@host}/api/v4/forms/#{form_id}/responses/search.json?query[#{data_id}][lft]=#{start_data}"
  end
end

