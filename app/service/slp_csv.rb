require 'csv'
require 'rest-client'
require 'tools'
require 'skylark_service'

class SlpCsv
  def initialize
    project_name = SkylarkProjects.project_name
    @namespace_id = SkylarkProjects.choose_project(project_name)[:namespace_id]
    @appid = SkylarkProjects.choose_project(project_name)[:appid]
    @appsecret = SkylarkProjects.choose_project(project_name)[:appsecret]
    @host = SkylarkProjects.choose_project(project_name)[:host]
  end

  def get_date(start_date_json = '', end_date_json = '')
    if start_date_json.nil? || end_date_json.nil?
      {
        start_date: "--",
        end_date: "--"
      }
    else
      {
        start_date: start_date_json,
        end_date: end_date_json
      }
    end
  end

  def choose_month_form?(form_id, get_date)
    if get_date[:start_date] == '--' && get_date[:end_date] != '--'
      skylark_service.query_data_form_before(form_id, -1, get_date[:end_date])
    elsif get_date[:end_date] == '--' && get_date[:start_date] != '--'
      skylark_service.query_data_form_after(form_id, -1, get_date[:start_date])
    elsif  get_date[:start_date] == '--' && get_date[:end_date] == '--'
      skylark_service.get_form_data(form_id)
    else
      skylark_service.query_data_form(form_id, -1, get_date[:start_date], get_date[:end_date])
    end
  end

  def choose_month_flow?(flow_id, get_date)
    if get_date[:start_date] == '--'
      skylark_service.query_data_flow_before(flow_id, -12, get_date[:end_date])
    elsif get_date[:end_date] == '--'
      skylark_service.query_data_flow_after(flow_id, -12, get_date[:start_date])
    elsif  get_date[:start_date] == '--' && get_date[:end_date] == '--'
      skylark_service.get_flow_journeys(flow_id)
    else
      skylark_service.query_data_flow(flow_id, -12, get_date[:start_date], get_date[:end_date])
    end
  end

  def skylark_service
    @skylark_service ||= SkylarkService.new
  end

  def field_presence(validations = [])
    presence_zh(is_presence?(validations))
  end

  def csv_file
    @csv_file ||= File.open(current_file_name, 'a+')
  end

  def close_csv_file
    @csv_file.close if @csv_file
  end

  private

  def presence_zh(flag = false)
    flag ? '是' : '否'
  end

  def is_presence?(validations)
    validations.include?('presence')
  end
end

