require 'rack'

unauthorized = "./401.html"
notfound = "./404.html"

map '/' do
	use Rack::Static, :urls => ["/"], :root => Dir.pwd, :index => 'index.html'

	run lambda { |env|
	  [200, {'Content-Type'  => 'text/html', 'Cache-Control' => 'public, max-age=3600'}, File.open('index.html', File::RDONLY)]
	}
end

map '/protected' do
	run lambda { |env|
    request = Rack::Request.new(env)
    #if ENV.has_key?("SECRET") and request.cookies.has_key?("secret") and request.cookies["secret"] == ENV["SECRET"] then
		if request.cookies.has_key?("secret") and request.cookies["secret"] == "foobar" then
			path = "." + request.script_name.to_s + Rack::Utils.unescape(request.path_info);	
			[200, {'Content-Type' => 'text/html', 'Content-Size' => "#{File.size(path)}", 'Cache-Control' => 'public, max-age=3600'}, File.open(path, File::RDONLY)]
	  else
	  	[401, {'Content-Type' => 'text/html', 'Content-Size' => "#{File.size(unauthorized)}", 'Cache-Control' => 'public, max-age=3600', 'Debugging' => "#{ENV.inspect}"}, File.open(unauthorized, File::RDONLY)]
	  end
	}
end