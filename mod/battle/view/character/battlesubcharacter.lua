ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = class("BattleSubCharacter", var0_0.Battle.BattlePlayerCharacter)

var0_0.Battle.BattleSubCharacter = var4_0
var4_0.__name = "BattleSubCharacter"

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)
end

function var4_0.AddArrowBar(arg0_2, arg1_2)
	var4_0.super.AddArrowBar(arg0_2, arg1_2)

	arg0_2._vectorOxygenSlider = arg0_2._arrowBarTf:Find("submarine/oxygenBar/oxygen"):GetComponent(typeof(Slider))
	arg0_2._vectorOxygenSlider.value = 1
	arg0_2._vectorAmmoCount = arg0_2._arrowBarTf:Find("submarine/Count/CountText"):GetComponent(typeof(Text))

	local var0_2 = #arg0_2._unitData:GetTorpedoList()

	arg0_2._vectorAmmoCount.text = var0_2 .. "/" .. var0_2
end

function var4_0.Update(arg0_3)
	var4_0.super.Update(arg0_3)

	if not arg0_3._inViewArea then
		arg0_3:updateOxygenVector()
	end
end

function var4_0.updateOxygenVector(arg0_4)
	arg0_4._vectorOxygenSlider.value = arg0_4._unitData:GetOxygenProgress()
end

function var4_0.onTorpedoWeaponFire(arg0_5, arg1_5)
	var4_0.super.onTorpedoWeaponFire(arg0_5, arg1_5)

	local var0_5 = 0

	for iter0_5, iter1_5 in ipairs(arg0_5._unitData:GetTorpedoList()) do
		if iter1_5:GetCurrentState() == iter1_5.STATE_READY then
			var0_5 = var0_5 + 1
		end
	end

	arg0_5._vectorAmmoCount.text = var0_5 .. "/" .. #arg0_5._unitData:GetTorpedoList()
end
