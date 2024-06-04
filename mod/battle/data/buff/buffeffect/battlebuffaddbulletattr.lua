ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffAddBulletAttr = class("BattleBuffAddBulletAttr", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffAddBulletAttr.__name = "BattleBuffAddBulletAttr"

local var1 = var0.Battle.BattleBuffAddBulletAttr

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._attr = arg0._tempData.arg_list.attr
	arg0._number = arg0._tempData.arg_list.number
	arg0._rate = arg0._tempData.arg_list.rate or 10000
	arg0._bulletID = arg0._tempData.arg_list.bulletID
	arg0._weaponIndexList = arg0._tempData.arg_list.index
	arg0._numberBase = arg0._number
	arg0._displacementConvert = arg0._tempData.arg_list.displacement_convert
end

function var1.onStack(arg0, arg1, arg2)
	arg0._number = arg0._numberBase * arg2._stack
end

function var1.onBulletCreate(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:calcBulletAttr(arg3)
end

function var1.onInternalBulletCreate(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:calcBulletAttr(arg3)
end

function var1.onManualBulletCreate(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:calcBulletAttr(arg3)
end

function var1.onBulletCollide(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:displacementConvert(arg3)
	arg0:calcBulletAttr(arg3)
end

function var1.onBombBulletBang(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:displacementConvert(arg3)
	arg0:calcBulletAttr(arg3)
end

function var1.onTorpedoBulletBang(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:displacementConvert(arg3)
	arg0:calcBulletAttr(arg3)
end

function var1.displacementConvert(arg0, arg1)
	local var0 = arg1._bullet:GetCurrentDistance()
	local var1 = arg0._displacementConvert.base
	local var2 = arg0._displacementConvert.rate
	local var3 = arg0._displacementConvert.max

	if var2 > 0 then
		arg0._number = math.min(math.max(var0 - var1, 0) * var2, var3)
	elseif var2 < 0 then
		arg0._number = math.min(math.max(0, var3 + (var0 - var1) * var2), var3)
	elseif var2 == 0 then
		arg0._number = 0
	end
end

function var1.calcBulletAttr(arg0, arg1)
	if var0.Battle.BattleFormulas.IsHappen(arg0._rate) then
		local var0 = arg1._bullet
		local var1 = var0:GetWeapon():GetEquipmentIndex()
		local var2 = false

		if not arg0._weaponIndexList then
			var2 = true
		elseif #arg0._weaponIndexList == 0 and var1 == nil then
			var2 = true
		elseif table.contains(arg0._weaponIndexList, var1) then
			var2 = true
		end

		if var2 then
			if arg0._bulletID then
				if var0:GetTemplate().id == arg0._bulletID then
					var0.Battle.BattleAttr.Increase(var0, arg0._attr, arg0._number)
				end
			else
				var0.Battle.BattleAttr.Increase(var0, arg0._attr, arg0._number)
			end
		end
	end
end
