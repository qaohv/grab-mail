FactoryGirl.define do
  factory :mail_box do
    login       "dns.ryabokon"
    pop3_server "pop3.google.com"
    domain      "google.com"
  end
end
