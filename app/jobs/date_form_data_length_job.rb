require 'skylark_projects'
require 'slp_csv'
require 'tools'

class DateFormDataLengthJob < ApplicationJob
  def perform(get_date, range_ids = [])
    slp_csv = SlpCsv.new
    current_form_rows = []
    range_ids.split(",").each do |form_ids|
      form_id = form_ids.to_i
      choose_month_form = Tools.retryable do
       slp_csv.choose_month_form?(form_id, get_date)
      end

      form_data_total =  choose_month_form.headers[:x_slp_total_count]

      form_res = Tools.retryable do
        slp_csv.skylark_service.get_form(form_id)
      end
      form_title = JSON.parse(form_res)['title']

      current_form_rows << [form_title, form_id, form_data_total]
    rescue Exception => e
      puts e.inspect
      next
    end
    current_form_rows
  end

  private

  def current_file_name
    "#{SkylarkProjects.project_name}表单-2月.csv"
  end


  def csv_headers
    %w(表单名字 表单id 数据量)
  end

  def row(field_name, field_id, number)
    [field_name, field_id, number]
  end
end
