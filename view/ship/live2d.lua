local var0_0 = class("Live2D")

var0_0.STATE_LOADING = 0
var0_0.STATE_INITED = 1
var0_0.STATE_DISPOSE = 2

local var1_0 = {
	"button",
	"vocal",
	"interaction"
}
local var2_0 = {
	"button",
	"interaction"
}
local var3_0 = {
	button = {
		sheet_name = "se-SkinButton"
	},
	vocal = {
		sheet_name = "",
		cv_voice = true
	},
	interaction = {
		sheet_name = "se-SkinInteractive"
	}
}

var0_0.COMMON_XIAQI_RESULT = "xiaqi_result"

local var4_0
local var5_0 = 5
local var6_0 = 3
local var7_0 = 0.3

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
var0_0.DRAG_WITH_PARAMETER_MOVE = 13
var0_0.DRAG_MOVE_DOWN_UP = 14
var0_0.DRAG_GAME_XIAQI = 15
var0_0.DRAG_GAME_XIAQI_RESULT = 16
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

local var8_0 = {
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
var0_0.EVENT_GAME_XIAQI = "event game xiaqi"
var0_0.relation_type_drag_x = 101
var0_0.relation_type_drag_y = 102
var0_0.relation_type_action_index = 103
var0_0.relation_type_idle = 104

local var9_0 = {
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

local function var10_0(arg0_7)
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

local function var11_0(arg0_8)
	local var0_8 = arg0_8.live2dData:GetShipSkinConfig().l2d_para_range

	if var0_8 ~= nil and type(var0_8) == "table" then
		for iter0_8, iter1_8 in pairs(var0_8) do
			arg0_8.liveCom:SetParaRange(iter0_8, iter1_8)
		end
	end
end

local function var12_0(arg0_9)
	return not arg0_9._readlyToStop
end

local function var13_0(arg0_10, arg1_10)
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

	if not var12_0(arg0_10) then
		return false
	end

	return true
end

local function var14_0(arg0_11, arg1_11, arg2_11)
	if not var13_0(arg0_11, arg1_11) then
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
		local var1_11 = var4_0.action2Id[arg1_11]

		if var1_11 then
			arg0_11.playActionName = arg1_11

			arg0_11.liveCom:SetAction(var1_11)

			if arg1_11 == "idle" then
				arg0_11:live2dActionChange(false)
			else
				if arg0_11._animator.speed ~= 1 then
					arg0_11:resumeSpeed()
				end

				arg0_11:live2dActionChange(true)
			end

			return true
		else
			print(tostring(arg1_11) .. " action is not exist")
		end
	end

	return false
end

local function var15_0(arg0_12, arg1_12)
	arg0_12.liveCom:SetCenterPart("Drawables/TouchHead", Vector3.zero)

	arg0_12.liveCom.DampingTime = 0.3
end

local function var16_0(arg0_13, arg1_13, arg2_13)
	if table.contains(Live2D.NOTICE_ACTION_LIST, arg1_13) then
		arg0_13:onListenerHandle(arg1_13, arg2_13)
	end
end

local function var17_0(arg0_14, arg1_14, arg2_14)
	if arg1_14 == Live2D.EVENT_ACTION_APPLY then
		local var0_14 = arg2_14.id
		local var1_14 = arg2_14.action
		local var2_14 = arg2_14.callback
		local var3_14 = arg2_14.finishCall
		local var4_14 = arg2_14.activeData
		local var5_14 = arg2_14.focus
		local var6_14 = arg2_14.react
		local var7_14 = var4_14.idle_focus
		local var8_14 = var12_0(arg0_14)
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

			var9_14 = var14_0(arg0_14, var1_14, var5_14 or false)

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
		arg0_14.liveCom:AddParameterValue(arg2_14.com, arg2_14.start, var9_0[arg2_14.mode])
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
	elseif arg1_14 == Live2D.EVENT_GAME_XIAQI then
		if arg0_14.xiaqiLimitTime and Time.realtimeSinceStartup - arg0_14.xiaqiLimitTime <= 1 then
			return
		end

		arg0_14.xiaqiLimitTime = Time.realtimeSinceStartup

		if Live2DExtend.CheckXiaQiFirst(arg0_14) and arg2_14.parameter_value == 0 and arg2_14.callback then
			arg2_14.callback({
				target = 1
			})
		end

		local var15_14, var16_14 = Live2DExtend.CheckXiaQiFinish(arg0_14)

		if var15_14 then
			onDelayTick(function()
				arg0_14:setDragCommonData(var0_0.COMMON_XIAQI_RESULT, var16_14)
			end, 0.5)

			return
		end

		if Live2DExtend.CheckXiaQiLast(arg0_14) then
			local var17_14 = Live2DExtend.GetXiaQiLastDrag(arg0_14)

			if var17_14 then
				var17_14:setTargetValueDelay(-1, 0.2)
			end
		end

		local var18_14, var19_14 = Live2DExtend.CheckXiaQiFinish(arg0_14)

		if var18_14 then
			onDelayTick(function()
				arg0_14:setDragCommonData(var0_0.COMMON_XIAQI_RESULT, var19_14)
			end, 0.5)

			return
		end
	end
end

function var0_0.setDragCommonData(arg0_17, arg1_17, arg2_17)
	arg0_17.dragCommonData[arg1_17] = arg2_17
end

function var0_0.getDragCommonData(arg0_18, arg1_18)
	return
end

local function var18_0(arg0_19, arg1_19)
	if not arg0_19._l2dCharEnable then
		return
	end

	if arg0_19._readlyToStop and not arg1_19 then
		return
	end

	arg0_19._listenerParametersValue = {}

	if arg0_19._listenerStepIndex and arg0_19._listenerStepIndex == 0 then
		arg0_19._listenerStepIndex = 3

		for iter0_19, iter1_19 in ipairs(arg0_19._listenerParameters) do
			arg0_19._listenerParametersValue[iter1_19.name] = iter1_19.Value
		end
	else
		arg0_19._listenerStepIndex = arg0_19._listenerStepIndex - 1
	end

	local var0_19 = false
	local var1_19 = arg0_19.liveCom.reactPos
	local var2_19 = arg0_19._animator:GetCurrentAnimatorStateInfo(0)
	local var3_19 = {
		reactPos = var1_19,
		normalTime = var2_19.normalizedTime,
		stateInfo = var2_19
	}

	for iter2_19 = 1, #arg0_19.drags do
		arg0_19.drags[iter2_19]:stepParameter(var3_19)

		local var4_19 = arg0_19.drags[iter2_19]:getParameToTargetFlag()
		local var5_19 = arg0_19.drags[iter2_19]:getActive()

		if (var4_19 or var5_19) and arg0_19.drags[iter2_19]:getIgnoreReact() then
			var0_19 = true
		elseif arg0_19.drags[iter2_19]:getReactCondition() then
			var0_19 = true
		end

		local var6_19 = arg0_19.drags[iter2_19]:getParameter()
		local var7_19 = arg0_19.drags[iter2_19]:getParameterUpdateFlag()

		if var6_19 and var7_19 then
			local var8_19 = arg0_19.drags[iter2_19]:getParameterCom()

			if var8_19 then
				arg0_19.liveCom:ChangeParameterData(var8_19, var6_19)
			end
		end

		local var9_19 = arg0_19.drags[iter2_19]:getRelationParameterList()

		for iter3_19, iter4_19 in ipairs(var9_19) do
			if iter4_19.enable then
				arg0_19.liveCom:ChangeParameterData(iter4_19.com, iter4_19.value)
			end
		end
	end

	if var0_19 == arg0_19.ignoreReact or not var0_19 and (arg0_19.mouseInputDown or arg0_19.isPlaying) then
		-- block empty
	else
		arg0_19:setReactPos(var0_19)
	end

	if arg0_19.foldAble and arg0_19.foldAble > 0 then
		arg0_19.foldAble = arg0_19.foldAble - Time.deltaTime

		if arg0_19.foldAble <= 0 then
			arg0_19.foldAble = nil

			pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, false)
		end
	end
end

local function var19_0(arg0_20)
	arg0_20.drags = {}
	arg0_20.dragParts = {}
	arg0_20.dragCommonData = {}

	for iter0_20 = 1, #var4_0.assistantTouchParts do
		table.insert(arg0_20.dragParts, var4_0.assistantTouchParts[iter0_20])
	end

	arg0_20._l2dCharEnable = true
	arg0_20._shopPreView = arg0_20.live2dData.shopPreView
	arg0_20._listenerParameters = {}
	arg0_20._listenerStepIndex = 0

	local var0_20 = "live2D初始化id列表："

	for iter1_20, iter2_20 in ipairs(arg0_20.live2dData.shipL2dId) do
		local var1_20 = pg.ship_l2d[iter2_20]

		if var1_20 and arg0_20:getDragEnable(var1_20) then
			var0_20 = var0_20 .. var1_20.id .. ","

			local var2_20 = Live2dDrag.New(var1_20, arg0_20.live2dData, arg0_20.dragCommonData)
			local var3_20 = arg0_20.liveCom:GetCubismParameter(var1_20.parameter)

			var2_20:setParameterCom(var3_20)
			var2_20:setEventCallback(function(arg0_21, arg1_21)
				var17_0(arg0_20, arg0_21, arg1_21)
				var16_0(arg0_20, arg0_21, arg1_21)
			end)
			arg0_20.liveCom:AddParameterValue(var2_20.parameterName, var2_20.startValue, var9_0[var2_20.mode])

			if var1_20.relation_parameter and var1_20.relation_parameter.list then
				local var4_20 = var1_20.relation_parameter.list

				for iter3_20, iter4_20 in ipairs(var4_20) do
					local var5_20 = arg0_20.liveCom:GetCubismParameter(iter4_20.name)

					if var5_20 then
						var2_20:addRelationComData(var5_20, iter4_20)

						local var6_20 = iter4_20.mode or var1_20.mode

						arg0_20.liveCom:AddParameterValue(iter4_20.name, iter4_20.start or var2_20.startValue or 0, var9_0[var6_20])
					end
				end
			end

			table.insert(arg0_20.drags, var2_20)

			if not table.contains(arg0_20._listenerParameters, var3_20) then
				table.insert(arg0_20._listenerParameters, var3_20)
			end

			if var2_20.drawAbleName and var2_20.drawAbleName ~= "" and not table.contains(arg0_20.dragParts, var2_20.drawAbleName) then
				table.insert(arg0_20.dragParts, var2_20.drawAbleName)
			end
		end
	end

	print(var0_20)
	arg0_20.liveCom:SetDragParts(arg0_20.dragParts)

	arg0_20.eventTrigger = GetOrAddComponent(arg0_20.liveCom.transform.parent, typeof(EventTriggerListener))

	arg0_20.eventTrigger:AddPointDownFunc(function(arg0_22, arg1_22)
		if arg0_20.useEventTriggerFlag then
			arg0_20:onPointDown(arg1_22)
		end
	end)
	arg0_20.eventTrigger:AddPointUpFunc(function(arg0_23, arg1_23)
		if arg0_20.useEventTriggerFlag then
			arg0_20:onPointUp(arg1_23)
		end
	end)
	arg0_20.eventTrigger:AddDragFunc(function(arg0_24, arg1_24)
		if arg0_20.useEventTriggerFlag then
			arg0_20:onPointDrag(arg1_24)
		end
	end)
	arg0_20.liveCom:SetMouseInputActions(System.Action(function()
		if not arg0_20.useEventTriggerFlag then
			arg0_20:onPointDown()
		end
	end), System.Action(function()
		if not arg0_20.useEventTriggerFlag then
			arg0_20:onPointUp()
		end
	end))

	arg0_20.paraRanges = arg0_20.liveCom.paraRanges
	arg0_20.destinations = ReflectionHelp.RefGetProperty(typeof(Live2dChar), "Destinations", arg0_20.liveCom):ToTable()
end

function var0_0.checkActionExist(arg0_27, arg1_27)
	return (table.indexof(arg0_27.animationClipNames, arg1_27))
end

function var0_0.checkActionProfile(arg0_28, arg1_28)
	local var0_28 = table.indexof(arg0_28.animationClipNames, arg1_28)

	if (not var0_28 or var0_28 == false) and string.find(arg1_28, "main_") then
		return true
	end

	return var0_28
end

function var0_0.onListenerHandle(arg0_29, arg1_29, arg2_29)
	if not arg0_29.drags or #arg0_29.drags == 0 then
		return
	end

	for iter0_29 = 1, #arg0_29.drags do
		arg0_29.drags[iter0_29]:onListenerEvent(arg1_29, arg2_29)
	end
end

function var0_0.onPointDown(arg0_30, arg1_30)
	if not arg0_30._l2dCharEnable then
		return
	end

	arg0_30.mouseInputDown = true

	if #arg0_30.drags > 0 and arg0_30.liveCom:GetDragPart() > 0 then
		local var0_30 = arg0_30.liveCom:GetDragPart()
		local var1_30 = arg0_30.dragParts[var0_30]

		if var0_30 > 0 and var1_30 then
			for iter0_30, iter1_30 in ipairs(arg0_30.drags) do
				if iter1_30.drawAbleName == var1_30 then
					iter1_30:startDrag(arg1_30)
				end
			end
		end
	end
end

function var0_0.onPointUp(arg0_31, arg1_31)
	if not arg0_31._l2dCharEnable then
		return
	end

	arg0_31.mouseInputDown = false

	if arg0_31.drags and #arg0_31.drags > 0 then
		local var0_31 = arg0_31.liveCom:GetDragPart()

		if var0_31 > 0 then
			local var1_31 = arg0_31.dragParts[var0_31]
		end

		for iter0_31 = 1, #arg0_31.drags do
			arg0_31.drags[iter0_31]:stopDrag(arg1_31)
		end
	end
end

function var0_0.onPointDrag(arg0_32, arg1_32)
	if not arg0_32._l2dCharEnable then
		return
	end

	if arg0_32.drags and #arg0_32.drags > 0 then
		for iter0_32 = 1, #arg0_32.drags do
			arg0_32.drags[iter0_32]:onDrag(arg1_32)
		end
	end
end

function var0_0.changeTriggerFlag(arg0_33, arg1_33)
	arg0_33.useEventTriggerFlag = arg1_33
end

local function var20_0(arg0_34, arg1_34)
	arg0_34._go = arg1_34
	arg0_34._tf = tf(arg1_34)

	HotfixHelper.SetLayerRecursively(arg0_34._go, LayerMask.NameToLayer("UI"))
	arg0_34._tf:SetParent(arg0_34.live2dData.parent, true)

	arg0_34._tf.localScale = arg0_34.live2dData.scale
	arg0_34._tf.localPosition = arg0_34.live2dData.position
	arg0_34.liveCom = arg1_34:GetComponent(typeof(Live2dChar))
	arg0_34._animator = arg1_34:GetComponent(typeof(Animator))
	arg0_34.loadSheets = {}
	arg0_34.playingSheetInfo = {}
	arg0_34.cubismModelCom = arg1_34:GetComponent("Live2D.Cubism.Core.CubismModel")
	arg0_34.animationClipNames = {}

	if arg0_34._animator and arg0_34._animator.runtimeAnimatorController then
		local var0_34 = arg0_34._animator.runtimeAnimatorController.animationClips:ToTable()

		for iter0_34, iter1_34 in ipairs(var0_34) do
			table.insert(arg0_34.animationClipNames, iter1_34.name)
		end
	end

	local var1_34 = var4_0.action2Id.idle

	arg0_34.liveCom:SetReactMotions(var4_0.idleActions)

	function arg0_34.liveCom.FinishAction(arg0_35)
		arg0_34:live2dActionChange(false)

		if arg0_34.finishActionCB then
			arg0_34.finishActionCB()

			arg0_34.finishActionCB = nil
		end

		arg0_34:changeActionIdle()

		if arg0_34.foldAble then
			pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, false)
		end
	end

	function arg0_34.liveCom.EventAction(arg0_36)
		if arg0_34.animEventCB then
			arg0_34.animEventCB(arg0_36)

			arg0_34.animEventCB = nil
		end
	end

	arg0_34.dftCom = GetOrAddComponent(arg0_34._tf, typeof(DftAniEvent))

	arg0_34.dftCom:SetCommonEvent(function(arg0_37)
		local var0_37 = string.split(arg0_37.stringParameter, "_")

		if table.contains(var1_0, var0_37[1]) then
			local var1_37 = arg0_34.live2dData.ship:getSkinId()
			local var2_37
			local var3_37
			local var4_37 = var3_0[var0_37[1]]

			if var4_37.cv_voice then
				var2_37 = pg.CriMgr.GetCVBankName(ShipWordHelper.RawGetCVKey(var1_37))

				local var5_37 = pg.ship_skin_template[var1_37].group_index

				var3_37 = "vocal_" .. var0_37[2] .. "_" .. var5_37
			else
				var2_37 = var4_37.sheet_name
				var3_37 = var1_37 .. "_" .. var0_37[2]
			end

			if var4_37.cv_voice then
				local var6_37 = table.contains(var2_0, var0_37[1])

				arg0_34:playL2dVoice(var2_37, var3_37, var6_37)
			end
		end
	end)
	arg0_34.liveCom:SetTouchParts(var4_0.assistantTouchParts)

	if arg0_34.live2dData and arg0_34.live2dData.ship and arg0_34.live2dData.ship.propose then
		arg0_34:changeParamaterValue("Paramring", 1)
	else
		arg0_34:changeParamaterValue("Paramring", 0)
	end

	if not arg0_34._physics then
		arg0_34._physics = GetComponent(arg0_34._tf, "CubismPhysicsController")
	end

	if arg0_34._physics then
		arg0_34._physics.enabled = false
		arg0_34._physics.enabled = true
	end

	if arg0_34.live2dData.l2dDragRate and #arg0_34.live2dData.l2dDragRate > 0 then
		arg0_34.liveCom.DragRateX = arg0_34.live2dData.l2dDragRate[1] * var5_0
		arg0_34.liveCom.DragRateY = arg0_34.live2dData.l2dDragRate[2] * var6_0
		arg0_34.liveCom.DampingTime = arg0_34.live2dData.l2dDragRate[3] * var7_0
	end

	var10_0(arg0_34)
	var11_0(arg0_34)
	var15_0(arg0_34)
	arg0_34:setEnableActions({})
	arg0_34:setIgnoreActions({})
	arg0_34:changeIdleIndex(0)

	if arg0_34.live2dData.shipL2dId and #arg0_34.live2dData.shipL2dId > 0 then
		var19_0(arg0_34)
		arg0_34:loadLive2dData()

		arg0_34.timer = Timer.New(function()
			var18_0(arg0_34)
		end, 0.0333333333333333, -1)

		arg0_34.timer:Start()
		var18_0(arg0_34)
	end

	arg0_34.state = var0_0.STATE_INITED

	if arg0_34.delayChangeParamater and #arg0_34.delayChangeParamater > 0 then
		for iter2_34 = 1, #arg0_34.delayChangeParamater do
			local var2_34 = arg0_34.delayChangeParamater[iter2_34]

			arg0_34:changeParamaterValue(var2_34[1], var2_34[2])
		end

		arg0_34.delayChangeParamater = nil
	end

	arg0_34:offsetL2dPositonDelay(0.3, 6)
	var14_0(arg0_34, "idle", true)
end

function var0_0.Ctor(arg0_39, arg1_39, arg2_39)
	arg0_39.state = var0_0.STATE_LOADING
	arg0_39.live2dData = arg1_39
	var4_0 = pg.AssistantInfo

	assert(not arg0_39.live2dData:isEmpty())

	arg0_39.modelName = arg0_39.live2dData:GetShipName()

	local function var0_39(arg0_40)
		if arg0_40 then
			if arg0_39.state == var0_0.STATE_LOADING then
				var20_0(arg0_39, arg0_40)

				if arg2_39 then
					arg2_39(arg0_39)
				end
			else
				arg0_39:clearMaskTexture(arg0_40)
				pg.Live2DMgr.GetInstance():ReturnLive2DModel(arg0_39.modelName, arg0_40)
			end
		end
	end

	arg0_39.live2dRequestId = pg.Live2DMgr.GetInstance():GetLive2DModelAsync(arg0_39.modelName, var0_39)
	Input.gyro.enabled = arg0_39.live2dData.gyro == 1 and PlayerPrefs.GetInt(GYRO_ENABLE, 1) == 1
	arg0_39.useEventTriggerFlag = true
end

function var0_0.SetVisible(arg0_41, arg1_41)
	if not arg0_41:IsLoaded() then
		return
	end

	if arg1_41 then
		arg0_41._readlyToStop = false

		if arg0_41._physics then
			arg0_41._physics.enabled = false
			arg0_41._physics.enabled = true
		end

		arg0_41:setReactPos(false)
		var18_0(arg0_41, true)

		if Live2dConst.GetLive2dDirty(arg0_41.live2dData.ship:getSkinId(), arg0_41.live2dData.ship.id, true) then
			arg0_41:resetL2dData()
		end

		if arg0_41._tf and isActive(arg0_41._tf) then
			setActive(arg0_41._tf, false)
		end

		onNextTick(function()
			setActive(arg0_41._tf, true)
			arg0_41:loadLive2dData()
			arg0_41:offsetL2dPositonDelay(0.3, 5, function()
				return
			end)
			var14_0(arg0_41, "idle", true)
		end)
	else
		arg0_41:stopVoice()
		arg0_41:setReactPos(true)
		arg0_41:saveLive2dData()
		arg0_41:changeIdleIndex(0)
		var14_0(arg0_41, "idle", true)

		arg0_41._readlyToStop = true
	end
end

function var0_0.loadL2dLinkData(arg0_44)
	return
end

function var0_0.loadLive2dData(arg0_45)
	if not arg0_45.live2dData.loadPrefs then
		return
	end

	if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and not arg0_45.live2dData.spineUseLive2d then
		if arg0_45.drags then
			for iter0_45 = 1, #arg0_45.drags do
				arg0_45.drags[iter0_45]:clearData()
				arg0_45.drags[iter0_45]:loadL2dFinal()
			end
		end

		arg0_45:changeIdleIndex(0)

		arg0_45.saveActionAbleId = nil

		arg0_45:loadL2dLinkData()
	else
		local var0_45, var1_45 = Live2dConst.GetL2dSaveData(arg0_45.live2dData:GetShipSkinConfig().id, arg0_45.live2dData.ship.id)
		local var2_45 = Live2dConst.GetDragActionIndex(var1_45, arg0_45.live2dData:GetShipSkinConfig().id, arg0_45.live2dData.ship.id) or 1

		if var0_45 then
			arg0_45:changeIdleIndex(var0_45)
		end

		arg0_45.saveActionAbleId = var1_45

		if var1_45 and var1_45 > 0 then
			if pg.ship_l2d[var1_45] then
				local var3_45 = pg.ship_l2d[var1_45].action_trigger_active

				if var0_45 and var3_45.idle_enable and #var3_45.idle_enable > 0 then
					for iter1_45, iter2_45 in ipairs(var3_45.idle_enable) do
						if iter2_45[1] == var0_45 then
							arg0_45:setEnableActions(iter2_45[2])
						end
					end
				elseif var2_45 and var2_45 >= 1 and var3_45.active_list then
					arg0_45:setEnableActions(var3_45.active_list[var2_45].enable and var3_45.active_list[var2_45].enable or {})
				else
					arg0_45:setEnableActions(var3_45.enable and var3_45.enable or {})
				end

				if var0_45 and var3_45.idle_ignore and #var3_45.idle_ignore > 0 then
					for iter3_45, iter4_45 in ipairs(var3_45.idle_ignore) do
						if iter4_45[1] == var0_45 then
							arg0_45:setIgnoreActions(iter4_45[2])
						end
					end
				elseif var2_45 and var2_45 >= 1 and var3_45.active_list then
					arg0_45:setIgnoreActions(var3_45.active_list[var2_45].ignore and var3_45.active_list[var2_45].ignore or {})
				else
					arg0_45:setIgnoreActions(var3_45.ignore and var3_45.ignore or {})
				end
			end
		else
			arg0_45:setEnableActions({})
			arg0_45:setIgnoreActions({})
		end

		if arg0_45.drags then
			for iter5_45 = 1, #arg0_45.drags do
				arg0_45.drags[iter5_45]:loadData()
				arg0_45.drags[iter5_45]:loadL2dFinal()
			end
		end
	end
end

function var0_0.saveLive2dData(arg0_46)
	if not arg0_46.live2dData.loadPrefs then
		return
	end

	if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and not arg0_46.live2dData.spineUseLive2d then
		return
	end

	local var0_46 = arg0_46.live2dData.skinId

	if arg0_46.idleIndex then
		Live2dConst.SaveL2dIdle(var0_46, arg0_46.live2dData.ship.id, arg0_46.idleIndex)
	end

	if arg0_46.saveActionAbleId then
		if arg0_46.idleIndex == 0 then
			Live2dConst.SaveL2dAction(var0_46, arg0_46.live2dData.ship.id, 0)
		else
			Live2dConst.SaveL2dAction(var0_46, arg0_46.live2dData.ship.id, arg0_46.saveActionAbleId)
		end
	end

	if arg0_46.drags then
		for iter0_46 = 1, #arg0_46.drags do
			arg0_46.drags[iter0_46]:saveData()
		end
	end
end

function var0_0.changeActionIdle(arg0_47)
	local var0_47 = var4_0.idleActions[math.ceil(math.random(#var4_0.idleActions))]

	var14_0(arg0_47, "idle", true)
end

function var0_0.enablePlayAction(arg0_48, arg1_48)
	return var13_0(arg0_48, arg1_48)
end

function var0_0.IgonreReactPos(arg0_49, arg1_49)
	arg0_49:setReactPos(arg1_49)
end

function var0_0.setReactPos(arg0_50, arg1_50)
	if arg0_50.liveCom then
		arg0_50.ignoreReact = arg1_50

		arg0_50.liveCom:IgonreReactPos(arg1_50)

		if arg1_50 then
			arg0_50.liveCom.inDrag = false
		end

		arg0_50.liveCom.reactPos = Vector3(0, 0, 0)

		arg0_50:updateDragsSateData()
	end
end

function var0_0.l2dCharEnable(arg0_51, arg1_51)
	arg0_51._l2dCharEnable = arg1_51
end

function var0_0.inShopPreView(arg0_52, arg1_52)
	arg0_52._shopPreView = arg1_52

	if arg1_52 then
		arg0_52:changeParamaterValue("shop_hx", 1)
	end
end

function var0_0.getDragEnable(arg0_53, arg1_53)
	if arg0_53._shopPreView and arg1_53.shop_action == 0 then
		return false
	end

	return true
end

function var0_0.updateShip(arg0_54, arg1_54)
	if arg1_54 and arg0_54.live2dData and arg0_54.live2dData.ship then
		arg0_54.live2dData.ship = arg1_54

		if arg0_54.live2dData and arg0_54.live2dData.ship and arg0_54.live2dData.ship.propose then
			arg0_54:changeParamaterValue("Paramring", 1)
		else
			arg0_54:changeParamaterValue("Paramring", 0)
		end
	end
end

function var0_0.getDragByTriggerType(arg0_55, arg1_55)
	for iter0_55 = 1, #arg0_55.drags do
		local var0_55 = arg0_55.drags[iter0_55]

		if var0_55:getActionTriggerType() == arg1_55 then
			return var0_55
		end
	end

	return nil
end

function var0_0.IsLoaded(arg0_56)
	return arg0_56.state == var0_0.STATE_INITED
end

function var0_0.GetTouchPart(arg0_57)
	return arg0_57.liveCom:GetTouchPart()
end

function var0_0.TriggerAction(arg0_58, arg1_58, arg2_58, arg3_58, arg4_58)
	arg0_58:CheckStopDrag()

	local var0_58 = var14_0(arg0_58, arg1_58, arg3_58)

	if var0_58 then
		arg0_58.finishActionCB = arg2_58
		arg0_58.animEventCB = arg4_58
	end

	return var0_58
end

function var0_0.ResetL2dData(arg0_59)
	arg0_59:live2dActionChange(false)
	arg0_59:setEnableActions({})
	arg0_59:setIgnoreActions({})

	arg0_59.ableFlag = nil
end

function var0_0.setPurchaseOffset(arg0_60, arg1_60)
	local var0_60 = arg0_60.live2dData.ship:GetSkinConfig().purchase_offset

	if not var0_60 or #var0_60 < 3 then
		return
	end

	if arg1_60 then
		if var0_60 and #var0_60 >= 3 then
			arg0_60._tf.localPosition = Vector3(var0_60[1], var0_60[2], var0_60[3])
		end

		if var0_60 and #var0_60 >= 4 then
			arg0_60._tf.localScale = Vector3(var0_60[4], var0_60[4], var0_60[4])
		end
	else
		arg0_60._tf.localScale = arg0_60.live2dData.scale
		arg0_60._tf.localPosition = arg0_60.live2dData.position
	end
end

function var0_0.offsetL2dPositonDelay(arg0_61, arg1_61, arg2_61, arg3_61)
	if arg0_61._tf and LeanTween.isTweening(go(arg0_61._tf)) then
		LeanTween.cancel(go(arg0_61._tf))
	end

	arg0_61._tf.localPosition = Vector3(30000, 0, 0)
	arg0_61._animator.speed = arg2_61

	LeanTween.delayedCall(go(arg0_61._tf), arg1_61, System.Action(function()
		if arg0_61._tf then
			arg0_61:resetPosition()

			arg0_61._animator.speed = 1
		end

		if arg3_61 then
			arg3_61()
		end
	end))
end

function var0_0.resumeSpeed(arg0_63)
	if arg0_63._animator then
		arg0_63._animator.speed = 1
	end
end

function var0_0.resetL2dData(arg0_64)
	if not arg0_64._tf then
		return
	end

	if LeanTween.isTweening(go(arg0_64._tf)) then
		return
	end

	arg0_64:offsetL2dPositonDelay(0.3, 5)
	Live2dConst.ClearLive2dSave(arg0_64.live2dData.ship:getSkinId(), arg0_64.live2dData.ship.id)
	arg0_64:ResetL2dData()
	arg0_64:changeIdleIndex(0)
	arg0_64:loadLive2dData()
	var14_0(arg0_64, "idle", true)
end

function var0_0.applyActiveData(arg0_65, arg1_65)
	if not arg1_65 then
		return
	end

	local var0_65 = arg1_65.activeData
	local var1_65 = var0_65.enable
	local var2_65 = var0_65.idle_enable
	local var3_65 = var0_65.idle_ignore
	local var4_65 = var0_65.ignore
	local var5_65 = var0_65.idle and var0_65.idle or arg1_65.idle
	local var6_65 = var0_65.repeatFlag
	local var7_65

	if var0_65.fold ~= nil then
		var7_65 = var0_65.fold == 1 and true or false
	end

	if var1_65 and #var1_65 >= 0 then
		arg0_65:setEnableActions(var1_65)
	elseif var2_65 and #var2_65 > 0 then
		for iter0_65, iter1_65 in ipairs(var2_65) do
			if iter1_65[1] == var5_65 then
				arg0_65:setEnableActions(iter1_65[2])
			end
		end
	end

	if var4_65 and #var4_65 >= 0 then
		arg0_65:setIgnoreActions(var4_65)
	elseif var3_65 and #var3_65 > 0 then
		for iter2_65, iter3_65 in ipairs(var3_65) do
			if iter3_65[1] == var5_65 then
				arg0_65:setIgnoreActions(iter3_65[2])
			end
		end
	end

	if var5_65 and var5_65 ~= arg0_65.indexIndex then
		arg0_65.saveActionAbleId = arg1_65.id
	end

	if var5_65 then
		local var8_65

		if type(var5_65) == "number" and var5_65 >= 0 then
			var8_65 = var5_65
		elseif type(var5_65) == "table" then
			local var9_65 = {}

			for iter4_65, iter5_65 in ipairs(var5_65) do
				if iter5_65 == arg0_65.idleIndex then
					if var6_65 then
						table.insert(var9_65, iter5_65)
					end
				else
					table.insert(var9_65, iter5_65)
				end
			end

			var8_65 = var9_65[math.random(1, #var9_65)]
		end

		if var8_65 then
			arg0_65:changeIdleIndex(var8_65)
		end

		arg0_65:saveLive2dData()
	end

	if var7_65 ~= nil then
		arg0_65.foldAble = true

		pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, var7_65)
	end
end

function var0_0.setIgnoreActions(arg0_66, arg1_66)
	arg0_66.ignorePlayActions = arg1_66 and arg1_66 or {}
end

function var0_0.setEnableActions(arg0_67, arg1_67)
	arg0_67.enablePlayActions = arg1_67 and arg1_67 or {}
end

function var0_0.changeIdleIndex(arg0_68, arg1_68)
	local var0_68 = false

	if arg0_68.idleIndex ~= arg1_68 then
		local var1_68 = arg0_68._animator:GetInteger("idle")

		if var1_68 and var1_68 >= 0 then
			arg0_68._animator:SetInteger("idle", arg1_68)

			var0_68 = true
		end
	end

	print("live2d 待机动作设置为 = " .. arg1_68)

	arg0_68.idleIndex = arg1_68

	arg0_68:onListenerHandle(Live2D.ON_ACTION_CHANGE_IDLE, {
		idle = arg0_68.idleIndex,
		idle_change = var0_68
	})
	arg0_68:updateDragsSateData()
end

function var0_0.live2dActionChange(arg0_69, arg1_69)
	arg0_69.isPlaying = arg1_69

	arg0_69:updateDragsSateData()
end

function var0_0.setPosition(arg0_70, arg1_70)
	arg0_70._tf.localPosition = arg1_70
end

function var0_0.resetPosition(arg0_71)
	arg0_71._tf.localPosition = arg0_71.live2dData.position
end

function var0_0.updateDragsSateData(arg0_72)
	local var0_72 = {
		idleIndex = arg0_72.idleIndex,
		isPlaying = arg0_72.isPlaying,
		ignoreReact = arg0_72.ignoreReact,
		actionName = arg0_72.playActionName
	}

	if arg0_72.drags then
		for iter0_72 = 1, #arg0_72.drags do
			arg0_72.drags[iter0_72]:updateStateData(var0_72)
		end
	end
end

function var0_0.CheckStopDrag(arg0_73)
	local var0_73 = arg0_73.live2dData:GetShipSkinConfig()

	if var0_73.l2d_ignore_drag and var0_73.l2d_ignore_drag == 1 then
		arg0_73.liveCom.ResponseClick = false
		arg0_73.liveCom.inDrag = false
	end
end

function var0_0.changeParamaterValue(arg0_74, arg1_74, arg2_74)
	if arg0_74:IsLoaded() then
		if not arg1_74 or string.len(arg1_74) == 0 then
			return
		end

		local var0_74 = arg0_74.liveCom:GetCubismParameter(arg1_74)

		if not var0_74 then
			return
		end

		arg0_74.liveCom:AddParameterValue(var0_74, arg2_74, var9_0[1])
	else
		if not arg0_74.delayChangeParamater then
			arg0_74.delayChangeParamater = {}
		end

		table.insert(arg0_74.delayChangeParamater, {
			arg1_74,
			arg2_74
		})
	end
end

function var0_0.changeDragParameter(arg0_75, arg1_75, arg2_75)
	if arg0_75:IsLoaded() and arg0_75.drags then
		for iter0_75 = 1, #arg0_75.drags do
			if arg0_75.drags[iter0_75].parameterName and arg0_75.drags[iter0_75].parameterName == arg1_75 then
				arg0_75.drags[iter0_75]:setTargetValue(arg2_75)
			end
		end
	end
end

function var0_0.setSortingLayer(arg0_76, arg1_76)
	arg1_76 = arg1_76 or LayerWeightConst.L2D_DEFAULT_LAYER

	arg0_76:updateL2dSortMode()

	local var0_76 = arg0_76._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_76 = typeof("Live2D.Cubism.Rendering.CubismRenderController")

	ReflectionHelp.RefSetProperty(var1_76, "SortingOrder", var0_76, arg1_76)
end

function var0_0.updateL2dSortMode(arg0_77)
	local var0_77 = arg0_77._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_77 = typeof("Live2D.Cubism.Rendering.CubismRenderController")
	local var2_77 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Rendering.CubismSortingMode"), "BackToFrontOrder", nil)

	ReflectionHelp.RefSetProperty(var1_77, "SortingMode", var0_77, var2_77)
end

function var0_0.setSortingModeFrontZ(arg0_78)
	local var0_78 = arg0_78._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_78 = typeof("Live2D.Cubism.Rendering.CubismRenderController")
	local var2_78 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Rendering.CubismSortingMode"), "BackToFrontZ", nil)

	ReflectionHelp.RefSetProperty(var1_78, "SortingMode", var0_78, var2_78)
end

function var0_0.Dispose(arg0_79)
	if arg0_79.state == var0_0.STATE_DISPOSE then
		return
	end

	if table.contains(ChangeSkinLink.L2D_SAVE_TEMPLATE_DISPOSE, arg0_79.live2dData.skinId) then
		local var0_79 = arg0_79:getParameterDic()

		if arg0_79.live2dData.ship and arg0_79.live2dData.ship.id and arg0_79.live2dData.ship.id > 0 then
			ChangeSkinLink.L2D_PARAMETER_DIC[arg0_79.live2dData.ship.id] = var0_79
		end
	end

	if arg0_79.state == var0_0.STATE_INITED then
		arg0_79.liveCom.FinishAction = nil
		arg0_79.liveCom.EventAction = nil

		arg0_79.liveCom:SetMouseInputActions(nil, nil)
	end

	if arg0_79.dftCom then
		arg0_79.dftCom:SetCommonEvent(nil)
	end

	arg0_79:stopVoice()
	arg0_79:unloadCueSheet()

	if arg0_79._tf and LeanTween.isTweening(go(arg0_79._tf)) then
		LeanTween.cancel(go(arg0_79._tf))
	end

	arg0_79:saveLive2dData()

	arg0_79._readlyToStop = false

	if arg0_79.live2dRequestId then
		pg.Live2DMgr.GetInstance():StopLoadingLive2d(arg0_79.live2dRequestId)

		arg0_79.live2dRequestId = nil
	end

	if arg0_79.drags then
		for iter0_79 = 1, #arg0_79.drags do
			arg0_79.drags[iter0_79]:dispose()
		end

		arg0_79.drags = {}
	end

	if arg0_79.live2dData and arg0_79.live2dData.gyro == 1 then
		Input.gyro.enabled = false
	end

	if arg0_79.live2dData then
		arg0_79.live2dData:Clear()

		arg0_79.live2dData = nil
	end

	if arg0_79.timer then
		arg0_79.timer:Stop()

		arg0_79.timer = nil
	end

	if arg0_79._go and arg0_79.state == var0_0.STATE_INITED then
		arg0_79:clearMaskTexture(arg0_79._go)
		pg.Live2DMgr.GetInstance():ReturnLive2DModel(arg0_79.modelName, arg0_79._go)

		arg0_79.modelName = nil
		arg0_79._go = nil
	end

	arg0_79.state = var0_0.STATE_DISPOSE
end

function var0_0.clearMaskTexture(arg0_80, arg1_80)
	if not arg1_80 then
		return
	end

	local var0_80 = GetComponent(arg1_80, "CubismMaskController")

	if var0_80 then
		local var1_80 = ReflectionHelp.RefGetProperty(typeof("Live2D.Cubism.Rendering.Masking.CubismMaskController"), "MaskTexture", var0_80)

		if var1_80 then
			local var2_80 = ReflectionHelp.RefGetProperty(typeof("Live2D.Cubism.Rendering.Masking.CubismMaskTexture"), "RenderTextures", var1_80)

			for iter0_80 = 0, var2_80.Length - 1 do
				local var3_80 = var2_80[iter0_80]

				var3_80:Release()
				Object.DestroyImmediate(var3_80)
			end

			ReflectionHelp.RefSetProperty(typeof("Live2D.Cubism.Rendering.Masking.CubismMaskTexture"), "RenderTextures", var1_80, nil)

			local var4_80 = ReflectionHelp.RefGetProperty(typeof("Live2D.Cubism.Rendering.Masking.CubismMaskTexture"), "RenderTexture", var1_80)

			var4_80:Release()
			Object.DestroyImmediate(var4_80)
			ReflectionHelp.RefSetProperty(typeof("Live2D.Cubism.Rendering.Masking.CubismMaskTexture"), "RenderTexture", var1_80, nil)
		end
	end
end

function var0_0.settempOffsetPosTime(arg0_81, arg1_81)
	arg0_81.tempOffsetPosTime = arg1_81
end

function var0_0.getParameterDic(arg0_82)
	local var0_82 = {}

	if arg0_82.drags and #arg0_82.drags > 0 then
		for iter0_82, iter1_82 in ipairs(arg0_82.drags) do
			local var1_82 = iter1_82:getParameterName()
			local var2_82 = iter1_82:getParameter()

			if var1_82 and #var1_82 > 0 and var2_82 then
				var0_82[var1_82] = var2_82
			end
		end
	end

	return var0_82
end

function var0_0.unloadCueSheet(arg0_83)
	if not arg0_83.loadSheets then
		return
	end

	for iter0_83, iter1_83 in ipairs(arg0_83.loadSheets) do
		pg.CriMgr.GetInstance():UnloadCueSheet(iter1_83)
	end

	arg0_83.loadSheets = {}
end

function var0_0.stopVoice(arg0_84)
	if not arg0_84.playingSheetInfo then
		return
	end

	for iter0_84, iter1_84 in ipairs(arg0_84.playingSheetInfo) do
		if iter1_84 then
			iter1_84:PlaybackStop()
		end
	end

	arg0_84.playingSheetInfo = {}
end

function var0_0.playL2dVoice(arg0_85, arg1_85, arg2_85, arg3_85)
	if not table.contains(arg0_85.loadSheets, arg1_85) then
		table.insert(arg0_85.loadSheets, arg1_85)
	end

	pg.CriMgr.GetInstance():playCueSheetVoice(arg1_85, arg2_85, arg3_85, function(arg0_86)
		if arg0_86 then
			print("播放的语音长度为 = " .. arg0_86:GetLength())
			table.insert(arg0_85.playingSheetInfo, arg0_86)
		end
	end)
end

function var0_0.UpdateAtomSource(arg0_87)
	arg0_87.updateAtom = true
end

function var0_0.AtomSouceFresh(arg0_88)
	local var0_88 = pg.CriMgr.GetInstance():getAtomSource(pg.CriMgr.C_VOICE)
	local var1_88 = arg0_88._go:GetComponent("CubismCriSrcMouthInput").Analyzer

	var0_88:AttachToAnalyzer(var1_88)

	if arg0_88.updateAtom then
		arg0_88.updateAtom = false
	end
end

function var0_0.SetL2dSortingLayer(arg0_89, arg1_89)
	var0_0.UpdateL2dSortMode(arg0_89)

	local var0_89 = arg0_89:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_89 = typeof("Live2D.Cubism.Rendering.CubismRenderController")

	ReflectionHelp.RefSetProperty(var1_89, "SortingOrder", var0_89, arg1_89)
end

function var0_0.UpdateL2dSortMode(arg0_90)
	local var0_90 = arg0_90:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_90 = typeof("Live2D.Cubism.Rendering.CubismRenderController")
	local var2_90 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Rendering.CubismSortingMode"), "BackToFrontOrder", nil)

	ReflectionHelp.RefSetProperty(var1_90, "SortingMode", var0_90, var2_90)
end

function var0_0.SetSortingModeFrontZ(arg0_91)
	local var0_91 = arg0_91:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_91 = typeof("Live2D.Cubism.Rendering.CubismRenderController")
	local var2_91 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Rendering.CubismSortingMode"), "BackToFrontZ", nil)

	ReflectionHelp.RefSetProperty(var1_91, "SortingMode", var0_91, var2_91)
end

return var0_0
