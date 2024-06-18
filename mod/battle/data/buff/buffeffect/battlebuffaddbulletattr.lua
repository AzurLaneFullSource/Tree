ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffAddBulletAttr = class("BattleBuffAddBulletAttr", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffAddBulletAttr.__name = "BattleBuffAddBulletAttr"

local var1_0 = var0_0.Battle.BattleBuffAddBulletAttr

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._attr = arg0_2._tempData.arg_list.attr
	arg0_2._number = arg0_2._tempData.arg_list.number
	arg0_2._rate = arg0_2._tempData.arg_list.rate or 10000
	arg0_2._bulletID = arg0_2._tempData.arg_list.bulletID
	arg0_2._weaponIndexList = arg0_2._tempData.arg_list.index
	arg0_2._numberBase = arg0_2._number
	arg0_2._displacementConvert = arg0_2._tempData.arg_list.displacement_convert
end

function var1_0.onStack(arg0_3, arg1_3, arg2_3)
	arg0_3._number = arg0_3._numberBase * arg2_3._stack
end

function var1_0.onBulletCreate(arg0_4, arg1_4, arg2_4, arg3_4)
	if not arg0_4:equipIndexRequire(arg3_4.equipIndex) then
		return
	end

	arg0_4:calcBulletAttr(arg3_4)
end

function var1_0.onInternalBulletCreate(arg0_5, arg1_5, arg2_5, arg3_5)
	if not arg0_5:equipIndexRequire(arg3_5.equipIndex) then
		return
	end

	arg0_5:calcBulletAttr(arg3_5)
end

function var1_0.onManualBulletCreate(arg0_6, arg1_6, arg2_6, arg3_6)
	if not arg0_6:equipIndexRequire(arg3_6.equipIndex) then
		return
	end

	arg0_6:calcBulletAttr(arg3_6)
end

function var1_0.onBulletCollide(arg0_7, arg1_7, arg2_7, arg3_7)
	if not arg0_7:equipIndexRequire(arg3_7.equipIndex) then
		return
	end

	arg0_7:displacementConvert(arg3_7)
	arg0_7:calcBulletAttr(arg3_7)
end

function var1_0.onBombBulletBang(arg0_8, arg1_8, arg2_8, arg3_8)
	if not arg0_8:equipIndexRequire(arg3_8.equipIndex) then
		return
	end

	arg0_8:displacementConvert(arg3_8)
	arg0_8:calcBulletAttr(arg3_8)
end

function var1_0.onTorpedoBulletBang(arg0_9, arg1_9, arg2_9, arg3_9)
	if not arg0_9:equipIndexRequire(arg3_9.equipIndex) then
		return
	end

	arg0_9:displacementConvert(arg3_9)
	arg0_9:calcBulletAttr(arg3_9)
end

function var1_0.displacementConvert(arg0_10, arg1_10)
	local var0_10 = arg1_10._bullet:GetCurrentDistance()
	local var1_10 = arg0_10._displacementConvert.base
	local var2_10 = arg0_10._displacementConvert.rate
	local var3_10 = arg0_10._displacementConvert.max

	if var2_10 > 0 then
		arg0_10._number = math.min(math.max(var0_10 - var1_10, 0) * var2_10, var3_10)
	elseif var2_10 < 0 then
		arg0_10._number = math.min(math.max(0, var3_10 + (var0_10 - var1_10) * var2_10), var3_10)
	elseif var2_10 == 0 then
		arg0_10._number = 0
	end
end

function var1_0.calcBulletAttr(arg0_11, arg1_11)
	if var0_0.Battle.BattleFormulas.IsHappen(arg0_11._rate) then
		local var0_11 = arg1_11._bullet
		local var1_11 = var0_11:GetWeapon():GetEquipmentIndex()
		local var2_11 = false

		if not arg0_11._weaponIndexList then
			var2_11 = true
		elseif #arg0_11._weaponIndexList == 0 and var1_11 == nil then
			var2_11 = true
		elseif table.contains(arg0_11._weaponIndexList, var1_11) then
			var2_11 = true
		end

		if var2_11 then
			if arg0_11._bulletID then
				if var0_11:GetTemplate().id == arg0_11._bulletID then
					var0_0.Battle.BattleAttr.Increase(var0_11, arg0_11._attr, arg0_11._number)
				end
			else
				var0_0.Battle.BattleAttr.Increase(var0_11, arg0_11._attr, arg0_11._number)
			end
		end
	end
end
