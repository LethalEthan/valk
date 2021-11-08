module nbt

// the type ID is in the comment
pub enum NBTType {
	tag_end			//0
	tag_byte		//1
	tag_short		//2
	tag_int			//3
	tag_long		//4
	tag_float		//5
	tag_double		//6
	tag_byte_array	//7
	tag_string		//8
	tag_list		//9
	tag_compound	//10
	tag_int_array	//11
	tag_long_array	//12
}