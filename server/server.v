module server

import net
import log
import x.json2

import util

pub struct Server {
	icon	string
mut:
	motd	string
pub:
	port	int
pub mut:
	tcp		&net.TcpListener
}

pub fn create_new() Server {

	mut logger := log.Log {
		level: log.Level.info
		output_target: log.LogTarget.console
	}

	conf := util.get_config()

	net_conf := conf['net'] or { panic(bad_section('net')) }.as_map()
	server_conf := conf['server'] or { panic(bad_section('server')) }.as_map()

	port := net_conf['port'] or { panic(bad_field('port')) }.str()
	motd := server_conf['motd'] or { 
		logger.error(bad_field('motd'))
		json2.Any('This server is running Valk!')	
	}.str()
	icon := server_conf['icon'] or { json2.Any('') }.str()

	return Server{
		port: port.int()
		icon: icon
		tcp: net.listen_tcp(net.AddrFamily.ip, '0.0.0.0:$port') or {
			panic('could not start to listen on port $port')
		} 
		motd: motd
	}
}

pub fn (s Server) str() string {
	return '$s.port, $s.motd, $s.icon'
}

fn bad_section(str string) string {
	return 'can not read section "$str" in config. please check your configuration file!'
}

fn bad_field(str string) string {
	return 'can not read field "$str"'
}