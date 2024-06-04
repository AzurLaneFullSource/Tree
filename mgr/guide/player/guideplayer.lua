local var0 = class("GuidePlayer")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0.bgCg = arg1:Find("BG"):GetComponent(typeof(CanvasGroup))
	arg0.windowContainer = arg1:Find("windows")
	arg0.charContainer = arg1:Find("char")
	arg0.dialogueWindows = pg.NewGuideMgr.GetInstance().dialogueWindows
	arg0.counsellors = pg.NewGuideMgr.GetInstance().counsellors
	arg0.uiFinder = pg.NewGuideMgr.GetInstance().uiFinder
	arg0.uiDuplicator = pg.NewGuideMgr.GetInstance().uiDuplicator
	arg0.uiLoader = pg.NewGuideMgr.GetInstance().uiLoader
	arg0.root = arg1:Find("target")
end

function var0.Execute(arg0, arg1, arg2)
	seriesAsync({
		function(arg0)
			arg0:HideDialogueWindows()
			arg0:UpdateStyle(arg1)
			arg0:DoDelay(arg1, arg0)
		end,
		function(arg0)
			arg0:WaitUntilSceneEnter(arg1, arg0)
		end,
		function(arg0)
			arg0:CheckBaseUI(arg1, arg0)
		end,
		function(arg0)
			arg0:CheckSprite(arg1, arg0)
		end,
		function(arg0)
			arg0:ShowDialogueWindow(arg1, arg0)
		end,
		function(arg0)
			arg0:UpdateHighLight(arg1, arg0)
		end,
		function(arg0)
			arg0:OnExecution(arg1, arg0)
		end,
		function(arg0)
			arg0:RegisterEvent(arg1, arg0)
		end,
		function(arg0)
			arg0:Clear()
			arg0()
		end
	}, arg2)
end

function var0.CheckBaseUI(arg0, arg1, arg2)
	if not arg1:ShouldCheckBaseUI() then
		arg2()

		return
	end

	arg0:SearchUI(arg1:GetBaseUI(), function(arg0)
		if not arg0 then
			pg.NewGuideMgr.GetInstance():Stop()

			return
		end

		arg2()
	end)
end

local function var1(arg0, arg1)
	local var0 = arg0:GetComponent(typeof(Image))

	return not (IsNil(var0.sprite) or arg1 and var0.sprite.name == arg1)
end

function var0.CheckSprite(arg0, arg1, arg2)
	if not arg1:ShouldCheckSpriteUI() then
		arg2()

		return
	end

	local var0 = arg1:GetSpriteUI()

	arg0:SearchUI(var0, function(arg0)
		if not arg0 then
			pg.NewGuideMgr.GetInstance():Stop()

			return
		end

		local var0 = var0.childPath and arg0:Find(var0.childPath) or arg0

		arg0:ClearSpriteTimer()

		local var1 = 0
		local var2 = 10

		arg0.spriteTimer = Timer.New(function()
			var1 = var1 + 1

			if var1 == var2 then
				arg0:ClearSpriteTimer()

				return
			end

			if var1(var0, var0.defaultName) then
				arg0:ClearSpriteTimer()
				arg2()
			end
		end, 0.5, -1)

		arg0.spriteTimer:Start()
	end)
end

function var0.ClearSpriteTimer(arg0)
	if arg0.spriteTimer then
		arg0.spriteTimer:Stop()

		arg0.spriteTimer = nil
	end
end

function var0.UpdateStyle(arg0, arg1)
	arg0.bgCg.alpha = arg1:GetAlpha()
end

function var0.DoDelay(arg0, arg1, arg2)
	local var0 = arg1:GetDelay()

	if var0 <= 0 then
		arg2()

		return
	end

	arg0.delayTimer = Timer.New(arg2, var0, 1)

	arg0.delayTimer:Start()
end

function var0.OnSceneEnter(arg0)
	if arg0.waitSceneData and pg.NewGuideMgr.GetInstance():ExistScene(arg0.waitSceneData.sceneName) then
		arg0:ClearWaitUntilSceneTimer()
		arg0.waitSceneData.callback()

		arg0.waitSceneData = nil
	end
end

function var0.WaitUntilSceneEnter(arg0, arg1, arg2)
	if not arg1:ShouldWaitScene() then
		arg2()

		return
	end

	arg0:ClearWaitUntilSceneTimer()

	local var0 = arg1:GetWaitScene()

	if pg.NewGuideMgr.GetInstance():ExistScene(var0) then
		arg2()
	else
		arg0.waitSceneData = {
			sceneName = var0,
			callback = arg2
		}

		arg0:AddWaitUntilSceneTimer()
	end
end

function var0.AddWaitUntilSceneTimer(arg0)
	arg0.waitUntilSceneTimer = Timer.New(function()
		arg0:ClearWaitUntilSceneTimer()
		pg.NewGuideMgr.GetInstance():Stop()
	end, 10, 1)

	arg0.waitUntilSceneTimer:Start()
end

function var0.ClearWaitUntilSceneTimer(arg0)
	if arg0.waitUntilSceneTimer then
		arg0.waitUntilSceneTimer:Stop()

		arg0.waitUntilSceneTimer = nil
	end
end

function var0.ShowDialogueWindow(arg0, arg1, arg2)
	if not arg1:ShouldShowDialogue() then
		arg0:HideDialogueWindows()
		arg2()

		return
	end

	local var0 = {}
	local var1 = arg1:GetDialogueType()

	if not arg0.dialogueWindows[var1] then
		table.insert(var0, function(arg0)
			arg0:LoadDialogueWindow(var1, arg0)
		end)
	end

	table.insert(var0, function(arg0)
		local var0 = arg0.dialogueWindows[var1]

		arg0:UpdateDialogue(arg1, var0, arg0)
	end)
	seriesAsync(var0, arg2)
end

function var0.UpdateDialogue(arg0, arg1, arg2, arg3)
	arg0:ActiveDialogueWindow(arg2)

	local var0 = arg1:GetStyleData()

	setText(arg2:Find("content"), var0.text)

	arg2.localScale = var0.scale
	arg2.localPosition = var0.position
	arg2:Find("content").localScale = var0.scale

	local var1 = arg2:Find("hand")

	if not IsNil(var1) then
		var1.localPosition = var0.handPosition
		var1.eulerAngles = var0.handAngle
	end

	local var2 = var0.counsellor

	seriesAsync({
		function(arg0)
			arg0:LoadCounsellor(var2.name, arg0)
		end,
		function(arg0)
			local var0 = arg0.counsellors[var2.name]

			setActive(var0, true)

			var0.localPosition = arg2.localPosition + Vector3(var2.position.x, var2.position.y, 0)
			var0.localScale = Vector3(var2.scale.x, var2.scale.y, 1)

			arg0()
		end
	}, arg3)
end

function var0.LoadCounsellor(arg0, arg1, arg2)
	if not arg0.counsellors[arg1] then
		ResourceMgr.Inst:getAssetAsync("guideitem/" .. arg1, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if IsNil(arg0) then
				return
			end

			local var0 = Object.Instantiate(arg0, arg0.charContainer)

			arg0.counsellors[arg1] = var0.transform

			arg2()
		end), true, true)
	else
		arg2()
	end
end

function var0.LoadDialogueWindow(arg0, arg1, arg2)
	ResourceMgr.Inst:getAssetAsync("guideitem/window_" .. arg1, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if IsNil(arg0) then
			return
		end

		local var0 = Object.Instantiate(arg0, arg0.windowContainer)

		arg0.dialogueWindows[arg1] = var0.transform

		if arg2 then
			arg2()
		end
	end), true, true)
end

function var0.ActiveDialogueWindow(arg0, arg1)
	for iter0, iter1 in pairs(arg0.dialogueWindows) do
		setActive(iter1, iter1 == arg1)
	end
end

function var0.HideDialogueWindows(arg0)
	for iter0, iter1 in pairs(arg0.dialogueWindows) do
		setActive(iter1, false)
	end
end

local function var2(arg0, arg1, arg2, arg3)
	if arg3.type == GuideStep.HIGH_TYPE_GAMEOBJECT then
		arg0.uiDuplicator:Duplicate(arg2, {
			clearAllEvent = true
		})
	elseif arg3.type == GuideStep.HIGH_TYPE_LINE then
		local var0 = arg1.isWorld and 15 or 55
		local var1 = arg0._tf:InverseTransformPoint(arg2.position)
		local var2 = (arg2.pivot.x - 0.5) * var0
		local var3 = (arg2.pivot.y - 0.5) * var0
		local var4 = Vector2(arg2.sizeDelta.x + var0, arg2.sizeDelta.y + var0)

		arg0.uiLoader:LoadHighLightArea({
			position = Vector3(var1.x, var1.y, 0) + Vector3(var2, var3, 0),
			sizeDelta = var4,
			pivot = arg2.pivot,
			isWorld = arg1.isWorld
		})
	end
end

function var0.UpdateHighLight(arg0, arg1, arg2)
	local var0 = arg1:GetHighLightTarget()

	if #var0 <= 0 then
		arg2()

		return
	end

	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, function(arg0)
			arg0:SearchUI(iter1, function(arg0)
				if not arg0 then
					pg.NewGuideMgr.GetInstance():Stop()

					return
				end

				var2(arg0, arg1, arg0, iter1)
				arg0()
			end)
		end)
	end

	parallelAsync(var1, arg2)
end

function var0.SearchUI(arg0, arg1, arg2)
	arg0.uiFinder:Search({
		path = arg1.path,
		delay = arg1.delay,
		childIndex = arg1.pathIndex,
		conditionData = arg1.conditionData,
		callback = arg2
	})
end

function var0.SearchWithoutDelay(arg0, arg1, arg2)
	arg0.uiFinder:SearchWithoutDelay({
		path = arg1.path,
		delay = arg1.delay,
		childIndex = arg1.pathIndex,
		conditionData = arg1.conditionData,
		callback = arg2
	})
end

function var0.RegisterEvent(arg0, arg1, arg2)
	if arg1:ExistTrigger() then
		removeOnButton(arg0._tf)
		arg2()

		return
	end

	onButton(pg.NewGuideMgr.GetInstance(), arg0._tf, function()
		if arg1:ShouldGoScene() then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE[arg1.sceneName])
			arg2()
		elseif arg1:ShouldTriggerOtherTarget() then
			arg0:SearchUI(arg1:GetOtherTriggerTarget(), function(arg0)
				triggerButton(arg0)
				arg2()
			end)
		else
			arg2()
		end
	end, SFX_PANEL)
end

function var0.NextOne(arg0)
	triggerButton(arg0._tf)
end

function var0.HideCounsellors(arg0)
	for iter0, iter1 in pairs(arg0.counsellors) do
		setActive(iter1, false)
	end
end

function var0.Clear(arg0)
	arg0:HideCounsellors()
	arg0:HideDialogueWindows()
	arg0:ClearSpriteTimer()
	removeOnButton(arg0._tf)
	arg0:OnClear()

	if arg0.delayTimer then
		arg0.delayTimer:Stop()

		arg0.delayTimer = nil
	end

	arg0.uiFinder:Clear()
	arg0.uiDuplicator:Clear()
	arg0.uiLoader:Clear()
end

function var0.OnExecution(arg0, arg1, arg2)
	arg2()
end

function var0.OnClear(arg0)
	return
end

return var0
