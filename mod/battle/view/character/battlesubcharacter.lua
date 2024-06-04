ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleConfig
local var3 = var0.Battle.BattleConst
local var4 = class("BattleSubCharacter", var0.Battle.BattlePlayerCharacter)

var0.Battle.BattleSubCharacter = var4
var4.__name = "BattleSubCharacter"

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)
end

function var4.AddArrowBar(arg0, arg1)
	var4.super.AddArrowBar(arg0, arg1)

	arg0._vectorOxygenSlider = arg0._arrowBarTf:Find("submarine/oxygenBar/oxygen"):GetComponent(typeof(Slider))
	arg0._vectorOxygenSlider.value = 1
	arg0._vectorAmmoCount = arg0._arrowBarTf:Find("submarine/Count/CountText"):GetComponent(typeof(Text))

	local var0 = #arg0._unitData:GetTorpedoList()

	arg0._vectorAmmoCount.text = var0 .. "/" .. var0
end

function var4.Update(arg0)
	var4.super.Update(arg0)

	if not arg0._inViewArea then
		arg0:updateOxygenVector()
	end
end

function var4.updateOxygenVector(arg0)
	arg0._vectorOxygenSlider.value = arg0._unitData:GetOxygenProgress()
end

function var4.onTorpedoWeaponFire(arg0, arg1)
	var4.super.onTorpedoWeaponFire(arg0, arg1)

	local var0 = 0

	for iter0, iter1 in ipairs(arg0._unitData:GetTorpedoList()) do
		if iter1:GetCurrentState() == iter1.STATE_READY then
			var0 = var0 + 1
		end
	end

	arg0._vectorAmmoCount.text = var0 .. "/" .. #arg0._unitData:GetTorpedoList()
end
