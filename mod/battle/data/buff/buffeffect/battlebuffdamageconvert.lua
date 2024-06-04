ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleAttr
local var3 = var0.Battle.BattleConst
local var4 = class("BattleBuffDamageConvert", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffDamageConvert = var4
var4.__name = "BattleBuffDamageConvert"
var4.ATTR_PRE = {
	[var3.WeaponDamageAttr.CANNON] = "injureRatioByCannon",
	[var3.WeaponDamageAttr.TORPEDO] = "injureRatioByBulletTorpedo",
	[var3.WeaponDamageAttr.AIR] = "injureRatioByAir"
}

function var4.Ctor(arg0, arg1)
	var4.super.Ctor(arg0, arg1)
end

function var4.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._convert = var0.convert_rate
	arg0._duration = var0.duration
	arg0._buffSkinID = var0.buff_skin_id
	arg0._attrTable = {}
end

function var4.onTakeDamage(arg0, arg1, arg2, arg3)
	local var0 = arg3.damageAttr

	if var0 then
		local var1 = (arg0._attrTable[var0] or 0) + arg3.damage

		arg0._attrTable[var0] = var1
	end
end

function var4.onRemove(arg0, arg1, arg2)
	local var0 = 0
	local var1

	for iter0, iter1 in pairs(arg0._attrTable) do
		if var0 <= iter1 then
			var0 = iter1
			var1 = iter0
		end
	end

	if not var1 then
		return
	end

	local var2 = var4.ATTR_PRE[var1]
	local var3 = var4.generateBuff(arg0._buffSkinID, arg0._duration, var2, var0 * arg0._convert)
	local var4 = var0.Battle.BattleBuffSelfModifyUnit.New(var3.id, 1, arg1, var3)

	arg1:AddBuff(var4)
end

function var4.generateBuff(arg0, arg1, arg2, arg3)
	return {
		id = arg0,
		icon = arg0,
		time = arg1,
		blink = {
			0,
			0.7,
			1,
			0.3,
			0.3
		},
		effect_list = {
			{
				type = "BattleBuffAddAttr",
				trigger = {
					"onAttach",
					"onRemove"
				},
				arg_list = {
					attr = arg2,
					number = arg3,
					group = arg0
				}
			}
		},
		{
			time = arg1
		},
		name = "代码生成buff",
		init_effect = "jinengchufablue",
		stack = 1,
		picture = "",
		last_effect = "",
		desc = "代码生成buff-指定属性减伤"
	}
end
