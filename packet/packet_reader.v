module packet

pub fn read_varint() int {
	mut value := 0
    mut bitOffset := 0
    mut currentByte := byte(0)

	for ((currentByte & 0b10000000) != 0) {
		if (bitOffset == 5) panic("VarInt is too big")

        currentByte = readByte()
        value |= (currentByte & 0b01111111) << bitOffset;

        ++bitOffset
	}

    return value;
}

pub fn read_byte() {
	return byte
}