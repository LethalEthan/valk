module server

import util

pub struct Server {
	port	u16
mut:
	motd	string	
}

pub fn create_new() {

	conf := util.naml(util.root_folder+'config.naml') or {
		panic('malformed config!')
	}
	conf_net := conf.block[0]
	println(conf_net.block[0].content)

	// unsafe {
	// 	conf_net_port := conf_net[0]
	// 	if conf_net_port.content is util.NamlData.int {
	// 		println(conf_net_port.content)
	// 	}
	// }
}  