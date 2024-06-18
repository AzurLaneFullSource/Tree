ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffAddAircraftTag = class("BattleBuffAddAircraftTag", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffAddAircraftTag.__name = "BattleBuffAddAircraftTag"

local var1_0 = var0_0.Battle.BattleBuffAddAircraftTag

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._labelTag = arg0_2._tempData.arg_list.tag_list
end

function var1_0.onAircraftCreate(arg0_3, arg1_3, arg2_3, arg3_3)
	if not arg0_3:equipIndexRequire(arg3_3.equipIndex) then
		return
	end

	local var0_3 = arg3_3.aircraft

	for iter0_3, iter1_3 in ipairs(arg0_3._labelTag) do
		if string.find(iter1_3, "^[NT]_%d+$") then
			pg.TipsMgr.GetInstance():ShowTips(">>BattleBuffAddAircraftTag<<不允许使用'N_'或'T_'标签")
		else
			var0_3:AddLabelTag(iter1_3)
		end
	end
end
