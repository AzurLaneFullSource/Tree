ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffDamageWall = class("BattleBuffDamageWall", var0_0.Battle.BattleBuffShieldWall)
var0_0.Battle.BattleBuffDamageWall.__name = "BattleBuffDamageWall"

local var1_0 = var0_0.Battle.BattleBuffDamageWall

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._cldList = {}
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	var1_0.super.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._wall:SetCldObjType(var0_0.Battle.BattleWallData.CLD_OBJ_TYPE_SHIP)

	arg0_2._attr = setmetatable({}, {
		__index = arg1_2._attr
	})
	arg0_2._atkAttrType = arg0_2._tempData.arg_list.attack_attribute
	arg0_2._damage = arg0_2._tempData.arg_list.damage
	arg0_2._forgeTmp = {
		random_damage_rate = 0,
		antisub_enhancement = 0,
		ammo_type = 1,
		damage_type = {
			1,
			1,
			1
		},
		DMG_font = {
			{
				2,
				1.2
			},
			{
				2,
				1.2
			},
			{
				2,
				1.2
			}
		},
		hit_type = {}
	}
	arg0_2._forgeWeapon = {
		GetConvertedAtkAttr = function()
			return 0.01
		end,
		GetFixAmmo = function()
			return nil
		end
	}
	arg0_2._forgeWeaponTmp = {
		attack_attribute = arg0_2._atkAttrType
	}
	arg0_2._atkAttr = var0_0.Battle.BattleAttr.GetAtkAttrByType(arg0_2._attr, arg0_2._atkAttrType)
end

function var1_0.onWallCld(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg1_5) do
		if not table.contains(arg0_5._cldList, iter1_5) then
			arg0_5._dataProxy:HandleWallDamage(arg0_5, iter1_5)
			table.insert(arg0_5._cldList, iter1_5)

			arg0_5._count = arg0_5._count - 1

			if arg0_5._count <= 0 then
				break
			end
		end
	end

	local var0_5 = #arg0_5._cldList

	while var0_5 > 0 do
		local var1_5 = arg0_5._cldList[var0_5]

		if not table.contains(arg1_5, var1_5) then
			table.remove(arg0_5._cldList, var0_5)
		end

		var0_5 = var0_5 - 1
	end

	if arg0_5._count <= 0 then
		arg0_5:Deactive()
	end
end

function var1_0.GetDamageEnhance(arg0_6)
	return 1
end

function var1_0.GetHost(arg0_7)
	return arg0_7._unit
end

function var1_0.GetWeaponHostAttr(arg0_8)
	return var0_0.Battle.BattleAttr.GetAttr(arg0_8)
end

function var1_0.GetWeapon(arg0_9)
	return arg0_9._forgeWeapon
end

function var1_0.GetWeaponTempData(arg0_10)
	return arg0_10._forgeWeaponTmp
end

function var1_0.GetWeaponAtkAttr(arg0_11)
	return arg0_11._atkAttr
end

function var1_0.GetCorrectedDMG(arg0_12)
	return arg0_12._damage
end

function var1_0.GetTemplate(arg0_13)
	return arg0_13._forgeTmp
end

function var1_0.Clear(arg0_14)
	arg0_14._cldList = nil

	var1_0.super.Clear(arg0_14)
end
