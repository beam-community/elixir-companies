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

    locations = complete_info
      .group_by { |company| location = company['location'] || 'unspecified'; [location, location.downcase.gsub(/[^a-zA-Z]/, "-")] }
      .sort_by { |key, _values| key[0] }
      .reduce([]) do |acc, ((name, path), companies)|
      sorted_companies = companies.sort_by { |c| c['name'].downcase }
      acc << { 'companies' => sorted_companies, 'name' => name, 'path' => path }
    end

    site.data['industries'] = industries
    site.data['locations'] = locations
    site.data['hiring'] = hiring_companies(industries)

    site.pages << hiring_page(site)

    industries.each { |item| site.pages << build_page(site, 'industries', item) }
    locations.each  { |item| site.pages << build_page(site, 'locations', item) }
  end

  def hiring_page(site)
    page = Jekyll::PageWithoutAFile.new(site, site.source, '/', "hiring.md")
    page.data['collection'] = 'Hiring'
    page.data['companies'] = site.data['hiring']
    page.data['layout'] = 'default'
    page.content = '{% include collection.html %}'

    page
  end

  def hiring_companies(industries)
    industries
      .flat_map { |industry| industry['companies'] }
      .select { |company| company['jobs'] }
  end

  def build_page(site, collection, item)
    page = Jekyll::PageWithoutAFile.new(site, site.source, collection, "#{item['path']}.md")
    page.data['collection'] = item['name']
    page.data['companies'] = item['companies']
    page.data['layout'] = 'default'
    page.content = '{% include collection.html %}'

    page
  end
end
