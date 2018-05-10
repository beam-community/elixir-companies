---
layout: default
---

{% assign companies = site.data['companies'] %}
{% capture company_count %}{{ site.data['companies'] | size }}{% endcapture %}

{% include hero-intro.html %}
<section class="section">
  <div class="container">
    <div class="content">
      <div class="columns is-desktop is-multiline">
      {% for company in companies %}
        <div class="column is-one-quarter-desktop">
          {% include company-card.html company=company %}
        </div>
      {% endfor %}
      </div> <!-- /columns -->
      {{ content }}
    </div> <!-- /content -->
  </div> <!-- /container -->
</section>
