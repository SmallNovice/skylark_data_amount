require 'skylark_projects'
require 'slp_csv'
require 'pry'

class DateFormDataLengthController < ApplicationController
  def index

    @type = params[:type]
    @space = params[:space]
    @range_ids = params[:range_ids]
    @start_date_json = params[:start_date_json]
    @end_date_json = params[:end_date_json]

    unless @space.nil?
      SkylarkProjects.get_project_name(@space)

      get_date = SlpCsv.new.get_date(@start_date_json, @end_date_json)
    end

    unless @range_ids.nil?
      case @type
      when '1'
        @person = DateFormDataLengthJob.new.perform(get_date, @range_ids)
      when '2'
        @person = DateFlowDataLengthJob.new.perform(get_date, @range_ids)
      when '3'
        @person = DateArticleDataLengthJob.new.perform(get_date, @range_ids)
      end
    end
    render :index
  end
end
