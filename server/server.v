module server

import util

pub struct Server {
	port	int
	icon	string
mut:
	motd	string
}

pub fn create_new() Server {

	conf := util.get_config()

	net_conf := conf['net'] or { panic(bad_section('net')) }.as_map()
	serverinfo_conf := conf['serverinfo'] or { panic(bad_section('serverinfo')) }.as_map()

	
	return Server{
		net_conf['port'] or {panic('can not read field')}.int(), 
		serverinfo_conf['motd'] or {panic('can not read field')}.str()
		serverinfo_conf['icon'] or {panic('can not read field')}.str()
	}
}

pub fn (s Server) str() string {
	return '$s.port, $s.motd, $s.icon'
}

fn bad_section(str string) string {
	return 'can not read section "$str" in config'
}