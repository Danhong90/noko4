class HelloController < ApplicationController
  def index
    
  end
  def delete_record
    Scrap.delete_all
    redirect_to :back
  end
  def noko
    @hello = []
    argue = true
    i = 1
    while argue
      
      uri = URI("http://contests.saramin.co.kr/contests?saramin_category=C001&state=3&page=#{i}")
      html_doc = Nokogiri::HTML(Net::HTTP.get(uri))
      hello = html_doc.xpath("//*[@id='content']/div/div[2]/div[3]/table/tbody/tr/td[2]/a")
      
      if hello.empty?
        argue = false
      else
        @hello = @hello + [hello.map {|element| element["href"]}.compact.map{|link|"http://contests.saramin.co.kr"+link}]
      end
      i = i+1
    end
    
    @hello.each do |post|
      post.each do |link|        
        post = Scrap.new
        uri = URI(link)
        html_doc = Nokogiri::HTML(Net::HTTP.get(uri))
        post.post_category= "공모전"
        post.post_subject = html_doc.xpath("//*[@id='content']/div/div[2]/div[1]/text()").inner_text
        post.post_image = html_doc.xpath("//*[@id='imageZoomOut']").map {|element| element['src']}.first
        post.post_company = html_doc.xpath("//*[@id='content']/div/div[2]/div[2]/div[1]/ul/li[2]/span").inner_text
        parsed_date = html_doc.xpath("//*[@id='content']/div/div[2]/div[2]/div[1]/ul/li[5]/span").inner_text.split('~')[1]
        if !parsed_date.nil?
          post.post_deadline = parsed_date.gsub(/' '/,'').gsub(/'.'/,'-').to_date
        end
        post.post_content = html_doc.xpath("//*[@id='content']/div/div[2]/div[2]/div[2]/dl/dd").inner_text
        post.save
      end  
    end
    @hey = Scrap.all
    
    redirect_to :back
  end
  
  def noko_intern
    @hey = []
    argue = true
    i = 1
    while argue
      uri = URI("http://career.snu.ac.kr/en/jobs/employer_posting.jsp?page=#{i}&no=&category_code=1&business_type=&searchKey=&searchVal=")
      html_doc = Nokogiri::HTML(Net::HTTP.get(uri))
      hello = html_doc.xpath("//*[@id='posting']/tbody/tr/td[3]/a")
      @hello = hello
    if i == 30
      argue = false
    else
      @hey = @hey + [hello.map {|element| element["onclick"]}.compact.map {|x| x[/\d+/]}.map{|link|"http://career.snu.ac.kr/en/jobs/employer_posting_view.jsp?no="+link}]
    end
    
    i = i+1;
    end
    
     @hey.each do |post|
      post.each do |link|        
        post = Scrap.new
        uri = URI(link)
        html_doc = Nokogiri::HTML(Net::HTTP.get(uri))
        post.post_category= "인턴"
        post.post_subject = html_doc.xpath("//*[@id='content']/div/div[2]/div[1]/text()").inner_text
        # post.post_image = html_doc.xpath("//*[@id='imageZoomOut']").map {|element| element['src']}.first
        post.post_company = html_doc.xpath("//*[@id='contents']/div[2]/div[3]/table/tbody/tr[1]/td[2]").inner_text
        parsed_date = html_doc.xpath("//*[@id='contents']/div[2]/div[3]/table/tbody/tr[2]/td[4]").inner_text
        if parsed_date != "Throughout the Year"
          post.post_deadline = parsed_date.gsub(/' '/,'').gsub(/'.'/,'-').to_date
        else
          post.post_deadline = "2015-12-31".to_date
        end
        post.post_content = html_doc.xpath("//*[@id='contents']/div[2]/div[3]/table/tbody/tr[4]/td").inner_text
        post.save
      end  
    end
    
    redirect_to :back
  end
  
  def export_only
    @scrap =Scrap.all
    
    
  end
  
  def export
    @scrap = Scrap.all
    respond_to do |format|
    format.xls { send_data @scrap.to_xls, content_type: 'application/vnd.ms-excel', filename: 'posts.xls' }
    end
    
  end
  
end
