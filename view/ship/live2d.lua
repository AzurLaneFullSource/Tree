local var0 = class("Live2D")

var0.STATE_LOADING = 0
var0.STATE_INITED = 1
var0.STATE_DISPOSE = 2

local var1
local var2 = 5
local var3 = 3
local var4 = 0.3

var0.DRAG_TIME_ACTION = 1
var0.DRAG_CLICK_ACTION = 2
var0.DRAG_DOWN_ACTION = 3
var0.DRAG_RELATION_XY = 4
var0.DRAG_RELATION_IDLE = 5
var0.DRAG_CLICK_MANY = 6
var0.EVENT_ACTION_APPLY = "event action apply"
var0.EVENT_ACTION_ABLE = "event action able"
var0.EVENT_ADD_PARAMETER_COM = "event add parameter com "
var0.EVENT_REMOVE_PARAMETER_COM = "event remove parameter com "
var0.relation_type_drag_x = 101
var0.relation_type_drag_y = 102
var0.relation_type_action_index = 103

local var5 = {
	CubismParameterBlendMode.Override,
	CubismParameterBlendMode.Additive,
	CubismParameterBlendMode.Multiply
}

function var0.GenerateData(arg0)
	local var0 = {
		SetData = function(arg0, arg1)
			arg0.ship = arg1.ship
			arg0.parent = arg1.parent
			arg0.scale = arg1.scale

			local var0 = arg0:GetShipSkinConfig().live2d_offset

			arg0.gyro = arg0:GetShipSkinConfig().gyro or 0
			arg0.shipL2dId = arg0:GetShipSkinConfig().ship_l2d_id
			arg0.skinId = arg0:GetShipSkinConfig().id
			arg0.spineUseLive2d = false

			if arg0.skinId then
				arg0.spineUseLive2d = pg.ship_skin_template[arg0.skinId].spine_use_live2d == 1
			end

			arg0.position = arg1.position + BuildVector3(var0)
			arg0.l2dDragRate = arg0:GetShipSkinConfig().l2d_drag_rate
			arg0.loadPrefs = arg1.loadPrefs
		end,
		GetShipName = function(arg0)
			return arg0.ship:getPainting()
		end,
		GetShipSkinConfig = function(arg0)
			return arg0.ship:GetSkinConfig()
		end,
		isEmpty = function(arg0)
			return arg0.ship == nil
		end,
		Clear = function(arg0)
			arg0.ship = nil
			arg0.parent = nil
			arg0.scale = nil
			arg0.position = nil
		end
	}

	var0:SetData(arg0)

	return var0
end

local function var6(arg0)
	local var0 = arg0.live2dData:GetShipSkinConfig()
	local var1 = var0.lip_sync_gain
	local var2 = var0.lip_smoothing

	if var1 and var1 ~= 0 then
		arg0._go:GetComponent("CubismCriSrcMouthInput").Gain = var1
	end

	if var2 and var2 ~= 0 then
		arg0._go:GetComponent("CubismCriSrcMouthInput").Smoothing = var2
	end
end

local function var7(arg0)
	local var0 = arg0.live2dData:GetShipSkinConfig().l2d_para_range

	if var0 ~= nil and type(var0) == "table" then
		for iter0, iter1 in pairs(var0) do
			arg0.liveCom:SetParaRange(iter0, iter1)
		end
	end
end

local function var8(arg0, arg1)
	if not arg1 or arg1 == "" then
		return false
	end

	if arg0.enablePlayActions and #arg0.enablePlayActions > 0 and not table.contains(arg0.enablePlayActions, arg1) then
		return false
	end

	if arg0.ignorePlayActions and #arg0.ignorePlayActions > 0 and table.contains(arg0.ignorePlayActions, arg1) then
		return false
	end

	if arg0._readlyToStop then
		return false
	end

	return true
end

local function var9(arg0, arg1, arg2)
	if not var8(arg0, arg1) then
		return false
	end

	if arg0.updateAtom then
		arg0:AtomSouceFresh()
	end

	if arg0.animationClipNames then
		local var0 = arg0:checkActionExist(arg1)

		if (not var0 or var0 == false) and string.find(arg1, "main_") then
			arg1 = "main_3"
		end
	end

	if not arg0.isPlaying or arg2 then
		local var1 = var1.action2Id[arg1]

		if var1 then
			arg0.playActionName = arg1

			arg0.liveCom:SetAction(var1)
			arg0:live2dActionChange(true)

			return true
		else
			print(tostring(arg1) .. " action is not exist")
		end
	end

	return false
end

function var0.checkActionExist(arg0, arg1)
	return (table.indexof(arg0.animationClipNames, arg1))
end

local function var10(arg0, arg1)
	arg0.liveCom:SetCenterPart("Drawables/TouchHead", Vector3.zero)

	arg0.liveCom.DampingTime = 0.3
end

local function var11(arg0, arg1, arg2)
	if arg1 == Live2D.EVENT_ACTION_APPLY then
		local var0 = arg2.id
		local var1 = arg2.action
		local var2 = arg2.callback
		local var3 = arg2.activeData
		local var4 = arg2.focus
		local var5 = arg2.react

		if not var8(arg0, var1) then
			return
		end

		if var5 ~= nil then
			arg0:setReactPos(tobool(var5))
		end

		if var1 then
			var9(arg0, var1, var4 or false)
		end

		arg0:applyActiveData(arg2, var3)

		if var2 then
			var2()
		end
	elseif arg1 == Live2D.EVENT_ACTION_ABLE then
		if arg0.ableFlag ~= arg2.ableFlag then
			arg0.ableFlag = arg2.ableFlag

			if arg2.ableFlag then
				arg0.tempEnable = arg0.enablePlayActions
				arg0.enablePlayActions = {
					"none action apply"
				}
			else
				arg0.enablePlayActions = arg0.tempEnable
			end
		else
			print("able flag 相同，不执行操作")
		end

		if arg2.callback then
			arg2.callback()
		end
	elseif arg1 == Live2D.EVENT_ADD_PARAMETER_COM then
		arg0.liveCom:AddParameterValue(arg2.com, arg2.start, var5[arg2.mode])
	elseif arg1 == Live2D.EVENT_REMOVE_PARAMETER_COM then
		arg0.liveCom:removeParameterValue(arg2.com)
	end
end

local function var12(arg0)
	if not arg0._l2dCharEnable then
		return
	end

	if arg0._readlyToStop then
		return
	end

	local var0 = false
	local var1 = ReflectionHelp.RefGetField(typeof(Live2dChar), "reactPos", arg0.liveCom)

	for iter0 = 1, #arg0.drags do
		arg0.drags[iter0]:changeReactValue(var1)
		arg0.drags[iter0]:stepParameter()

		local var2 = arg0.drags[iter0]:getParameToTargetFlag()
		local var3 = arg0.drags[iter0]:getActive()

		if (var2 or var3) and arg0.drags[iter0]:getIgnoreReact() then
			var0 = true
		elseif arg0.drags[iter0]:getReactCondition() then
			var0 = true
		end

		local var4 = arg0.drags[iter0]:getParameter()
		local var5 = arg0.drags[iter0]:getParameterUpdateFlag()

		if var4 and var5 then
			local var6 = arg0.drags[iter0]:getParameterCom()

			if var6 then
				arg0.liveCom:ChangeParameterData(var6, var4)
			end
		end

		local var7 = arg0.drags[iter0]:getRelationParameterList()

		for iter1, iter2 in ipairs(var7) do
			if iter2.enable then
				arg0.liveCom:ChangeParameterData(iter2.com, iter2.value)
			end
		end
	end

	if var0 == arg0.ignoreReact or not var0 and (arg0.mouseInputDown or arg0.isPlaying) then
		-- block empty
	else
		arg0:setReactPos(var0)
	end
end

local function var13(arg0)
	arg0.drags = {}
	arg0.dragParts = {}

	for iter0 = 1, #var1.assistantTouchParts do
		table.insert(arg0.dragParts, var1.assistantTouchParts[iter0])
	end

	arg0._l2dCharEnable = true
	arg0._shopPreView = arg0.live2dData.shopPreView

	for iter1, iter2 in ipairs(arg0.live2dData.shipL2dId) do
		local var0 = pg.ship_l2d[iter2]

		if var0 and arg0:getDragEnable(var0) then
			local var1 = Live2dDrag.New(var0, arg0.live2dData)
			local var2 = arg0.liveCom:GetCubismParameter(var0.parameter)

			var1:setParameterCom(var2)
			var1:setEventCallback(function(arg0, arg1)
				var11(arg0, arg0, arg1)
			end)
			arg0.liveCom:AddParameterValue(var1.parameterName, var1.startValue, var5[var0.mode])

			if var0.relation_parameter and var0.relation_parameter.list then
				local var3 = var0.relation_parameter.list

				for iter3, iter4 in ipairs(var3) do
					local var4 = arg0.liveCom:GetCubismParameter(iter4.name)

					if var4 then
						var1:addRelationComData(var4, iter4)

						local var5 = iter4.mode or var0.mode

						arg0.liveCom:AddParameterValue(iter4.name, iter4.start or var1.startValue or 0, var5[var5])
					end
				end
			end

			table.insert(arg0.drags, var1)

			if not table.contains(arg0.dragParts, var1.drawAbleName) then
				table.insert(arg0.dragParts, var1.drawAbleName)
			end
		end
	end

	arg0.liveCom:SetDragParts(arg0.dragParts)

	arg0.eventTrigger = GetOrAddComponent(arg0.liveCom.transform.parent, typeof(EventTriggerListener))

	arg0.eventTrigger:AddPointDownFunc(function()
		if arg0.useEventTriggerFlag then
			arg0:onPointDown()
		end
	end)
	arg0.eventTrigger:AddPointUpFunc(function()
		if arg0.useEventTriggerFlag then
			arg0:onPointUp()
		end
	end)
	arg0.liveCom:SetMouseInputActions(System.Action(function()
		if not arg0.useEventTriggerFlag then
			arg0:onPointDown()
		end
	end), System.Action(function()
		if not arg0.useEventTriggerFlag then
			arg0:onPointUp()
		end
	end))

	arg0.paraRanges = ReflectionHelp.RefGetField(typeof(Live2dChar), "paraRanges", arg0.liveCom)
	arg0.destinations = {}

	local var6 = ReflectionHelp.RefGetProperty(typeof(Live2dChar), "Destinations", arg0.liveCom)

	for iter5 = 0, var6.Length - 1 do
		local var7 = var6[iter5]

		table.insert(arg0.destinations, var6[iter5])
	end

	arg0.timer = Timer.New(function()
		var12(arg0)
	end, 0.0333333333333333, -1)

	arg0.timer:Start()
	var12(arg0)
end

function var0.onPointDown(arg0)
	if not arg0._l2dCharEnable then
		return
	end

	arg0.mouseInputDown = true

	if #arg0.drags > 0 and arg0.liveCom:GetDragPart() > 0 then
		local var0 = arg0.liveCom:GetDragPart()
		local var1 = arg0.dragParts[var0]

		if var0 > 0 and var1 then
			for iter0, iter1 in ipairs(arg0.drags) do
				if iter1.drawAbleName == var1 then
					iter1:startDrag()
				end
			end
		end
	end
end

function var0.onPointUp(arg0)
	if not arg0._l2dCharEnable then
		return
	end

	arg0.mouseInputDown = false

	if arg0.drags and #arg0.drags > 0 then
		local var0 = arg0.liveCom:GetDragPart()

		if var0 > 0 then
			local var1 = arg0.dragParts[var0]
		end

		for iter0 = 1, #arg0.drags do
			arg0.drags[iter0]:stopDrag()
		end
	end
end

function var0.changeTriggerFlag(arg0, arg1)
	arg0.useEventTriggerFlag = arg1
end

local function var14(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)

	UIUtil.SetLayerRecursively(arg0._go, LayerMask.NameToLayer("UI"))
	arg0._tf:SetParent(arg0.live2dData.parent, true)

	arg0._tf.localScale = arg0.live2dData.scale
	arg0._tf.localPosition = arg0.live2dData.position
	arg0.liveCom = arg1:GetComponent(typeof(Live2dChar))
	arg0._animator = arg1:GetComponent(typeof(Animator))
	arg0.animationClipNames = {}

	if arg0._animator and arg0._animator.runtimeAnimatorController then
		local var0 = arg0._animator.runtimeAnimatorController.animationClips
		local var1 = var0.Length

		for iter0 = 0, var1 - 1 do
			table.insert(arg0.animationClipNames, var0[iter0].name)
		end
	end

	local var2 = var1.action2Id.idle

	arg0.liveCom:SetReactMotions(var1.idleActions)
	arg0.liveCom:SetAction(var2)

	function arg0.liveCom.FinishAction(arg0)
		arg0:live2dActionChange(false)

		if arg0.finishActionCB then
			arg0.finishActionCB()

			arg0.finishActionCB = nil
		end

		arg0.liveCom:SetAction(var1.idleActions[math.ceil(math.random(#var1.idleActions))])
	end

	function arg0.liveCom.EventAction(arg0)
		if arg0.animEventCB then
			arg0.animEventCB(arg0)

			arg0.animEventCB = nil
		end
	end

	arg0.liveCom:SetTouchParts(var1.assistantTouchParts)

	if arg0.live2dData and arg0.live2dData.ship and arg0.live2dData.ship.propose then
		arg0:changeParamaterValue("Paramring", 1)
	else
		arg0:changeParamaterValue("Paramring", 0)
	end

	if not arg0._physics then
		arg0._physics = GetComponent(arg0._tf, "CubismPhysicsController")
	end

	if arg0._physics then
		arg0._physics.enabled = false
		arg0._physics.enabled = true
	end

	if arg0.live2dData.l2dDragRate and #arg0.live2dData.l2dDragRate > 0 then
		arg0.liveCom.DragRateX = arg0.live2dData.l2dDragRate[1] * var2
		arg0.liveCom.DragRateY = arg0.live2dData.l2dDragRate[2] * var3
		arg0.liveCom.DampingTime = arg0.live2dData.l2dDragRate[3] * var4
	end

	var6(arg0)
	var7(arg0)
	var10(arg0)

	if arg0.live2dData.shipL2dId and #arg0.live2dData.shipL2dId > 0 then
		var13(arg0)
	end

	arg0:addKeyBoard()

	arg0.state = var0.STATE_INITED

	if arg0.delayChangeParamater and #arg0.delayChangeParamater > 0 then
		for iter1 = 1, #arg0.delayChangeParamater do
			local var3 = arg0.delayChangeParamater[iter1]

			arg0:changeParamaterValue(var3[1], var3[2])
		end

		arg0.delayChangeParamater = nil
	end

	arg0.enablePlayActions = {}
	arg0.ignorePlayActions = {}

	arg0:changeIdleIndex(0)
	arg0:loadLive2dData()
end

function var0.Ctor(arg0, arg1, arg2)
	arg0.state = var0.STATE_LOADING
	arg0.live2dData = arg1
	var1 = pg.AssistantInfo

	assert(not arg0.live2dData:isEmpty())

	local var0 = arg0.live2dData:GetShipName()

	local function var1(arg0)
		var14(arg0, arg0)

		if arg2 then
			arg2(arg0)
		end
	end

	arg0.live2dRequestId = pg.Live2DMgr.GetInstance():GetLive2DModelAsync(var0, var1)
	Input.gyro.enabled = arg0.live2dData.gyro == 1 and PlayerPrefs.GetInt(GYRO_ENABLE, 1) == 1
	arg0.useEventTriggerFlag = true
end

function var0.setStopCallback(arg0, arg1)
	arg0._stopCallback = arg1
end

function var0.SetVisible(arg0, arg1)
	if not arg0:IsLoaded() then
		return
	end

	Input.gyro.enabled = PlayerPrefs.GetInt(GYRO_ENABLE, 1) == 1

	arg0:setReactPos(true)
	arg0:Reset()

	if arg1 then
		arg0._readlyToStop = false

		onDelayTick(function()
			if not arg0._readlyToStop then
				if arg0._physics then
					arg0._physics.enabled = false
					arg0._physics.enabled = true
				end

				arg0:setReactPos(false)
			end
		end, 1)
	else
		var9(arg0, "idle", true)

		arg0._readlyToStop = true

		onDelayTick(function()
			if arg0._readlyToStop then
				arg0._animator.speed = 0

				if arg0._stopCallback then
					arg0._stopCallback()
				end
			end
		end, 3)
	end

	if arg1 then
		arg0:loadLive2dData()
	else
		arg0:saveLive2dData()
	end

	arg0._animator.speed = 1
end

function var0.loadLive2dData(arg0)
	if not arg0.live2dData.loadPrefs then
		return
	end

	if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and not arg0.live2dData.spineUseLive2d then
		if arg0.drags then
			for iter0 = 1, #arg0.drags do
				arg0.drags[iter0]:clearData()
			end
		end

		arg0:changeIdleIndex(0)
		arg0._animator:Play("idle")

		arg0.saveActionAbleId = nil

		var12(arg0)

		return
	end

	local var0, var1 = Live2dConst.GetL2dSaveData(arg0.live2dData:GetShipSkinConfig().id, arg0.live2dData.ship.id)

	if var0 then
		arg0:changeIdleIndex(var0)

		if var0 == 0 then
			arg0._animator:Play("idle")
		else
			arg0._animator:Play("idle" .. var0)
		end
	end

	arg0.saveActionAbleId = var1

	if var1 and var1 > 0 then
		if pg.ship_l2d[var1] then
			local var2 = pg.ship_l2d[var1].action_trigger_active

			arg0.enablePlayActions = var2.enable
			arg0.ignorePlayActions = var2.ignore
		end
	else
		arg0.enablePlayActions = {}
		arg0.ignorePlayActions = {}
	end

	if arg0.drags then
		for iter1 = 1, #arg0.drags do
			arg0.drags[iter1]:loadData()
		end
	end

	var12(arg0)
end

function var0.saveLive2dData(arg0)
	if not arg0.live2dData.loadPrefs then
		return
	end

	if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and not arg0.live2dData.spineUseLive2d then
		return
	end

	if arg0.idleIndex then
		Live2dConst.SaveL2dIdle(arg0.live2dData:GetShipSkinConfig().id, arg0.live2dData.ship.id, arg0.idleIndex)
	end

	if arg0.saveActionAbleId then
		if arg0.idleIndex == 0 then
			Live2dConst.SaveL2dAction(arg0.live2dData:GetShipSkinConfig().id, arg0.live2dData.ship.id, 0)
		else
			Live2dConst.SaveL2dAction(arg0.live2dData:GetShipSkinConfig().id, arg0.live2dData.ship.id, arg0.saveActionAbleId)
		end
	end

	if arg0.drags then
		for iter0 = 1, #arg0.drags do
			arg0.drags[iter0]:saveData()
		end
	end
end

function var0.enablePlayAction(arg0, arg1)
	return var8(arg0, arg1)
end

function var0.IgonreReactPos(arg0, arg1)
	arg0:setReactPos(arg1)
end

function var0.setReactPos(arg0, arg1)
	if arg0.liveCom then
		arg0.ignoreReact = arg1

		arg0.liveCom:IgonreReactPos(arg1)

		if arg1 then
			ReflectionHelp.RefSetField(typeof(Live2dChar), "inDrag", arg0.liveCom, false)
		end

		ReflectionHelp.RefSetField(typeof(Live2dChar), "reactPos", arg0.liveCom, Vector3(0, 0, 0))
		arg0:updateDragsSateData()
	end
end

function var0.l2dCharEnable(arg0, arg1)
	arg0._l2dCharEnable = arg1
end

function var0.inShopPreView(arg0, arg1)
	arg0._shopPreView = arg1
end

function var0.getDragEnable(arg0, arg1)
	if arg0._shopPreView and arg1.shop_action == 0 then
		return false
	end

	return true
end

function var0.updateShip(arg0, arg1)
	if arg1 and arg0.live2dData and arg0.live2dData.ship then
		arg0.live2dData.ship = arg1

		if arg0.live2dData and arg0.live2dData.ship and arg0.live2dData.ship.propose then
			arg0:changeParamaterValue("Paramring", 1)
		else
			arg0:changeParamaterValue("Paramring", 0)
		end
	end
end

function var0.IsLoaded(arg0)
	return arg0.state == var0.STATE_INITED
end

function var0.GetTouchPart(arg0)
	return arg0.liveCom:GetTouchPart()
end

function var0.TriggerAction(arg0, arg1, arg2, arg3, arg4)
	arg0:CheckStopDrag()

	arg0.finishActionCB = arg2
	arg0.animEventCB = arg4

	if not var9(arg0, arg1, arg3) and arg0.animEventCB then
		arg0.animEventCB(false)

		arg0.animEventCB = nil
	end
end

function var0.Reset(arg0)
	arg0:live2dActionChange(false)

	arg0.enablePlayActions = {}
	arg0.ignorePlayActions = {}
	arg0.ableFlag = nil
end

function var0.resetL2dData(arg0)
	if not arg0._tf then
		return
	end

	if arg0._tf and LeanTween.isTweening(go(arg0._tf)) then
		return
	end

	arg0._l2dPosition = arg0._tf.position
	arg0._tf.position = Vector3(arg0._l2dPosition.x + 100, 0, 0)

	LeanTween.delayedCall(go(arg0._tf), 0.2, System.Action(function()
		if arg0._tf then
			arg0._tf.position = arg0._l2dPosition
		end
	end))
	Live2dConst.ClearLive2dSave(arg0.live2dData.ship.skinId, arg0.live2dData.ship.id)
	arg0:Reset()
	arg0:changeIdleIndex(0)
	arg0:loadLive2dData()
end

function var0.applyActiveData(arg0, arg1, arg2)
	local var0 = arg2.enable
	local var1 = arg2.ignore
	local var2 = arg2.idle
	local var3 = arg2.repeatFlag

	if var0 and #var0 >= 0 then
		arg0.enablePlayActions = var0
	end

	if var1 and #var1 >= 0 then
		arg0.ignorePlayActions = var1
	end

	if var2 ~= arg0.indexIndex then
		arg0.saveActionAbleId = arg1.id
	end

	if var2 then
		local var4

		if type(var2) == "number" and var2 >= 0 then
			var4 = var2
		elseif type(var2) == "table" then
			local var5 = {}

			for iter0, iter1 in ipairs(var2) do
				if iter1 == arg0.idleIndex then
					if var3 then
						table.insert(var5, iter1)
					end
				else
					table.insert(var5, iter1)
				end
			end

			var4 = var5[math.random(1, #var5)]
		end

		if var4 then
			arg0:changeIdleIndex(var4)
		end

		arg0:saveLive2dData()
	end
end

function var0.changeIdleIndex(arg0, arg1)
	if arg0.idleIndex ~= arg1 then
		arg0._animator:SetInteger("idle", arg1)
	end

	arg0.idleIndex = arg1

	arg0:updateDragsSateData()
end

function var0.live2dActionChange(arg0, arg1)
	arg0.isPlaying = arg1

	arg0:updateDragsSateData()
end

function var0.updateDragsSateData(arg0)
	local var0 = {
		idleIndex = arg0.idleIndex,
		isPlaying = arg0.isPlaying,
		ignoreReact = arg0.ignoreReact,
		actionName = arg0.playActionName
	}

	if arg0.drags then
		for iter0 = 1, #arg0.drags do
			arg0.drags[iter0]:updateStateData(var0)
		end
	end
end

function var0.CheckStopDrag(arg0)
	local var0 = arg0.live2dData:GetShipSkinConfig()

	if var0.l2d_ignore_drag and var0.l2d_ignore_drag == 1 then
		arg0.liveCom.ResponseClick = false

		ReflectionHelp.RefSetField(typeof(Live2dChar), "inDrag", arg0.liveCom, false)
	end
end

function var0.changeParamaterValue(arg0, arg1, arg2)
	if arg0:IsLoaded() then
		if not arg1 or string.len(arg1) == 0 then
			return
		end

		local var0 = arg0.liveCom:GetCubismParameter(arg1)

		if not var0 then
			return
		end

		arg0.liveCom:AddParameterValue(var0, arg2, var5[1])
	else
		if not arg0.delayChangeParamater then
			arg0.delayChangeParamater = {}
		end

		table.insert(arg0.delayChangeParamater, {
			arg1,
			arg2
		})
	end
end

function var0.Dispose(arg0)
	if arg0.state == var0.STATE_INITED then
		if arg0._go then
			Destroy(arg0._go)
		end

		arg0.liveCom.FinishAction = nil
		arg0.liveCom.EventAction = nil
	end

	arg0:saveLive2dData()
	arg0.liveCom:SetMouseInputActions(nil, nil)

	arg0._readlyToStop = false
	arg0.state = var0.STATE_DISPOSE

	pg.Live2DMgr.GetInstance():StopLoadingLive2d(arg0.live2dRequestId)

	arg0.live2dRequestId = nil

	if arg0.drags then
		for iter0 = 1, #arg0.drags do
			arg0.drags[iter0]:dispose()
		end

		arg0.drags = {}
	end

	if arg0.live2dData.gyro == 1 then
		Input.gyro.enabled = false
	end

	if arg0.live2dData then
		arg0.live2dData:Clear()

		arg0.live2dData = nil
	end

	arg0:live2dActionChange(false)

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.UpdateAtomSource(arg0)
	arg0.updateAtom = true
end

function var0.AtomSouceFresh(arg0)
	local var0 = pg.CriMgr.GetInstance():getAtomSource(pg.CriMgr.C_VOICE)
	local var1 = arg0._go:GetComponent("CubismCriSrcMouthInput")
	local var2 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Framework.MouthMovement.CubismCriSrcMouthInput"), "Analyzer", var1)

	var0:AttachToAnalyzer(var2)

	if arg0.updateAtom then
		arg0.updateAtom = false
	end
end

function var0.addKeyBoard(arg0)
	return
end

return var0
