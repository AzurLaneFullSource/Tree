local var0_0 = class("GuidePlayer")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.bgCg = arg1_1:Find("BG"):GetComponent(typeof(CanvasGroup))
	arg0_1.windowContainer = arg1_1:Find("windows")
	arg0_1.charContainer = arg1_1:Find("char")
	arg0_1.maskTr = arg1_1:Find("mask")
	arg0_1.dialogueWindows = pg.NewGuideMgr.GetInstance().dialogueWindows
	arg0_1.counsellors = pg.NewGuideMgr.GetInstance().counsellors
	arg0_1.uiFinder = pg.NewGuideMgr.GetInstance().uiFinder
	arg0_1.uiDuplicator = pg.NewGuideMgr.GetInstance().uiDuplicator
	arg0_1.uiLoader = pg.NewGuideMgr.GetInstance().uiLoader
	arg0_1.uiFloatCollctor = pg.NewGuideMgr.GetInstance().uiFloatCollctor
	arg0_1.root = arg1_1:Find("target")
end

function var0_0.Execute(arg0_2, arg1_2, arg2_2)
	seriesAsync({
		function(arg0_3)
			arg0_2:UpdateCanClickMask(arg1_2)
			arg0_2:HideDialogueWindows()
			arg0_2:UpdateStyle(arg1_2)
			arg0_2:DoDelay(arg1_2, arg0_3)
		end,
		function(arg0_4)
			arg0_2:WaitUntilSceneEnter(arg1_2, arg0_4)
		end,
		function(arg0_5)
			arg0_2:CheckBaseUI(arg1_2, arg0_5)
		end,
		function(arg0_6)
			arg0_2:CheckSprite(arg1_2, arg0_6)
		end,
		function(arg0_7)
			arg0_2:ShowDialogueWindow(arg1_2, arg0_7)
		end,
		function(arg0_8)
			arg0_2:UpdateHighLight(arg1_2, arg0_8)
		end,
		function(arg0_9)
			arg0_2:OnExecution(arg1_2, arg0_9)
		end,
		function(arg0_10)
			arg0_2:RegisterEvent(arg1_2, arg0_10)
		end,
		function(arg0_11)
			arg0_2:Clear()
			arg0_11()
		end
	}, arg2_2)
end

function var0_0.UpdateCanClickMask(arg0_12, arg1_12)
	setActive(arg0_12.maskTr, not arg1_12:CanClick())
end

function var0_0.CheckBaseUI(arg0_13, arg1_13, arg2_13)
	if not arg1_13:ShouldCheckBaseUI() then
		arg2_13()

		return
	end

	arg0_13:SearchUI(arg1_13:GetBaseUI(), function(arg0_14)
		if not arg0_14 then
			pg.NewGuideMgr.GetInstance():Stop()

			return
		end

		arg2_13()
	end)
end

local function var1_0(arg0_15, arg1_15)
	local var0_15 = arg0_15:GetComponent(typeof(Image))

	return not (IsNil(var0_15.sprite) or arg1_15 and var0_15.sprite.name == arg1_15)
end

function var0_0.CheckSprite(arg0_16, arg1_16, arg2_16)
	if not arg1_16:ShouldCheckSpriteUI() then
		arg2_16()

		return
	end

	local var0_16 = arg1_16:GetSpriteUI()

	arg0_16:SearchUI(var0_16, function(arg0_17)
		if not arg0_17 then
			pg.NewGuideMgr.GetInstance():Stop()

			return
		end

		local var0_17 = var0_16.childPath and arg0_17:Find(var0_16.childPath) or arg0_17

		arg0_16:ClearSpriteTimer()

		local var1_17 = 0
		local var2_17 = 10

		arg0_16.spriteTimer = Timer.New(function()
			var1_17 = var1_17 + 1

			if var1_17 == var2_17 then
				arg0_16:ClearSpriteTimer()

				return
			end

			if var1_0(var0_17, var0_16.defaultName) then
				arg0_16:ClearSpriteTimer()
				arg2_16()
			end
		end, 0.5, -1)

		arg0_16.spriteTimer:Start()
	end)
end

function var0_0.ClearSpriteTimer(arg0_19)
	if arg0_19.spriteTimer then
		arg0_19.spriteTimer:Stop()

		arg0_19.spriteTimer = nil
	end
end

function var0_0.UpdateStyle(arg0_20, arg1_20)
	arg0_20.bgCg.alpha = arg1_20:GetAlpha()
end

function var0_0.DoDelay(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg1_21:GetDelay()

	if var0_21 <= 0 then
		arg2_21()

		return
	end

	arg0_21.delayTimer = Timer.New(arg2_21, var0_21, 1)

	arg0_21.delayTimer:Start()
end

function var0_0.OnSceneEnter(arg0_22)
	if arg0_22.waitSceneData and pg.NewGuideMgr.GetInstance():ExistScene(arg0_22.waitSceneData.sceneName) then
		arg0_22:ClearWaitUntilSceneTimer()
		arg0_22.waitSceneData.callback()

		arg0_22.waitSceneData = nil
	end
end

function var0_0.WaitUntilSceneEnter(arg0_23, arg1_23, arg2_23)
	if not arg1_23:ShouldWaitScene() then
		arg2_23()

		return
	end

	arg0_23:ClearWaitUntilSceneTimer()

	local var0_23 = arg1_23:GetWaitScene()

	if pg.NewGuideMgr.GetInstance():ExistScene(var0_23) then
		arg2_23()
	else
		arg0_23.waitSceneData = {
			sceneName = var0_23,
			callback = arg2_23
		}

		arg0_23:AddWaitUntilSceneTimer()
	end
end

function var0_0.AddWaitUntilSceneTimer(arg0_24)
	arg0_24.waitUntilSceneTimer = Timer.New(function()
		arg0_24:ClearWaitUntilSceneTimer()
		pg.NewGuideMgr.GetInstance():Stop()
	end, 10, 1)

	arg0_24.waitUntilSceneTimer:Start()
end

function var0_0.ClearWaitUntilSceneTimer(arg0_26)
	if arg0_26.waitUntilSceneTimer then
		arg0_26.waitUntilSceneTimer:Stop()

		arg0_26.waitUntilSceneTimer = nil
	end
end

function var0_0.ShowDialogueWindow(arg0_27, arg1_27, arg2_27)
	if not arg1_27:ShouldShowDialogue() then
		arg0_27:HideDialogueWindows()
		arg2_27()

		return
	end

	local var0_27 = {}
	local var1_27 = arg1_27:GetDialogueType()

	if not arg0_27.dialogueWindows[var1_27] then
		table.insert(var0_27, function(arg0_28)
			arg0_27:LoadDialogueWindow(var1_27, arg0_28)
		end)
	end

	table.insert(var0_27, function(arg0_29)
		local var0_29 = arg0_27.dialogueWindows[var1_27]

		arg0_27:UpdateDialogue(arg1_27, var0_29, arg0_29)
	end)
	seriesAsync(var0_27, arg2_27)
end

function var0_0.UpdateDialogue(arg0_30, arg1_30, arg2_30, arg3_30)
	arg0_30:ActiveDialogueWindow(arg2_30)

	local var0_30 = arg1_30:GetStyleData()

	setText(arg2_30:Find("content"), var0_30.text)

	arg2_30.localScale = var0_30.scale
	arg2_30.localPosition = var0_30.position
	arg2_30:Find("content").localScale = var0_30.scale

	local var1_30 = arg2_30:Find("hand")

	if not IsNil(var1_30) then
		var1_30.localPosition = var0_30.handPosition
		var1_30.eulerAngles = var0_30.handAngle
	end

	local var2_30 = var0_30.counsellor

	if var2_30 then
		seriesAsync({
			function(arg0_31)
				arg0_30:LoadCounsellor(var2_30.name, arg0_31)
			end,
			function(arg0_32)
				local var0_32 = arg0_30.counsellors[var2_30.name]

				setActive(var0_32, true)

				var0_32.localPosition = arg2_30.localPosition + Vector3(var2_30.position.x, var2_30.position.y, 0)
				var0_32.localScale = Vector3(var2_30.scale.x, var2_30.scale.y, 1)

				arg0_32()
			end
		}, arg3_30)
	else
		for iter0_30, iter1_30 in pairs(arg0_30.counsellors) do
			setActive(iter1_30, false)
		end

		arg3_30()
	end
end

function var0_0.LoadCounsellor(arg0_33, arg1_33, arg2_33)
	if not arg0_33.counsellors[arg1_33] then
		LoadAnyAsync("guideitem/" .. arg1_33, "", nil, function(arg0_34)
			if IsNil(arg0_34) then
				return
			end

			local var0_34 = Object.Instantiate(arg0_34, arg0_33.charContainer)

			arg0_33.counsellors[arg1_33] = var0_34.transform

			arg2_33()
		end)
	else
		arg2_33()
	end
end

function var0_0.LoadDialogueWindow(arg0_35, arg1_35, arg2_35)
	LoadAnyAsync("guideitem/window_" .. arg1_35, "", nil, function(arg0_36)
		if IsNil(arg0_36) then
			return
		end

		local var0_36 = Object.Instantiate(arg0_36, arg0_35.windowContainer)

		arg0_35.dialogueWindows[arg1_35] = var0_36.transform

		if arg2_35 then
			arg2_35()
		end
	end)
end

function var0_0.ActiveDialogueWindow(arg0_37, arg1_37)
	for iter0_37, iter1_37 in pairs(arg0_37.dialogueWindows) do
		setActive(iter1_37, iter1_37 == arg1_37)
	end
end

function var0_0.HideDialogueWindows(arg0_38)
	for iter0_38, iter1_38 in pairs(arg0_38.dialogueWindows) do
		setActive(iter1_38, false)
	end
end

local function var2_0(arg0_39, arg1_39, arg2_39, arg3_39)
	if arg3_39.type == GuideStep.HIGH_TYPE_GAMEOBJECT then
		arg0_39.uiDuplicator:Duplicate(arg2_39, {
			clearAllEvent = true
		})
	elseif arg3_39.type == GuideStep.HIGH_TYPE_LINE then
		local var0_39 = arg2_39.rect
		local var1_39 = arg0_39._tf:InverseTransformPoint(arg2_39.position)

		arg0_39.uiLoader:LoadHighLightArea({
			position = Vector3(var1_39.x, var1_39.y, 0) + Vector3(var0_39.x, var0_39.y, 0),
			size = Vector2(var0_39.width, var0_39.height),
			length = arg1_39:GetHighlightLength(),
			name = arg1_39:GetHighlightName()
		})
	elseif arg3_39.type == GuideStep.HIGH_TYPE_FLOAT then
		arg0_39.uiFloatCollctor:SetFloat(arg2_39)
	end
end

function var0_0.UpdateHighLight(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg1_40:GetHighLightTarget()

	if #var0_40 <= 0 then
		arg2_40()

		return
	end

	local var1_40 = {}

	for iter0_40, iter1_40 in ipairs(var0_40) do
		table.insert(var1_40, function(arg0_41)
			arg0_40:SearchUI(iter1_40, function(arg0_42)
				if not arg0_42 then
					pg.NewGuideMgr.GetInstance():Stop()

					return
				end

				var2_0(arg0_40, arg1_40, arg0_42, iter1_40)
				arg0_41()
			end)
		end)
	end

	parallelAsync(var1_40, arg2_40)
end

function var0_0.SearchUI(arg0_43, arg1_43, arg2_43)
	arg0_43.uiFinder:Search({
		path = arg1_43.path,
		delay = arg1_43.delay,
		childIndex = arg1_43.pathIndex,
		conditionData = arg1_43.conditionData,
		callback = arg2_43
	})
end

function var0_0.SearchWithoutDelay(arg0_44, arg1_44, arg2_44)
	arg0_44.uiFinder:SearchWithoutDelay({
		path = arg1_44.path,
		delay = arg1_44.delay,
		childIndex = arg1_44.pathIndex,
		conditionData = arg1_44.conditionData,
		callback = arg2_44
	})
end

function var0_0.RegisterEvent(arg0_45, arg1_45, arg2_45)
	if arg1_45:ExistTrigger() then
		removeOnButton(arg0_45._tf)
		arg2_45()

		return
	end

	onButton(pg.NewGuideMgr.GetInstance(), arg0_45._tf, function()
		if arg1_45:ShouldGoScene() then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE[arg1_45.sceneName])
			arg2_45()
		elseif arg1_45:ShouldTriggerOtherTarget() then
			arg0_45:SearchUI(arg1_45:GetOtherTriggerTarget(), function(arg0_47)
				triggerButton(arg0_47)
				arg2_45()
			end)
		else
			arg2_45()
		end
	end, SFX_PANEL)
end

function var0_0.NextOne(arg0_48)
	triggerButton(arg0_48._tf)
end

function var0_0.HideCounsellors(arg0_49)
	for iter0_49, iter1_49 in pairs(arg0_49.counsellors) do
		setActive(iter1_49, false)
	end
end

function var0_0.Clear(arg0_50)
	arg0_50:HideCounsellors()
	arg0_50:HideDialogueWindows()
	arg0_50:ClearSpriteTimer()
	setActive(arg0_50.maskTr, false)
	removeOnButton(arg0_50._tf)
	arg0_50:OnClear()

	if arg0_50.delayTimer then
		arg0_50.delayTimer:Stop()

		arg0_50.delayTimer = nil
	end

	arg0_50.uiFinder:Clear()
	arg0_50.uiDuplicator:Clear()
	arg0_50.uiLoader:Clear()
	arg0_50.uiFloatCollctor:Clear()
end

function var0_0.OnExecution(arg0_51, arg1_51, arg2_51)
	arg2_51()
end

function var0_0.OnClear(arg0_52)
	return
end

return var0_0
