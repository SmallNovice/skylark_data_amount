class DateFlowDataLengthJob < ApplicationJob
  def perform(get_date, range_ids = [])
    slp_csv = SlpCsv.new
    current_form_rows = []
    range_ids.split(",").each do |flow_ids|
      flow_id = flow_ids.to_i

      flow_response = Tools.retryable do
        slp_csv.skylark_service.get_flow(flow_id)
      end

      flow_title = JSON.parse(flow_response)['title']

      choose_month_flow = Tools.retryable do
        slp_csv.choose_month_flow?(flow_id, get_date)
      end

      form_data_total = choose_month_flow.headers[:x_slp_total_count]
      current_form_rows << [flow_title, flow_id, form_data_total]
    rescue Exception => e
      puts e.inspect
      next
    end
    current_form_rows
  end

end
