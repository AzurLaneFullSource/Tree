local var0_0 = class("Live2dDrag")
local var1_0 = 4
local var2_0 = {
	Live2D.DRAG_DOWN_ACTION
}
local var3_0 = 1
local var4_0 = 2
local var5_0 = 3
local var6_0 = 1
local var7_0 = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.live2dData = arg2_1
	arg0_1.frameRate = Application.targetFrameRate or 60

	print("drag id " .. arg1_1.id .. "初始化")

	arg0_1.id = arg1_1.id
	arg0_1.drawAbleName = arg1_1.draw_able_name or ""
	arg0_1.parameterName = arg1_1.parameter
	arg0_1.mode = arg1_1.mode
	arg0_1.startValue = arg1_1.start_value or 0
	arg0_1.range = arg1_1.range
	arg0_1.offsetX = arg1_1.offset_x

	if arg0_1.offsetX == 0 then
		arg0_1.offsetX = nil
	end

	arg0_1.offsetY = arg1_1.offset_y

	if arg0_1.offsetY == 0 then
		arg0_1.offsetY = nil
	end

	arg0_1.smooth = arg1_1.smooth / 1000
	arg0_1.smoothRevert = arg1_1.revert_smooth / 1000
	arg0_1.revert = arg1_1.revert
	arg0_1.ignoreReact = arg1_1.ignore_react == 1
	arg0_1.gyro = arg1_1.gyro == 1 or nil
	arg0_1.gyroX = arg1_1.gyro_x == 1
	arg0_1.gyroY = arg1_1.gyro_y == 1
	arg0_1.gyroZ = arg1_1.gyro_z == 1
	arg0_1.ignoreAction = arg1_1.ignore_action == 1
	arg0_1.dragDirect = arg1_1.drag_direct
	arg0_1.rangeAbs = arg1_1.range_abs == 1
	arg0_1.partsData = arg1_1.parts_data
	arg0_1.actionTrigger = arg1_1.action_trigger
	arg0_1.reactX = arg1_1.react_pos_x ~= 0 and arg1_1.react_pos_x or nil
	arg0_1.reactY = arg1_1.react_pos_y ~= 0 and arg1_1.react_pos_y or nil
	arg0_1.actionTriggerActive = arg1_1.action_trigger_active
	arg0_1.relationParameter = arg1_1.relation_parameter
	arg0_1.relationParts = arg0_1.relationParameter.parts
	arg0_1.limitTime = arg1_1.limit_time > 0 and arg1_1.limit_time or var1_0
	arg0_1.listenerData = arg1_1.listener_data
	arg0_1.listenerType = arg0_1.listenerData.type
	arg0_1.listenerChange = arg0_1.listenerData.change
	arg0_1.listenerApply = arg0_1.listenerData.apply
	arg0_1.reactCondition = arg1_1.react_condition and arg1_1.react_condition ~= "" and arg1_1.react_condition or {}
	arg0_1.idleOn = arg0_1.reactCondition.idle_on and arg0_1.reactCondition.idle_on or {}
	arg0_1.idleOff = arg0_1.reactCondition.idle_off and arg0_1.reactCondition.idle_off or {}

	local var0_1 = false

	if type(arg1_1.revert_idle_index) == "number" then
		var0_1 = arg1_1.revert_idle_index == 1 and true or false
	elseif type(arg1_1.revert_idle_index) == "table" then
		var0_1 = arg1_1.revert_idle_index
	end

	arg0_1.revertIdleIndex = var0_1
	arg0_1.revertActionIndex = arg1_1.revert_action_index == 1 and true or false
	arg0_1.saveParameterFlag = true

	if arg1_1.save_parameter == -1 then
		arg0_1.saveParameterFlag = false
	end

	arg0_1.randomAttitudeIndex = L2D_RANDOM_PARAM
	arg0_1._active = false
	arg0_1._parameterCom = nil
	arg0_1.parameterValue = arg0_1.startValue
	arg0_1.parameterTargetValue = arg0_1.startValue
	arg0_1.parameterSmooth = 0
	arg0_1.parameterSmoothTime = arg0_1.smooth
	arg0_1.mouseInputDown = Vector2(0, 0)
	arg0_1.nextTriggerTime = 0
	arg0_1.triggerActionTime = 0
	arg0_1.sensitive = 4
	arg0_1.l2dIdleIndex = 0
	arg0_1.reactPos = Vector2(0, 0)
	arg0_1.actionListIndex = 1
	arg0_1._relationParameterList = {}
	arg0_1.offsetDragX = arg0_1.startValue
	arg0_1.offsetDragY = arg0_1.startValue
	arg0_1.offsetDragTargetX = arg0_1.startValue
	arg0_1.offsetDragTargetY = arg0_1.startValue
	arg0_1.parameterComAdd = true
	arg0_1.reactConditionFlag = false
	arg0_1.loadL2dStep = true
end

function var0_0.onListenerEvent(arg0_2, arg1_2, arg2_2)
	if arg0_2.listenerType == arg1_2 then
		local var0_2 = arg2_2.action
		local var1_2 = arg2_2.values
		local var2_2 = arg2_2.idle
		local var3_2 = arg2_2.idle_change
		local var4_2 = arg2_2.draw_able_name
		local var5_2 = arg2_2.parameter_name
		local var6_2 = false

		if arg0_2.listenerChange and #arg0_2.listenerChange > 0 then
			local var7_2 = arg0_2:getChangeCheckName(arg1_2, arg2_2)

			if var7_2 then
				for iter0_2 = 1, #arg0_2.listenerChange do
					local var8_2 = arg0_2.listenerChange[iter0_2]
					local var9_2 = var8_2[1]
					local var10_2 = var8_2[2]
					local var11_2 = var8_2[3]
					local var12_2 = #var8_2 >= 4 and var8_2[4] or 1

					if table.contains(var10_2, var7_2) then
						local var13_2

						if var9_2 == var6_0 then
							var13_2 = arg0_2.parameterTargetValue + var11_2
						elseif var9_2 == var7_0 then
							var13_2 = var11_2
						end

						if var13_2 then
							var6_2 = true

							local var14_2 = arg0_2:fixParameterTargetValue(var13_2, arg0_2.range, arg0_2.rangeAbs, arg0_2.dragDirect)

							if arg0_2.actionTrigger.change_focus == false then
								arg0_2.prepareTargetValue = var14_2

								print(arg0_2.parameterName .. "等待动作结束后的target赋值" .. arg0_2.parameterTargetValue)
							else
								arg0_2:setTargetValue(var14_2)
								print(arg0_2.parameterName .. " 数值变更为" .. arg0_2.parameterTargetValue)
							end
						end

						if var12_2 and var12_2 > 0 then
							var6_2 = true
							arg0_2.actionListIndex = var12_2
						end
					end
				end
			end
		end

		if arg0_2.listenerApply and #arg0_2.listenerApply > 0 then
			local var15_2 = arg0_2.listenerApply[1]
			local var16_2 = arg0_2.listenerApply[2]

			if var15_2 == 1 and var6_2 then
				local var17_2 = arg0_2.parameterTargetValue

				if arg0_2.prepareTargetValue ~= nil then
					var17_2 = arg0_2.prepareTargetValue
				end

				local var18_2

				for iter1_2 = 1, #var16_2 do
					local var19_2 = var16_2[iter1_2]

					if var17_2 >= var19_2[1] and var17_2 < var19_2[2] then
						var18_2 = var19_2[3]
					end
				end

				if var18_2 then
					arg0_2:onEventCallback(Live2D.EVENT_CHANGE_IDLE_INDEX, {
						id = arg0_2.id,
						idle = var18_2,
						activeData = arg0_2.actionTriggerActive
					})
				end
			end
		end
	end
end

function var0_0.getChangeCheckName(arg0_3, arg1_3, arg2_3)
	if arg1_3 == Live2D.ON_ACTION_PLAY then
		return arg2_3.action
	elseif arg1_3 == Live2D.ON_ACTION_DRAG_CLICK then
		-- block empty
	elseif arg1_3 == Live2D.ON_ACTION_CHANGE_IDLE then
		return arg2_3.idle
	elseif arg1_3 == Live2D.ON_ACTION_PARAMETER then
		-- block empty
	elseif arg1_3 == Live2D.ON_ACTION_DOWN then
		-- block empty
	elseif arg1_3 == Live2D.ON_ACTION_XY_TRIGGER then
		-- block empty
	elseif arg1_3 == Live2D.ON_ACTION_DRAG_TRIGGER then
		-- block empty
	end

	return nil
end

function var0_0.startDrag(arg0_4)
	if arg0_4.ignoreAction and arg0_4.l2dIsPlaying then
		return
	end

	if not arg0_4._active then
		arg0_4._active = true
		arg0_4.mouseInputDown = Input.mousePosition
		arg0_4.mouseInputDownTime = Time.time
		arg0_4.triggerActionTime = 0

		if table.contains(var2_0, arg0_4.actionTrigger.type) then
			arg0_4.actionListIndex = 1
		end

		arg0_4.parameterSmoothTime = arg0_4.smooth
	end
end

function var0_0.stopDrag(arg0_5)
	if arg0_5._active then
		arg0_5._active = false

		if arg0_5.revert > 0 then
			arg0_5.parameterToStart = arg0_5.revert / 1000
			arg0_5.parameterSmoothTime = arg0_5.smoothRevert
		end

		if arg0_5.offsetDragX then
			arg0_5.offsetDragTargetX = arg0_5:fixParameterTargetValue(arg0_5.offsetDragX, arg0_5.range, arg0_5.rangeAbs, arg0_5.dragDirect)
		end

		if arg0_5.offsetDragY then
			arg0_5.offsetDragTargetY = arg0_5:fixParameterTargetValue(arg0_5.offsetDragY, arg0_5.range, arg0_5.rangeAbs, arg0_5.dragDirect)
		end

		arg0_5:checkResetTriggerTime()

		arg0_5.mouseInputUp = Input.mousePosition
		arg0_5.mouseInputUpTime = Time.time

		arg0_5:updatePartsParameter()
		arg0_5:saveData()
	end
end

function var0_0.checkResetTriggerTime(arg0_6)
	local var0_6 = false

	if arg0_6.actionTrigger.type == Live2D.DRAG_DOWN_ACTION and arg0_6.actionTrigger.last then
		var0_6 = true
	end

	if var0_6 then
		arg0_6:resetNextTriggerTime()
	end
end

function var0_0.resetNextTriggerTime(arg0_7)
	arg0_7.nextTriggerTime = 0
end

function var0_0.updatePartsParameter(arg0_8)
	if type(arg0_8.partsData) == "table" then
		local var0_8 = arg0_8.partsData.parts
		local var1_8 = arg0_8.partsData.type
		local var2_8 = false

		if arg0_8.offsetX or arg0_8.offsetY then
			var2_8 = true
		elseif arg0_8.actionTrigger and arg0_8.actionTrigger.type == Live2D.DRAG_DOWN_TOUCH then
			var2_8 = true
		end

		if var2_8 then
			local var3_8 = arg0_8.parameterTargetValue
			local var4_8
			local var5_8

			for iter0_8 = 1, #var0_8 do
				local var6_8 = var0_8[iter0_8]
				local var7_8 = math.abs(var3_8 - var6_8)

				if var1_8 == var3_0 or not var1_8 then
					if not var4_8 or var7_8 < var4_8 then
						var4_8 = var7_8
						var5_8 = iter0_8
					end
				elseif var1_8 == var4_0 then
					if var6_8 <= var3_8 and (not var4_8 or var7_8 < var4_8) then
						var4_8 = var7_8
						var5_8 = iter0_8
					end
				elseif var1_8 == var5_0 and var3_8 <= var6_8 and (not var4_8 or var7_8 < var4_8) then
					var4_8 = var7_8
					var5_8 = iter0_8
				end
			end

			if var5_8 then
				if math.abs(arg0_8.parameterTargetValue - var0_8[var5_8]) >= 0.05 then
					print("吸附数值" .. var0_8[var5_8])
				end

				arg0_8:setTargetValue(var0_8[var5_8])
			end
		end
	end
end

function var0_0.getIgnoreReact(arg0_9)
	return arg0_9.ignoreReact
end

function var0_0.setParameterCom(arg0_10, arg1_10)
	if not arg1_10 then
		print("live2dDrag id:" .. tostring(arg0_10.id) .. "设置了null的组件(该打印非报错)")
	end

	arg0_10._parameterCom = arg1_10
end

function var0_0.getParameterCom(arg0_11)
	return arg0_11._parameterCom
end

function var0_0.addRelationComData(arg0_12, arg1_12, arg2_12)
	table.insert(arg0_12._relationParameterList, {
		com = arg1_12,
		data = arg2_12
	})
end

function var0_0.getRelationParameterList(arg0_13)
	return arg0_13._relationParameterList
end

function var0_0.getReactCondition(arg0_14)
	return arg0_14.reactConditionFlag
end

function var0_0.getActive(arg0_15)
	return arg0_15._active
end

function var0_0.getParameterUpdateFlag(arg0_16)
	return arg0_16._parameterUpdateFlag
end

function var0_0.setEventCallback(arg0_17, arg1_17)
	arg0_17._eventCallback = arg1_17
end

function var0_0.onEventCallback(arg0_18, arg1_18, arg2_18, arg3_18)
	if arg1_18 == Live2D.EVENT_ACTION_APPLY then
		local var0_18 = {}
		local var1_18
		local var2_18 = false
		local var3_18
		local var4_18
		local var5_18
		local var6_18 = false

		if arg0_18.actionTrigger.action then
			var1_18 = arg0_18:fillterAction(arg0_18.actionTrigger.action)
			var0_18 = arg0_18.actionTriggerActive
			var2_18 = arg0_18.actionTrigger.focus or false
			var3_18 = arg0_18.actionTrigger.target or nil
			var6_18 = arg0_18.actionTrigger.target_focus == 1 and true or false

			if (arg0_18.actionTrigger.circle or nil) and var3_18 and var3_18 == arg0_18.parameterTargetValue then
				var3_18 = arg0_18.startValue
			end

			var4_18 = arg0_18.actionTrigger.react or nil

			arg0_18:triggerAction()
			arg0_18:stopDrag()
		elseif arg0_18.actionTrigger.action_list then
			local var7_18 = arg0_18.actionTrigger.action_list[arg0_18.actionListIndex]

			var1_18 = arg0_18:fillterAction(var7_18.action)

			if arg0_18.actionTriggerActive.active_list and arg0_18.actionListIndex <= #arg0_18.actionTriggerActive.active_list then
				var0_18 = arg0_18.actionTriggerActive.active_list[arg0_18.actionListIndex]
			else
				var0_18 = arg0_18.actionTriggerActive
			end

			var2_18 = var7_18.focus or true
			var3_18 = var7_18.target or nil
			var6_18 = var7_18.target_focus == 1 and true or false
			var4_18 = var7_18.react or nil

			arg0_18:triggerAction()

			if arg0_18.actionListIndex == #arg0_18.actionTrigger.action_list then
				arg0_18:stopDrag()

				arg0_18.actionListIndex = 1
			else
				arg0_18.actionListIndex = arg0_18.actionListIndex + 1
			end
		elseif not arg0_18.actionTrigger.action then
			var1_18 = arg0_18:fillterAction(arg0_18.actionTrigger.action)
			var0_18 = arg0_18.actionTriggerActive
			var2_18 = arg0_18.actionTrigger.focus or false
			var3_18 = arg0_18.actionTrigger.target or nil
			var6_18 = arg0_18.actionTrigger.target_focus == 1 and true or false

			local var8_18 = arg0_18.actionTrigger.circle or nil

			var4_18 = arg0_18.actionTrigger.react or nil

			if var8_18 and var3_18 and var3_18 == arg0_18.parameterTargetValue then
				var3_18 = arg0_18.startValue
			end

			arg0_18:triggerAction()
			arg0_18:setTriggerActionFlag(false)
			arg0_18:stopDrag()
		end

		if var0_18.idle then
			if type(var0_18.idle) == "number" then
				if var0_18.idle == arg0_18.l2dIdleIndex and not var0_18.repeat_flag then
					return
				end
			elseif type(var0_18.idle) == "table" and #var0_18.idle == 1 and var0_18.idle[1] == arg0_18.l2dIdleIndex and not var0_18.repeat_flag then
				return
			end
		end

		if var3_18 then
			arg0_18:setTargetValue(var3_18)

			if var6_18 then
				arg0_18:setParameterValue(var3_18)
			end

			if not var1_18 then
				arg0_18.revertResetFlag = true
			end
		end

		arg2_18 = {
			id = arg0_18.id,
			action = var1_18,
			activeData = var0_18,
			focus = var2_18,
			react = var4_18,
			callback = arg3_18,
			finishCall = function()
				arg0_18:actionApplyFinish()
			end
		}
	elseif arg1_18 == Live2D.EVENT_ACTION_ABLE then
		-- block empty
	elseif arg1_18 == Live2D.EVENT_CHANGE_IDLE_INDEX then
		print("change idle")
	elseif arg1_18 == Live2D.EVENT_GET_PARAMETER then
		arg2_18.callback = arg3_18
	end

	arg0_18._eventCallback(arg1_18, arg2_18)
end

function var0_0.fillterAction(arg0_20, arg1_20)
	if type(arg1_20) == "table" then
		return arg1_20[math.random(1, #arg1_20)]
	else
		return arg1_20
	end
end

function var0_0.onEventNotice(arg0_21, arg1_21)
	if arg0_21._eventCallback then
		local var0_21 = arg0_21:getCommonNoticeData()

		arg0_21._eventCallback(arg1_21, var0_21)
	end
end

function var0_0.getCommonNoticeData(arg0_22)
	return {
		draw_able_name = arg0_22.drawAbleName,
		parameter_name = arg0_22.parameterName,
		parameter_target = arg0_22.parameterTargetValue
	}
end

function var0_0.setTargetValue(arg0_23, arg1_23)
	arg0_23.parameterTargetValue = arg1_23
end

function var0_0.getParameter(arg0_24)
	return arg0_24.parameterValue
end

function var0_0.getParameToTargetFlag(arg0_25)
	if arg0_25.parameterValue ~= arg0_25.parameterTargetValue then
		return true
	end

	if arg0_25.parameterToStart and arg0_25.parameterToStart > 0 then
		return true
	end

	return false
end

function var0_0.actionApplyFinish(arg0_26)
	return
end

function var0_0.stepParameter(arg0_27)
	arg0_27:updateState()
	arg0_27:updateTrigger()
	arg0_27:updateParameterUpdateFlag()
	arg0_27:updateGyro()
	arg0_27:updateDrag()
	arg0_27:updateReactValue()
	arg0_27:updateParameterValue()
	arg0_27:updateRelationValue()
	arg0_27:checkReset()

	arg0_27.loadL2dStep = false
end

function var0_0.updateParameterUpdateFlag(arg0_28)
	if arg0_28.actionTrigger.type == Live2D.DRAG_CLICK_ACTION then
		arg0_28._parameterUpdateFlag = true
	elseif arg0_28.actionTrigger.type == Live2D.DRAG_RELATION_IDLE then
		if not arg0_28._parameterUpdateFlag then
			if not arg0_28.l2dIsPlaying then
				arg0_28._parameterUpdateFlag = true

				arg0_28:changeParameComAble(true)
			elseif not table.contains(arg0_28.actionTrigger.remove_com_list, arg0_28.l2dPlayActionName) then
				arg0_28._parameterUpdateFlag = true

				arg0_28:changeParameComAble(true)
			end
		elseif arg0_28._parameterUpdateFlag == true and arg0_28.l2dIsPlaying and table.contains(arg0_28.actionTrigger.remove_com_list, arg0_28.l2dPlayActionName) then
			arg0_28._parameterUpdateFlag = false

			arg0_28:changeParameComAble(false)
		end
	elseif arg0_28.actionTrigger.type == Live2D.DRAG_DOWN_TOUCH then
		arg0_28._parameterUpdateFlag = true
	elseif arg0_28.actionTrigger.type == Live2D.DRAG_LISTENER_EVENT then
		arg0_28._parameterUpdateFlag = true
	else
		arg0_28._parameterUpdateFlag = false
	end
end

function var0_0.changeParameComAble(arg0_29, arg1_29)
	if arg0_29.parameterComAdd == arg1_29 then
		return
	end

	arg0_29.parameterComAdd = arg1_29

	if arg1_29 then
		arg0_29:onEventCallback(Live2D.EVENT_ADD_PARAMETER_COM, {
			com = arg0_29._parameterCom,
			start = arg0_29.startValue,
			mode = arg0_29.mode
		})
	else
		arg0_29:onEventCallback(Live2D.EVENT_REMOVE_PARAMETER_COM, {
			com = arg0_29._parameterCom,
			mode = arg0_29.mode
		})
	end
end

function var0_0.updateDrag(arg0_30)
	if not arg0_30.offsetX and not arg0_30.offsetY then
		return
	end

	local var0_30

	if arg0_30._active then
		local var1_30 = Input.mousePosition

		if arg0_30.offsetX and arg0_30.offsetX ~= 0 then
			local var2_30 = var1_30.x - arg0_30.mouseInputDown.x

			var0_30 = arg0_30.offsetDragTargetX + var2_30 / arg0_30.offsetX
			arg0_30.offsetDragX = var0_30
		end

		if arg0_30.offsetY and arg0_30.offsetY ~= 0 then
			local var3_30 = var1_30.y - arg0_30.mouseInputDown.y

			var0_30 = arg0_30.offsetDragTargetY + var3_30 / arg0_30.offsetY
			arg0_30.offsetDragY = var0_30
		end

		if var0_30 then
			arg0_30:setTargetValue(arg0_30:fixParameterTargetValue(var0_30, arg0_30.range, arg0_30.rangeAbs, arg0_30.dragDirect))
		end
	end

	arg0_30._parameterUpdateFlag = true
end

function var0_0.updateGyro(arg0_31)
	if not arg0_31.gyro then
		return
	end

	if not Input.gyro.enabled then
		arg0_31:setTargetValue(0)

		arg0_31._parameterUpdateFlag = true

		return
	end

	local var0_31 = Input.gyro and Input.gyro.attitude or Vector3.zero
	local var1_31 = 0

	if arg0_31.gyroX and not math.isnan(var0_31.y) then
		var1_31 = Mathf.Clamp(var0_31.y * arg0_31.sensitive, -0.5, 0.5)
	elseif arg0_31.gyroY and not math.isnan(var0_31.x) then
		var1_31 = Mathf.Clamp(var0_31.x * arg0_31.sensitive, -0.5, 0.5)
	elseif arg0_31.gyroZ and not math.isnan(var0_31.z) then
		var1_31 = Mathf.Clamp(var0_31.z * arg0_31.sensitive, -0.5, 0.5)
	end

	if IsUnityEditor then
		if L2D_USE_RANDOM_ATTI then
			if arg0_31.randomAttitudeIndex == 0 then
				var1_31 = math.random() - 0.5

				local var2_31 = (var1_31 + 0.5) * (arg0_31.range[2] - arg0_31.range[1]) + arg0_31.range[1]

				arg0_31:setTargetValue(var2_31)

				arg0_31.randomAttitudeIndex = L2D_RANDOM_PARAM
			elseif arg0_31.randomAttitudeIndex > 0 then
				arg0_31.randomAttitudeIndex = arg0_31.randomAttitudeIndex - 1
			end
		end
	else
		local var3_31 = (var1_31 + 0.5) * (arg0_31.range[2] - arg0_31.range[1]) + arg0_31.range[1]

		arg0_31:setTargetValue(var3_31)
	end

	arg0_31._parameterUpdateFlag = true
end

function var0_0.updateReactValue(arg0_32)
	if not arg0_32.reactX and not arg0_32.reactY then
		return
	end

	local var0_32
	local var1_32 = false

	if arg0_32.l2dIgnoreReact then
		var0_32 = arg0_32.parameterTargetValue
	elseif arg0_32.reactX then
		var0_32 = arg0_32.reactPos.x * arg0_32.reactX
		var1_32 = true
	else
		var0_32 = arg0_32.reactPos.y * arg0_32.reactY
		var1_32 = true
	end

	if var1_32 then
		arg0_32:setTargetValue(arg0_32:fixParameterTargetValue(var0_32, arg0_32.range, arg0_32.rangeAbs, arg0_32.dragDirect))
	end

	arg0_32._parameterUpdateFlag = true
end

function var0_0.updateParameterValue(arg0_33)
	if arg0_33.prepareTargetValue and not arg0_33.l2dIsPlaying then
		arg0_33:setTargetValue(arg0_33.prepareTargetValue)

		arg0_33.prepareTargetValue = nil
	end

	if arg0_33._parameterUpdateFlag and arg0_33.parameterValue ~= arg0_33.parameterTargetValue then
		if math.abs(arg0_33.parameterValue - arg0_33.parameterTargetValue) < 0.01 then
			arg0_33:setParameterValue(arg0_33.parameterTargetValue)
		elseif arg0_33.parameterSmoothTime and arg0_33.parameterSmoothTime > 0 then
			local var0_33, var1_33 = Mathf.SmoothDamp(arg0_33.parameterValue, arg0_33.parameterTargetValue, arg0_33.parameterSmooth, arg0_33.parameterSmoothTime)

			arg0_33:setParameterValue(var0_33, var1_33)
		else
			arg0_33:setParameterValue(arg0_33.parameterTargetValue, 0)
		end
	end
end

function var0_0.updateRelationValue(arg0_34)
	for iter0_34, iter1_34 in ipairs(arg0_34._relationParameterList) do
		local var0_34 = iter1_34.data
		local var1_34 = var0_34.type
		local var2_34 = var0_34.relation_value
		local var3_34 = var0_34.target
		local var4_34
		local var5_34

		if var1_34 == Live2D.relation_type_drag_x then
			var4_34 = arg0_34.offsetDragX or iter1_34.start or arg0_34.startValue or 0
			var5_34 = true
		elseif var1_34 == Live2D.relation_type_drag_y then
			var4_34 = arg0_34.offsetDragY or iter1_34.start or arg0_34.startValue or 0
			var5_34 = true
		elseif var1_34 == Live2D.relation_type_action_index then
			var4_34 = var2_34[arg0_34.actionListIndex]
			var4_34 = var4_34 or 0
			var5_34 = true
		elseif var1_34 == Live2D.relation_type_idle then
			if arg0_34.loadL2dStep and arg0_34.l2dIdleIndex == var0_34.idle then
				var5_34 = true
			end

			if arg0_34.l2dIsPlaying then
				if arg0_34.l2dPlayActionName == arg0_34.actionTrigger.action then
					arg0_34.relationActive = true
				end
			else
				arg0_34.relationActive = false
				arg0_34.relationCountTime = nil
			end

			if not var5_34 and arg0_34.relationActive and arg0_34.l2dIdleIndex == var0_34.idle then
				if not arg0_34.relationCountTime then
					arg0_34.relationCountTime = Time.GetTimestamp() + var0_34.time
				end

				if arg0_34.relationCountTime and Time.GetTimestamp() >= arg0_34.relationCountTime then
					var5_34 = true
				end
			end
		else
			var4_34 = arg0_34.parameterTargetValue
			var5_34 = false
		end

		local var6_34
		local var7_34

		if var3_34 then
			var6_34 = var3_34
		else
			local var8_34 = arg0_34:fixRelationParameter(var4_34, var0_34)
			local var9_34 = iter1_34.value or arg0_34.startValue
			local var10_34 = iter1_34.parameterSmooth or 0
			local var11_34 = var0_34.smooth and var0_34.smooth / 1000 or arg0_34.smooth

			var6_34, var7_34 = Mathf.SmoothDamp(var9_34, var8_34, var10_34, var11_34)
		end

		iter1_34.value = var6_34
		iter1_34.parameterSmooth = var7_34
		iter1_34.enable = var5_34
		iter1_34.comId = arg0_34.id
	end
end

function var0_0.fixRelationParameter(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg2_35.range or arg0_35.range
	local var1_35 = arg2_35.rangeAbs and arg2_35.rangeAbs == 1 or arg0_35.rangeAbs
	local var2_35 = arg2_35.drag_direct and arg2_35.drag_direct or arg0_35.dragDirect

	return arg0_35:fixParameterTargetValue(arg1_35, var0_35, var1_35, var2_35)
end

function var0_0.fixParameterTargetValue(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	if arg1_36 < 0 and arg4_36 == 1 then
		arg1_36 = 0
	elseif arg1_36 > 0 and arg4_36 == 2 then
		arg1_36 = 0
	end

	arg1_36 = arg3_36 and math.abs(arg1_36) or arg1_36

	if arg1_36 < arg2_36[1] then
		arg1_36 = arg2_36[1]
	elseif arg1_36 > arg2_36[2] then
		arg1_36 = arg2_36[2]
	end

	return arg1_36
end

function var0_0.checkReset(arg0_37)
	if not arg0_37._active and arg0_37.parameterToStart then
		if arg0_37.parameterToStart > 0 then
			arg0_37.parameterToStart = arg0_37.parameterToStart - Time.deltaTime
		end

		if arg0_37.parameterToStart <= 0 then
			arg0_37:setTargetValue(arg0_37.startValue)

			arg0_37.parameterToStart = nil

			if arg0_37.revertResetFlag then
				arg0_37:setTriggerActionFlag(false)

				arg0_37.revertResetFlag = false
			end

			if arg0_37.offsetDragX then
				arg0_37.offsetDragX = arg0_37.startValue
				arg0_37.offsetDragTargetX = arg0_37.startValue
			end

			if arg0_37.offsetDragY then
				arg0_37.offsetDragY = arg0_37.startValue
				arg0_37.offsetDragTargetY = arg0_37.startValue
			end
		end
	end
end

function var0_0.changeReactValue(arg0_38, arg1_38)
	arg0_38.reactPos = arg1_38
end

function var0_0.setParameterValue(arg0_39, arg1_39, arg2_39)
	if arg1_39 then
		arg0_39.parameterValue = arg1_39
	end

	if arg2_39 then
		arg0_39.parameterSmooth = arg2_39
	end
end

function var0_0.updateState(arg0_40)
	if not arg0_40.lastFrameActive and arg0_40._active then
		arg0_40.firstActive = true
	else
		arg0_40.firstActive = false
	end

	if arg0_40.lastFrameActive and not arg0_40._active then
		arg0_40.firstStop = true
	else
		arg0_40.firstStop = false
	end

	arg0_40.lastFrameActive = arg0_40._active
end

function var0_0.updateTrigger(arg0_41)
	if not arg0_41:isActionTriggerAble() then
		return
	end

	local var0_41 = arg0_41.actionTrigger.type
	local var1_41 = arg0_41.actionTrigger.action
	local var2_41

	if arg0_41.actionTrigger.time then
		var2_41 = arg0_41.actionTrigger.time
	elseif arg0_41.actionTrigger.action_list and arg0_41.actionListIndex > 0 then
		var2_41 = arg0_41.actionTrigger.action_list[arg0_41.actionListIndex].time
	end

	local var3_41

	if arg0_41.actionTrigger.num then
		var3_41 = arg0_41.actionTrigger.num
	elseif arg0_41.actionTrigger.action_list and arg0_41.actionTrigger.action_list[arg0_41.actionListIndex].num and arg0_41.actionListIndex > 0 then
		var3_41 = arg0_41.actionTrigger.action_list[arg0_41.actionListIndex].num
	end

	if var0_41 == Live2D.DRAG_TIME_ACTION then
		if arg0_41._active then
			if math.abs(arg0_41.parameterValue - var3_41) < math.abs(var3_41) * 0.25 then
				arg0_41.triggerActionTime = arg0_41.triggerActionTime + Time.deltaTime

				if var2_41 < arg0_41.triggerActionTime and not arg0_41.l2dIsPlaying then
					arg0_41:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_42)
						if arg0_42 then
							arg0_41:onEventNotice(Live2D.ON_ACTION_DRAG_TRIGGER)
						end
					end)
				end
			else
				arg0_41.triggerActionTime = arg0_41.triggerActionTime + 0
			end
		end
	elseif var0_41 == Live2D.DRAG_CLICK_ACTION then
		if arg0_41:checkClickAction() then
			arg0_41:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_43)
				if arg0_43 then
					arg0_41:onEventNotice(Live2D.ON_ACTION_DRAG_CLICK)
				end
			end)
		end
	elseif var0_41 == Live2D.DRAG_DOWN_ACTION then
		if arg0_41._active then
			arg0_41:setAbleWithFlag(true)

			if var2_41 <= Time.time - arg0_41.mouseInputDownTime then
				print("触发按压动作")
				arg0_41:setAbleWithFlag(false)
				arg0_41:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_44)
					if arg0_44 then
						arg0_41:onEventNotice(Live2D.ON_ACTION_DOWN)
					end
				end)

				if arg0_41.actionListIndex ~= 1 then
					arg0_41:setTriggerActionFlag(false)
				end

				arg0_41:setAbleWithFlag(true)

				arg0_41.mouseInputDownTime = Time.time
			end
		elseif arg0_41.actionTrigger.last and arg0_41.actionListIndex ~= 1 then
			arg0_41.actionListIndex = #arg0_41.actionTrigger.action_list

			arg0_41:setAbleWithFlag(false)
			arg0_41:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_45)
				return
			end)
			arg0_41:resetNextTriggerTime()
			arg0_41:setTriggerActionFlag(false)
		else
			arg0_41:setAbleWithFlag(false)
		end
	elseif var0_41 == Live2D.DRAG_RELATION_XY then
		if arg0_41._active then
			local var4_41 = arg0_41:fixParameterTargetValue(arg0_41.offsetDragX, arg0_41.range, arg0_41.rangeAbs, arg0_41.dragDirect)
			local var5_41 = arg0_41:fixParameterTargetValue(arg0_41.offsetDragY, arg0_41.range, arg0_41.rangeAbs, arg0_41.dragDirect)
			local var6_41 = var3_41[1]
			local var7_41 = var3_41[2]

			if math.abs(var4_41 - var6_41) < math.abs(var6_41) * 0.25 and math.abs(var5_41 - var7_41) < math.abs(var7_41) * 0.25 then
				arg0_41.triggerActionTime = arg0_41.triggerActionTime + Time.deltaTime

				if var2_41 < arg0_41.triggerActionTime and not arg0_41.l2dIsPlaying then
					arg0_41:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_46)
						if arg0_46 then
							arg0_41:onEventNotice(Live2D.ON_ACTION_XY_TRIGGER)
						end
					end)
				end
			else
				arg0_41.triggerActionTime = arg0_41.triggerActionTime + 0
			end
		end
	elseif var0_41 == Live2D.DRAG_RELATION_IDLE then
		if arg0_41.actionTrigger.const_fit then
			for iter0_41 = 1, #arg0_41.actionTrigger.const_fit do
				local var8_41 = arg0_41.actionTrigger.const_fit[iter0_41]

				if arg0_41.l2dIdleIndex == var8_41.idle and not arg0_41.l2dIsPlaying then
					arg0_41:setTargetValue(var8_41.target)
				end
			end
		end
	elseif var0_41 == Live2D.DRAG_CLICK_MANY then
		if arg0_41:checkClickAction() then
			arg0_41:onEventCallback(Live2D.EVENT_ACTION_APPLY)
		end
	elseif var0_41 == Live2D.DRAG_LISTENER_EVENT then
		if arg0_41._listenerTrigger then
			arg0_41:onEventCallback(Live2D.EVENT_ACTION_APPLY)
		end
	elseif var0_41 == Live2D.DRAG_DOWN_TOUCH then
		arg0_41:setAbleWithFlag(arg0_41._active)

		if arg0_41._active then
			local var9_41 = Time.deltaTime / arg0_41.actionTrigger.delta
			local var10_41 = arg0_41.parameterTargetValue + var9_41
			local var11_41 = arg0_41:fixParameterTargetValue(var10_41, arg0_41.range, arg0_41.rangeAbs, arg0_41.dragDirect)

			arg0_41:setTargetValue(var11_41)
		end
	elseif var0_41 == Live2D.DRAG_CLICK_PARAMETER and arg0_41:checkClickAction() then
		local var12_41 = var3_41
		local var13_41 = arg0_41.actionTrigger.parameter

		arg0_41:onEventCallback(Live2D.EVENT_GET_PARAMETER, {
			name = var13_41
		}, function(arg0_47)
			if math.abs(var12_41 - arg0_47) <= 0.05 then
				print("数值允许播放，开始执行动作 " .. arg0_41.actionTrigger.action)
				arg0_41:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_48)
					if arg0_48 then
						arg0_41:onEventNotice(Live2D.ON_ACTION_DRAG_CLICK)
					end
				end)
			end
		end)
	end
end

function var0_0.setAbleWithFlag(arg0_49, arg1_49)
	if arg0_49.ableFlag ~= arg1_49 then
		arg0_49.ableFlag = arg1_49

		arg0_49:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
			ableFlag = arg1_49
		})
	end
end

function var0_0.triggerAction(arg0_50)
	arg0_50.nextTriggerTime = arg0_50.limitTime

	arg0_50:setTriggerActionFlag(true)
end

function var0_0.isActionTriggerAble(arg0_51)
	if arg0_51.actionTrigger.type == nil then
		return false
	end

	if not arg0_51.actionTrigger or arg0_51.actionTrigger == "" then
		return false
	end

	if arg0_51.nextTriggerTime - Time.deltaTime >= 0 then
		arg0_51.nextTriggerTime = arg0_51.nextTriggerTime - Time.deltaTime

		return false
	end

	if arg0_51.isTriggerAtion then
		return false
	end

	return true
end

function var0_0.updateStateData(arg0_52, arg1_52)
	if arg0_52.l2dIdleIndex ~= arg1_52.idleIndex then
		if type(arg0_52.revertIdleIndex) == "boolean" and arg0_52.revertIdleIndex == true then
			arg0_52:setTargetValue(arg0_52.startValue)
		elseif type(arg0_52.revertIdleIndex) == "table" and table.contains(arg0_52.revertIdleIndex, arg1_52.idleIndex) then
			arg0_52:setTargetValue(arg0_52.startValue)
		end
	end

	arg0_52.lastActionIndex = arg0_52.actionListIndex

	if arg1_52.isPlaying and arg0_52.actionTrigger.reset_index_action and arg1_52.actionName and table.contains(arg0_52.actionTrigger.reset_index_action, arg1_52.actionName) then
		arg0_52.actionListIndex = 1
	end

	if arg0_52.revertActionIndex and arg0_52.lastActionIndex ~= arg0_52.actionListIndex then
		arg0_52:setTargetValue(arg0_52.startValue)
	end

	arg0_52.l2dIdleIndex = arg1_52.idleIndex
	arg0_52.l2dIsPlaying = arg1_52.isPlaying
	arg0_52.l2dIgnoreReact = arg1_52.ignoreReact
	arg0_52.l2dPlayActionName = arg1_52.actionName

	if not arg0_52.l2dIsPlaying and arg0_52.isTriggerAtion then
		arg0_52:setTriggerActionFlag(false)
	end

	if arg0_52.l2dIdleIndex and arg0_52.idleOn and #arg0_52.idleOn > 0 then
		arg0_52.reactConditionFlag = not table.contains(arg0_52.idleOn, arg0_52.l2dIdleIndex)
	end

	if arg0_52.l2dIdleIndex and arg0_52.idleOff and #arg0_52.idleOff > 0 then
		arg0_52.reactConditionFlag = table.contains(arg0_52.idleOff, arg0_52.l2dIdleIndex)
	end
end

function var0_0.checkClickAction(arg0_53)
	if arg0_53.firstActive then
		arg0_53:setAbleWithFlag(true)
	elseif arg0_53.firstStop then
		local var0_53 = math.abs(arg0_53.mouseInputUp.x - arg0_53.mouseInputDown.x) < 30 and math.abs(arg0_53.mouseInputUp.y - arg0_53.mouseInputDown.y) < 30
		local var1_53 = arg0_53.mouseInputUpTime - arg0_53.mouseInputDownTime < 0.5

		if var0_53 and var1_53 and not arg0_53.l2dIsPlaying then
			arg0_53.clickTriggerTime = 0.01
			arg0_53.clickApplyFlag = true
		else
			arg0_53:setAbleWithFlag(false)
		end
	elseif arg0_53.clickTriggerTime and arg0_53.clickTriggerTime > 0 then
		arg0_53.clickTriggerTime = arg0_53.clickTriggerTime - Time.deltaTime

		if arg0_53.clickTriggerTime <= 0 then
			arg0_53.clickTriggerTime = nil

			arg0_53:setAbleWithFlag(false)

			if arg0_53.clickApplyFlag then
				arg0_53.clickApplyFlag = false

				return true
			end
		end
	end

	return false
end

function var0_0.saveData(arg0_54)
	if arg0_54.revert == -1 and arg0_54.saveParameterFlag then
		Live2dConst.SaveDragData(arg0_54.id, arg0_54.live2dData:GetShipSkinConfig().id, arg0_54.live2dData.ship.id, arg0_54.parameterTargetValue)
	end

	if arg0_54.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		print("保存actionListIndex" .. arg0_54.actionListIndex)
		Live2dConst.SetDragActionIndex(arg0_54.id, arg0_54.live2dData:GetShipSkinConfig().id, arg0_54.live2dData.ship.id, arg0_54.actionListIndex)
	end
end

function var0_0.loadData(arg0_55)
	if arg0_55.revert == -1 and arg0_55.saveParameterFlag then
		local var0_55 = Live2dConst.GetDragData(arg0_55.id, arg0_55.live2dData:GetShipSkinConfig().id, arg0_55.live2dData.ship.id)

		if var0_55 then
			arg0_55:setParameterValue(var0_55)
			arg0_55:setTargetValue(var0_55)
		end
	end

	if arg0_55.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		arg0_55.actionListIndex = Live2dConst.GetDragActionIndex(arg0_55.id, arg0_55.live2dData:GetShipSkinConfig().id, arg0_55.live2dData.ship.id) or 1
	end
end

function var0_0.loadL2dFinal(arg0_56)
	arg0_56.loadL2dStep = true
end

function var0_0.clearData(arg0_57)
	if arg0_57.revert == -1 then
		arg0_57.actionListIndex = 1

		arg0_57:setParameterValue(arg0_57.startValue)
		arg0_57:setTargetValue(arg0_57.startValue)
	end
end

function var0_0.setTriggerActionFlag(arg0_58, arg1_58)
	arg0_58.isTriggerAtion = arg1_58
end

function var0_0.dispose(arg0_59)
	arg0_59._active = false
	arg0_59._parameterCom = nil
	arg0_59.parameterValue = arg0_59.startValue
	arg0_59.parameterTargetValue = 0
	arg0_59.parameterSmooth = 0
	arg0_59.mouseInputDown = Vector2(0, 0)
	arg0_59.live2dData = nil
end

return var0_0
