local var0 = require("protobuf")
local var1 = require("common_pb")

module("p70_pb")

SC_70000 = var0.Descriptor()

local var2 = var0.FieldDescriptor()

CS_70001 = var0.Descriptor()

local var3 = var0.FieldDescriptor()
local var4 = var0.FieldDescriptor()

SC_70002 = var0.Descriptor()

local var5 = var0.FieldDescriptor()

CS_70003 = var0.Descriptor()

local var6 = var0.FieldDescriptor()

SC_70004 = var0.Descriptor()

local var7 = var0.FieldDescriptor()

CS_70005 = var0.Descriptor()

local var8 = var0.FieldDescriptor()

SC_70006 = var0.Descriptor()

local var9 = var0.FieldDescriptor()
local var10 = var0.FieldDescriptor()

var2.name = "meta_char_list"
var2.full_name = ".p70.sc_70000.meta_char_list"
var2.number = 1
var2.index = 0
var2.label = 3
var2.has_default_value = false
var2.default_value = {}
var2.message_type = var1.METACHARINFO
var2.type = 11
var2.cpp_type = 10
SC_70000.name = "sc_70000"
SC_70000.full_name = ".p70.sc_70000"
SC_70000.nested_types = {}
SC_70000.enum_types = {}
SC_70000.fields = {
	var2
}
SC_70000.is_extendable = false
SC_70000.extensions = {}
var3.name = "id"
var3.full_name = ".p70.cs_70001.id"
var3.number = 1
var3.index = 0
var3.label = 2
var3.has_default_value = false
var3.default_value = 0
var3.type = 13
var3.cpp_type = 3
var4.name = "attr_list"
var4.full_name = ".p70.cs_70001.attr_list"
var4.number = 2
var4.index = 1
var4.label = 3
var4.has_default_value = false
var4.default_value = {}
var4.type = 13
var4.cpp_type = 3
CS_70001.name = "cs_70001"
CS_70001.full_name = ".p70.cs_70001"
CS_70001.nested_types = {}
CS_70001.enum_types = {}
CS_70001.fields = {
	var3,
	var4
}
CS_70001.is_extendable = false
CS_70001.extensions = {}
var5.name = "result"
var5.full_name = ".p70.sc_70002.result"
var5.number = 1
var5.index = 0
var5.label = 2
var5.has_default_value = false
var5.default_value = 0
var5.type = 13
var5.cpp_type = 3
SC_70002.name = "sc_70002"
SC_70002.full_name = ".p70.sc_70002"
SC_70002.nested_types = {}
SC_70002.enum_types = {}
SC_70002.fields = {
	var5
}
SC_70002.is_extendable = false
SC_70002.extensions = {}
var6.name = "id"
var6.full_name = ".p70.cs_70003.id"
var6.number = 1
var6.index = 0
var6.label = 2
var6.has_default_value = false
var6.default_value = 0
var6.type = 13
var6.cpp_type = 3
CS_70003.name = "cs_70003"
CS_70003.full_name = ".p70.cs_70003"
CS_70003.nested_types = {}
CS_70003.enum_types = {}
CS_70003.fields = {
	var6
}
CS_70003.is_extendable = false
CS_70003.extensions = {}
var7.name = "result"
var7.full_name = ".p70.sc_70004.result"
var7.number = 1
var7.index = 0
var7.label = 2
var7.has_default_value = false
var7.default_value = 0
var7.type = 13
var7.cpp_type = 3
SC_70004.name = "sc_70004"
SC_70004.full_name = ".p70.sc_70004"
SC_70004.nested_types = {}
SC_70004.enum_types = {}
SC_70004.fields = {
	var7
}
SC_70004.is_extendable = false
SC_70004.extensions = {}
var8.name = "id"
var8.full_name = ".p70.cs_70005.id"
var8.number = 1
var8.index = 0
var8.label = 2
var8.has_default_value = false
var8.default_value = 0
var8.type = 13
var8.cpp_type = 3
CS_70005.name = "cs_70005"
CS_70005.full_name = ".p70.cs_70005"
CS_70005.nested_types = {}
CS_70005.enum_types = {}
CS_70005.fields = {
	var8
}
CS_70005.is_extendable = false
CS_70005.extensions = {}
var9.name = "result"
var9.full_name = ".p70.sc_70006.result"
var9.number = 1
var9.index = 0
var9.label = 2
var9.has_default_value = false
var9.default_value = 0
var9.type = 13
var9.cpp_type = 3
var10.name = "ship"
var10.full_name = ".p70.sc_70006.ship"
var10.number = 2
var10.index = 1
var10.label = 1
var10.has_default_value = false
var10.default_value = nil
var10.message_type = var1.SHIPINFO
var10.type = 11
var10.cpp_type = 10
SC_70006.name = "sc_70006"
SC_70006.full_name = ".p70.sc_70006"
SC_70006.nested_types = {}
SC_70006.enum_types = {}
SC_70006.fields = {
	var9,
	var10
}
SC_70006.is_extendable = false
SC_70006.extensions = {}
cs_70001 = var0.Message(CS_70001)
cs_70003 = var0.Message(CS_70003)
cs_70005 = var0.Message(CS_70005)
sc_70000 = var0.Message(SC_70000)
sc_70002 = var0.Message(SC_70002)
sc_70004 = var0.Message(SC_70004)
sc_70006 = var0.Message(SC_70006)
