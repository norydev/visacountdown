COUNTRY_LIST = YAML.load_file("#{Rails.root}/config/countries.yml")
POLICIES = YAML.load_file("#{Rails.root}/config/policies.yml")
COUNTRIES = POLICIES["Schengen area"].keys