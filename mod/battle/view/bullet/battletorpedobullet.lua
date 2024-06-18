ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleTorpedoBullet
local var2_0 = var0_0.Battle.BattleResourceManager

var0_0.Battle.BattleTorpedoBullet = class("BattleTorpedoBullet", var0_0.Battle.BattleBullet)
var0_0.Battle.BattleTorpedoBullet.__name = "BattleTorpedoBullet"

local var3_0 = var0_0.Battle.BattleTorpedoBullet

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.Dispose(arg0_2)
	if arg0_2._alert then
		arg0_2._alert:Dispose()
	end

	var3_0.super.Dispose(arg0_2)
end

function var3_0.Advance(arg0_3)
	arg0_3._speed = arg0_3._speed * 2
end

function var3_0.GetZExtraOffset(arg0_4)
	return 0
end

function var3_0.MakeAlert(arg0_5, arg1_5)
	arg0_5._alert = var0_0.Battle.TorAlert.New(arg1_5)

	arg0_5._alert:SetPosition(arg0_5._bulletData:GetPosition(), arg0_5._bulletData:GetYAngle())
end

function var3_0.Neutrailze(arg0_6)
	SetActive(arg0_6._go, false)
end
