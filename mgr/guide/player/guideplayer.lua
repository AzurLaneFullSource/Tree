local var0_0 = class("GuidePlayer")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.bgCg = arg1_1:Find("BG"):GetComponent(typeof(CanvasGroup))
	arg0_1.windowContainer = arg1_1:Find("windows")
	arg0_1.charContainer = arg1_1:Find("char")
	arg0_1.dialogueWindows = pg.NewGuideMgr.GetInstance().dialogueWindows
	arg0_1.counsellors = pg.NewGuideMgr.GetInstance().counsellors
	arg0_1.uiFinder = pg.NewGuideMgr.GetInstance().uiFinder
	arg0_1.uiDuplicator = pg.NewGuideMgr.GetInstance().uiDuplicator
	arg0_1.uiLoader = pg.NewGuideMgr.GetInstance().uiLoader
	arg0_1.root = arg1_1:Find("target")
end

function var0_0.Execute(arg0_2, arg1_2, arg2_2)
	seriesAsync({
		function(arg0_3)
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

function var0_0.CheckBaseUI(arg0_12, arg1_12, arg2_12)
	if not arg1_12:ShouldCheckBaseUI() then
		arg2_12()

		return
	end

	arg0_12:SearchUI(arg1_12:GetBaseUI(), function(arg0_13)
		if not arg0_13 then
			pg.NewGuideMgr.GetInstance():Stop()

			return
		end

		arg2_12()
	end)
end

local function var1_0(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetComponent(typeof(Image))

	return not (IsNil(var0_14.sprite) or arg1_14 and var0_14.sprite.name == arg1_14)
end

function var0_0.CheckSprite(arg0_15, arg1_15, arg2_15)
	if not arg1_15:ShouldCheckSpriteUI() then
		arg2_15()

		return
	end

	local var0_15 = arg1_15:GetSpriteUI()

	arg0_15:SearchUI(var0_15, function(arg0_16)
		if not arg0_16 then
			pg.NewGuideMgr.GetInstance():Stop()

			return
		end

		local var0_16 = var0_15.childPath and arg0_16:Find(var0_15.childPath) or arg0_16

		arg0_15:ClearSpriteTimer()

		local var1_16 = 0
		local var2_16 = 10

		arg0_15.spriteTimer = Timer.New(function()
			var1_16 = var1_16 + 1

			if var1_16 == var2_16 then
				arg0_15:ClearSpriteTimer()

				return
			end

			if var1_0(var0_16, var0_15.defaultName) then
				arg0_15:ClearSpriteTimer()
				arg2_15()
			end
		end, 0.5, -1)

		arg0_15.spriteTimer:Start()
	end)
end

function var0_0.ClearSpriteTimer(arg0_18)
	if arg0_18.spriteTimer then
		arg0_18.spriteTimer:Stop()

		arg0_18.spriteTimer = nil
	end
end

function var0_0.UpdateStyle(arg0_19, arg1_19)
	arg0_19.bgCg.alpha = arg1_19:GetAlpha()
end

function var0_0.DoDelay(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg1_20:GetDelay()

	if var0_20 <= 0 then
		arg2_20()

		return
	end

	arg0_20.delayTimer = Timer.New(arg2_20, var0_20, 1)

	arg0_20.delayTimer:Start()
end

function var0_0.OnSceneEnter(arg0_21)
	if arg0_21.waitSceneData and pg.NewGuideMgr.GetInstance():ExistScene(arg0_21.waitSceneData.sceneName) then
		arg0_21:ClearWaitUntilSceneTimer()
		arg0_21.waitSceneData.callback()

		arg0_21.waitSceneData = nil
	end
end

function var0_0.WaitUntilSceneEnter(arg0_22, arg1_22, arg2_22)
	if not arg1_22:ShouldWaitScene() then
		arg2_22()

		return
	end

	arg0_22:ClearWaitUntilSceneTimer()

	local var0_22 = arg1_22:GetWaitScene()

	if pg.NewGuideMgr.GetInstance():ExistScene(var0_22) then
		arg2_22()
	else
		arg0_22.waitSceneData = {
			sceneName = var0_22,
			callback = arg2_22
		}

		arg0_22:AddWaitUntilSceneTimer()
	end
end

function var0_0.AddWaitUntilSceneTimer(arg0_23)
	arg0_23.waitUntilSceneTimer = Timer.New(function()
		arg0_23:ClearWaitUntilSceneTimer()
		pg.NewGuideMgr.GetInstance():Stop()
	end, 10, 1)

	arg0_23.waitUntilSceneTimer:Start()
end

function var0_0.ClearWaitUntilSceneTimer(arg0_25)
	if arg0_25.waitUntilSceneTimer then
		arg0_25.waitUntilSceneTimer:Stop()

		arg0_25.waitUntilSceneTimer = nil
	end
end

function var0_0.ShowDialogueWindow(arg0_26, arg1_26, arg2_26)
	if not arg1_26:ShouldShowDialogue() then
		arg0_26:HideDialogueWindows()
		arg2_26()

		return
	end

	local var0_26 = {}
	local var1_26 = arg1_26:GetDialogueType()

	if not arg0_26.dialogueWindows[var1_26] then
		table.insert(var0_26, function(arg0_27)
			arg0_26:LoadDialogueWindow(var1_26, arg0_27)
		end)
	end

	table.insert(var0_26, function(arg0_28)
		local var0_28 = arg0_26.dialogueWindows[var1_26]

		arg0_26:UpdateDialogue(arg1_26, var0_28, arg0_28)
	end)
	seriesAsync(var0_26, arg2_26)
end

function var0_0.UpdateDialogue(arg0_29, arg1_29, arg2_29, arg3_29)
	arg0_29:ActiveDialogueWindow(arg2_29)

	local var0_29 = arg1_29:GetStyleData()

	setText(arg2_29:Find("content"), var0_29.text)

	arg2_29.localScale = var0_29.scale
	arg2_29.localPosition = var0_29.position
	arg2_29:Find("content").localScale = var0_29.scale

	local var1_29 = arg2_29:Find("hand")

	if not IsNil(var1_29) then
		var1_29.localPosition = var0_29.handPosition
		var1_29.eulerAngles = var0_29.handAngle
	end

	local var2_29 = var0_29.counsellor

	if var2_29 then
		seriesAsync({
			function(arg0_30)
				arg0_29:LoadCounsellor(var2_29.name, arg0_30)
			end,
			function(arg0_31)
				local var0_31 = arg0_29.counsellors[var2_29.name]

				setActive(var0_31, true)

				var0_31.localPosition = arg2_29.localPosition + Vector3(var2_29.position.x, var2_29.position.y, 0)
				var0_31.localScale = Vector3(var2_29.scale.x, var2_29.scale.y, 1)

				arg0_31()
			end
		}, arg3_29)
	else
		for iter0_29, iter1_29 in pairs(arg0_29.counsellors) do
			setActive(iter1_29, false)
		end

		arg3_29()
	end
end

function var0_0.LoadCounsellor(arg0_32, arg1_32, arg2_32)
	if not arg0_32.counsellors[arg1_32] then
		ResourceMgr.Inst:getAssetAsync("guideitem/" .. arg1_32, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_33)
			if IsNil(arg0_33) then
				return
			end

			local var0_33 = Object.Instantiate(arg0_33, arg0_32.charContainer)

			arg0_32.counsellors[arg1_32] = var0_33.transform

			arg2_32()
		end), true, true)
	else
		arg2_32()
	end
end

function var0_0.LoadDialogueWindow(arg0_34, arg1_34, arg2_34)
	ResourceMgr.Inst:getAssetAsync("guideitem/window_" .. arg1_34, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_35)
		if IsNil(arg0_35) then
			return
		end

		local var0_35 = Object.Instantiate(arg0_35, arg0_34.windowContainer)

		arg0_34.dialogueWindows[arg1_34] = var0_35.transform

		if arg2_34 then
			arg2_34()
		end
	end), true, true)
end

function var0_0.ActiveDialogueWindow(arg0_36, arg1_36)
	for iter0_36, iter1_36 in pairs(arg0_36.dialogueWindows) do
		setActive(iter1_36, iter1_36 == arg1_36)
	end
end

function var0_0.HideDialogueWindows(arg0_37)
	for iter0_37, iter1_37 in pairs(arg0_37.dialogueWindows) do
		setActive(iter1_37, false)
	end
end

local function var2_0(arg0_38, arg1_38, arg2_38, arg3_38)
	if arg3_38.type == GuideStep.HIGH_TYPE_GAMEOBJECT then
		arg0_38.uiDuplicator:Duplicate(arg2_38, {
			clearAllEvent = true
		})
	elseif arg3_38.type == GuideStep.HIGH_TYPE_LINE then
		local var0_38 = arg2_38.rect
		local var1_38 = arg0_38._tf:InverseTransformPoint(arg2_38.position)

		arg0_38.uiLoader:LoadHighLightArea({
			position = Vector3(var1_38.x, var1_38.y, 0) + Vector3(var0_38.x, var0_38.y, 0),
			size = Vector2(var0_38.width, var0_38.height),
			length = arg1_38:GetHighlightLength(),
			name = arg1_38:GetHighlightName()
		})
	end
end

function var0_0.UpdateHighLight(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg1_39:GetHighLightTarget()

	if #var0_39 <= 0 then
		arg2_39()

		return
	end

	local var1_39 = {}

	for iter0_39, iter1_39 in ipairs(var0_39) do
		table.insert(var1_39, function(arg0_40)
			arg0_39:SearchUI(iter1_39, function(arg0_41)
				if not arg0_41 then
					pg.NewGuideMgr.GetInstance():Stop()

					return
				end

				var2_0(arg0_39, arg1_39, arg0_41, iter1_39)
				arg0_40()
			end)
		end)
	end

	parallelAsync(var1_39, arg2_39)
end

function var0_0.SearchUI(arg0_42, arg1_42, arg2_42)
	arg0_42.uiFinder:Search({
		path = arg1_42.path,
		delay = arg1_42.delay,
		childIndex = arg1_42.pathIndex,
		conditionData = arg1_42.conditionData,
		callback = arg2_42
	})
end

function var0_0.SearchWithoutDelay(arg0_43, arg1_43, arg2_43)
	arg0_43.uiFinder:SearchWithoutDelay({
		path = arg1_43.path,
		delay = arg1_43.delay,
		childIndex = arg1_43.pathIndex,
		conditionData = arg1_43.conditionData,
		callback = arg2_43
	})
end

function var0_0.RegisterEvent(arg0_44, arg1_44, arg2_44)
	if arg1_44:ExistTrigger() then
		removeOnButton(arg0_44._tf)
		arg2_44()

		return
	end

	onButton(pg.NewGuideMgr.GetInstance(), arg0_44._tf, function()
		if arg1_44:ShouldGoScene() then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE[arg1_44.sceneName])
			arg2_44()
		elseif arg1_44:ShouldTriggerOtherTarget() then
			arg0_44:SearchUI(arg1_44:GetOtherTriggerTarget(), function(arg0_46)
				triggerButton(arg0_46)
				arg2_44()
			end)
		else
			arg2_44()
		end
	end, SFX_PANEL)
end

function var0_0.NextOne(arg0_47)
	triggerButton(arg0_47._tf)
end

function var0_0.HideCounsellors(arg0_48)
	for iter0_48, iter1_48 in pairs(arg0_48.counsellors) do
		setActive(iter1_48, false)
	end
end

function var0_0.Clear(arg0_49)
	arg0_49:HideCounsellors()
	arg0_49:HideDialogueWindows()
	arg0_49:ClearSpriteTimer()
	removeOnButton(arg0_49._tf)
	arg0_49:OnClear()

	if arg0_49.delayTimer then
		arg0_49.delayTimer:Stop()

		arg0_49.delayTimer = nil
	end

	arg0_49.uiFinder:Clear()
	arg0_49.uiDuplicator:Clear()
	arg0_49.uiLoader:Clear()
end

function var0_0.OnExecution(arg0_50, arg1_50, arg2_50)
	arg2_50()
end

function var0_0.OnClear(arg0_51)
	return
end

return var0_0
