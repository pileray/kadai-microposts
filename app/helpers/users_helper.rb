module UsersHelper
    def gravatar_url(user, options={ size: 80 })
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        size = options[:size]
        "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    end
    
    def counts(user)
       @count_microposts = user.microposts.count
       @count_followings = user.followings.count
       @count_followers = user.followers.count
       @count_favorites = user.added_to_favorites.count
    end
    
end
