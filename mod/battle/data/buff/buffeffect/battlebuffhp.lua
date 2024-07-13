ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffHP", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffHP = var1_0
var1_0.__name = "BattleBuffHP"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._number = arg0_2._tempData.arg_list.number or 0
	arg0_2._numberBase = arg0_2._number
	arg0_2._currentHPRatio = 0

	if arg0_2._tempData.arg_list.currentHPRatio then
		arg0_2._currentHPRatio = arg0_2._tempData.arg_list.currentHPRatio * 0.0001
	end

	local var0_2, var1_2 = arg1_2:GetHP()
	local var2_2, var3_2 = arg0_2._caster:GetHP()

	arg0_2._maxHPRatio = arg0_2._tempData.arg_list.maxHPRatio or 0
	arg0_2._maxHPNumber = var1_2 * arg0_2._maxHPRatio
	arg0_2._castMaxHPRatio = arg0_2._tempData.arg_list.casterMaxHPRatio or 0
	arg0_2._castMaxHPNumber = arg0_2._castMaxHPRatio * var3_2
	arg0_2._weaponType = arg0_2._tempData.arg_list.weaponType
	arg0_2._damageConvert = 0

	if arg0_2._tempData.arg_list.damageConvertRatio then
		arg0_2._damageConvert = arg0_2._tempData.arg_list.damageConvertRatio * 0.0001
	end

	arg0_2._incorruptible = arg0_2._tempData.arg_list.incorrupt
end

function var1_0.onBulletHit(arg0_3, arg1_3, arg2_3, arg3_3)
	if not arg0_3:equipIndexRequire(arg3_3.equipIndex) then
		return
	end

	if not arg0_3:bulletTagRequire(arg3_3.bulletTag) then
		return
	end

	if not arg0_3:victimRequire(arg3_3.target, arg1_3) then
		return
	end

	local var0_3 = arg1_3:GetAttrByName("healingRate")
	local var1_3 = arg3_3.target

	if not arg0_3._weaponType then
		local var2_3 = arg0_3._number
		local var3_3 = var2_3 > 0

		if var3_3 then
			var2_3 = math.floor(var2_3 * var0_3)
		end

		local var4_3 = {
			isMiss = false,
			isCri = false,
			isHeal = var3_3
		}

		var1_3:UpdateHP(var2_3, var4_3)
	elseif arg3_3.weaponType == arg0_3._weaponType then
		local var5_3 = math.floor(arg3_3.damage * arg0_3._damageConvert * var0_3)
		local var6_3 = {
			isMiss = false,
			isCri = false,
			isHeal = true,
			incorrupt = arg0_3._incorruptible
		}

		arg1_3:UpdateHP(var5_3, var6_3)
	end
end

function var1_0.onAttach(arg0_4, arg1_4, arg2_4)
	onDelayTick(function()
		var1_0.super.onAttach(arg0_4, arg1_4, arg2_4)
	end, 0.03)
end

function var1_0.onTrigger(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6:CalcNumber(arg1_6)
	local var1_6 = var0_6 > 0

	if var1_6 then
		local var2_6 = arg1_6:GetAttrByName("healingRate")

		var0_6 = math.floor(var0_6 * var2_6)
	end

	local var3_6 = {
		isMiss = false,
		isCri = false,
		isHeal = var1_6,
		incorrupt = arg0_6._incorruptible
	}

	arg1_6:UpdateHP(var0_6, var3_6)
end

function var1_0.CalcNumber(arg0_7, arg1_7)
	local var0_7 = arg1_7:GetHP()
	local var1_7 = arg0_7._caster:GetAttrByName("healingEnhancement") + 1

	return math.floor((var0_7 * arg0_7._currentHPRatio + arg0_7._maxHPNumber + arg0_7._number + arg0_7._castMaxHPNumber) * var1_7)
end
