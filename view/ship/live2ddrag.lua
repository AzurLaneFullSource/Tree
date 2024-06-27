local var0_0 = class("Live2dDrag")
local var1_0 = 4

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
	arg0_1.limitTime = arg1_1.limit_time > 0 and arg1_1.limit_time or var1_0
	arg0_1.listenerData = arg1_1.listener_data
	arg0_1.listenerType = arg0_1.listenerData.type
	arg0_1.listenerChange = arg0_1.listenerData.change
	arg0_1.listenerApply = arg0_1.listenerData.apply
	arg0_1.reactCondition = arg1_1.react_condition and arg1_1.react_condition ~= "" and arg1_1.react_condition or {}
	arg0_1.idleOn = arg0_1.reactCondition.idle_on and arg0_1.reactCondition.idle_on or {}
	arg0_1.idleOff = arg0_1.reactCondition.idleOff and arg0_1.reactCondition.idleOff or {}
	arg0_1.revertIdleIndex = arg1_1.revert_idle_index == 1 and true or false
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
					local var12_2 = var8_2[4]

					if table.contains(var10_2, var7_2) then
						local var13_2

						if var9_2 == 1 then
							var13_2 = arg0_2.parameterTargetValue + var11_2
						elseif var9_2 == 2 then
							var13_2 = var11_2
						end

						if var13_2 then
							var6_2 = true

							local var14_2 = arg0_2:fixParameterTargetValue(var13_2, arg0_2.range, arg0_2.rangeAbs, arg0_2.dragDirect)

							arg0_2:setTargetValue(var14_2)
							arg0_2:setParameterValue(var14_2)
							print("数值变更为" .. arg0_2.parameterTargetValue)
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

		print("激活，id=" .. arg0_4.id)

		arg0_4.mouseInputDown = Input.mousePosition
		arg0_4.mouseInputDownTime = Time.time
		arg0_4.triggerActionTime = 0

		if arg0_4.actionTrigger.type == Live2D.DRAG_DOWN_ACTION then
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

		if type(arg0_5.partsData) == "table" then
			local var0_5 = arg0_5.partsData.parts

			if arg0_5.offsetX or arg0_5.offsetY then
				local var1_5 = arg0_5.parameterTargetValue
				local var2_5
				local var3_5

				for iter0_5 = 1, #var0_5 do
					local var4_5 = var0_5[iter0_5]
					local var5_5 = math.abs(var1_5 - var4_5)

					if not var2_5 or var5_5 < var2_5 then
						var2_5 = var5_5
						var3_5 = iter0_5
					end
				end

				if var3_5 then
					arg0_5:setTargetValue(var0_5[var3_5])
				end
			end
		end

		arg0_5.mouseInputUp = Input.mousePosition
		arg0_5.mouseInputUpTime = Time.time

		arg0_5:saveData()
	end
end

function var0_0.getIgnoreReact(arg0_6)
	return arg0_6.ignoreReact
end

function var0_0.setParameterCom(arg0_7, arg1_7)
	if not arg1_7 then
		print("live2dDrag id:" .. tostring(arg0_7.id) .. "设置了null的组件(该打印非报错)")
	end

	arg0_7._parameterCom = arg1_7
end

function var0_0.getParameterCom(arg0_8)
	return arg0_8._parameterCom
end

function var0_0.addRelationComData(arg0_9, arg1_9, arg2_9)
	table.insert(arg0_9._relationParameterList, {
		com = arg1_9,
		data = arg2_9
	})
end

function var0_0.getRelationParameterList(arg0_10)
	return arg0_10._relationParameterList
end

function var0_0.getReactCondition(arg0_11)
	return arg0_11.reactConditionFlag
end

function var0_0.getActive(arg0_12)
	return arg0_12._active
end

function var0_0.getParameterUpdateFlag(arg0_13)
	return arg0_13._parameterUpdateFlag
end

function var0_0.setEventCallback(arg0_14, arg1_14)
	arg0_14._eventCallback = arg1_14
end

function var0_0.onEventCallback(arg0_15, arg1_15, arg2_15, arg3_15)
	if arg1_15 == Live2D.EVENT_ACTION_APPLY then
		local var0_15 = {}
		local var1_15
		local var2_15 = false
		local var3_15
		local var4_15
		local var5_15

		if arg0_15.actionTrigger.action then
			var1_15 = arg0_15:fillterAction(arg0_15.actionTrigger.action)
			var0_15 = arg0_15.actionTriggerActive
			var2_15 = arg0_15.actionTrigger.focus or false
			var3_15 = arg0_15.actionTrigger.target or nil

			if (arg0_15.actionTrigger.circle or nil) and var3_15 and var3_15 == arg0_15.parameterTargetValue then
				var3_15 = arg0_15.startValue
			end

			var4_15 = arg0_15.actionTrigger.react or nil

			arg0_15:triggerAction()
			arg0_15:stopDrag()
		elseif arg0_15.actionTrigger.action_list then
			local var6_15 = arg0_15.actionTrigger.action_list[arg0_15.actionListIndex]

			var1_15 = arg0_15:fillterAction(var6_15.action)

			if arg0_15.actionTriggerActive.active_list and arg0_15.actionListIndex <= #arg0_15.actionTriggerActive.active_list then
				var0_15 = arg0_15.actionTriggerActive.active_list[arg0_15.actionListIndex]
			end

			var2_15 = var6_15.focus or true
			var3_15 = var6_15.target or nil
			var4_15 = var6_15.react or nil

			if arg0_15.actionListIndex == #arg0_15.actionTrigger.action_list then
				arg0_15:triggerAction()
				arg0_15:stopDrag()

				arg0_15.actionListIndex = 1
			else
				arg0_15.actionListIndex = arg0_15.actionListIndex + 1
			end

			print("id = " .. arg0_15.id .. " action list index = " .. arg0_15.actionListIndex)
		elseif not arg0_15.actionTrigger.action then
			var1_15 = arg0_15:fillterAction(arg0_15.actionTrigger.action)
			var0_15 = arg0_15.actionTriggerActive
			var2_15 = arg0_15.actionTrigger.focus or false
			var3_15 = arg0_15.actionTrigger.target or nil

			if (arg0_15.actionTrigger.circle or nil) and var3_15 and var3_15 == arg0_15.parameterTargetValue then
				var3_15 = arg0_15.startValue
			end

			var4_15 = arg0_15.actionTrigger.react or nil

			arg0_15:triggerAction()
			arg0_15:stopDrag()
		end

		if var0_15.idle then
			if type(var0_15.idle) == "number" then
				if var0_15.idle == arg0_15.l2dIdleIndex and not var0_15.repeatFlag then
					return
				end
			elseif type(var0_15.idle) == "table" and #var0_15.idle == 1 and var0_15.idle[1] == arg0_15.l2dIdleIndex and not var0_15.repeatFlag then
				return
			end
		end

		if var3_15 then
			arg0_15:setTargetValue(var3_15)

			if not var1_15 then
				arg0_15.revertResetFlag = true
			end
		end

		arg2_15 = {
			id = arg0_15.id,
			action = var1_15,
			activeData = var0_15,
			focus = var2_15,
			react = var4_15,
			callback = arg3_15,
			finishCall = function()
				arg0_15:actionApplyFinish()
			end
		}
	elseif arg1_15 == Live2D.EVENT_ACTION_ABLE then
		-- block empty
	elseif arg1_15 == Live2D.EVENT_CHANGE_IDLE_INDEX then
		print("CHANGE idle")
	end

	arg0_15._eventCallback(arg1_15, arg2_15)
end

function var0_0.fillterAction(arg0_17, arg1_17)
	if type(arg1_17) == "table" then
		return arg1_17[math.random(1, #arg0_17.actionTrigger.action)]
	else
		return arg1_17
	end
end

function var0_0.onEventNotice(arg0_18, arg1_18)
	if arg0_18._eventCallback then
		local var0_18 = arg0_18:getCommonNoticeData()

		arg0_18._eventCallback(arg1_18, var0_18)
	end
end

function var0_0.getCommonNoticeData(arg0_19)
	return {
		draw_able_name = arg0_19.drawAbleName,
		parameter_name = arg0_19.parameterName,
		parameter_target = arg0_19.parameterTargetValue
	}
end

function var0_0.setTargetValue(arg0_20, arg1_20)
	arg0_20.parameterTargetValue = arg1_20
end

function var0_0.getParameter(arg0_21)
	return arg0_21.parameterValue
end

function var0_0.getParameToTargetFlag(arg0_22)
	if arg0_22.parameterValue ~= arg0_22.parameterTargetValue then
		return true
	end

	if arg0_22.parameterToStart and arg0_22.parameterToStart > 0 then
		return true
	end

	return false
end

function var0_0.actionApplyFinish(arg0_23)
	return
end

function var0_0.stepParameter(arg0_24)
	arg0_24:updateState()
	arg0_24:updateTrigger()
	arg0_24:updateParameterUpdateFlag()
	arg0_24:updateGyro()
	arg0_24:updateDrag()
	arg0_24:updateReactValue()
	arg0_24:updateParameterValue()
	arg0_24:updateRelationValue()
	arg0_24:checkReset()
end

function var0_0.updateParameterUpdateFlag(arg0_25)
	if arg0_25.actionTrigger.type == Live2D.DRAG_CLICK_ACTION then
		arg0_25._parameterUpdateFlag = true
	elseif arg0_25.actionTrigger.type == Live2D.DRAG_RELATION_IDLE then
		if not arg0_25._parameterUpdateFlag then
			if not arg0_25.l2dIsPlaying then
				arg0_25._parameterUpdateFlag = true

				arg0_25:changeParameComAble(true)
			elseif not table.contains(arg0_25.actionTrigger.remove_com_list, arg0_25.l2dPlayActionName) then
				arg0_25._parameterUpdateFlag = true

				arg0_25:changeParameComAble(true)
			end
		elseif arg0_25._parameterUpdateFlag == true and arg0_25.l2dIsPlaying and table.contains(arg0_25.actionTrigger.remove_com_list, arg0_25.l2dPlayActionName) then
			arg0_25._parameterUpdateFlag = false

			arg0_25:changeParameComAble(false)
		end
	else
		arg0_25._parameterUpdateFlag = false
	end
end

function var0_0.changeParameComAble(arg0_26, arg1_26)
	if arg0_26.parameterComAdd == arg1_26 then
		return
	end

	arg0_26.parameterComAdd = arg1_26

	if arg1_26 then
		arg0_26:onEventCallback(Live2D.EVENT_ADD_PARAMETER_COM, {
			com = arg0_26._parameterCom,
			start = arg0_26.startValue,
			mode = arg0_26.mode
		})
	else
		arg0_26:onEventCallback(Live2D.EVENT_REMOVE_PARAMETER_COM, {
			com = arg0_26._parameterCom,
			mode = arg0_26.mode
		})
	end
end

function var0_0.updateDrag(arg0_27)
	if not arg0_27.offsetX and not arg0_27.offsetY then
		return
	end

	local var0_27

	if arg0_27._active then
		local var1_27 = Input.mousePosition

		if arg0_27.offsetX and arg0_27.offsetX ~= 0 then
			local var2_27 = var1_27.x - arg0_27.mouseInputDown.x

			var0_27 = arg0_27.offsetDragTargetX + var2_27 / arg0_27.offsetX
			arg0_27.offsetDragX = var0_27
		end

		if arg0_27.offsetY and arg0_27.offsetY ~= 0 then
			local var3_27 = var1_27.y - arg0_27.mouseInputDown.y

			var0_27 = arg0_27.offsetDragTargetY + var3_27 / arg0_27.offsetY
			arg0_27.offsetDragY = var0_27
		end

		if var0_27 then
			arg0_27:setTargetValue(arg0_27:fixParameterTargetValue(var0_27, arg0_27.range, arg0_27.rangeAbs, arg0_27.dragDirect))
		end
	end

	arg0_27._parameterUpdateFlag = true
end

function var0_0.updateGyro(arg0_28)
	if not arg0_28.gyro then
		return
	end

	if not Input.gyro.enabled then
		arg0_28:setTargetValue(0)

		arg0_28._parameterUpdateFlag = true

		return
	end

	local var0_28 = Input.gyro and Input.gyro.attitude or Vector3.zero
	local var1_28 = 0

	if arg0_28.gyroX and not math.isnan(var0_28.y) then
		var1_28 = Mathf.Clamp(var0_28.y * arg0_28.sensitive, -0.5, 0.5)
	elseif arg0_28.gyroY and not math.isnan(var0_28.x) then
		var1_28 = Mathf.Clamp(var0_28.x * arg0_28.sensitive, -0.5, 0.5)
	elseif arg0_28.gyroZ and not math.isnan(var0_28.z) then
		var1_28 = Mathf.Clamp(var0_28.z * arg0_28.sensitive, -0.5, 0.5)
	end

	if IsUnityEditor then
		if L2D_USE_RANDOM_ATTI then
			if arg0_28.randomAttitudeIndex == 0 then
				var1_28 = math.random() - 0.5

				local var2_28 = (var1_28 + 0.5) * (arg0_28.range[2] - arg0_28.range[1]) + arg0_28.range[1]

				arg0_28:setTargetValue(var2_28)

				arg0_28.randomAttitudeIndex = L2D_RANDOM_PARAM
			elseif arg0_28.randomAttitudeIndex > 0 then
				arg0_28.randomAttitudeIndex = arg0_28.randomAttitudeIndex - 1
			end
		end
	else
		local var3_28 = (var1_28 + 0.5) * (arg0_28.range[2] - arg0_28.range[1]) + arg0_28.range[1]

		arg0_28:setTargetValue(var3_28)
	end

	arg0_28._parameterUpdateFlag = true
end

function var0_0.updateReactValue(arg0_29)
	if not arg0_29.reactX and not arg0_29.reactY then
		return
	end

	local var0_29
	local var1_29 = false

	if arg0_29.l2dIgnoreReact then
		var0_29 = arg0_29.parameterTargetValue
	elseif arg0_29.reactX then
		var0_29 = arg0_29.reactPos.x * arg0_29.reactX
		var1_29 = true
	else
		var0_29 = arg0_29.reactPos.y * arg0_29.reactY
		var1_29 = true
	end

	if var1_29 then
		arg0_29:setTargetValue(arg0_29:fixParameterTargetValue(var0_29, arg0_29.range, arg0_29.rangeAbs, arg0_29.dragDirect))
	end

	arg0_29._parameterUpdateFlag = true
end

function var0_0.updateParameterValue(arg0_30)
	if arg0_30._parameterUpdateFlag and arg0_30.parameterValue ~= arg0_30.parameterTargetValue then
		if math.abs(arg0_30.parameterValue - arg0_30.parameterTargetValue) < 0.01 then
			arg0_30:setParameterValue(arg0_30.parameterTargetValue)
		elseif arg0_30.parameterSmoothTime and arg0_30.parameterSmoothTime > 0 then
			local var0_30, var1_30 = Mathf.SmoothDamp(arg0_30.parameterValue, arg0_30.parameterTargetValue, arg0_30.parameterSmooth, arg0_30.parameterSmoothTime)

			arg0_30:setParameterValue(var0_30, var1_30)
		else
			arg0_30:setParameterValue(arg0_30.parameterTargetValue, 0)
		end
	end
end

function var0_0.updateRelationValue(arg0_31)
	for iter0_31, iter1_31 in ipairs(arg0_31._relationParameterList) do
		local var0_31 = iter1_31.data
		local var1_31 = var0_31.type
		local var2_31 = var0_31.relation_value
		local var3_31
		local var4_31
		local var5_31

		if var1_31 == Live2D.relation_type_drag_x then
			var3_31 = arg0_31.offsetDragX or iter1_31.start or arg0_31.startValue or 0
			var5_31 = true
		elseif var1_31 == Live2D.relation_type_drag_y then
			var3_31 = arg0_31.offsetDragY or iter1_31.start or arg0_31.startValue or 0
			var5_31 = true
		elseif var1_31 == Live2D.relation_type_action_index then
			var3_31 = var2_31[arg0_31.actionListIndex]
			var3_31 = var3_31 or 0
			var5_31 = true
		else
			var3_31 = arg0_31.parameterTargetValue
			var5_31 = false
		end

		local var6_31 = iter1_31.value or arg0_31.startValue
		local var7_31 = arg0_31:fixRelationParameter(var3_31, var0_31)
		local var8_31 = iter1_31.parameterSmooth or 0
		local var9_31 = var0_31.smooth and var0_31.smooth / 1000 or arg0_31.smooth
		local var10_31, var11_31 = Mathf.SmoothDamp(var6_31, var7_31, var8_31, var9_31)

		iter1_31.value = var10_31
		iter1_31.parameterSmooth = var11_31
		iter1_31.enable = var5_31
		iter1_31.comId = arg0_31.id
	end
end

function var0_0.fixRelationParameter(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg2_32.range or arg0_32.range
	local var1_32 = arg2_32.rangeAbs and arg2_32.rangeAbs == 1 or arg0_32.rangeAbs
	local var2_32 = arg2_32.drag_direct and arg2_32.drag_direct or arg0_32.dragDirect

	return arg0_32:fixParameterTargetValue(arg1_32, var0_32, var1_32, var2_32)
end

function var0_0.fixParameterTargetValue(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	if arg1_33 < 0 and arg4_33 == 1 then
		arg1_33 = 0
	elseif arg1_33 > 0 and arg4_33 == 2 then
		arg1_33 = 0
	end

	arg1_33 = arg3_33 and math.abs(arg1_33) or arg1_33

	if arg1_33 < arg2_33[1] then
		arg1_33 = arg2_33[1]
	elseif arg1_33 > arg2_33[2] then
		arg1_33 = arg2_33[2]
	end

	return arg1_33
end

function var0_0.checkReset(arg0_34)
	if not arg0_34._active and arg0_34.parameterToStart then
		if arg0_34.parameterToStart > 0 then
			arg0_34.parameterToStart = arg0_34.parameterToStart - Time.deltaTime
		end

		if arg0_34.parameterToStart <= 0 then
			arg0_34:setTargetValue(arg0_34.startValue)

			arg0_34.parameterToStart = nil

			if arg0_34.revertResetFlag then
				arg0_34:setTriggerActionFlag(false)

				arg0_34.revertResetFlag = false
			end

			if arg0_34.offsetDragX then
				arg0_34.offsetDragX = arg0_34.startValue
				arg0_34.offsetDragTargetX = arg0_34.startValue
			end

			if arg0_34.offsetDragY then
				arg0_34.offsetDragY = arg0_34.startValue
				arg0_34.offsetDragTargetY = arg0_34.startValue
			end
		end
	end
end

function var0_0.changeReactValue(arg0_35, arg1_35)
	arg0_35.reactPos = arg1_35
end

function var0_0.setParameterValue(arg0_36, arg1_36, arg2_36)
	if arg1_36 then
		arg0_36.parameterValue = arg1_36
	end

	if arg2_36 then
		arg0_36.parameterSmooth = arg2_36
	end
end

function var0_0.updateState(arg0_37)
	if not arg0_37.lastFrameActive and arg0_37._active then
		arg0_37.firstActive = true
	else
		arg0_37.firstActive = false
	end

	if arg0_37.lastFrameActive and not arg0_37._active then
		arg0_37.firstStop = true
	else
		arg0_37.firstStop = false
	end

	arg0_37.lastFrameActive = arg0_37._active
end

function var0_0.updateTrigger(arg0_38)
	if not arg0_38:isActionTriggerAble() then
		return
	end

	local var0_38 = arg0_38.actionTrigger.type
	local var1_38 = arg0_38.actionTrigger.action
	local var2_38

	if arg0_38.actionTrigger.time then
		var2_38 = arg0_38.actionTrigger.time
	elseif arg0_38.actionTrigger.action_list and arg0_38.actionListIndex > 0 then
		var2_38 = arg0_38.actionTrigger.action_list[arg0_38.actionListIndex].time
	end

	local var3_38

	if arg0_38.actionTrigger.num then
		var3_38 = arg0_38.actionTrigger.num
	elseif arg0_38.actionTrigger.action_list and arg0_38.actionTrigger.action_list[arg0_38.actionListIndex].num and arg0_38.actionListIndex > 0 then
		var3_38 = arg0_38.actionTrigger.action_list[arg0_38.actionListIndex].num
	end

	if var0_38 == Live2D.DRAG_TIME_ACTION then
		if arg0_38._active then
			if math.abs(arg0_38.parameterValue - var3_38) < math.abs(var3_38) * 0.25 then
				arg0_38.triggerActionTime = arg0_38.triggerActionTime + Time.deltaTime

				if var2_38 < arg0_38.triggerActionTime and not arg0_38.l2dIsPlaying then
					arg0_38:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_39)
						if arg0_39 then
							arg0_38:onEventNotice(Live2D.ON_ACTION_DRAG_TRIGGER)
						end
					end)
				end
			else
				arg0_38.triggerActionTime = arg0_38.triggerActionTime + 0
			end
		end
	elseif var0_38 == Live2D.DRAG_CLICK_ACTION then
		if arg0_38:checkClickAction() then
			arg0_38:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_40)
				if arg0_40 then
					arg0_38:onEventNotice(Live2D.ON_ACTION_DRAG_CLICK)
				end
			end)
		end
	elseif var0_38 == Live2D.DRAG_DOWN_ACTION then
		if arg0_38._active then
			if arg0_38.firstActive then
				arg0_38.ableFalg = true

				arg0_38:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
					ableFlag = true
				})
			end

			if var2_38 <= Time.time - arg0_38.mouseInputDownTime then
				arg0_38:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
					ableFlag = false
				})

				arg0_38.ableFalg = false

				arg0_38:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_41)
					if arg0_41 then
						arg0_38:onEventNotice(Live2D.ON_ACTION_DOWN)
					end
				end)

				arg0_38.mouseInputDownTime = Time.time
			end
		elseif arg0_38.ableFalg then
			arg0_38.ableFalg = false

			arg0_38:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
				ableFlag = false
			})
		end
	elseif var0_38 == Live2D.DRAG_RELATION_XY then
		if arg0_38._active then
			local var4_38 = arg0_38:fixParameterTargetValue(arg0_38.offsetDragX, arg0_38.range, arg0_38.rangeAbs, arg0_38.dragDirect)
			local var5_38 = arg0_38:fixParameterTargetValue(arg0_38.offsetDragY, arg0_38.range, arg0_38.rangeAbs, arg0_38.dragDirect)
			local var6_38 = var3_38[1]
			local var7_38 = var3_38[2]

			if math.abs(var4_38 - var6_38) < math.abs(var6_38) * 0.25 and math.abs(var5_38 - var7_38) < math.abs(var7_38) * 0.25 then
				arg0_38.triggerActionTime = arg0_38.triggerActionTime + Time.deltaTime

				if var2_38 < arg0_38.triggerActionTime and not arg0_38.l2dIsPlaying then
					arg0_38:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_42)
						if arg0_42 then
							arg0_38:onEventNotice(Live2D.ON_ACTION_XY_TRIGGER)
						end
					end)
				end
			else
				arg0_38.triggerActionTime = arg0_38.triggerActionTime + 0
			end
		end
	elseif var0_38 == Live2D.DRAG_RELATION_IDLE then
		if arg0_38.actionTrigger.const_fit then
			for iter0_38 = 1, #arg0_38.actionTrigger.const_fit do
				local var8_38 = arg0_38.actionTrigger.const_fit[iter0_38]

				if arg0_38.l2dIdleIndex == var8_38.idle and not arg0_38.l2dIsPlaying then
					arg0_38:setTargetValue(var8_38.target)
				end
			end
		end
	elseif var0_38 == Live2D.DRAG_CLICK_MANY then
		if arg0_38:checkClickAction() then
			arg0_38:onEventCallback(Live2D.EVENT_ACTION_APPLY)
		end
	elseif var0_38 == Live2D.DRAG_LISTENER_EVENT and arg0_38._listenerTrigger then
		arg0_38:onEventCallback(Live2D.EVENT_ACTION_APPLY)
	end
end

function var0_0.triggerAction(arg0_43)
	arg0_43.nextTriggerTime = arg0_43.limitTime

	arg0_43:setTriggerActionFlag(true)
end

function var0_0.isActionTriggerAble(arg0_44)
	if arg0_44.actionTrigger.type == nil then
		return false
	end

	if not arg0_44.actionTrigger or arg0_44.actionTrigger == "" then
		return
	end

	if arg0_44.nextTriggerTime - Time.deltaTime >= 0 then
		arg0_44.nextTriggerTime = arg0_44.nextTriggerTime - Time.deltaTime

		return false
	end

	if arg0_44.isTriggerAtion then
		return false
	end

	return true
end

function var0_0.updateStateData(arg0_45, arg1_45)
	if arg0_45.revertIdleIndex and arg0_45.l2dIdleIndex ~= arg1_45.idleIndex then
		arg0_45:setTargetValue(arg0_45.startValue)
	end

	arg0_45.lastActionIndex = arg0_45.actionListIndex

	if arg1_45.isPlaying and arg0_45.actionTrigger.reset_index_action and arg1_45.actionName and table.contains(arg0_45.actionTrigger.reset_index_action, arg1_45.actionName) then
		arg0_45.actionListIndex = 1
	end

	if arg0_45.revertActionIndex and arg0_45.lastActionIndex ~= arg0_45.actionListIndex then
		arg0_45:setTargetValue(arg0_45.startValue)
	end

	arg0_45.l2dIdleIndex = arg1_45.idleIndex
	arg0_45.l2dIsPlaying = arg1_45.isPlaying
	arg0_45.l2dIgnoreReact = arg1_45.ignoreReact
	arg0_45.l2dPlayActionName = arg1_45.actionName

	if not arg0_45.l2dIsPlaying and arg0_45.isTriggerAtion then
		arg0_45:setTriggerActionFlag(false)
	end

	if arg0_45.l2dIdleIndex and arg0_45.idleOn and #arg0_45.idleOn > 0 then
		arg0_45.reactConditionFlag = table.contains(arg0_45.idleOn, arg0_45.l2dIdleIndex)
	end

	if arg0_45.l2dIdleIndex and arg0_45.idleOff and #arg0_45.idleOff > 0 then
		arg0_45.reactConditionFlag = not table.contains(arg0_45.idleOff, arg0_45.l2dIdleIndex)
	end
end

function var0_0.checkClickAction(arg0_46)
	if arg0_46.firstActive then
		arg0_46:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
			ableFlag = true
		})
	elseif arg0_46.firstStop then
		local var0_46 = math.abs(arg0_46.mouseInputUp.x - arg0_46.mouseInputDown.x) < 30 and math.abs(arg0_46.mouseInputUp.y - arg0_46.mouseInputDown.y) < 30
		local var1_46 = arg0_46.mouseInputUpTime - arg0_46.mouseInputDownTime < 0.5

		if var0_46 and var1_46 and not arg0_46.l2dIsPlaying then
			arg0_46.clickTriggerTime = 0.01
			arg0_46.clickApplyFlag = true
		else
			arg0_46:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
				ableFlag = false
			})
		end
	elseif arg0_46.clickTriggerTime and arg0_46.clickTriggerTime > 0 then
		arg0_46.clickTriggerTime = arg0_46.clickTriggerTime - Time.deltaTime

		if arg0_46.clickTriggerTime <= 0 then
			arg0_46.clickTriggerTime = nil

			arg0_46:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
				ableFlag = false
			})

			if arg0_46.clickApplyFlag then
				arg0_46.clickApplyFlag = false

				return true
			end
		end
	end

	return false
end

function var0_0.saveData(arg0_47)
	if arg0_47.revert == -1 and arg0_47.saveParameterFlag then
		Live2dConst.SaveDragData(arg0_47.id, arg0_47.live2dData:GetShipSkinConfig().id, arg0_47.live2dData.ship.id, arg0_47.parameterTargetValue)
	end

	if arg0_47.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		Live2dConst.SetDragActionIndex(arg0_47.id, arg0_47.live2dData:GetShipSkinConfig().id, arg0_47.live2dData.ship.id, arg0_47.actionListIndex)
	end
end

function var0_0.loadData(arg0_48)
	if arg0_48.revert == -1 and arg0_48.saveParameterFlag then
		local var0_48 = Live2dConst.GetDragData(arg0_48.id, arg0_48.live2dData:GetShipSkinConfig().id, arg0_48.live2dData.ship.id)

		if var0_48 then
			arg0_48:setParameterValue(var0_48)
			arg0_48:setTargetValue(var0_48)
		end
	end

	if arg0_48.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		arg0_48.actionListIndex = Live2dConst.GetDragActionIndex(arg0_48.id, arg0_48.live2dData:GetShipSkinConfig().id, arg0_48.live2dData.ship.id) or 1
	end
end

function var0_0.clearData(arg0_49)
	if arg0_49.revert == -1 then
		arg0_49.actionListIndex = 1

		arg0_49:setParameterValue(arg0_49.startValue)
		arg0_49:setTargetValue(arg0_49.startValue)
	end
end

function var0_0.setTriggerActionFlag(arg0_50, arg1_50)
	arg0_50.isTriggerAtion = arg1_50
end

function var0_0.dispose(arg0_51)
	arg0_51._active = false
	arg0_51._parameterCom = nil
	arg0_51.parameterValue = arg0_51.startValue
	arg0_51.parameterTargetValue = 0
	arg0_51.parameterSmooth = 0
	arg0_51.mouseInputDown = Vector2(0, 0)
	arg0_51.live2dData = nil
end

return var0_0
