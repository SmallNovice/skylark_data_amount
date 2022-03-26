class DateArticleDataLengthJob < ApplicationJob
  def perform(get_date, range_ids = [])
    slp_csv = SlpCsv.new
    current_form_rows = []
    range_ids.split(",").each do |categorie_id|

      article_service = Tools.retryable do
        slp_csv.skylark_service.get_article(categorie_id)
      end
      articles_response = JSON.parse(article_service)

      articles_response.each do |article_response|
        array_dta = article_response['created_at'].split('T')[0].split('-')
        article_data = "#{array_dta[0]}-#{array_dta[1]}"
        now_data_array = Date.today.to_s.split('-')
        now_data = "#{now_data_array[0]}-#{now_data_array[1]}"
        if get_date[:start_date] == "--" #创建都现在的总数据量，返回创建日期
          current_form_rows << [article_response['title'], article_response['id'], article_response['read_count'], article_data]
        else
          get_array_date_last = ("#{get_date[:start_date]}-01".to_date - 10).to_s.split('-')
          get_date_last = "#{get_array_date_last[0]}-#{get_array_date_last[1]}"
          if Article.find_by(article_id: article_response['id']).nil? ||
            Article.find_by(article_id: article_response['id'], article_data: now_data).nil?
            @article = Article.new
            @article.article_name = article_response['title']
            @article.article_id = article_response['id']
            @article.article_number = article_response['read_count']
            @article.article_data = now_data
            @article.save!
          end
          unless Article.where(article_id: article_response['id'], article_data: get_date[:start_date]).nil?
            unless Article.find_by(article_id: article_response['id'], article_data: get_date_last).nil?
              current_numbers = Article.find_by(article_id: article_response['id'], article_data: get_date[:start_date])[:article_number] - Article.find_by(article_id: article_response['id'], article_data: get_date_last)[:article_number]
            else
              current_numbers = Article.find_by(article_id: article_response['id'], article_data: get_date[:start_date])[:article_number]
            end
            current_form_rows << [article_response['title'], article_response['id'], current_numbers, get_date[:start_date]]
          else
            current_form_rows << [article_response['title'], article_response['id'], 0, get_date[:start_date]]
          end
        end
      rescue Exception => e
        puts e.inspect
        next
      end
    end
    current_form_rows
  end
end
