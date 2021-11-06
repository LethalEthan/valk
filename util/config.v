module util

import os
import x.json2

const (
	//this is the correct way to use constants... right?
	config_content = 
'{
	"net": {
		"port": 25565
	},
	"server": {
		"motd": "This server is running on Valk!",
		"icon": ""
	},
	"world": {
		"seed": "",
		"enable_end": true,
		"enable_nether": true
	}
}'
)

pub fn get_config() map[string]json2.Any {

	mut conf_str := ''
	
	if operating_system == 'windows' {
		conf_str = os.read_file(root_folder_win+'config.json') or {
			panic('failed to load config')
		}
	} else {
		conf_str = os.read_file(root_folder_nix+'config.json') or {
			panic('failed to load config')
		}
	}

	conf_jsonstr := json2.fast_raw_decode(conf_str) or {
		panic('failed to decode json')
	}

	return conf_jsonstr.as_map()
}

fn setup_config() bool {

	mut config_path := ''
	//readd os check
	if os.user_os() == 'windows' {
		config_path = '${os.executable().all_before('valk.exe')}config.json'
	} else {
		config_path = '${os.executable().all_before_last('valk')}config.json'
	}

	if !os.exists(config_path) {
		os.create(config_path) or {
			panic('could not create config')
		}
		os.write_file(config_path, config_content) or {
			panic('could not write to config')
		}
		return true
	}
	return false
}