ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleDrops")

var0_0.Battle.BattleDrops = var1_0
var1_0.__name = "BattleDrops"

function var1_0.Ctor(arg0_1, arg1_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)

	arg0_1._dropList = arg1_1
	arg0_1._resourceCount = 0
	arg0_1._itemCount = 0
end

function var1_0.CreateDrops(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2 = arg0_2._dropList[arg1_2]

	if var1_2 ~= nil and #var1_2 > 0 then
		var0_2 = var1_2[#var1_2]
		var1_2[#var1_2] = nil
	end

	if var0_2.resourceCount ~= nil then
		arg0_2._resourceCount = arg0_2._resourceCount + var0_2.resourceCount
	end

	if var0_2.itemCount ~= nil then
		arg0_2._itemCount = arg0_2._itemCount + var0_2.itemCount
	end

	return var0_2
end

function var1_0.GetDropped(arg0_3)
	return arg0_3._resourceCount, arg0_3._itemCount
end

function var1_0.Dispose(arg0_4)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_4)
end
