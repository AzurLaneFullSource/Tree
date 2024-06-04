ys = ys or {}

local var0 = class("BattleNodeBuff", ys.Battle.BattleBuffEffect)

ys.Battle.BattleNodeBuff = var0
var0.__name = "BattleNodeBuff"

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)
end

function var0.SetArgs(arg0, arg1, arg2)
	arg0._rate = arg0._tempData.arg_list.rate
end

function var0.onFire(arg0, arg1, arg2)
	if not ys.Battle.BattleFormulas.IsHappen(arg0._rate) then
		return
	end

	local var0 = arg0._tempData.arg_list
	local var1 = var0.node
	local var2 = var0.weapon
	local var3 = ys.Battle.BattleDataProxy.GetInstance():GetSeqCenter()

	for iter0, iter1 in ipairs(arg1:GetAutoWeapons()) do
		if iter1:GetWeaponId() == var2 then
			local var4 = var3:NewSeq("buff" .. arg0._id)
			local var5 = ys.Battle.NodeData.New(arg1, {
				weapon = iter1
			}, var4)

			pg.NodeMgr.GetInstance():GenNode(var5, pg.BattleNodesCfg[var1], var4)

			break
		end
	end
end
