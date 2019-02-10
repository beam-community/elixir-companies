class IndustryGenerator < Jekyll::Generator
  def generate(site)
    complete_info = site
      .data['companies']
      .map { |name, details| details.merge({'name' => name}) }

    site.data['companies'] = complete_info.reverse

    industries = complete_info
      .group_by { |company| [company['industry'], company['industry'].downcase.gsub(/[^a-zA-Z]/, "-")] }
      .sort_by { |key, _values| key[0] }
      .reduce([]) do |acc, ((name, path), companies)|
      sorted_companies = companies.sort_by { |c| c['name'].downcase }
      acc << { 'companies' => sorted_companies, 'name' => name, 'path' => path }
    end

    site.data['industries'] = industries
    site.data['hiring'] = hiring_companies(industries)

    site.pages << hiring_page(site)

    industries.each { |industry| site.pages << build_page(site, industry) }
  end

  def hiring_page(site)
    page = Jekyll::PageWithoutAFile.new(site, site.source, '/', "hiring.md")
    page.data['industry'] = 'Hiring'
    page.data['companies'] = site.data['hiring']
    page.data['layout'] = 'default'
    page.content = '{% include industry.html %}'

    page
  end

  def hiring_companies(industries)
    industries
      .flat_map { |industry| industry['companies'] }
      .select { |company| company['jobs'] }
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
