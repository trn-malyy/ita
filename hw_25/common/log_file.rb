require 'net/smtp'

module LogFile

  def send_log_email(smtp_server,contents,test_name, log_file)
    from_address = "your@mail.com"
    to_addresses = []
    IO.readlines(File.join(File.expand_path(File.dirname(__FILE__)),"email_to_test.txt")).each do |id|
      val = id.gsub(/\s|\n/,'').strip
      to_addresses << val if val.match(/^[a-zA-Z0-9,!#\$%&'\*\+=\?\^_`\{\|}~-]+(\.[a-z0-9,!#\$%&'\*\+=\?\^_`\{\|}~-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.([a-z]{2,})$/)
    end
    msg = <<-MSG
From: QA Automation <your@mail.com>
To: #{to_addresses}
Content-Type: text/plain
Subject: #{test_name} Log Test Result

#{contents}

Regards,
QA-TEAM
    MSG
    begin
      smtp_server = 'smtp.server.com'

      Net::SMTP.start(smtp_server) do |smtp|
        smtp.send_message msg, from_address, to_addresses
      end
    rescue Exception => e
      File.open(log_file, "w+"){ |file| file.print "Exception occurred while sending the log report:\n #{e}" }
      Signal.trap('EXIT') { exit 1 }
      exit
    end
  end

end