# coding: utf-8

namespace :db do
  desc 'create fake mail_boxes for test pagination'
  task :fake_mail_boxes => :environment do
    user = User.first
    100.times do |time|
      domain = Faker::Internet.domain_name
      user.mail_boxes.create!(
        login:       Faker::Internet.user_name,
        domain:      domain,
        pop3_server: "pop3.#{domain}"
      )
    end
  end

  desc 'create fake emails for mail_box with login denisgudzenko'
  task :fake_emails_for_mail_box => :environment do
    mail_box = MailBox.where(login: "denisgudzenko").first
    100.times do |time|
      mail_box.emails.create!(
        from:       Faker::Internet.email,
        to:         Faker::Internet.email,
        subject:    Faker::Lorem.word,
        body:       Faker::Lorem.sentence(5),
        message_id: Faker::Internet.password(27)
      )
    end
  end
end

