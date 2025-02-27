ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBuffEvent
local var2_0 = var0_0.Battle.BattleUnitEvent
local var3_0 = var0_0.Battle.BattleResourceManager
local var4_0 = var0_0.Battle.BattleDataFunction

var0_0.Battle.BattleEffectComponent = class("BattleEffectComponent")

local var5_0 = var0_0.Battle.BattleEffectComponent

var5_0.__name = "BattleEffectComponent"

function var5_0.Ctor(arg0_1, arg1_1)
	var0_0.EventListener.AttachEventListener(arg0_1)

	arg0_1._owner = arg1_1
	arg0_1._blinkIDList = {}
	arg0_1._buffLastEffects = {}
	arg0_1._currentLastFXID = nil
	arg0_1._effectIndex = 0
	arg0_1._effectList = {}
end

function var5_0.SwitchOwner(arg0_2, arg1_2, arg2_2)
	arg0_2._owner = arg1_2

	for iter0_2, iter1_2 in pairs(arg0_2._blinkIDList) do
		if arg2_2[iter1_2] then
			arg0_2._blinkIDList[iter0_2] = arg2_2[iter1_2]
		end
	end
end

function var5_0.ClearEffect(arg0_3)
	for iter0_3, iter1_3 in pairs(arg0_3._blinkIDList) do
		arg0_3._owner:RemoveBlink(iter1_3)
	end

	arg0_3._blinkIDList = {}
end

function var5_0.Dispose(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4._blinkIDList) do
		arg0_4._owner:RemoveBlink(iter1_4)
	end

	arg0_4._effectList = nil
	arg0_4._buffLastEffects = nil

	var0_0.EventListener.DetachEventListener(arg0_4)
end

function var5_0.GetFXPool(arg0_5)
	return var0_0.Battle.BattleFXPool.GetInstance()
end

function var5_0.SetUnitDataEvent(arg0_6, arg1_6)
	arg1_6:RegisterEventListener(arg0_6, var1_0.BUFF_CAST, arg0_6.onBuffCast)
	arg1_6:RegisterEventListener(arg0_6, var1_0.BUFF_ATTACH, arg0_6.onBuffAdd)
	arg1_6:RegisterEventListener(arg0_6, var1_0.BUFF_STACK, arg0_6.onBuffStack)
	arg1_6:RegisterEventListener(arg0_6, var1_0.BUFF_REMOVE, arg0_6.onBuffRemove)
	arg1_6:RegisterEventListener(arg0_6, var2_0.ADD_EFFECT, arg0_6.onAddEffect)
	arg1_6:RegisterEventListener(arg0_6, var2_0.CANCEL_EFFECT, arg0_6.onCancelEffect)
	arg1_6:RegisterEventListener(arg0_6, var2_0.DEACTIVE_EFFECT, arg0_6.onDeactiveEffect)
end

function var5_0.RemoveUnitEvent(arg0_7, arg1_7)
	arg1_7:UnregisterEventListener(arg0_7, var1_0.BUFF_ATTACH)
	arg1_7:UnregisterEventListener(arg0_7, var1_0.BUFF_CAST)
	arg1_7:UnregisterEventListener(arg0_7, var1_0.BUFF_STACK)
	arg1_7:UnregisterEventListener(arg0_7, var1_0.BUFF_REMOVE)
	arg1_7:UnregisterEventListener(arg0_7, var2_0.ADD_EFFECT)
	arg1_7:UnregisterEventListener(arg0_7, var2_0.CANCEL_EFFECT)
	arg1_7:UnregisterEventListener(arg0_7, var2_0.DEACTIVE_EFFECT)
end

function var5_0.Update(arg0_8, arg1_8)
	arg0_8._dir = arg0_8._owner:GetUnitData():GetDirection()

	for iter0_8, iter1_8 in pairs(arg0_8._effectList) do
		iter1_8.currentTime = arg1_8 - iter1_8.startTime

		arg0_8:updateEffect(iter1_8)
	end
end

function var5_0.onAddEffect(arg0_9, arg1_9)
	local var0_9 = arg1_9.Data

	arg0_9:addEffect(var0_9)
end

function var5_0.onCancelEffect(arg0_10, arg1_10)
	local var0_10 = arg1_10.Data

	arg0_10:cancelEffect(var0_10)
end

function var5_0.onDeactiveEffect(arg0_11, arg1_11)
	local var0_11 = arg1_11.Data

	arg0_11:deactiveEffect(var0_11)
end

function var5_0.onBuffAdd(arg0_12, arg1_12)
	arg0_12:DoWhenAddBuff(arg1_12)
end

function var5_0.onBuffCast(arg0_13, arg1_13)
	local var0_13 = arg1_13.Data.buff_id

	arg0_13:addBlink(var0_13)
end

function var5_0.DoWhenAddBuff(arg0_14, arg1_14)
	local var0_14 = arg1_14.Data.buff_id
	local var1_14 = arg1_14.Data.buff_level

	arg0_14:addInitFX(var0_14)
	arg0_14:addLastFX(var0_14)
end

function var5_0.onBuffStack(arg0_15, arg1_15)
	arg0_15:DoWhenStackBuff(arg1_15)
end

function var5_0.DoWhenStackBuff(arg0_16, arg1_16)
	local var0_16 = arg1_16.Data.buff_id

	arg0_16:addInitFX(var0_16)

	local var1_16 = arg1_16.Data.stack_count
	local var2_16 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(var0_16)

	if var2_16.last_effect_stack_list and arg0_16:checkLastFXID(var0_16, var1_16) ~= arg0_16._currentLastFXID then
		arg0_16:switchLastFX(var0_16, var1_16)
	end

	if var2_16.last_effect ~= "" and var2_16.last_effect_stack then
		local var3_16 = #arg0_16._buffLastEffects[var0_16]

		if var3_16 < var1_16 then
			arg0_16:addLastFX(var0_16)
		elseif var1_16 < var3_16 then
			local var4_16 = var3_16 - var1_16

			while var4_16 > 0 do
				arg0_16:removeLastFX(var0_16)

				var4_16 = var4_16 - 1
			end
		end
	end
end

function var5_0.onBuffRemove(arg0_17, arg1_17)
	local var0_17 = arg1_17.Data.buff_id

	if arg0_17._buffLastEffects[var0_17] then
		local var1_17 = #arg0_17._buffLastEffects[var0_17]

		while var1_17 > 0 do
			arg0_17:removeLastFX(var0_17)

			var1_17 = var1_17 - 1
		end
	end

	local var2_17 = arg0_17._blinkIDList[var0_17]

	if var2_17 then
		arg0_17._owner:RemoveBlink(var2_17)

		arg0_17._blinkIDList[var0_17] = nil
	end
end

function var5_0.addInitFX(arg0_18, arg1_18)
	local var0_18 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg1_18)

	if var0_18.init_effect and var0_18.init_effect ~= "" then
		local var1_18 = var0_18.init_effect

		if var0_18.skin_adapt then
			var1_18 = var4_0.SkinAdaptFXID(var1_18, arg0_18._owner:GetUnitData():GetSkinID())
		end

		arg0_18._owner:AddFX(var1_18)
	end
end

function var5_0.removeLastFX(arg0_19, arg1_19)
	local var0_19 = arg0_19._buffLastEffects[arg1_19]

	if var0_19 ~= nil and #var0_19 > 0 then
		local var1_19 = table.remove(var0_19)

		arg0_19._owner:RemoveFX(var1_19)
	end
end

function var5_0.switchLastFX(arg0_20, arg1_20, arg2_20)
	local var0_20 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg1_20)
	local var1_20 = arg0_20:checkLastFXID(arg1_20, arg2_20)

	if arg0_20._currentLastFXID then
		arg0_20:removeLastFX(arg1_20)
	end

	if var1_20 then
		local var2_20 = arg0_20:generateLastFX(var0_20, var1_20)
		local var3_20 = arg0_20._buffLastEffects[arg1_20] or {}

		table.insert(var3_20, var2_20)

		arg0_20._buffLastEffects[arg1_20] = var3_20
	end
end

function var5_0.checkLastFXID(arg0_21, arg1_21, arg2_21)
	local var0_21 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg1_21)
	local var1_21

	for iter0_21, iter1_21 in pairs(var0_21.last_effect_stack_list) do
		if iter0_21 <= arg2_21 then
			var1_21 = iter1_21
		end
	end

	return var1_21
end

function var5_0.addLastFX(arg0_22, arg1_22)
	local var0_22 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg1_22)

	if var0_22.last_effect ~= nil and var0_22.last_effect ~= "" then
		local var1_22 = arg0_22:generateLastFX(var0_22, var0_22.last_effect)
		local var2_22 = arg0_22._buffLastEffects[arg1_22] or {}

		table.insert(var2_22, var1_22)

		arg0_22._buffLastEffects[arg1_22] = var2_22
	end
end

function var5_0.generateLastFX(arg0_23, arg1_23, arg2_23)
	arg0_23._currentLastFXID = arg2_23

	local var0_23 = arg0_23._owner:AddFX(arg2_23)

	if arg1_23.last_effect_cld_scale or arg1_23.last_effect_cld_angle then
		local var1_23
		local var2_23 = arg1_23[buffLv] or arg1_23.effect_list

		for iter0_23, iter1_23 in ipairs(var2_23) do
			if iter1_23.arg_list.cld_data then
				var1_23 = iter1_23

				break
			end
		end

		if var1_23 then
			if arg1_23.last_effect_cld_scale then
				local var3_23 = var1_23.arg_list.cld_data.box
				local var4_23 = var0_23.transform.localScale

				if var3_23.range then
					var4_23.x = var4_23.x * var3_23.range
					var4_23.y = var4_23.y * var3_23.range
					var4_23.z = var4_23.z * var3_23.range
				else
					var4_23.x = var4_23.x * var3_23[1]
					var4_23.y = var4_23.y * var3_23[2]
					var4_23.z = var4_23.z * var3_23[3]
				end

				var0_23.transform.localScale = var4_23
			end

			if arg1_23.last_effect_cld_angle then
				local var5_23 = var1_23.arg_list.cld_data.angle
				local var6_23 = var0_23.transform:Find("scale/sector"):GetComponent(typeof(Renderer)).material
				local var7_23 = (360 - var5_23) * 0.5 - 5

				var6_23:SetInt("_AngleControl", var7_23)
			end

			if arg1_23.last_effect_bound_bone then
				local var8_23 = arg0_23._owner:GetBoneList()[arg1_23.last_effect_bound_bone]

				if var8_23 then
					var0_23.transform.localPosition = var8_23[1]
				end
			end
		end
	end

	var0_23:SetActive(true)

	return var0_23
end

function var5_0.addBlink(arg0_24, arg1_24)
	local var0_24 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg1_24)

	if var0_24.blink then
		local var1_24 = var0_24.blink
		local var2_24 = arg0_24._owner:AddBlink(var1_24[1], var1_24[2], var1_24[3], var1_24[4], var1_24[5])

		arg0_24._blinkIDList[arg1_24] = var2_24
	end
end

function var5_0.addEffect(arg0_25, arg1_25)
	local var0_25 = arg1_25.index or arg0_25:getIndex()
	local var1_25 = arg0_25._effectList[var0_25]

	if var1_25 then
		local var2_25 = var1_25.effect_tf.localScale

		var1_25.effect_go:SetActive(true)

		var1_25.effect_tf.localScale = var2_25
	else
		local var3_25 = arg0_25._owner:AddFX(arg1_25.effect)
		local var4_25 = {
			currentTime = 0,
			effect_go = var3_25,
			effect_tf = var3_25.transform,
			posFun = arg1_25.posFun,
			rotationFun = arg1_25.rotationFun,
			startTime = pg.TimeMgr.GetInstance():GetCombatTime(),
			fillFunc = arg1_25.fillFunc
		}

		arg0_25._effectList[var0_25] = var4_25

		arg0_25:updateEffect(var4_25)
		pg.EffectMgr.GetInstance():PlayBattleEffect(var3_25, var3_25.transform.localPosition, false, function(arg0_26)
			arg0_25._owner:RemoveFX(var3_25)

			arg0_25._effectList[var0_25] = nil
		end)
	end
end

function var5_0.cancelEffect(arg0_27, arg1_27)
	local var0_27 = arg1_27.index
	local var1_27 = arg0_27._effectList[var0_27]

	if var1_27 then
		arg0_27._owner:RemoveFX(var1_27.effect_go)

		arg0_27._effectList[var0_27] = nil
	end
end

function var5_0.deactiveEffect(arg0_28, arg1_28)
	local var0_28 = arg1_28.index
	local var1_28 = arg0_28._effectList[var0_28]

	if var1_28 then
		var1_28.effect_go:SetActive(false)
	end
end

function var5_0.getIndex(arg0_29)
	arg0_29._effectIndex = arg0_29._effectIndex + 1

	return arg0_29._effectIndex
end

function var5_0.updateEffect(arg0_30, arg1_30)
	if arg1_30.posFun then
		local var0_30 = arg1_30.posFun(arg1_30.currentTime)

		arg1_30.effect_tf.localPosition = var0_30
	end

	if arg1_30.rotationFun then
		local var1_30 = arg1_30.rotationFun(arg1_30.currentTime)

		if arg0_30._dir == var0_0.Battle.BattleConst.UnitDir.LEFT then
			var1_30.y = var1_30.y - 180
		end

		arg1_30.effect_tf.localEulerAngles = var1_30
	end

	if arg1_30.fillFunc then
		arg0_30._characterScaleX = arg0_30._characterScaleX or arg0_30._owner:GetTf().localScale.x
		arg0_30._characterScaleZ = arg0_30._characterScaleZ or arg0_30._owner:GetTf().localScale.z

		local var2_30, var3_30, var4_30 = arg1_30.fillFunc()

		arg1_30.effect_tf.position = var2_30
		arg1_30.effect_tf.localScale = Vector3(var3_30 / arg0_30._characterScaleX, 0, var4_30 / arg0_30._characterScaleZ)
	end
end
