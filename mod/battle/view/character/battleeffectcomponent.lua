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

	local var1_16 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(var0_16)

	if var1_16.last_effect ~= "" and var1_16.last_effect_stack then
		local var2_16 = arg1_16.Data.stack_count
		local var3_16 = #arg0_16._buffLastEffects[var0_16]

		if var3_16 < var2_16 then
			arg0_16:addLastFX(var0_16)
		elseif var2_16 < var3_16 then
			local var4_16 = var3_16 - var2_16

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

function var5_0.addLastFX(arg0_20, arg1_20)
	local var0_20 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg1_20)

	if var0_20.last_effect ~= nil and var0_20.last_effect ~= "" then
		local var1_20 = arg0_20._owner:AddFX(var0_20.last_effect)
		local var2_20 = arg0_20._buffLastEffects[arg1_20] or {}

		table.insert(var2_20, var1_20)

		arg0_20._buffLastEffects[arg1_20] = var2_20

		if var0_20.last_effect_cld_scale or var0_20.last_effect_cld_angle then
			local var3_20
			local var4_20 = var0_20[buffLv] or var0_20.effect_list

			for iter0_20, iter1_20 in ipairs(var4_20) do
				if iter1_20.arg_list.cld_data then
					var3_20 = iter1_20

					break
				end
			end

			if var3_20 then
				if var0_20.last_effect_cld_scale then
					local var5_20 = var3_20.arg_list.cld_data.box
					local var6_20 = var1_20.transform.localScale

					if var5_20.range then
						var6_20.x = var6_20.x * var5_20.range
						var6_20.y = var6_20.y * var5_20.range
						var6_20.z = var6_20.z * var5_20.range
					else
						var6_20.x = var6_20.x * var5_20[1]
						var6_20.y = var6_20.y * var5_20[2]
						var6_20.z = var6_20.z * var5_20[3]
					end

					var1_20.transform.localScale = var6_20
				end

				if var0_20.last_effect_cld_angle then
					local var7_20 = var3_20.arg_list.cld_data.angle
					local var8_20 = var1_20.transform:Find("scale/sector"):GetComponent(typeof(Renderer)).material
					local var9_20 = (360 - var7_20) * 0.5 - 5

					var8_20:SetInt("_AngleControl", var9_20)
				end

				if var0_20.last_effect_bound_bone then
					local var10_20 = arg0_20._owner:GetBoneList()[var0_20.last_effect_bound_bone]

					if var10_20 then
						var1_20.transform.localPosition = var10_20[1]
					end
				end
			end
		end

		var1_20:SetActive(true)
	end
end

function var5_0.addBlink(arg0_21, arg1_21)
	local var0_21 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg1_21)

	if var0_21.blink then
		local var1_21 = var0_21.blink
		local var2_21 = arg0_21._owner:AddBlink(var1_21[1], var1_21[2], var1_21[3], var1_21[4], var1_21[5])

		arg0_21._blinkIDList[arg1_21] = var2_21
	end
end

function var5_0.addEffect(arg0_22, arg1_22)
	local var0_22 = arg1_22.index or arg0_22:getIndex()
	local var1_22 = arg0_22._effectList[var0_22]

	if var1_22 then
		local var2_22 = var1_22.effect_tf.localScale

		var1_22.effect_go:SetActive(true)

		var1_22.effect_tf.localScale = var2_22
	else
		local var3_22 = arg0_22._owner:AddFX(arg1_22.effect)
		local var4_22 = {
			currentTime = 0,
			effect_go = var3_22,
			effect_tf = var3_22.transform,
			posFun = arg1_22.posFun,
			rotationFun = arg1_22.rotationFun,
			startTime = pg.TimeMgr.GetInstance():GetCombatTime(),
			fillFunc = arg1_22.fillFunc
		}

		arg0_22._effectList[var0_22] = var4_22

		arg0_22:updateEffect(var4_22)
		pg.EffectMgr.GetInstance():PlayBattleEffect(var3_22, var3_22.transform.localPosition, false, function(arg0_23)
			arg0_22._owner:RemoveFX(var3_22)

			arg0_22._effectList[var0_22] = nil
		end)
	end
end

function var5_0.cancelEffect(arg0_24, arg1_24)
	local var0_24 = arg1_24.index
	local var1_24 = arg0_24._effectList[var0_24]

	if var1_24 then
		arg0_24._owner:RemoveFX(var1_24.effect_go)

		arg0_24._effectList[var0_24] = nil
	end
end

function var5_0.deactiveEffect(arg0_25, arg1_25)
	local var0_25 = arg1_25.index
	local var1_25 = arg0_25._effectList[var0_25]

	if var1_25 then
		var1_25.effect_go:SetActive(false)
	end
end

function var5_0.getIndex(arg0_26)
	arg0_26._effectIndex = arg0_26._effectIndex + 1

	return arg0_26._effectIndex
end

function var5_0.updateEffect(arg0_27, arg1_27)
	if arg1_27.posFun then
		local var0_27 = arg1_27.posFun(arg1_27.currentTime)

		arg1_27.effect_tf.localPosition = var0_27
	end

	if arg1_27.rotationFun then
		local var1_27 = arg1_27.rotationFun(arg1_27.currentTime)

		if arg0_27._dir == var0_0.Battle.BattleConst.UnitDir.LEFT then
			var1_27.y = var1_27.y - 180
		end

		arg1_27.effect_tf.localEulerAngles = var1_27
	end

	if arg1_27.fillFunc then
		arg0_27._characterScaleX = arg0_27._characterScaleX or arg0_27._owner:GetTf().localScale.x
		arg0_27._characterScaleZ = arg0_27._characterScaleZ or arg0_27._owner:GetTf().localScale.z

		local var2_27, var3_27, var4_27 = arg1_27.fillFunc()

		arg1_27.effect_tf.position = var2_27
		arg1_27.effect_tf.localScale = Vector3(var3_27 / arg0_27._characterScaleX, 0, var4_27 / arg0_27._characterScaleZ)
	end
end
