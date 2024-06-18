ys = ys or {}

local var0_0 = class("BattleNodeBuff", ys.Battle.BattleBuffEffect)

ys.Battle.BattleNodeBuff = var0_0
var0_0.__name = "BattleNodeBuff"

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)
end

function var0_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._rate = arg0_2._tempData.arg_list.rate
end

function var0_0.onFire(arg0_3, arg1_3, arg2_3)
	if not ys.Battle.BattleFormulas.IsHappen(arg0_3._rate) then
		return
	end

	local var0_3 = arg0_3._tempData.arg_list
	local var1_3 = var0_3.node
	local var2_3 = var0_3.weapon
	local var3_3 = ys.Battle.BattleDataProxy.GetInstance():GetSeqCenter()

	for iter0_3, iter1_3 in ipairs(arg1_3:GetAutoWeapons()) do
		if iter1_3:GetWeaponId() == var2_3 then
			local var4_3 = var3_3:NewSeq("buff" .. arg0_3._id)
			local var5_3 = ys.Battle.NodeData.New(arg1_3, {
				weapon = iter1_3
			}, var4_3)

			pg.NodeMgr.GetInstance():GenNode(var5_3, pg.BattleNodesCfg[var1_3], var4_3)

			break
		end
	end
end
