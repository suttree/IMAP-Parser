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
  email.body.to_s.downcase.gsub(/<\/?[^>]*>/, '').split(/\b/).each do |word|
    word = word.gsub(/[^[:alnum:]]/, '')
    next if word.length < 4
    next if word.downcase == 'http'
    next if word.downcase == 'madebymany'
    next if word.downcase == 'diespeker'
    next if word.downcase == 'london'
    next if word.downcase == 'wharf'
    next if word.downcase == 'made'
    next if word.downcase == 'many'
    next if word.downcase == 'wrote'
    next if word.downcase == 'charset'
    next if word.downcase == 'street'
    next if word.downcase == 'this'
    next if word.downcase == 'text'
    next if word.downcase == 'from'
    next if word.downcase == 'that'
    next if word.downcase == 'have'
    next if word.downcase == 'content'
    next if word.downcase == 'encoding'
    next if word.downcase == 'printable'
    next if word.downcase == 'sparrowmailapp'
    next if word.downcase == 'plain'
    next if word.downcase == 'sent'
    next if word.downcase == 'with'
    next if word.downcase == 'sparrow'
    next if word.downcase == 'some'
    next if word.downcase == 'quoted'
    next if word.downcase == 'html'

    if @words[word]
      @words[word] += 1
    else
      @words[word] = 1
    end
  end
end

@words.sort_by { |k,v| v }.reverse[0..49].each do |word|
  puts "#{word[0]}:#{word[1]}"
end
