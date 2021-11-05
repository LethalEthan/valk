module util

import os

pub const (
	root_folder_win = os.executable().all_before('valk.exe')
	root_folder_nix = os.executable().all_before_last('valk')
	operating_system = os.user_os()
)

pub fn setup_file_structure() bool {
	return setup_config()
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