local var0_0 = class("Live2dDrag")
local var1_0 = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.live2dData = arg2_1
	arg0_1.frameRate = Application.targetFrameRate or 60
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

function var0_0.startDrag(arg0_2)
	if arg0_2.ignoreAction and arg0_2.l2dIsPlaying then
		return
	end

	if not arg0_2._active then
		arg0_2._active = true
		arg0_2.mouseInputDown = Input.mousePosition
		arg0_2.mouseInputDownTime = Time.time
		arg0_2.triggerActionTime = 0

		if arg0_2.actionTrigger.type == Live2D.DRAG_DOWN_ACTION then
			arg0_2.actionListIndex = 1
		end

		arg0_2.parameterSmoothTime = arg0_2.smooth
	end
end

function var0_0.stopDrag(arg0_3)
	if arg0_3._active then
		arg0_3._active = false

		if arg0_3.revert > 0 then
			arg0_3.parameterToStart = arg0_3.revert / 1000
			arg0_3.parameterSmoothTime = arg0_3.smoothRevert
		end

		if arg0_3.offsetDragX then
			arg0_3.offsetDragTargetX = arg0_3:fixParameterTargetValue(arg0_3.offsetDragX, arg0_3.range, arg0_3.rangeAbs, arg0_3.dragDirect)
		end

		if arg0_3.offsetDragY then
			arg0_3.offsetDragTargetY = arg0_3:fixParameterTargetValue(arg0_3.offsetDragY, arg0_3.range, arg0_3.rangeAbs, arg0_3.dragDirect)
		end

		if type(arg0_3.partsData) == "table" then
			local var0_3 = arg0_3.partsData.parts

			if arg0_3.offsetX or arg0_3.offsetY then
				local var1_3 = arg0_3.parameterTargetValue
				local var2_3
				local var3_3

				for iter0_3 = 1, #var0_3 do
					local var4_3 = var0_3[iter0_3]
					local var5_3 = math.abs(var1_3 - var4_3)

					if not var2_3 or var5_3 < var2_3 then
						var2_3 = var5_3
						var3_3 = iter0_3
					end
				end

				if var3_3 then
					arg0_3:setTargetValue(var0_3[var3_3])
				end
			end
		end

		arg0_3.mouseInputUp = Input.mousePosition
		arg0_3.mouseInputUpTime = Time.time

		arg0_3:saveData()
	end
end

function var0_0.getIgnoreReact(arg0_4)
	return arg0_4.ignoreReact
end

function var0_0.setParameterCom(arg0_5, arg1_5)
	if not arg1_5 then
		print("live2dDrag id:" .. tostring(arg0_5.id) .. "设置了null的组件(该打印非报错)")
	end

	arg0_5._parameterCom = arg1_5
end

function var0_0.getParameterCom(arg0_6)
	return arg0_6._parameterCom
end

function var0_0.addRelationComData(arg0_7, arg1_7, arg2_7)
	table.insert(arg0_7._relationParameterList, {
		com = arg1_7,
		data = arg2_7
	})
end

function var0_0.getRelationParameterList(arg0_8)
	return arg0_8._relationParameterList
end

function var0_0.getReactCondition(arg0_9)
	return arg0_9.reactConditionFlag
end

function var0_0.getActive(arg0_10)
	return arg0_10._active
end

function var0_0.getParameterUpdateFlag(arg0_11)
	return arg0_11._parameterUpdateFlag
end

function var0_0.setEventCallback(arg0_12, arg1_12)
	arg0_12._eventCallback = arg1_12
end

function var0_0.onEventCallback(arg0_13, arg1_13, arg2_13, arg3_13)
	if arg1_13 == Live2D.EVENT_ACTION_APPLY then
		local var0_13 = {}
		local var1_13
		local var2_13 = false
		local var3_13
		local var4_13
		local var5_13

		if arg0_13.actionTrigger.action then
			var1_13 = arg0_13:fillterAction(arg0_13.actionTrigger.action)
			var0_13 = arg0_13.actionTriggerActive
			var2_13 = arg0_13.actionTrigger.focus or false
			var3_13 = arg0_13.actionTrigger.target or nil

			if (arg0_13.actionTrigger.circle or nil) and var3_13 and var3_13 == arg0_13.parameterTargetValue then
				var3_13 = arg0_13.startValue
			end

			var4_13 = arg0_13.actionTrigger.react or nil

			arg0_13:triggerAction()
			arg0_13:stopDrag()
		elseif arg0_13.actionTrigger.action_list then
			local var6_13 = arg0_13.actionTrigger.action_list[arg0_13.actionListIndex]

			var1_13 = arg0_13:fillterAction(var6_13.action)

			if arg0_13.actionTriggerActive.active_list and arg0_13.actionListIndex <= #arg0_13.actionTriggerActive.active_list then
				var0_13 = arg0_13.actionTriggerActive.active_list[arg0_13.actionListIndex]
			end

			var2_13 = var6_13.focus or true
			var3_13 = var6_13.target or nil
			var4_13 = var6_13.react or nil

			if arg0_13.actionListIndex == #arg0_13.actionTrigger.action_list then
				arg0_13:triggerAction()
				arg0_13:stopDrag()

				arg0_13.actionListIndex = 1
			else
				arg0_13.actionListIndex = arg0_13.actionListIndex + 1
			end

			print("id = " .. arg0_13.id .. " action list index = " .. arg0_13.actionListIndex)
		elseif not arg0_13.actionTrigger.action then
			var1_13 = arg0_13:fillterAction(arg0_13.actionTrigger.action)
			var0_13 = arg0_13.actionTriggerActive
			var2_13 = arg0_13.actionTrigger.focus or false
			var3_13 = arg0_13.actionTrigger.target or nil

			if (arg0_13.actionTrigger.circle or nil) and var3_13 and var3_13 == arg0_13.parameterTargetValue then
				var3_13 = arg0_13.startValue
			end

			var4_13 = arg0_13.actionTrigger.react or nil

			arg0_13:triggerAction()
			arg0_13:stopDrag()
		end

		if var0_13.idle then
			if type(var0_13.idle) == "number" then
				if var0_13.idle == arg0_13.l2dIdleIndex and not var0_13.repeatFlag then
					return
				end
			elseif type(var0_13.idle) == "table" and #var0_13.idle == 1 and var0_13.idle[1] == arg0_13.l2dIdleIndex and not var0_13.repeatFlag then
				return
			end
		end

		if var3_13 then
			arg0_13:setTargetValue(var3_13)

			if not var1_13 then
				arg0_13.revertResetFlag = true
			end
		end

		arg2_13 = {
			id = arg0_13.id,
			action = var1_13,
			activeData = var0_13,
			focus = var2_13,
			react = var4_13,
			function()
				arg0_13:actionApplyFinish()
			end
		}
	elseif arg1_13 == Live2D.EVENT_ACTION_ABLE then
		-- block empty
	end

	arg0_13._eventCallback(arg1_13, arg2_13, arg3_13)
end

function var0_0.fillterAction(arg0_15, arg1_15)
	if type(arg1_15) == "table" then
		return arg1_15[math.random(1, #arg0_15.actionTrigger.action)]
	else
		return arg1_15
	end
end

function var0_0.setTargetValue(arg0_16, arg1_16)
	arg0_16.parameterTargetValue = arg1_16
end

function var0_0.getParameter(arg0_17)
	return arg0_17.parameterValue
end

function var0_0.getParameToTargetFlag(arg0_18)
	if arg0_18.parameterValue ~= arg0_18.parameterTargetValue then
		return true
	end

	if arg0_18.parameterToStart and arg0_18.parameterToStart > 0 then
		return true
	end

	return false
end

function var0_0.actionApplyFinish(arg0_19)
	return
end

function var0_0.stepParameter(arg0_20)
	arg0_20:updateState()
	arg0_20:updateTrigger()
	arg0_20:updateParameterUpdateFlag()
	arg0_20:updateGyro()
	arg0_20:updateDrag()
	arg0_20:updateReactValue()
	arg0_20:updateParameterValue()
	arg0_20:updateRelationValue()
	arg0_20:checkReset()
end

function var0_0.updateParameterUpdateFlag(arg0_21)
	if arg0_21.actionTrigger.type == Live2D.DRAG_CLICK_ACTION then
		arg0_21._parameterUpdateFlag = true
	elseif arg0_21.actionTrigger.type == Live2D.DRAG_RELATION_IDLE then
		if not arg0_21._parameterUpdateFlag then
			if not arg0_21.l2dIsPlaying then
				arg0_21._parameterUpdateFlag = true

				arg0_21:changeParameComAble(true)
			elseif not table.contains(arg0_21.actionTrigger.remove_com_list, arg0_21.l2dPlayActionName) then
				arg0_21._parameterUpdateFlag = true

				arg0_21:changeParameComAble(true)
			end
		elseif arg0_21._parameterUpdateFlag == true and arg0_21.l2dIsPlaying and table.contains(arg0_21.actionTrigger.remove_com_list, arg0_21.l2dPlayActionName) then
			arg0_21._parameterUpdateFlag = false

			arg0_21:changeParameComAble(false)
		end
	else
		arg0_21._parameterUpdateFlag = false
	end
end

function var0_0.changeParameComAble(arg0_22, arg1_22)
	if arg0_22.parameterComAdd == arg1_22 then
		return
	end

	arg0_22.parameterComAdd = arg1_22

	if arg1_22 then
		arg0_22:onEventCallback(Live2D.EVENT_ADD_PARAMETER_COM, {
			com = arg0_22._parameterCom,
			start = arg0_22.startValue,
			mode = arg0_22.mode
		})
	else
		arg0_22:onEventCallback(Live2D.EVENT_REMOVE_PARAMETER_COM, {
			com = arg0_22._parameterCom,
			mode = arg0_22.mode
		})
	end
end

function var0_0.updateDrag(arg0_23)
	if not arg0_23.offsetX and not arg0_23.offsetY then
		return
	end

	local var0_23

	if arg0_23._active then
		local var1_23 = Input.mousePosition

		if arg0_23.offsetX and arg0_23.offsetX ~= 0 then
			local var2_23 = var1_23.x - arg0_23.mouseInputDown.x

			var0_23 = arg0_23.offsetDragTargetX + var2_23 / arg0_23.offsetX
			arg0_23.offsetDragX = var0_23
		end

		if arg0_23.offsetY and arg0_23.offsetY ~= 0 then
			local var3_23 = var1_23.y - arg0_23.mouseInputDown.y

			var0_23 = arg0_23.offsetDragTargetY + var3_23 / arg0_23.offsetY
			arg0_23.offsetDragY = var0_23
		end

		if var0_23 then
			arg0_23:setTargetValue(arg0_23:fixParameterTargetValue(var0_23, arg0_23.range, arg0_23.rangeAbs, arg0_23.dragDirect))
		end
	end

	arg0_23._parameterUpdateFlag = true
end

function var0_0.updateGyro(arg0_24)
	if not arg0_24.gyro then
		return
	end

	if not Input.gyro.enabled then
		arg0_24:setTargetValue(0)

		arg0_24._parameterUpdateFlag = true

		return
	end

	local var0_24 = Input.gyro and Input.gyro.attitude or Vector3.zero
	local var1_24 = 0

	if arg0_24.gyroX and not math.isnan(var0_24.y) then
		var1_24 = Mathf.Clamp(var0_24.y * arg0_24.sensitive, -0.5, 0.5)
	elseif arg0_24.gyroY and not math.isnan(var0_24.x) then
		var1_24 = Mathf.Clamp(var0_24.x * arg0_24.sensitive, -0.5, 0.5)
	elseif arg0_24.gyroZ and not math.isnan(var0_24.z) then
		var1_24 = Mathf.Clamp(var0_24.z * arg0_24.sensitive, -0.5, 0.5)
	end

	if IsUnityEditor then
		if L2D_USE_RANDOM_ATTI then
			if arg0_24.randomAttitudeIndex == 0 then
				var1_24 = math.random() - 0.5

				local var2_24 = (var1_24 + 0.5) * (arg0_24.range[2] - arg0_24.range[1]) + arg0_24.range[1]

				arg0_24:setTargetValue(var2_24)

				arg0_24.randomAttitudeIndex = L2D_RANDOM_PARAM
			elseif arg0_24.randomAttitudeIndex > 0 then
				arg0_24.randomAttitudeIndex = arg0_24.randomAttitudeIndex - 1
			end
		end
	else
		local var3_24 = (var1_24 + 0.5) * (arg0_24.range[2] - arg0_24.range[1]) + arg0_24.range[1]

		arg0_24:setTargetValue(var3_24)
	end

	arg0_24._parameterUpdateFlag = true
end

function var0_0.updateReactValue(arg0_25)
	if not arg0_25.reactX and not arg0_25.reactY then
		return
	end

	local var0_25
	local var1_25 = false

	if arg0_25.l2dIgnoreReact then
		var0_25 = arg0_25.parameterTargetValue
	elseif arg0_25.reactX then
		var0_25 = arg0_25.reactPos.x * arg0_25.reactX
		var1_25 = true
	else
		var0_25 = arg0_25.reactPos.y * arg0_25.reactY
		var1_25 = true
	end

	if var1_25 then
		arg0_25:setTargetValue(arg0_25:fixParameterTargetValue(var0_25, arg0_25.range, arg0_25.rangeAbs, arg0_25.dragDirect))
	end

	arg0_25._parameterUpdateFlag = true
end

function var0_0.updateParameterValue(arg0_26)
	if arg0_26._parameterUpdateFlag and arg0_26.parameterValue ~= arg0_26.parameterTargetValue then
		if math.abs(arg0_26.parameterValue - arg0_26.parameterTargetValue) < 0.01 then
			arg0_26:setParameterValue(arg0_26.parameterTargetValue)
		elseif arg0_26.parameterSmoothTime and arg0_26.parameterSmoothTime > 0 then
			local var0_26, var1_26 = Mathf.SmoothDamp(arg0_26.parameterValue, arg0_26.parameterTargetValue, arg0_26.parameterSmooth, arg0_26.parameterSmoothTime)

			arg0_26:setParameterValue(var0_26, var1_26)
		else
			arg0_26:setParameterValue(arg0_26.parameterTargetValue, 0)
		end
	end
end

function var0_0.updateRelationValue(arg0_27)
	for iter0_27, iter1_27 in ipairs(arg0_27._relationParameterList) do
		local var0_27 = iter1_27.data
		local var1_27 = var0_27.type
		local var2_27 = var0_27.relation_value
		local var3_27
		local var4_27
		local var5_27

		if var1_27 == Live2D.relation_type_drag_x then
			var3_27 = arg0_27.offsetDragX or iter1_27.start or arg0_27.startValue or 0
			var5_27 = true
		elseif var1_27 == Live2D.relation_type_drag_y then
			var3_27 = arg0_27.offsetDragY or iter1_27.start or arg0_27.startValue or 0
			var5_27 = true
		elseif var1_27 == Live2D.relation_type_action_index then
			var3_27 = var2_27[arg0_27.actionListIndex]
			var3_27 = var3_27 or 0
			var5_27 = true
		else
			var3_27 = arg0_27.parameterTargetValue
			var5_27 = false
		end

		local var6_27 = iter1_27.value or arg0_27.startValue
		local var7_27 = arg0_27:fixRelationParameter(var3_27, var0_27)
		local var8_27 = iter1_27.parameterSmooth or 0
		local var9_27 = 0.1
		local var10_27, var11_27 = Mathf.SmoothDamp(var6_27, var7_27, var8_27, var9_27)

		iter1_27.value = var10_27
		iter1_27.parameterSmooth = var11_27
		iter1_27.enable = var5_27
		iter1_27.comId = arg0_27.id
	end
end

function var0_0.fixRelationParameter(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg2_28.range or arg0_28.range
	local var1_28 = arg2_28.rangeAbs and arg2_28.rangeAbs == 1 or arg0_28.rangeAbs
	local var2_28 = arg2_28.dragDirect and arg2_28.dragDirect or arg0_28.dragDirect

	return arg0_28:fixParameterTargetValue(arg1_28, var0_28, var1_28, var2_28)
end

function var0_0.fixParameterTargetValue(arg0_29, arg1_29, arg2_29, arg3_29, arg4_29)
	if arg1_29 < 0 and arg4_29 == 1 then
		arg1_29 = 0
	elseif arg1_29 > 0 and arg4_29 == 2 then
		arg1_29 = 0
	end

	arg1_29 = arg3_29 and math.abs(arg1_29) or arg1_29

	if arg1_29 < arg2_29[1] then
		arg1_29 = arg2_29[1]
	elseif arg1_29 > arg2_29[2] then
		arg1_29 = arg2_29[2]
	end

	return arg1_29
end

function var0_0.checkReset(arg0_30)
	if not arg0_30._active and arg0_30.parameterToStart then
		if arg0_30.parameterToStart > 0 then
			arg0_30.parameterToStart = arg0_30.parameterToStart - Time.deltaTime
		end

		if arg0_30.parameterToStart <= 0 then
			arg0_30:setTargetValue(arg0_30.startValue)

			arg0_30.parameterToStart = nil

			if arg0_30.revertResetFlag then
				arg0_30:setTriggerActionFlag(false)

				arg0_30.revertResetFlag = false
			end

			if arg0_30.offsetDragX then
				arg0_30.offsetDragX = arg0_30.startValue
				arg0_30.offsetDragTargetX = arg0_30.startValue
			end

			if arg0_30.offsetDragY then
				arg0_30.offsetDragY = arg0_30.startValue
				arg0_30.offsetDragTargetY = arg0_30.startValue
			end
		end
	end
end

function var0_0.changeReactValue(arg0_31, arg1_31)
	arg0_31.reactPos = arg1_31
end

function var0_0.setParameterValue(arg0_32, arg1_32, arg2_32)
	if arg1_32 then
		arg0_32.parameterValue = arg1_32
	end

	if arg2_32 then
		arg0_32.parameterSmooth = arg2_32
	end
end

function var0_0.updateState(arg0_33)
	if not arg0_33.lastFrameActive and arg0_33._active then
		arg0_33.firstActive = true
	else
		arg0_33.firstActive = false
	end

	if arg0_33.lastFrameActive and not arg0_33._active then
		arg0_33.firstStop = true
	else
		arg0_33.firstStop = false
	end

	arg0_33.lastFrameActive = arg0_33._active
end

function var0_0.updateTrigger(arg0_34)
	if not arg0_34:isActionTriggerAble() then
		return
	end

	local var0_34 = arg0_34.actionTrigger.type
	local var1_34 = arg0_34.actionTrigger.action
	local var2_34

	if arg0_34.actionTrigger.time then
		var2_34 = arg0_34.actionTrigger.time
	elseif arg0_34.actionTrigger.action_list and arg0_34.actionListIndex > 0 then
		var2_34 = arg0_34.actionTrigger.action_list[arg0_34.actionListIndex].time
	end

	local var3_34

	if arg0_34.actionTrigger.num then
		var3_34 = arg0_34.actionTrigger.num
	elseif arg0_34.actionTrigger.action_list and arg0_34.actionTrigger.action_list[arg0_34.actionListIndex].num and arg0_34.actionListIndex > 0 then
		var3_34 = arg0_34.actionTrigger.action_list[arg0_34.actionListIndex].num
	end

	if var0_34 == Live2D.DRAG_TIME_ACTION then
		if arg0_34._active then
			if math.abs(arg0_34.parameterValue - var3_34) < math.abs(var3_34) * 0.25 then
				arg0_34.triggerActionTime = arg0_34.triggerActionTime + Time.deltaTime

				if var2_34 < arg0_34.triggerActionTime and not arg0_34.l2dIsPlaying then
					arg0_34:onEventCallback(Live2D.EVENT_ACTION_APPLY)
				end
			else
				arg0_34.triggerActionTime = arg0_34.triggerActionTime + 0
			end
		end
	elseif var0_34 == Live2D.DRAG_CLICK_ACTION then
		if arg0_34:checkClickAction() then
			arg0_34:onEventCallback(Live2D.EVENT_ACTION_APPLY)
		end
	elseif var0_34 == Live2D.DRAG_DOWN_ACTION then
		if arg0_34._active then
			if arg0_34.firstActive then
				arg0_34.ableFalg = true

				arg0_34:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
					ableFlag = true
				})
			end

			if var2_34 <= Time.time - arg0_34.mouseInputDownTime then
				arg0_34:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
					ableFlag = false
				})

				arg0_34.ableFalg = false

				arg0_34:onEventCallback(Live2D.EVENT_ACTION_APPLY)

				arg0_34.mouseInputDownTime = Time.time
			end
		elseif arg0_34.ableFalg then
			arg0_34.ableFalg = false

			arg0_34:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
				ableFlag = false
			})
		end
	elseif var0_34 == Live2D.DRAG_RELATION_XY then
		if arg0_34._active then
			local var4_34 = arg0_34:fixParameterTargetValue(arg0_34.offsetDragX, arg0_34.range, arg0_34.rangeAbs, arg0_34.dragDirect)
			local var5_34 = arg0_34:fixParameterTargetValue(arg0_34.offsetDragY, arg0_34.range, arg0_34.rangeAbs, arg0_34.dragDirect)
			local var6_34 = var3_34[1]
			local var7_34 = var3_34[2]

			if math.abs(var4_34 - var6_34) < math.abs(var6_34) * 0.25 and math.abs(var5_34 - var7_34) < math.abs(var7_34) * 0.25 then
				arg0_34.triggerActionTime = arg0_34.triggerActionTime + Time.deltaTime

				if var2_34 < arg0_34.triggerActionTime and not arg0_34.l2dIsPlaying then
					arg0_34:onEventCallback(Live2D.EVENT_ACTION_APPLY)
				end
			else
				arg0_34.triggerActionTime = arg0_34.triggerActionTime + 0
			end
		end
	elseif var0_34 == Live2D.DRAG_RELATION_IDLE then
		if arg0_34.actionTrigger.const_fit then
			for iter0_34 = 1, #arg0_34.actionTrigger.const_fit do
				local var8_34 = arg0_34.actionTrigger.const_fit[iter0_34]

				if arg0_34.l2dIdleIndex == var8_34.idle and not arg0_34.l2dIsPlaying then
					arg0_34:setTargetValue(var8_34.target)
				end
			end
		end
	elseif var0_34 == Live2D.DRAG_CLICK_MANY and arg0_34:checkClickAction() then
		print("id = " .. arg0_34.id .. "被按下了")
		arg0_34:onEventCallback(Live2D.EVENT_ACTION_APPLY)
	end
end

function var0_0.triggerAction(arg0_35)
	arg0_35.nextTriggerTime = arg0_35.limitTime

	arg0_35:setTriggerActionFlag(true)
end

function var0_0.isActionTriggerAble(arg0_36)
	if arg0_36.actionTrigger.type == nil then
		return false
	end

	if not arg0_36.actionTrigger or arg0_36.actionTrigger == "" then
		return
	end

	if arg0_36.nextTriggerTime - Time.deltaTime >= 0 then
		arg0_36.nextTriggerTime = arg0_36.nextTriggerTime - Time.deltaTime

		return false
	end

	if arg0_36.isTriggerAtion then
		return false
	end

	return true
end

function var0_0.updateStateData(arg0_37, arg1_37)
	if arg0_37.revertIdleIndex and arg0_37.l2dIdleIndex ~= arg1_37.idleIndex then
		arg0_37:setTargetValue(arg0_37.startValue)
	end

	arg0_37.lastActionIndex = arg0_37.actionListIndex

	if arg1_37.isPlaying and arg0_37.actionTrigger.reset_index_action and arg1_37.actionName and table.contains(arg0_37.actionTrigger.reset_index_action, arg1_37.actionName) then
		arg0_37.actionListIndex = 1
	end

	if arg0_37.revertActionIndex and arg0_37.lastActionIndex ~= arg0_37.actionListIndex then
		arg0_37:setTargetValue(arg0_37.startValue)
	end

	arg0_37.l2dIdleIndex = arg1_37.idleIndex
	arg0_37.l2dIsPlaying = arg1_37.isPlaying
	arg0_37.l2dIgnoreReact = arg1_37.ignoreReact
	arg0_37.l2dPlayActionName = arg1_37.actionName

	if not arg0_37.l2dIsPlaying and arg0_37.isTriggerAtion then
		arg0_37:setTriggerActionFlag(false)
	end

	if arg0_37.l2dIdleIndex and arg0_37.idleOn and #arg0_37.idleOn > 0 then
		arg0_37.reactConditionFlag = table.contains(arg0_37.idleOn, arg0_37.l2dIdleIndex)
	end

	if arg0_37.l2dIdleIndex and arg0_37.idleOff and #arg0_37.idleOff > 0 then
		arg0_37.reactConditionFlag = not table.contains(arg0_37.idleOff, arg0_37.l2dIdleIndex)
	end
end

function var0_0.checkClickAction(arg0_38)
	if arg0_38.firstActive then
		arg0_38:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
			ableFlag = true
		})
	elseif arg0_38.firstStop then
		local var0_38 = math.abs(arg0_38.mouseInputUp.x - arg0_38.mouseInputDown.x) < 30 and math.abs(arg0_38.mouseInputUp.y - arg0_38.mouseInputDown.y) < 30
		local var1_38 = arg0_38.mouseInputUpTime - arg0_38.mouseInputDownTime < 0.5

		if var0_38 and var1_38 and not arg0_38.l2dIsPlaying then
			arg0_38.clickTriggerTime = 0.01
			arg0_38.clickApplyFlag = true
		else
			arg0_38:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
				ableFlag = false
			})
		end
	elseif arg0_38.clickTriggerTime and arg0_38.clickTriggerTime > 0 then
		arg0_38.clickTriggerTime = arg0_38.clickTriggerTime - Time.deltaTime

		if arg0_38.clickTriggerTime <= 0 then
			arg0_38.clickTriggerTime = nil

			arg0_38:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
				ableFlag = false
			})

			if arg0_38.clickApplyFlag then
				arg0_38.clickApplyFlag = false

				return true
			end
		end
	end

	return false
end

function var0_0.saveData(arg0_39)
	if arg0_39.revert == -1 and arg0_39.saveParameterFlag then
		Live2dConst.SaveDragData(arg0_39.id, arg0_39.live2dData:GetShipSkinConfig().id, arg0_39.live2dData.ship.id, arg0_39.parameterTargetValue)
	end

	if arg0_39.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		Live2dConst.SetDragActionIndex(arg0_39.id, arg0_39.live2dData:GetShipSkinConfig().id, arg0_39.live2dData.ship.id, arg0_39.actionListIndex)
	end
end

function var0_0.loadData(arg0_40)
	if arg0_40.revert == -1 and arg0_40.saveParameterFlag then
		local var0_40 = Live2dConst.GetDragData(arg0_40.id, arg0_40.live2dData:GetShipSkinConfig().id, arg0_40.live2dData.ship.id)

		if var0_40 then
			arg0_40:setParameterValue(var0_40)
			arg0_40:setTargetValue(var0_40)
		end
	end

	if arg0_40.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		arg0_40.actionListIndex = Live2dConst.GetDragActionIndex(arg0_40.id, arg0_40.live2dData:GetShipSkinConfig().id, arg0_40.live2dData.ship.id) or 1
	end
end

function var0_0.clearData(arg0_41)
	if arg0_41.revert == -1 then
		arg0_41:setParameterValue(arg0_41.startValue)
		arg0_41:setTargetValue(arg0_41.startValue)
	end
end

function var0_0.setTriggerActionFlag(arg0_42, arg1_42)
	arg0_42.isTriggerAtion = arg1_42
end

function var0_0.dispose(arg0_43)
	arg0_43._active = false
	arg0_43._parameterCom = nil
	arg0_43.parameterValue = arg0_43.startValue
	arg0_43.parameterTargetValue = 0
	arg0_43.parameterSmooth = 0
	arg0_43.mouseInputDown = Vector2(0, 0)
	arg0_43.live2dData = nil
end

return var0_0
