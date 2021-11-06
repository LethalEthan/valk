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