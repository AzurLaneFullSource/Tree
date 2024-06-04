ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffDamageWall = class("BattleBuffDamageWall", var0.Battle.BattleBuffShieldWall)
var0.Battle.BattleBuffDamageWall.__name = "BattleBuffDamageWall"

local var1 = var0.Battle.BattleBuffDamageWall

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)

	arg0._cldList = {}
end

function var1.SetArgs(arg0, arg1, arg2)
	var1.super.SetArgs(arg0, arg1, arg2)
	arg0._wall:SetCldObjType(var0.Battle.BattleWallData.CLD_OBJ_TYPE_SHIP)

	arg0._attr = setmetatable({}, {
		__index = arg1._attr
	})
	arg0._atkAttrType = arg0._tempData.arg_list.attack_attribute
	arg0._damage = arg0._tempData.arg_list.damage
	arg0._forgeTmp = {
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
	arg0._forgeWeapon = {
		GetConvertedAtkAttr = function()
			return 0.01
		end,
		GetFixAmmo = function()
			return nil
		end
	}
	arg0._forgeWeaponTmp = {
		attack_attribute = arg0._atkAttrType
	}
	arg0._atkAttr = var0.Battle.BattleAttr.GetAtkAttrByType(arg0._attr, arg0._atkAttrType)
end

function var1.onWallCld(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		if not table.contains(arg0._cldList, iter1) then
			arg0._dataProxy:HandleWallDamage(arg0, iter1)
			table.insert(arg0._cldList, iter1)

			arg0._count = arg0._count - 1

			if arg0._count <= 0 then
				break
			end
		end
	end

	local var0 = #arg0._cldList

	while var0 > 0 do
		local var1 = arg0._cldList[var0]

		if not table.contains(arg1, var1) then
			table.remove(arg0._cldList, var0)
		end

		var0 = var0 - 1
	end

	if arg0._count <= 0 then
		arg0:Deactive()
	end
end

function var1.GetDamageEnhance(arg0)
	return 1
end

function var1.GetHost(arg0)
	return arg0._unit
end

function var1.GetWeaponHostAttr(arg0)
	return var0.Battle.BattleAttr.GetAttr(arg0)
end

function var1.GetWeapon(arg0)
	return arg0._forgeWeapon
end

function var1.GetWeaponTempData(arg0)
	return arg0._forgeWeaponTmp
end

function var1.GetWeaponAtkAttr(arg0)
	return arg0._atkAttr
end

function var1.GetCorrectedDMG(arg0)
	return arg0._damage
end

function var1.GetTemplate(arg0)
	return arg0._forgeTmp
end

function var1.Clear(arg0)
	arg0._cldList = nil

	var1.super.Clear(arg0)
end
