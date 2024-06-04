ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBuffEvent
local var2 = var0.Battle.BattleUnitEvent
local var3 = var0.Battle.BattleResourceManager
local var4 = var0.Battle.BattleDataFunction

var0.Battle.BattleEffectComponent = class("BattleEffectComponent")

local var5 = var0.Battle.BattleEffectComponent

var5.__name = "BattleEffectComponent"

function var5.Ctor(arg0, arg1)
	var0.EventListener.AttachEventListener(arg0)

	arg0._owner = arg1
	arg0._blinkIDList = {}
	arg0._buffLastEffects = {}
	arg0._effectIndex = 0
	arg0._effectList = {}
end

function var5.SwitchOwner(arg0, arg1, arg2)
	arg0._owner = arg1

	for iter0, iter1 in pairs(arg0._blinkIDList) do
		if arg2[iter1] then
			arg0._blinkIDList[iter0] = arg2[iter1]
		end
	end
end

function var5.ClearEffect(arg0)
	for iter0, iter1 in pairs(arg0._blinkIDList) do
		arg0._owner:RemoveBlink(iter1)
	end

	arg0._blinkIDList = {}
end

function var5.Dispose(arg0)
	for iter0, iter1 in pairs(arg0._blinkIDList) do
		arg0._owner:RemoveBlink(iter1)
	end

	arg0._effectList = nil
	arg0._buffLastEffects = nil

	var0.EventListener.DetachEventListener(arg0)
end

function var5.GetFXPool(arg0)
	return var0.Battle.BattleFXPool.GetInstance()
end

function var5.SetUnitDataEvent(arg0, arg1)
	arg1:RegisterEventListener(arg0, var1.BUFF_CAST, arg0.onBuffCast)
	arg1:RegisterEventListener(arg0, var1.BUFF_ATTACH, arg0.onBuffAdd)
	arg1:RegisterEventListener(arg0, var1.BUFF_STACK, arg0.onBuffStack)
	arg1:RegisterEventListener(arg0, var1.BUFF_REMOVE, arg0.onBuffRemove)
	arg1:RegisterEventListener(arg0, var2.ADD_EFFECT, arg0.onAddEffect)
	arg1:RegisterEventListener(arg0, var2.CANCEL_EFFECT, arg0.onCancelEffect)
	arg1:RegisterEventListener(arg0, var2.DEACTIVE_EFFECT, arg0.onDeactiveEffect)
end

function var5.RemoveUnitEvent(arg0, arg1)
	arg1:UnregisterEventListener(arg0, var1.BUFF_ATTACH)
	arg1:UnregisterEventListener(arg0, var1.BUFF_CAST)
	arg1:UnregisterEventListener(arg0, var1.BUFF_STACK)
	arg1:UnregisterEventListener(arg0, var1.BUFF_REMOVE)
	arg1:UnregisterEventListener(arg0, var2.ADD_EFFECT)
	arg1:UnregisterEventListener(arg0, var2.CANCEL_EFFECT)
	arg1:UnregisterEventListener(arg0, var2.DEACTIVE_EFFECT)
end

function var5.Update(arg0, arg1)
	arg0._dir = arg0._owner:GetUnitData():GetDirection()

	for iter0, iter1 in pairs(arg0._effectList) do
		iter1.currentTime = arg1 - iter1.startTime

		arg0:updateEffect(iter1)
	end
end

function var5.onAddEffect(arg0, arg1)
	local var0 = arg1.Data

	arg0:addEffect(var0)
end

function var5.onCancelEffect(arg0, arg1)
	local var0 = arg1.Data

	arg0:cancelEffect(var0)
end

function var5.onDeactiveEffect(arg0, arg1)
	local var0 = arg1.Data

	arg0:deactiveEffect(var0)
end

function var5.onBuffAdd(arg0, arg1)
	arg0:DoWhenAddBuff(arg1)
end

function var5.onBuffCast(arg0, arg1)
	local var0 = arg1.Data.buff_id

	arg0:addBlink(var0)
end

function var5.DoWhenAddBuff(arg0, arg1)
	local var0 = arg1.Data.buff_id
	local var1 = arg1.Data.buff_level

	arg0:addInitFX(var0)
	arg0:addLastFX(var0)
end

function var5.onBuffStack(arg0, arg1)
	arg0:DoWhenStackBuff(arg1)
end

function var5.DoWhenStackBuff(arg0, arg1)
	local var0 = arg1.Data.buff_id

	arg0:addInitFX(var0)

	local var1 = var0.Battle.BattleDataFunction.GetBuffTemplate(var0)

	if var1.last_effect ~= "" and var1.last_effect_stack then
		local var2 = arg1.Data.stack_count
		local var3 = #arg0._buffLastEffects[var0]

		if var3 < var2 then
			arg0:addLastFX(var0)
		elseif var2 < var3 then
			local var4 = var3 - var2

			while var4 > 0 do
				arg0:removeLastFX(var0)

				var4 = var4 - 1
			end
		end
	end
end

function var5.onBuffRemove(arg0, arg1)
	local var0 = arg1.Data.buff_id

	if arg0._buffLastEffects[var0] then
		local var1 = #arg0._buffLastEffects[var0]

		while var1 > 0 do
			arg0:removeLastFX(var0)

			var1 = var1 - 1
		end
	end

	local var2 = arg0._blinkIDList[var0]

	if var2 then
		arg0._owner:RemoveBlink(var2)

		arg0._blinkIDList[var0] = nil
	end
end

function var5.addInitFX(arg0, arg1)
	local var0 = var0.Battle.BattleDataFunction.GetBuffTemplate(arg1)

	if var0.init_effect and var0.init_effect ~= "" then
		local var1 = var0.init_effect

		if var0.skin_adapt then
			var1 = var4.SkinAdaptFXID(var1, arg0._owner:GetUnitData():GetSkinID())
		end

		arg0._owner:AddFX(var1)
	end
end

function var5.removeLastFX(arg0, arg1)
	local var0 = arg0._buffLastEffects[arg1]

	if var0 ~= nil and #var0 > 0 then
		local var1 = table.remove(var0)

		arg0._owner:RemoveFX(var1)
	end
end

function var5.addLastFX(arg0, arg1)
	local var0 = var0.Battle.BattleDataFunction.GetBuffTemplate(arg1)

	if var0.last_effect ~= nil and var0.last_effect ~= "" then
		local var1 = arg0._owner:AddFX(var0.last_effect)
		local var2 = arg0._buffLastEffects[arg1] or {}

		table.insert(var2, var1)

		arg0._buffLastEffects[arg1] = var2

		if var0.last_effect_cld_scale or var0.last_effect_cld_angle then
			local var3
			local var4 = var0[buffLv] or var0.effect_list

			for iter0, iter1 in ipairs(var4) do
				if iter1.arg_list.cld_data then
					var3 = iter1

					break
				end
			end

			if var3 then
				if var0.last_effect_cld_scale then
					local var5 = var3.arg_list.cld_data.box
					local var6 = var1.transform.localScale

					if var5.range then
						var6.x = var6.x * var5.range
						var6.y = var6.y * var5.range
						var6.z = var6.z * var5.range
					else
						var6.x = var6.x * var5[1]
						var6.y = var6.y * var5[2]
						var6.z = var6.z * var5[3]
					end

					var1.transform.localScale = var6
				end

				if var0.last_effect_cld_angle then
					local var7 = var3.arg_list.cld_data.angle
					local var8 = var1.transform:Find("scale/sector"):GetComponent(typeof(Renderer)).material
					local var9 = (360 - var7) * 0.5 - 5

					var8:SetInt("_AngleControl", var9)
				end

				if var0.last_effect_bound_bone then
					local var10 = arg0._owner:GetBoneList()[var0.last_effect_bound_bone]

					if var10 then
						var1.transform.localPosition = var10[1]
					end
				end
			end
		end

		var1:SetActive(true)
	end
end

function var5.addBlink(arg0, arg1)
	local var0 = var0.Battle.BattleDataFunction.GetBuffTemplate(arg1)

	if var0.blink then
		local var1 = var0.blink
		local var2 = arg0._owner:AddBlink(var1[1], var1[2], var1[3], var1[4], var1[5])

		arg0._blinkIDList[arg1] = var2
	end
end

function var5.addEffect(arg0, arg1)
	local var0 = arg1.index or arg0:getIndex()
	local var1 = arg0._effectList[var0]

	if var1 then
		local var2 = var1.effect_tf.localScale

		var1.effect_go:SetActive(true)

		var1.effect_tf.localScale = var2
	else
		local var3 = arg0._owner:AddFX(arg1.effect)
		local var4 = {
			currentTime = 0,
			effect_go = var3,
			effect_tf = var3.transform,
			posFun = arg1.posFun,
			rotationFun = arg1.rotationFun,
			startTime = pg.TimeMgr.GetInstance():GetCombatTime(),
			fillFunc = arg1.fillFunc
		}

		arg0._effectList[var0] = var4

		arg0:updateEffect(var4)
		pg.EffectMgr.GetInstance():PlayBattleEffect(var3, var3.transform.localPosition, false, function(arg0)
			arg0._owner:RemoveFX(var3)

			arg0._effectList[var0] = nil
		end)
	end
end

function var5.cancelEffect(arg0, arg1)
	local var0 = arg1.index
	local var1 = arg0._effectList[var0]

	if var1 then
		arg0._owner:RemoveFX(var1.effect_go)

		arg0._effectList[var0] = nil
	end
end

function var5.deactiveEffect(arg0, arg1)
	local var0 = arg1.index
	local var1 = arg0._effectList[var0]

	if var1 then
		var1.effect_go:SetActive(false)
	end
end

function var5.getIndex(arg0)
	arg0._effectIndex = arg0._effectIndex + 1

	return arg0._effectIndex
end

function var5.updateEffect(arg0, arg1)
	if arg1.posFun then
		local var0 = arg1.posFun(arg1.currentTime)

		arg1.effect_tf.localPosition = var0
	end

	if arg1.rotationFun then
		local var1 = arg1.rotationFun(arg1.currentTime)

		if arg0._dir == var0.Battle.BattleConst.UnitDir.LEFT then
			var1.y = var1.y - 180
		end

		arg1.effect_tf.localEulerAngles = var1
	end

	if arg1.fillFunc then
		arg0._characterScaleX = arg0._characterScaleX or arg0._owner:GetTf().localScale.x
		arg0._characterScaleZ = arg0._characterScaleZ or arg0._owner:GetTf().localScale.z

		local var2, var3, var4 = arg1.fillFunc()

		arg1.effect_tf.position = var2
		arg1.effect_tf.localScale = Vector3(var3 / arg0._characterScaleX, 0, var4 / arg0._characterScaleZ)
	end
end
