ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = class("BattleLastingAOEData", var0_0.Battle.BattleAOEData)

var0_0.Battle.BattleLastingAOEData = var2_0
var2_0.__name = "BattleLastingAOEData"

function var2_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1, arg6_1)
	var2_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg5_1)

	arg0_1._exitCldFunc = arg4_1

	if arg6_1 then
		arg0_1.Settle = arg0_1.frequentlySettle
	end

	arg0_1._handledList = {}
end

function var2_0.Dispose(arg0_2)
	for iter0_2, iter1_2 in pairs(arg0_2._handledList) do
		arg0_2._exitCldFunc(iter0_2)

		arg0_2._handledList[iter0_2] = nil
	end

	arg0_2._exitCldFunc = nil
	arg0_2._handledList = nil

	var2_0.super.Dispose(arg0_2)
end

function var2_0.Settle(arg0_3)
	local var0_3 = {}
	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3._cldObjList) do
		var1_3[iter1_3.UID] = true

		if not arg0_3._handledList[iter1_3] then
			var0_3[#var0_3 + 1] = iter1_3
			arg0_3._handledList[iter1_3] = true
		end
	end

	arg0_3.SortCldObjList(var0_3)
	arg0_3._cldComponent:GetCldData().func(var0_3, obj)

	for iter2_3, iter3_3 in pairs(arg0_3._handledList) do
		if not var1_3[iter2_3.UID] or iter2_3.ImmuneCLD == true then
			arg0_3._exitCldFunc(iter2_3)

			arg0_3._handledList[iter2_3] = nil
		end
	end
end

function var2_0.frequentlySettle(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4._cldObjList) do
		var0_4[iter1_4.UID] = true

		if not arg0_4._handledList[iter1_4] then
			arg0_4._handledList[iter1_4] = true
		end
	end

	for iter2_4, iter3_4 in pairs(arg0_4._handledList) do
		if not var0_4[iter2_4.UID] then
			arg0_4._exitCldFunc(iter2_4)

			arg0_4._handledList[iter2_4] = nil
		end
	end

	arg0_4.SortCldObjList(arg0_4._cldObjList)
	arg0_4._cldComponent:GetCldData().func(arg0_4._cldObjList)
end

function var2_0.ForceExit(arg0_5, arg1_5)
	local var0_5

	for iter0_5, iter1_5 in pairs(arg0_5._handledList) do
		if iter0_5.UID == arg1_5 then
			var0_5 = iter0_5

			break
		end
	end

	if var0_5 then
		arg0_5._exitCldFunc(var0_5)

		arg0_5._handledList[var0_5] = nil
	end
end
