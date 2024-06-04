ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleTorpedoBullet
local var2 = var0.Battle.BattleResourceManager

var0.Battle.BattleTorpedoBullet = class("BattleTorpedoBullet", var0.Battle.BattleBullet)
var0.Battle.BattleTorpedoBullet.__name = "BattleTorpedoBullet"

local var3 = var0.Battle.BattleTorpedoBullet

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.Dispose(arg0)
	if arg0._alert then
		arg0._alert:Dispose()
	end

	var3.super.Dispose(arg0)
end

function var3.Advance(arg0)
	arg0._speed = arg0._speed * 2
end

function var3.GetZExtraOffset(arg0)
	return 0
end

function var3.MakeAlert(arg0, arg1)
	arg0._alert = var0.Battle.TorAlert.New(arg1)

	arg0._alert:SetPosition(arg0._bulletData:GetPosition(), arg0._bulletData:GetYAngle())
end

function var3.Neutrailze(arg0)
	SetActive(arg0._go, false)
end
