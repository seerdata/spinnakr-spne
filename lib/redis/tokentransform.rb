require_relative './redistoken'

class Transform
  def transform_customer_token(data)
    hm = Hash.new
    rt = RedisToken.new
    data.each do |key,value|
      if key == 'access_token'
        apkey = rt.get_apkey_from_uuid(value)
        account = rt.get_account_from_apkey(apkey)
        project = rt.get_project_from_apkey(apkey)
        dbnumber = rt.getDbNumber_from_accountid(account)
        print key, ' ', value, ' ', apkey, ' ', account, ' ', project, ' ', dbnumber; puts
        # These are integers
        hm['account_id'] = account
        hm['project_id'] = project
        hm['dbnumber'] = dbnumber
      else
        hm[key] = value
       end
    end
    hm
  end
end

=begin
hm = Hash.new
#hm['access_token'] = '104a5866-b844-4186-9322-19cacdcec297'
#hm['access_token'] = '27ffa057-1878-46ea-9450-34475347e0d2'
hm['access_token'] = '3339efca-5e99-4ea9-9cff-2075136e04bf'
hm['dimension'] = "job-skills"
hm['key'] = "java"
hm['value'] = "5.05"
hm['created_at'] = "2014-11-06 17:34:38 -0800"
hm['interval'] = ["hours","weeks","months"]
hm['calculation'] = ["count","sum","average","standard_deviation","linear_regression"]
t = Transform.new
tmessage = t.transform_customer_token(hm)
print tmessage; puts
=end
