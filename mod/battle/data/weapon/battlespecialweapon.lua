ys = ys or {}

local var0 = ys
local var1 = class("BattleSpecialWeapon", var0.Battle.BattleWeaponUnit)

var0.Battle.BattleSpecialWeapon = var1
var1.__name = "BattleSpecialWeapon"

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.CheckPreCast(arg0)
	local var0 = arg0._dataProxy:GetSeqCenter()
	local var1 = arg0._tmpData.bullet_ID[1]

	if not var1 then
		arg0._castInfo = {
			weapon = arg0
		}

		return true
	end

	local var2 = var0:NewSeq("precast")
	local var3 = var0.Battle.NodeData.New(arg0._host, {
		weapon = arg0
	}, var2)

	pg.NodeMgr.GetInstance():GenNode(var3, pg.BattleNodesCfg[var1], var2)

	local var4 = var3:GetData()

	if var4.targets[1] == nil then
		return false
	end

	arg0._castInfo = var4

	return true
end

function var1.Fire(arg0)
	assert(arg0._castInfo ~= nil, "需要指定施法信息，有特殊需求可默认指定为{ weapon = self }")

	local var0 = arg0._dataProxy:GetSeqCenter()
	local var1 = arg0._tmpData.bullet_ID[1]
	local var2 = arg0._castInfo
	local var3 = var0:NewSeq("cast")
	local var4 = var0.Battle.NodeData.New(arg0._host, var2, var3)

	pg.NodeMgr.GetInstance():GenNode(var4, pg.BattleNodesCfg[arg0._tmpData.barrage_ID[1]], var3)
	arg0._host:SetCurNodeList(var4:GetAllSeq())

	arg0._currentState = arg0.STATE_ATTACK
	arg0._castInfo = nil

	arg0:CheckAndShake()
	var3:Add(var0.Battle.CallbackNode.New(function()
		arg0:EnterCoolDown()
	end))

	return true
end
