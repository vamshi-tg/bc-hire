Rails.application.config.middleware.use OmniAuth::Builder do
    GOOGLE_CLIENT_ID = "1090375265634-g1kpc64r1l35rm4q864f364hgdeeltge.apps.googleusercontent.com"
    GOOGLE_CLIENT_SECRET = "qcLBrNWCUK7t2CRRgvuMh8Xf"
    provider :google_oauth2, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET
end