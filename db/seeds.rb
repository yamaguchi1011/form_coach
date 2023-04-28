10.times do
  User.create(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      password: '12345678',
      password_confirmation: '12345678'
  )
end

20.times do |index|
  Post.create(
      user: User.offset(rand(User.count)).first,
      video: File.open('./app/assets/images/test2.mp4'),
      body: "本文#{index}"
  )
end