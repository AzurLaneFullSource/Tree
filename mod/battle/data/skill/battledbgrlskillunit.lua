ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleVariable

var0_0.Battle.BattleSkillUnit = class("BattleSkillUnit")
var0_0.Battle.BattleSkillUnit.__name = "BattleSkillUnit"

local var3_0 = var0_0.Battle.BattleSkillUnit

function var3_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._id = arg1_1
	arg0_1._level = arg2_1
	arg0_1._tempData = var0_0.Battle.BattleDataFunction.GetSkillTemplate(arg1_1, arg2_1)
	arg0_1._cd = arg0_1._tempData.cd
	arg0_1._effectList = {}
	arg0_1._lastEffectTarget = {}

	for iter0_1, iter1_1 in ipairs(arg0_1._tempData.effect_list) do
		local var0_1 = iter1_1.type

		arg0_1._effectList[iter0_1] = var0_0.Battle[var0_1].New(iter1_1, arg2_1)
	end

	arg0_1._dataProxy = var0_0.Battle.BattleDataProxy.GetInstance()
end

function var3_0.GenerateSpell(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = var0_0.Battle.BattleSkillUnit.New(arg0_2, arg1_2)

	var0_2._attachData = arg3_2

	return var0_2
end

function var3_0.GetSkillEffectList(arg0_3)
	return arg0_3._effectList
end

function var3_0.Cast(arg0_4, arg1_4, arg2_4)
	local var0_4 = var0_0.Battle.BattleState.GetInstance():GetUIMediator()

	if arg0_4._tempData.focus_duration then
		var0_4:ShowSkillPainting(arg1_4, arg0_4._tempData)
	end

	if arg0_4._tempData.painting == 1 then
		if arg2_4 then
			arg1_4:DispatchSkillFloat(arg2_4:getSkills()[1]:getConfig("name"), arg2_4:getPainting())
		else
			arg1_4:DispatchSkillFloat(arg0_4._tempData.name)
		end
	elseif type(arg0_4._tempData.painting) == "string" then
		arg1_4:DispatchSkillFloat(arg0_4._tempData.name, nil, arg0_4._tempData.painting)
	end

	local var1_4 = type(arg0_4._tempData.castCV)

	if var1_4 == "string" then
		arg1_4:DispatchVoice(arg0_4._tempData.castCV)
	elseif var1_4 == "table" then
		local var2_4, var3_4, var4_4 = ShipWordHelper.GetWordAndCV(arg0_4._tempData.castCV.skinID, arg0_4._tempData.castCV.key)

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3_4)
	end

	local var5_4 = arg0_4._attachData

	for iter0_4, iter1_4 in ipairs(arg0_4._effectList) do
		local var6_4 = iter1_4:GetTarget(arg1_4, arg0_4)

		arg0_4._lastEffectTarget = var6_4

		iter1_4:SetCommander(arg2_4)
		iter1_4:Effect(arg1_4, var6_4, var5_4)
	end

	local var7_4 = arg0_4._tempData.aniEffect

	if var7_4 and var7_4 ~= "" then
		local var8_4 = {
			effect = var7_4.effect,
			time = var7_4.time,
			offset = var7_4.offset,
			posFun = var7_4.posFun
		}

		arg1_4:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.ADD_EFFECT, var8_4))
	end
end

function var3_0.SetTarget(arg0_5, arg1_5)
	arg0_5._lastEffectTarget = arg1_5
end

function var3_0.Interrupt(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6._effectList) do
		iter1_6:Interrupt()
	end
end

function var3_0.Clear(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7._effectList) do
		iter1_7:Clear()
	end
end

function var3_0.GetDamageSum(arg0_8)
	local var0_8 = 0

	for iter0_8, iter1_8 in ipairs(arg0_8._effectList) do
		var0_8 = iter1_8:GetDamageSum() + var0_8
	end

	return var0_8
end

function var3_0.IsFireSkill(arg0_9, arg1_9)
	local var0_9 = false
	local var1_9 = var0_0.Battle.BattleDataFunction.GetSkillTemplate(arg0_9, arg1_9)

	for iter0_9, iter1_9 in ipairs(var1_9.effect_list) do
		if iter1_9.type == var0_0.Battle.BattleSkillFire.__name or iter1_9.type == var0_0.Battle.BattleSkillFireSupport.__name then
			var0_9 = true

			break
		end
	end

	return var0_9
end
