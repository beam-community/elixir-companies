---
layout: default
---

{% assign companies = site.data['companies'] | slice: 0, 8 %}
{% capture company_count %}{{ site.data['companies'] | size }}{% endcapture %}

{% include hero-intro.html %}
<section class="section">
  <div class="container">
    <div class="content">
      <h1 class="title is-3 fancy">Recent Additions</h1>
      <div class="columns is-desktop is-multiline">
      {% for company in companies %}
        <div class="column is-one-quarter-desktop">
          {% include company-card.html company=company %}
        </div>
      {% endfor %}
      </div> <!-- /columns -->
    </div> <!-- /content -->
  </div> <!-- /container -->
</section>
