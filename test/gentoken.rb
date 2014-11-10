require_relative './../lib/redis/redistoken'

class GenToken

  def get_random_token
    my_token_uuid = []
    for i in 0..10
      my_token_uuid.push(SecureRandom.uuid)
    end
    my_token_uuid
  end
end

#
# These calls have to be here instead of in redistoken
# because redistoken can NOT be poluted with test code
#
# These tokens have to match up with the tokens in the
# customer simulator in lib/msgbase.rb
#
rt = RedisToken.new
rt.create_uuid_account_project('104a5866-b844-4186-9322-19cacdcec297','1','1')
rt.create_uuid_account_project('15f32255-aaeb-4d2f-8988-26494bc4d58d','1','2')
rt.create_uuid_account_project('1c953ea8-a620-45bf-8959-3feee5d57c33','1','3')

rt.create_uuid_account_project('28037e39-456d-49e4-998a-17c48ce916aa','2','1')
rt.create_uuid_account_project('212efc9f-f60e-402a-a326-225872a0b0a8','2','2')
rt.create_uuid_account_project('27ffa057-1878-46ea-9450-34475347e0d2','2','3')

rt.create_uuid_account_project('38ef38e8-aa85-4426-beb9-1f877f84fedf','3','1')
rt.create_uuid_account_project('3339efca-5e99-4ea9-9cff-2075136e04bf','3','2')
rt.create_uuid_account_project('35b010e6-3a0d-421c-9c25-354a7a1336ae','3','3')

=begin
This is only here if you want to crank out
a bunch of test tokens
gt = GenToken.new
tokens = gt.get_random_token
tokens.each do |token|
  print token; puts
end
=end
