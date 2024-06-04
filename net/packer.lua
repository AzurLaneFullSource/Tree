pg = pg or {}

local var0 = pg

var0.Packer = singletonClass("Packer")

local var1 = var0.Packer

var1.ps = nil

function var1.Ctor(arg0)
	arg0._protocols = {}
	var1.ps = PackStream.New()
	arg0.defaultBuffSize = 8192
end

function var1.Pack(arg0, arg1, arg2, arg3)
	local var0 = arg3:SerializeToString()
	local var1 = ""
	local var2 = arg0.ps

	if #var0 > arg0.defaultBuffSize - 7 then
		var2 = PackStream.New(#var0 + 7)
	end

	if var2.Length ~= 0 then
		print("### pack string error !!!!!!!!!!!")
	end

	if #var0 == 0 then
		var2:WriteUint16(6)
	else
		var2:WriteUint16(5 + #var0)
	end

	var2:WriteUint8(0)
	var2:WriteUint16(arg2)
	var2:WriteUint16(arg1)
	var2:WriteBuffer(var0)

	return var2:ToArray()
end

function var1.Unpack(arg0, arg1, arg2)
	local var0 = var1.GetInstance():GetProtocolWithName("sc_" .. arg1)

	if var0 ~= nil then
		local var1 = var0._object[var0._name]()

		var1:ParseFromString(arg2)

		return var1
	end
end

function var1.GetProtocolWithName(arg0, arg1)
	if arg0._protocols[arg1] ~= nil then
		return arg0._protocols[arg1]
	end

	local var0 = string.sub(arg1, 4, #arg1)
	local var1 = "Net/Protocol/"
	local var2 = "p" .. string.sub(var0, 1, 2) .. "_pb"
	local var3

	pcall(function()
		var3 = require(var1 .. var2)
	end)

	if var3 then
		local var4 = var0.Protocol.New(var0, arg1, package.loaded[var2])

		arg0._protocols[arg1] = var4

		return var4
	else
		return nil
	end
end
