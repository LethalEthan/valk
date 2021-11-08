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

	//TODO: handle incoming traffic correctly
	accept_conn(mut server, mut logger)
}

fn accept_conn(mut server server.Server, mut logger log.Log) {
	for {
		mut conn := server.tcp.accept() or {
			logger.error('could not receive connection')
			continue
		}
		conn.set_blocking(true) or { panic('could not set connection to blocking') }
		addr := conn.addr() or { panic('unable to get address from connection') }
		logger.info('connection received from $addr')
		go handle_conn(mut conn, mut logger, addr)
	}
}

fn handle_conn(mut conn net.TcpConn, mut logger log.Log, addr net.Addr) {
	mut buf := []byte{len: 2097151}
	mut byte_counter := 0
	for {
		byte_counter = conn.read(mut buf) or { 
			logger.info('client<$addr> has disconnected')
			return
		}
		// if buf[0] > byte_counter-1 || buf[0] < byte_counter-1 {
		// 	logger.error('packet is the wrong size! expected: ${buf[0]}, got: $byte_counter')
		// }
		logger.info('read: ${buf[..byte_counter].str()} | size of $byte_counter bytes')
	}
}