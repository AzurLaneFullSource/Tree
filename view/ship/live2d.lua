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
			arg0_2.scale = arg1_2.scale

			local var0_2 = arg0_2:GetShipSkinConfig().live2d_offset

			arg0_2.gyro = arg0_2:GetShipSkinConfig().gyro or 0
			arg0_2.shipL2dId = arg0_2:GetShipSkinConfig().ship_l2d_id
			arg0_2.skinId = arg0_2:GetShipSkinConfig().id
			arg0_2.spineUseLive2d = false

			if arg0_2.skinId then
				arg0_2.spineUseLive2d = pg.ship_skin_template[arg0_2.skinId].spine_use_live2d == 1
			end

			arg0_2.position = arg1_2.position + BuildVector3(var0_2)
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

		print("action id " .. tostring(arg1_11) .. " → 开始播放动作" .. tostring(var1_11))

		if var1_11 then
			arg0_11.playActionName = arg1_11

			arg0_11.liveCom:SetAction(var1_11)
			arg0_11:live2dActionChange(true)

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

		if (not var1_14 or var1_14 == "") and var2_14 then
			var2_14(var9_0(arg0_14))
		end

		if var9_0(arg0_14) then
			if var6_14 ~= nil then
				arg0_14:setReactPos(tobool(var6_14))
			end

			arg0_14:onListenerHandle(Live2D.ON_ACTION_PLAY, {
				action = var1_14
			})

			if var7_14 and var7_14 == 1 and (not var1_14 or var1_14 == "") then
				var1_14 = "idle"

				arg0_14:changeIdleIndex(var4_14.idle and var4_14.idle or 0)
			end

			local var8_14 = var11_0(arg0_14, var1_14, var5_14 or false)

			if var8_14 then
				arg0_14:applyActiveData(arg2_14)
			end

			if var7_14 and var7_14 == 1 then
				arg0_14:live2dActionChange(false)
			end

			if var2_14 then
				var2_14(var8_14)
			end
		end
	elseif arg1_14 == Live2D.EVENT_ACTION_ABLE then
		if arg0_14.ableFlag ~= arg2_14.ableFlag then
			arg0_14.ableFlag = arg2_14.ableFlag

			if arg2_14.ableFlag then
				arg0_14.tempEnable = arg0_14.enablePlayActions
				arg0_14.enablePlayActions = {
					"none action apply"
				}
			else
				arg0_14.enablePlayActions = arg0_14.tempEnable
			end
		else
			print("able flag 相同，不执行操作")
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
		arg0_15._listenerStepIndex = 5

		for iter0_15, iter1_15 in ipairs(arg0_15._listenerParameters) do
			arg0_15._listenerParametersValue[iter1_15.name] = iter1_15.Value
		end

		arg0_15:onListenerHandle(Live2D.ON_ACTION_PARAMETER, {
			values = arg0_15._listenerParametersValue
		})
	else
		arg0_15._listenerStepIndex = arg0_15._listenerStepIndex - 1
	end

	local var0_15 = false
	local var1_15 = ReflectionHelp.RefGetField(typeof(Live2dChar), "reactPos", arg0_15.liveCom)

	for iter2_15 = 1, #arg0_15.drags do
		arg0_15.drags[iter2_15]:changeReactValue(var1_15)
		arg0_15.drags[iter2_15]:stepParameter()

		local var2_15 = arg0_15.drags[iter2_15]:getParameToTargetFlag()
		local var3_15 = arg0_15.drags[iter2_15]:getActive()

		if (var2_15 or var3_15) and arg0_15.drags[iter2_15]:getIgnoreReact() then
			var0_15 = true
		elseif arg0_15.drags[iter2_15]:getReactCondition() then
			var0_15 = true
		end

		local var4_15 = arg0_15.drags[iter2_15]:getParameter()
		local var5_15 = arg0_15.drags[iter2_15]:getParameterUpdateFlag()

		if var4_15 and var5_15 then
			local var6_15 = arg0_15.drags[iter2_15]:getParameterCom()

			if var6_15 then
				arg0_15.liveCom:ChangeParameterData(var6_15, var4_15)
			end
		end

		local var7_15 = arg0_15.drags[iter2_15]:getRelationParameterList()

		for iter3_15, iter4_15 in ipairs(var7_15) do
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

	for iter1_16, iter2_16 in ipairs(arg0_16.live2dData.shipL2dId) do
		local var0_16 = pg.ship_l2d[iter2_16]

		if var0_16 and arg0_16:getDragEnable(var0_16) then
			local var1_16 = Live2dDrag.New(var0_16, arg0_16.live2dData)
			local var2_16 = arg0_16.liveCom:GetCubismParameter(var0_16.parameter)

			var1_16:setParameterCom(var2_16)
			var1_16:setEventCallback(function(arg0_17, arg1_17)
				var14_0(arg0_16, arg0_17, arg1_17)
				var13_0(arg0_16, arg0_17, arg1_17)
			end)
			arg0_16.liveCom:AddParameterValue(var1_16.parameterName, var1_16.startValue, var6_0[var0_16.mode])

			if var0_16.relation_parameter and var0_16.relation_parameter.list then
				local var3_16 = var0_16.relation_parameter.list

				for iter3_16, iter4_16 in ipairs(var3_16) do
					local var4_16 = arg0_16.liveCom:GetCubismParameter(iter4_16.name)

					if var4_16 then
						var1_16:addRelationComData(var4_16, iter4_16)

						local var5_16 = iter4_16.mode or var0_16.mode

						arg0_16.liveCom:AddParameterValue(iter4_16.name, iter4_16.start or var1_16.startValue or 0, var6_0[var5_16])
					end
				end
			end

			table.insert(arg0_16.drags, var1_16)

			if not table.contains(arg0_16._listenerParameters, var2_16) then
				table.insert(arg0_16._listenerParameters, var2_16)
			end

			if var1_16.drawAbleName and var1_16.drawAbleName ~= "" and not table.contains(arg0_16.dragParts, var1_16.drawAbleName) then
				table.insert(arg0_16.dragParts, var1_16.drawAbleName)
			end
		end
	end

	arg0_16.liveCom:SetDragParts(arg0_16.dragParts)

	arg0_16.eventTrigger = GetOrAddComponent(arg0_16.liveCom.transform.parent, typeof(EventTriggerListener))

	arg0_16.eventTrigger:AddPointDownFunc(function()
		if arg0_16.useEventTriggerFlag then
			arg0_16:onPointDown()
		end
	end)
	arg0_16.eventTrigger:AddPointUpFunc(function()
		if arg0_16.useEventTriggerFlag then
			arg0_16:onPointUp()
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

	arg0_16.paraRanges = ReflectionHelp.RefGetField(typeof(Live2dChar), "paraRanges", arg0_16.liveCom)
	arg0_16.destinations = {}

	local var6_16 = ReflectionHelp.RefGetProperty(typeof(Live2dChar), "Destinations", arg0_16.liveCom)

	for iter5_16 = 0, var6_16.Length - 1 do
		local var7_16 = var6_16[iter5_16]

		table.insert(arg0_16.destinations, var6_16[iter5_16])
	end

	arg0_16.timer = Timer.New(function()
		var15_0(arg0_16)
	end, 0.0333333333333333, -1)

	arg0_16.timer:Start()
	var15_0(arg0_16)
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

function var0_0.onPointDown(arg0_25)
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
					iter1_25:startDrag()
				end
			end
		end
	end
end

function var0_0.onPointUp(arg0_26)
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
			arg0_26.drags[iter0_26]:stopDrag()
		end
	end
end

function var0_0.changeTriggerFlag(arg0_27, arg1_27)
	arg0_27.useEventTriggerFlag = arg1_27
end

local function var17_0(arg0_28, arg1_28)
	arg0_28._go = arg1_28
	arg0_28._tf = tf(arg1_28)

	UIUtil.SetLayerRecursively(arg0_28._go, LayerMask.NameToLayer("UI"))
	arg0_28._tf:SetParent(arg0_28.live2dData.parent, true)

	arg0_28._tf.localScale = arg0_28.live2dData.scale
	arg0_28._tf.localPosition = arg0_28.live2dData.position
	arg0_28.liveCom = arg1_28:GetComponent(typeof(Live2dChar))
	arg0_28._animator = arg1_28:GetComponent(typeof(Animator))
	arg0_28.animationClipNames = {}

	if arg0_28._animator and arg0_28._animator.runtimeAnimatorController then
		local var0_28 = arg0_28._animator.runtimeAnimatorController.animationClips
		local var1_28 = var0_28.Length

		for iter0_28 = 0, var1_28 - 1 do
			table.insert(arg0_28.animationClipNames, var0_28[iter0_28].name)
		end
	end

	local var2_28 = var1_0.action2Id.idle

	arg0_28.liveCom:SetReactMotions(var1_0.idleActions)
	arg0_28.liveCom:SetAction(var2_28)

	function arg0_28.liveCom.FinishAction(arg0_29)
		arg0_28:live2dActionChange(false)

		if arg0_28.finishActionCB then
			arg0_28.finishActionCB()

			arg0_28.finishActionCB = nil
		end

		arg0_28:changeActionIdle()
	end

	function arg0_28.liveCom.EventAction(arg0_30)
		if arg0_28.animEventCB then
			arg0_28.animEventCB(arg0_30)

			arg0_28.animEventCB = nil
		end
	end

	arg0_28.liveCom:SetTouchParts(var1_0.assistantTouchParts)

	if arg0_28.live2dData and arg0_28.live2dData.ship and arg0_28.live2dData.ship.propose then
		arg0_28:changeParamaterValue("Paramring", 1)
	else
		arg0_28:changeParamaterValue("Paramring", 0)
	end

	if not arg0_28._physics then
		arg0_28._physics = GetComponent(arg0_28._tf, "CubismPhysicsController")
	end

	if arg0_28._physics then
		arg0_28._physics.enabled = false
		arg0_28._physics.enabled = true
	end

	if arg0_28.live2dData.l2dDragRate and #arg0_28.live2dData.l2dDragRate > 0 then
		arg0_28.liveCom.DragRateX = arg0_28.live2dData.l2dDragRate[1] * var2_0
		arg0_28.liveCom.DragRateY = arg0_28.live2dData.l2dDragRate[2] * var3_0
		arg0_28.liveCom.DampingTime = arg0_28.live2dData.l2dDragRate[3] * var4_0
	end

	var7_0(arg0_28)
	var8_0(arg0_28)
	var12_0(arg0_28)

	if arg0_28.live2dData.shipL2dId and #arg0_28.live2dData.shipL2dId > 0 then
		var16_0(arg0_28)
	end

	arg0_28:addKeyBoard()

	arg0_28.state = var0_0.STATE_INITED

	if arg0_28.delayChangeParamater and #arg0_28.delayChangeParamater > 0 then
		for iter1_28 = 1, #arg0_28.delayChangeParamater do
			local var3_28 = arg0_28.delayChangeParamater[iter1_28]

			arg0_28:changeParamaterValue(var3_28[1], var3_28[2])
		end

		arg0_28.delayChangeParamater = nil
	end

	arg0_28.enablePlayActions = {}
	arg0_28.ignorePlayActions = {}

	arg0_28:changeIdleIndex(0)
	arg0_28:loadLive2dData()
end

function var0_0.Ctor(arg0_31, arg1_31, arg2_31)
	arg0_31.state = var0_0.STATE_LOADING
	arg0_31.live2dData = arg1_31
	var1_0 = pg.AssistantInfo

	assert(not arg0_31.live2dData:isEmpty())

	local var0_31 = arg0_31.live2dData:GetShipName()

	local function var1_31(arg0_32)
		var17_0(arg0_31, arg0_32)

		if arg2_31 then
			arg2_31(arg0_31)
		end
	end

	arg0_31.live2dRequestId = pg.Live2DMgr.GetInstance():GetLive2DModelAsync(var0_31, var1_31)
	Input.gyro.enabled = arg0_31.live2dData.gyro == 1 and PlayerPrefs.GetInt(GYRO_ENABLE, 1) == 1
	arg0_31.useEventTriggerFlag = true
end

function var0_0.setStopCallback(arg0_33, arg1_33)
	arg0_33._stopCallback = arg1_33
end

function var0_0.SetVisible(arg0_34, arg1_34)
	if not arg0_34:IsLoaded() then
		return
	end

	Input.gyro.enabled = PlayerPrefs.GetInt(GYRO_ENABLE, 1) == 1

	arg0_34:setReactPos(true)
	arg0_34:Reset()

	if arg1_34 then
		arg0_34._readlyToStop = false

		onDelayTick(function()
			if not arg0_34._readlyToStop then
				if arg0_34._physics then
					arg0_34._physics.enabled = false
					arg0_34._physics.enabled = true
				end

				arg0_34:setReactPos(false)
			end
		end, 1)
	else
		var11_0(arg0_34, "idle", true)

		arg0_34._readlyToStop = true

		onDelayTick(function()
			if arg0_34._readlyToStop then
				arg0_34._animator.speed = 0

				if arg0_34._stopCallback then
					arg0_34._stopCallback()
				end
			end
		end, 3)
	end

	if arg1_34 then
		arg0_34:loadLive2dData()
	else
		arg0_34:saveLive2dData()
		arg0_34:loadLive2dData()
	end

	var15_0(arg0_34, true)

	arg0_34._animator.speed = 1
end

function var0_0.loadLive2dData(arg0_37)
	if not arg0_37.live2dData.loadPrefs then
		return
	end

	if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and not arg0_37.live2dData.spineUseLive2d then
		if arg0_37.drags then
			for iter0_37 = 1, #arg0_37.drags do
				arg0_37.drags[iter0_37]:clearData()
				arg0_37.drags[iter0_37]:loadL2dFinal()
			end
		end

		arg0_37:changeIdleIndex(0)
		arg0_37._animator:Play("idle")

		arg0_37.saveActionAbleId = nil

		return
	end

	local var0_37, var1_37 = Live2dConst.GetL2dSaveData(arg0_37.live2dData:GetShipSkinConfig().id, arg0_37.live2dData.ship.id)
	local var2_37 = Live2dConst.GetDragActionIndex(var1_37, arg0_37.live2dData:GetShipSkinConfig().id, arg0_37.live2dData.ship.id) or 1

	if var0_37 then
		arg0_37:changeIdleIndex(var0_37)

		if var0_37 == 0 then
			arg0_37._animator:Play("idle")
		else
			arg0_37._animator:Play("idle" .. var0_37)
		end
	end

	arg0_37.saveActionAbleId = var1_37

	if var1_37 and var1_37 > 0 then
		if pg.ship_l2d[var1_37] then
			local var3_37 = pg.ship_l2d[var1_37].action_trigger_active

			if var0_37 and var3_37.idle_enable and #var3_37.idle_enable > 0 then
				for iter1_37, iter2_37 in ipairs(var3_37.idle_enable) do
					if iter2_37[1] == var0_37 then
						arg0_37.enablePlayActions = iter2_37[2]
					end
				end
			elseif var2_37 and var2_37 >= 1 and var3_37.active_list then
				arg0_37.enablePlayActions = var3_37.active_list[var2_37].enable and var3_37.active_list[var2_37].enable or {}
			else
				arg0_37.enablePlayActions = var3_37.enable and var3_37.enable or {}
			end

			if var0_37 and var3_37.idle_ignore and #var3_37.idle_ignore > 0 then
				for iter3_37, iter4_37 in ipairs(var3_37.idle_ignore) do
					if iter4_37[1] == var0_37 then
						arg0_37.ignorePlayActions = iter4_37[2]
					end
				end
			elseif var2_37 and var2_37 >= 1 and var3_37.active_list then
				arg0_37.ignorePlayActions = var3_37.active_list[var2_37].ignore and var3_37.active_list[var2_37].ignore or {}
			else
				arg0_37.ignorePlayActions = var3_37.ignore and var3_37.ignore or {}
			end
		end
	else
		arg0_37.enablePlayActions = {}
		arg0_37.ignorePlayActions = {}
	end

	if arg0_37.drags then
		for iter5_37 = 1, #arg0_37.drags do
			arg0_37.drags[iter5_37]:loadData()
			arg0_37.drags[iter5_37]:loadL2dFinal()
		end
	end
end

function var0_0.saveLive2dData(arg0_38)
	if not arg0_38.live2dData.loadPrefs then
		return
	end

	if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and not arg0_38.live2dData.spineUseLive2d then
		return
	end

	if arg0_38.idleIndex then
		Live2dConst.SaveL2dIdle(arg0_38.live2dData:GetShipSkinConfig().id, arg0_38.live2dData.ship.id, arg0_38.idleIndex)
	end

	if arg0_38.saveActionAbleId then
		if arg0_38.idleIndex == 0 then
			Live2dConst.SaveL2dAction(arg0_38.live2dData:GetShipSkinConfig().id, arg0_38.live2dData.ship.id, 0)
		else
			Live2dConst.SaveL2dAction(arg0_38.live2dData:GetShipSkinConfig().id, arg0_38.live2dData.ship.id, arg0_38.saveActionAbleId)
		end
	end

	if arg0_38.drags then
		for iter0_38 = 1, #arg0_38.drags do
			arg0_38.drags[iter0_38]:saveData()
		end
	end
end

function var0_0.changeActionIdle(arg0_39)
	local var0_39 = var1_0.idleActions[math.ceil(math.random(#var1_0.idleActions))]

	arg0_39.liveCom:SetAction(var0_39)
end

function var0_0.enablePlayAction(arg0_40, arg1_40)
	return var10_0(arg0_40, arg1_40)
end

function var0_0.IgonreReactPos(arg0_41, arg1_41)
	arg0_41:setReactPos(arg1_41)
end

function var0_0.setReactPos(arg0_42, arg1_42)
	if arg0_42.liveCom then
		arg0_42.ignoreReact = arg1_42

		arg0_42.liveCom:IgonreReactPos(arg1_42)

		if arg1_42 then
			ReflectionHelp.RefSetField(typeof(Live2dChar), "inDrag", arg0_42.liveCom, false)
		end

		ReflectionHelp.RefSetField(typeof(Live2dChar), "reactPos", arg0_42.liveCom, Vector3(0, 0, 0))
		arg0_42:updateDragsSateData()
	end
end

function var0_0.l2dCharEnable(arg0_43, arg1_43)
	arg0_43._l2dCharEnable = arg1_43
end

function var0_0.inShopPreView(arg0_44, arg1_44)
	arg0_44._shopPreView = arg1_44
end

function var0_0.getDragEnable(arg0_45, arg1_45)
	if arg0_45._shopPreView and arg1_45.shop_action == 0 then
		return false
	end

	return true
end

function var0_0.updateShip(arg0_46, arg1_46)
	if arg1_46 and arg0_46.live2dData and arg0_46.live2dData.ship then
		arg0_46.live2dData.ship = arg1_46

		if arg0_46.live2dData and arg0_46.live2dData.ship and arg0_46.live2dData.ship.propose then
			arg0_46:changeParamaterValue("Paramring", 1)
		else
			arg0_46:changeParamaterValue("Paramring", 0)
		end
	end
end

function var0_0.IsLoaded(arg0_47)
	return arg0_47.state == var0_0.STATE_INITED
end

function var0_0.GetTouchPart(arg0_48)
	return arg0_48.liveCom:GetTouchPart()
end

function var0_0.TriggerAction(arg0_49, arg1_49, arg2_49, arg3_49, arg4_49)
	arg0_49:CheckStopDrag()

	arg0_49.finishActionCB = arg2_49
	arg0_49.animEventCB = arg4_49

	return (var11_0(arg0_49, arg1_49, arg3_49))
end

function var0_0.Reset(arg0_50)
	arg0_50:live2dActionChange(false)

	arg0_50.enablePlayActions = {}
	arg0_50.ignorePlayActions = {}
	arg0_50.ableFlag = nil
end

function var0_0.resetL2dData(arg0_51)
	if not arg0_51._tf then
		return
	end

	if arg0_51._tf and LeanTween.isTweening(go(arg0_51._tf)) then
		return
	end

	arg0_51._l2dPosition = arg0_51._tf.position
	arg0_51._tf.position = Vector3(arg0_51._l2dPosition.x + 100, 0, 0)

	LeanTween.delayedCall(go(arg0_51._tf), 0.2, System.Action(function()
		if arg0_51._tf then
			arg0_51._tf.position = arg0_51._l2dPosition
		end
	end))
	Live2dConst.ClearLive2dSave(arg0_51.live2dData.ship.skinId, arg0_51.live2dData.ship.id)
	arg0_51:Reset()
	arg0_51:changeIdleIndex(0)
	arg0_51:loadLive2dData()
end

function var0_0.applyActiveData(arg0_53, arg1_53)
	local var0_53 = arg1_53.activeData
	local var1_53 = var0_53.enable
	local var2_53 = var0_53.idle_enable
	local var3_53 = var0_53.idle_ignore
	local var4_53 = var0_53.ignore
	local var5_53 = var0_53.idle and var0_53.idle or arg1_53.idle

	print("active data idle = " .. tostring(var5_53))

	local var6_53 = var0_53.repeatFlag

	if var1_53 and #var1_53 >= 0 then
		arg0_53.enablePlayActions = var1_53
	elseif var2_53 and #var2_53 > 0 then
		for iter0_53, iter1_53 in ipairs(var2_53) do
			if iter1_53[1] == var5_53 then
				arg0_53.enablePlayActions = iter1_53[2]
			end
		end
	end

	if var4_53 and #var4_53 >= 0 then
		arg0_53.ignorePlayActions = var4_53
	elseif var3_53 and #var3_53 > 0 then
		for iter2_53, iter3_53 in ipairs(var3_53) do
			if iter3_53[1] == var5_53 then
				arg0_53.ignorePlayActions = iter3_53[2]
			end
		end
	end

	if var5_53 and var5_53 ~= arg0_53.indexIndex then
		arg0_53.saveActionAbleId = arg1_53.id
	end

	if var5_53 then
		local var7_53

		if type(var5_53) == "number" and var5_53 >= 0 then
			var7_53 = var5_53
		elseif type(var5_53) == "table" then
			local var8_53 = {}

			for iter4_53, iter5_53 in ipairs(var5_53) do
				if iter5_53 == arg0_53.idleIndex then
					if var6_53 then
						table.insert(var8_53, iter5_53)
					end
				else
					table.insert(var8_53, iter5_53)
				end
			end

			var7_53 = var8_53[math.random(1, #var8_53)]
		end

		if var7_53 then
			arg0_53:changeIdleIndex(var7_53)
		end

		arg0_53:saveLive2dData()
	end
end

function var0_0.changeIdleIndex(arg0_54, arg1_54)
	local var0_54 = false

	if arg0_54.idleIndex ~= arg1_54 then
		arg0_54._animator:SetInteger("idle", arg1_54)

		var0_54 = true
	end

	arg0_54:onListenerHandle(Live2D.ON_ACTION_CHANGE_IDLE, {
		idle = arg0_54.idleIndex,
		idle_change = var0_54
	})
	print("now set idle index is " .. arg1_54)

	arg0_54.idleIndex = arg1_54

	arg0_54:updateDragsSateData()
end

function var0_0.live2dActionChange(arg0_55, arg1_55)
	arg0_55.isPlaying = arg1_55

	arg0_55:updateDragsSateData()
end

function var0_0.updateDragsSateData(arg0_56)
	local var0_56 = {
		idleIndex = arg0_56.idleIndex,
		isPlaying = arg0_56.isPlaying,
		ignoreReact = arg0_56.ignoreReact,
		actionName = arg0_56.playActionName
	}

	if arg0_56.drags then
		for iter0_56 = 1, #arg0_56.drags do
			arg0_56.drags[iter0_56]:updateStateData(var0_56)
		end
	end
end

function var0_0.CheckStopDrag(arg0_57)
	local var0_57 = arg0_57.live2dData:GetShipSkinConfig()

	if var0_57.l2d_ignore_drag and var0_57.l2d_ignore_drag == 1 then
		arg0_57.liveCom.ResponseClick = false

		ReflectionHelp.RefSetField(typeof(Live2dChar), "inDrag", arg0_57.liveCom, false)
	end
end

function var0_0.changeParamaterValue(arg0_58, arg1_58, arg2_58)
	if arg0_58:IsLoaded() then
		if not arg1_58 or string.len(arg1_58) == 0 then
			return
		end

		local var0_58 = arg0_58.liveCom:GetCubismParameter(arg1_58)

		if not var0_58 then
			return
		end

		arg0_58.liveCom:AddParameterValue(var0_58, arg2_58, var6_0[1])
	else
		if not arg0_58.delayChangeParamater then
			arg0_58.delayChangeParamater = {}
		end

		table.insert(arg0_58.delayChangeParamater, {
			arg1_58,
			arg2_58
		})
	end
end

function var0_0.Dispose(arg0_59)
	if arg0_59.state == var0_0.STATE_INITED then
		if arg0_59._go then
			Destroy(arg0_59._go)
		end

		arg0_59.liveCom.FinishAction = nil
		arg0_59.liveCom.EventAction = nil
	end

	arg0_59:saveLive2dData()
	arg0_59.liveCom:SetMouseInputActions(nil, nil)

	arg0_59._readlyToStop = false
	arg0_59.state = var0_0.STATE_DISPOSE

	pg.Live2DMgr.GetInstance():StopLoadingLive2d(arg0_59.live2dRequestId)

	arg0_59.live2dRequestId = nil

	if arg0_59.drags then
		for iter0_59 = 1, #arg0_59.drags do
			arg0_59.drags[iter0_59]:dispose()
		end

		arg0_59.drags = {}
	end

	if arg0_59.live2dData.gyro == 1 then
		Input.gyro.enabled = false
	end

	if arg0_59.live2dData then
		arg0_59.live2dData:Clear()

		arg0_59.live2dData = nil
	end

	arg0_59:live2dActionChange(false)

	if arg0_59.timer then
		arg0_59.timer:Stop()

		arg0_59.timer = nil
	end
end

function var0_0.UpdateAtomSource(arg0_60)
	arg0_60.updateAtom = true
end

function var0_0.AtomSouceFresh(arg0_61)
	local var0_61 = pg.CriMgr.GetInstance():getAtomSource(pg.CriMgr.C_VOICE)
	local var1_61 = arg0_61._go:GetComponent("CubismCriSrcMouthInput")
	local var2_61 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Framework.MouthMovement.CubismCriSrcMouthInput"), "Analyzer", var1_61)

	var0_61:AttachToAnalyzer(var2_61)

	if arg0_61.updateAtom then
		arg0_61.updateAtom = false
	end
end

function var0_0.addKeyBoard(arg0_62)
	return
end

return var0_0
