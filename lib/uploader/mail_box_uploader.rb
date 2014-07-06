# coding: utf-8

module Uploader
  class MailBoxUploader
    include Sidekiq::Worker
    include Sidekiq::Status::Worker
    sidekiq_options :retry => false

    def perform(*args)
      if args.size == 2
        get_emails(args.first, args.last)
        p "end process perform"
      else
        p "Incorrect arguments numbers."
      end
    end

    def get_emails(password, mailbox_id)
      mailbox = MailBox.where(id: mailbox_id).first
      if mailbox
        p "mailbox is #{mailbox.inspect}"
        pop = Net::POP3.new mailbox.pop3_server
        pop.start "#{mailbox.login}@#{mailbox.domain}", password
        unless pop.mails.empty?
          pop.each_mail do |mail|
            email, args = Mail.new(mail.pop), {}
            if Email.where(message_id: email.message_id).empty?
              [:from, :to, :subject, :message_id].each { |field|  args[field] = email.send(field).to_s }
              text = email.html_part ? email.html_part : email.text_part
              args[:body] = text.decoded.force_encoding("utf-8") if text
              current_email =  mailbox.emails.create!(args) rescue nil
              if current_email
                dir = FileUtils.mkdir("#{Rails.root}/public/attachments/email_#{current_email.id}_attachments/") if email.attachments.size > 0
                email.attachments.each do |attachment|
                  filename = attachment.filename
                  path_to_file = "#{dir.first}#{filename}"
                  File.open(path_to_file,"w+"){|file| file.write attachment.body.decoded.force_encoding("utf-8") }
                  Zip::File.open("#{dir.first}attachment.zip", Zip::File::CREATE) do |zip_file|
                    zip_file.add(filename, path_to_file)
                  end
                  current_email.update_attributes(attach: File.open("#{dir.first}attachment.zip"))
                  FileUtils.rm(path_to_file)
                end
                FileUtils.rm("#{dir.first}attachment.zip") if email.attachments.size > 0
              end
            end
          end
        end
      end
    end
  end
end
