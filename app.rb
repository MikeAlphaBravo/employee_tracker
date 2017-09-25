require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
also_reload 'lib/**/*.rb'
require './lib/division'
require './lib/employee'
require 'pg'

get '/' do
  @divisions = Division.all
  erb :index
end

get '/divisions/new' do
  erb :new_division_form
end

post '/divisions/new' do
  Division.create({:description => params['description']})
  redirect '/'
end

delete '/divisions/:id/delete' do
  Division.find(params[:id]).destroy
  redirect '/'
end

get '/divisions/:id/edit' do
  @id = Division.find(params[:id]).id
  erb :edit_division_form
end

patch '/divisions/:id/edit' do
  Division.find(params[:id]).update({:description => params["description"]})
  redirect '/'
end

get '/divisions/:id' do
  @division = Division.find(params[:id])
  erb :division_info
end

post '/add_employee' do
  Employee.create({:name => params['name'], :division_id => params["id"]})
  redirect "/divisions/#{params["id"]}"
end

get '/employee/:id' do
  @employee = Employee.find(params[:id])
  erb :employee_info
end

delete '/employee/:id/delete' do
  division_id = Employee.find(params[:id]).division_id
  Employee.find(params[:id]).destroy
  redirect "/divisions/#{division_id}"
end

patch '/employee/:id/edit' do
  Employee.find(params[:id]).update({:name => params["name"]})
  redirect "/divisions/#{Employee.find(params[:id]).division_id}"
end
