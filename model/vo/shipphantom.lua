local var0_0 = class("ShipPhantom", import(".Ship"))

function var0_0.Change(arg0_1, arg1_1)
	assert(arg0_1.__cname == "Ship")
	setmetatable(arg0_1, var0_0)

	arg0_1.class = var0_0
	arg0_1.phantomId = arg1_1

	return arg0_1
end

function var0_0.Revert(arg0_2)
	assert(arg0_2.__cname == "ShipPhantom")
	setmetatable(arg0_2, Ship)

	arg0_2.class = Ship
	arg0_2.phantomId = nil

	return arg0_2
end

function var0_0.Create(arg0_3, arg1_3)
	assert(arg0_3.__cname == "Ship")

	local var0_3 = cloneRawTableFormClass(arg0_3)

	var0_3.phantomId = arg1_3

	setmetatable(var0_3, var0_0)

	var0_3.class = var0_0

	return var0_3
end

function var0_0.getSkinId(arg0_4, arg1_4)
	return var0_0.super.getSkinId(arg0_4, arg1_4 or arg0_4.phantomId)
end

function var0_0.GetShipPhantomMark(arg0_5, arg1_5)
	return var0_0.super.GetShipPhantomMark(arg0_5, arg1_5 or arg0_5.phantomId)
end

function var0_0.getRandomFlag(arg0_6)
	return var0_0.super.getRandomFlag(arg0_6, arg0_6.phantomId)
end

function var0_0.GetSelectMark(arg0_7)
	return arg0_7:GetShipPhantomMark()
end

function var0_0.PackMark(arg0_8, arg1_8)
	return arg0_8 .. "_" .. (arg1_8 or 0)
end

function var0_0.UnpackMark(arg0_9)
	return unpack(underscore.map(string.split(arg0_9, "_"), function(arg0_10)
		return tonumber(arg0_10)
	end))
end

return var0_0
