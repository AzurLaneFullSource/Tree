local var0_0 = require("protobuf")
local var1_0 = require("common_pb")

module("p70_pb")

SC_70000 = var0_0.Descriptor()

local var2_0 = var0_0.FieldDescriptor()

CS_70001 = var0_0.Descriptor()

local var3_0 = var0_0.FieldDescriptor()
local var4_0 = var0_0.FieldDescriptor()

SC_70002 = var0_0.Descriptor()

local var5_0 = var0_0.FieldDescriptor()

CS_70003 = var0_0.Descriptor()

local var6_0 = var0_0.FieldDescriptor()

SC_70004 = var0_0.Descriptor()

local var7_0 = var0_0.FieldDescriptor()

CS_70005 = var0_0.Descriptor()

local var8_0 = var0_0.FieldDescriptor()

SC_70006 = var0_0.Descriptor()

local var9_0 = var0_0.FieldDescriptor()
local var10_0 = var0_0.FieldDescriptor()

var2_0.name = "meta_char_list"
var2_0.full_name = ".p70.sc_70000.meta_char_list"
var2_0.number = 1
var2_0.index = 0
var2_0.label = 3
var2_0.has_default_value = false
var2_0.default_value = {}
var2_0.message_type = var1_0.METACHARINFO
var2_0.type = 11
var2_0.cpp_type = 10
SC_70000.name = "sc_70000"
SC_70000.full_name = ".p70.sc_70000"
SC_70000.nested_types = {}
SC_70000.enum_types = {}
SC_70000.fields = {
	var2_0
}
SC_70000.is_extendable = false
SC_70000.extensions = {}
var3_0.name = "id"
var3_0.full_name = ".p70.cs_70001.id"
var3_0.number = 1
var3_0.index = 0
var3_0.label = 2
var3_0.has_default_value = false
var3_0.default_value = 0
var3_0.type = 13
var3_0.cpp_type = 3
var4_0.name = "attr_list"
var4_0.full_name = ".p70.cs_70001.attr_list"
var4_0.number = 2
var4_0.index = 1
var4_0.label = 3
var4_0.has_default_value = false
var4_0.default_value = {}
var4_0.type = 13
var4_0.cpp_type = 3
CS_70001.name = "cs_70001"
CS_70001.full_name = ".p70.cs_70001"
CS_70001.nested_types = {}
CS_70001.enum_types = {}
CS_70001.fields = {
	var3_0,
	var4_0
}
CS_70001.is_extendable = false
CS_70001.extensions = {}
var5_0.name = "result"
var5_0.full_name = ".p70.sc_70002.result"
var5_0.number = 1
var5_0.index = 0
var5_0.label = 2
var5_0.has_default_value = false
var5_0.default_value = 0
var5_0.type = 13
var5_0.cpp_type = 3
SC_70002.name = "sc_70002"
SC_70002.full_name = ".p70.sc_70002"
SC_70002.nested_types = {}
SC_70002.enum_types = {}
SC_70002.fields = {
	var5_0
}
SC_70002.is_extendable = false
SC_70002.extensions = {}
var6_0.name = "id"
var6_0.full_name = ".p70.cs_70003.id"
var6_0.number = 1
var6_0.index = 0
var6_0.label = 2
var6_0.has_default_value = false
var6_0.default_value = 0
var6_0.type = 13
var6_0.cpp_type = 3
CS_70003.name = "cs_70003"
CS_70003.full_name = ".p70.cs_70003"
CS_70003.nested_types = {}
CS_70003.enum_types = {}
CS_70003.fields = {
	var6_0
}
CS_70003.is_extendable = false
CS_70003.extensions = {}
var7_0.name = "result"
var7_0.full_name = ".p70.sc_70004.result"
var7_0.number = 1
var7_0.index = 0
var7_0.label = 2
var7_0.has_default_value = false
var7_0.default_value = 0
var7_0.type = 13
var7_0.cpp_type = 3
SC_70004.name = "sc_70004"
SC_70004.full_name = ".p70.sc_70004"
SC_70004.nested_types = {}
SC_70004.enum_types = {}
SC_70004.fields = {
	var7_0
}
SC_70004.is_extendable = false
SC_70004.extensions = {}
var8_0.name = "id"
var8_0.full_name = ".p70.cs_70005.id"
var8_0.number = 1
var8_0.index = 0
var8_0.label = 2
var8_0.has_default_value = false
var8_0.default_value = 0
var8_0.type = 13
var8_0.cpp_type = 3
CS_70005.name = "cs_70005"
CS_70005.full_name = ".p70.cs_70005"
CS_70005.nested_types = {}
CS_70005.enum_types = {}
CS_70005.fields = {
	var8_0
}
CS_70005.is_extendable = false
CS_70005.extensions = {}
var9_0.name = "result"
var9_0.full_name = ".p70.sc_70006.result"
var9_0.number = 1
var9_0.index = 0
var9_0.label = 2
var9_0.has_default_value = false
var9_0.default_value = 0
var9_0.type = 13
var9_0.cpp_type = 3
var10_0.name = "ship"
var10_0.full_name = ".p70.sc_70006.ship"
var10_0.number = 2
var10_0.index = 1
var10_0.label = 1
var10_0.has_default_value = false
var10_0.default_value = nil
var10_0.message_type = var1_0.SHIPINFO
var10_0.type = 11
var10_0.cpp_type = 10
SC_70006.name = "sc_70006"
SC_70006.full_name = ".p70.sc_70006"
SC_70006.nested_types = {}
SC_70006.enum_types = {}
SC_70006.fields = {
	var9_0,
	var10_0
}
SC_70006.is_extendable = false
SC_70006.extensions = {}
cs_70001 = var0_0.Message(CS_70001)
cs_70003 = var0_0.Message(CS_70003)
cs_70005 = var0_0.Message(CS_70005)
sc_70000 = var0_0.Message(SC_70000)
sc_70002 = var0_0.Message(SC_70002)
sc_70004 = var0_0.Message(SC_70004)
sc_70006 = var0_0.Message(SC_70006)
