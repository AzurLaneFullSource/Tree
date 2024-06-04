ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffHP", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffHP = var1
var1.__name = "BattleBuffHP"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._number = arg0._tempData.arg_list.number or 0
	arg0._numberBase = arg0._number
	arg0._currentHPRatio = 0

	if arg0._tempData.arg_list.currentHPRatio then
		arg0._currentHPRatio = arg0._tempData.arg_list.currentHPRatio * 0.0001
	end

	local var0, var1 = arg1:GetHP()
	local var2, var3 = arg0._caster:GetHP()

	arg0._maxHPRatio = arg0._tempData.arg_list.maxHPRatio or 0
	arg0._maxHPNumber = var1 * arg0._maxHPRatio
	arg0._castMaxHPRatio = arg0._tempData.arg_list.casterMaxHPRatio or 0
	arg0._castMaxHPNumber = arg0._castMaxHPRatio * var3
	arg0._weaponType = arg0._tempData.arg_list.weaponType
	arg0._damageConvert = 0

	if arg0._tempData.arg_list.damageConvertRatio then
		arg0._damageConvert = arg0._tempData.arg_list.damageConvertRatio * 0.0001
	end

	arg0._incorruptible = arg0._tempData.arg_list.incorrupt
end

function var1.onBulletHit(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	if not arg0:bulletTagRequire(arg3.bulletTag) then
		return
	end

	if not arg0:victimRequire(arg3.target, arg1) then
		return
	end

	local var0 = arg1:GetAttrByName("healingRate")
	local var1 = arg3.target

	if not arg0._weaponType then
		local var2 = arg0._number
		local var3 = var2 > 0

		if var3 then
			var2 = math.floor(var2 * var0)
		end

		local var4 = {
			isMiss = false,
			isCri = false,
			isHeal = var3
		}

		var1:UpdateHP(var2, var4)
	elseif arg3.weaponType == arg0._weaponType then
		local var5 = math.floor(arg3.damage * arg0._damageConvert * var0)
		local var6 = {
			isMiss = false,
			isCri = false,
			isHeal = true,
			incorrupt = arg0._incorruptible
		}

		arg1:UpdateHP(var5, var6)
	end
end

function var1.onAttach(arg0, arg1, arg2)
	onDelayTick(function()
		var1.super.onAttach(arg0, arg1, arg2)
	end, 0.03)
end

function var1.onTrigger(arg0, arg1, arg2)
	local var0 = arg0:CalcNumber(arg1)
	local var1 = var0 > 0

	if var1 then
		local var2 = arg1:GetAttrByName("healingRate")

		var0 = math.floor(var0 * var2)
	end

	local var3 = {
		isMiss = false,
		isCri = false,
		isHeal = var1,
		incorrupt = arg0._incorruptible
	}

	arg1:UpdateHP(var0, var3)
end

function var1.CalcNumber(arg0, arg1)
	local var0 = arg1:GetHP()
	local var1 = arg0._caster:GetAttrByName("healingEnhancement") + 1

	return math.floor((var0 * arg0._currentHPRatio + arg0._maxHPNumber + arg0._number + arg0._castMaxHPNumber) * var1)
end
