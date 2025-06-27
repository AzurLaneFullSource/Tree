local var0_0 = class("Live2D")

var0_0.STATE_LOADING = 0
var0_0.STATE_INITED = 1
var0_0.STATE_DISPOSE = 2

local var1_0
local var2_0 = 5
local var3_0 = 3
local var4_0 = 0.3

var0_0.DRAG_TIME_ACTION = 1
var0_0.DRAG_CLICK_ACTION = 2
var0_0.DRAG_DOWN_ACTION = 3
var0_0.DRAG_RELATION_XY = 4
var0_0.DRAG_RELATION_IDLE = 5
var0_0.DRAG_CLICK_MANY = 6
var0_0.DRAG_LISTENER_EVENT = 7
var0_0.DRAG_DOWN_TOUCH = 8
var0_0.DRAG_CLICK_PARAMETER = 9
var0_0.DRAG_ANIMATION_PLAY = 10
var0_0.DRAG_CLICK_RANGE = 11
var0_0.DRAG_EXTEND_ACTION_RULE = 12
var0_0.ON_ACTION_PLAY = 1
var0_0.ON_ACTION_DRAG_CLICK = 2
var0_0.ON_ACTION_CHANGE_IDLE = 3
var0_0.ON_ACTION_PARAMETER = 4
var0_0.ON_ACTION_DOWN = 5
var0_0.ON_ACTION_XY_TRIGGER = 6
var0_0.ON_ACTION_DRAG_TRIGGER = 7
var0_0.NOTICE_ACTION_LIST = {
	var0_0.ON_ACTION_PLAY,
	var0_0.ON_ACTION_DRAG_CLICK,
	var0_0.ON_ACTION_CHANGE_IDLE,
	var0_0.ON_ACTION_PARAMETER,
	var0_0.ON_ACTION_DOWN,
	var0_0.ON_ACTION_XY_TRIGGER,
	var0_0.ON_ACTION_DRAG_TRIGGER
}

local var5_0 = {
	[var0_0.ON_ACTION_PLAY] = "动作播放 1",
	[var0_0.ON_ACTION_DRAG_CLICK] = "动作点击 2",
	[var0_0.ON_ACTION_CHANGE_IDLE] = "改变idle 3",
	[var0_0.ON_ACTION_PARAMETER] = "参数变化 4",
	[var0_0.ON_ACTION_DOWN] = "按下触发 5",
	[var0_0.ON_ACTION_XY_TRIGGER] = "xy联动触发 6",
	[var0_0.ON_ACTION_DRAG_TRIGGER] = "拖拽到达目标值触发 7"
}

var0_0.EVENT_ACTION_APPLY = "event action apply"
var0_0.EVENT_ACTION_ABLE = "event action able"
var0_0.EVENT_ADD_PARAMETER_COM = "event add parameter com "
var0_0.EVENT_REMOVE_PARAMETER_COM = "event remove parameter com "
var0_0.EVENT_CHANGE_IDLE_INDEX = "event change idle index"
var0_0.EVENT_GET_PARAMETER = "event get parameter num"
var0_0.EVENT_GET_WORLD_POSITION = "event get world position"
var0_0.EVENT_GET_DRAG_PARAMETER = "event get drag parameter"
var0_0.relation_type_drag_x = 101
var0_0.relation_type_drag_y = 102
var0_0.relation_type_action_index = 103
var0_0.relation_type_idle = 104

local var6_0 = {
	CubismParameterBlendMode.Override,
	CubismParameterBlendMode.Additive,
	CubismParameterBlendMode.Multiply
}

function var0_0.GenerateData(arg0_1)
	local var0_1 = {
		SetData = function(arg0_2, arg1_2)
			arg0_2.ship = arg1_2.ship
			arg0_2.parent = arg1_2.parent

			local var0_2 = arg1_2.offset
			local var1_2 = arg0_2:GetShipSkinConfig().live2d_offset
			local var2_2

			if var0_2 and #var0_2 >= 4 then
				var2_2 = Vector3(var0_2[4], var0_2[4], var0_2[4])
			elseif var1_2 and #var1_2 >= 4 then
				var2_2 = Vector3(var1_2[4], var1_2[4], var1_2[4])
			else
				var2_2 = Vector3(52, 52, 52)
			end

			local var3_2

			if var0_2 and #var0_2 >= 3 then
				if var0_2[1] and var0_2[2] and var0_2[3] then
					var3_2 = {
						var0_2[1],
						var0_2[2],
						var0_2[3]
					}
				else
					var3_2 = arg0_2:GetShipSkinConfig().live2d_offset
				end
			else
				var3_2 = arg0_2:GetShipSkinConfig().live2d_offset
			end

			local var4_2

			if arg1_2.position then
				var4_2 = arg1_2.position
			else
				var4_2 = Vector3(0, 0, 0)
			end

			arg0_2.scale = var2_2
			arg0_2.gyro = arg0_2:GetShipSkinConfig().gyro or 0
			arg0_2.shipL2dId = arg0_2:GetShipSkinConfig().ship_l2d_id
			arg0_2.skinId = arg0_2:GetShipSkinConfig().id
			arg0_2.spineUseLive2d = false

			if arg0_2.skinId then
				arg0_2.spineUseLive2d = pg.ship_skin_template[arg0_2.skinId].spine_use_live2d == 1
			end

			arg0_2.position = var4_2 + BuildVector3(var3_2)
			arg0_2.l2dDragRate = arg0_2:GetShipSkinConfig().l2d_drag_rate
			arg0_2.loadPrefs = arg1_2.loadPrefs
		end,
		GetShipName = function(arg0_3)
			return arg0_3.ship:getPainting()
		end,
		GetShipSkinConfig = function(arg0_4)
			return arg0_4.ship:GetSkinConfig()
		end,
		isEmpty = function(arg0_5)
			return arg0_5.ship == nil
		end,
		Clear = function(arg0_6)
			arg0_6.ship = nil
			arg0_6.parent = nil
			arg0_6.scale = nil
			arg0_6.position = nil
		end
	}

	var0_1:SetData(arg0_1)

	return var0_1
end

local function var7_0(arg0_7)
	local var0_7 = arg0_7.live2dData:GetShipSkinConfig()
	local var1_7 = var0_7.lip_sync_gain
	local var2_7 = var0_7.lip_smoothing

	if var1_7 and var1_7 ~= 0 then
		arg0_7._go:GetComponent("CubismCriSrcMouthInput").Gain = var1_7
	end

	if var2_7 and var2_7 ~= 0 then
		arg0_7._go:GetComponent("CubismCriSrcMouthInput").Smoothing = var2_7
	end
end

local function var8_0(arg0_8)
	local var0_8 = arg0_8.live2dData:GetShipSkinConfig().l2d_para_range

	if var0_8 ~= nil and type(var0_8) == "table" then
		for iter0_8, iter1_8 in pairs(var0_8) do
			arg0_8.liveCom:SetParaRange(iter0_8, iter1_8)
		end
	end
end

local function var9_0(arg0_9)
	return not arg0_9._readlyToStop
end

local function var10_0(arg0_10, arg1_10)
	if not arg1_10 or arg1_10 == "" then
		return false
	end

	if arg1_10 == "idle" then
		return true
	end

	if arg0_10.drags then
		for iter0_10, iter1_10 in ipairs(arg0_10.drags) do
			if iter1_10:getExtendAction() then
				local var0_10, var1_10 = iter1_10:checkActionInExtendFlag(arg1_10)

				if var0_10 then
					return false
				elseif var1_10 then
					return true
				end
			end
		end
	end

	if arg0_10.enablePlayActions and #arg0_10.enablePlayActions > 0 and not table.contains(arg0_10.enablePlayActions, arg1_10) then
		print(tostring(arg1_10) .. "不在白名单中,不播放该动作")

		return false
	end

	if arg0_10.ignorePlayActions and #arg0_10.ignorePlayActions > 0 and table.contains(arg0_10.ignorePlayActions, arg1_10) then
		print(tostring(arg1_10) .. "在黑名单中，不播放该动作")

		return false
	end

	if not var9_0(arg0_10) then
		return false
	end

	return true
end

local function var11_0(arg0_11, arg1_11, arg2_11)
	if not var10_0(arg0_11, arg1_11) then
		return false
	end

	if arg0_11.updateAtom then
		arg0_11:AtomSouceFresh()
	end

	if arg0_11.animationClipNames then
		local var0_11 = arg0_11:checkActionExist(arg1_11)

		if (not var0_11 or var0_11 == false) and string.find(arg1_11, "main_") then
			arg1_11 = "main_3"
		end
	end

	if not arg0_11.isPlaying or arg2_11 then
		local var1_11 = var1_0.action2Id[arg1_11]

		if var1_11 then
			arg0_11.playActionName = arg1_11

			arg0_11.liveCom:SetAction(var1_11)

			if arg1_11 == "idle" then
				arg0_11:live2dActionChange(false)
			else
				arg0_11:live2dActionChange(true)
			end

			return true
		else
			print(tostring(arg1_11) .. " action is not exist")
		end
	end

	return false
end

local function var12_0(arg0_12, arg1_12)
	arg0_12.liveCom:SetCenterPart("Drawables/TouchHead", Vector3.zero)

	arg0_12.liveCom.DampingTime = 0.3
end

local function var13_0(arg0_13, arg1_13, arg2_13)
	if table.contains(Live2D.NOTICE_ACTION_LIST, arg1_13) then
		arg0_13:onListenerHandle(arg1_13, arg2_13)
	end
end

local function var14_0(arg0_14, arg1_14, arg2_14)
	if arg1_14 == Live2D.EVENT_ACTION_APPLY then
		local var0_14 = arg2_14.id
		local var1_14 = arg2_14.action
		local var2_14 = arg2_14.callback
		local var3_14 = arg2_14.finishCall
		local var4_14 = arg2_14.activeData
		local var5_14 = arg2_14.focus
		local var6_14 = arg2_14.react
		local var7_14 = var4_14.idle_focus
		local var8_14 = var9_0(arg0_14)
		local var9_14
		local var10_14 = false

		if not var1_14 or var1_14 == "" then
			var10_14 = true
		end

		if var8_14 then
			if var6_14 ~= nil then
				arg0_14:setReactPos(tobool(var6_14))
			end

			if var7_14 and var7_14 == 1 and (not var1_14 or var1_14 == "") then
				var1_14 = "idle"

				arg0_14:changeIdleIndex(var4_14.idle and var4_14.idle or 0)
			end

			var9_14 = var11_0(arg0_14, var1_14, var5_14 or false)

			if var9_14 then
				print("id = " .. var0_14 .. " 触发成功")
				arg0_14:onListenerHandle(Live2D.ON_ACTION_PLAY, {
					action = var1_14
				})
				arg0_14:applyActiveData(arg2_14)
			elseif var10_14 then
				print("id = " .. var0_14 .. " 空触发成功")
				arg0_14:applyActiveData(arg2_14)
			end

			if var7_14 and var7_14 == 1 then
				arg0_14:live2dActionChange(false)
			elseif var1_14 == "idle" then
				arg0_14:live2dActionChange(false)
			end
		end

		if var2_14 then
			var2_14(var9_14)
		end
	elseif arg1_14 == Live2D.EVENT_ACTION_ABLE then
		if arg0_14.ableFlag ~= arg2_14.ableFlag then
			arg0_14.ableFlag = arg2_14.ableFlag

			if arg2_14.ableFlag then
				arg0_14.tempEnable = arg0_14.enablePlayActions

				arg0_14:setEnableActions({
					"none action apply"
				})
			else
				arg0_14:setEnableActions(arg0_14.tempEnable or {})
			end
		end

		if arg2_14.callback then
			arg2_14.callback()
		end
	elseif arg1_14 == Live2D.EVENT_ADD_PARAMETER_COM then
		arg0_14.liveCom:AddParameterValue(arg2_14.com, arg2_14.start, var6_0[arg2_14.mode])
	elseif arg1_14 == Live2D.EVENT_REMOVE_PARAMETER_COM then
		arg0_14.liveCom:removeParameterValue(arg2_14.com)
	elseif arg1_14 == Live2D.EVENT_CHANGE_IDLE_INDEX then
		arg0_14:applyActiveData(arg2_14)
	elseif arg1_14 == Live2D.EVENT_GET_PARAMETER then
		local var11_14 = 0
		local var12_14 = arg0_14.liveCom:GetCubismParameter(arg2_14.name)

		if var12_14 then
			var11_14 = var12_14.Value
		end

		if arg2_14.callback then
			arg2_14.callback(var11_14)
		end
	elseif arg1_14 == Live2D.EVENT_GET_WORLD_POSITION then
		local var13_14 = arg0_14._tf:TransformPoint(Vector3(arg2_14.pos[1], arg2_14.pos[2], arg2_14.pos[3]))

		if arg2_14.callback then
			arg2_14.callback(var13_14)
		end
	elseif arg1_14 == Live2D.EVENT_GET_DRAG_PARAMETER then
		local var14_14 = 0

		for iter0_14, iter1_14 in ipairs(arg0_14.drags) do
			if iter1_14.parameterName == arg2_14.name then
				var14_14 = iter1_14.parameterValue
			end
		end

		if arg2_14.callback then
			arg2_14.callback(var14_14)
		end
	end
end

local function var15_0(arg0_15, arg1_15)
	if not arg0_15._l2dCharEnable then
		return
	end

	if arg0_15._readlyToStop and not arg1_15 then
		return
	end

	arg0_15._listenerParametersValue = {}

	if arg0_15._listenerStepIndex and arg0_15._listenerStepIndex == 0 then
		arg0_15._listenerStepIndex = 3

		for iter0_15, iter1_15 in ipairs(arg0_15._listenerParameters) do
			arg0_15._listenerParametersValue[iter1_15.name] = iter1_15.Value
		end
	else
		arg0_15._listenerStepIndex = arg0_15._listenerStepIndex - 1
	end

	local var0_15 = false
	local var1_15 = arg0_15.liveCom.reactPos
	local var2_15 = arg0_15._animator:GetCurrentAnimatorStateInfo(0)
	local var3_15 = {
		reactPos = var1_15,
		normalTime = var2_15.normalizedTime,
		stateInfo = var2_15
	}

	for iter2_15 = 1, #arg0_15.drags do
		arg0_15.drags[iter2_15]:stepParameter(var3_15)

		local var4_15 = arg0_15.drags[iter2_15]:getParameToTargetFlag()
		local var5_15 = arg0_15.drags[iter2_15]:getActive()

		if (var4_15 or var5_15) and arg0_15.drags[iter2_15]:getIgnoreReact() then
			var0_15 = true
		elseif arg0_15.drags[iter2_15]:getReactCondition() then
			var0_15 = true
		end

		local var6_15 = arg0_15.drags[iter2_15]:getParameter()
		local var7_15 = arg0_15.drags[iter2_15]:getParameterUpdateFlag()

		if var6_15 and var7_15 then
			local var8_15 = arg0_15.drags[iter2_15]:getParameterCom()

			if var8_15 then
				arg0_15.liveCom:ChangeParameterData(var8_15, var6_15)
			end
		end

		local var9_15 = arg0_15.drags[iter2_15]:getRelationParameterList()

		for iter3_15, iter4_15 in ipairs(var9_15) do
			if iter4_15.enable then
				arg0_15.liveCom:ChangeParameterData(iter4_15.com, iter4_15.value)
			end
		end
	end

	if var0_15 == arg0_15.ignoreReact or not var0_15 and (arg0_15.mouseInputDown or arg0_15.isPlaying) then
		-- block empty
	else
		arg0_15:setReactPos(var0_15)
	end
end

local function var16_0(arg0_16)
	arg0_16.drags = {}
	arg0_16.dragParts = {}

	for iter0_16 = 1, #var1_0.assistantTouchParts do
		table.insert(arg0_16.dragParts, var1_0.assistantTouchParts[iter0_16])
	end

	arg0_16._l2dCharEnable = true
	arg0_16._shopPreView = arg0_16.live2dData.shopPreView
	arg0_16._listenerParameters = {}
	arg0_16._listenerStepIndex = 0

	local var0_16 = "live2D初始化id列表："

	for iter1_16, iter2_16 in ipairs(arg0_16.live2dData.shipL2dId) do
		local var1_16 = pg.ship_l2d[iter2_16]

		if var1_16 and arg0_16:getDragEnable(var1_16) then
			var0_16 = var0_16 .. var1_16.id .. ","

			local var2_16 = Live2dDrag.New(var1_16, arg0_16.live2dData)
			local var3_16 = arg0_16.liveCom:GetCubismParameter(var1_16.parameter)

			var2_16:setParameterCom(var3_16)
			var2_16:setEventCallback(function(arg0_17, arg1_17)
				var14_0(arg0_16, arg0_17, arg1_17)
				var13_0(arg0_16, arg0_17, arg1_17)
			end)
			arg0_16.liveCom:AddParameterValue(var2_16.parameterName, var2_16.startValue, var6_0[var2_16.mode])

			if var1_16.relation_parameter and var1_16.relation_parameter.list then
				local var4_16 = var1_16.relation_parameter.list

				for iter3_16, iter4_16 in ipairs(var4_16) do
					local var5_16 = arg0_16.liveCom:GetCubismParameter(iter4_16.name)

					if var5_16 then
						var2_16:addRelationComData(var5_16, iter4_16)

						local var6_16 = iter4_16.mode or var1_16.mode

						arg0_16.liveCom:AddParameterValue(iter4_16.name, iter4_16.start or var2_16.startValue or 0, var6_0[var6_16])
					end
				end
			end

			table.insert(arg0_16.drags, var2_16)

			if not table.contains(arg0_16._listenerParameters, var3_16) then
				table.insert(arg0_16._listenerParameters, var3_16)
			end

			if var2_16.drawAbleName and var2_16.drawAbleName ~= "" and not table.contains(arg0_16.dragParts, var2_16.drawAbleName) then
				table.insert(arg0_16.dragParts, var2_16.drawAbleName)
			end
		end
	end

	print(var0_16)
	arg0_16.liveCom:SetDragParts(arg0_16.dragParts)

	arg0_16.eventTrigger = GetOrAddComponent(arg0_16.liveCom.transform.parent, typeof(EventTriggerListener))

	arg0_16.eventTrigger:AddPointDownFunc(function(arg0_18, arg1_18)
		if arg0_16.useEventTriggerFlag then
			arg0_16:onPointDown(arg1_18)
		end
	end)
	arg0_16.eventTrigger:AddPointUpFunc(function(arg0_19, arg1_19)
		if arg0_16.useEventTriggerFlag then
			arg0_16:onPointUp(arg1_19)
		end
	end)
	arg0_16.eventTrigger:AddDragFunc(function(arg0_20, arg1_20)
		if arg0_16.useEventTriggerFlag then
			arg0_16:onPointDrag(arg1_20)
		end
	end)
	arg0_16.liveCom:SetMouseInputActions(System.Action(function()
		if not arg0_16.useEventTriggerFlag then
			arg0_16:onPointDown()
		end
	end), System.Action(function()
		if not arg0_16.useEventTriggerFlag then
			arg0_16:onPointUp()
		end
	end))

	arg0_16.paraRanges = arg0_16.liveCom.paraRanges
	arg0_16.destinations = ReflectionHelp.RefGetProperty(typeof(Live2dChar), "Destinations", arg0_16.liveCom):ToTable()
end

function var0_0.checkActionExist(arg0_23, arg1_23)
	return (table.indexof(arg0_23.animationClipNames, arg1_23))
end

function var0_0.onListenerHandle(arg0_24, arg1_24, arg2_24)
	if not arg0_24.drags or #arg0_24.drags == 0 then
		return
	end

	if arg1_24 ~= Live2D.ON_ACTION_PARAMETER then
		-- block empty
	end

	for iter0_24 = 1, #arg0_24.drags do
		arg0_24.drags[iter0_24]:onListenerEvent(arg1_24, arg2_24)
	end
end

function var0_0.onPointDown(arg0_25, arg1_25)
	if not arg0_25._l2dCharEnable then
		return
	end

	arg0_25.mouseInputDown = true

	if #arg0_25.drags > 0 and arg0_25.liveCom:GetDragPart() > 0 then
		local var0_25 = arg0_25.liveCom:GetDragPart()
		local var1_25 = arg0_25.dragParts[var0_25]

		if var0_25 > 0 and var1_25 then
			for iter0_25, iter1_25 in ipairs(arg0_25.drags) do
				if iter1_25.drawAbleName == var1_25 then
					iter1_25:startDrag(arg1_25)
				end
			end
		end
	end
end

function var0_0.onPointUp(arg0_26, arg1_26)
	if not arg0_26._l2dCharEnable then
		return
	end

	arg0_26.mouseInputDown = false

	if arg0_26.drags and #arg0_26.drags > 0 then
		local var0_26 = arg0_26.liveCom:GetDragPart()

		if var0_26 > 0 then
			local var1_26 = arg0_26.dragParts[var0_26]
		end

		for iter0_26 = 1, #arg0_26.drags do
			arg0_26.drags[iter0_26]:stopDrag(arg1_26)
		end
	end
end

function var0_0.onPointDrag(arg0_27, arg1_27)
	if not arg0_27._l2dCharEnable then
		return
	end

	if arg0_27.drags and #arg0_27.drags > 0 then
		for iter0_27 = 1, #arg0_27.drags do
			arg0_27.drags[iter0_27]:onDrag(arg1_27)
		end
	end
end

function var0_0.changeTriggerFlag(arg0_28, arg1_28)
	arg0_28.useEventTriggerFlag = arg1_28
end

local function var17_0(arg0_29, arg1_29)
	arg0_29._go = arg1_29
	arg0_29._tf = tf(arg1_29)

	UIUtil.SetLayerRecursively(arg0_29._go, LayerMask.NameToLayer("UI"))
	arg0_29._tf:SetParent(arg0_29.live2dData.parent, true)

	arg0_29._tf.localScale = arg0_29.live2dData.scale
	arg0_29._tf.localPosition = arg0_29.live2dData.position
	arg0_29.liveCom = arg1_29:GetComponent(typeof(Live2dChar))
	arg0_29._animator = arg1_29:GetComponent(typeof(Animator))
	arg0_29.cubismModelCom = arg1_29:GetComponent("Live2D.Cubism.Core.CubismModel")
	arg0_29.animationClipNames = {}

	if arg0_29._animator and arg0_29._animator.runtimeAnimatorController then
		local var0_29 = arg0_29._animator.runtimeAnimatorController.animationClips:ToTable()

		for iter0_29, iter1_29 in ipairs(var0_29) do
			table.insert(arg0_29.animationClipNames, iter1_29.name)
		end
	end

	local var1_29 = var1_0.action2Id.idle

	arg0_29.liveCom:SetReactMotions(var1_0.idleActions)

	function arg0_29.liveCom.FinishAction(arg0_30)
		arg0_29:live2dActionChange(false)

		if arg0_29.finishActionCB then
			arg0_29.finishActionCB()

			arg0_29.finishActionCB = nil
		end

		arg0_29:changeActionIdle()
	end

	function arg0_29.liveCom.EventAction(arg0_31)
		if arg0_29.animEventCB then
			arg0_29.animEventCB(arg0_31)

			arg0_29.animEventCB = nil
		end
	end

	arg0_29.liveCom:SetTouchParts(var1_0.assistantTouchParts)

	if arg0_29.live2dData and arg0_29.live2dData.ship and arg0_29.live2dData.ship.propose then
		arg0_29:changeParamaterValue("Paramring", 1)
	else
		arg0_29:changeParamaterValue("Paramring", 0)
	end

	if not arg0_29._physics then
		arg0_29._physics = GetComponent(arg0_29._tf, "CubismPhysicsController")
	end

	if arg0_29._physics then
		arg0_29._physics.enabled = false
		arg0_29._physics.enabled = true
	end

	if arg0_29.live2dData.l2dDragRate and #arg0_29.live2dData.l2dDragRate > 0 then
		arg0_29.liveCom.DragRateX = arg0_29.live2dData.l2dDragRate[1] * var2_0
		arg0_29.liveCom.DragRateY = arg0_29.live2dData.l2dDragRate[2] * var3_0
		arg0_29.liveCom.DampingTime = arg0_29.live2dData.l2dDragRate[3] * var4_0
	end

	var7_0(arg0_29)
	var8_0(arg0_29)
	var12_0(arg0_29)
	arg0_29:setEnableActions({})
	arg0_29:setIgnoreActions({})
	arg0_29:changeIdleIndex(0)

	if arg0_29.live2dData.shipL2dId and #arg0_29.live2dData.shipL2dId > 0 then
		var16_0(arg0_29)
		arg0_29:loadLive2dData()

		arg0_29.timer = Timer.New(function()
			var15_0(arg0_29)
		end, 0.0333333333333333, -1)

		arg0_29.timer:Start()
		var15_0(arg0_29)
	end

	arg0_29:addKeyBoard()

	arg0_29.state = var0_0.STATE_INITED

	if arg0_29.delayChangeParamater and #arg0_29.delayChangeParamater > 0 then
		for iter2_29 = 1, #arg0_29.delayChangeParamater do
			local var2_29 = arg0_29.delayChangeParamater[iter2_29]

			arg0_29:changeParamaterValue(var2_29[1], var2_29[2])
		end

		arg0_29.delayChangeParamater = nil
	end

	var11_0(arg0_29, "idle", true)
	arg0_29:offsetL2dPositonDelay(0.3, 5)
end

function var0_0.Ctor(arg0_33, arg1_33, arg2_33)
	arg0_33.state = var0_0.STATE_LOADING
	arg0_33.live2dData = arg1_33
	var1_0 = pg.AssistantInfo

	assert(not arg0_33.live2dData:isEmpty())

	local var0_33 = arg0_33.live2dData:GetShipName()

	local function var1_33(arg0_34)
		var17_0(arg0_33, arg0_34)

		if arg2_33 then
			arg2_33(arg0_33)
		end
	end

	arg0_33.live2dRequestId = pg.Live2DMgr.GetInstance():GetLive2DModelAsync(var0_33, var1_33)
	Input.gyro.enabled = arg0_33.live2dData.gyro == 1 and PlayerPrefs.GetInt(GYRO_ENABLE, 1) == 1
	arg0_33.useEventTriggerFlag = true
end

function var0_0.setStopCallback(arg0_35, arg1_35)
	arg0_35._stopCallback = arg1_35
end

function var0_0.SetVisible(arg0_36, arg1_36)
	if not arg0_36:IsLoaded() then
		return
	end

	Input.gyro.enabled = PlayerPrefs.GetInt(GYRO_ENABLE, 1) == 1

	arg0_36:setReactPos(true)
	arg0_36:Reset()

	if arg1_36 then
		arg0_36._readlyToStop = false

		if arg0_36._physics then
			arg0_36._physics.enabled = false
			arg0_36._physics.enabled = true
		end

		arg0_36:setReactPos(false)

		arg0_36._animator.speed = 1

		var15_0(arg0_36, true)

		if Live2dConst.GetLive2dDirty(arg0_36.live2dData.ship:getSkinId(), arg0_36.live2dData.ship.id, true) then
			arg0_36:resetL2dData()
		end
	else
		arg0_36:saveLive2dData()
		arg0_36:loadLive2dData()

		if arg0_36._stopCallback then
			arg0_36._stopCallback()
		end

		arg0_36._readlyToStop = true

		var11_0(arg0_36, "idle", true)
		arg0_36:offsetL2dPositonDelay(0.3, 5, function()
			if arg0_36._readlyToStop then
				arg0_36._animator.speed = 0
			end
		end)
	end
end

function var0_0.loadLive2dData(arg0_38)
	if not arg0_38.live2dData.loadPrefs then
		return
	end

	if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and not arg0_38.live2dData.spineUseLive2d then
		if arg0_38.drags then
			for iter0_38 = 1, #arg0_38.drags do
				arg0_38.drags[iter0_38]:clearData()
				arg0_38.drags[iter0_38]:loadL2dFinal()
			end
		end

		arg0_38:changeIdleIndex(0)

		arg0_38.saveActionAbleId = nil
	else
		local var0_38, var1_38 = Live2dConst.GetL2dSaveData(arg0_38.live2dData:GetShipSkinConfig().id, arg0_38.live2dData.ship.id)
		local var2_38 = Live2dConst.GetDragActionIndex(var1_38, arg0_38.live2dData:GetShipSkinConfig().id, arg0_38.live2dData.ship.id) or 1

		if var0_38 then
			arg0_38:changeIdleIndex(var0_38)
		end

		arg0_38.saveActionAbleId = var1_38

		if var1_38 and var1_38 > 0 then
			if pg.ship_l2d[var1_38] then
				local var3_38 = pg.ship_l2d[var1_38].action_trigger_active

				if var0_38 and var3_38.idle_enable and #var3_38.idle_enable > 0 then
					for iter1_38, iter2_38 in ipairs(var3_38.idle_enable) do
						if iter2_38[1] == var0_38 then
							arg0_38:setEnableActions(iter2_38[2])
						end
					end
				elseif var2_38 and var2_38 >= 1 and var3_38.active_list then
					arg0_38:setEnableActions(var3_38.active_list[var2_38].enable and var3_38.active_list[var2_38].enable or {})
				else
					arg0_38:setEnableActions(var3_38.enable and var3_38.enable or {})
				end

				if var0_38 and var3_38.idle_ignore and #var3_38.idle_ignore > 0 then
					for iter3_38, iter4_38 in ipairs(var3_38.idle_ignore) do
						if iter4_38[1] == var0_38 then
							arg0_38:setIgnoreActions(iter4_38[2])
						end
					end
				elseif var2_38 and var2_38 >= 1 and var3_38.active_list then
					arg0_38:setIgnoreActions(var3_38.active_list[var2_38].ignore and var3_38.active_list[var2_38].ignore or {})
				else
					arg0_38:setIgnoreActions(var3_38.ignore and var3_38.ignore or {})
				end
			end
		else
			arg0_38:setEnableActions({})
			arg0_38:setIgnoreActions({})
		end

		if arg0_38.drags then
			for iter5_38 = 1, #arg0_38.drags do
				arg0_38.drags[iter5_38]:loadData()
				arg0_38.drags[iter5_38]:loadL2dFinal()
			end
		end
	end
end

function var0_0.saveLive2dData(arg0_39)
	if not arg0_39.live2dData.loadPrefs then
		return
	end

	if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and not arg0_39.live2dData.spineUseLive2d then
		return
	end

	if arg0_39.idleIndex then
		Live2dConst.SaveL2dIdle(arg0_39.live2dData:GetShipSkinConfig().id, arg0_39.live2dData.ship.id, arg0_39.idleIndex)
	end

	if arg0_39.saveActionAbleId then
		if arg0_39.idleIndex == 0 then
			Live2dConst.SaveL2dAction(arg0_39.live2dData:GetShipSkinConfig().id, arg0_39.live2dData.ship.id, 0)
		else
			Live2dConst.SaveL2dAction(arg0_39.live2dData:GetShipSkinConfig().id, arg0_39.live2dData.ship.id, arg0_39.saveActionAbleId)
		end
	end

	if arg0_39.drags then
		for iter0_39 = 1, #arg0_39.drags do
			arg0_39.drags[iter0_39]:saveData()
		end
	end
end

function var0_0.changeActionIdle(arg0_40)
	local var0_40 = var1_0.idleActions[math.ceil(math.random(#var1_0.idleActions))]

	var11_0(arg0_40, "idle", true)
end

function var0_0.enablePlayAction(arg0_41, arg1_41)
	return var10_0(arg0_41, arg1_41)
end

function var0_0.IgonreReactPos(arg0_42, arg1_42)
	arg0_42:setReactPos(arg1_42)
end

function var0_0.setReactPos(arg0_43, arg1_43)
	if arg0_43.liveCom then
		arg0_43.ignoreReact = arg1_43

		arg0_43.liveCom:IgonreReactPos(arg1_43)

		if arg1_43 then
			arg0_43.liveCom.inDrag = false
		end

		arg0_43.liveCom.reactPos = Vector3(0, 0, 0)

		arg0_43:updateDragsSateData()
	end
end

function var0_0.l2dCharEnable(arg0_44, arg1_44)
	arg0_44._l2dCharEnable = arg1_44
end

function var0_0.inShopPreView(arg0_45, arg1_45)
	arg0_45._shopPreView = arg1_45
end

function var0_0.getDragEnable(arg0_46, arg1_46)
	if arg0_46._shopPreView and arg1_46.shop_action == 0 then
		return false
	end

	return true
end

function var0_0.updateShip(arg0_47, arg1_47)
	if arg1_47 and arg0_47.live2dData and arg0_47.live2dData.ship then
		arg0_47.live2dData.ship = arg1_47

		if arg0_47.live2dData and arg0_47.live2dData.ship and arg0_47.live2dData.ship.propose then
			arg0_47:changeParamaterValue("Paramring", 1)
		else
			arg0_47:changeParamaterValue("Paramring", 0)
		end
	end
end

function var0_0.IsLoaded(arg0_48)
	return arg0_48.state == var0_0.STATE_INITED
end

function var0_0.GetTouchPart(arg0_49)
	return arg0_49.liveCom:GetTouchPart()
end

function var0_0.TriggerAction(arg0_50, arg1_50, arg2_50, arg3_50, arg4_50)
	arg0_50:CheckStopDrag()

	local var0_50 = var11_0(arg0_50, arg1_50, arg3_50)

	if var0_50 then
		arg0_50.finishActionCB = arg2_50
		arg0_50.animEventCB = arg4_50
	end

	return var0_50
end

function var0_0.Reset(arg0_51)
	arg0_51:live2dActionChange(false)
	arg0_51:setEnableActions({})
	arg0_51:setIgnoreActions({})

	arg0_51.ableFlag = nil
end

function var0_0.setPurchaseOffset(arg0_52, arg1_52)
	local var0_52 = arg0_52.live2dData.ship:GetSkinConfig().purchase_offset

	if not var0_52 or #var0_52 < 3 then
		return
	end

	if arg1_52 then
		if var0_52 and #var0_52 >= 3 then
			arg0_52._tf.localPosition = Vector3(var0_52[1], var0_52[2], var0_52[3])
		end

		if var0_52 and #var0_52 >= 4 then
			arg0_52._tf.localScale = Vector3(var0_52[4], var0_52[4], var0_52[4])
		end
	else
		arg0_52._tf.localScale = arg0_52.live2dData.scale
		arg0_52._tf.localPosition = arg0_52.live2dData.position
	end
end

function var0_0.offsetL2dPositonDelay(arg0_53, arg1_53, arg2_53, arg3_53)
	if arg0_53._tf and LeanTween.isTweening(go(arg0_53._tf)) then
		LeanTween.cancel(go(arg0_53._tf))
	end

	arg0_53._tf.localPosition = Vector3(30000, 0, 0)
	arg0_53._animator.speed = arg2_53

	LeanTween.delayedCall(go(arg0_53._tf), arg1_53, System.Action(function()
		if arg0_53._tf then
			arg0_53:resetPosition()

			arg0_53._animator.speed = 1
		end

		if arg3_53 then
			arg3_53()
		end
	end))
end

function var0_0.resetL2dData(arg0_55)
	if not arg0_55._tf then
		return
	end

	if LeanTween.isTweening(go(arg0_55._tf)) then
		return
	end

	arg0_55:offsetL2dPositonDelay(0.3, 5)
	Live2dConst.ClearLive2dSave(arg0_55.live2dData.ship:getSkinId(), arg0_55.live2dData.ship.id)
	arg0_55:Reset()
	arg0_55:changeIdleIndex(0)
	arg0_55:loadLive2dData()
	var11_0(arg0_55, "idle", true)
end

function var0_0.applyActiveData(arg0_56, arg1_56)
	if not arg1_56 then
		return
	end

	local var0_56 = arg1_56.activeData
	local var1_56 = var0_56.enable
	local var2_56 = var0_56.idle_enable
	local var3_56 = var0_56.idle_ignore
	local var4_56 = var0_56.ignore
	local var5_56 = var0_56.idle and var0_56.idle or arg1_56.idle
	local var6_56 = var0_56.repeatFlag

	if var1_56 and #var1_56 >= 0 then
		arg0_56:setEnableActions(var1_56)
	elseif var2_56 and #var2_56 > 0 then
		for iter0_56, iter1_56 in ipairs(var2_56) do
			if iter1_56[1] == var5_56 then
				arg0_56:setEnableActions(iter1_56[2])
			end
		end
	end

	if var4_56 and #var4_56 >= 0 then
		arg0_56:setIgnoreActions(var4_56)
	elseif var3_56 and #var3_56 > 0 then
		for iter2_56, iter3_56 in ipairs(var3_56) do
			if iter3_56[1] == var5_56 then
				arg0_56:setIgnoreActions(iter3_56[2])
			end
		end
	end

	if var5_56 and var5_56 ~= arg0_56.indexIndex then
		arg0_56.saveActionAbleId = arg1_56.id
	end

	if var5_56 then
		local var7_56

		if type(var5_56) == "number" and var5_56 >= 0 then
			var7_56 = var5_56
		elseif type(var5_56) == "table" then
			local var8_56 = {}

			for iter4_56, iter5_56 in ipairs(var5_56) do
				if iter5_56 == arg0_56.idleIndex then
					if var6_56 then
						table.insert(var8_56, iter5_56)
					end
				else
					table.insert(var8_56, iter5_56)
				end
			end

			var7_56 = var8_56[math.random(1, #var8_56)]
		end

		if var7_56 then
			arg0_56:changeIdleIndex(var7_56)
		end

		arg0_56:saveLive2dData()
	end
end

function var0_0.setIgnoreActions(arg0_57, arg1_57)
	arg0_57.ignorePlayActions = arg1_57 and arg1_57 or {}
end

function var0_0.setEnableActions(arg0_58, arg1_58)
	arg0_58.enablePlayActions = arg1_58 and arg1_58 or {}
end

function var0_0.changeIdleIndex(arg0_59, arg1_59)
	local var0_59 = false

	if arg0_59.idleIndex ~= arg1_59 then
		local var1_59 = arg0_59._animator:GetInteger("idle")

		if var1_59 and var1_59 >= 0 then
			arg0_59._animator:SetInteger("idle", arg1_59)

			var0_59 = true
		end
	end

	arg0_59:onListenerHandle(Live2D.ON_ACTION_CHANGE_IDLE, {
		idle = arg0_59.idleIndex,
		idle_change = var0_59
	})
	print("live2d 待机动作设置为 = " .. arg1_59)

	arg0_59.idleIndex = arg1_59

	arg0_59:updateDragsSateData()
end

function var0_0.live2dActionChange(arg0_60, arg1_60)
	arg0_60.isPlaying = arg1_60

	arg0_60:updateDragsSateData()
end

function var0_0.setPosition(arg0_61, arg1_61)
	arg0_61._tf.localPosition = arg1_61
end

function var0_0.resetPosition(arg0_62)
	arg0_62._tf.localPosition = arg0_62.live2dData.position
end

function var0_0.updateDragsSateData(arg0_63)
	local var0_63 = {
		idleIndex = arg0_63.idleIndex,
		isPlaying = arg0_63.isPlaying,
		ignoreReact = arg0_63.ignoreReact,
		actionName = arg0_63.playActionName
	}

	if arg0_63.drags then
		for iter0_63 = 1, #arg0_63.drags do
			arg0_63.drags[iter0_63]:updateStateData(var0_63)
		end
	end
end

function var0_0.CheckStopDrag(arg0_64)
	local var0_64 = arg0_64.live2dData:GetShipSkinConfig()

	if var0_64.l2d_ignore_drag and var0_64.l2d_ignore_drag == 1 then
		arg0_64.liveCom.ResponseClick = false
		arg0_64.liveCom.inDrag = false
	end
end

function var0_0.changeParamaterValue(arg0_65, arg1_65, arg2_65)
	if arg0_65:IsLoaded() then
		if not arg1_65 or string.len(arg1_65) == 0 then
			return
		end

		local var0_65 = arg0_65.liveCom:GetCubismParameter(arg1_65)

		if not var0_65 then
			return
		end

		arg0_65.liveCom:AddParameterValue(var0_65, arg2_65, var6_0[1])
	else
		if not arg0_65.delayChangeParamater then
			arg0_65.delayChangeParamater = {}
		end

		table.insert(arg0_65.delayChangeParamater, {
			arg1_65,
			arg2_65
		})
	end
end

function var0_0.changeDragParameter(arg0_66, arg1_66, arg2_66)
	if arg0_66:IsLoaded() and arg0_66.drags then
		for iter0_66 = 1, #arg0_66.drags do
			if arg0_66.drags[iter0_66].parameterName and arg0_66.drags[iter0_66].parameterName == arg1_66 then
				arg0_66.drags[iter0_66]:setTargetValue(arg2_66)
			end
		end
	end
end

function var0_0.setSortingLayer(arg0_67, arg1_67)
	arg0_67:updateL2dSortMode()

	local var0_67 = arg0_67._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_67 = typeof("Live2D.Cubism.Rendering.CubismRenderController")

	ReflectionHelp.RefSetProperty(var1_67, "SortingOrder", var0_67, arg1_67)
end

function var0_0.updateL2dSortMode(arg0_68)
	local var0_68 = arg0_68._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_68 = typeof("Live2D.Cubism.Rendering.CubismRenderController")
	local var2_68 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Rendering.CubismSortingMode"), "BackToFrontOrder", nil)

	ReflectionHelp.RefSetProperty(var1_68, "SortingMode", var0_68, var2_68)
end

function var0_0.Dispose(arg0_69)
	if arg0_69.state == var0_0.STATE_INITED then
		arg0_69.liveCom.FinishAction = nil
		arg0_69.liveCom.EventAction = nil

		arg0_69.liveCom:SetMouseInputActions(nil, nil)
	end

	if arg0_69._tf and LeanTween.isTweening(go(arg0_69._tf)) then
		LeanTween.cancel(go(arg0_69._tf))
	end

	arg0_69:saveLive2dData()

	arg0_69._readlyToStop = false

	if arg0_69.live2dRequestId then
		pg.Live2DMgr.GetInstance():StopLoadingLive2d(arg0_69.live2dRequestId)

		arg0_69.live2dRequestId = nil
	end

	if arg0_69.drags then
		for iter0_69 = 1, #arg0_69.drags do
			arg0_69.drags[iter0_69]:dispose()
		end

		arg0_69.drags = {}
	end

	if arg0_69.live2dData and arg0_69.live2dData.gyro == 1 then
		Input.gyro.enabled = false
	end

	if arg0_69.live2dData then
		arg0_69.live2dData:Clear()

		arg0_69.live2dData = nil
	end

	if arg0_69.timer then
		arg0_69.timer:Stop()

		arg0_69.timer = nil
	end

	if arg0_69._go and arg0_69.state == var0_0.STATE_INITED then
		Destroy(arg0_69._go)
	end

	arg0_69.state = var0_0.STATE_DISPOSE
end

function var0_0.UpdateAtomSource(arg0_70)
	arg0_70.updateAtom = true
end

function var0_0.AtomSouceFresh(arg0_71)
	local var0_71 = pg.CriMgr.GetInstance():getAtomSource(pg.CriMgr.C_VOICE)
	local var1_71 = arg0_71._go:GetComponent("CubismCriSrcMouthInput").Analyzer

	var0_71:AttachToAnalyzer(var1_71)

	if arg0_71.updateAtom then
		arg0_71.updateAtom = false
	end
end

function var0_0.addKeyBoard(arg0_72)
	return
end

function var0_0.SetL2dSortingLayer(arg0_73, arg1_73)
	var0_0.UpdateL2dSortMode(arg0_73)

	local var0_73 = arg0_73:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_73 = typeof("Live2D.Cubism.Rendering.CubismRenderController")

	ReflectionHelp.RefSetProperty(var1_73, "SortingOrder", var0_73, arg1_73)
end

function var0_0.UpdateL2dSortMode(arg0_74)
	local var0_74 = arg0_74:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_74 = typeof("Live2D.Cubism.Rendering.CubismRenderController")
	local var2_74 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Rendering.CubismSortingMode"), "BackToFrontOrder", nil)

	ReflectionHelp.RefSetProperty(var1_74, "SortingMode", var0_74, var2_74)
end

return var0_0
