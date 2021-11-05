module server

import net

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

	conf := util.get_config()

	net_conf := conf['net'] or { panic(bad_section('net')) }.as_map()
	serverinfo_conf := conf['server'] or { panic(bad_section('server')) }.as_map()

	port := net_conf['port'] or {panic('can not read field')}.str()
	motd := serverinfo_conf['motd'] or {panic('can not read field')}.str()
	icon := serverinfo_conf['icon'] or {panic('can not read field')}.str()

	return Server{
		port: port.int()
		icon: icon
		tcp: net.listen_tcp(net.AddrFamily.ip, 'localhost:$port') or {
			panic('could not start to listen on port $port')
		} 
		motd: motd
	}
}

pub fn (s Server) str() string {
	return '$s.port, $s.motd, $s.icon'
}

fn bad_section(str string) string {
	return 'can not read section "$str" in config'
}