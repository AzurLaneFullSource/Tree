ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffAddAircraftTag = class("BattleBuffAddAircraftTag", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffAddAircraftTag.__name = "BattleBuffAddAircraftTag"

local var1 = var0.Battle.BattleBuffAddAircraftTag

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._labelTag = arg0._tempData.arg_list.tag_list
end

function var1.onAircraftCreate(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	local var0 = arg3.aircraft

	for iter0, iter1 in ipairs(arg0._labelTag) do
		if string.find(iter1, "^[NT]_%d+$") then
			pg.TipsMgr.GetInstance():ShowTips(">>BattleBuffAddAircraftTag<<不允许使用'N_'或'T_'标签")
		else
			var0:AddLabelTag(iter1)
		end
	end
end
