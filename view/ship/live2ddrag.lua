local var0 = class("Live2dDrag")
local var1 = 4

function var0.Ctor(arg0, arg1, arg2)
	arg0.live2dData = arg2
	arg0.frameRate = Application.targetFrameRate or 60
	arg0.id = arg1.id
	arg0.drawAbleName = arg1.draw_able_name or ""
	arg0.parameterName = arg1.parameter
	arg0.mode = arg1.mode
	arg0.startValue = arg1.start_value or 0
	arg0.range = arg1.range
	arg0.offsetX = arg1.offset_x

	if arg0.offsetX == 0 then
		arg0.offsetX = nil
	end

	arg0.offsetY = arg1.offset_y

	if arg0.offsetY == 0 then
		arg0.offsetY = nil
	end

	arg0.smooth = arg1.smooth / 1000
	arg0.smoothRevert = arg1.revert_smooth / 1000
	arg0.revert = arg1.revert
	arg0.ignoreReact = arg1.ignore_react == 1
	arg0.gyro = arg1.gyro == 1 or nil
	arg0.gyroX = arg1.gyro_x == 1
	arg0.gyroY = arg1.gyro_y == 1
	arg0.gyroZ = arg1.gyro_z == 1
	arg0.ignoreAction = arg1.ignore_action == 1
	arg0.dragDirect = arg1.drag_direct
	arg0.rangeAbs = arg1.range_abs == 1
	arg0.partsData = arg1.parts_data
	arg0.actionTrigger = arg1.action_trigger
	arg0.reactX = arg1.react_pos_x ~= 0 and arg1.react_pos_x or nil
	arg0.reactY = arg1.react_pos_y ~= 0 and arg1.react_pos_y or nil
	arg0.actionTriggerActive = arg1.action_trigger_active
	arg0.relationParameter = arg1.relation_parameter
	arg0.limitTime = arg1.limit_time > 0 and arg1.limit_time or var1
	arg0.reactCondition = arg1.react_condition and arg1.react_condition ~= "" and arg1.react_condition or {}
	arg0.idleOn = arg0.reactCondition.idle_on and arg0.reactCondition.idle_on or {}
	arg0.idleOff = arg0.reactCondition.idleOff and arg0.reactCondition.idleOff or {}
	arg0.revertIdleIndex = arg1.revert_idle_index == 1 and true or false
	arg0.revertActionIndex = arg1.revert_action_index == 1 and true or false
	arg0.saveParameterFlag = true

	if arg1.save_parameter == -1 then
		arg0.saveParameterFlag = false
	end

	arg0.randomAttitudeIndex = L2D_RANDOM_PARAM
	arg0._active = false
	arg0._parameterCom = nil
	arg0.parameterValue = arg0.startValue
	arg0.parameterTargetValue = arg0.startValue
	arg0.parameterSmooth = 0
	arg0.parameterSmoothTime = arg0.smooth
	arg0.mouseInputDown = Vector2(0, 0)
	arg0.nextTriggerTime = 0
	arg0.triggerActionTime = 0
	arg0.sensitive = 4
	arg0.l2dIdleIndex = 0
	arg0.reactPos = Vector2(0, 0)
	arg0.actionListIndex = 1
	arg0._relationParameterList = {}
	arg0.offsetDragX = arg0.startValue
	arg0.offsetDragY = arg0.startValue
	arg0.offsetDragTargetX = arg0.startValue
	arg0.offsetDragTargetY = arg0.startValue
	arg0.parameterComAdd = true
	arg0.reactConditionFlag = false
end

function var0.startDrag(arg0)
	if arg0.ignoreAction and arg0.l2dIsPlaying then
		return
	end

	if not arg0._active then
		arg0._active = true
		arg0.mouseInputDown = Input.mousePosition
		arg0.mouseInputDownTime = Time.time
		arg0.triggerActionTime = 0

		if arg0.actionTrigger.type == Live2D.DRAG_DOWN_ACTION then
			arg0.actionListIndex = 1
		end

		arg0.parameterSmoothTime = arg0.smooth
	end
end

function var0.stopDrag(arg0)
	if arg0._active then
		arg0._active = false

		if arg0.revert > 0 then
			arg0.parameterToStart = arg0.revert / 1000
			arg0.parameterSmoothTime = arg0.smoothRevert
		end

		if arg0.offsetDragX then
			arg0.offsetDragTargetX = arg0:fixParameterTargetValue(arg0.offsetDragX, arg0.range, arg0.rangeAbs, arg0.dragDirect)
		end

		if arg0.offsetDragY then
			arg0.offsetDragTargetY = arg0:fixParameterTargetValue(arg0.offsetDragY, arg0.range, arg0.rangeAbs, arg0.dragDirect)
		end

		if type(arg0.partsData) == "table" then
			local var0 = arg0.partsData.parts

			if arg0.offsetX or arg0.offsetY then
				local var1 = arg0.parameterTargetValue
				local var2
				local var3

				for iter0 = 1, #var0 do
					local var4 = var0[iter0]
					local var5 = math.abs(var1 - var4)

					if not var2 or var5 < var2 then
						var2 = var5
						var3 = iter0
					end
				end

				if var3 then
					arg0:setTargetValue(var0[var3])
				end
			end
		end

		arg0.mouseInputUp = Input.mousePosition
		arg0.mouseInputUpTime = Time.time

		arg0:saveData()
	end
end

function var0.getIgnoreReact(arg0)
	return arg0.ignoreReact
end

function var0.setParameterCom(arg0, arg1)
	if not arg1 then
		print("live2dDrag id:" .. tostring(arg0.id) .. "设置了null的组件(该打印非报错)")
	end

	arg0._parameterCom = arg1
end

function var0.getParameterCom(arg0)
	return arg0._parameterCom
end

function var0.addRelationComData(arg0, arg1, arg2)
	table.insert(arg0._relationParameterList, {
		com = arg1,
		data = arg2
	})
end

function var0.getRelationParameterList(arg0)
	return arg0._relationParameterList
end

function var0.getReactCondition(arg0)
	return arg0.reactConditionFlag
end

function var0.getActive(arg0)
	return arg0._active
end

function var0.getParameterUpdateFlag(arg0)
	return arg0._parameterUpdateFlag
end

function var0.setEventCallback(arg0, arg1)
	arg0._eventCallback = arg1
end

function var0.onEventCallback(arg0, arg1, arg2, arg3)
	if arg1 == Live2D.EVENT_ACTION_APPLY then
		local var0 = {}
		local var1
		local var2 = false
		local var3
		local var4
		local var5

		if arg0.actionTrigger.action then
			var1 = arg0:fillterAction(arg0.actionTrigger.action)
			var0 = arg0.actionTriggerActive
			var2 = arg0.actionTrigger.focus or false
			var3 = arg0.actionTrigger.target or nil

			if (arg0.actionTrigger.circle or nil) and var3 and var3 == arg0.parameterTargetValue then
				var3 = arg0.startValue
			end

			var4 = arg0.actionTrigger.react or nil

			arg0:triggerAction()
			arg0:stopDrag()
		elseif arg0.actionTrigger.action_list then
			local var6 = arg0.actionTrigger.action_list[arg0.actionListIndex]

			var1 = arg0:fillterAction(var6.action)

			if arg0.actionTriggerActive.active_list and arg0.actionListIndex <= #arg0.actionTriggerActive.active_list then
				var0 = arg0.actionTriggerActive.active_list[arg0.actionListIndex]
			end

			var2 = var6.focus or true
			var3 = var6.target or nil
			var4 = var6.react or nil

			if arg0.actionListIndex == #arg0.actionTrigger.action_list then
				arg0:triggerAction()
				arg0:stopDrag()

				arg0.actionListIndex = 1
			else
				arg0.actionListIndex = arg0.actionListIndex + 1
			end

			print("id = " .. arg0.id .. " action list index = " .. arg0.actionListIndex)
		elseif not arg0.actionTrigger.action then
			var1 = arg0:fillterAction(arg0.actionTrigger.action)
			var0 = arg0.actionTriggerActive
			var2 = arg0.actionTrigger.focus or false
			var3 = arg0.actionTrigger.target or nil

			if (arg0.actionTrigger.circle or nil) and var3 and var3 == arg0.parameterTargetValue then
				var3 = arg0.startValue
			end

			var4 = arg0.actionTrigger.react or nil

			arg0:triggerAction()
			arg0:stopDrag()
		end

		if var0.idle then
			if type(var0.idle) == "number" then
				if var0.idle == arg0.l2dIdleIndex and not var0.repeatFlag then
					return
				end
			elseif type(var0.idle) == "table" and #var0.idle == 1 and var0.idle[1] == arg0.l2dIdleIndex and not var0.repeatFlag then
				return
			end
		end

		if var3 then
			arg0:setTargetValue(var3)

			if not var1 then
				arg0.revertResetFlag = true
			end
		end

		arg2 = {
			id = arg0.id,
			action = var1,
			activeData = var0,
			focus = var2,
			react = var4,
			function()
				arg0:actionApplyFinish()
			end
		}
	elseif arg1 == Live2D.EVENT_ACTION_ABLE then
		-- block empty
	end

	arg0._eventCallback(arg1, arg2, arg3)
end

function var0.fillterAction(arg0, arg1)
	if type(arg1) == "table" then
		return arg1[math.random(1, #arg0.actionTrigger.action)]
	else
		return arg1
	end
end

function var0.setTargetValue(arg0, arg1)
	arg0.parameterTargetValue = arg1
end

function var0.getParameter(arg0)
	return arg0.parameterValue
end

function var0.getParameToTargetFlag(arg0)
	if arg0.parameterValue ~= arg0.parameterTargetValue then
		return true
	end

	if arg0.parameterToStart and arg0.parameterToStart > 0 then
		return true
	end

	return false
end

function var0.actionApplyFinish(arg0)
	return
end

function var0.stepParameter(arg0)
	arg0:updateState()
	arg0:updateTrigger()
	arg0:updateParameterUpdateFlag()
	arg0:updateGyro()
	arg0:updateDrag()
	arg0:updateReactValue()
	arg0:updateParameterValue()
	arg0:updateRelationValue()
	arg0:checkReset()
end

function var0.updateParameterUpdateFlag(arg0)
	if arg0.actionTrigger.type == Live2D.DRAG_CLICK_ACTION then
		arg0._parameterUpdateFlag = true
	elseif arg0.actionTrigger.type == Live2D.DRAG_RELATION_IDLE then
		if not arg0._parameterUpdateFlag then
			if not arg0.l2dIsPlaying then
				arg0._parameterUpdateFlag = true

				arg0:changeParameComAble(true)
			elseif not table.contains(arg0.actionTrigger.remove_com_list, arg0.l2dPlayActionName) then
				arg0._parameterUpdateFlag = true

				arg0:changeParameComAble(true)
			end
		elseif arg0._parameterUpdateFlag == true and arg0.l2dIsPlaying and table.contains(arg0.actionTrigger.remove_com_list, arg0.l2dPlayActionName) then
			arg0._parameterUpdateFlag = false

			arg0:changeParameComAble(false)
		end
	else
		arg0._parameterUpdateFlag = false
	end
end

function var0.changeParameComAble(arg0, arg1)
	if arg0.parameterComAdd == arg1 then
		return
	end

	arg0.parameterComAdd = arg1

	if arg1 then
		arg0:onEventCallback(Live2D.EVENT_ADD_PARAMETER_COM, {
			com = arg0._parameterCom,
			start = arg0.startValue,
			mode = arg0.mode
		})
	else
		arg0:onEventCallback(Live2D.EVENT_REMOVE_PARAMETER_COM, {
			com = arg0._parameterCom,
			mode = arg0.mode
		})
	end
end

function var0.updateDrag(arg0)
	if not arg0.offsetX and not arg0.offsetY then
		return
	end

	local var0

	if arg0._active then
		local var1 = Input.mousePosition

		if arg0.offsetX and arg0.offsetX ~= 0 then
			local var2 = var1.x - arg0.mouseInputDown.x

			var0 = arg0.offsetDragTargetX + var2 / arg0.offsetX
			arg0.offsetDragX = var0
		end

		if arg0.offsetY and arg0.offsetY ~= 0 then
			local var3 = var1.y - arg0.mouseInputDown.y

			var0 = arg0.offsetDragTargetY + var3 / arg0.offsetY
			arg0.offsetDragY = var0
		end

		if var0 then
			arg0:setTargetValue(arg0:fixParameterTargetValue(var0, arg0.range, arg0.rangeAbs, arg0.dragDirect))
		end
	end

	arg0._parameterUpdateFlag = true
end

function var0.updateGyro(arg0)
	if not arg0.gyro then
		return
	end

	if not Input.gyro.enabled then
		arg0:setTargetValue(0)

		arg0._parameterUpdateFlag = true

		return
	end

	local var0 = Input.gyro and Input.gyro.attitude or Vector3.zero
	local var1 = 0

	if arg0.gyroX and not math.isnan(var0.y) then
		var1 = Mathf.Clamp(var0.y * arg0.sensitive, -0.5, 0.5)
	elseif arg0.gyroY and not math.isnan(var0.x) then
		var1 = Mathf.Clamp(var0.x * arg0.sensitive, -0.5, 0.5)
	elseif arg0.gyroZ and not math.isnan(var0.z) then
		var1 = Mathf.Clamp(var0.z * arg0.sensitive, -0.5, 0.5)
	end

	if IsUnityEditor then
		if L2D_USE_RANDOM_ATTI then
			if arg0.randomAttitudeIndex == 0 then
				var1 = math.random() - 0.5

				local var2 = (var1 + 0.5) * (arg0.range[2] - arg0.range[1]) + arg0.range[1]

				arg0:setTargetValue(var2)

				arg0.randomAttitudeIndex = L2D_RANDOM_PARAM
			elseif arg0.randomAttitudeIndex > 0 then
				arg0.randomAttitudeIndex = arg0.randomAttitudeIndex - 1
			end
		end
	else
		local var3 = (var1 + 0.5) * (arg0.range[2] - arg0.range[1]) + arg0.range[1]

		arg0:setTargetValue(var3)
	end

	arg0._parameterUpdateFlag = true
end

function var0.updateReactValue(arg0)
	if not arg0.reactX and not arg0.reactY then
		return
	end

	local var0
	local var1 = false

	if arg0.l2dIgnoreReact then
		var0 = arg0.parameterTargetValue
	elseif arg0.reactX then
		var0 = arg0.reactPos.x * arg0.reactX
		var1 = true
	else
		var0 = arg0.reactPos.y * arg0.reactY
		var1 = true
	end

	if var1 then
		arg0:setTargetValue(arg0:fixParameterTargetValue(var0, arg0.range, arg0.rangeAbs, arg0.dragDirect))
	end

	arg0._parameterUpdateFlag = true
end

function var0.updateParameterValue(arg0)
	if arg0._parameterUpdateFlag and arg0.parameterValue ~= arg0.parameterTargetValue then
		if math.abs(arg0.parameterValue - arg0.parameterTargetValue) < 0.01 then
			arg0:setParameterValue(arg0.parameterTargetValue)
		elseif arg0.parameterSmoothTime and arg0.parameterSmoothTime > 0 then
			local var0, var1 = Mathf.SmoothDamp(arg0.parameterValue, arg0.parameterTargetValue, arg0.parameterSmooth, arg0.parameterSmoothTime)

			arg0:setParameterValue(var0, var1)
		else
			arg0:setParameterValue(arg0.parameterTargetValue, 0)
		end
	end
end

function var0.updateRelationValue(arg0)
	for iter0, iter1 in ipairs(arg0._relationParameterList) do
		local var0 = iter1.data
		local var1 = var0.type
		local var2 = var0.relation_value
		local var3
		local var4
		local var5

		if var1 == Live2D.relation_type_drag_x then
			var3 = arg0.offsetDragX or iter1.start or arg0.startValue or 0
			var5 = true
		elseif var1 == Live2D.relation_type_drag_y then
			var3 = arg0.offsetDragY or iter1.start or arg0.startValue or 0
			var5 = true
		elseif var1 == Live2D.relation_type_action_index then
			var3 = var2[arg0.actionListIndex]
			var3 = var3 or 0
			var5 = true
		else
			var3 = arg0.parameterTargetValue
			var5 = false
		end

		local var6 = iter1.value or arg0.startValue
		local var7 = arg0:fixRelationParameter(var3, var0)
		local var8 = iter1.parameterSmooth or 0
		local var9 = 0.1
		local var10, var11 = Mathf.SmoothDamp(var6, var7, var8, var9)

		iter1.value = var10
		iter1.parameterSmooth = var11
		iter1.enable = var5
		iter1.comId = arg0.id
	end
end

function var0.fixRelationParameter(arg0, arg1, arg2)
	local var0 = arg2.range or arg0.range
	local var1 = arg2.rangeAbs and arg2.rangeAbs == 1 or arg0.rangeAbs
	local var2 = arg2.dragDirect and arg2.dragDirect or arg0.dragDirect

	return arg0:fixParameterTargetValue(arg1, var0, var1, var2)
end

function var0.fixParameterTargetValue(arg0, arg1, arg2, arg3, arg4)
	if arg1 < 0 and arg4 == 1 then
		arg1 = 0
	elseif arg1 > 0 and arg4 == 2 then
		arg1 = 0
	end

	arg1 = arg3 and math.abs(arg1) or arg1

	if arg1 < arg2[1] then
		arg1 = arg2[1]
	elseif arg1 > arg2[2] then
		arg1 = arg2[2]
	end

	return arg1
end

function var0.checkReset(arg0)
	if not arg0._active and arg0.parameterToStart then
		if arg0.parameterToStart > 0 then
			arg0.parameterToStart = arg0.parameterToStart - Time.deltaTime
		end

		if arg0.parameterToStart <= 0 then
			arg0:setTargetValue(arg0.startValue)

			arg0.parameterToStart = nil

			if arg0.revertResetFlag then
				arg0:setTriggerActionFlag(false)

				arg0.revertResetFlag = false
			end

			if arg0.offsetDragX then
				arg0.offsetDragX = arg0.startValue
				arg0.offsetDragTargetX = arg0.startValue
			end

			if arg0.offsetDragY then
				arg0.offsetDragY = arg0.startValue
				arg0.offsetDragTargetY = arg0.startValue
			end
		end
	end
end

function var0.changeReactValue(arg0, arg1)
	arg0.reactPos = arg1
end

function var0.setParameterValue(arg0, arg1, arg2)
	if arg1 then
		arg0.parameterValue = arg1
	end

	if arg2 then
		arg0.parameterSmooth = arg2
	end
end

function var0.updateState(arg0)
	if not arg0.lastFrameActive and arg0._active then
		arg0.firstActive = true
	else
		arg0.firstActive = false
	end

	if arg0.lastFrameActive and not arg0._active then
		arg0.firstStop = true
	else
		arg0.firstStop = false
	end

	arg0.lastFrameActive = arg0._active
end

function var0.updateTrigger(arg0)
	if not arg0:isActionTriggerAble() then
		return
	end

	local var0 = arg0.actionTrigger.type
	local var1 = arg0.actionTrigger.action
	local var2

	if arg0.actionTrigger.time then
		var2 = arg0.actionTrigger.time
	elseif arg0.actionTrigger.action_list and arg0.actionListIndex > 0 then
		var2 = arg0.actionTrigger.action_list[arg0.actionListIndex].time
	end

	local var3

	if arg0.actionTrigger.num then
		var3 = arg0.actionTrigger.num
	elseif arg0.actionTrigger.action_list and arg0.actionTrigger.action_list[arg0.actionListIndex].num and arg0.actionListIndex > 0 then
		var3 = arg0.actionTrigger.action_list[arg0.actionListIndex].num
	end

	if var0 == Live2D.DRAG_TIME_ACTION then
		if arg0._active then
			if math.abs(arg0.parameterValue - var3) < math.abs(var3) * 0.25 then
				arg0.triggerActionTime = arg0.triggerActionTime + Time.deltaTime

				if var2 < arg0.triggerActionTime and not arg0.l2dIsPlaying then
					arg0:onEventCallback(Live2D.EVENT_ACTION_APPLY)
				end
			else
				arg0.triggerActionTime = arg0.triggerActionTime + 0
			end
		end
	elseif var0 == Live2D.DRAG_CLICK_ACTION then
		if arg0:checkClickAction() then
			arg0:onEventCallback(Live2D.EVENT_ACTION_APPLY)
		end
	elseif var0 == Live2D.DRAG_DOWN_ACTION then
		if arg0._active then
			if arg0.firstActive then
				arg0.ableFalg = true

				arg0:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
					ableFlag = true
				})
			end

			if var2 <= Time.time - arg0.mouseInputDownTime then
				arg0:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
					ableFlag = false
				})

				arg0.ableFalg = false

				arg0:onEventCallback(Live2D.EVENT_ACTION_APPLY)

				arg0.mouseInputDownTime = Time.time
			end
		elseif arg0.ableFalg then
			arg0.ableFalg = false

			arg0:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
				ableFlag = false
			})
		end
	elseif var0 == Live2D.DRAG_RELATION_XY then
		if arg0._active then
			local var4 = arg0:fixParameterTargetValue(arg0.offsetDragX, arg0.range, arg0.rangeAbs, arg0.dragDirect)
			local var5 = arg0:fixParameterTargetValue(arg0.offsetDragY, arg0.range, arg0.rangeAbs, arg0.dragDirect)
			local var6 = var3[1]
			local var7 = var3[2]

			if math.abs(var4 - var6) < math.abs(var6) * 0.25 and math.abs(var5 - var7) < math.abs(var7) * 0.25 then
				arg0.triggerActionTime = arg0.triggerActionTime + Time.deltaTime

				if var2 < arg0.triggerActionTime and not arg0.l2dIsPlaying then
					arg0:onEventCallback(Live2D.EVENT_ACTION_APPLY)
				end
			else
				arg0.triggerActionTime = arg0.triggerActionTime + 0
			end
		end
	elseif var0 == Live2D.DRAG_RELATION_IDLE then
		if arg0.actionTrigger.const_fit then
			for iter0 = 1, #arg0.actionTrigger.const_fit do
				local var8 = arg0.actionTrigger.const_fit[iter0]

				if arg0.l2dIdleIndex == var8.idle and not arg0.l2dIsPlaying then
					arg0:setTargetValue(var8.target)
				end
			end
		end
	elseif var0 == Live2D.DRAG_CLICK_MANY and arg0:checkClickAction() then
		print("id = " .. arg0.id .. "被按下了")
		arg0:onEventCallback(Live2D.EVENT_ACTION_APPLY)
	end
end

function var0.triggerAction(arg0)
	arg0.nextTriggerTime = arg0.limitTime

	arg0:setTriggerActionFlag(true)
end

function var0.isActionTriggerAble(arg0)
	if arg0.actionTrigger.type == nil then
		return false
	end

	if not arg0.actionTrigger or arg0.actionTrigger == "" then
		return
	end

	if arg0.nextTriggerTime - Time.deltaTime >= 0 then
		arg0.nextTriggerTime = arg0.nextTriggerTime - Time.deltaTime

		return false
	end

	if arg0.isTriggerAtion then
		return false
	end

	return true
end

function var0.updateStateData(arg0, arg1)
	if arg0.revertIdleIndex and arg0.l2dIdleIndex ~= arg1.idleIndex then
		arg0:setTargetValue(arg0.startValue)
	end

	arg0.lastActionIndex = arg0.actionListIndex

	if arg1.isPlaying and arg0.actionTrigger.reset_index_action and arg1.actionName and table.contains(arg0.actionTrigger.reset_index_action, arg1.actionName) then
		arg0.actionListIndex = 1
	end

	if arg0.revertActionIndex and arg0.lastActionIndex ~= arg0.actionListIndex then
		arg0:setTargetValue(arg0.startValue)
	end

	arg0.l2dIdleIndex = arg1.idleIndex
	arg0.l2dIsPlaying = arg1.isPlaying
	arg0.l2dIgnoreReact = arg1.ignoreReact
	arg0.l2dPlayActionName = arg1.actionName

	if not arg0.l2dIsPlaying and arg0.isTriggerAtion then
		arg0:setTriggerActionFlag(false)
	end

	if arg0.l2dIdleIndex and arg0.idleOn and #arg0.idleOn > 0 then
		arg0.reactConditionFlag = table.contains(arg0.idleOn, arg0.l2dIdleIndex)
	end

	if arg0.l2dIdleIndex and arg0.idleOff and #arg0.idleOff > 0 then
		arg0.reactConditionFlag = not table.contains(arg0.idleOff, arg0.l2dIdleIndex)
	end
end

function var0.checkClickAction(arg0)
	if arg0.firstActive then
		arg0:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
			ableFlag = true
		})
	elseif arg0.firstStop then
		local var0 = math.abs(arg0.mouseInputUp.x - arg0.mouseInputDown.x) < 30 and math.abs(arg0.mouseInputUp.y - arg0.mouseInputDown.y) < 30
		local var1 = arg0.mouseInputUpTime - arg0.mouseInputDownTime < 0.5

		if var0 and var1 and not arg0.l2dIsPlaying then
			arg0.clickTriggerTime = 0.01
			arg0.clickApplyFlag = true
		else
			arg0:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
				ableFlag = false
			})
		end
	elseif arg0.clickTriggerTime and arg0.clickTriggerTime > 0 then
		arg0.clickTriggerTime = arg0.clickTriggerTime - Time.deltaTime

		if arg0.clickTriggerTime <= 0 then
			arg0.clickTriggerTime = nil

			arg0:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
				ableFlag = false
			})

			if arg0.clickApplyFlag then
				arg0.clickApplyFlag = false

				return true
			end
		end
	end

	return false
end

function var0.saveData(arg0)
	if arg0.revert == -1 and arg0.saveParameterFlag then
		Live2dConst.SaveDragData(arg0.id, arg0.live2dData:GetShipSkinConfig().id, arg0.live2dData.ship.id, arg0.parameterTargetValue)
	end

	if arg0.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		Live2dConst.SetDragActionIndex(arg0.id, arg0.live2dData:GetShipSkinConfig().id, arg0.live2dData.ship.id, arg0.actionListIndex)
	end
end

function var0.loadData(arg0)
	if arg0.revert == -1 and arg0.saveParameterFlag then
		local var0 = Live2dConst.GetDragData(arg0.id, arg0.live2dData:GetShipSkinConfig().id, arg0.live2dData.ship.id)

		if var0 then
			arg0:setParameterValue(var0)
			arg0:setTargetValue(var0)
		end
	end

	if arg0.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		arg0.actionListIndex = Live2dConst.GetDragActionIndex(arg0.id, arg0.live2dData:GetShipSkinConfig().id, arg0.live2dData.ship.id) or 1
	end
end

function var0.clearData(arg0)
	if arg0.revert == -1 then
		arg0:setParameterValue(arg0.startValue)
		arg0:setTargetValue(arg0.startValue)
	end
end

function var0.setTriggerActionFlag(arg0, arg1)
	arg0.isTriggerAtion = arg1
end

function var0.dispose(arg0)
	arg0._active = false
	arg0._parameterCom = nil
	arg0.parameterValue = arg0.startValue
	arg0.parameterTargetValue = 0
	arg0.parameterSmooth = 0
	arg0.mouseInputDown = Vector2(0, 0)
	arg0.live2dData = nil
end

return var0
