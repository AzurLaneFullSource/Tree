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
local var8_0 = 1

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.live2dData = arg2_1
	arg0_1.frameRate = Application.targetFrameRate or 60
	arg0_1.id = arg1_1.id
	arg0_1.drawAbleName = arg1_1.draw_able_name or ""
	arg0_1.parameterName = arg1_1.parameter
	arg0_1.mode = arg1_1.mode and arg1_1.mode ~= 0 and arg1_1.mode or 1
	arg0_1.startValue = arg1_1.start_value or 0
	arg0_1.range = arg1_1.range and arg0_1.range ~= "" and arg1_1.range or {
		0,
		0
	}
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
	arg0_1.offsetCircle = arg1_1.offset_circle or ""
	arg0_1.offsetCirclePos = arg0_1.offsetCircle.pos and arg0_1.offsetCircle.pos or nil
	arg0_1.offsetCircleStart = arg0_1.offsetCircle.start and arg0_1.offsetCircle.start or nil
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
	arg0_1.rangeOffset = arg0_1.range[2] - arg0_1.range[1]
	arg0_1.offsetDragTargetX = arg0_1.startValue
	arg0_1.offsetDragTargetY = arg0_1.startValue
	arg0_1._relationFlag = false
	arg0_1.ableFlag = false

	if arg0_1.relationParameter and arg0_1.relationParameter.list then
		arg0_1._relationFlag = true
	end

	arg0_1.extendActionFlag = false
	arg0_1.parameterComAdd = true
	arg0_1.reactConditionFlag = false
	arg0_1.loadL2dStep = true
end

function var0_0.onListenerEvent(arg0_2, arg1_2, arg2_2)
	arg0_2:onListenerTrigger(arg1_2, arg2_2)

	if not arg0_2.listenerType then
		return
	end

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
								print(arg0_2.parameterName .. "监听 数值变更为" .. arg0_2.parameterTargetValue)
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

			if var15_2 == var8_0 and var6_2 then
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

				if var18_2 and arg0_2.l2dIdleIndex ~= var18_2 then
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

function var0_0.onListenerTrigger(arg0_3, arg1_3, arg2_3)
	if arg0_3.actionTrigger.click_cd and arg1_3 == Live2D.ON_ACTION_DRAG_CLICK and table.contains(arg0_3.actionTrigger.click_cd, arg2_3.draw_able_name) then
		arg0_3.nextTriggerTime = arg0_3.limitTime
	end
end

function var0_0.getChangeCheckName(arg0_4, arg1_4, arg2_4)
	if arg1_4 == Live2D.ON_ACTION_PLAY then
		return arg2_4.action
	elseif arg1_4 == Live2D.ON_ACTION_DRAG_CLICK then
		return arg2_4.draw_able_name
	elseif arg1_4 == Live2D.ON_ACTION_CHANGE_IDLE then
		return arg2_4.idle
	elseif arg1_4 == Live2D.ON_ACTION_PARAMETER then
		-- block empty
	elseif arg1_4 == Live2D.ON_ACTION_DOWN then
		-- block empty
	elseif arg1_4 == Live2D.ON_ACTION_XY_TRIGGER then
		-- block empty
	elseif arg1_4 == Live2D.ON_ACTION_DRAG_TRIGGER then
		-- block empty
	end

	return nil
end

function var0_0.startDrag(arg0_5, arg1_5)
	if arg0_5.ignoreAction and arg0_5.l2dIsPlaying then
		return
	end

	print(arg0_5.drawAbleName .. " 按下了")

	if not arg0_5._active then
		arg0_5._active = true
		arg0_5.mouseInputDown = Input.mousePosition
		arg0_5.mouseInputDownTime = Time.time
		arg0_5.triggerActionTime = 0

		if table.contains(var2_0, arg0_5.actionTrigger.type) then
			arg0_5.actionListIndex = 1
		end

		arg0_5.parameterSmoothTime = arg0_5.smooth
	end
end

function var0_0.stopDrag(arg0_6, arg1_6)
	if arg0_6._active then
		arg0_6._active = false

		if arg0_6.revert > 0 then
			arg0_6.parameterToStart = arg0_6.revert / 1000
			arg0_6.parameterSmoothTime = arg0_6.smoothRevert
		end

		if arg0_6.offsetDragX then
			arg0_6.offsetDragTargetX = arg0_6:fixParameterTargetValue(arg0_6.offsetDragX, arg0_6.range, arg0_6.rangeAbs, arg0_6.dragDirect)
		end

		if arg0_6.offsetDragY then
			arg0_6.offsetDragTargetY = arg0_6:fixParameterTargetValue(arg0_6.offsetDragY, arg0_6.range, arg0_6.rangeAbs, arg0_6.dragDirect)
		end

		arg0_6:checkResetTriggerTime()

		arg0_6.mouseInputUp = Input.mousePosition
		arg0_6.mouseInputUpTime = Time.time
		arg0_6.mouseWorld = nil
		arg0_6.circleDragWorld = nil

		arg0_6:updatePartsParameter()
		arg0_6:saveData()
	end
end

function var0_0.onDrag(arg0_7, arg1_7)
	arg0_7.mouseWorld = arg1_7.pointerCurrentRaycast.worldPosition
end

function var0_0.checkResetTriggerTime(arg0_8)
	local var0_8 = false

	if arg0_8.actionTrigger.type == Live2D.DRAG_DOWN_ACTION and arg0_8.actionTrigger.last then
		var0_8 = true
	end

	if var0_8 then
		arg0_8:resetNextTriggerTime()
	end
end

function var0_0.resetNextTriggerTime(arg0_9)
	arg0_9.nextTriggerTime = 0
end

function var0_0.updatePartsParameter(arg0_10)
	if type(arg0_10.partsData) == "table" then
		local var0_10 = arg0_10.partsData.parts
		local var1_10 = arg0_10.partsData.type
		local var2_10 = false

		if arg0_10.offsetX or arg0_10.offsetY then
			var2_10 = true
		elseif arg0_10.actionTrigger and arg0_10.actionTrigger.type == Live2D.DRAG_DOWN_TOUCH then
			var2_10 = true
		elseif arg0_10.offsetCirclePos then
			var2_10 = true
		end

		if var2_10 then
			local var3_10 = arg0_10.parameterTargetValue
			local var4_10
			local var5_10

			for iter0_10 = 1, #var0_10 do
				local var6_10 = var0_10[iter0_10]
				local var7_10 = math.abs(var3_10 - var6_10)

				if var1_10 == var3_0 or not var1_10 then
					if not var4_10 or var7_10 < var4_10 then
						var4_10 = var7_10
						var5_10 = iter0_10
					end
				elseif var1_10 == var4_0 then
					if var6_10 <= var3_10 and (not var4_10 or var7_10 < var4_10) then
						var4_10 = var7_10
						var5_10 = iter0_10
					end
				elseif var1_10 == var5_0 and var3_10 <= var6_10 and (not var4_10 or var7_10 < var4_10) then
					var4_10 = var7_10
					var5_10 = iter0_10
				end
			end

			if var5_10 then
				if math.abs(arg0_10.parameterTargetValue - var0_10[var5_10]) >= 0.05 then
					print("吸附数值" .. var0_10[var5_10])
				end

				arg0_10:setTargetValue(var0_10[var5_10])
			end
		end
	end
end

function var0_0.getIgnoreReact(arg0_11)
	return arg0_11.ignoreReact
end

function var0_0.setParameterCom(arg0_12, arg1_12)
	if not arg1_12 then
		-- block empty
	end

	arg0_12._parameterCom = arg1_12
end

function var0_0.getParameterCom(arg0_13)
	return arg0_13._parameterCom
end

function var0_0.addRelationComData(arg0_14, arg1_14, arg2_14)
	table.insert(arg0_14._relationParameterList, {
		com = arg1_14,
		data = arg2_14
	})
end

function var0_0.getRelationParameterList(arg0_15)
	return arg0_15._relationParameterList
end

function var0_0.getReactCondition(arg0_16)
	return arg0_16.reactConditionFlag
end

function var0_0.getActive(arg0_17)
	return arg0_17._active
end

function var0_0.getParameterUpdateFlag(arg0_18)
	return arg0_18._parameterUpdateFlag
end

function var0_0.setEventCallback(arg0_19, arg1_19)
	arg0_19._eventCallback = arg1_19
end

function var0_0.onEventCallback(arg0_20, arg1_20, arg2_20, arg3_20)
	if arg1_20 == Live2D.EVENT_ACTION_APPLY then
		local var0_20 = {}
		local var1_20
		local var2_20 = false
		local var3_20
		local var4_20
		local var5_20
		local var6_20 = false

		if arg0_20.actionTrigger.action then
			var1_20 = arg0_20:fillterAction(arg0_20.actionTrigger.action)
			var0_20 = arg0_20.actionTriggerActive
			var2_20 = arg0_20.actionTrigger.focus or false
			var3_20 = arg0_20.actionTrigger.target or nil
			var6_20 = arg0_20.actionTrigger.target_focus == 1 and true or false

			if (arg0_20.actionTrigger.circle or nil) and var3_20 and var3_20 == arg0_20.parameterTargetValue then
				var3_20 = arg0_20.startValue
			end

			var4_20 = arg0_20.actionTrigger.react or nil

			arg0_20:triggerAction()
			arg0_20:stopDrag()
		elseif arg0_20.actionTrigger.action_list then
			local var7_20 = arg0_20.actionTrigger.action_list[arg0_20.actionListIndex]

			var1_20 = arg0_20:fillterAction(var7_20.action)

			if arg0_20.actionTriggerActive.active_list and arg0_20.actionListIndex <= #arg0_20.actionTriggerActive.active_list then
				var0_20 = arg0_20.actionTriggerActive.active_list[arg0_20.actionListIndex]
			else
				var0_20 = arg0_20.actionTriggerActive
			end

			var2_20 = var7_20.focus or true
			var3_20 = var7_20.target or nil
			var6_20 = var7_20.target_focus == 1 and true or false
			var4_20 = var7_20.react or nil

			if var1_20 and #var1_20 > 0 then
				arg0_20:triggerAction()
			end

			if arg0_20.actionListIndex == #arg0_20.actionTrigger.action_list then
				arg0_20:stopDrag()

				arg0_20.actionListIndex = 1
			else
				arg0_20.actionListIndex = arg0_20.actionListIndex + 1
			end

			print("id = " .. arg0_20.id .. " action list index = " .. arg0_20.actionListIndex)
		elseif not arg0_20.actionTrigger.action then
			var1_20 = arg0_20:fillterAction(arg0_20.actionTrigger.action)
			var0_20 = arg0_20.actionTriggerActive
			var2_20 = arg0_20.actionTrigger.focus or false
			var3_20 = arg0_20.actionTrigger.target or nil
			var6_20 = arg0_20.actionTrigger.target_focus == 1 and true or false

			local var8_20 = arg0_20.actionTrigger.circle or nil

			var4_20 = arg0_20.actionTrigger.react or nil

			if var8_20 and var3_20 and var3_20 == arg0_20.parameterTargetValue then
				var3_20 = arg0_20.startValue
			end

			arg0_20:triggerAction()
			arg0_20:setTriggerActionFlag(false)
			arg0_20:stopDrag()
		end

		if var0_20.idle then
			if type(var0_20.idle) == "number" then
				if var0_20.idle == arg0_20.l2dIdleIndex and not var0_20.repeat_flag then
					return
				end
			elseif type(var0_20.idle) == "table" and #var0_20.idle == 1 and var0_20.idle[1] == arg0_20.l2dIdleIndex and not var0_20.repeat_flag then
				return
			end
		end

		print("执行aplly数据 id = " .. arg0_20.id .. "播放action = " .. tostring(var1_20) .. " active idle is " .. tostring(var0_20.idle))

		if var3_20 then
			arg0_20:setTargetValue(var3_20)

			if var6_20 then
				arg0_20:setParameterValue(var3_20)
			end

			if not var1_20 then
				arg0_20.revertResetFlag = true
			end
		end

		arg2_20 = {
			id = arg0_20.id,
			action = var1_20,
			activeData = var0_20,
			focus = var2_20,
			react = var4_20,
			callback = arg3_20,
			finishCall = function()
				arg0_20:actionApplyFinish()
			end
		}
	elseif arg1_20 == Live2D.EVENT_ACTION_ABLE then
		-- block empty
	elseif arg1_20 == Live2D.EVENT_CHANGE_IDLE_INDEX then
		print("change idle")
	elseif arg1_20 == Live2D.EVENT_GET_PARAMETER then
		arg2_20.callback = arg3_20
	elseif arg1_20 == Live2D.EVENT_GET_DRAG_PARAMETER then
		arg2_20.callback = arg3_20
	elseif arg1_20 == Live2D.EVENT_GET_WORLD_POSITION then
		arg2_20.callback = arg3_20
	end

	arg0_20._eventCallback(arg1_20, arg2_20)
end

function var0_0.fillterAction(arg0_22, arg1_22)
	if type(arg1_22) == "table" then
		return arg1_22[math.random(1, #arg1_22)]
	else
		return arg1_22
	end
end

function var0_0.onEventNotice(arg0_23, arg1_23)
	if arg0_23._eventCallback then
		local var0_23 = arg0_23:getCommonNoticeData()

		arg0_23._eventCallback(arg1_23, var0_23)
	end
end

function var0_0.getCommonNoticeData(arg0_24)
	return {
		draw_able_name = arg0_24.drawAbleName,
		parameter_name = arg0_24.parameterName,
		parameter_target = arg0_24.parameterTargetValue
	}
end

function var0_0.setTargetValue(arg0_25, arg1_25)
	arg0_25.parameterTargetValue = arg1_25
end

function var0_0.getParameter(arg0_26)
	return arg0_26.parameterValue
end

function var0_0.getParameToTargetFlag(arg0_27)
	if arg0_27.parameterValue ~= arg0_27.parameterTargetValue then
		return true
	end

	if arg0_27.parameterToStart and arg0_27.parameterToStart > 0 then
		return true
	end

	return false
end

function var0_0.actionApplyFinish(arg0_28)
	return
end

function var0_0.stepParameter(arg0_29, arg1_29)
	arg0_29:updateStepData(arg1_29)
	arg0_29:updateState()
	arg0_29:updateTrigger()
	arg0_29:updateParameterUpdateFlag()
	arg0_29:updateGyro()
	arg0_29:updateDrag()
	arg0_29:updateCircleDrag()
	arg0_29:updateReactValue()
	arg0_29:updateParameterValue()
	arg0_29:updateRelationValue()
	arg0_29:checkReset()

	arg0_29.loadL2dStep = false
end

function var0_0.updateStepData(arg0_30, arg1_30)
	arg0_30.reactPos = arg1_30.reactPos
	arg0_30.lastNormalTime = arg0_30.normalTime
	arg0_30.normalTime = arg1_30.normalTime
	arg0_30.stateInfo = arg1_30.stateInfo
end

function var0_0.updateParameterUpdateFlag(arg0_31)
	if arg0_31.actionTrigger.type == Live2D.DRAG_CLICK_ACTION then
		arg0_31._parameterUpdateFlag = true
	elseif arg0_31.actionTrigger.type == Live2D.DRAG_RELATION_IDLE then
		if not arg0_31._parameterUpdateFlag then
			if not arg0_31.l2dIsPlaying then
				arg0_31._parameterUpdateFlag = true

				arg0_31:changeParameComAble(true)
			elseif not table.contains(arg0_31.actionTrigger.remove_com_list, arg0_31.l2dPlayActionName) then
				arg0_31._parameterUpdateFlag = true

				arg0_31:changeParameComAble(true)
			end
		elseif arg0_31._parameterUpdateFlag == true and arg0_31.l2dIsPlaying and table.contains(arg0_31.actionTrigger.remove_com_list, arg0_31.l2dPlayActionName) then
			arg0_31._parameterUpdateFlag = false

			arg0_31:changeParameComAble(false)
		end
	elseif arg0_31.actionTrigger.type == Live2D.DRAG_DOWN_TOUCH then
		arg0_31._parameterUpdateFlag = true
	elseif arg0_31.actionTrigger.type == Live2D.DRAG_LISTENER_EVENT then
		arg0_31._parameterUpdateFlag = true
	else
		arg0_31._parameterUpdateFlag = false
	end
end

function var0_0.changeParameComAble(arg0_32, arg1_32)
	if arg0_32.parameterComAdd == arg1_32 then
		return
	end

	arg0_32.parameterComAdd = arg1_32

	if arg1_32 then
		arg0_32:onEventCallback(Live2D.EVENT_ADD_PARAMETER_COM, {
			com = arg0_32._parameterCom,
			start = arg0_32.startValue,
			mode = arg0_32.mode
		})
	else
		arg0_32:onEventCallback(Live2D.EVENT_REMOVE_PARAMETER_COM, {
			com = arg0_32._parameterCom,
			mode = arg0_32.mode
		})
	end
end

function var0_0.updateDrag(arg0_33)
	if not arg0_33.offsetX and not arg0_33.offsetY then
		return
	end

	local var0_33

	if arg0_33._active then
		local var1_33 = Input.mousePosition

		if arg0_33.offsetX and arg0_33.offsetX ~= 0 then
			local var2_33 = var1_33.x - arg0_33.mouseInputDown.x

			var0_33 = arg0_33.offsetDragTargetX + var2_33 / arg0_33.offsetX
			arg0_33.offsetDragX = var0_33
		end

		if arg0_33.offsetY and arg0_33.offsetY ~= 0 then
			local var3_33 = var1_33.y - arg0_33.mouseInputDown.y

			var0_33 = arg0_33.offsetDragTargetY + var3_33 / arg0_33.offsetY
			arg0_33.offsetDragY = var0_33
		end

		if var0_33 then
			arg0_33:setTargetValue(arg0_33:fixParameterTargetValue(var0_33, arg0_33.range, arg0_33.rangeAbs, arg0_33.dragDirect))
		end
	end

	arg0_33._parameterUpdateFlag = true
end

function var0_0.updateCircleDrag(arg0_34)
	if not arg0_34.offsetCirclePos then
		return
	end

	if arg0_34._active and arg0_34.mouseWorld ~= nil then
		if not arg0_34.circleDragWorld then
			arg0_34:onEventCallback(Live2D.EVENT_GET_WORLD_POSITION, {
				pos = arg0_34.offsetCirclePos,
				name = arg0_34.drawAbleName
			}, function(arg0_35)
				arg0_34.circleDragWorld = arg0_35
			end)
		end

		local var0_34 = (math.atan2(arg0_34.mouseWorld.x - arg0_34.circleDragWorld.x, arg0_34.mouseWorld.y - arg0_34.circleDragWorld.y) * math.rad2Deg + 360 - arg0_34.offsetCircleStart) % 360 / 360
		local var1_34 = arg0_34.range[2] * var0_34

		arg0_34:setTargetValue(var1_34)

		arg0_34._parameterUpdateFlag = true
	elseif arg0_34.parameterTargetValue ~= arg0_34.parameterValue then
		arg0_34._parameterUpdateFlag = true
	end
end

function var0_0.updateGyro(arg0_36)
	if not arg0_36.gyro then
		return
	end

	if not Input.gyro.enabled then
		arg0_36:setTargetValue(0)

		arg0_36._parameterUpdateFlag = true

		return
	end

	local var0_36 = Input.gyro and Input.gyro.attitude or Vector3.zero
	local var1_36 = 0

	if arg0_36.gyroX and not math.isnan(var0_36.y) then
		var1_36 = Mathf.Clamp(var0_36.y * arg0_36.sensitive, -0.5, 0.5)
	elseif arg0_36.gyroY and not math.isnan(var0_36.x) then
		var1_36 = Mathf.Clamp(var0_36.x * arg0_36.sensitive, -0.5, 0.5)
	elseif arg0_36.gyroZ and not math.isnan(var0_36.z) then
		var1_36 = Mathf.Clamp(var0_36.z * arg0_36.sensitive, -0.5, 0.5)
	end

	if IsUnityEditor then
		if L2D_USE_RANDOM_ATTI then
			if arg0_36.randomAttitudeIndex == 0 then
				var1_36 = math.random() - 0.5

				local var2_36 = (var1_36 + 0.5) * (arg0_36.range[2] - arg0_36.range[1]) + arg0_36.range[1]

				arg0_36:setTargetValue(var2_36)

				arg0_36.randomAttitudeIndex = L2D_RANDOM_PARAM
			elseif arg0_36.randomAttitudeIndex > 0 then
				arg0_36.randomAttitudeIndex = arg0_36.randomAttitudeIndex - 1
			end
		end
	else
		local var3_36 = (var1_36 + 0.5) * (arg0_36.range[2] - arg0_36.range[1]) + arg0_36.range[1]

		arg0_36:setTargetValue(var3_36)
	end

	arg0_36._parameterUpdateFlag = true
end

function var0_0.updateReactValue(arg0_37)
	if not arg0_37.reactX and not arg0_37.reactY then
		return
	end

	local var0_37
	local var1_37 = false

	if arg0_37.l2dIgnoreReact then
		var0_37 = arg0_37.parameterTargetValue
	elseif arg0_37.reactX then
		var0_37 = arg0_37.reactPos.x * arg0_37.reactX
		var1_37 = true
	else
		var0_37 = arg0_37.reactPos.y * arg0_37.reactY
		var1_37 = true
	end

	if var1_37 then
		arg0_37:setTargetValue(arg0_37:fixParameterTargetValue(var0_37, arg0_37.range, arg0_37.rangeAbs, arg0_37.dragDirect))
	end

	arg0_37._parameterUpdateFlag = true
end

function var0_0.updateParameterValue(arg0_38)
	if arg0_38.prepareTargetValue and not arg0_38.l2dIsPlaying then
		arg0_38:setTargetValue(arg0_38.prepareTargetValue)

		arg0_38.prepareTargetValue = nil
	end

	if arg0_38._parameterUpdateFlag and arg0_38.parameterValue ~= arg0_38.parameterTargetValue then
		if math.abs(arg0_38.parameterValue - arg0_38.parameterTargetValue) < 0.01 then
			arg0_38:setParameterValue(arg0_38.parameterTargetValue)
		elseif arg0_38.parameterSmoothTime and arg0_38.parameterSmoothTime > 0 then
			local var0_38 = arg0_38.parameterValue
			local var1_38 = arg0_38.parameterTargetValue
			local var2_38 = arg0_38:checkUpdateParameterNum(var1_38, var0_38)
			local var3_38, var4_38 = Mathf.SmoothDamp(var0_38, var2_38, arg0_38.parameterSmooth, arg0_38.parameterSmoothTime)

			arg0_38:setParameterValue(var3_38, var4_38)
		else
			arg0_38:setParameterValue(arg0_38.parameterTargetValue, 0)
		end
	end
end

function var0_0.checkUpdateParameterNum(arg0_39, arg1_39, arg2_39)
	if arg0_39.offsetCirclePos and math.abs(arg1_39 - arg2_39) >= arg0_39.rangeOffset / 2 then
		if arg2_39 < arg1_39 then
			arg1_39 = arg1_39 - arg0_39.rangeOffset
		else
			arg1_39 = arg1_39 + arg0_39.rangeOffset
		end
	end

	return arg1_39
end

function var0_0.updateRelationValue(arg0_40)
	for iter0_40, iter1_40 in ipairs(arg0_40._relationParameterList) do
		local var0_40 = iter1_40.data
		local var1_40 = var0_40.type
		local var2_40 = var0_40.relation_value
		local var3_40 = var0_40.target
		local var4_40
		local var5_40

		if var1_40 == Live2D.relation_type_drag_x then
			var4_40 = arg0_40.offsetDragX or iter1_40.start or arg0_40.startValue or 0
			var5_40 = true
		elseif var1_40 == Live2D.relation_type_drag_y then
			var4_40 = arg0_40.offsetDragY or iter1_40.start or arg0_40.startValue or 0
			var5_40 = true
		elseif var1_40 == Live2D.relation_type_action_index then
			var4_40 = var2_40[arg0_40.actionListIndex]
			var4_40 = var4_40 or 0
			var5_40 = true
		elseif var1_40 == Live2D.relation_type_idle then
			if arg0_40.loadL2dStep and arg0_40.l2dIdleIndex == var0_40.idle then
				var5_40 = true
			end

			if arg0_40.l2dIsPlaying then
				if arg0_40.l2dPlayActionName == arg0_40.actionTrigger.action then
					arg0_40.relationActive = true
				end
			else
				arg0_40.relationActive = false
				arg0_40.relationCountTime = nil
			end

			if not var5_40 and arg0_40.relationActive and arg0_40.l2dIdleIndex == var0_40.idle then
				if not arg0_40.relationCountTime then
					arg0_40.relationCountTime = Time.GetTimestamp() + var0_40.time
				end

				if arg0_40.relationCountTime and Time.GetTimestamp() >= arg0_40.relationCountTime then
					var5_40 = true
				end
			end
		else
			var4_40 = arg0_40.parameterTargetValue
			var5_40 = false
		end

		local var6_40
		local var7_40

		if var3_40 then
			var6_40 = var3_40
		else
			local var8_40 = arg0_40:fixRelationParameter(var4_40, var0_40)
			local var9_40 = iter1_40.value or arg0_40.startValue
			local var10_40 = iter1_40.parameterSmooth or 0
			local var11_40 = var0_40.smooth and var0_40.smooth / 1000 or arg0_40.smooth

			var6_40, var7_40 = Mathf.SmoothDamp(var9_40, var8_40, var10_40, var11_40)
		end

		iter1_40.value = var6_40
		iter1_40.parameterSmooth = var7_40
		iter1_40.enable = var5_40
		iter1_40.comId = arg0_40.id
	end
end

function var0_0.fixRelationParameter(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg2_41.range or arg0_41.range
	local var1_41 = arg2_41.rangeAbs and arg2_41.rangeAbs == 1 or arg0_41.rangeAbs
	local var2_41 = arg2_41.drag_direct and arg2_41.drag_direct or arg0_41.dragDirect

	return arg0_41:fixParameterTargetValue(arg1_41, var0_41, var1_41, var2_41)
end

function var0_0.fixParameterTargetValue(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42)
	if arg1_42 < 0 and arg4_42 == 1 then
		arg1_42 = 0
	elseif arg1_42 > 0 and arg4_42 == 2 then
		arg1_42 = 0
	end

	arg1_42 = arg3_42 and math.abs(arg1_42) or arg1_42

	if arg1_42 < arg2_42[1] then
		arg1_42 = arg2_42[1]
	elseif arg1_42 > arg2_42[2] then
		arg1_42 = arg2_42[2]
	end

	return arg1_42
end

function var0_0.checkReset(arg0_43)
	if not arg0_43._active and arg0_43.parameterToStart then
		if arg0_43.parameterToStart > 0 then
			arg0_43.parameterToStart = arg0_43.parameterToStart - Time.deltaTime
		end

		if arg0_43.parameterToStart <= 0 then
			arg0_43:setTargetValue(arg0_43.startValue)

			arg0_43.parameterToStart = nil

			if arg0_43.revertResetFlag then
				arg0_43:setTriggerActionFlag(false)

				arg0_43.revertResetFlag = false
			end

			if arg0_43.offsetDragX then
				arg0_43.offsetDragX = arg0_43.startValue
				arg0_43.offsetDragTargetX = arg0_43.startValue
			end

			if arg0_43.offsetDragY then
				arg0_43.offsetDragY = arg0_43.startValue
				arg0_43.offsetDragTargetY = arg0_43.startValue
			end
		end
	end
end

function var0_0.setParameterValue(arg0_44, arg1_44, arg2_44)
	if arg1_44 then
		arg0_44.parameterValue = arg1_44
	end

	if arg2_44 then
		arg0_44.parameterSmooth = arg2_44
	end
end

function var0_0.updateState(arg0_45)
	if not arg0_45.lastFrameActive and arg0_45._active then
		arg0_45.firstActive = true
	else
		arg0_45.firstActive = false
	end

	if arg0_45.lastFrameActive and not arg0_45._active then
		arg0_45.firstStop = true
	else
		arg0_45.firstStop = false
	end

	arg0_45.lastFrameActive = arg0_45._active
end

function var0_0.updateTrigger(arg0_46)
	if not arg0_46:isActionTriggerAble() then
		return
	end

	local var0_46 = arg0_46.actionTrigger.type
	local var1_46 = arg0_46.actionTrigger.action
	local var2_46

	if arg0_46.actionTrigger.time then
		var2_46 = arg0_46.actionTrigger.time
	elseif arg0_46.actionTrigger.action_list and arg0_46.actionListIndex > 0 then
		var2_46 = arg0_46.actionTrigger.action_list[arg0_46.actionListIndex].time
	end

	local var3_46

	if arg0_46.actionTrigger.num then
		var3_46 = arg0_46.actionTrigger.num
	elseif arg0_46.actionTrigger.action_list and arg0_46.actionTrigger.action_list[arg0_46.actionListIndex].num and arg0_46.actionListIndex > 0 then
		var3_46 = arg0_46.actionTrigger.action_list[arg0_46.actionListIndex].num
	end

	if var0_46 == Live2D.DRAG_TIME_ACTION then
		if arg0_46._active then
			if math.abs(arg0_46.parameterValue - var3_46) < math.abs(var3_46) * 0.25 then
				arg0_46.triggerActionTime = arg0_46.triggerActionTime + Time.deltaTime

				if var2_46 < arg0_46.triggerActionTime and not arg0_46.l2dIsPlaying then
					arg0_46:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_47)
						if arg0_47 then
							arg0_46:onEventNotice(Live2D.ON_ACTION_DRAG_TRIGGER)
						end
					end)
				end
			else
				arg0_46.triggerActionTime = arg0_46.triggerActionTime + 0
			end
		end
	elseif var0_46 == Live2D.DRAG_CLICK_ACTION then
		if arg0_46:checkClickAction() then
			arg0_46:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_48)
				arg0_46:onEventNotice(Live2D.ON_ACTION_DRAG_CLICK)
			end)
		end
	elseif var0_46 == Live2D.DRAG_CLICK_RANGE then
		if arg0_46:checkClickAction() then
			local var4_46 = arg0_46.actionTrigger.parameter and arg0_46.actionTrigger.parameter or arg0_46.parameterName
			local var5_46 = var3_46

			arg0_46:onEventCallback(Live2D.EVENT_GET_PARAMETER, {
				name = var4_46
			}, function(arg0_49)
				print("获取到数值 " .. var4_46 .. " = " .. arg0_49)

				if arg0_49 >= var5_46[1] and arg0_49 < var5_46[2] then
					print("数值范围内，开始触发")
					arg0_46:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_50)
						arg0_46:onEventNotice(Live2D.ON_ACTION_DRAG_CLICK)
					end)
				end
			end)
		end
	elseif var0_46 == Live2D.DRAG_DOWN_ACTION then
		if arg0_46._active then
			arg0_46:setAbleWithFlag(true)

			if var2_46 <= Time.time - arg0_46.mouseInputDownTime then
				print("触发按压动作")
				arg0_46:setAbleWithFlag(false)
				arg0_46:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_51)
					if arg0_51 then
						arg0_46:onEventNotice(Live2D.ON_ACTION_DOWN)
					end
				end)

				if arg0_46.actionListIndex ~= 1 then
					arg0_46:setTriggerActionFlag(false)
				end

				arg0_46:setAbleWithFlag(true)

				arg0_46.mouseInputDownTime = Time.time
			end
		elseif arg0_46.actionTrigger.last and arg0_46.actionListIndex ~= 1 then
			arg0_46.actionListIndex = #arg0_46.actionTrigger.action_list

			arg0_46:setAbleWithFlag(false)
			arg0_46:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_52)
				return
			end)
			arg0_46:resetNextTriggerTime()
			arg0_46:setTriggerActionFlag(false)
		else
			arg0_46:setAbleWithFlag(false)
		end
	elseif var0_46 == Live2D.DRAG_RELATION_XY then
		if arg0_46._active then
			local var6_46 = arg0_46:fixParameterTargetValue(arg0_46.offsetDragX, arg0_46.range, arg0_46.rangeAbs, arg0_46.dragDirect)
			local var7_46 = arg0_46:fixParameterTargetValue(arg0_46.offsetDragY, arg0_46.range, arg0_46.rangeAbs, arg0_46.dragDirect)
			local var8_46 = var3_46[1]
			local var9_46 = var3_46[2]

			if math.abs(var6_46 - var8_46) < math.abs(var8_46) * 0.25 and math.abs(var7_46 - var9_46) < math.abs(var9_46) * 0.25 then
				arg0_46.triggerActionTime = arg0_46.triggerActionTime + Time.deltaTime

				if var2_46 < arg0_46.triggerActionTime and not arg0_46.l2dIsPlaying then
					arg0_46:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_53)
						if arg0_53 then
							arg0_46:onEventNotice(Live2D.ON_ACTION_XY_TRIGGER)
						end
					end)
				end
			else
				arg0_46.triggerActionTime = arg0_46.triggerActionTime + 0
			end
		end
	elseif var0_46 == Live2D.DRAG_RELATION_IDLE then
		if arg0_46.actionTrigger.const_fit then
			for iter0_46 = 1, #arg0_46.actionTrigger.const_fit do
				local var10_46 = arg0_46.actionTrigger.const_fit[iter0_46]

				if arg0_46.l2dIdleIndex == var10_46.idle and not arg0_46.l2dIsPlaying then
					arg0_46:setTargetValue(var10_46.target)
				end
			end
		end
	elseif var0_46 == Live2D.DRAG_CLICK_MANY then
		if arg0_46:checkClickAction() then
			arg0_46:onEventCallback(Live2D.EVENT_ACTION_APPLY)
		end
	elseif var0_46 == Live2D.DRAG_LISTENER_EVENT then
		if arg0_46._listenerTrigger then
			arg0_46:onEventCallback(Live2D.EVENT_ACTION_APPLY)
		end
	elseif var0_46 == Live2D.DRAG_DOWN_TOUCH then
		arg0_46:setAbleWithFlag(arg0_46._active)

		if arg0_46._active then
			local var11_46 = Time.deltaTime / arg0_46.actionTrigger.delta
			local var12_46 = arg0_46.parameterTargetValue + var11_46
			local var13_46 = arg0_46:fixParameterTargetValue(var12_46, arg0_46.range, arg0_46.rangeAbs, arg0_46.dragDirect)

			arg0_46:setTargetValue(var13_46)
		end
	elseif var0_46 == Live2D.DRAG_CLICK_PARAMETER then
		if arg0_46:checkClickAction() then
			local var14_46 = var3_46
			local var15_46 = arg0_46.actionTrigger.parameter

			arg0_46:onEventCallback(Live2D.EVENT_GET_PARAMETER, {
				name = var15_46
			}, function(arg0_54)
				if math.abs(var14_46 - arg0_54) <= 0.05 then
					print("数值允许播放，开始执行动作 " .. arg0_46.actionTrigger.action)
					arg0_46:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_55)
						arg0_46:onEventNotice(Live2D.ON_ACTION_DRAG_CLICK)
					end)
				end
			end)
		end
	elseif var0_46 == Live2D.DRAG_ANIMATION_PLAY then
		local var16_46 = arg0_46.actionTrigger.trigger_name

		if arg0_46.actionTrigger.trigger_index > 0 and arg0_46.actionTrigger.trigger_name == "idle" then
			var16_46 = var16_46 .. arg0_46.actionTrigger.trigger_index
		end

		if arg0_46.stateInfo:IsName(var16_46) and arg0_46.l2dIdleIndex == arg0_46.actionTrigger.trigger_index then
			local var17_46 = false
			local var18_46 = arg0_46.actionTrigger.parameter_range

			if var18_46 then
				local var19_46 = var18_46[1]
				local var20_46 = var18_46[2]

				arg0_46:onEventCallback(Live2D.EVENT_GET_PARAMETER, {
					name = var19_46
				}, function(arg0_56)
					if arg0_56 and arg0_56 >= var20_46[1] and arg0_56 < var20_46[2] then
						var17_46 = true
					end
				end)
			else
				var17_46 = true
			end

			if var17_46 and arg0_46.normalTime >= arg0_46.actionTrigger.trigger_rate then
				arg0_46:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function()
					return
				end)
				arg0_46:setTriggerActionFlag(false)
			end
		end
	elseif var0_46 == Live2D.DRAG_EXTEND_ACTION_RULE and not arg0_46.extendActionFlag then
		arg0_46.extendActionFlag = true
	end
end

function var0_0.getExtendAction(arg0_58)
	return arg0_58.extendActionFlag
end

function var0_0.checkActionInExtendFlag(arg0_59, arg1_59)
	local var0_59 = false
	local var1_59 = false

	if not arg0_59.extendActionFlag then
		return var0_59, var1_59
	end

	local var2_59 = arg0_59.actionTrigger.parameter
	local var3_59 = arg0_59.actionTrigger.num
	local var4_59 = false

	arg0_59:onEventCallback(Live2D.EVENT_GET_DRAG_PARAMETER, {
		name = var2_59
	}, function(arg0_60)
		if arg0_60 > var3_59[1] and arg0_60 <= var3_59[2] then
			var4_59 = true
		end
	end)

	if not var4_59 then
		return var0_59, var0_59
	end

	local var5_59 = arg0_59.actionTriggerActive.ignore
	local var6_59 = arg0_59.actionTriggerActive.enable

	if var5_59 and table.contains(var5_59, arg1_59) then
		var0_59 = true
	end

	if var6_59 and table.contains(var6_59, arg1_59) then
		var1_59 = true
	end

	return var0_59, var1_59
end

function var0_0.setAbleWithFlag(arg0_61, arg1_61)
	if arg0_61.ableFlag ~= arg1_61 then
		arg0_61.ableFlag = arg1_61

		arg0_61:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
			ableFlag = arg1_61
		})
	end
end

function var0_0.triggerAction(arg0_62)
	arg0_62.nextTriggerTime = arg0_62.limitTime

	arg0_62:setTriggerActionFlag(true)
end

function var0_0.isActionTriggerAble(arg0_63)
	if arg0_63.actionTrigger.type == nil then
		return false
	end

	if not arg0_63.actionTrigger or arg0_63.actionTrigger == "" then
		return false
	end

	if arg0_63.nextTriggerTime - Time.deltaTime >= 0 then
		arg0_63.nextTriggerTime = arg0_63.nextTriggerTime - Time.deltaTime

		return false
	end

	if arg0_63.isTriggerAtion then
		return false
	end

	return true
end

function var0_0.updateStateData(arg0_64, arg1_64)
	if arg0_64.l2dIdleIndex ~= arg1_64.idleIndex then
		if type(arg0_64.revertIdleIndex) == "boolean" and arg0_64.revertIdleIndex == true then
			arg0_64:setTargetValue(arg0_64.startValue)
		elseif type(arg0_64.revertIdleIndex) == "table" and table.contains(arg0_64.revertIdleIndex, arg1_64.idleIndex) then
			arg0_64:setTargetValue(arg0_64.startValue)
		end
	end

	arg0_64.lastActionIndex = arg0_64.actionListIndex

	if arg1_64.isPlaying and arg0_64.actionTrigger.reset_index_action and arg1_64.actionName and table.contains(arg0_64.actionTrigger.reset_index_action, arg1_64.actionName) then
		arg0_64.actionListIndex = 1
	end

	if arg0_64.revertActionIndex and arg0_64.lastActionIndex ~= arg0_64.actionListIndex then
		arg0_64:setTargetValue(arg0_64.startValue)
	end

	arg0_64.l2dIdleIndex = arg1_64.idleIndex
	arg0_64.l2dIsPlaying = arg1_64.isPlaying
	arg0_64.l2dIgnoreReact = arg1_64.ignoreReact
	arg0_64.l2dPlayActionName = arg1_64.actionName

	if not arg0_64.l2dIsPlaying and arg0_64.isTriggerAtion then
		arg0_64:setTriggerActionFlag(false)
	end

	if arg0_64.l2dIdleIndex and arg0_64.idleOn and #arg0_64.idleOn > 0 then
		arg0_64.reactConditionFlag = not table.contains(arg0_64.idleOn, arg0_64.l2dIdleIndex)
	end

	if arg0_64.l2dIdleIndex and arg0_64.idleOff and #arg0_64.idleOff > 0 then
		arg0_64.reactConditionFlag = table.contains(arg0_64.idleOff, arg0_64.l2dIdleIndex)
	end
end

function var0_0.checkClickAction(arg0_65)
	if arg0_65.firstActive then
		if arg0_65.actionTrigger.down then
			if not arg0_65.l2dIsPlaying then
				return true
			end
		else
			arg0_65:setAbleWithFlag(true)
		end
	elseif arg0_65.firstStop then
		local var0_65 = math.abs(arg0_65.mouseInputUp.x - arg0_65.mouseInputDown.x) < 30 and math.abs(arg0_65.mouseInputUp.y - arg0_65.mouseInputDown.y) < 30
		local var1_65 = arg0_65.mouseInputUpTime - arg0_65.mouseInputDownTime < 0.5

		if not arg0_65.actionTrigger.down and var0_65 and var1_65 and not arg0_65.l2dIsPlaying then
			arg0_65.clickTriggerTime = 0.01
			arg0_65.clickApplyFlag = true
		else
			arg0_65:setAbleWithFlag(false)
		end
	elseif arg0_65.clickTriggerTime and arg0_65.clickTriggerTime > 0 then
		arg0_65.clickTriggerTime = arg0_65.clickTriggerTime - Time.deltaTime

		if arg0_65.clickTriggerTime <= 0 then
			arg0_65.clickTriggerTime = nil

			arg0_65:setAbleWithFlag(false)

			if arg0_65.clickApplyFlag then
				arg0_65.clickApplyFlag = false

				return true
			end
		end
	end

	return false
end

function var0_0.saveData(arg0_66)
	local var0_66 = arg0_66.id
	local var1_66 = arg0_66.live2dData:GetShipSkinConfig().id
	local var2_66 = arg0_66.live2dData.ship.id

	if arg0_66.revert == -1 and arg0_66.saveParameterFlag then
		Live2dConst.SaveDragData(var0_66, var1_66, var2_66, arg0_66.parameterTargetValue)
	end

	if arg0_66.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		print("保存actionListIndex" .. arg0_66.actionListIndex)
		Live2dConst.SetDragActionIndex(var0_66, var1_66, var2_66, arg0_66.actionListIndex)
	end

	if arg0_66._relationFlag then
		Live2dConst.SetRelationData(var0_66, var1_66, var2_66, arg0_66:getRelationSaveData())
	end
end

function var0_0.loadData(arg0_67)
	local var0_67 = arg0_67.id
	local var1_67 = arg0_67.live2dData:GetShipSkinConfig().id
	local var2_67 = arg0_67.live2dData.ship.id

	if arg0_67.revert == -1 and arg0_67.saveParameterFlag then
		local var3_67 = Live2dConst.GetDragData(arg0_67.id, arg0_67.live2dData:GetShipSkinConfig().id, arg0_67.live2dData.ship.id)

		if var3_67 then
			arg0_67:setParameterValue(var3_67)
			arg0_67:setTargetValue(var3_67)
		end

		if var3_67 == arg0_67.startValue and arg0_67._relationParameterList and #arg0_67._relationParameterList > 0 then
			arg0_67:clearRelationValue()
		end
	end

	if arg0_67.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		arg0_67.actionListIndex = Live2dConst.GetDragActionIndex(arg0_67.id, arg0_67.live2dData:GetShipSkinConfig().id, arg0_67.live2dData.ship.id) or 1
	end

	if arg0_67._relationFlag then
		local var4_67 = Live2dConst.GetRelationData(var0_67, var1_67, var2_67)

		arg0_67.offsetDragX = var4_67.drag_x and var4_67.drag_x or arg0_67.startValue
		arg0_67.offsetDragY = var4_67.drag_y and var4_67.drag_y or arg0_67.startValue
	end
end

function var0_0.getRelationSaveData(arg0_68)
	return {
		[Live2dConst.RELATION_DRAG_X] = arg0_68.offsetDragX,
		[Live2dConst.RELATION_DRAG_Y] = arg0_68.offsetDragY
	}
end

function var0_0.clearRelationValue(arg0_69)
	if arg0_69._relationParameterList and #arg0_69._relationParameterList > 0 then
		for iter0_69 = 1, #arg0_69._relationParameterList do
			local var0_69 = arg0_69._relationParameterList[iter0_69]

			if var0_69.data.type == Live2D.relation_type_drag_x or var0_69.data.type == Live2D.relation_type_drag_y then
				var0_69.value = var0_69.start or arg0_69.startValue or 0
				var0_69.enable = true
			end

			arg0_69.offsetDragX, arg0_69.offsetDragY = arg0_69.startValue, arg0_69.startValue
		end
	end
end

function var0_0.loadL2dFinal(arg0_70)
	arg0_70.loadL2dStep = true
end

function var0_0.clearData(arg0_71)
	if arg0_71.revert == -1 then
		arg0_71.actionListIndex = 1

		arg0_71:setParameterValue(arg0_71.startValue)
		arg0_71:setTargetValue(arg0_71.startValue)
		arg0_71:clearRelationValue()
	end
end

function var0_0.setTriggerActionFlag(arg0_72, arg1_72)
	arg0_72.isTriggerAtion = arg1_72
end

function var0_0.dispose(arg0_73)
	arg0_73._active = false
	arg0_73._parameterCom = nil
	arg0_73.parameterValue = arg0_73.startValue
	arg0_73.parameterTargetValue = 0
	arg0_73.parameterSmooth = 0
	arg0_73.mouseInputDown = Vector2(0, 0)
	arg0_73.live2dData = nil
end

return var0_0
