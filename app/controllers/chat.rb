connections = []

App.controllers :chat do
	get :index, map: '/chat' do 
		halt 403, render(:login) unless params[:user]
	  render :chat, :locals => { :user => params[:user].gsub(/\W/, '') }
	end

	get :stream, map: '/chat/stream', provides: 'text/event-stream' do
	  stream :keep_open do |out|
	    connections << out
	    out.callback { connections.delete(out) } # when client disconnects then delete the connection
	  end
	end

	post :new, map: '/chat' do
	  connections.each { |out| out << "data: #{params[:msg]}\n\n" }
	  204
	end
end
