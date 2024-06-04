ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = class("BattleLastingAOEData", var0.Battle.BattleAOEData)

var0.Battle.BattleLastingAOEData = var2
var2.__name = "BattleLastingAOEData"

function var2.Ctor(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	var2.super.Ctor(arg0, arg1, arg2, arg3, arg5)

	arg0._exitCldFunc = arg4

	if arg6 then
		arg0.Settle = arg0.frequentlySettle
	end

	arg0._handledList = {}
end

function var2.Dispose(arg0)
	for iter0, iter1 in pairs(arg0._handledList) do
		arg0._exitCldFunc(iter0)

		arg0._handledList[iter0] = nil
	end

	arg0._exitCldFunc = nil
	arg0._handledList = nil

	var2.super.Dispose(arg0)
end

function var2.Settle(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg0._cldObjList) do
		var1[iter1.UID] = true

		if not arg0._handledList[iter1] then
			var0[#var0 + 1] = iter1
			arg0._handledList[iter1] = true
		end
	end

	arg0.SortCldObjList(var0)
	arg0._cldComponent:GetCldData().func(var0, obj)

	for iter2, iter3 in pairs(arg0._handledList) do
		if not var1[iter2.UID] or iter2.ImmuneCLD == true then
			arg0._exitCldFunc(iter2)

			arg0._handledList[iter2] = nil
		end
	end
end

function var2.frequentlySettle(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0._cldObjList) do
		var0[iter1.UID] = true

		if not arg0._handledList[iter1] then
			arg0._handledList[iter1] = true
		end
	end

	for iter2, iter3 in pairs(arg0._handledList) do
		if not var0[iter2.UID] then
			arg0._exitCldFunc(iter2)

			arg0._handledList[iter2] = nil
		end
	end

	arg0.SortCldObjList(arg0._cldObjList)
	arg0._cldComponent:GetCldData().func(arg0._cldObjList)
end

function var2.ForceExit(arg0, arg1)
	local var0

	for iter0, iter1 in pairs(arg0._handledList) do
		if iter0.UID == arg1 then
			var0 = iter0

			break
		end
	end

	if var0 then
		arg0._exitCldFunc(var0)

		arg0._handledList[var0] = nil
	end
end
