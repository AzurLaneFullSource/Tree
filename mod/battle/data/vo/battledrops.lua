ys = ys or {}

local var0 = ys
local var1 = class("BattleDrops")

var0.Battle.BattleDrops = var1
var1.__name = "BattleDrops"

function var1.Ctor(arg0, arg1)
	var0.EventDispatcher.AttachEventDispatcher(arg0)

	arg0._dropList = arg1
	arg0._resourceCount = 0
	arg0._itemCount = 0
end

function var1.CreateDrops(arg0, arg1)
	local var0 = {}
	local var1 = arg0._dropList[arg1]

	if var1 ~= nil and #var1 > 0 then
		var0 = var1[#var1]
		var1[#var1] = nil
	end

	if var0.resourceCount ~= nil then
		arg0._resourceCount = arg0._resourceCount + var0.resourceCount
	end

	if var0.itemCount ~= nil then
		arg0._itemCount = arg0._itemCount + var0.itemCount
	end

	return var0
end

function var1.GetDropped(arg0)
	return arg0._resourceCount, arg0._itemCount
end

function var1.Dispose(arg0)
	var0.EventDispatcher.DetachEventDispatcher(arg0)
end
