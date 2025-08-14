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

		arg0_6:setParameterRevert()

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

function var0_0.setParameterRevert(arg0_7)
	if arg0_7.revert > 0 then
		arg0_7.parameterToStart = arg0_7.revert / 1000
		arg0_7.parameterSmoothTime = arg0_7.smoothRevert
	end
end

function var0_0.onDrag(arg0_8, arg1_8)
	arg0_8.mouseWorld = arg1_8.pointerCurrentRaycast.worldPosition
end

function var0_0.checkResetTriggerTime(arg0_9)
	local var0_9 = false

	if arg0_9.actionTrigger.type == Live2D.DRAG_DOWN_ACTION and arg0_9.actionTrigger.last then
		var0_9 = true
	end

	if var0_9 then
		arg0_9:resetNextTriggerTime()
	end
end

function var0_0.resetNextTriggerTime(arg0_10)
	arg0_10.nextTriggerTime = 0
end

function var0_0.updatePartsParameter(arg0_11)
	if type(arg0_11.partsData) == "table" then
		local var0_11 = arg0_11.partsData.parts
		local var1_11 = arg0_11.partsData.type
		local var2_11 = false

		if arg0_11.offsetX or arg0_11.offsetY then
			var2_11 = true
		elseif arg0_11.actionTrigger and arg0_11.actionTrigger.type == Live2D.DRAG_DOWN_TOUCH then
			var2_11 = true
		elseif arg0_11.offsetCirclePos then
			var2_11 = true
		end

		if var2_11 then
			local var3_11 = arg0_11.parameterTargetValue
			local var4_11
			local var5_11

			for iter0_11 = 1, #var0_11 do
				local var6_11 = var0_11[iter0_11]
				local var7_11 = math.abs(var3_11 - var6_11)

				if var1_11 == var3_0 or not var1_11 then
					if not var4_11 or var7_11 < var4_11 then
						var4_11 = var7_11
						var5_11 = iter0_11
					end
				elseif var1_11 == var4_0 then
					if var6_11 <= var3_11 and (not var4_11 or var7_11 < var4_11) then
						var4_11 = var7_11
						var5_11 = iter0_11
					end
				elseif var1_11 == var5_0 and var3_11 <= var6_11 and (not var4_11 or var7_11 < var4_11) then
					var4_11 = var7_11
					var5_11 = iter0_11
				end
			end

			if var5_11 then
				if math.abs(arg0_11.parameterTargetValue - var0_11[var5_11]) >= 0.05 then
					print("吸附数值" .. var0_11[var5_11])
				end

				arg0_11:setTargetValue(var0_11[var5_11])
			end
		end
	end
end

function var0_0.getIgnoreReact(arg0_12)
	return arg0_12.ignoreReact
end

function var0_0.setParameterCom(arg0_13, arg1_13)
	if not arg1_13 then
		-- block empty
	end

	arg0_13._parameterCom = arg1_13
end

function var0_0.getParameterCom(arg0_14)
	return arg0_14._parameterCom
end

function var0_0.addRelationComData(arg0_15, arg1_15, arg2_15)
	table.insert(arg0_15._relationParameterList, {
		com = arg1_15,
		data = arg2_15
	})
end

function var0_0.getRelationParameterList(arg0_16)
	return arg0_16._relationParameterList
end

function var0_0.getReactCondition(arg0_17)
	return arg0_17.reactConditionFlag
end

function var0_0.getActive(arg0_18)
	return arg0_18._active
end

function var0_0.getParameterUpdateFlag(arg0_19)
	return arg0_19._parameterUpdateFlag
end

function var0_0.setEventCallback(arg0_20, arg1_20)
	arg0_20._eventCallback = arg1_20
end

function var0_0.onEventCallback(arg0_21, arg1_21, arg2_21, arg3_21)
	if arg1_21 == Live2D.EVENT_ACTION_APPLY then
		local var0_21 = {}
		local var1_21
		local var2_21 = false
		local var3_21
		local var4_21
		local var5_21
		local var6_21 = false

		if arg0_21.actionTrigger.action then
			var1_21 = arg0_21:fillterAction(arg0_21.actionTrigger.action)
			var0_21 = arg0_21.actionTriggerActive
			var2_21 = arg0_21.actionTrigger.focus == 1 and true or false
			var3_21 = arg0_21.actionTrigger.target or nil
			var6_21 = arg0_21.actionTrigger.target_focus == 1 and true or false

			if (arg0_21.actionTrigger.circle or nil) and var3_21 and var3_21 == arg0_21.parameterTargetValue then
				var3_21 = arg0_21.startValue
			end

			var4_21 = arg0_21.actionTrigger.react or nil

			arg0_21:triggerAction()
			arg0_21:stopDrag()
		elseif arg0_21.actionTrigger.action_list then
			local var7_21 = arg0_21.actionTrigger.action_list[arg0_21.actionListIndex]

			var1_21 = arg0_21:fillterAction(var7_21.action)

			if arg0_21.actionTriggerActive.active_list and arg0_21.actionListIndex <= #arg0_21.actionTriggerActive.active_list then
				var0_21 = arg0_21.actionTriggerActive.active_list[arg0_21.actionListIndex]
			else
				var0_21 = arg0_21.actionTriggerActive
			end

			var2_21 = var7_21.focus == 1 and true or false
			var3_21 = var7_21.target or nil
			var6_21 = var7_21.target_focus == 1 and true or false
			var4_21 = var7_21.react or nil

			if var1_21 and #var1_21 > 0 then
				arg0_21:triggerAction()
			end

			if arg0_21.actionListIndex == #arg0_21.actionTrigger.action_list then
				arg0_21:stopDrag()

				arg0_21.actionListIndex = 1
			else
				arg0_21.actionListIndex = arg0_21.actionListIndex + 1
			end

			print("id = " .. arg0_21.id .. " action list index = " .. arg0_21.actionListIndex)
		elseif not arg0_21.actionTrigger.action then
			var1_21 = arg0_21:fillterAction(arg0_21.actionTrigger.action)
			var0_21 = arg0_21.actionTriggerActive
			var2_21 = arg0_21.actionTrigger.focus == 1 and true or false
			var3_21 = arg0_21.actionTrigger.target or nil
			var6_21 = arg0_21.actionTrigger.target_focus == 1 and true or false

			local var8_21 = arg0_21.actionTrigger.circle or nil

			var4_21 = arg0_21.actionTrigger.react or nil

			if var8_21 and var3_21 and var3_21 == arg0_21.parameterTargetValue then
				var3_21 = arg0_21.startValue
			end

			arg0_21:triggerAction()
			arg0_21:setTriggerActionFlag(false)
			arg0_21:stopDrag()
		end

		if var0_21.idle then
			if type(var0_21.idle) == "number" then
				if var0_21.idle == arg0_21.l2dIdleIndex and not var0_21.repeat_flag then
					return
				end
			elseif type(var0_21.idle) == "table" and #var0_21.idle == 1 and var0_21.idle[1] == arg0_21.l2dIdleIndex and not var0_21.repeat_flag then
				return
			end
		end

		print("执行aplly数据 id = " .. arg0_21.id .. "播放action = " .. tostring(var1_21) .. " active idle is " .. tostring(var0_21.idle))

		if var3_21 then
			arg0_21:setTargetValue(var3_21)

			if var6_21 then
				arg0_21:setParameterValue(var3_21)
			end

			if not var1_21 then
				arg0_21.revertResetFlag = true
			end
		end

		if var2_21 then
			arg0_21:setTriggerActionFlag(false)
		end

		arg2_21 = {
			id = arg0_21.id,
			action = var1_21,
			activeData = var0_21,
			focus = var2_21,
			react = var4_21,
			callback = arg3_21,
			finishCall = function()
				arg0_21:actionApplyFinish()
			end
		}
	elseif arg1_21 == Live2D.EVENT_ACTION_ABLE then
		-- block empty
	elseif arg1_21 == Live2D.EVENT_CHANGE_IDLE_INDEX then
		print("change idle")
	elseif arg1_21 == Live2D.EVENT_GET_PARAMETER then
		arg2_21.callback = arg3_21
	elseif arg1_21 == Live2D.EVENT_GET_DRAG_PARAMETER then
		arg2_21.callback = arg3_21
	elseif arg1_21 == Live2D.EVENT_GET_WORLD_POSITION then
		arg2_21.callback = arg3_21
	end

	arg0_21._eventCallback(arg1_21, arg2_21)
end

function var0_0.fillterAction(arg0_23, arg1_23)
	if type(arg1_23) == "table" then
		return arg1_23[math.random(1, #arg1_23)]
	else
		return arg1_23
	end
end

function var0_0.onEventNotice(arg0_24, arg1_24)
	if arg0_24._eventCallback then
		local var0_24 = arg0_24:getCommonNoticeData()

		arg0_24._eventCallback(arg1_24, var0_24)
	end
end

function var0_0.getCommonNoticeData(arg0_25)
	return {
		draw_able_name = arg0_25.drawAbleName,
		parameter_name = arg0_25.parameterName,
		parameter_target = arg0_25.parameterTargetValue
	}
end

function var0_0.setTargetValue(arg0_26, arg1_26)
	arg0_26.parameterTargetValue = arg1_26
end

function var0_0.getParameter(arg0_27)
	return arg0_27.parameterValue
end

function var0_0.getParameToTargetFlag(arg0_28)
	if arg0_28.parameterValue ~= arg0_28.parameterTargetValue then
		return true
	end

	if arg0_28.parameterToStart and arg0_28.parameterToStart > 0 then
		return true
	end

	return false
end

function var0_0.actionApplyFinish(arg0_29)
	return
end

function var0_0.stepParameter(arg0_30, arg1_30)
	arg0_30:updateStepData(arg1_30)
	arg0_30:updateState()
	arg0_30:updateTrigger()
	arg0_30:updateParameterUpdateFlag()
	arg0_30:updateGyro()
	arg0_30:updateDrag()
	arg0_30:updateCircleDrag()
	arg0_30:updateReactValue()
	arg0_30:updateParameterValue()
	arg0_30:updateRelationValue()
	arg0_30:checkReset()

	arg0_30.loadL2dStep = false
end

function var0_0.updateStepData(arg0_31, arg1_31)
	arg0_31.reactPos = arg1_31.reactPos
	arg0_31.lastNormalTime = arg0_31.normalTime
	arg0_31.normalTime = arg1_31.normalTime
	arg0_31.stateInfo = arg1_31.stateInfo
end

function var0_0.updateParameterUpdateFlag(arg0_32)
	if arg0_32.actionTrigger.type == Live2D.DRAG_CLICK_ACTION then
		arg0_32._parameterUpdateFlag = true
	elseif arg0_32.actionTrigger.type == Live2D.DRAG_RELATION_IDLE then
		if not arg0_32._parameterUpdateFlag then
			if not arg0_32.l2dIsPlaying then
				arg0_32._parameterUpdateFlag = true

				arg0_32:changeParameComAble(true)
			elseif not table.contains(arg0_32.actionTrigger.remove_com_list, arg0_32.l2dPlayActionName) then
				arg0_32._parameterUpdateFlag = true

				arg0_32:changeParameComAble(true)
			end
		elseif arg0_32._parameterUpdateFlag == true and arg0_32.l2dIsPlaying and table.contains(arg0_32.actionTrigger.remove_com_list, arg0_32.l2dPlayActionName) then
			arg0_32._parameterUpdateFlag = false

			arg0_32:changeParameComAble(false)
		end
	elseif arg0_32.actionTrigger.type == Live2D.DRAG_DOWN_TOUCH then
		arg0_32._parameterUpdateFlag = true
	elseif arg0_32.actionTrigger.type == Live2D.DRAG_LISTENER_EVENT then
		arg0_32._parameterUpdateFlag = true
	elseif arg0_32.actionTrigger.type == Live2D.DRAG_ANIMATION_PLAY then
		arg0_32._parameterUpdateFlag = true
	elseif arg0_32.actionTrigger.type == Live2D.DRAG_WITH_PARAMETER_MOVE then
		arg0_32._parameterUpdateFlag = true
	else
		arg0_32._parameterUpdateFlag = false
	end
end

function var0_0.changeParameComAble(arg0_33, arg1_33)
	if arg0_33.parameterComAdd == arg1_33 then
		return
	end

	arg0_33.parameterComAdd = arg1_33

	if arg1_33 then
		arg0_33:onEventCallback(Live2D.EVENT_ADD_PARAMETER_COM, {
			com = arg0_33._parameterCom,
			start = arg0_33.startValue,
			mode = arg0_33.mode
		})
	else
		arg0_33:onEventCallback(Live2D.EVENT_REMOVE_PARAMETER_COM, {
			com = arg0_33._parameterCom,
			mode = arg0_33.mode
		})
	end
end

function var0_0.updateDrag(arg0_34)
	if not arg0_34.offsetX and not arg0_34.offsetY then
		return
	end

	local var0_34

	if arg0_34._active then
		local var1_34 = Input.mousePosition

		if arg0_34.offsetX and arg0_34.offsetX ~= 0 then
			local var2_34 = var1_34.x - arg0_34.mouseInputDown.x

			var0_34 = arg0_34.offsetDragTargetX + var2_34 / arg0_34.offsetX
			arg0_34.offsetDragX = var0_34
		end

		if arg0_34.offsetY and arg0_34.offsetY ~= 0 then
			local var3_34 = var1_34.y - arg0_34.mouseInputDown.y

			var0_34 = arg0_34.offsetDragTargetY + var3_34 / arg0_34.offsetY
			arg0_34.offsetDragY = var0_34
		end

		if var0_34 then
			arg0_34:setTargetValue(arg0_34:fixParameterTargetValue(var0_34, arg0_34.range, arg0_34.rangeAbs, arg0_34.dragDirect))
		end
	end

	arg0_34._parameterUpdateFlag = true
end

function var0_0.updateCircleDrag(arg0_35)
	if not arg0_35.offsetCirclePos then
		return
	end

	if arg0_35._active and arg0_35.mouseWorld ~= nil then
		if not arg0_35.circleDragWorld then
			arg0_35:onEventCallback(Live2D.EVENT_GET_WORLD_POSITION, {
				pos = arg0_35.offsetCirclePos,
				name = arg0_35.drawAbleName
			}, function(arg0_36)
				arg0_35.circleDragWorld = arg0_36
			end)
		end

		local var0_35 = (math.atan2(arg0_35.mouseWorld.x - arg0_35.circleDragWorld.x, arg0_35.mouseWorld.y - arg0_35.circleDragWorld.y) * math.rad2Deg + 360 - arg0_35.offsetCircleStart) % 360 / 360
		local var1_35 = arg0_35.range[2] * var0_35

		arg0_35:setTargetValue(var1_35)

		arg0_35._parameterUpdateFlag = true
	elseif arg0_35.parameterTargetValue ~= arg0_35.parameterValue then
		arg0_35._parameterUpdateFlag = true
	end
end

function var0_0.updateGyro(arg0_37)
	if not arg0_37.gyro then
		return
	end

	if not Input.gyro.enabled then
		arg0_37:setTargetValue(0)

		arg0_37._parameterUpdateFlag = true

		return
	end

	local var0_37 = Input.gyro and Input.gyro.attitude or Vector3.zero
	local var1_37 = 0

	if arg0_37.gyroX and not math.isnan(var0_37.y) then
		var1_37 = Mathf.Clamp(var0_37.y * arg0_37.sensitive, -0.5, 0.5)
	elseif arg0_37.gyroY and not math.isnan(var0_37.x) then
		var1_37 = Mathf.Clamp(var0_37.x * arg0_37.sensitive, -0.5, 0.5)
	elseif arg0_37.gyroZ and not math.isnan(var0_37.z) then
		var1_37 = Mathf.Clamp(var0_37.z * arg0_37.sensitive, -0.5, 0.5)
	end

	if IsUnityEditor then
		if L2D_USE_RANDOM_ATTI then
			if arg0_37.randomAttitudeIndex == 0 then
				var1_37 = math.random() - 0.5

				local var2_37 = (var1_37 + 0.5) * (arg0_37.range[2] - arg0_37.range[1]) + arg0_37.range[1]

				arg0_37:setTargetValue(var2_37)

				arg0_37.randomAttitudeIndex = L2D_RANDOM_PARAM
			elseif arg0_37.randomAttitudeIndex > 0 then
				arg0_37.randomAttitudeIndex = arg0_37.randomAttitudeIndex - 1
			end
		end
	else
		local var3_37 = (var1_37 + 0.5) * (arg0_37.range[2] - arg0_37.range[1]) + arg0_37.range[1]

		arg0_37:setTargetValue(var3_37)
	end

	arg0_37._parameterUpdateFlag = true
end

function var0_0.updateReactValue(arg0_38)
	if not arg0_38.reactX and not arg0_38.reactY then
		return
	end

	local var0_38
	local var1_38 = false

	if arg0_38.l2dIgnoreReact then
		var0_38 = arg0_38.parameterTargetValue
	elseif arg0_38.reactX then
		var0_38 = arg0_38.reactPos.x * arg0_38.reactX
		var1_38 = true
	else
		var0_38 = arg0_38.reactPos.y * arg0_38.reactY
		var1_38 = true
	end

	if var1_38 then
		arg0_38:setTargetValue(arg0_38:fixParameterTargetValue(var0_38, arg0_38.range, arg0_38.rangeAbs, arg0_38.dragDirect))
	end

	arg0_38._parameterUpdateFlag = true
end

function var0_0.updateParameterValue(arg0_39)
	if arg0_39.prepareTargetValue and not arg0_39.l2dIsPlaying then
		arg0_39:setTargetValue(arg0_39.prepareTargetValue)

		arg0_39.prepareTargetValue = nil
	end

	if arg0_39._parameterUpdateFlag and arg0_39.parameterValue ~= arg0_39.parameterTargetValue then
		if math.abs(arg0_39.parameterValue - arg0_39.parameterTargetValue) < 0.01 then
			arg0_39:setParameterValue(arg0_39.parameterTargetValue)
		elseif arg0_39.parameterSmoothTime and arg0_39.parameterSmoothTime > 0 then
			local var0_39 = arg0_39.parameterValue
			local var1_39 = arg0_39.parameterTargetValue
			local var2_39 = arg0_39:checkUpdateParameterNum(var1_39, var0_39)
			local var3_39, var4_39 = Mathf.SmoothDamp(var0_39, var2_39, arg0_39.parameterSmooth, arg0_39.parameterSmoothTime)

			arg0_39:setParameterValue(var3_39, var4_39)
		else
			arg0_39:setParameterValue(arg0_39.parameterTargetValue, 0)
		end
	end
end

function var0_0.checkUpdateParameterNum(arg0_40, arg1_40, arg2_40)
	if arg0_40.offsetCirclePos and math.abs(arg1_40 - arg2_40) >= arg0_40.rangeOffset / 2 then
		if arg2_40 < arg1_40 then
			arg1_40 = arg1_40 - arg0_40.rangeOffset
		else
			arg1_40 = arg1_40 + arg0_40.rangeOffset
		end
	end

	return arg1_40
end

function var0_0.updateRelationValue(arg0_41)
	for iter0_41, iter1_41 in ipairs(arg0_41._relationParameterList) do
		local var0_41 = iter1_41.data
		local var1_41 = var0_41.type
		local var2_41 = var0_41.relation_value
		local var3_41 = var0_41.target
		local var4_41
		local var5_41

		if var1_41 == Live2D.relation_type_drag_x then
			var4_41 = arg0_41.offsetDragX or iter1_41.start or arg0_41.startValue or 0
			var5_41 = true
		elseif var1_41 == Live2D.relation_type_drag_y then
			var4_41 = arg0_41.offsetDragY or iter1_41.start or arg0_41.startValue or 0
			var5_41 = true
		elseif var1_41 == Live2D.relation_type_action_index then
			var4_41 = var2_41[arg0_41.actionListIndex]
			var4_41 = var4_41 or 0
			var5_41 = true
		elseif var1_41 == Live2D.relation_type_idle then
			if arg0_41.loadL2dStep and arg0_41.l2dIdleIndex == var0_41.idle then
				var5_41 = true
			end

			if arg0_41.l2dIsPlaying then
				if arg0_41.l2dPlayActionName == arg0_41.actionTrigger.action then
					arg0_41.relationActive = true
				end
			else
				arg0_41.relationActive = false
				arg0_41.relationCountTime = nil
			end

			if not var5_41 and arg0_41.relationActive and arg0_41.l2dIdleIndex == var0_41.idle then
				if not arg0_41.relationCountTime then
					arg0_41.relationCountTime = Time.GetTimestamp() + var0_41.time
				end

				if arg0_41.relationCountTime and Time.GetTimestamp() >= arg0_41.relationCountTime then
					var5_41 = true
				end
			end
		else
			var4_41 = arg0_41.parameterTargetValue
			var5_41 = false
		end

		local var6_41
		local var7_41

		if var3_41 then
			var6_41 = var3_41
		else
			local var8_41 = arg0_41:fixRelationParameter(var4_41, var0_41)
			local var9_41 = iter1_41.value or arg0_41.startValue
			local var10_41 = iter1_41.parameterSmooth or 0
			local var11_41 = var0_41.smooth and var0_41.smooth / 1000 or arg0_41.smooth

			var6_41, var7_41 = Mathf.SmoothDamp(var9_41, var8_41, var10_41, var11_41)
		end

		iter1_41.value = var6_41
		iter1_41.parameterSmooth = var7_41
		iter1_41.enable = var5_41
		iter1_41.comId = arg0_41.id
	end
end

function var0_0.fixRelationParameter(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg2_42.range or arg0_42.range
	local var1_42 = arg2_42.rangeAbs and arg2_42.rangeAbs == 1 or arg0_42.rangeAbs
	local var2_42 = arg2_42.drag_direct and arg2_42.drag_direct or arg0_42.dragDirect

	return arg0_42:fixParameterTargetValue(arg1_42, var0_42, var1_42, var2_42)
end

function var0_0.fixParameterTargetValue(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43)
	if arg1_43 < 0 and arg4_43 == 1 then
		arg1_43 = 0
	elseif arg1_43 > 0 and arg4_43 == 2 then
		arg1_43 = 0
	end

	arg1_43 = arg3_43 and math.abs(arg1_43) or arg1_43

	if arg1_43 < arg2_43[1] then
		arg1_43 = arg2_43[1]
	elseif arg1_43 > arg2_43[2] then
		arg1_43 = arg2_43[2]
	end

	return arg1_43
end

function var0_0.checkReset(arg0_44)
	if not arg0_44._active and arg0_44.parameterToStart then
		if arg0_44.parameterToStart > 0 then
			arg0_44.parameterToStart = arg0_44.parameterToStart - Time.deltaTime
		end

		if arg0_44.parameterToStart <= 0 then
			arg0_44:setTargetValue(arg0_44.startValue)

			arg0_44.parameterToStart = nil

			if arg0_44.revertResetFlag then
				arg0_44:setTriggerActionFlag(false)

				arg0_44.revertResetFlag = false
			end

			if arg0_44.offsetDragX then
				arg0_44.offsetDragX = arg0_44.startValue
				arg0_44.offsetDragTargetX = arg0_44.startValue
			end

			if arg0_44.offsetDragY then
				arg0_44.offsetDragY = arg0_44.startValue
				arg0_44.offsetDragTargetY = arg0_44.startValue
			end
		end
	end
end

function var0_0.setParameterValue(arg0_45, arg1_45, arg2_45)
	if arg1_45 then
		arg0_45.parameterValue = arg1_45
	end

	if arg2_45 then
		arg0_45.parameterSmooth = arg2_45
	end
end

function var0_0.updateState(arg0_46)
	if not arg0_46.lastFrameActive and arg0_46._active then
		arg0_46.firstActive = true
	else
		arg0_46.firstActive = false
	end

	if arg0_46.lastFrameActive and not arg0_46._active then
		arg0_46.firstStop = true
	else
		arg0_46.firstStop = false
	end

	arg0_46.lastFrameActive = arg0_46._active
end

function var0_0.updateTrigger(arg0_47)
	if not arg0_47:isActionTriggerAble() then
		return
	end

	local var0_47 = arg0_47.actionTrigger.type
	local var1_47 = arg0_47.actionTrigger.action
	local var2_47

	if arg0_47.actionTrigger.time then
		var2_47 = arg0_47.actionTrigger.time
	elseif arg0_47.actionTrigger.action_list and arg0_47.actionListIndex > 0 then
		var2_47 = arg0_47.actionTrigger.action_list[arg0_47.actionListIndex].time
	end

	local var3_47

	if arg0_47.actionTrigger.num then
		var3_47 = arg0_47.actionTrigger.num
	elseif arg0_47.actionTrigger.action_list and arg0_47.actionTrigger.action_list[arg0_47.actionListIndex].num and arg0_47.actionListIndex > 0 then
		var3_47 = arg0_47.actionTrigger.action_list[arg0_47.actionListIndex].num
	end

	if var0_47 == Live2D.DRAG_TIME_ACTION then
		if arg0_47._active and math.abs(arg0_47.parameterValue - var3_47) < math.abs(var3_47) * 0.25 then
			arg0_47.triggerActionTime = arg0_47.triggerActionTime + Time.deltaTime

			if var2_47 < arg0_47.triggerActionTime and not arg0_47.l2dIsPlaying then
				arg0_47:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_48)
					if arg0_48 then
						arg0_47:onEventNotice(Live2D.ON_ACTION_DRAG_TRIGGER)
					end
				end)
			end
		end
	elseif var0_47 == Live2D.DRAG_CLICK_ACTION then
		if arg0_47:checkClickAction() then
			arg0_47:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_49)
				arg0_47:onEventNotice(Live2D.ON_ACTION_DRAG_CLICK)
			end)
		end
	elseif var0_47 == Live2D.DRAG_CLICK_RANGE then
		if arg0_47:checkClickAction() then
			local var4_47 = arg0_47.actionTrigger.parameter and arg0_47.actionTrigger.parameter or arg0_47.parameterName
			local var5_47 = var3_47

			arg0_47:onEventCallback(Live2D.EVENT_GET_PARAMETER, {
				name = var4_47
			}, function(arg0_50)
				print("获取到数值 " .. var4_47 .. " = " .. arg0_50)

				if arg0_50 >= var5_47[1] and arg0_50 < var5_47[2] then
					print("数值范围内，开始触发")
					arg0_47:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_51)
						arg0_47:onEventNotice(Live2D.ON_ACTION_DRAG_CLICK)
					end)
				end
			end)
		end
	elseif var0_47 == Live2D.DRAG_DOWN_ACTION then
		if arg0_47._active then
			arg0_47:setAbleWithFlag(true)

			if var2_47 <= Time.time - arg0_47.mouseInputDownTime and not arg0_47.l2dIsPlaying then
				print("触发按压动作")
				arg0_47:setAbleWithFlag(false)
				arg0_47:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_52)
					if arg0_52 then
						arg0_47:onEventNotice(Live2D.ON_ACTION_DOWN)
					end
				end)

				if arg0_47.actionListIndex ~= 1 then
					arg0_47:setTriggerActionFlag(false)
				end

				arg0_47:setAbleWithFlag(true)

				arg0_47.mouseInputDownTime = Time.time
			end
		elseif arg0_47.actionTrigger.last and arg0_47.actionListIndex ~= 1 then
			arg0_47.actionListIndex = #arg0_47.actionTrigger.action_list

			arg0_47:setAbleWithFlag(false)
			arg0_47:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_53)
				return
			end)
			arg0_47:resetNextTriggerTime()
			arg0_47:setTriggerActionFlag(false)
		else
			arg0_47:setAbleWithFlag(false)
		end
	elseif var0_47 == Live2D.DRAG_RELATION_XY then
		if arg0_47._active then
			local var6_47 = arg0_47:fixParameterTargetValue(arg0_47.offsetDragX, arg0_47.range, arg0_47.rangeAbs, arg0_47.dragDirect)
			local var7_47 = arg0_47:fixParameterTargetValue(arg0_47.offsetDragY, arg0_47.range, arg0_47.rangeAbs, arg0_47.dragDirect)
			local var8_47 = var3_47[1]
			local var9_47 = var3_47[2]

			if math.abs(var6_47 - var8_47) < math.abs(var8_47) * 0.25 and math.abs(var7_47 - var9_47) < math.abs(var9_47) * 0.25 then
				arg0_47.triggerActionTime = arg0_47.triggerActionTime + Time.deltaTime

				if var2_47 < arg0_47.triggerActionTime and not arg0_47.l2dIsPlaying then
					arg0_47:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_54)
						if arg0_54 then
							arg0_47:onEventNotice(Live2D.ON_ACTION_XY_TRIGGER)
						end
					end)
				end
			else
				arg0_47.triggerActionTime = arg0_47.triggerActionTime + 0
			end
		end
	elseif var0_47 == Live2D.DRAG_RELATION_IDLE then
		if arg0_47.actionTrigger.const_fit then
			for iter0_47 = 1, #arg0_47.actionTrigger.const_fit do
				local var10_47 = arg0_47.actionTrigger.const_fit[iter0_47]

				if arg0_47.l2dIdleIndex == var10_47.idle and not arg0_47.l2dIsPlaying then
					arg0_47:setTargetValue(var10_47.target)
				end
			end
		end
	elseif var0_47 == Live2D.DRAG_CLICK_MANY then
		if arg0_47:checkClickAction() then
			arg0_47:onEventCallback(Live2D.EVENT_ACTION_APPLY)
		end
	elseif var0_47 == Live2D.DRAG_LISTENER_EVENT then
		if arg0_47._listenerTrigger then
			arg0_47:onEventCallback(Live2D.EVENT_ACTION_APPLY)
		end
	elseif var0_47 == Live2D.DRAG_DOWN_TOUCH then
		arg0_47:setAbleWithFlag(arg0_47._active)

		if arg0_47._active then
			local var11_47 = Time.deltaTime / arg0_47.actionTrigger.delta
			local var12_47 = arg0_47.parameterTargetValue + var11_47
			local var13_47 = arg0_47:fixParameterTargetValue(var12_47, arg0_47.range, arg0_47.rangeAbs, arg0_47.dragDirect)

			arg0_47:setTargetValue(var13_47)
		end
	elseif var0_47 == Live2D.DRAG_CLICK_PARAMETER then
		if arg0_47:checkClickAction() then
			local var14_47 = var3_47
			local var15_47 = arg0_47.actionTrigger.parameter

			arg0_47:onEventCallback(Live2D.EVENT_GET_PARAMETER, {
				name = var15_47
			}, function(arg0_55)
				if math.abs(var14_47 - arg0_55) <= 0.05 then
					print("数值允许播放，开始执行动作 " .. arg0_47.actionTrigger.action)
					arg0_47:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_56)
						arg0_47:onEventNotice(Live2D.ON_ACTION_DRAG_CLICK)
					end)
				end
			end)
		end
	elseif var0_47 == Live2D.DRAG_ANIMATION_PLAY then
		local var16_47 = arg0_47.actionTrigger.trigger_name

		if arg0_47.actionTrigger.trigger_index > 0 and arg0_47.actionTrigger.trigger_name == "idle" then
			var16_47 = var16_47 .. arg0_47.actionTrigger.trigger_index
		end

		if arg0_47.stateInfo:IsName(var16_47) and arg0_47.l2dIdleIndex == arg0_47.actionTrigger.trigger_index then
			local var17_47 = false
			local var18_47 = arg0_47.actionTrigger.parameter_range

			if var18_47 then
				local var19_47 = var18_47[1]
				local var20_47 = var18_47[2]

				arg0_47:onEventCallback(Live2D.EVENT_GET_PARAMETER, {
					name = var19_47
				}, function(arg0_57)
					if arg0_57 and arg0_57 >= var20_47[1] and arg0_57 < var20_47[2] then
						var17_47 = true
					end
				end)
			else
				var17_47 = true
			end

			if var17_47 and arg0_47.normalTime >= arg0_47.actionTrigger.trigger_rate and not arg0_47.animationPlayApply then
				arg0_47:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function()
					return
				end)
				arg0_47:setTriggerActionFlag(false)

				arg0_47.animationPlayApply = true
			end
		elseif arg0_47.animationPlayApply then
			arg0_47.animationPlayApply = false
		end
	elseif var0_47 == Live2D.DRAG_EXTEND_ACTION_RULE then
		if not arg0_47.extendActionFlag then
			arg0_47.extendActionFlag = true
		end
	elseif var0_47 == Live2D.DRAG_WITH_PARAMETER_MOVE and not arg0_47.l2dIsPlaying then
		local var21_47
		local var22_47

		if var3_47 then
			var21_47 = var3_47 and math.abs(arg0_47.parameterValue - var3_47) or 0
			var22_47 = math.abs(var3_47) * 0.1
		end

		if var3_47 and var21_47 <= var22_47 and not arg0_47.parameterMoveTrigger then
			arg0_47.parameterMoveTrigger = true

			arg0_47:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_59)
				return
			end)
		else
			if not arg0_47.moveCheckStep then
				arg0_47.moveCheckStep = 10
			end

			if arg0_47.parameterMoveTrigger then
				arg0_47.parameterMoveTrigger = false

				arg0_47:setParameterValue(arg0_47.startValue)
				arg0_47:setTargetValue(arg0_47.startValue)
			end

			arg0_47.moveCheckStep = arg0_47.moveCheckStep - 1

			if arg0_47.moveCheckStep <= 0 then
				arg0_47.moveCheckStep = 10

				local var23_47 = arg0_47.actionTrigger.parameter

				arg0_47.lastParameterMove = arg0_47.parameterMove

				arg0_47:onEventCallback(Live2D.EVENT_GET_PARAMETER, {
					name = var23_47
				}, function(arg0_60)
					arg0_47.parameterMove = arg0_60
				end)

				if arg0_47.lastParameterMove and arg0_47.parameterMove then
					local var24_47 = math.abs(arg0_47.parameterMove - arg0_47.lastParameterMove)

					if var24_47 ~= 0 then
						local var25_47 = arg0_47.actionTrigger.rate and arg0_47.actionTrigger.rate or 0
						local var26_47 = arg0_47.parameterTargetValue + var24_47 * var25_47

						arg0_47:setTargetValue(arg0_47:fixParameterTargetValue(var26_47, arg0_47.range, arg0_47.rangeAbs, arg0_47.dragDirect))
						print("检测数值发生改变 = " .. arg0_47.parameterTargetValue)
					end
				end
			end
		end
	end
end

function var0_0.getExtendAction(arg0_61)
	return arg0_61.extendActionFlag
end

function var0_0.checkActionInExtendFlag(arg0_62, arg1_62)
	local var0_62 = false
	local var1_62 = false

	if not arg0_62.extendActionFlag then
		return var0_62, var1_62
	end

	local var2_62 = arg0_62.actionTrigger.parameter
	local var3_62 = arg0_62.actionTrigger.num
	local var4_62 = false

	arg0_62:onEventCallback(Live2D.EVENT_GET_DRAG_PARAMETER, {
		name = var2_62
	}, function(arg0_63)
		if arg0_63 > var3_62[1] and arg0_63 <= var3_62[2] then
			var4_62 = true
		end
	end)

	if not var4_62 then
		return var0_62, var0_62
	end

	local var5_62 = arg0_62.actionTriggerActive.ignore
	local var6_62 = arg0_62.actionTriggerActive.enable

	if var5_62 and table.contains(var5_62, arg1_62) then
		var0_62 = true
	end

	if var6_62 and table.contains(var6_62, arg1_62) then
		var1_62 = true
	end

	return var0_62, var1_62
end

function var0_0.setAbleWithFlag(arg0_64, arg1_64)
	if arg0_64.ableFlag ~= arg1_64 then
		arg0_64.ableFlag = arg1_64

		arg0_64:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
			ableFlag = arg1_64
		})
	end
end

function var0_0.triggerAction(arg0_65)
	arg0_65.nextTriggerTime = arg0_65.limitTime

	arg0_65:setTriggerActionFlag(true)
end

function var0_0.isActionTriggerAble(arg0_66)
	if arg0_66.actionTrigger.type == nil then
		return false
	end

	if not arg0_66.actionTrigger or arg0_66.actionTrigger == "" then
		return false
	end

	if arg0_66.nextTriggerTime - Time.deltaTime >= 0 then
		arg0_66.nextTriggerTime = arg0_66.nextTriggerTime - Time.deltaTime

		return false
	end

	if arg0_66.isTriggerAtion then
		return false
	end

	return true
end

function var0_0.updateStateData(arg0_67, arg1_67)
	if arg0_67.l2dIdleIndex ~= arg1_67.idleIndex then
		if type(arg0_67.revertIdleIndex) == "boolean" and arg0_67.revertIdleIndex == true then
			arg0_67:setTargetValue(arg0_67.startValue)
		elseif type(arg0_67.revertIdleIndex) == "table" and table.contains(arg0_67.revertIdleIndex, arg1_67.idleIndex) then
			arg0_67:setTargetValue(arg0_67.startValue)
		end
	end

	arg0_67.lastActionIndex = arg0_67.actionListIndex

	if arg1_67.isPlaying and arg0_67.actionTrigger.reset_index_action and arg1_67.actionName and table.contains(arg0_67.actionTrigger.reset_index_action, arg1_67.actionName) then
		arg0_67.actionListIndex = 1
	end

	if arg0_67.revertActionIndex and arg0_67.lastActionIndex ~= arg0_67.actionListIndex then
		arg0_67:setTargetValue(arg0_67.startValue)
	end

	arg0_67.l2dIdleIndex = arg1_67.idleIndex
	arg0_67.l2dIsPlaying = arg1_67.isPlaying
	arg0_67.l2dIgnoreReact = arg1_67.ignoreReact
	arg0_67.l2dPlayActionName = arg1_67.actionName

	if not arg0_67.l2dIsPlaying and arg0_67.isTriggerAtion then
		arg0_67:setTriggerActionFlag(false)
	end

	if arg0_67.l2dIdleIndex and arg0_67.idleOn and #arg0_67.idleOn > 0 then
		arg0_67.reactConditionFlag = not table.contains(arg0_67.idleOn, arg0_67.l2dIdleIndex)
	end

	if arg0_67.l2dIdleIndex and arg0_67.idleOff and #arg0_67.idleOff > 0 then
		arg0_67.reactConditionFlag = table.contains(arg0_67.idleOff, arg0_67.l2dIdleIndex)
	end
end

function var0_0.checkClickAction(arg0_68)
	if arg0_68.firstActive then
		if arg0_68.actionTrigger.down then
			if arg0_68.actionTrigger.focus == 1 and arg0_68.l2dIsPlaying then
				return true
			elseif not arg0_68.l2dIsPlaying then
				return true
			end
		else
			arg0_68:setAbleWithFlag(true)
		end
	elseif arg0_68.firstStop then
		local var0_68 = math.abs(arg0_68.mouseInputUp.x - arg0_68.mouseInputDown.x) < 30 and math.abs(arg0_68.mouseInputUp.y - arg0_68.mouseInputDown.y) < 30
		local var1_68 = arg0_68.mouseInputUpTime - arg0_68.mouseInputDownTime < 0.5

		if not arg0_68.actionTrigger.down and var0_68 and var1_68 then
			if arg0_68.actionTrigger.focus == 1 and arg0_68.l2dIsPlaying then
				if arg0_68.l2dPlayActionName == arg0_68.actionTrigger.action then
					arg0_68.clickTriggerTime = 0.01
					arg0_68.clickApplyFlag = true
				end
			elseif not arg0_68.l2dIsPlaying then
				arg0_68.clickTriggerTime = 0.01
				arg0_68.clickApplyFlag = true
			end
		else
			arg0_68:setAbleWithFlag(false)
		end
	elseif arg0_68.clickTriggerTime and arg0_68.clickTriggerTime > 0 then
		arg0_68.clickTriggerTime = arg0_68.clickTriggerTime - Time.deltaTime

		if arg0_68.clickTriggerTime <= 0 then
			arg0_68.clickTriggerTime = nil

			arg0_68:setAbleWithFlag(false)

			if arg0_68.clickApplyFlag then
				arg0_68.clickApplyFlag = false

				return true
			end
		end
	end

	return false
end

function var0_0.saveData(arg0_69)
	local var0_69 = arg0_69.id
	local var1_69 = arg0_69.live2dData:GetShipSkinConfig().id
	local var2_69 = arg0_69.live2dData.ship.id

	if arg0_69.revert == -1 and arg0_69.saveParameterFlag then
		Live2dConst.SaveDragData(var0_69, var1_69, var2_69, arg0_69.parameterTargetValue)
	end

	if arg0_69.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		print("保存actionListIndex" .. arg0_69.actionListIndex)
		Live2dConst.SetDragActionIndex(var0_69, var1_69, var2_69, arg0_69.actionListIndex)
	end

	if arg0_69._relationFlag then
		Live2dConst.SetRelationData(var0_69, var1_69, var2_69, arg0_69:getRelationSaveData())
	end
end

function var0_0.loadData(arg0_70)
	local var0_70 = arg0_70.id
	local var1_70 = arg0_70.live2dData:GetShipSkinConfig().id
	local var2_70 = arg0_70.live2dData.ship.id

	if arg0_70.revert == -1 and arg0_70.saveParameterFlag then
		local var3_70 = Live2dConst.GetDragData(arg0_70.id, arg0_70.live2dData:GetShipSkinConfig().id, arg0_70.live2dData.ship.id)

		if var3_70 then
			arg0_70:setParameterValue(var3_70)
			arg0_70:setTargetValue(var3_70)
		end

		if var3_70 == arg0_70.startValue and arg0_70._relationParameterList and #arg0_70._relationParameterList > 0 then
			arg0_70:clearRelationValue()
		end
	end

	if arg0_70.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		arg0_70.actionListIndex = Live2dConst.GetDragActionIndex(arg0_70.id, arg0_70.live2dData:GetShipSkinConfig().id, arg0_70.live2dData.ship.id) or 1
	end

	if arg0_70._relationFlag then
		local var4_70 = Live2dConst.GetRelationData(var0_70, var1_70, var2_70)

		arg0_70.offsetDragX = var4_70.drag_x and var4_70.drag_x or arg0_70.startValue
		arg0_70.offsetDragY = var4_70.drag_y and var4_70.drag_y or arg0_70.startValue
	end
end

function var0_0.getRelationSaveData(arg0_71)
	return {
		[Live2dConst.RELATION_DRAG_X] = arg0_71.offsetDragX,
		[Live2dConst.RELATION_DRAG_Y] = arg0_71.offsetDragY
	}
end

function var0_0.clearRelationValue(arg0_72)
	if arg0_72._relationParameterList and #arg0_72._relationParameterList > 0 then
		for iter0_72 = 1, #arg0_72._relationParameterList do
			local var0_72 = arg0_72._relationParameterList[iter0_72]

			if var0_72.data.type == Live2D.relation_type_drag_x or var0_72.data.type == Live2D.relation_type_drag_y then
				var0_72.value = var0_72.start or arg0_72.startValue or 0
				var0_72.enable = true
			end

			arg0_72.offsetDragX, arg0_72.offsetDragY = arg0_72.startValue, arg0_72.startValue
		end
	end
end

function var0_0.loadL2dFinal(arg0_73)
	arg0_73.loadL2dStep = true
end

function var0_0.clearData(arg0_74)
	if arg0_74.revert == -1 then
		arg0_74.actionListIndex = 1

		arg0_74:setParameterValue(arg0_74.startValue)
		arg0_74:setTargetValue(arg0_74.startValue)
		arg0_74:clearRelationValue()
	end
end

function var0_0.setTriggerActionFlag(arg0_75, arg1_75)
	arg0_75.isTriggerAtion = arg1_75
end

function var0_0.dispose(arg0_76)
	arg0_76._active = false
	arg0_76._parameterCom = nil
	arg0_76.parameterValue = arg0_76.startValue
	arg0_76.parameterTargetValue = 0
	arg0_76.parameterSmooth = 0
	arg0_76.mouseInputDown = Vector2(0, 0)
	arg0_76.live2dData = nil
end

return var0_0
