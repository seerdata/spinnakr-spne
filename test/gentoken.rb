require 'securerandom'

class GenToken

  def get_random_token
    my_token_uuid = []
    for i in 0..10
      my_token_uuid.push(SecureRandom.uuid)
    end
    my_token_uuid
  end

  def get_token_id
    my_token_uuid = [
      '104a5866-b844-4186-9322-59cacdcec297',
      '25f32255-aaeb-4d2f-8988-26494bc4d58d',
      '3c953ea8-a620-45bf-8959-6feee5d57c33',
    ].sample
  end
end

gt = GenToken.new
tokens = gt.get_random_token
tokens.each do |token|
  print token; puts
end
