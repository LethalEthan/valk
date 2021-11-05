module util

import os

pub const (
	root_folder = os.executable().all_before('valk.exe')
)

pub fn setup_file_structure() bool {
	return setup_config()
}

fn setup_config() bool {
	config_path := '${os.executable().all_before('valk.exe')}config.json'

	if !os.exists(config_path) {
		os.create(config_path) or {
			panic('could not create config')
		}
		os.write_file(config_path,
//yes, this is ugly and i could do it better but hey, it works
'{
	"net": {
		"port": 25565
	},
	"serverinfo": {
		"motd": "This server is running on Valk!",
		"icon": ""
	}
}'
		) or {
			panic('could not write to config')
		}
		return true
	}
	return false
}