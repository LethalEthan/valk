module main

import os
import log
import net

import util
import server

fn main() {

	mut logger := log.Log{
		level: log.Level.info
		output_target: log.LogTarget.console
	}

	logger.info('welcome to valk!')
	logger.info('getting basic system diagnostics...')
	logger.info('current os: ${os.user_os()}')
	logger.info('check if all files exist...')
	if util.setup_file_structure() {
		logger.info('created files!')
	} 
	logger.info('looks good! starting...')

	mut server := server.create_new()
	logger.info('listening on port $server.port')
	server.tcp.sock.set_option_bool(net.SocketOption.keep_alive, true) or {
		panic('failed to set option')
	}

	for {
		conn := server.tcp.accept() or { panic(err) }
		println(conn)
	}
}