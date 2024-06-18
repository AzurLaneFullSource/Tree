ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSpecialWeapon", var0_0.Battle.BattleWeaponUnit)

var0_0.Battle.BattleSpecialWeapon = var1_0
var1_0.__name = "BattleSpecialWeapon"

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.CheckPreCast(arg0_2)
	local var0_2 = arg0_2._dataProxy:GetSeqCenter()
	local var1_2 = arg0_2._tmpData.bullet_ID[1]

	if not var1_2 then
		arg0_2._castInfo = {
			weapon = arg0_2
		}

		return true
	end

	local var2_2 = var0_2:NewSeq("precast")
	local var3_2 = var0_0.Battle.NodeData.New(arg0_2._host, {
		weapon = arg0_2
	}, var2_2)

	pg.NodeMgr.GetInstance():GenNode(var3_2, pg.BattleNodesCfg[var1_2], var2_2)

	local var4_2 = var3_2:GetData()

	if var4_2.targets[1] == nil then
		return false
	end

	arg0_2._castInfo = var4_2

	return true
end

function var1_0.Fire(arg0_3)
	assert(arg0_3._castInfo ~= nil, "需要指定施法信息，有特殊需求可默认指定为{ weapon = self }")

	local var0_3 = arg0_3._dataProxy:GetSeqCenter()
	local var1_3 = arg0_3._tmpData.bullet_ID[1]
	local var2_3 = arg0_3._castInfo
	local var3_3 = var0_3:NewSeq("cast")
	local var4_3 = var0_0.Battle.NodeData.New(arg0_3._host, var2_3, var3_3)

	pg.NodeMgr.GetInstance():GenNode(var4_3, pg.BattleNodesCfg[arg0_3._tmpData.barrage_ID[1]], var3_3)
	arg0_3._host:SetCurNodeList(var4_3:GetAllSeq())

	arg0_3._currentState = arg0_3.STATE_ATTACK
	arg0_3._castInfo = nil

	arg0_3:CheckAndShake()
	var3_3:Add(var0_0.Battle.CallbackNode.New(function()
		arg0_3:EnterCoolDown()
	end))

	return true
end
