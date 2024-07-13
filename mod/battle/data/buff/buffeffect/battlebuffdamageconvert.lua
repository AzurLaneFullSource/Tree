ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleAttr
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = class("BattleBuffDamageConvert", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffDamageConvert = var4_0
var4_0.__name = "BattleBuffDamageConvert"
var4_0.ATTR_PRE = {
	[var3_0.WeaponDamageAttr.CANNON] = "injureRatioByCannon",
	[var3_0.WeaponDamageAttr.TORPEDO] = "injureRatioByBulletTorpedo",
	[var3_0.WeaponDamageAttr.AIR] = "injureRatioByAir"
}

function var4_0.Ctor(arg0_1, arg1_1)
	var4_0.super.Ctor(arg0_1, arg1_1)
end

function var4_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._convert = var0_2.convert_rate
	arg0_2._duration = var0_2.duration
	arg0_2._buffSkinID = var0_2.buff_skin_id
	arg0_2._attrTable = {}
end

function var4_0.onTakeDamage(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg3_3.damageAttr

	if var0_3 then
		local var1_3 = (arg0_3._attrTable[var0_3] or 0) + arg3_3.damage

		arg0_3._attrTable[var0_3] = var1_3
	end
end

function var4_0.onRemove(arg0_4, arg1_4, arg2_4)
	local var0_4 = 0
	local var1_4

	for iter0_4, iter1_4 in pairs(arg0_4._attrTable) do
		if var0_4 <= iter1_4 then
			var0_4 = iter1_4
			var1_4 = iter0_4
		end
	end

	if not var1_4 then
		return
	end

	local var2_4 = var4_0.ATTR_PRE[var1_4]
	local var3_4 = var4_0.generateBuff(arg0_4._buffSkinID, arg0_4._duration, var2_4, var0_4 * arg0_4._convert)
	local var4_4 = var0_0.Battle.BattleBuffSelfModifyUnit.New(var3_4.id, 1, arg1_4, var3_4)

	arg1_4:AddBuff(var4_4)
end

function var4_0.generateBuff(arg0_5, arg1_5, arg2_5, arg3_5)
	return {
		id = arg0_5,
		icon = arg0_5,
		time = arg1_5,
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
					attr = arg2_5,
					number = arg3_5,
					group = arg0_5
				}
			}
		},
		{
			time = arg1_5
		},
		name = "代码生成buff",
		init_effect = "jinengchufablue",
		stack = 1,
		picture = "",
		last_effect = "",
		desc = "代码生成buff-指定属性减伤"
	}
end
