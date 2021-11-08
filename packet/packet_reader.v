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

pub fn create_packet_reader(data []byte) {
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
    mut currentByte := p.read_byte()

	for ((currentByte & 0b10000000) != 0) {
		if (bitOffset == 5) panic("VarInt is too big")

        currentByte = read_byte()
        value |= (currentByte & 0b01111111) << bitOffset;

        ++bitOffset
	}

    return value;
    
}

pub fn (p &PacketReader) read_byte() byte {
    if p.check_end_with_offset(1) return none
    b := p.data[p.index]
    p.seek(1) or {
        panic('somehow the packet managed to slip past 2 checks')
    }
    return b
}

pub fn (p &PacketReader) read_unsigned_short() u16 {
    if p.check_end_with_offset(2) return none
    us := binary.big_endian_u16(p.data[p.index..p.index+1])
    p.seek(2) or {
        panic('somehow the packet managed to slip past 2 checks')
    }
    return us
}

pub fn (p &PacketReader) read_short() i16 {
    return i16(read_signed_short())
}

// check if the packetreader is at the end of packet
pub fn (p &PacketReader) check_end() bool {
    return p.index >= p.length
}

// check if the packetreader can seek forward by `offset` bytes
pub fn (p &PacketReader) check_end_with_offset(offset int) bool {
    return p.index + offset >= p.length
}

// increases the index by offsest
pub fn (p &PacketReader) seek(offset int) ? {
    if !check_end_with_offset(offset) {
        p.index += offset
        return
    }
    return none
}