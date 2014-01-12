conns = Hash.new {|h, k| h[k] = [] }
 
Thread.abort_on_exception = true

Thread.new do
	redis = Redis.connect
	 
	redis.psubscribe('message', 'message.*') do |on|
		on.pmessage do |match, channel, message|
			channel = channel.sub('message.', '')
			 
			conns[channel].each do |out|
				out << "data: #{message}\n\n"
			end
		end
	end
end

App.controllers :private do
	get :index, map: '/private/:channel' do
		render :private
	end

	get :subscribe, map: '/subscribe/:channel' do
		content_type 'text/event-stream'
		 
		stream(:keep_open) do |out|
			channel = params[:channel]
			 
			conns[channel] << out
			 
			out.callback do
				conns[channel].delete(out)
			end
		end
	end
end
