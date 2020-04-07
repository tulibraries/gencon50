#! /usr/bin/env bash
bin/bundle exec rails runner "User.create!(email: 'admin@best50yearsingaming.com', password: 'MjVjOTJiMmE1ZTRk', password_confirmation:'MjVjOTJiMmE1ZTRk') unless User.where(email: 'admin@best50yearsingaming.com').exists?"
