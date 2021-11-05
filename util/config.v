module util

import os
import x.json2

pub fn get_config() map[string]json2.Any {
	conf_str := os.read_file(util.root_folder+'config.json') or {
		panic('failed to load config')
	}

	conf_jsonstr := json2.fast_raw_decode(conf_str) or {
		panic('failed to decode json')
	}

	return conf_jsonstr.as_map()
}

