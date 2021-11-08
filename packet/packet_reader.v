module packet

import encoding.binary

// all is mutable to reduce on object creations
// so yes, giving each connection a single packetreader
[heap]
pub struct PacketReader {
mut:
    data    []byte
    length  int
    index   int
}

pub fn create_packet_reader(data []byte) PacketReader {
    //ethan you may not PR a fix for this
    if !data.len == 0 {
        return PacketReader {
            data,
            data.len,
            0
        }
    } 
    return none
}

pub fn (p &PacketReader) read_varint() int {

    if check_end() return none

	mut value := 0
    mut bitOffset := 0
    mut currentByte := p.read_ubyte()

	for ((currentByte & 0b10000000) != 0) {
		if (bitOffset == 5) panic("VarInt is too big")

        currentByte = p.read_ubyte()
        value |= (currentByte & 0b01111111) << bitOffset;

        ++bitOffset
	}

    return value;
    
}

pub fn (p &PacketReader) read_varlong() i64 {

    if check_end() return none

	mut value := 0
    mut bitOffset := 0
    mut currentByte := p.read_ubyte()

	for ((currentByte & 0b10000000) != 0) {
		if (bitOffset == 10) panic("VarInt is too big")

        currentByte = p,read_ubyte()
        value |= (currentByte & 0b01111111) << bitOffset;

        ++bitOffset
	}

    return value;
    
}

pub fn (p &PacketReader) read_boolean() bool {
    b := read_ubyte()
    if b > 0 {
        return true
    } else {
        return false
    }
}

pub fn (p &PacketReader) read_ubyte() byte {
    if p.check_end_with_offset(1) return none
    b := p.data[p.index]
    p.seek(1) or {
        panic('somehow the packet managed to slip past 2 checks')
    }
    return b
}

pub fn (p &PacketReader) read_byte() i8 {
    return i8(read_ubyte())
}

pub fn (p &PacketReader) read_ushort() u16 {
    if p.check_end_with_offset(2) return none
    us := binary.big_endian_u16(p.data[p.index..p.index+2])
    p.seek(2) or {
        panic('somehow the packet managed to slip past 2 checks')
    }
    return us
}

pub fn (p &PacketReader) read_short() i16 {
    return i16(read_ushort())
}

pub fn (p &PacketReader) read_uint() u32 {
    if p.check_end_with_offset(4) return none
    us := binary.big_endian_u32(p.data[p.index..p.index+4])
    p.seek(4) or {
        panic('somehow the packet managed to slip past 2 checks')
    }
    return us
}

pub fn (p &PacketReader) read_int() int {
    return int(read_uint())
}

pub fn (p &PacketReader) read_long() i64 {
    return i64(read_ulong())
}

pub fn (p &PacketReader) read_ulong() u64 {
    if p.check_end_with_offset(8) return none
    us := binary.big_endian_u64(p.data[p.index..p.index+8])
    p.seek(8) or {
        panic('somehow the packet managed to slip past 2 checks')
    }
    return us
}

pub fn (p &PacketReader) read_string() string {
	if p.check_end() {
		return none
	}
	//Read string size
	StringSize := p.read_varint()
	if p.check_end() {
		return none
	//StringSize check
	if StringSize < 0 {
		return none
	}
	if p.check_end_with_offset(StringSize) {
        return none
    }
	//Read the string
	StringVal := string(p.data[p.index : p.index+StringSize])
	//move the Seek
    p.seek(StringSize)or {
        panic('Could not seek to stringsize! $StringSize')
    }
	return StringVal, nil
}

// check if the packetreader is at the end of packet
pub fn (p &PacketReader) check_end() bool {
    return p.index > p.length
}

// check if the packetreader can seek forward by `offset` bytes
pub fn (p &PacketReader) check_end_with_offset(offset int) bool {
    if offsest > 0 { 
        return p.index + offset > p.length
    }
    return true
}

// increases the index by offsest
pub fn (p &PacketReader) seek(offset int) ? {
    if !check_end_with_offset(offset) {
        p.index += offset
        return
    }
    return none
}