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
var0_0.EVENT_ACTION_APPLY = "event action apply"
var0_0.EVENT_ACTION_ABLE = "event action able"
var0_0.EVENT_ADD_PARAMETER_COM = "event add parameter com "
var0_0.EVENT_REMOVE_PARAMETER_COM = "event remove parameter com "
var0_0.relation_type_drag_x = 101
var0_0.relation_type_drag_y = 102
var0_0.relation_type_action_index = 103

local var5_0 = {
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

local function var6_0(arg0_7)
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

local function var7_0(arg0_8)
	local var0_8 = arg0_8.live2dData:GetShipSkinConfig().l2d_para_range

	if var0_8 ~= nil and type(var0_8) == "table" then
		for iter0_8, iter1_8 in pairs(var0_8) do
			arg0_8.liveCom:SetParaRange(iter0_8, iter1_8)
		end
	end
end

local function var8_0(arg0_9, arg1_9)
	if not arg1_9 or arg1_9 == "" then
		return false
	end

	if arg0_9.enablePlayActions and #arg0_9.enablePlayActions > 0 and not table.contains(arg0_9.enablePlayActions, arg1_9) then
		return false
	end

	if arg0_9.ignorePlayActions and #arg0_9.ignorePlayActions > 0 and table.contains(arg0_9.ignorePlayActions, arg1_9) then
		return false
	end

	if arg0_9._readlyToStop then
		return false
	end

	return true
end

local function var9_0(arg0_10, arg1_10, arg2_10)
	if not var8_0(arg0_10, arg1_10) then
		return false
	end

	if arg0_10.updateAtom then
		arg0_10:AtomSouceFresh()
	end

	if arg0_10.animationClipNames then
		local var0_10 = arg0_10:checkActionExist(arg1_10)

		if (not var0_10 or var0_10 == false) and string.find(arg1_10, "main_") then
			arg1_10 = "main_3"
		end
	end

	if not arg0_10.isPlaying or arg2_10 then
		local var1_10 = var1_0.action2Id[arg1_10]

		if var1_10 then
			arg0_10.playActionName = arg1_10

			arg0_10.liveCom:SetAction(var1_10)
			arg0_10:live2dActionChange(true)

			return true
		else
			print(tostring(arg1_10) .. " action is not exist")
		end
	end

	return false
end

function var0_0.checkActionExist(arg0_11, arg1_11)
	return (table.indexof(arg0_11.animationClipNames, arg1_11))
end

local function var10_0(arg0_12, arg1_12)
	arg0_12.liveCom:SetCenterPart("Drawables/TouchHead", Vector3.zero)

	arg0_12.liveCom.DampingTime = 0.3
end

local function var11_0(arg0_13, arg1_13, arg2_13)
	if arg1_13 == Live2D.EVENT_ACTION_APPLY then
		local var0_13 = arg2_13.id
		local var1_13 = arg2_13.action
		local var2_13 = arg2_13.callback
		local var3_13 = arg2_13.activeData
		local var4_13 = arg2_13.focus
		local var5_13 = arg2_13.react

		if not var8_0(arg0_13, var1_13) then
			return
		end

		if var5_13 ~= nil then
			arg0_13:setReactPos(tobool(var5_13))
		end

		if var1_13 then
			var9_0(arg0_13, var1_13, var4_13 or false)
		end

		arg0_13:applyActiveData(arg2_13, var3_13)

		if var2_13 then
			var2_13()
		end
	elseif arg1_13 == Live2D.EVENT_ACTION_ABLE then
		if arg0_13.ableFlag ~= arg2_13.ableFlag then
			arg0_13.ableFlag = arg2_13.ableFlag

			if arg2_13.ableFlag then
				arg0_13.tempEnable = arg0_13.enablePlayActions
				arg0_13.enablePlayActions = {
					"none action apply"
				}
			else
				arg0_13.enablePlayActions = arg0_13.tempEnable
			end
		else
			print("able flag 相同，不执行操作")
		end

		if arg2_13.callback then
			arg2_13.callback()
		end
	elseif arg1_13 == Live2D.EVENT_ADD_PARAMETER_COM then
		arg0_13.liveCom:AddParameterValue(arg2_13.com, arg2_13.start, var5_0[arg2_13.mode])
	elseif arg1_13 == Live2D.EVENT_REMOVE_PARAMETER_COM then
		arg0_13.liveCom:removeParameterValue(arg2_13.com)
	end
end

local function var12_0(arg0_14)
	if not arg0_14._l2dCharEnable then
		return
	end

	if arg0_14._readlyToStop then
		return
	end

	local var0_14 = false
	local var1_14 = ReflectionHelp.RefGetField(typeof(Live2dChar), "reactPos", arg0_14.liveCom)

	for iter0_14 = 1, #arg0_14.drags do
		arg0_14.drags[iter0_14]:changeReactValue(var1_14)
		arg0_14.drags[iter0_14]:stepParameter()

		local var2_14 = arg0_14.drags[iter0_14]:getParameToTargetFlag()
		local var3_14 = arg0_14.drags[iter0_14]:getActive()

		if (var2_14 or var3_14) and arg0_14.drags[iter0_14]:getIgnoreReact() then
			var0_14 = true
		elseif arg0_14.drags[iter0_14]:getReactCondition() then
			var0_14 = true
		end

		local var4_14 = arg0_14.drags[iter0_14]:getParameter()
		local var5_14 = arg0_14.drags[iter0_14]:getParameterUpdateFlag()

		if var4_14 and var5_14 then
			local var6_14 = arg0_14.drags[iter0_14]:getParameterCom()

			if var6_14 then
				arg0_14.liveCom:ChangeParameterData(var6_14, var4_14)
			end
		end

		local var7_14 = arg0_14.drags[iter0_14]:getRelationParameterList()

		for iter1_14, iter2_14 in ipairs(var7_14) do
			if iter2_14.enable then
				arg0_14.liveCom:ChangeParameterData(iter2_14.com, iter2_14.value)
			end
		end
	end

	if var0_14 == arg0_14.ignoreReact or not var0_14 and (arg0_14.mouseInputDown or arg0_14.isPlaying) then
		-- block empty
	else
		arg0_14:setReactPos(var0_14)
	end
end

local function var13_0(arg0_15)
	arg0_15.drags = {}
	arg0_15.dragParts = {}

	for iter0_15 = 1, #var1_0.assistantTouchParts do
		table.insert(arg0_15.dragParts, var1_0.assistantTouchParts[iter0_15])
	end

	arg0_15._l2dCharEnable = true
	arg0_15._shopPreView = arg0_15.live2dData.shopPreView

	for iter1_15, iter2_15 in ipairs(arg0_15.live2dData.shipL2dId) do
		local var0_15 = pg.ship_l2d[iter2_15]

		if var0_15 and arg0_15:getDragEnable(var0_15) then
			local var1_15 = Live2dDrag.New(var0_15, arg0_15.live2dData)
			local var2_15 = arg0_15.liveCom:GetCubismParameter(var0_15.parameter)

			var1_15:setParameterCom(var2_15)
			var1_15:setEventCallback(function(arg0_16, arg1_16)
				var11_0(arg0_15, arg0_16, arg1_16)
			end)
			arg0_15.liveCom:AddParameterValue(var1_15.parameterName, var1_15.startValue, var5_0[var0_15.mode])

			if var0_15.relation_parameter and var0_15.relation_parameter.list then
				local var3_15 = var0_15.relation_parameter.list

				for iter3_15, iter4_15 in ipairs(var3_15) do
					local var4_15 = arg0_15.liveCom:GetCubismParameter(iter4_15.name)

					if var4_15 then
						var1_15:addRelationComData(var4_15, iter4_15)

						local var5_15 = iter4_15.mode or var0_15.mode

						arg0_15.liveCom:AddParameterValue(iter4_15.name, iter4_15.start or var1_15.startValue or 0, var5_0[var5_15])
					end
				end
			end

			table.insert(arg0_15.drags, var1_15)

			if not table.contains(arg0_15.dragParts, var1_15.drawAbleName) then
				table.insert(arg0_15.dragParts, var1_15.drawAbleName)
			end
		end
	end

	arg0_15.liveCom:SetDragParts(arg0_15.dragParts)

	arg0_15.eventTrigger = GetOrAddComponent(arg0_15.liveCom.transform.parent, typeof(EventTriggerListener))

	arg0_15.eventTrigger:AddPointDownFunc(function()
		if arg0_15.useEventTriggerFlag then
			arg0_15:onPointDown()
		end
	end)
	arg0_15.eventTrigger:AddPointUpFunc(function()
		if arg0_15.useEventTriggerFlag then
			arg0_15:onPointUp()
		end
	end)
	arg0_15.liveCom:SetMouseInputActions(System.Action(function()
		if not arg0_15.useEventTriggerFlag then
			arg0_15:onPointDown()
		end
	end), System.Action(function()
		if not arg0_15.useEventTriggerFlag then
			arg0_15:onPointUp()
		end
	end))

	arg0_15.paraRanges = ReflectionHelp.RefGetField(typeof(Live2dChar), "paraRanges", arg0_15.liveCom)
	arg0_15.destinations = {}

	local var6_15 = ReflectionHelp.RefGetProperty(typeof(Live2dChar), "Destinations", arg0_15.liveCom)

	for iter5_15 = 0, var6_15.Length - 1 do
		local var7_15 = var6_15[iter5_15]

		table.insert(arg0_15.destinations, var6_15[iter5_15])
	end

	arg0_15.timer = Timer.New(function()
		var12_0(arg0_15)
	end, 0.0333333333333333, -1)

	arg0_15.timer:Start()
	var12_0(arg0_15)
end

function var0_0.onPointDown(arg0_22)
	if not arg0_22._l2dCharEnable then
		return
	end

	arg0_22.mouseInputDown = true

	if #arg0_22.drags > 0 and arg0_22.liveCom:GetDragPart() > 0 then
		local var0_22 = arg0_22.liveCom:GetDragPart()
		local var1_22 = arg0_22.dragParts[var0_22]

		if var0_22 > 0 and var1_22 then
			for iter0_22, iter1_22 in ipairs(arg0_22.drags) do
				if iter1_22.drawAbleName == var1_22 then
					iter1_22:startDrag()
				end
			end
		end
	end
end

function var0_0.onPointUp(arg0_23)
	if not arg0_23._l2dCharEnable then
		return
	end

	arg0_23.mouseInputDown = false

	if arg0_23.drags and #arg0_23.drags > 0 then
		local var0_23 = arg0_23.liveCom:GetDragPart()

		if var0_23 > 0 then
			local var1_23 = arg0_23.dragParts[var0_23]
		end

		for iter0_23 = 1, #arg0_23.drags do
			arg0_23.drags[iter0_23]:stopDrag()
		end
	end
end

function var0_0.changeTriggerFlag(arg0_24, arg1_24)
	arg0_24.useEventTriggerFlag = arg1_24
end

local function var14_0(arg0_25, arg1_25)
	arg0_25._go = arg1_25
	arg0_25._tf = tf(arg1_25)

	UIUtil.SetLayerRecursively(arg0_25._go, LayerMask.NameToLayer("UI"))
	arg0_25._tf:SetParent(arg0_25.live2dData.parent, true)

	arg0_25._tf.localScale = arg0_25.live2dData.scale
	arg0_25._tf.localPosition = arg0_25.live2dData.position
	arg0_25.liveCom = arg1_25:GetComponent(typeof(Live2dChar))
	arg0_25._animator = arg1_25:GetComponent(typeof(Animator))
	arg0_25.animationClipNames = {}

	if arg0_25._animator and arg0_25._animator.runtimeAnimatorController then
		local var0_25 = arg0_25._animator.runtimeAnimatorController.animationClips
		local var1_25 = var0_25.Length

		for iter0_25 = 0, var1_25 - 1 do
			table.insert(arg0_25.animationClipNames, var0_25[iter0_25].name)
		end
	end

	local var2_25 = var1_0.action2Id.idle

	arg0_25.liveCom:SetReactMotions(var1_0.idleActions)
	arg0_25.liveCom:SetAction(var2_25)

	function arg0_25.liveCom.FinishAction(arg0_26)
		arg0_25:live2dActionChange(false)

		if arg0_25.finishActionCB then
			arg0_25.finishActionCB()

			arg0_25.finishActionCB = nil
		end

		arg0_25.liveCom:SetAction(var1_0.idleActions[math.ceil(math.random(#var1_0.idleActions))])
	end

	function arg0_25.liveCom.EventAction(arg0_27)
		if arg0_25.animEventCB then
			arg0_25.animEventCB(arg0_27)

			arg0_25.animEventCB = nil
		end
	end

	arg0_25.liveCom:SetTouchParts(var1_0.assistantTouchParts)

	if arg0_25.live2dData and arg0_25.live2dData.ship and arg0_25.live2dData.ship.propose then
		arg0_25:changeParamaterValue("Paramring", 1)
	else
		arg0_25:changeParamaterValue("Paramring", 0)
	end

	if not arg0_25._physics then
		arg0_25._physics = GetComponent(arg0_25._tf, "CubismPhysicsController")
	end

	if arg0_25._physics then
		arg0_25._physics.enabled = false
		arg0_25._physics.enabled = true
	end

	if arg0_25.live2dData.l2dDragRate and #arg0_25.live2dData.l2dDragRate > 0 then
		arg0_25.liveCom.DragRateX = arg0_25.live2dData.l2dDragRate[1] * var2_0
		arg0_25.liveCom.DragRateY = arg0_25.live2dData.l2dDragRate[2] * var3_0
		arg0_25.liveCom.DampingTime = arg0_25.live2dData.l2dDragRate[3] * var4_0
	end

	var6_0(arg0_25)
	var7_0(arg0_25)
	var10_0(arg0_25)

	if arg0_25.live2dData.shipL2dId and #arg0_25.live2dData.shipL2dId > 0 then
		var13_0(arg0_25)
	end

	arg0_25:addKeyBoard()

	arg0_25.state = var0_0.STATE_INITED

	if arg0_25.delayChangeParamater and #arg0_25.delayChangeParamater > 0 then
		for iter1_25 = 1, #arg0_25.delayChangeParamater do
			local var3_25 = arg0_25.delayChangeParamater[iter1_25]

			arg0_25:changeParamaterValue(var3_25[1], var3_25[2])
		end

		arg0_25.delayChangeParamater = nil
	end

	arg0_25.enablePlayActions = {}
	arg0_25.ignorePlayActions = {}

	arg0_25:changeIdleIndex(0)
	arg0_25:loadLive2dData()
end

function var0_0.Ctor(arg0_28, arg1_28, arg2_28)
	arg0_28.state = var0_0.STATE_LOADING
	arg0_28.live2dData = arg1_28
	var1_0 = pg.AssistantInfo

	assert(not arg0_28.live2dData:isEmpty())

	local var0_28 = arg0_28.live2dData:GetShipName()

	local function var1_28(arg0_29)
		var14_0(arg0_28, arg0_29)

		if arg2_28 then
			arg2_28(arg0_28)
		end
	end

	arg0_28.live2dRequestId = pg.Live2DMgr.GetInstance():GetLive2DModelAsync(var0_28, var1_28)
	Input.gyro.enabled = arg0_28.live2dData.gyro == 1 and PlayerPrefs.GetInt(GYRO_ENABLE, 1) == 1
	arg0_28.useEventTriggerFlag = true
end

function var0_0.setStopCallback(arg0_30, arg1_30)
	arg0_30._stopCallback = arg1_30
end

function var0_0.SetVisible(arg0_31, arg1_31)
	if not arg0_31:IsLoaded() then
		return
	end

	Input.gyro.enabled = PlayerPrefs.GetInt(GYRO_ENABLE, 1) == 1

	arg0_31:setReactPos(true)
	arg0_31:Reset()

	if arg1_31 then
		arg0_31._readlyToStop = false

		onDelayTick(function()
			if not arg0_31._readlyToStop then
				if arg0_31._physics then
					arg0_31._physics.enabled = false
					arg0_31._physics.enabled = true
				end

				arg0_31:setReactPos(false)
			end
		end, 1)
	else
		var9_0(arg0_31, "idle", true)

		arg0_31._readlyToStop = true

		onDelayTick(function()
			if arg0_31._readlyToStop then
				arg0_31._animator.speed = 0

				if arg0_31._stopCallback then
					arg0_31._stopCallback()
				end
			end
		end, 3)
	end

	if arg1_31 then
		arg0_31:loadLive2dData()
	else
		arg0_31:saveLive2dData()
	end

	arg0_31._animator.speed = 1
end

function var0_0.loadLive2dData(arg0_34)
	if not arg0_34.live2dData.loadPrefs then
		return
	end

	if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and not arg0_34.live2dData.spineUseLive2d then
		if arg0_34.drags then
			for iter0_34 = 1, #arg0_34.drags do
				arg0_34.drags[iter0_34]:clearData()
			end
		end

		arg0_34:changeIdleIndex(0)
		arg0_34._animator:Play("idle")

		arg0_34.saveActionAbleId = nil

		var12_0(arg0_34)

		return
	end

	local var0_34, var1_34 = Live2dConst.GetL2dSaveData(arg0_34.live2dData:GetShipSkinConfig().id, arg0_34.live2dData.ship.id)

	if var0_34 then
		arg0_34:changeIdleIndex(var0_34)

		if var0_34 == 0 then
			arg0_34._animator:Play("idle")
		else
			arg0_34._animator:Play("idle" .. var0_34)
		end
	end

	arg0_34.saveActionAbleId = var1_34

	if var1_34 and var1_34 > 0 then
		if pg.ship_l2d[var1_34] then
			local var2_34 = pg.ship_l2d[var1_34].action_trigger_active

			arg0_34.enablePlayActions = var2_34.enable
			arg0_34.ignorePlayActions = var2_34.ignore
		end
	else
		arg0_34.enablePlayActions = {}
		arg0_34.ignorePlayActions = {}
	end

	if arg0_34.drags then
		for iter1_34 = 1, #arg0_34.drags do
			arg0_34.drags[iter1_34]:loadData()
		end
	end

	var12_0(arg0_34)
end

function var0_0.saveLive2dData(arg0_35)
	if not arg0_35.live2dData.loadPrefs then
		return
	end

	if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and not arg0_35.live2dData.spineUseLive2d then
		return
	end

	if arg0_35.idleIndex then
		Live2dConst.SaveL2dIdle(arg0_35.live2dData:GetShipSkinConfig().id, arg0_35.live2dData.ship.id, arg0_35.idleIndex)
	end

	if arg0_35.saveActionAbleId then
		if arg0_35.idleIndex == 0 then
			Live2dConst.SaveL2dAction(arg0_35.live2dData:GetShipSkinConfig().id, arg0_35.live2dData.ship.id, 0)
		else
			Live2dConst.SaveL2dAction(arg0_35.live2dData:GetShipSkinConfig().id, arg0_35.live2dData.ship.id, arg0_35.saveActionAbleId)
		end
	end

	if arg0_35.drags then
		for iter0_35 = 1, #arg0_35.drags do
			arg0_35.drags[iter0_35]:saveData()
		end
	end
end

function var0_0.enablePlayAction(arg0_36, arg1_36)
	return var8_0(arg0_36, arg1_36)
end

function var0_0.IgonreReactPos(arg0_37, arg1_37)
	arg0_37:setReactPos(arg1_37)
end

function var0_0.setReactPos(arg0_38, arg1_38)
	if arg0_38.liveCom then
		arg0_38.ignoreReact = arg1_38

		arg0_38.liveCom:IgonreReactPos(arg1_38)

		if arg1_38 then
			ReflectionHelp.RefSetField(typeof(Live2dChar), "inDrag", arg0_38.liveCom, false)
		end

		ReflectionHelp.RefSetField(typeof(Live2dChar), "reactPos", arg0_38.liveCom, Vector3(0, 0, 0))
		arg0_38:updateDragsSateData()
	end
end

function var0_0.l2dCharEnable(arg0_39, arg1_39)
	arg0_39._l2dCharEnable = arg1_39
end

function var0_0.inShopPreView(arg0_40, arg1_40)
	arg0_40._shopPreView = arg1_40
end

function var0_0.getDragEnable(arg0_41, arg1_41)
	if arg0_41._shopPreView and arg1_41.shop_action == 0 then
		return false
	end

	return true
end

function var0_0.updateShip(arg0_42, arg1_42)
	if arg1_42 and arg0_42.live2dData and arg0_42.live2dData.ship then
		arg0_42.live2dData.ship = arg1_42

		if arg0_42.live2dData and arg0_42.live2dData.ship and arg0_42.live2dData.ship.propose then
			arg0_42:changeParamaterValue("Paramring", 1)
		else
			arg0_42:changeParamaterValue("Paramring", 0)
		end
	end
end

function var0_0.IsLoaded(arg0_43)
	return arg0_43.state == var0_0.STATE_INITED
end

function var0_0.GetTouchPart(arg0_44)
	return arg0_44.liveCom:GetTouchPart()
end

function var0_0.TriggerAction(arg0_45, arg1_45, arg2_45, arg3_45, arg4_45)
	arg0_45:CheckStopDrag()

	arg0_45.finishActionCB = arg2_45
	arg0_45.animEventCB = arg4_45

	if not var9_0(arg0_45, arg1_45, arg3_45) and arg0_45.animEventCB then
		arg0_45.animEventCB(false)

		arg0_45.animEventCB = nil
	end
end

function var0_0.Reset(arg0_46)
	arg0_46:live2dActionChange(false)

	arg0_46.enablePlayActions = {}
	arg0_46.ignorePlayActions = {}
	arg0_46.ableFlag = nil
end

function var0_0.resetL2dData(arg0_47)
	if not arg0_47._tf then
		return
	end

	if arg0_47._tf and LeanTween.isTweening(go(arg0_47._tf)) then
		return
	end

	arg0_47._l2dPosition = arg0_47._tf.position
	arg0_47._tf.position = Vector3(arg0_47._l2dPosition.x + 100, 0, 0)

	LeanTween.delayedCall(go(arg0_47._tf), 0.2, System.Action(function()
		if arg0_47._tf then
			arg0_47._tf.position = arg0_47._l2dPosition
		end
	end))
	Live2dConst.ClearLive2dSave(arg0_47.live2dData.ship.skinId, arg0_47.live2dData.ship.id)
	arg0_47:Reset()
	arg0_47:changeIdleIndex(0)
	arg0_47:loadLive2dData()
end

function var0_0.applyActiveData(arg0_49, arg1_49, arg2_49)
	local var0_49 = arg2_49.enable
	local var1_49 = arg2_49.ignore
	local var2_49 = arg2_49.idle
	local var3_49 = arg2_49.repeatFlag

	if var0_49 and #var0_49 >= 0 then
		arg0_49.enablePlayActions = var0_49
	end

	if var1_49 and #var1_49 >= 0 then
		arg0_49.ignorePlayActions = var1_49
	end

	if var2_49 ~= arg0_49.indexIndex then
		arg0_49.saveActionAbleId = arg1_49.id
	end

	if var2_49 then
		local var4_49

		if type(var2_49) == "number" and var2_49 >= 0 then
			var4_49 = var2_49
		elseif type(var2_49) == "table" then
			local var5_49 = {}

			for iter0_49, iter1_49 in ipairs(var2_49) do
				if iter1_49 == arg0_49.idleIndex then
					if var3_49 then
						table.insert(var5_49, iter1_49)
					end
				else
					table.insert(var5_49, iter1_49)
				end
			end

			var4_49 = var5_49[math.random(1, #var5_49)]
		end

		if var4_49 then
			arg0_49:changeIdleIndex(var4_49)
		end

		arg0_49:saveLive2dData()
	end
end

function var0_0.changeIdleIndex(arg0_50, arg1_50)
	if arg0_50.idleIndex ~= arg1_50 then
		arg0_50._animator:SetInteger("idle", arg1_50)
	end

	arg0_50.idleIndex = arg1_50

	arg0_50:updateDragsSateData()
end

function var0_0.live2dActionChange(arg0_51, arg1_51)
	arg0_51.isPlaying = arg1_51

	arg0_51:updateDragsSateData()
end

function var0_0.updateDragsSateData(arg0_52)
	local var0_52 = {
		idleIndex = arg0_52.idleIndex,
		isPlaying = arg0_52.isPlaying,
		ignoreReact = arg0_52.ignoreReact,
		actionName = arg0_52.playActionName
	}

	if arg0_52.drags then
		for iter0_52 = 1, #arg0_52.drags do
			arg0_52.drags[iter0_52]:updateStateData(var0_52)
		end
	end
end

function var0_0.CheckStopDrag(arg0_53)
	local var0_53 = arg0_53.live2dData:GetShipSkinConfig()

	if var0_53.l2d_ignore_drag and var0_53.l2d_ignore_drag == 1 then
		arg0_53.liveCom.ResponseClick = false

		ReflectionHelp.RefSetField(typeof(Live2dChar), "inDrag", arg0_53.liveCom, false)
	end
end

function var0_0.changeParamaterValue(arg0_54, arg1_54, arg2_54)
	if arg0_54:IsLoaded() then
		if not arg1_54 or string.len(arg1_54) == 0 then
			return
		end

		local var0_54 = arg0_54.liveCom:GetCubismParameter(arg1_54)

		if not var0_54 then
			return
		end

		arg0_54.liveCom:AddParameterValue(var0_54, arg2_54, var5_0[1])
	else
		if not arg0_54.delayChangeParamater then
			arg0_54.delayChangeParamater = {}
		end

		table.insert(arg0_54.delayChangeParamater, {
			arg1_54,
			arg2_54
		})
	end
end

function var0_0.Dispose(arg0_55)
	if arg0_55.state == var0_0.STATE_INITED then
		if arg0_55._go then
			Destroy(arg0_55._go)
		end

		arg0_55.liveCom.FinishAction = nil
		arg0_55.liveCom.EventAction = nil
	end

	arg0_55:saveLive2dData()
	arg0_55.liveCom:SetMouseInputActions(nil, nil)

	arg0_55._readlyToStop = false
	arg0_55.state = var0_0.STATE_DISPOSE

	pg.Live2DMgr.GetInstance():StopLoadingLive2d(arg0_55.live2dRequestId)

	arg0_55.live2dRequestId = nil

	if arg0_55.drags then
		for iter0_55 = 1, #arg0_55.drags do
			arg0_55.drags[iter0_55]:dispose()
		end

		arg0_55.drags = {}
	end

	if arg0_55.live2dData.gyro == 1 then
		Input.gyro.enabled = false
	end

	if arg0_55.live2dData then
		arg0_55.live2dData:Clear()

		arg0_55.live2dData = nil
	end

	arg0_55:live2dActionChange(false)

	if arg0_55.timer then
		arg0_55.timer:Stop()

		arg0_55.timer = nil
	end
end

function var0_0.UpdateAtomSource(arg0_56)
	arg0_56.updateAtom = true
end

function var0_0.AtomSouceFresh(arg0_57)
	local var0_57 = pg.CriMgr.GetInstance():getAtomSource(pg.CriMgr.C_VOICE)
	local var1_57 = arg0_57._go:GetComponent("CubismCriSrcMouthInput")
	local var2_57 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Framework.MouthMovement.CubismCriSrcMouthInput"), "Analyzer", var1_57)

	var0_57:AttachToAnalyzer(var2_57)

	if arg0_57.updateAtom then
		arg0_57.updateAtom = false
	end
end

function var0_0.addKeyBoard(arg0_58)
	return
end

return var0_0
