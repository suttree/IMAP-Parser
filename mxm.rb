#! /usr/bin/env ruby

# gem install ruby-gmail
# gem install mime
# gem install highline

require 'gmail'
require 'highline/import'

email = ask("Please enter your email address:")
password = ask("Please enter your password:") { |q| q.echo = "x" }
label = ask("Please enter a mailbox label:")

gmail = Gmail.new(email, password)

# Patching the broken ruby-gmail gem
class Gmail
  def label(name)
    mailboxes[name] ||= Mailbox.new(self, name)
  end
  alias :mailbox :label
end

@words = {}
gmail.label(label).emails.each do |email|
  email.body.to_s.gsub(/<\/?[^>]*>/, '').split(' ').each do |word|
    word = word.gsub(/[^0-9a-z ]/i, '')
    if @words[word]
      @words[word] += 1
    else
      @words[word] = 1
    end
  end
end

@words.sort_by { |k,v| v }.reverse[0..19].each do |word|
  puts "#{word[0]}:#{word[1]}"
end
