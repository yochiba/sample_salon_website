# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Service.create(servicename: "縮毛矯正", servicetypename: "パーマ", serviceflg: 3, servicetime: 120, serviceprice: 12000 ,created_at: "2019-07-04 15:40:11", updated_at: "2019-07-04 15:40:11", servicekeyword: "パーマ, 縮毛矯正")
# Service.create(servicename: "デジタルパーマ", servicetypename: "パーマ", serviceflg: 3, servicetime: 120, serviceprice: 13000 ,created_at: "2019-07-04 15:40:30", updated_at: "2019-07-04 15:40:30", servicekeyword: "パーマ")
# Service.create(servicename: "ナノパーマ", servicetypename: "パーマ", serviceflg: 3, servicetime: 120, serviceprice: 16000 ,created_at: "2019-07-04 15:40:49", updated_at: "2019-07-04 15:40:49", servicekeyword: "パーマ")
# Service.create(servicename: "メンズカット", servicetypename: "カット", serviceflg: 1, servicetime: 45, serviceprice: 4500 ,created_at: "2019-07-04 15:41:14", updated_at: "2019-07-04 15:41:14", servicekeyword: "カット, メンズ")
# Service.create(servicename: "学生カット", servicetypename: "カット", serviceflg: 1, servicetime: 45, serviceprice: 3500 ,created_at: "2019-07-04 15:41:37", updated_at: "2019-07-04 15:41:37", servicekeyword: "カット, 学生")
# Service.create(servicename: "カラー", servicetypename: "カラー", serviceflg: 4, servicetime: 120, serviceprice: 10000 ,created_at: "2019-07-06 10:55:31", updated_at: "2019-07-06 10:55:31", servicekeyword: "カラー")

# Appointment.create(firstname: "a", lastname: "a", email: "a@a", servicename: "[\"ナノパーマ\", \"メンズカット\"]", appointmentdate: "2019-07-30 16:00:00", totalservicetime: "120", totalserviceprice: "16000")

Staff.create(firstname: "山口", lastname: "潤", email: "sample@sample", displayname: "JUN")
Staff.create(firstname: "山下", lastname: "たくや", email: "sample@sample", displayname: "たくや")