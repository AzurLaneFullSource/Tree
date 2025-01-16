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

	if arg0_1.relationParameter and arg0_1.relationParameter.list then
		arg0_1._relationFlag = true
	end

	arg0_1.extendActionFlag = false
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

function var0_0.getChangeCheckName(arg0_3, arg1_3, arg2_3)
	if arg1_3 == Live2D.ON_ACTION_PLAY then
		return arg2_3.action
	elseif arg1_3 == Live2D.ON_ACTION_DRAG_CLICK then
		return arg2_3.draw_able_name
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

function var0_0.startDrag(arg0_4, arg1_4)
	if arg0_4.ignoreAction and arg0_4.l2dIsPlaying then
		return
	end

	print(arg0_4.drawAbleName .. " 按下了")

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

function var0_0.stopDrag(arg0_5, arg1_5)
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
		arg0_5.mouseWorld = nil
		arg0_5.circleDragWorld = nil

		arg0_5:updatePartsParameter()
		arg0_5:saveData()
	end
end

function var0_0.onDrag(arg0_6, arg1_6)
	arg0_6.mouseWorld = arg1_6.pointerCurrentRaycast.worldPosition
end

function var0_0.checkResetTriggerTime(arg0_7)
	local var0_7 = false

	if arg0_7.actionTrigger.type == Live2D.DRAG_DOWN_ACTION and arg0_7.actionTrigger.last then
		var0_7 = true
	end

	if var0_7 then
		arg0_7:resetNextTriggerTime()
	end
end

function var0_0.resetNextTriggerTime(arg0_8)
	arg0_8.nextTriggerTime = 0
end

function var0_0.updatePartsParameter(arg0_9)
	if type(arg0_9.partsData) == "table" then
		local var0_9 = arg0_9.partsData.parts
		local var1_9 = arg0_9.partsData.type
		local var2_9 = false

		if arg0_9.offsetX or arg0_9.offsetY then
			var2_9 = true
		elseif arg0_9.actionTrigger and arg0_9.actionTrigger.type == Live2D.DRAG_DOWN_TOUCH then
			var2_9 = true
		elseif arg0_9.offsetCirclePos then
			var2_9 = true
		end

		if var2_9 then
			local var3_9 = arg0_9.parameterTargetValue
			local var4_9
			local var5_9

			for iter0_9 = 1, #var0_9 do
				local var6_9 = var0_9[iter0_9]
				local var7_9 = math.abs(var3_9 - var6_9)

				if var1_9 == var3_0 or not var1_9 then
					if not var4_9 or var7_9 < var4_9 then
						var4_9 = var7_9
						var5_9 = iter0_9
					end
				elseif var1_9 == var4_0 then
					if var6_9 <= var3_9 and (not var4_9 or var7_9 < var4_9) then
						var4_9 = var7_9
						var5_9 = iter0_9
					end
				elseif var1_9 == var5_0 and var3_9 <= var6_9 and (not var4_9 or var7_9 < var4_9) then
					var4_9 = var7_9
					var5_9 = iter0_9
				end
			end

			if var5_9 then
				if math.abs(arg0_9.parameterTargetValue - var0_9[var5_9]) >= 0.05 then
					print("吸附数值" .. var0_9[var5_9])
				end

				arg0_9:setTargetValue(var0_9[var5_9])
			end
		end
	end
end

function var0_0.getIgnoreReact(arg0_10)
	return arg0_10.ignoreReact
end

function var0_0.setParameterCom(arg0_11, arg1_11)
	if not arg1_11 then
		print("live2dDrag id:" .. tostring(arg0_11.id) .. "设置了null的组件(该打印非报错)")
	end

	arg0_11._parameterCom = arg1_11
end

function var0_0.getParameterCom(arg0_12)
	return arg0_12._parameterCom
end

function var0_0.addRelationComData(arg0_13, arg1_13, arg2_13)
	table.insert(arg0_13._relationParameterList, {
		com = arg1_13,
		data = arg2_13
	})
end

function var0_0.getRelationParameterList(arg0_14)
	return arg0_14._relationParameterList
end

function var0_0.getReactCondition(arg0_15)
	return arg0_15.reactConditionFlag
end

function var0_0.getActive(arg0_16)
	return arg0_16._active
end

function var0_0.getParameterUpdateFlag(arg0_17)
	return arg0_17._parameterUpdateFlag
end

function var0_0.setEventCallback(arg0_18, arg1_18)
	arg0_18._eventCallback = arg1_18
end

function var0_0.onEventCallback(arg0_19, arg1_19, arg2_19, arg3_19)
	if arg1_19 == Live2D.EVENT_ACTION_APPLY then
		local var0_19 = {}
		local var1_19
		local var2_19 = false
		local var3_19
		local var4_19
		local var5_19
		local var6_19 = false

		if arg0_19.actionTrigger.action then
			var1_19 = arg0_19:fillterAction(arg0_19.actionTrigger.action)
			var0_19 = arg0_19.actionTriggerActive
			var2_19 = arg0_19.actionTrigger.focus or false
			var3_19 = arg0_19.actionTrigger.target or nil
			var6_19 = arg0_19.actionTrigger.target_focus == 1 and true or false

			if (arg0_19.actionTrigger.circle or nil) and var3_19 and var3_19 == arg0_19.parameterTargetValue then
				var3_19 = arg0_19.startValue
			end

			var4_19 = arg0_19.actionTrigger.react or nil

			arg0_19:triggerAction()
			arg0_19:stopDrag()
		elseif arg0_19.actionTrigger.action_list then
			local var7_19 = arg0_19.actionTrigger.action_list[arg0_19.actionListIndex]

			var1_19 = arg0_19:fillterAction(var7_19.action)

			if arg0_19.actionTriggerActive.active_list and arg0_19.actionListIndex <= #arg0_19.actionTriggerActive.active_list then
				var0_19 = arg0_19.actionTriggerActive.active_list[arg0_19.actionListIndex]
			else
				var0_19 = arg0_19.actionTriggerActive
			end

			var2_19 = var7_19.focus or true
			var3_19 = var7_19.target or nil
			var6_19 = var7_19.target_focus == 1 and true or false
			var4_19 = var7_19.react or nil

			arg0_19:triggerAction()

			if arg0_19.actionListIndex == #arg0_19.actionTrigger.action_list then
				arg0_19:stopDrag()

				arg0_19.actionListIndex = 1
			else
				arg0_19.actionListIndex = arg0_19.actionListIndex + 1
			end
		elseif not arg0_19.actionTrigger.action then
			var1_19 = arg0_19:fillterAction(arg0_19.actionTrigger.action)
			var0_19 = arg0_19.actionTriggerActive
			var2_19 = arg0_19.actionTrigger.focus or false
			var3_19 = arg0_19.actionTrigger.target or nil
			var6_19 = arg0_19.actionTrigger.target_focus == 1 and true or false

			local var8_19 = arg0_19.actionTrigger.circle or nil

			var4_19 = arg0_19.actionTrigger.react or nil

			if var8_19 and var3_19 and var3_19 == arg0_19.parameterTargetValue then
				var3_19 = arg0_19.startValue
			end

			arg0_19:triggerAction()
			arg0_19:setTriggerActionFlag(false)
			arg0_19:stopDrag()
		end

		if var0_19.idle then
			if type(var0_19.idle) == "number" then
				if var0_19.idle == arg0_19.l2dIdleIndex and not var0_19.repeat_flag then
					return
				end
			elseif type(var0_19.idle) == "table" and #var0_19.idle == 1 and var0_19.idle[1] == arg0_19.l2dIdleIndex and not var0_19.repeat_flag then
				return
			end
		end

		print("执行aplly数据 id = " .. arg0_19.id .. "播放action = " .. tostring(var1_19) .. " active idle is " .. tostring(var0_19.idle))

		if var3_19 then
			arg0_19:setTargetValue(var3_19)

			if var6_19 then
				arg0_19:setParameterValue(var3_19)
			end

			if not var1_19 then
				arg0_19.revertResetFlag = true
			end
		end

		arg2_19 = {
			id = arg0_19.id,
			action = var1_19,
			activeData = var0_19,
			focus = var2_19,
			react = var4_19,
			callback = arg3_19,
			finishCall = function()
				arg0_19:actionApplyFinish()
			end
		}
	elseif arg1_19 == Live2D.EVENT_ACTION_ABLE then
		-- block empty
	elseif arg1_19 == Live2D.EVENT_CHANGE_IDLE_INDEX then
		print("change idle")
	elseif arg1_19 == Live2D.EVENT_GET_PARAMETER then
		arg2_19.callback = arg3_19
	elseif arg1_19 == Live2D.EVENT_GET_DRAG_PARAMETER then
		arg2_19.callback = arg3_19
	elseif arg1_19 == Live2D.EVENT_GET_WORLD_POSITION then
		arg2_19.callback = arg3_19
	end

	arg0_19._eventCallback(arg1_19, arg2_19)
end

function var0_0.fillterAction(arg0_21, arg1_21)
	if type(arg1_21) == "table" then
		return arg1_21[math.random(1, #arg1_21)]
	else
		return arg1_21
	end
end

function var0_0.onEventNotice(arg0_22, arg1_22)
	if arg0_22._eventCallback then
		local var0_22 = arg0_22:getCommonNoticeData()

		arg0_22._eventCallback(arg1_22, var0_22)
	end
end

function var0_0.getCommonNoticeData(arg0_23)
	return {
		draw_able_name = arg0_23.drawAbleName,
		parameter_name = arg0_23.parameterName,
		parameter_target = arg0_23.parameterTargetValue
	}
end

function var0_0.setTargetValue(arg0_24, arg1_24)
	arg0_24.parameterTargetValue = arg1_24
end

function var0_0.getParameter(arg0_25)
	return arg0_25.parameterValue
end

function var0_0.getParameToTargetFlag(arg0_26)
	if arg0_26.parameterValue ~= arg0_26.parameterTargetValue then
		return true
	end

	if arg0_26.parameterToStart and arg0_26.parameterToStart > 0 then
		return true
	end

	return false
end

function var0_0.actionApplyFinish(arg0_27)
	return
end

function var0_0.stepParameter(arg0_28, arg1_28)
	arg0_28:updateStepData(arg1_28)
	arg0_28:updateState()
	arg0_28:updateTrigger()
	arg0_28:updateParameterUpdateFlag()
	arg0_28:updateGyro()
	arg0_28:updateDrag()
	arg0_28:updateCircleDrag()
	arg0_28:updateReactValue()
	arg0_28:updateParameterValue()
	arg0_28:updateRelationValue()
	arg0_28:checkReset()

	arg0_28.loadL2dStep = false
end

function var0_0.updateStepData(arg0_29, arg1_29)
	arg0_29.reactPos = arg1_29.reactPos
	arg0_29.normalTime = arg1_29.normalTime
	arg0_29.stateInfo = arg1_29.stateInfo
end

function var0_0.updateParameterUpdateFlag(arg0_30)
	if arg0_30.actionTrigger.type == Live2D.DRAG_CLICK_ACTION then
		arg0_30._parameterUpdateFlag = true
	elseif arg0_30.actionTrigger.type == Live2D.DRAG_RELATION_IDLE then
		if not arg0_30._parameterUpdateFlag then
			if not arg0_30.l2dIsPlaying then
				arg0_30._parameterUpdateFlag = true

				arg0_30:changeParameComAble(true)
			elseif not table.contains(arg0_30.actionTrigger.remove_com_list, arg0_30.l2dPlayActionName) then
				arg0_30._parameterUpdateFlag = true

				arg0_30:changeParameComAble(true)
			end
		elseif arg0_30._parameterUpdateFlag == true and arg0_30.l2dIsPlaying and table.contains(arg0_30.actionTrigger.remove_com_list, arg0_30.l2dPlayActionName) then
			arg0_30._parameterUpdateFlag = false

			arg0_30:changeParameComAble(false)
		end
	elseif arg0_30.actionTrigger.type == Live2D.DRAG_DOWN_TOUCH then
		arg0_30._parameterUpdateFlag = true
	elseif arg0_30.actionTrigger.type == Live2D.DRAG_LISTENER_EVENT then
		arg0_30._parameterUpdateFlag = true
	else
		arg0_30._parameterUpdateFlag = false
	end
end

function var0_0.changeParameComAble(arg0_31, arg1_31)
	if arg0_31.parameterComAdd == arg1_31 then
		return
	end

	arg0_31.parameterComAdd = arg1_31

	if arg1_31 then
		arg0_31:onEventCallback(Live2D.EVENT_ADD_PARAMETER_COM, {
			com = arg0_31._parameterCom,
			start = arg0_31.startValue,
			mode = arg0_31.mode
		})
	else
		arg0_31:onEventCallback(Live2D.EVENT_REMOVE_PARAMETER_COM, {
			com = arg0_31._parameterCom,
			mode = arg0_31.mode
		})
	end
end

function var0_0.updateDrag(arg0_32)
	if not arg0_32.offsetX and not arg0_32.offsetY then
		return
	end

	local var0_32

	if arg0_32._active then
		local var1_32 = Input.mousePosition

		if arg0_32.offsetX and arg0_32.offsetX ~= 0 then
			local var2_32 = var1_32.x - arg0_32.mouseInputDown.x

			var0_32 = arg0_32.offsetDragTargetX + var2_32 / arg0_32.offsetX
			arg0_32.offsetDragX = var0_32
		end

		if arg0_32.offsetY and arg0_32.offsetY ~= 0 then
			local var3_32 = var1_32.y - arg0_32.mouseInputDown.y

			var0_32 = arg0_32.offsetDragTargetY + var3_32 / arg0_32.offsetY
			arg0_32.offsetDragY = var0_32
		end

		if var0_32 then
			arg0_32:setTargetValue(arg0_32:fixParameterTargetValue(var0_32, arg0_32.range, arg0_32.rangeAbs, arg0_32.dragDirect))
		end
	end

	arg0_32._parameterUpdateFlag = true
end

function var0_0.updateCircleDrag(arg0_33)
	if not arg0_33.offsetCirclePos then
		return
	end

	if arg0_33._active and arg0_33.mouseWorld ~= nil then
		if not arg0_33.circleDragWorld then
			arg0_33:onEventCallback(Live2D.EVENT_GET_WORLD_POSITION, {
				pos = arg0_33.offsetCirclePos,
				name = arg0_33.drawAbleName
			}, function(arg0_34)
				arg0_33.circleDragWorld = arg0_34
			end)
		end

		local var0_33 = (math.atan2(arg0_33.mouseWorld.x - arg0_33.circleDragWorld.x, arg0_33.mouseWorld.y - arg0_33.circleDragWorld.y) * math.rad2Deg + 360 - arg0_33.offsetCircleStart) % 360 / 360
		local var1_33 = arg0_33.range[2] * var0_33

		arg0_33:setTargetValue(var1_33)

		arg0_33._parameterUpdateFlag = true
	elseif arg0_33.parameterTargetValue ~= arg0_33.parameterValue then
		arg0_33._parameterUpdateFlag = true
	end
end

function var0_0.updateGyro(arg0_35)
	if not arg0_35.gyro then
		return
	end

	if not Input.gyro.enabled then
		arg0_35:setTargetValue(0)

		arg0_35._parameterUpdateFlag = true

		return
	end

	local var0_35 = Input.gyro and Input.gyro.attitude or Vector3.zero
	local var1_35 = 0

	if arg0_35.gyroX and not math.isnan(var0_35.y) then
		var1_35 = Mathf.Clamp(var0_35.y * arg0_35.sensitive, -0.5, 0.5)
	elseif arg0_35.gyroY and not math.isnan(var0_35.x) then
		var1_35 = Mathf.Clamp(var0_35.x * arg0_35.sensitive, -0.5, 0.5)
	elseif arg0_35.gyroZ and not math.isnan(var0_35.z) then
		var1_35 = Mathf.Clamp(var0_35.z * arg0_35.sensitive, -0.5, 0.5)
	end

	if IsUnityEditor then
		if L2D_USE_RANDOM_ATTI then
			if arg0_35.randomAttitudeIndex == 0 then
				var1_35 = math.random() - 0.5

				local var2_35 = (var1_35 + 0.5) * (arg0_35.range[2] - arg0_35.range[1]) + arg0_35.range[1]

				arg0_35:setTargetValue(var2_35)

				arg0_35.randomAttitudeIndex = L2D_RANDOM_PARAM
			elseif arg0_35.randomAttitudeIndex > 0 then
				arg0_35.randomAttitudeIndex = arg0_35.randomAttitudeIndex - 1
			end
		end
	else
		local var3_35 = (var1_35 + 0.5) * (arg0_35.range[2] - arg0_35.range[1]) + arg0_35.range[1]

		arg0_35:setTargetValue(var3_35)
	end

	arg0_35._parameterUpdateFlag = true
end

function var0_0.updateReactValue(arg0_36)
	if not arg0_36.reactX and not arg0_36.reactY then
		return
	end

	local var0_36
	local var1_36 = false

	if arg0_36.l2dIgnoreReact then
		var0_36 = arg0_36.parameterTargetValue
	elseif arg0_36.reactX then
		var0_36 = arg0_36.reactPos.x * arg0_36.reactX
		var1_36 = true
	else
		var0_36 = arg0_36.reactPos.y * arg0_36.reactY
		var1_36 = true
	end

	if var1_36 then
		arg0_36:setTargetValue(arg0_36:fixParameterTargetValue(var0_36, arg0_36.range, arg0_36.rangeAbs, arg0_36.dragDirect))
	end

	arg0_36._parameterUpdateFlag = true
end

function var0_0.updateParameterValue(arg0_37)
	if arg0_37.prepareTargetValue and not arg0_37.l2dIsPlaying then
		arg0_37:setTargetValue(arg0_37.prepareTargetValue)

		arg0_37.prepareTargetValue = nil
	end

	if arg0_37._parameterUpdateFlag and arg0_37.parameterValue ~= arg0_37.parameterTargetValue then
		if math.abs(arg0_37.parameterValue - arg0_37.parameterTargetValue) < 0.01 then
			arg0_37:setParameterValue(arg0_37.parameterTargetValue)
		elseif arg0_37.parameterSmoothTime and arg0_37.parameterSmoothTime > 0 then
			local var0_37 = arg0_37.parameterValue
			local var1_37 = arg0_37.parameterTargetValue
			local var2_37 = arg0_37:checkUpdateParameterNum(var1_37, var0_37)
			local var3_37, var4_37 = Mathf.SmoothDamp(var0_37, var2_37, arg0_37.parameterSmooth, arg0_37.parameterSmoothTime)

			arg0_37:setParameterValue(var3_37, var4_37)
		else
			arg0_37:setParameterValue(arg0_37.parameterTargetValue, 0)
		end
	end
end

function var0_0.checkUpdateParameterNum(arg0_38, arg1_38, arg2_38)
	if arg0_38.offsetCirclePos and math.abs(arg1_38 - arg2_38) >= arg0_38.rangeOffset / 2 then
		if arg2_38 < arg1_38 then
			arg1_38 = arg1_38 - arg0_38.rangeOffset
		else
			arg1_38 = arg1_38 + arg0_38.rangeOffset
		end
	end

	return arg1_38
end

function var0_0.updateRelationValue(arg0_39)
	for iter0_39, iter1_39 in ipairs(arg0_39._relationParameterList) do
		local var0_39 = iter1_39.data
		local var1_39 = var0_39.type
		local var2_39 = var0_39.relation_value
		local var3_39 = var0_39.target
		local var4_39
		local var5_39

		if var1_39 == Live2D.relation_type_drag_x then
			var4_39 = arg0_39.offsetDragX or iter1_39.start or arg0_39.startValue or 0
			var5_39 = true
		elseif var1_39 == Live2D.relation_type_drag_y then
			var4_39 = arg0_39.offsetDragY or iter1_39.start or arg0_39.startValue or 0
			var5_39 = true
		elseif var1_39 == Live2D.relation_type_action_index then
			var4_39 = var2_39[arg0_39.actionListIndex]
			var4_39 = var4_39 or 0
			var5_39 = true
		elseif var1_39 == Live2D.relation_type_idle then
			if arg0_39.loadL2dStep and arg0_39.l2dIdleIndex == var0_39.idle then
				var5_39 = true
			end

			if arg0_39.l2dIsPlaying then
				if arg0_39.l2dPlayActionName == arg0_39.actionTrigger.action then
					arg0_39.relationActive = true
				end
			else
				arg0_39.relationActive = false
				arg0_39.relationCountTime = nil
			end

			if not var5_39 and arg0_39.relationActive and arg0_39.l2dIdleIndex == var0_39.idle then
				if not arg0_39.relationCountTime then
					arg0_39.relationCountTime = Time.GetTimestamp() + var0_39.time
				end

				if arg0_39.relationCountTime and Time.GetTimestamp() >= arg0_39.relationCountTime then
					var5_39 = true
				end
			end
		else
			var4_39 = arg0_39.parameterTargetValue
			var5_39 = false
		end

		local var6_39
		local var7_39

		if var3_39 then
			var6_39 = var3_39
		else
			local var8_39 = arg0_39:fixRelationParameter(var4_39, var0_39)
			local var9_39 = iter1_39.value or arg0_39.startValue
			local var10_39 = iter1_39.parameterSmooth or 0
			local var11_39 = var0_39.smooth and var0_39.smooth / 1000 or arg0_39.smooth

			var6_39, var7_39 = Mathf.SmoothDamp(var9_39, var8_39, var10_39, var11_39)
		end

		iter1_39.value = var6_39
		iter1_39.parameterSmooth = var7_39
		iter1_39.enable = var5_39
		iter1_39.comId = arg0_39.id
	end
end

function var0_0.fixRelationParameter(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg2_40.range or arg0_40.range
	local var1_40 = arg2_40.rangeAbs and arg2_40.rangeAbs == 1 or arg0_40.rangeAbs
	local var2_40 = arg2_40.drag_direct and arg2_40.drag_direct or arg0_40.dragDirect

	return arg0_40:fixParameterTargetValue(arg1_40, var0_40, var1_40, var2_40)
end

function var0_0.fixParameterTargetValue(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41)
	if arg1_41 < 0 and arg4_41 == 1 then
		arg1_41 = 0
	elseif arg1_41 > 0 and arg4_41 == 2 then
		arg1_41 = 0
	end

	arg1_41 = arg3_41 and math.abs(arg1_41) or arg1_41

	if arg1_41 < arg2_41[1] then
		arg1_41 = arg2_41[1]
	elseif arg1_41 > arg2_41[2] then
		arg1_41 = arg2_41[2]
	end

	return arg1_41
end

function var0_0.checkReset(arg0_42)
	if not arg0_42._active and arg0_42.parameterToStart then
		if arg0_42.parameterToStart > 0 then
			arg0_42.parameterToStart = arg0_42.parameterToStart - Time.deltaTime
		end

		if arg0_42.parameterToStart <= 0 then
			arg0_42:setTargetValue(arg0_42.startValue)

			arg0_42.parameterToStart = nil

			if arg0_42.revertResetFlag then
				arg0_42:setTriggerActionFlag(false)

				arg0_42.revertResetFlag = false
			end

			if arg0_42.offsetDragX then
				arg0_42.offsetDragX = arg0_42.startValue
				arg0_42.offsetDragTargetX = arg0_42.startValue
			end

			if arg0_42.offsetDragY then
				arg0_42.offsetDragY = arg0_42.startValue
				arg0_42.offsetDragTargetY = arg0_42.startValue
			end
		end
	end
end

function var0_0.setParameterValue(arg0_43, arg1_43, arg2_43)
	if arg1_43 then
		arg0_43.parameterValue = arg1_43
	end

	if arg2_43 then
		arg0_43.parameterSmooth = arg2_43
	end
end

function var0_0.updateState(arg0_44)
	if not arg0_44.lastFrameActive and arg0_44._active then
		arg0_44.firstActive = true
	else
		arg0_44.firstActive = false
	end

	if arg0_44.lastFrameActive and not arg0_44._active then
		arg0_44.firstStop = true
	else
		arg0_44.firstStop = false
	end

	arg0_44.lastFrameActive = arg0_44._active
end

function var0_0.updateTrigger(arg0_45)
	if not arg0_45:isActionTriggerAble() then
		return
	end

	local var0_45 = arg0_45.actionTrigger.type
	local var1_45 = arg0_45.actionTrigger.action
	local var2_45

	if arg0_45.actionTrigger.time then
		var2_45 = arg0_45.actionTrigger.time
	elseif arg0_45.actionTrigger.action_list and arg0_45.actionListIndex > 0 then
		var2_45 = arg0_45.actionTrigger.action_list[arg0_45.actionListIndex].time
	end

	local var3_45

	if arg0_45.actionTrigger.num then
		var3_45 = arg0_45.actionTrigger.num
	elseif arg0_45.actionTrigger.action_list and arg0_45.actionTrigger.action_list[arg0_45.actionListIndex].num and arg0_45.actionListIndex > 0 then
		var3_45 = arg0_45.actionTrigger.action_list[arg0_45.actionListIndex].num
	end

	if var0_45 == Live2D.DRAG_TIME_ACTION then
		if arg0_45._active then
			if math.abs(arg0_45.parameterValue - var3_45) < math.abs(var3_45) * 0.25 then
				arg0_45.triggerActionTime = arg0_45.triggerActionTime + Time.deltaTime

				if var2_45 < arg0_45.triggerActionTime and not arg0_45.l2dIsPlaying then
					arg0_45:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_46)
						if arg0_46 then
							arg0_45:onEventNotice(Live2D.ON_ACTION_DRAG_TRIGGER)
						end
					end)
				end
			else
				arg0_45.triggerActionTime = arg0_45.triggerActionTime + 0
			end
		end
	elseif var0_45 == Live2D.DRAG_CLICK_ACTION then
		if arg0_45:checkClickAction() then
			arg0_45:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_47)
				if arg0_47 then
					arg0_45:onEventNotice(Live2D.ON_ACTION_DRAG_CLICK)
				end
			end)
		end
	elseif var0_45 == Live2D.DRAG_CLICK_RANGE then
		if arg0_45:checkClickAction() then
			local var4_45 = arg0_45.actionTrigger.parameter and arg0_45.actionTrigger.parameter or arg0_45.parameterName
			local var5_45 = var3_45

			arg0_45:onEventCallback(Live2D.EVENT_GET_PARAMETER, {
				name = var4_45
			}, function(arg0_48)
				print("获取到数值 " .. var4_45 .. " = " .. arg0_48)

				if arg0_48 >= var5_45[1] and arg0_48 < var5_45[2] then
					print("数值范围内，开始触发")
					arg0_45:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_49)
						if arg0_49 then
							arg0_45:onEventNotice(Live2D.ON_ACTION_DRAG_CLICK)
						end
					end)
				end
			end)
		end
	elseif var0_45 == Live2D.DRAG_DOWN_ACTION then
		if arg0_45._active then
			arg0_45:setAbleWithFlag(true)

			if var2_45 <= Time.time - arg0_45.mouseInputDownTime then
				print("触发按压动作")
				arg0_45:setAbleWithFlag(false)
				arg0_45:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_50)
					if arg0_50 then
						arg0_45:onEventNotice(Live2D.ON_ACTION_DOWN)
					end
				end)

				if arg0_45.actionListIndex ~= 1 then
					arg0_45:setTriggerActionFlag(false)
				end

				arg0_45:setAbleWithFlag(true)

				arg0_45.mouseInputDownTime = Time.time
			end
		elseif arg0_45.actionTrigger.last and arg0_45.actionListIndex ~= 1 then
			arg0_45.actionListIndex = #arg0_45.actionTrigger.action_list

			arg0_45:setAbleWithFlag(false)
			arg0_45:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_51)
				return
			end)
			arg0_45:resetNextTriggerTime()
			arg0_45:setTriggerActionFlag(false)
		else
			arg0_45:setAbleWithFlag(false)
		end
	elseif var0_45 == Live2D.DRAG_RELATION_XY then
		if arg0_45._active then
			local var6_45 = arg0_45:fixParameterTargetValue(arg0_45.offsetDragX, arg0_45.range, arg0_45.rangeAbs, arg0_45.dragDirect)
			local var7_45 = arg0_45:fixParameterTargetValue(arg0_45.offsetDragY, arg0_45.range, arg0_45.rangeAbs, arg0_45.dragDirect)
			local var8_45 = var3_45[1]
			local var9_45 = var3_45[2]

			if math.abs(var6_45 - var8_45) < math.abs(var8_45) * 0.25 and math.abs(var7_45 - var9_45) < math.abs(var9_45) * 0.25 then
				arg0_45.triggerActionTime = arg0_45.triggerActionTime + Time.deltaTime

				if var2_45 < arg0_45.triggerActionTime and not arg0_45.l2dIsPlaying then
					arg0_45:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_52)
						if arg0_52 then
							arg0_45:onEventNotice(Live2D.ON_ACTION_XY_TRIGGER)
						end
					end)
				end
			else
				arg0_45.triggerActionTime = arg0_45.triggerActionTime + 0
			end
		end
	elseif var0_45 == Live2D.DRAG_RELATION_IDLE then
		if arg0_45.actionTrigger.const_fit then
			for iter0_45 = 1, #arg0_45.actionTrigger.const_fit do
				local var10_45 = arg0_45.actionTrigger.const_fit[iter0_45]

				if arg0_45.l2dIdleIndex == var10_45.idle and not arg0_45.l2dIsPlaying then
					arg0_45:setTargetValue(var10_45.target)
				end
			end
		end
	elseif var0_45 == Live2D.DRAG_CLICK_MANY then
		if arg0_45:checkClickAction() then
			arg0_45:onEventCallback(Live2D.EVENT_ACTION_APPLY)
		end
	elseif var0_45 == Live2D.DRAG_LISTENER_EVENT then
		if arg0_45._listenerTrigger then
			arg0_45:onEventCallback(Live2D.EVENT_ACTION_APPLY)
		end
	elseif var0_45 == Live2D.DRAG_DOWN_TOUCH then
		arg0_45:setAbleWithFlag(arg0_45._active)

		if arg0_45._active then
			local var11_45 = Time.deltaTime / arg0_45.actionTrigger.delta
			local var12_45 = arg0_45.parameterTargetValue + var11_45
			local var13_45 = arg0_45:fixParameterTargetValue(var12_45, arg0_45.range, arg0_45.rangeAbs, arg0_45.dragDirect)

			arg0_45:setTargetValue(var13_45)
		end
	elseif var0_45 == Live2D.DRAG_CLICK_PARAMETER then
		if arg0_45:checkClickAction() then
			local var14_45 = var3_45
			local var15_45 = arg0_45.actionTrigger.parameter

			arg0_45:onEventCallback(Live2D.EVENT_GET_PARAMETER, {
				name = var15_45
			}, function(arg0_53)
				if math.abs(var14_45 - arg0_53) <= 0.05 then
					print("数值允许播放，开始执行动作 " .. arg0_45.actionTrigger.action)
					arg0_45:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function(arg0_54)
						if arg0_54 then
							arg0_45:onEventNotice(Live2D.ON_ACTION_DRAG_CLICK)
						end
					end)
				end
			end)
		end
	elseif var0_45 == Live2D.DRAG_ANIMATION_PLAY then
		local var16_45 = arg0_45.actionTrigger.trigger_name

		if arg0_45.actionTrigger.trigger_index > 0 and arg0_45.actionTrigger.trigger_name == "idle" then
			var16_45 = var16_45 .. arg0_45.actionTrigger.trigger_index
		end

		if arg0_45.stateInfo:IsName(var16_45) and arg0_45.l2dIdleIndex == arg0_45.actionTrigger.trigger_index and arg0_45.normalTime >= arg0_45.actionTrigger.trigger_rate then
			arg0_45:onEventCallback(Live2D.EVENT_ACTION_APPLY, {}, function()
				return
			end)
		end
	elseif var0_45 == Live2D.DRAG_EXTEND_ACTION_RULE and not arg0_45.extendActionFlag then
		arg0_45.extendActionFlag = true
	end
end

function var0_0.getExtendAction(arg0_56)
	return arg0_56.extendActionFlag
end

function var0_0.checkActionInExtendFlag(arg0_57, arg1_57)
	local var0_57 = false
	local var1_57 = false

	if not arg0_57.extendActionFlag then
		return var0_57, var1_57
	end

	local var2_57 = arg0_57.actionTrigger.parameter
	local var3_57 = arg0_57.actionTrigger.num
	local var4_57 = false

	arg0_57:onEventCallback(Live2D.EVENT_GET_DRAG_PARAMETER, {
		name = var2_57
	}, function(arg0_58)
		if arg0_58 > var3_57[1] and arg0_58 <= var3_57[2] then
			var4_57 = true
		end
	end)

	if not var4_57 then
		return var0_57, var0_57
	end

	local var5_57 = arg0_57.actionTriggerActive.ignore
	local var6_57 = arg0_57.actionTriggerActive.enable

	if var5_57 and table.contains(var5_57, arg1_57) then
		var0_57 = true
	end

	if var6_57 and table.contains(var6_57, arg1_57) then
		var1_57 = true
	end

	return var0_57, var1_57
end

function var0_0.setAbleWithFlag(arg0_59, arg1_59)
	if arg0_59.ableFlag ~= arg1_59 then
		arg0_59.ableFlag = arg1_59

		arg0_59:onEventCallback(Live2D.EVENT_ACTION_ABLE, {
			ableFlag = arg1_59
		})
	end
end

function var0_0.triggerAction(arg0_60)
	arg0_60.nextTriggerTime = arg0_60.limitTime

	arg0_60:setTriggerActionFlag(true)
end

function var0_0.isActionTriggerAble(arg0_61)
	if arg0_61.actionTrigger.type == nil then
		return false
	end

	if not arg0_61.actionTrigger or arg0_61.actionTrigger == "" then
		return false
	end

	if arg0_61.nextTriggerTime - Time.deltaTime >= 0 then
		arg0_61.nextTriggerTime = arg0_61.nextTriggerTime - Time.deltaTime

		return false
	end

	if arg0_61.isTriggerAtion then
		return false
	end

	return true
end

function var0_0.updateStateData(arg0_62, arg1_62)
	if arg0_62.l2dIdleIndex ~= arg1_62.idleIndex then
		if type(arg0_62.revertIdleIndex) == "boolean" and arg0_62.revertIdleIndex == true then
			arg0_62:setTargetValue(arg0_62.startValue)
		elseif type(arg0_62.revertIdleIndex) == "table" and table.contains(arg0_62.revertIdleIndex, arg1_62.idleIndex) then
			arg0_62:setTargetValue(arg0_62.startValue)
		end
	end

	arg0_62.lastActionIndex = arg0_62.actionListIndex

	if arg1_62.isPlaying and arg0_62.actionTrigger.reset_index_action and arg1_62.actionName and table.contains(arg0_62.actionTrigger.reset_index_action, arg1_62.actionName) then
		arg0_62.actionListIndex = 1
	end

	if arg0_62.revertActionIndex and arg0_62.lastActionIndex ~= arg0_62.actionListIndex then
		arg0_62:setTargetValue(arg0_62.startValue)
	end

	arg0_62.l2dIdleIndex = arg1_62.idleIndex
	arg0_62.l2dIsPlaying = arg1_62.isPlaying
	arg0_62.l2dIgnoreReact = arg1_62.ignoreReact
	arg0_62.l2dPlayActionName = arg1_62.actionName

	if not arg0_62.l2dIsPlaying and arg0_62.isTriggerAtion then
		arg0_62:setTriggerActionFlag(false)
	end

	if arg0_62.l2dIdleIndex and arg0_62.idleOn and #arg0_62.idleOn > 0 then
		arg0_62.reactConditionFlag = not table.contains(arg0_62.idleOn, arg0_62.l2dIdleIndex)
	end

	if arg0_62.l2dIdleIndex and arg0_62.idleOff and #arg0_62.idleOff > 0 then
		arg0_62.reactConditionFlag = table.contains(arg0_62.idleOff, arg0_62.l2dIdleIndex)
	end
end

function var0_0.checkClickAction(arg0_63)
	if arg0_63.firstActive then
		arg0_63:setAbleWithFlag(true)
	elseif arg0_63.firstStop then
		local var0_63 = math.abs(arg0_63.mouseInputUp.x - arg0_63.mouseInputDown.x) < 30 and math.abs(arg0_63.mouseInputUp.y - arg0_63.mouseInputDown.y) < 30
		local var1_63 = arg0_63.mouseInputUpTime - arg0_63.mouseInputDownTime < 0.5

		if var0_63 and var1_63 and not arg0_63.l2dIsPlaying then
			arg0_63.clickTriggerTime = 0.01
			arg0_63.clickApplyFlag = true
		else
			arg0_63:setAbleWithFlag(false)
		end
	elseif arg0_63.clickTriggerTime and arg0_63.clickTriggerTime > 0 then
		arg0_63.clickTriggerTime = arg0_63.clickTriggerTime - Time.deltaTime

		if arg0_63.clickTriggerTime <= 0 then
			arg0_63.clickTriggerTime = nil

			arg0_63:setAbleWithFlag(false)

			if arg0_63.clickApplyFlag then
				arg0_63.clickApplyFlag = false

				return true
			end
		end
	end

	return false
end

function var0_0.saveData(arg0_64)
	local var0_64 = arg0_64.id
	local var1_64 = arg0_64.live2dData:GetShipSkinConfig().id
	local var2_64 = arg0_64.live2dData.ship.id

	if arg0_64.revert == -1 and arg0_64.saveParameterFlag then
		Live2dConst.SaveDragData(var0_64, var1_64, var2_64, arg0_64.parameterTargetValue)
	end

	if arg0_64.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		print("保存actionListIndex" .. arg0_64.actionListIndex)
		Live2dConst.SetDragActionIndex(var0_64, var1_64, var2_64, arg0_64.actionListIndex)
	end

	if arg0_64._relationFlag then
		Live2dConst.SetRelationData(var0_64, var1_64, var2_64, arg0_64:getRelationSaveData())
	end
end

function var0_0.loadData(arg0_65)
	local var0_65 = arg0_65.id
	local var1_65 = arg0_65.live2dData:GetShipSkinConfig().id
	local var2_65 = arg0_65.live2dData.ship.id

	if arg0_65.revert == -1 and arg0_65.saveParameterFlag then
		local var3_65 = Live2dConst.GetDragData(arg0_65.id, arg0_65.live2dData:GetShipSkinConfig().id, arg0_65.live2dData.ship.id)

		if var3_65 then
			arg0_65:setParameterValue(var3_65)
			arg0_65:setTargetValue(var3_65)
		end

		if var3_65 == arg0_65.startValue and arg0_65._relationParameterList and #arg0_65._relationParameterList > 0 then
			arg0_65:clearRelationValue()
		end
	end

	if arg0_65.actionTrigger.type == Live2D.DRAG_CLICK_MANY then
		arg0_65.actionListIndex = Live2dConst.GetDragActionIndex(arg0_65.id, arg0_65.live2dData:GetShipSkinConfig().id, arg0_65.live2dData.ship.id) or 1
	end

	if arg0_65._relationFlag then
		local var4_65 = Live2dConst.GetRelationData(var0_65, var1_65, var2_65)

		arg0_65.offsetDragX = var4_65.drag_x and var4_65.drag_x or arg0_65.startValue
		arg0_65.offsetDragY = var4_65.drag_y and var4_65.drag_y or arg0_65.startValue
	end
end

function var0_0.getRelationSaveData(arg0_66)
	return {
		[Live2dConst.RELATION_DRAG_X] = arg0_66.offsetDragX,
		[Live2dConst.RELATION_DRAG_Y] = arg0_66.offsetDragY
	}
end

function var0_0.clearRelationValue(arg0_67)
	if arg0_67._relationParameterList and #arg0_67._relationParameterList > 0 then
		for iter0_67 = 1, #arg0_67._relationParameterList do
			local var0_67 = arg0_67._relationParameterList[iter0_67]

			if var0_67.data.type == Live2D.relation_type_drag_x or var0_67.data.type == Live2D.relation_type_drag_y then
				var0_67.value = var0_67.start or arg0_67.startValue or 0
				var0_67.enable = true
			end

			arg0_67.offsetDragX, arg0_67.offsetDragY = arg0_67.startValue, arg0_67.startValue
		end
	end
end

function var0_0.loadL2dFinal(arg0_68)
	arg0_68.loadL2dStep = true
end

function var0_0.clearData(arg0_69)
	if arg0_69.revert == -1 then
		arg0_69.actionListIndex = 1

		arg0_69:setParameterValue(arg0_69.startValue)
		arg0_69:setTargetValue(arg0_69.startValue)
		arg0_69:clearRelationValue()
	end
end

function var0_0.setTriggerActionFlag(arg0_70, arg1_70)
	arg0_70.isTriggerAtion = arg1_70
end

function var0_0.dispose(arg0_71)
	arg0_71._active = false
	arg0_71._parameterCom = nil
	arg0_71.parameterValue = arg0_71.startValue
	arg0_71.parameterTargetValue = 0
	arg0_71.parameterSmooth = 0
	arg0_71.mouseInputDown = Vector2(0, 0)
	arg0_71.live2dData = nil
end

return var0_0
