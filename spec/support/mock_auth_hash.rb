module OmniauthMacros
    def mock_auth_hash
      # The mock_auth configuration allows you to set per-provider (or default)
      # authentication hashes to return during integration testing.
      OmniAuth.config.mock_auth[:google] =  OmniAuth::AuthHash.new({
        'provider' => 'google',
        'uid' => '123545',
        'user_info' => {
          'name' => 'mockuser_name',
          'email' => 'mockuser@beautifulcode.in',
          'image' => 'mock_user_thumbnail_url'
        }})
    end
  end