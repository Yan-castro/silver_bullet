puts "🌱 Generating development environment seeds."

team = Team.find_or_create_by(name: 'administadores', slug: 'administadores')
 
admin_1 = User.find_or_create_by(email: 'yansousa@gmail.com') do |user|
  user.password = 'Yaned120'
  user.first_name = 'Yansousa'
  user.last_name = 'Castro' 
  user.time_zone = 'Brasilia' 
  user.current_team_id = team.id
end

admin_2 = User.find_or_create_by(email: 'aryrabelo@gmail.com') do |user|
  user.password = 'Aryed120'
  user.first_name = 'Ary'
  user.last_name = 'Rabelo' 
  user.time_zone = 'Brasilia' 
  user.current_team_id  = team.id
end

Membership.find_or_create_by( user_email: 'yan@gmail.com', team: team, user: admin_1, role_ids: [ 'admin'])
Membership.find_or_create_by( user_email: 'aryrabelo@gmail.com', team: team, user: admin_2, role_ids: [ 'admin'])

property_1 = Property.find_or_create_by( name: 'casacocaralter', description: 'casa em alter do cão', team: team)
property_2 = Property.find_or_create_by( name: 'casacocarsantarem', description: 'casa em santarem', team: team)
