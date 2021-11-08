module packet.login

// serverbound packet 0x00
pub struct SB_Handshake {
	protocol_ver	int		// protocol version as int
	server_addr		string  // e.g. localhost, play.monkegame.online etc
	server_port		u16	 	// 0 to 65535
	next_state		byte 	// 1 for status ping, 2 for continue with login
}

// serverbound packet 0x00
pub struct SB_LoginStart {
	name	string
}

// serverbound packet 0x01
pub struct SB_EncryptResp {
	secret_length	int
	secret			[]byte
	verify_length	int
	verify_token	[]byte
}