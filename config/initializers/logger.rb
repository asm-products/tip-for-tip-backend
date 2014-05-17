Rails.logger = Logger.new(STDOUT)

# TODO: log tagggggs
# - subdomain
# - current user id
# - specific modes the app may be running in (console?)

# Rails.configuration.log_tags = [
#   proc do |req|
#     if req.session["warden.user.user.key"].nil?
#       "Anonym"
#     else
#       "user_id:#{req.session["warden.user.user.key"][1][0]}"
#     end
#   end
# ]
