class IndustryGenerator < Jekyll::Generator
  def generate(site)
    complete_info = site
      .data['companies']
      .map { |name, details| details.merge({'name' => name}) }

    site.data['companies'] = complete_info.reverse

    industries = complete_info
      .group_by { |company| [company['industry'], company['industry'].downcase.gsub(/[^a-zA-Z]/, "-")] }
      .sort_by { |key, _values| key[0] }
      .reduce([]) do |acc, group|
        acc << { 'companies' => group.last, 'name' => group.first.first, 'path' => group.first.last }
      end

    site.data['industries'] = industries

    industries.each { |industry| site.pages << build_page(site, industry) }
  end

  def build_page(site, industry)

    page = Jekyll::PageWithoutAFile.new(site, site.source, 'industries', "#{industry['path']}.md")
    page.data['industry'] = industry['name']
    page.data['companies'] = industry['companies']
    page.data['layout'] = 'default'
    page.content = '{% include industry.html %}'

    page
  end
end
