require 'spec_helper'
require 'rspec_website_helpers'

HUNSPELL_DICTIONARY_FILE= "spec/hunspell_en_US"
HUNSPELL_BASE_DICTIONARIES  = "en_US"


describe "Testing the web site", type: :feature  do
  include_context :test_website, '/cider-ci/docs'
end
