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

