class RedirectRoutingController < ActionController::Base
  def redirect
    args, options = params[:args] || [], {}
    options = params[:args].pop if Hash === params[:args].last
    response.headers["Status"] = "301 Moved Permanently" if options.delete(:permanent)
    raise ArgumentError, "too many arguments" if args.size > 1
    
    id = @url.to_s.split(',')[2].strip.split('/').last
    args.first.gsub! ':id', id
    
    redirect_to args.empty? ? options : args.first
  end
end