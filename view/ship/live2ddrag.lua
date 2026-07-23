local var0_0 = class("Live2dDrag")
local var1_0 = 4
local var2_0 = {}
local var3_0 = 1
local var4_0 = 2
local var5_0 = 3
local var6_0 = 1
local var7_0 = 2
local var8_0 = 1

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.data = arg1_1
	arg0_1.live2dData = arg2_1
	arg0_1.commonData = arg3_1
	arg0_1.frameRate = Application.targetFrameRate or 60
	var2_0 = {
		Live2DPainting.DRAG_DOWN_ACTION
	}
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

	if #arg1_1.revert_idle_index > 0 then
		if type(arg1_1.revert_idle_index) == "table" then
			var0_1 = arg1_1.revert_idle_index
		elseif tonumber(arg1_1.revert_idle_index) and tonumber(arg1_1.revert_idle_index) >= 0 then
			var0_1 = tonumber(arg1_1.revert_idle_index) == 1 and true or false
		end
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
	arg0_1.parameterStartValue = arg0_1.startValue
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

								print(arg0_2.id .. "=" .. arg0_2.parameterName .. "等待动作结束后的target赋值" .. arg0_2.parameterTargetValue)
							else
								arg0_2:setTargetValue(var14_2)
								print(arg0_2.id .. "=" .. arg0_2.parameterName .. "监听 数值变更为" .. arg0_2.parameterTargetValue)
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
					arg0_2:onEventCallback(Live2DPainting.EVENT_CHANGE_IDLE_INDEX, {
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
	if arg1_3 == Live2DPainting.ON_ACTION_DRAG_CLICK then
		if arg0_3.actionTrigger.click_cd and table.contains(arg0_3.actionTrigger.click_cd, arg2_3.draw_able_name) then
			arg0_3.nextTriggerTime = arg0_3.limitTime
		end
	elseif arg1_3 == Live2DPainting.ON_ACTION_PLAY then
		arg0_3.nextTriggerTime = arg0_3.limitTime <= 0.2 and arg0_3.limitTime or 0.2
	end
end

function var0_0.getChangeCheckName(arg0_4, arg1_4, arg2_4)
	if arg1_4 == Live2DPainting.ON_ACTION_PLAY then
		return arg2_4.action
	elseif arg1_4 == Live2DPainting.ON_ACTION_DRAG_CLICK then
		return arg2_4.draw_able_name
	elseif arg1_4 == Live2DPainting.ON_ACTION_CHANGE_IDLE then
		return arg2_4.idle
	elseif arg1_4 == Live2DPainting.ON_ACTION_PARAMETER then
		-- block empty
	elseif arg1_4 == Live2DPainting.ON_ACTION_DOWN then
		-- block empty
	elseif arg1_4 == Live2DPainting.ON_ACTION_XY_TRIGGER then
		-- block empty
	elseif arg1_4 == Live2DPainting.ON_ACTION_DRAG_TRIGGER then
		-- block empty
	end

	return nil
end

function var0_0.startDrag(arg0_5, arg1_5)
	if arg0_5.ignoreAction and arg0_5.l2dIsPlaying then
		return
	end

	print(arg0_5.drawAbleName .. " 按下了 id = " .. arg0_5.id)

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

	if arg0_9.actionTrigger.type == Live2DPainting.DRAG_DOWN_ACTION and arg0_9.actionTrigger.last then
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
		elseif arg0_11.actionTrigger and arg0_11.actionTrigger.type == Live2DPainting.DRAG_DOWN_TOUCH then
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

				if arg0_11.offsetDragTargetX then
					arg0_11.offsetDragTargetX = var0_11[var5_11]
				end

				if arg0_11.offsetDragTargetY then
					arg0_11.offsetDragTargetY = var0_11[var5_11]
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

function var0_0.getParameterName(arg0_15)
	if arg0_15.parameterName and #arg0_15.parameterName > 0 then
		return arg0_15.parameterName
	end

	return nil
end

function var0_0.addRelationComData(arg0_16, arg1_16, arg2_16)
	table.insert(arg0_16._relationParameterList, {
		com = arg1_16,
		data = arg2_16
	})
end

function var0_0.getRelationParameterList(arg0_17)
	return arg0_17._relationParameterList
end

function var0_0.getReactCondition(arg0_18)
	return arg0_18.reactConditionFlag
end

function var0_0.getActive(arg0_19)
	return arg0_19._active
end

function var0_0.getParameterUpdateFlag(arg0_20)
	return arg0_20._parameterUpdateFlag
end

function var0_0.setEventCallback(arg0_21, arg1_21)
	arg0_21._eventCallback = arg1_21
end

function var0_0.onEventCallback(arg0_22, arg1_22, arg2_22, arg3_22)
	if arg1_22 == Live2DPainting.EVENT_ACTION_APPLY then
		local var0_22 = {}
		local var1_22
		local var2_22 = false
		local var3_22
		local var4_22
		local var5_22
		local var6_22 = false

		local function var7_22()
			if arg0_22:isApplyStopDrag() then
				arg0_22:stopDrag()
			end
		end

		if arg0_22.actionTrigger.action then
			var1_22 = arg0_22:fillterAction(arg0_22.actionTrigger.action)
			var0_22 = arg0_22.actionTriggerActive
			var2_22 = arg0_22.actionTrigger.focus == 1 and true or false
			var3_22 = arg0_22.actionTrigger.target or nil
			var6_22 = arg0_22.actionTrigger.target_focus == 1 and true or false

			if (arg0_22.actionTrigger.circle ~= nil and true or false) and var3_22 and var3_22 == arg0_22.parameterTargetValue then
				var3_22 = arg0_22.startValue
			end

			var4_22 = arg0_22.actionTrigger.react or nil

			arg0_22:triggerAction()
			var7_22()
		elseif arg0_22.actionTrigger.action_list then
			local var8_22 = arg0_22.actionTrigger.action_list[arg0_22.actionListIndex]

			var1_22 = arg0_22:fillterAction(var8_22.action)

			if arg0_22.actionTriggerActive.active_list and arg0_22.actionListIndex <= #arg0_22.actionTriggerActive.active_list then
				var0_22 = arg0_22.actionTriggerActive.active_list[arg0_22.actionListIndex]
			else
				var0_22 = arg0_22.actionTriggerActive
			end

			var2_22 = var8_22.focus == 1 and true or false

			if not var2_22 and arg0_22.actionTrigger.focus then
				var2_22 = arg0_22.actionTrigger.focus == 1 and true or false
			end

			var3_22 = var8_22.target or nil
			var6_22 = var8_22.target_focus == 1 and true or false
			var4_22 = var8_22.react or nil

			if var1_22 and #var1_22 > 0 then
				arg0_22:triggerAction()
			end

			if arg0_22.actionListIndex == #arg0_22.actionTrigger.action_list then
				arg0_22.actionListIndex = 1

				var7_22()
			else
				arg0_22.actionListIndex = arg0_22.actionListIndex + 1
			end

			print("id = " .. arg0_22.id .. " action list index = " .. arg0_22.actionListIndex)
		elseif not arg0_22.actionTrigger.action then
			var1_22 = arg0_22:fillterAction(arg0_22.actionTrigger.action)
			var0_22 = arg0_22.actionTriggerActive
			var2_22 = arg0_22.actionTrigger.focus == 1 and true or false
			var3_22 = arg0_22.actionTrigger.target or nil
			var6_22 = arg0_22.actionTrigger.target_focus == 1 and true or false

			local var9_22 = arg0_22.actionTrigger.circle ~= nil and true or false

			var4_22 = arg0_22.actionTrigger.react or nil

			if var9_22 and var3_22 and var3_22 == arg0_22.parameterTargetValue then
				var3_22 = arg0_22.startValue
			end

			arg0_22:triggerAction()
			arg0_22:setTriggerActionFlag(false)
			var7_22()
		end

		if var0_22.idle then
			if type(var0_22.idle) == "number" then
				if var0_22.idle == arg0_22.l2dIdleIndex and not var0_22.repeat_flag then
					return
				end
			elseif type(var0_22.idle) == "table" and #var0_22.idle == 1 and var0_22.idle[1] == arg0_22.l2dIdleIndex and not var0_22.repeat_flag then
				return
			end
		end

		print("执行aplly数据 id = " .. arg0_22.id .. "播放action = " .. tostring(var1_22) .. " active idle is " .. tostring(var0_22.idle))

		if var3_22 then
			arg0_22:setTargetValue(var3_22)

			if var6_22 then
				arg0_22:setParameterValue(var3_22)
			end

			if not var1_22 then
				arg0_22.revertResetFlag = true
			end
		end

		if var2_22 then
			arg0_22:setTriggerActionFlag(false)
		end

		arg2_22 = {
			id = arg0_22.id,
			action = var1_22,
			activeData = var0_22,
			focus = var2_22,
			react = var4_22,
			callback = arg3_22,
			finishCall = function()
				arg0_22:actionApplyFinish()
			end
		}
	elseif arg1_22 == Live2DPainting.EVENT_ACTION_ABLE then
		-- block empty
	elseif arg1_22 == Live2DPainting.EVENT_CHANGE_IDLE_INDEX then
		print("change idle")
	elseif arg1_22 == Live2DPainting.EVENT_GET_PARAMETER then
		arg2_22.callback = arg3_22
	elseif arg1_22 == Live2DPainting.EVENT_GET_DRAG_PARAMETER then
		arg2_22.callback = arg3_22
	elseif arg1_22 == Live2DPainting.EVENT_GET_WORLD_POSITION then
		arg2_22.callback = arg3_22
	elseif arg1_22 == Live2DPainting.EVENT_GAME_XIAQI then
		arg2_22.callback = arg3_22
	end

	arg0_22._eventCallback(arg1_22, arg2_22)
end

function var0_0.isApplyStopDrag(arg0_25)
	if arg0_25.actionTrigger and arg0_25.actionTrigger.type == Live2DPainting.DRAG_MOVE_DOWN_UP then
		return false
	end

	return true
end

function var0_0.fillterAction(arg0_26, arg1_26)
	if type(arg1_26) == "table" then
		return arg1_26[math.random(1, #arg1_26)]
	else
		return arg1_26
	end
end

function var0_0.onEventNotice(arg0_27, arg1_27)
	if arg0_27._eventCallback then
		local var0_27 = arg0_27:getCommonNoticeData()

		arg0_27._eventCallback(arg1_27, var0_27)
	end
end

function var0_0.getCommonNoticeData(arg0_28)
	return {
		draw_able_name = arg0_28.drawAbleName,
		parameter_name = arg0_28.parameterName,
		parameter_target = arg0_28.parameterTargetValue
	}
end

function var0_0.setTargetValue(arg0_29, arg1_29)
	arg0_29.parameterSmooth = 0
	arg0_29.parameterStartValue = arg0_29.parameterTargetValue
	arg0_29.parameterTargetValue = arg1_29
end

function var0_0.setTargetValueDelay(arg0_30, arg1_30, arg2_30)
	arg0_30:setTargetValue(arg1_30)

	arg0_30.delayTargetTime = arg2_30
end

function var0_0.getParameter(arg0_31)
	return arg0_31.parameterValue
end

function var0_0.getParameterTarget(arg0_32)
	return arg0_32.parameterTargetValue
end

function var0_0.getParameToTargetFlag(arg0_33)
	if arg0_33.parameterValue ~= arg0_33.parameterTargetValue then
		return true
	end

	if arg0_33.parameterToStart and arg0_33.parameterToStart > 0 then
		return true
	end

	return false
end

function var0_0.actionApplyFinish(arg0_34)
	return
end

function var0_0.stepParameter(arg0_35, arg1_35)
	arg0_35:updateStepData(arg1_35)
	arg0_35:updateActiveState()
	arg0_35:updateTrigger()
	arg0_35:updateParameterUpdateFlag()
	arg0_35:updateGyro()
	arg0_35:updateDrag()
	arg0_35:updateCircleDrag()
	arg0_35:updateReactValue()
	arg0_35:updateParameterValue()
	arg0_35:updateRelationValue()
	arg0_35:checkReset()

	arg0_35.loadL2dStep = false
end

function var0_0.updateStepData(arg0_36, arg1_36)
	arg0_36.reactPos = arg1_36.reactPos
	arg0_36.lastNormalTime = arg0_36.normalTime
	arg0_36.normalTime = arg1_36.normalTime
	arg0_36.stateInfo = arg1_36.stateInfo
end

function var0_0.updateParameterUpdateFlag(arg0_37)
	if arg0_37.actionTrigger.type == Live2DPainting.DRAG_CLICK_ACTION then
		arg0_37._parameterUpdateFlag = true
	elseif arg0_37.actionTrigger.type == Live2DPainting.DRAG_RELATION_IDLE then
		if not arg0_37._parameterUpdateFlag then
			if not arg0_37.l2dIsPlaying then
				arg0_37._parameterUpdateFlag = true

				arg0_37:changeParameComAble(true)
			elseif not table.contains(arg0_37.actionTrigger.remove_com_list, arg0_37.l2dPlayActionName) then
				arg0_37._parameterUpdateFlag = true

				arg0_37:changeParameComAble(true)
			end
		elseif arg0_37._parameterUpdateFlag == true and arg0_37.l2dIsPlaying and table.contains(arg0_37.actionTrigger.remove_com_list, arg0_37.l2dPlayActionName) then
			arg0_37._parameterUpdateFlag = false

			arg0_37:changeParameComAble(false)
		end
	elseif arg0_37.actionTrigger.type == Live2DPainting.DRAG_DOWN_TOUCH then
		arg0_37._parameterUpdateFlag = true
	elseif arg0_37.actionTrigger.type == Live2DPainting.DRAG_LISTENER_EVENT then
		arg0_37._parameterUpdateFlag = true
	elseif arg0_37.actionTrigger.type == Live2DPainting.DRAG_ANIMATION_PLAY then
		arg0_37._parameterUpdateFlag = true
	elseif arg0_37.actionTrigger.type == Live2DPainting.DRAG_WITH_PARAMETER_MOVE then
		arg0_37._parameterUpdateFlag = true
	elseif arg0_37.actionTrigger.type == Live2DPainting.DRAG_MOVE_DOWN_UP then
		arg0_37._parameterUpdateFlag = true
	elseif arg0_37.actionTrigger.type == Live2DPainting.DRAG_GAME_XIAQI then
		arg0_37._parameterUpdateFlag = true
	else
		arg0_37._parameterUpdateFlag = false
	end
end

function var0_0.changeParameComAble(arg0_38, arg1_38)
	if arg0_38.parameterComAdd == arg1_38 then
		return
	end

	arg0_38.parameterComAdd = arg1_38

	if arg1_38 then
		arg0_38:onEventCallback(Live2DPainting.EVENT_ADD_PARAMETER_COM, {
			com = arg0_38._parameterCom,
			start = arg0_38.startValue,
			mode = arg0_38.mode
		})
	else
		arg0_38:onEventCallback(Live2DPainting.EVENT_REMOVE_PARAMETER_COM, {
			com = arg0_38._parameterCom,
			mode = arg0_38.mode
		})
	end
end

function var0_0.updateDrag(arg0_39)
	if not arg0_39.offsetX and not arg0_39.offsetY then
		return
	end

	local var0_39

	if arg0_39._active then
		local var1_39 = Input.mousePosition

		if arg0_39.offsetX and arg0_39.offsetX ~= 0 then
			local var2_39 = var1_39.x - arg0_39.mouseInputDown.x

			var0_39 = arg0_39.offsetDragTargetX + var2_39 / arg0_39.offsetX
			arg0_39.offsetDragX = var0_39
		end

		if arg0_39.offsetY and arg0_39.offsetY ~= 0 then
			local var3_39 = var1_39.y - arg0_39.mouseInputDown.y

			var0_39 = arg0_39.offsetDragTargetY + var3_39 / arg0_39.offsetY
			arg0_39.offsetDragY = var0_39
		end

		if var0_39 then
			arg0_39:setTargetValue(arg0_39:fixParameterTargetValue(var0_39, arg0_39.range, arg0_39.rangeAbs, arg0_39.dragDirect))
		end
	end

	arg0_39._parameterUpdateFlag = true
end

function var0_0.updateCircleDrag(arg0_40)
	if not arg0_40.offsetCirclePos then
		return
	end

	if arg0_40._active and arg0_40.mouseWorld ~= nil then
		if not arg0_40.circleDragWorld then
			arg0_40:onEventCallback(Live2DPainting.EVENT_GET_WORLD_POSITION, {
				pos = arg0_40.offsetCirclePos,
				name = arg0_40.drawAbleName
			}, function(arg0_41)
				arg0_40.circleDragWorld = arg0_41
			end)
		end

		local var0_40 = (math.atan2(arg0_40.mouseWorld.x - arg0_40.circleDragWorld.x, arg0_40.mouseWorld.y - arg0_40.circleDragWorld.y) * math.rad2Deg + 360 - arg0_40.offsetCircleStart) % 360 / 360
		local var1_40 = arg0_40.range[2] * var0_40

		arg0_40:setTargetValue(var1_40)

		arg0_40._parameterUpdateFlag = true
	elseif arg0_40.parameterTargetValue ~= arg0_40.parameterValue then
		arg0_40._parameterUpdateFlag = true
	end
end

function var0_0.updateGyro(arg0_42)
	if not arg0_42.gyro then
		return
	end

	if not Input.gyro.enabled then
		arg0_42:setTargetValue(0)

		arg0_42._parameterUpdateFlag = true

		return
	end

	local var0_42 = Input.gyro and Input.gyro.attitude or Vector3.zero
	local var1_42 = 0

	if arg0_42.gyroX and not math.isnan(var0_42.y) then
		var1_42 = Mathf.Clamp(var0_42.y * arg0_42.sensitive, -0.5, 0.5)
	elseif arg0_42.gyroY and not math.isnan(var0_42.x) then
		var1_42 = Mathf.Clamp(var0_42.x * arg0_42.sensitive, -0.5, 0.5)
	elseif arg0_42.gyroZ and not math.isnan(var0_42.z) then
		var1_42 = Mathf.Clamp(var0_42.z * arg0_42.sensitive, -0.5, 0.5)
	end

	if IsUnityEditor then
		if L2D_USE_RANDOM_ATTI then
			if arg0_42.randomAttitudeIndex == 0 then
				var1_42 = math.random() - 0.5

				local var2_42 = (var1_42 + 0.5) * (arg0_42.range[2] - arg0_42.range[1]) + arg0_42.range[1]

				arg0_42:setTargetValue(var2_42)

				arg0_42.randomAttitudeIndex = L2D_RANDOM_PARAM
			elseif arg0_42.randomAttitudeIndex > 0 then
				arg0_42.randomAttitudeIndex = arg0_42.randomAttitudeIndex - 1
			end
		end
	else
		local var3_42 = (var1_42 + 0.5) * (arg0_42.range[2] - arg0_42.range[1]) + arg0_42.range[1]

		arg0_42:setTargetValue(var3_42)
	end

	arg0_42._parameterUpdateFlag = true
end

function var0_0.updateReactValue(arg0_43)
	if not arg0_43.reactX and not arg0_43.reactY then
		return
	end

	local var0_43
	local var1_43 = false

	if arg0_43.l2dIgnoreReact then
		var0_43 = arg0_43.parameterTargetValue
	elseif arg0_43.reactX then
		var0_43 = arg0_43.reactPos.x * arg0_43.reactX
		var1_43 = true
	else
		var0_43 = arg0_43.reactPos.y * arg0_43.reactY
		var1_43 = true
	end

	if var1_43 then
		arg0_43:setTargetValue(arg0_43:fixParameterTargetValue(var0_43, arg0_43.range, arg0_43.rangeAbs, arg0_43.dragDirect))
	end

	arg0_43._parameterUpdateFlag = true
end

function var0_0.updateParameterValue(arg0_44)
	if arg0_44.delayTargetTime and arg0_44.delayTargetTime > 0 then
		arg0_44.delayTargetTime = arg0_44.delayTargetTime - Time.deltaTime

		if arg0_44.delayTargetTime <= 0 then
			arg0_44.delayTargetTime = nil
		end

		return
	end

	if arg0_44.prepareTargetValue and not arg0_44.l2dIsPlaying then
		arg0_44:setTargetValue(arg0_44.prepareTargetValue)

		arg0_44.prepareTargetValue = nil
	end

	if arg0_44._parameterUpdateFlag and arg0_44.parameterValue ~= arg0_44.parameterTargetValue then
		if math.abs(arg0_44.parameterValue - arg0_44.parameterTargetValue) < 0.05 then
			arg0_44:setParameterValue(arg0_44.parameterTargetValue)
		elseif arg0_44.parameterSmoothTime and arg0_44.parameterSmoothTime > 0 then
			local var0_44 = arg0_44.parameterValue
			local var1_44 = arg0_44.parameterTargetValue
			local var2_44 = arg0_44:checkUpdateParameterNum(var1_44, var0_44)
			local var3_44, var4_44 = Live2DExtend.CustomSmoothValue(arg0_44.parameterStartValue, var2_44, arg0_44.parameterSmoothTime, arg0_44.parameterSmooth, Time.fixedDeltaTime)

			arg0_44:setParameterValue(var3_44, var4_44)
		else
			arg0_44:setParameterValue(arg0_44.parameterTargetValue, 0)
		end
	end
end

function var0_0.checkUpdateParameterNum(arg0_45, arg1_45, arg2_45)
	if arg0_45.offsetCirclePos and math.abs(arg1_45 - arg2_45) >= arg0_45.rangeOffset / 2 then
		if arg2_45 < arg1_45 then
			arg1_45 = arg1_45 - arg0_45.rangeOffset
		else
			arg1_45 = arg1_45 + arg0_45.rangeOffset
		end
	end

	return arg1_45
end

function var0_0.updateRelationValue(arg0_46)
	for iter0_46, iter1_46 in ipairs(arg0_46._relationParameterList) do
		local var0_46 = iter1_46.data
		local var1_46 = var0_46.type
		local var2_46 = var0_46.relation_value
		local var3_46 = var0_46.target
		local var4_46
		local var5_46

		if var1_46 == Live2DPainting.relation_type_drag_x then
			var4_46 = arg0_46.offsetDragX or iter1_46.start or arg0_46.startValue or 0
			var5_46 = true
		elseif var1_46 == Live2DPainting.relation_type_drag_y then
			var4_46 = arg0_46.offsetDragY or iter1_46.start or arg0_46.startValue or 0
			var5_46 = true
		elseif var1_46 == Live2DPainting.relation_type_action_index then
			var4_46 = var2_46[arg0_46.actionListIndex]
			var4_46 = var4_46 or 0
			var5_46 = true
		elseif var1_46 == Live2DPainting.relation_type_idle then
			if arg0_46.loadL2dStep and arg0_46.l2dIdleIndex == var0_46.idle then
				var5_46 = true
			end

			if arg0_46.l2dIsPlaying then
				if arg0_46.l2dPlayActionName == arg0_46.actionTrigger.action then
					arg0_46.relationActive = true
				end
			else
				arg0_46.relationActive = false
				arg0_46.relationCountTime = nil
			end

			if not var5_46 and arg0_46.relationActive and arg0_46.l2dIdleIndex == var0_46.idle then
				if not arg0_46.relationCountTime then
					arg0_46.relationCountTime = Time.GetTimestamp() + var0_46.time
				end

				if arg0_46.relationCountTime and Time.GetTimestamp() >= arg0_46.relationCountTime then
					var5_46 = true
				end
			end
		else
			var4_46 = arg0_46.parameterTargetValue
			var5_46 = false
		end

		local var6_46
		local var7_46

		if var3_46 then
			var6_46 = var3_46
		else
			local var8_46 = arg0_46:fixRelationParameter(var4_46, var0_46)
			local var9_46 = iter1_46.value or arg0_46.startValue

			if math.abs(var8_46 - var9_46) <= 0.01 then
				var6_46 = var8_46
			else
				local var10_46 = iter1_46.parameterSmooth or 0
				local var11_46 = var0_46.smooth and var0_46.smooth / 1000 or arg0_46.smooth

				var6_46, var7_46 = Mathf.SmoothDamp(var9_46, var8_46, var10_46, var11_46)
			end
		end

		iter1_46.target = var4_46
		iter1_46.value = var6_46
		iter1_46.parameterSmooth = var7_46
		iter1_46.enable = var5_46
		iter1_46.comId = arg0_46.id
	end
end

function var0_0.fixRelationParameter(arg0_47, arg1_47, arg2_47)
	local var0_47 = arg2_47.range or arg0_47.range
	local var1_47 = arg2_47.rangeAbs and arg2_47.rangeAbs == 1 or arg0_47.rangeAbs
	local var2_47 = arg2_47.drag_direct and arg2_47.drag_direct or arg0_47.dragDirect

	return arg0_47:fixParameterTargetValue(arg1_47, var0_47, var1_47, var2_47)
end

function var0_0.fixParameterTargetValue(arg0_48, arg1_48, arg2_48, arg3_48, arg4_48)
	if arg1_48 < 0 and arg4_48 == 1 then
		arg1_48 = 0
	elseif arg1_48 > 0 and arg4_48 == 2 then
		arg1_48 = 0
	end

	arg1_48 = arg3_48 and math.abs(arg1_48) or arg1_48

	if arg1_48 < arg2_48[1] then
		arg1_48 = arg2_48[1]
	elseif arg1_48 > arg2_48[2] then
		arg1_48 = arg2_48[2]
	end

	return arg1_48
end

function var0_0.checkReset(arg0_49)
	if not arg0_49._active and arg0_49.parameterToStart then
		if arg0_49.parameterToStart > 0 then
			arg0_49.parameterToStart = arg0_49.parameterToStart - Time.deltaTime
		end

		if arg0_49.parameterToStart <= 0 then
			arg0_49:setTargetValue(arg0_49.startValue)

			arg0_49.parameterToStart = nil

			if arg0_49.revertResetFlag then
				arg0_49:setTriggerActionFlag(false)

				arg0_49.revertResetFlag = false
			end

			if arg0_49.offsetDragX then
				arg0_49.offsetDragX = arg0_49.startValue
				arg0_49.offsetDragTargetX = arg0_49.startValue
			end

			if arg0_49.offsetDragY then
				arg0_49.offsetDragY = arg0_49.startValue
				arg0_49.offsetDragTargetY = arg0_49.startValue
			end
		end
	end
end

function var0_0.setParameterValue(arg0_50, arg1_50, arg2_50)
	if arg1_50 then
		arg0_50.parameterValue = arg1_50
	end

	if arg2_50 then
		arg0_50.parameterSmooth = arg2_50
	end
end

function var0_0.updateActiveState(arg0_51)
	if not arg0_51.lastFrameActive and arg0_51._active then
		arg0_51.firstActive = true
	else
		arg0_51.firstActive = false
	end

	if arg0_51.lastFrameActive and not arg0_51._active then
		arg0_51.firstStop = true
	else
		arg0_51.firstStop = false
	end

	arg0_51.lastFrameActive = arg0_51._active
end

function var0_0.updateTrigger(arg0_52)
	if not arg0_52:isActionTriggerAble() then
		return
	end

	local var0_52 = arg0_52.actionTrigger.type
	local var1_52 = arg0_52.actionTrigger.action
	local var2_52

	if arg0_52.actionTrigger.time then
		var2_52 = arg0_52.actionTrigger.time
	elseif arg0_52.actionTrigger.action_list and arg0_52.actionListIndex > 0 then
		var2_52 = arg0_52.actionTrigger.action_list[arg0_52.actionListIndex].time
	end

	local var3_52

	if arg0_52.actionTrigger.num then
		var3_52 = arg0_52.actionTrigger.num
	elseif arg0_52.actionTrigger.action_list and arg0_52.actionTrigger.action_list[arg0_52.actionListIndex].num and arg0_52.actionListIndex > 0 then
		var3_52 = arg0_52.actionTrigger.action_list[arg0_52.actionListIndex].num
	end

	if var0_52 == Live2DPainting.DRAG_TIME_ACTION then
		if arg0_52._active then
			if var3_52 and math.abs(arg0_52.parameterValue - var3_52) < math.abs(var3_52) * 0.25 then
				arg0_52.triggerActionTime = arg0_52.triggerActionTime + Time.deltaTime

				if var2_52 < arg0_52.triggerActionTime and not arg0_52.l2dIsPlaying then
					arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY, nil, function(arg0_53)
						if arg0_53 then
							arg0_52:onEventNotice(Live2DPainting.ON_ACTION_DRAG_TRIGGER)
						end
					end)
				end
			else
				print("配置id = " .. arg0_52.id .. " 缺少参数 num")
			end
		end
	elseif var0_52 == Live2DPainting.DRAG_CLICK_ACTION then
		if arg0_52:checkClickAction() then
			arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY, nil, function(arg0_54)
				arg0_52:onEventNotice(Live2DPainting.ON_ACTION_DRAG_CLICK)
			end)
		end
	elseif var0_52 == Live2DPainting.DRAG_CLICK_RANGE then
		if arg0_52:checkClickAction() then
			local var4_52 = arg0_52.actionTrigger.parameter and arg0_52.actionTrigger.parameter or arg0_52.parameterName
			local var5_52 = var3_52

			arg0_52:onEventCallback(Live2DPainting.EVENT_GET_PARAMETER, {
				name = var4_52
			}, function(arg0_55)
				print("获取到数值 " .. var4_52 .. " = " .. arg0_55, "匹配范围 = " .. var5_52[1] .. " - " .. var5_52[2])

				if arg0_55 >= var5_52[1] and arg0_55 < var5_52[2] then
					print("数值范围内，开始触发动作  = " .. tostring(arg0_52.id))
					arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY, nil, function(arg0_56)
						arg0_52:onEventNotice(Live2DPainting.ON_ACTION_DRAG_CLICK)
					end)
				end
			end)
		end
	elseif var0_52 == Live2DPainting.DRAG_DOWN_ACTION then
		if arg0_52._active then
			arg0_52:setAbleWithFlag(true)

			if var2_52 <= Time.time - arg0_52.mouseInputDownTime and not arg0_52.l2dIsPlaying then
				print("触发按压动作")
				arg0_52:setAbleWithFlag(false)
				arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY, nil, function(arg0_57)
					if arg0_57 then
						arg0_52:onEventNotice(Live2DPainting.ON_ACTION_DOWN)
					end
				end)

				if arg0_52.actionListIndex ~= 1 then
					arg0_52:setTriggerActionFlag(false)
				end

				arg0_52:setAbleWithFlag(true)

				arg0_52.mouseInputDownTime = Time.time
			end
		elseif arg0_52.actionTrigger.last and arg0_52.actionListIndex ~= 1 then
			arg0_52.actionListIndex = #arg0_52.actionTrigger.action_list

			arg0_52:setAbleWithFlag(false)
			arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY, nil, function(arg0_58)
				return
			end)
			arg0_52:resetNextTriggerTime()
			arg0_52:setTriggerActionFlag(false)
		else
			arg0_52:setAbleWithFlag(false)
		end
	elseif var0_52 == Live2DPainting.DRAG_RELATION_XY then
		if arg0_52._active then
			local var6_52 = arg0_52:fixParameterTargetValue(arg0_52.offsetDragX, arg0_52.range, arg0_52.rangeAbs, arg0_52.dragDirect)
			local var7_52 = arg0_52:fixParameterTargetValue(arg0_52.offsetDragY, arg0_52.range, arg0_52.rangeAbs, arg0_52.dragDirect)
			local var8_52 = var3_52[1]
			local var9_52 = var3_52[2]

			if math.abs(var6_52 - var8_52) <= math.abs(var8_52) * 0.25 and math.abs(var7_52 - var9_52) <= math.abs(var9_52) * 0.25 then
				arg0_52.triggerActionTime = arg0_52.triggerActionTime + Time.deltaTime

				if var2_52 < arg0_52.triggerActionTime and not arg0_52.l2dIsPlaying then
					arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY, nil, function(arg0_59)
						if arg0_59 then
							arg0_52:onEventNotice(Live2DPainting.ON_ACTION_XY_TRIGGER)
						end
					end)
				end
			else
				arg0_52.triggerActionTime = arg0_52.triggerActionTime + 0
			end
		end
	elseif var0_52 == Live2DPainting.DRAG_RELATION_IDLE then
		if arg0_52.actionTrigger.const_fit then
			for iter0_52 = 1, #arg0_52.actionTrigger.const_fit do
				local var10_52 = arg0_52.actionTrigger.const_fit[iter0_52]

				if arg0_52.l2dIdleIndex == var10_52.idle and not arg0_52.l2dIsPlaying then
					arg0_52:setTargetValue(var10_52.target)
				end
			end
		end
	elseif var0_52 == Live2DPainting.DRAG_CLICK_MANY then
		if arg0_52:checkClickAction() then
			arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY)
		end
	elseif var0_52 == Live2DPainting.DRAG_LISTENER_EVENT then
		if arg0_52._listenerTrigger then
			arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY)
		end
	elseif var0_52 == Live2DPainting.DRAG_DOWN_TOUCH then
		arg0_52:setAbleWithFlag(arg0_52._active)

		if arg0_52._active then
			local var11_52 = Time.deltaTime / arg0_52.actionTrigger.delta
			local var12_52 = arg0_52.parameterTargetValue + var11_52
			local var13_52 = arg0_52:fixParameterTargetValue(var12_52, arg0_52.range, arg0_52.rangeAbs, arg0_52.dragDirect)

			arg0_52:setTargetValue(var13_52)
		end
	elseif var0_52 == Live2DPainting.DRAG_CLICK_PARAMETER then
		if arg0_52:checkClickAction() then
			local var14_52 = var3_52
			local var15_52 = arg0_52.actionTrigger.parameter

			arg0_52:onEventCallback(Live2DPainting.EVENT_GET_PARAMETER, {
				name = var15_52
			}, function(arg0_60)
				if math.abs(var14_52 - arg0_60) <= 0.05 then
					print("数值允许播放，开始执行动作 " .. arg0_52.actionTrigger.action)
					arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY, nil, function(arg0_61)
						arg0_52:onEventNotice(Live2DPainting.ON_ACTION_DRAG_CLICK)
					end)
				end
			end)
		end
	elseif var0_52 == Live2DPainting.DRAG_ANIMATION_PLAY then
		local var16_52 = arg0_52.actionTrigger.trigger_name

		if arg0_52.actionTrigger.trigger_name == "idle" and arg0_52.actionTrigger.trigger_index and arg0_52.actionTrigger.trigger_index > 0 then
			var16_52 = var16_52 .. arg0_52.actionTrigger.trigger_index
		end

		if arg0_52.stateInfo:IsName(var16_52) and arg0_52.l2dIdleIndex == arg0_52.actionTrigger.trigger_index then
			local var17_52 = false
			local var18_52 = arg0_52.actionTrigger.parameter_range

			if var18_52 then
				local var19_52 = var18_52[1]
				local var20_52 = var18_52[2]

				arg0_52:onEventCallback(Live2DPainting.EVENT_GET_PARAMETER, {
					name = var19_52
				}, function(arg0_62)
					if arg0_62 and arg0_62 >= var20_52[1] and arg0_62 < var20_52[2] then
						var17_52 = true
					end
				end)
			else
				var17_52 = true
			end

			if var17_52 and arg0_52.normalTime >= arg0_52.actionTrigger.trigger_rate and not arg0_52.animationPlayApply then
				arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY, nil, function()
					return
				end)
				arg0_52:setTriggerActionFlag(false)

				arg0_52.animationPlayApply = true
			end
		elseif arg0_52.animationPlayApply then
			arg0_52.animationPlayApply = false
		end
	elseif var0_52 == Live2DPainting.DRAG_EXTEND_ACTION_RULE then
		if not arg0_52.extendActionFlag then
			arg0_52.extendActionFlag = true
		end
	elseif var0_52 == Live2DPainting.DRAG_WITH_PARAMETER_MOVE then
		if not arg0_52.l2dIsPlaying then
			local var21_52
			local var22_52

			if var3_52 then
				var21_52 = var3_52 and math.abs(arg0_52.parameterValue - var3_52) or 0
				var22_52 = math.abs(var3_52) * 0.1
			end

			if var3_52 and var21_52 <= var22_52 and not arg0_52.parameterMoveTrigger then
				arg0_52.parameterMoveTrigger = true

				arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY, nil, function(arg0_64)
					return
				end)
			else
				if not arg0_52.moveCheckStep then
					arg0_52.moveCheckStep = 10
				end

				if arg0_52.parameterMoveTrigger then
					arg0_52.parameterMoveTrigger = false

					arg0_52:setParameterValue(arg0_52.startValue)
					arg0_52:setTargetValue(arg0_52.startValue)
				end

				arg0_52.moveCheckStep = arg0_52.moveCheckStep - 1

				if arg0_52.moveCheckStep <= 0 then
					arg0_52.moveCheckStep = 10

					local var23_52 = arg0_52.actionTrigger.parameter

					arg0_52.lastParameterMove = arg0_52.parameterMove

					arg0_52:onEventCallback(Live2DPainting.EVENT_GET_PARAMETER, {
						name = var23_52
					}, function(arg0_65)
						arg0_52.parameterMove = arg0_65
					end)

					if arg0_52.lastParameterMove and arg0_52.parameterMove then
						local var24_52 = math.abs(arg0_52.parameterMove - arg0_52.lastParameterMove)

						if var24_52 ~= 0 then
							local var25_52 = arg0_52.actionTrigger.rate and arg0_52.actionTrigger.rate or 0
							local var26_52 = arg0_52.parameterTargetValue + var24_52 * var25_52

							arg0_52:setTargetValue(arg0_52:fixParameterTargetValue(var26_52, arg0_52.range, arg0_52.rangeAbs, arg0_52.dragDirect))
							print("检测数值发生改变 = " .. arg0_52.parameterTargetValue)
						end
					end
				end
			end
		end
	elseif var0_52 == Live2DPainting.DRAG_MOVE_DOWN_UP then
		local var27_52 = arg0_52.actionTrigger.range

		if arg0_52._active and arg0_52.actionTrigger.active == 1 then
			if not arg0_52.dragMoveUp and arg0_52.parameterValue > var27_52[1] and arg0_52.parameterValue <= var27_52[2] then
				arg0_52.dragMoveUp = true

				arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY, nil, function(arg0_66)
					return
				end)
			end
		elseif arg0_52.firstStop and arg0_52.actionTrigger.active == 0 then
			arg0_52:onEventCallback(Live2DPainting.EVENT_GET_PARAMETER, {
				name = arg0_52.actionTrigger.parameter
			}, function(arg0_67)
				if arg0_67 > var27_52[1] and arg0_67 <= var27_52[2] then
					arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY, nil, function(arg0_68)
						return
					end)
				end
			end)
		elseif arg0_52._active == false and arg0_52.dragMoveUp then
			arg0_52.dragMoveUp = false
		end
	elseif var0_52 == Live2DPainting.DRAG_GAME_XIAQI then
		if arg0_52:checkClickAction() then
			arg0_52:onEventCallback(Live2DPainting.EVENT_GAME_XIAQI, {
				parameter_value = arg0_52.parameterValue
			}, function(arg0_69)
				if arg0_69 and arg0_69.target then
					print(arg0_52.parameterName .. " 设置数值 = " .. arg0_69.target)
					arg0_52:setTargetValue(arg0_69.target)
				end
			end)
		end
	elseif var0_52 == Live2DPainting.DRAG_GAME_XIAQI_RESULT and arg0_52.commonData and arg0_52.commonData[Live2DPainting.COMMON_XIAQI_RESULT] ~= nil and (arg0_52.actionTrigger.win == 1 and true or false) == arg0_52.commonData[Live2DPainting.COMMON_XIAQI_RESULT] then
		arg0_52:onEventCallback(Live2DPainting.EVENT_ACTION_APPLY, nil, function(arg0_70)
			if arg0_70 then
				arg0_52:setTriggerActionFlag(false)
				arg0_52:setCommonData(Live2DPainting.COMMON_XIAQI_RESULT, nil)
			end
		end)
	end
end

function var0_0.IsTouchAble(arg0_71)
	return true
end

function var0_0.setCommonData(arg0_72, arg1_72, arg2_72)
	arg0_72.commonData[arg1_72] = arg2_72
end

function var0_0.getExtendAction(arg0_73)
	return arg0_73.extendActionFlag
end

function var0_0.checkActionInExtendFlag(arg0_74, arg1_74)
	local var0_74 = false
	local var1_74 = false

	if not arg0_74.extendActionFlag then
		return var0_74, var1_74
	end

	local var2_74 = arg0_74.actionTrigger.parameter
	local var3_74 = arg0_74.actionTrigger.num
	local var4_74 = false

	arg0_74:onEventCallback(Live2DPainting.EVENT_GET_DRAG_PARAMETER, {
		name = var2_74
	}, function(arg0_75)
		if arg0_75 > var3_74[1] and arg0_75 <= var3_74[2] then
			var4_74 = true
		end
	end)

	if not var4_74 then
		return var0_74, var0_74
	end

	local var5_74 = arg0_74.actionTriggerActive.ignore
	local var6_74 = arg0_74.actionTriggerActive.enable

	if var5_74 and table.contains(var5_74, arg1_74) then
		var0_74 = true
	end

	if var6_74 and table.contains(var6_74, arg1_74) then
		var1_74 = true
	end

	return var0_74, var1_74
end

function var0_0.setAbleWithFlag(arg0_76, arg1_76)
	if arg0_76.ableFlag ~= arg1_76 then
		arg0_76.ableFlag = arg1_76

		arg0_76:onEventCallback(Live2DPainting.EVENT_ACTION_ABLE, {
			ableFlag = arg1_76
		})
	end
end

function var0_0.triggerAction(arg0_77)
	arg0_77.nextTriggerTime = arg0_77.limitTime

	arg0_77:setTriggerActionFlag(true)
end

function var0_0.isActionTriggerAble(arg0_78)
	if arg0_78.actionTrigger.type == nil then
		return false
	end

	if not arg0_78.actionTrigger or arg0_78.actionTrigger == "" then
		return false
	end

	if arg0_78.nextTriggerTime - Time.deltaTime >= 0 then
		arg0_78.nextTriggerTime = arg0_78.nextTriggerTime - Time.deltaTime

		return false
	end

	if arg0_78.isTriggerAtion then
		return false
	end

	return true
end

function var0_0.updateStateData(arg0_79, arg1_79)
	if arg0_79.l2dIdleIndex ~= arg1_79.idleIndex then
		if type(arg0_79.revertIdleIndex) == "boolean" and arg0_79.revertIdleIndex == true then
			arg0_79:setTargetValue(arg0_79.startValue)

			arg0_79.offsetDragX, arg0_79.offsetDragY = arg0_79.startValue, arg0_79.startValue
			arg0_79.offsetDragTargetX, arg0_79.offsetDragTargetY = arg0_79.startValue, arg0_79.startValue
		elseif type(arg0_79.revertIdleIndex) == "table" and table.contains(arg0_79.revertIdleIndex, arg1_79.idleIndex) then
			arg0_79:setTargetValue(arg0_79.startValue)

			arg0_79.offsetDragTargetX, arg0_79.offsetDragTargetY = arg0_79.startValue, arg0_79.startValue
			arg0_79.offsetDragX, arg0_79.offsetDragY = arg0_79.startValue, arg0_79.startValue
		end
	end

	arg0_79.lastActionIndex = arg0_79.actionListIndex

	if arg1_79.isPlaying and arg0_79.actionTrigger.reset_index_action and arg1_79.actionName and table.contains(arg0_79.actionTrigger.reset_index_action, arg1_79.actionName) then
		arg0_79.actionListIndex = 1
	end

	if arg0_79.revertActionIndex and arg0_79.lastActionIndex ~= arg0_79.actionListIndex then
		arg0_79:setTargetValue(arg0_79.startValue)
	end

	arg0_79.l2dIdleIndex = arg1_79.idleIndex
	arg0_79.l2dIsPlaying = arg1_79.isPlaying
	arg0_79.l2dIgnoreReact = arg1_79.ignoreReact
	arg0_79.l2dPlayActionName = arg1_79.actionName

	if not arg0_79.l2dIsPlaying and arg0_79.isTriggerAtion then
		arg0_79:setTriggerActionFlag(false)
	end

	if arg0_79.l2dIdleIndex and arg0_79.idleOn and #arg0_79.idleOn > 0 then
		arg0_79.reactConditionFlag = not table.contains(arg0_79.idleOn, arg0_79.l2dIdleIndex)
	end

	if arg0_79.l2dIdleIndex and arg0_79.idleOff and #arg0_79.idleOff > 0 then
		arg0_79.reactConditionFlag = table.contains(arg0_79.idleOff, arg0_79.l2dIdleIndex)
	end
end

function var0_0.checkClickAction(arg0_80)
	if arg0_80.firstActive then
		if arg0_80.actionTrigger.down then
			if arg0_80.actionTrigger.focus == 1 and arg0_80.l2dIsPlaying then
				return true
			elseif not arg0_80.l2dIsPlaying then
				return true
			end
		else
			arg0_80:setAbleWithFlag(true)
		end
	elseif arg0_80.firstStop then
		local var0_80 = math.abs(arg0_80.mouseInputUp.x - arg0_80.mouseInputDown.x) < 30 and math.abs(arg0_80.mouseInputUp.y - arg0_80.mouseInputDown.y) < 30
		local var1_80 = arg0_80.mouseInputUpTime - arg0_80.mouseInputDownTime < 0.5

		if not arg0_80.actionTrigger.down and var0_80 and var1_80 then
			if arg0_80.actionTrigger.focus == 1 and arg0_80.l2dIsPlaying then
				if arg0_80.l2dPlayActionName == arg0_80.actionTrigger.action then
					arg0_80.clickTriggerTime = Time.realtimeSinceStartup + 0.1
				end
			elseif not arg0_80.l2dIsPlaying then
				arg0_80.clickTriggerTime = Time.realtimeSinceStartup + 0.1
			end
		else
			arg0_80:setAbleWithFlag(false)
		end
	elseif arg0_80.clickTriggerTime and arg0_80.clickTriggerTime > 0 and Time.realtimeSinceStartup >= arg0_80.clickTriggerTime then
		arg0_80:setAbleWithFlag(false)

		if Time.realtimeSinceStartup - arg0_80.clickTriggerTime <= 0.1 then
			print("点击成功" .. arg0_80.id)

			arg0_80.clickTriggerTime = nil

			return true
		end
	end

	return false
end

function var0_0.saveData(arg0_81)
	local var0_81 = arg0_81.id
	local var1_81 = arg0_81.live2dData.skinId
	local var2_81 = arg0_81.live2dData.ship.id

	if arg0_81.revert == -1 and arg0_81.saveParameterFlag then
		Live2dConst.SaveDragData(var0_81, var1_81, var2_81, arg0_81.parameterTargetValue)
	end

	if arg0_81.actionTrigger.type == Live2DPainting.DRAG_CLICK_MANY then
		Live2dConst.SetDragActionIndex(var0_81, var1_81, var2_81, arg0_81.actionListIndex)
	end

	if arg0_81._relationFlag then
		Live2dConst.SetRelationData(var0_81, var1_81, var2_81, arg0_81:getRelationSaveData())
	end
end

function var0_0.getActionTriggerType(arg0_82)
	if arg0_82.actionTrigger and arg0_82.actionTrigger.type then
		return arg0_82.actionTrigger.type
	end

	return nil
end

function var0_0.loadData(arg0_83)
	local var0_83 = arg0_83.id
	local var1_83 = arg0_83.live2dData:GetShipSkinConfig().id
	local var2_83 = arg0_83.live2dData.ship.id

	if arg0_83.revert == -1 and arg0_83.saveParameterFlag then
		local var3_83 = Live2dConst.GetDragData(arg0_83.id, arg0_83.live2dData:GetShipSkinConfig().id, arg0_83.live2dData.ship.id)

		if var3_83 then
			arg0_83:setParameterValue(var3_83)
			arg0_83:setTargetValue(var3_83)
		end

		if var3_83 == arg0_83.startValue and arg0_83._relationParameterList and #arg0_83._relationParameterList > 0 then
			arg0_83:clearRelationValue()
		end
	end

	if arg0_83.actionTrigger.type == Live2DPainting.DRAG_CLICK_MANY then
		arg0_83.actionListIndex = Live2dConst.GetDragActionIndex(arg0_83.id, arg0_83.live2dData:GetShipSkinConfig().id, arg0_83.live2dData.ship.id) or 1
	end

	if arg0_83._relationFlag then
		local var4_83 = Live2dConst.GetRelationData(var0_83, var1_83, var2_83)

		arg0_83.offsetDragX = var4_83.drag_x and var4_83.drag_x or arg0_83.startValue
		arg0_83.offsetDragY = var4_83.drag_y and var4_83.drag_y or arg0_83.startValue
	end
end

function var0_0.getRelationSaveData(arg0_84)
	return {
		[Live2dConst.RELATION_DRAG_X] = arg0_84.offsetDragX,
		[Live2dConst.RELATION_DRAG_Y] = arg0_84.offsetDragY
	}
end

function var0_0.clearRelationValue(arg0_85)
	if arg0_85._relationParameterList and #arg0_85._relationParameterList > 0 then
		for iter0_85 = 1, #arg0_85._relationParameterList do
			local var0_85 = arg0_85._relationParameterList[iter0_85]

			if var0_85.data.type == Live2DPainting.relation_type_drag_x or var0_85.data.type == Live2DPainting.relation_type_drag_y then
				var0_85.value = var0_85.start or arg0_85.startValue or 0
				var0_85.enable = true
			end

			arg0_85.offsetDragX, arg0_85.offsetDragY = arg0_85.startValue, arg0_85.startValue
		end
	end
end

function var0_0.loadL2dFinal(arg0_86)
	arg0_86.loadL2dStep = true
end

function var0_0.clearData(arg0_87)
	if arg0_87.revert == -1 then
		arg0_87.actionListIndex = 1
		arg0_87.delayTargetTime = nil

		arg0_87:setParameterValue(arg0_87.startValue)
		arg0_87:setTargetValue(arg0_87.startValue)
		arg0_87:clearRelationValue()
	end
end

function var0_0.setTriggerActionFlag(arg0_88, arg1_88)
	arg0_88.isTriggerAtion = arg1_88
end

function var0_0.dispose(arg0_89)
	arg0_89._active = false
	arg0_89._parameterCom = nil
	arg0_89.parameterValue = arg0_89.startValue
	arg0_89.parameterTargetValue = 0
	arg0_89.parameterSmooth = 0
	arg0_89.mouseInputDown = Vector2(0, 0)
	arg0_89.data = nil
	arg0_89.live2dData = nil
	arg0_89.commonData = nil
end

return var0_0
