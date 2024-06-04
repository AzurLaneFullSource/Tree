ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleVariable

var0.Battle.BattleSkillUnit = class("BattleSkillUnit")
var0.Battle.BattleSkillUnit.__name = "BattleSkillUnit"

local var3 = var0.Battle.BattleSkillUnit

function var3.Ctor(arg0, arg1, arg2)
	arg0._id = arg1
	arg0._level = arg2
	arg0._tempData = var0.Battle.BattleDataFunction.GetSkillTemplate(arg1, arg2)
	arg0._cd = arg0._tempData.cd
	arg0._effectList = {}
	arg0._lastEffectTarget = {}

	for iter0, iter1 in ipairs(arg0._tempData.effect_list) do
		local var0 = iter1.type

		arg0._effectList[iter0] = var0.Battle[var0].New(iter1, arg2)
	end

	arg0._dataProxy = var0.Battle.BattleDataProxy.GetInstance()
end

function var3.GenerateSpell(arg0, arg1, arg2, arg3)
	local var0 = var0.Battle.BattleSkillUnit.New(arg0, arg1)

	var0._attachData = arg3

	return var0
end

function var3.GetSkillEffectList(arg0)
	return arg0._effectList
end

function var3.Cast(arg0, arg1, arg2)
	local var0 = var0.Battle.BattleState.GetInstance():GetUIMediator()

	if arg0._tempData.focus_duration then
		var0:ShowSkillPainting(arg1, arg0._tempData)
	end

	if arg0._tempData.painting == 1 then
		if arg2 then
			arg1:DispatchSkillFloat(arg2:getSkills()[1]:getConfig("name"), arg2:getPainting())
		else
			arg1:DispatchSkillFloat(arg0._tempData.name)
		end
	elseif type(arg0._tempData.painting) == "string" then
		arg1:DispatchSkillFloat(arg0._tempData.name, nil, arg0._tempData.painting)
	end

	local var1 = type(arg0._tempData.castCV)

	if var1 == "string" then
		arg1:DispatchVoice(arg0._tempData.castCV)
	elseif var1 == "table" then
		local var2, var3, var4 = ShipWordHelper.GetWordAndCV(arg0._tempData.castCV.skinID, arg0._tempData.castCV.key)

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3)
	end

	local var5 = arg0._attachData

	for iter0, iter1 in ipairs(arg0._effectList) do
		local var6 = iter1:GetTarget(arg1, arg0)

		arg0._lastEffectTarget = var6

		iter1:SetCommander(arg2)
		iter1:Effect(arg1, var6, var5)
	end

	local var7 = arg0._tempData.aniEffect

	if var7 and var7 ~= "" then
		local var8 = {
			effect = var7.effect,
			time = var7.time,
			offset = var7.offset,
			posFun = var7.posFun
		}

		arg1:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.ADD_EFFECT, var8))
	end
end

function var3.SetTarget(arg0, arg1)
	arg0._lastEffectTarget = arg1
end

function var3.Interrupt(arg0)
	for iter0, iter1 in ipairs(arg0._effectList) do
		iter1:Interrupt()
	end
end

function var3.Clear(arg0)
	for iter0, iter1 in ipairs(arg0._effectList) do
		iter1:Clear()
	end
end

function var3.GetDamageSum(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0._effectList) do
		var0 = iter1:GetDamageSum() + var0
	end

	return var0
end

function var3.IsFireSkill(arg0, arg1)
	local var0 = false
	local var1 = var0.Battle.BattleDataFunction.GetSkillTemplate(arg0, arg1)

	for iter0, iter1 in ipairs(var1.effect_list) do
		if iter1.type == var0.Battle.BattleSkillFire.__name or iter1.type == var0.Battle.BattleSkillFireSupport.__name then
			var0 = true

			break
		end
	end

	return var0
end
