# Be sure to restart your server when you modify this file.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly, such as by adding
# .secret to your .gitignore file.

require 'securerandom'

def secure_token
  token_file = Rails.root.join('.secret')
  if File.exist?(token_file)
    # Use the existing token.
    File.read(token_file).chomp
  else
    # Generate a new token and store it in token_file.
    token = SecureRandom.hex(64)
    File.open(token_file, "w") do |f|
      f.write(token)
    end
    token
  end
end

NestedPagesApp::Application.config.secret_token = secure_token