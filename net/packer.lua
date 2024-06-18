pg = pg or {}

local var0_0 = pg

var0_0.Packer = singletonClass("Packer")

local var1_0 = var0_0.Packer

var1_0.ps = nil

function var1_0.Ctor(arg0_1)
	arg0_1._protocols = {}
	var1_0.ps = PackStream.New()
	arg0_1.defaultBuffSize = 8192
end

function var1_0.Pack(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = arg3_2:SerializeToString()
	local var1_2 = ""
	local var2_2 = arg0_2.ps

	if #var0_2 > arg0_2.defaultBuffSize - 7 then
		var2_2 = PackStream.New(#var0_2 + 7)
	end

	if var2_2.Length ~= 0 then
		print("### pack string error !!!!!!!!!!!")
	end

	if #var0_2 == 0 then
		var2_2:WriteUint16(6)
	else
		var2_2:WriteUint16(5 + #var0_2)
	end

	var2_2:WriteUint8(0)
	var2_2:WriteUint16(arg2_2)
	var2_2:WriteUint16(arg1_2)
	var2_2:WriteBuffer(var0_2)

	return var2_2:ToArray()
end

function var1_0.Unpack(arg0_3, arg1_3, arg2_3)
	local var0_3 = var1_0.GetInstance():GetProtocolWithName("sc_" .. arg1_3)

	if var0_3 ~= nil then
		local var1_3 = var0_3._object[var0_3._name]()

		var1_3:ParseFromString(arg2_3)

		return var1_3
	end
end

function var1_0.GetProtocolWithName(arg0_4, arg1_4)
	if arg0_4._protocols[arg1_4] ~= nil then
		return arg0_4._protocols[arg1_4]
	end

	local var0_4 = string.sub(arg1_4, 4, #arg1_4)
	local var1_4 = "Net/Protocol/"
	local var2_4 = "p" .. string.sub(var0_4, 1, 2) .. "_pb"
	local var3_4

	pcall(function()
		var3_4 = require(var1_4 .. var2_4)
	end)

	if var3_4 then
		local var4_4 = var0_0.Protocol.New(var0_4, arg1_4, package.loaded[var2_4])

		arg0_4._protocols[arg1_4] = var4_4

		return var4_4
	else
		return nil
	end
end
