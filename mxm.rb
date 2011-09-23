#! /usr/bin/env ruby

# gem install ruby-gmail
# gem install mime

require 'gmail'
gmail = Gmail.new('email', 'password')

# Patching the broken ruby-gmail gem
class Gmail
  def label(name)
    mailboxes[name] ||= Mailbox.new(self, name)
  end
  alias :mailbox :label
end

#puts gmail.inbox.count.to_s

@words = {}
gmail.label('Pingdom').emails.each do |email|
  email.body.to_s.gsub(/<\/?[^>]*>/, '').split(' ').each do |word|
    if @words[word]
      @words[word] += 1
    else
      @words[word] = 1
    end
  end
end

puts @words.sort_by { |k,v| v }.reverse[0..9]
