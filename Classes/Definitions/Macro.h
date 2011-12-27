//
//  Macros.h
//  SuperSample
//
//  Created by Eugene Pavlyuk on 11/3/11.
//  Copyright (c) 2011 QuickBlox. All rights reserved.
//

#ifndef SuperSample_Macros_h
#define SuperSample_Macros_h

#define SERIALIZE_OBJECT(var_name, coder)		[coder encodeObject:var_name forKey:@#var_name]
#define SERIALIZE_INT(var_name, coder)			[coder encodeInt:var_name forKey:@#var_name]
#define SERIALIZE_FLOAT(var_name, coder)		[coder encodeFloat:var_name forKey:@#var_name]
#define SERIALIZE_DOUBLE(var_name, coder)		[coder encodeDouble:var_name forKey:@#var_name]
#define SERIALIZE_BOOL(var_name, coder)			[coder encodeBool:var_name forKey:@#var_name]

#define DESERIALIZE_OBJECT(var_name, decoder)	var_name = [[decoder decodeObjectForKey:@#var_name] retain]
#define DESERIALIZE_INT(var_name, decoder)		var_name = [decoder decodeIntForKey:@#var_name]
#define DESERIALIZE_FLOAT(var_name, decoder)	var_name = [decoder decodeFloatForKey:@#var_name]
#define DESERIALIZE_DOUBLE(var_name, decoder)	var_name = [decoder decodeDoubleForKey:@#var_name]
#define DESERIALIZE_BOOL(var_name, decoder)		var_name = [decoder decodeBoolForKey:@#var_name]

#endif
