require "rubygems";require "thin";require"markaby"; class Invisible
HTTP_METHODS =[:get,:post,:head,:put,:delete];attr_reader :request,
:response, :params; def initialize(&block); @actions =[]; @with=[];
@layouts={};@views={};@helpers=Module.new;@app=self; instance_eval(
&block) if block end; def action(method, route, &block); @actions<<
[method.to_s, build_route(@with*"/"+route),block] end;HTTP_METHODS.
each{|m|class_eval "def #{m}(r='/',&b); action('#{m}', r, &b) end"}
def with(route); @with.push(route);yield;@with.pop end; def render(
*args,&block);options=args.last.is_a?(Hash)?args.pop: {};@response.
status=options.delete(:status)||200;layout=@layouts[options.delete(
:layout)||:default];assigns={:request=>request,:response=>response,
:params=>params,:session=>session};content=args.last.is_a?(String)?
args.last : Markaby::Builder.new(assigns,@helpers, &(block||@views[
args.last] )).to_s ; content = Markaby::Builder.new( assigns.merge(
:content => content), @helpers, &layout).to_s if layout; @response.
headers.merge!(options);@response.body=content end;def layout(name=
:default, &block); @layouts[name]=block end; def view(name,&block);
@views[name]=block end; def helpers(&block);@helpers.instance_eval(
&block ) ; instance_eval(&block)  end;  def session;  @request.env[
"rack.session"]end; def use(middleware, *args);@app=middleware.new(
@app,*args) end; def run(*args);Thin::Server.start(@app, *args) end
def call(env); @request = Rack::Request.new(env); @response =Rack::
Response.new; @params = @request.params; if action = recognize(env[
"PATH_INFO"], @params["_method"] ||env["REQUEST_METHOD"]); @params.
merge!(@path_params);action.last.call;@response.finish; else; [404,
{}, "Not found"]; end; end; def self.run(*args,&block);new(&block).
run(*args) end; def self.app;@app||=self.new end;def self.call(env)
@app.call(env) end; private; def build_route(route);pattern= route.
split("/").inject('\/*') { |r, s| r << (s[0] == ?: ? '(\w+)' : s) +
'\/*' } + '\/*';[/^#{pattern}$/i,route.scan(/\:(\w+)/).flatten] end
def recognize(url, method); method =method.to_s.downcase; @actions.
detect do |m,(pattern,keys),_| method==m&&@path_params=match_route(
pattern,keys,url)end;end;def match_route(pattern,keys,url);matches,
params=(url.match(pattern)||return)[1..-1],{};keys.each_with_index{
|key,i| params[key]=matches[i]};params;end;end; def method_missing(
method, *args,  &block);  ; if Invisible.app .respond_to?(method) ;
Invisible.app. send( method, *args, &block);  else; super; end; end
