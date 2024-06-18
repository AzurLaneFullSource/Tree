pg = pg or {}
pg.GuideMgr = singletonClass("GuideMgr")

local var0_0 = pg.GuideMgr

var0_0.ENABLE_GUIDE = true
var0_0.MANAGER_STATE = {
	IDLE = 1,
	BUSY = 2,
	LOADING = 0,
	BREAK = 4,
	STOP = 3
}

local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 5
local var6_0 = {
	MODE1 = 1,
	MODE2 = 2
}

function var0_0.Init(arg0_1, arg1_1)
	print("initializing guide manager...")

	arg0_1.managerState = var0_0.MANAGER_STATE.LOADING
	arg0_1.sceneStore = {}
	arg0_1.uisetGos = {}

	PoolMgr.GetInstance():GetUI("GuideUI", true, function(arg0_2)
		arg0_1._go = arg0_2
		arg0_1._tf = arg0_1._go.transform

		arg0_1._go:SetActive(false)

		arg0_1.UIOverlay = tf(GameObject.Find("Overlay/UIOverlay"))

		arg0_1._go.transform:SetParent(arg0_1.UIOverlay, false)

		arg0_1.guiderTF = findTF(arg0_1._go, "Guider")
		arg0_1.styleTF1 = findTF(arg0_1.guiderTF, "mode1")
		arg0_1.styleTF2 = findTF(arg0_1.guiderTF, "mode2")
		arg0_1.initChatBgH = arg0_1.styleTF2.sizeDelta.y

		SetActive(arg0_1.guiderTF, false)

		arg0_1._bg = findTF(arg0_1._go, "BG")
		arg0_1.bgAlpha = arg0_1._bg:GetComponent(typeof(CanvasGroup))
		arg0_1.bgAlpha.alpha = 0.2
		arg0_1._closeBtn = arg0_1._bg:Find("close_btn")
		arg0_1.uiLongPress = GetOrAddComponent(arg0_1._closeBtn, typeof(UILongPressTrigger))
		arg0_1.uiLongPress.longPressThreshold = 10
		arg0_1.fingerTF = findTF(arg0_1._go, "finger")

		SetActive(arg0_1.fingerTF, false)

		arg0_1._signRes = findTF(arg0_1._go, "signRes")
		arg0_1.signPool = {}
		arg0_1.curSignList = {}
		arg0_1.fingerSprites = {}

		eachChild(findTF(arg0_1._go, "resources"), function(arg0_3)
			local var0_3 = arg0_3:GetComponent(typeof(Image)).sprite

			table.insert(arg0_1.fingerSprites, var0_3)
		end)

		arg0_1.sceneFunc = nil
		arg0_1.inited = true
		arg0_1.finder = arg0_1:Finder()
		arg0_1.managerState = var0_0.MANAGER_STATE.IDLE
		arg0_1.chars = {
			arg0_1.styleTF1:Find("char"):GetComponent(typeof(Image)).sprite,
			GetSpriteFromAtlas("ui/guide_atlas", "guide1"),
			GetSpriteFromAtlas("ui/share/guider_atlas", "amazon")
		}
		arg0_1.material = arg0_1._tf:Find("resources/material"):GetComponent(typeof(Image)).material

		arg1_1()
	end)
end

function var0_0.isRuning(arg0_4)
	return arg0_4.managerState == var0_0.MANAGER_STATE.BUSY
end

function var0_0.transformPos(arg0_5, arg1_5)
	return tf(arg0_5._go):InverseTransformPoint(arg1_5)
end

function var0_0.canPlay(arg0_6)
	if pg.MsgboxMgr.GetInstance()._go.activeSelf then
		return false, 1
	end

	if pg.NewStoryMgr.GetInstance():IsRunning() then
		return false, 2
	end

	if arg0_6.managerState == var0_0.MANAGER_STATE.BUSY then
		return false, 3
	end

	return true
end

function var0_0.onSceneAnimDone(arg0_7, arg1_7)
	if not arg0_7.inited then
		return
	end

	if not table.contains(arg0_7.sceneStore, arg1_7.view) then
		table.insert(arg0_7.sceneStore, arg1_7.view)
	end

	if arg0_7.sceneFunc then
		arg0_7.sceneFunc(arg1_7.view)
	end
end

function var0_0.onSceneExit(arg0_8, arg1_8)
	if not arg0_8.inited then
		return
	end

	if table.contains(arg0_8.sceneStore, arg1_8.view) then
		table.removebyvalue(arg0_8.sceneStore, arg1_8.view)
	end
end

function var0_0.checkModuleOpen(arg0_9, arg1_9)
	return table.contains(arg0_9.sceneStore, arg1_9)
end

function var0_0.isPlayed(arg0_10, arg1_10)
	return pg.NewStoryMgr.GetInstance():IsPlayed(arg1_10)
end

function var0_0.play(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	if not var0_0.ENABLE_GUIDE then
		return
	end

	local var0_11, var1_11 = arg0_11:canPlay()

	originalPrint("play guide >>", arg1_11, var0_11)

	arg0_11.erroCallback = arg4_11

	if var0_11 then
		arg0_11.currentGuide = require("GameCfg.guide.newguide.segments." .. arg1_11)

		arg0_11:addDelegateInfo()

		local var2_11 = Clone(arg0_11.currentGuide.events)

		if arg2_11 then
			arg0_11.curEvents = _.select(var2_11, function(arg0_12)
				if not arg0_12.code then
					return true
				elseif type(arg0_12.code) == "table" then
					return _.any(arg2_11, function(arg0_13)
						return table.contains(arg0_12.code, arg0_13)
					end)
				else
					return table.contains(arg2_11, arg0_12.code)
				end
			end)
		else
			arg0_11.curEvents = var2_11
		end

		arg0_11:prepareGuider(arg3_11)

		local var3_11 = {}

		for iter0_11, iter1_11 in ipairs(arg0_11.curEvents or {}) do
			table.insert(var3_11, function(arg0_14)
				local function var0_14()
					if arg0_11.managerState ~= var0_0.MANAGER_STATE.IDLE then
						arg0_11.scenes = {}

						arg0_14()
					else
						arg0_11.erroCallback()

						arg0_11.erroCallback = nil
					end
				end

				arg0_11:doCurrEvent(iter1_11, var0_14)
			end)
		end

		arg0_11.managerState = var0_0.MANAGER_STATE.BUSY

		seriesAsync(var3_11, function()
			arg0_11:endGuider(arg3_11)
		end)
	elseif arg3_11 then
		arg3_11()
	end
end

function var0_0.prepareGuider(arg0_17, arg1_17)
	pg.m02:sendNotification(GAME.START_GUIDE)
	arg0_17._go.transform:SetAsLastSibling()
	arg0_17._go:SetActive(true)
	SetActive(arg0_17.fingerTF, false)

	arg0_17.bgAlpha.alpha = 0.2

	arg0_17.uiLongPress.onLongPressed:AddListener(function()
		arg0_17:endGuider(arg1_17)
	end)
end

function var0_0.doCurrEvent(arg0_19, arg1_19, arg2_19)
	local function var0_19(arg0_20)
		if arg1_19.waitScene and arg1_19.waitScene ~= "" and not table.contains(arg0_19.scenes, arg1_19.waitScene) then
			function arg0_19.sceneFunc(arg0_21)
				if arg1_19.waitScene == arg0_21 or table.contains(arg0_19.sceneStore, arg1_19.waitScene) then
					arg0_19.sceneFunc = nil

					arg0_20()
				end
			end

			arg0_19.sceneFunc()
		else
			arg0_20()
		end
	end

	local function var1_19()
		if arg1_19.hideui then
			arg0_19:hideUI(arg1_19, arg2_19)
		elseif arg1_19.stories then
			arg0_19:playStories(arg1_19, arg2_19)
		elseif arg1_19.notifies then
			arg0_19:sendNotifies(arg1_19, arg2_19)
		elseif arg1_19.showSign then
			arg0_19:showSign(arg1_19, arg2_19)
		elseif arg1_19.doFunc then
			arg1_19.doFunc()
			arg2_19()
		elseif arg1_19.doNothing then
			arg2_19()
		else
			arg0_19:findUI(arg1_19, arg2_19)
		end
	end

	if arg1_19.delay ~= nil then
		arg0_19.delayTimer = Timer.New(function()
			var0_19(var1_19)
		end, arg1_19.delay, 1)

		arg0_19.delayTimer:Start()
	else
		var0_19(var1_19)
	end
end

function var0_0.showSign(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg1_24.showSign

	;(function()
		local var0_25 = var0_24.type
		local var1_25 = var0_24.duration
		local var2_25 = var0_24.simultaneously
		local var3_25 = var0_24.clickUI
		local var4_25 = var0_24.clickArea
		local var5_25 = var0_24.longPress
		local var6_25 = var0_24.signList
		local var7_25 = {}

		for iter0_25, iter1_25 in ipairs(var6_25) do
			local var8_25 = iter1_25.signType
			local var9_25 = iter1_25.pos
			local var10_25 = iter1_25.cachedIndex
			local var11_25 = arg0_24:getSign(var8_25, iter1_25)
			local var12_25 = #arg0_24.curSignList + 1

			arg0_24.curSignList[var12_25] = {
				signType = var8_25,
				sign = var11_25
			}

			if type(var9_25) == "string" then
				if var9_25 == "useCachePos" then
					var9_25 = WorldGuider.GetInstance():GetTempGridPos(var10_25)
				end
			elseif type(var9_25) == "table" then
				var9_25 = Vector3.New(var9_25[1], var9_25[2], var9_25[3])
			end

			if var9_25 then
				setLocalPosition(var11_25, var9_25)
			end

			var7_25[#var7_25 + 1] = var12_25
		end

		function recycle_handler()
			for iter0_26, iter1_26 in ipairs(var7_25) do
				local var0_26 = arg0_24.curSignList[iter1_26]

				arg0_24:recycleSign(var0_26.signType, var0_26.sign)

				arg0_24.curSignList[iter1_26] = nil
			end

			if not var2_25 then
				arg0_24:finishCurrEvent(arg1_24, arg2_24)
			end
		end

		local var13_25 = var7_25[1]
		local var14_25 = arg0_24.curSignList[var13_25].sign

		if var0_25 == 2 then
			arg0_24:updateUIStyle(arg1_24, false, nil)

			local var15_25 = findTF(var14_25, "btn")

			if var3_25 then
				setActive(var14_25, false)
				arg0_24.finder:Search({
					path = var3_25.path,
					delay = var3_25.delay,
					pathIndex = var3_25.pathIndex,
					conditionData = var3_25.conditionData,
					found = function(arg0_27)
						arg0_24.cloneTarget = arg0_24:cloneGO(go(arg0_27), arg0_24._tf, var3_25)

						setActive(arg0_24.cloneTarget, false)

						local var0_27 = Vector3(arg0_24.cloneTarget.sizeDelta.x * (arg0_24.cloneTarget.pivot.x - 0.5), arg0_24.cloneTarget.sizeDelta.y * (arg0_24.cloneTarget.pivot.y - 0.5), 0)

						var14_25.localPosition = arg0_24.cloneTarget.localPosition - var0_27

						if var3_25.sizeDeltaPlus then
							local var1_27 = Vector2(var3_25.sizeDeltaPlus[1], var3_25.sizeDeltaPlus[2])

							var15_25.sizeDelta = arg0_24.cloneTarget.sizeDelta + var1_27
						else
							var15_25.sizeDelta = arg0_24.cloneTarget.sizeDelta
						end

						setActive(var14_25, true)
					end,
					notFound = function()
						arg0_24:endGuider(arg2_24)
					end
				})
			elseif var4_25 then
				var15_25.sizeDelta = Vector2.New(var4_25[1], var4_25[2])
			end

			local var16_25 = GetOrAddComponent(var15_25, typeof(UILongPressTrigger))

			var16_25.onLongPressed:RemoveAllListeners()
			var16_25.onReleased:RemoveAllListeners()

			if var5_25 == 1 then
				var16_25.onLongPressed:AddListener(function()
					recycle_handler()
				end)
			else
				var16_25.onReleased:AddListener(function()
					recycle_handler()
				end)
			end
		elseif var0_25 == 3 then
			var14_25.sizeDelta = Vector2.New(var4_25[1], var4_25[2])

			arg0_24:updateUIStyle(arg1_24, true, arg2_24)
		else
			if var2_25 then
				arg0_24:finishCurrEvent(arg1_24, arg2_24)
			end

			if var1_25 ~= nil then
				arg0_24.curSignList[var13_25].signTimer = Timer.New(function()
					recycle_handler()
				end, var1_25, 1)

				arg0_24.curSignList[var13_25].signTimer:Start()
			end
		end
	end)()
end

function var0_0.getSign(arg0_32, arg1_32, arg2_32)
	local var0_32
	local var1_32
	local var2_32 = arg2_32.atlasName
	local var3_32 = arg2_32.fileName

	if arg0_32.signPool[arg1_32] ~= nil and #arg0_32.signPool[arg1_32] > 0 then
		var0_32 = table.remove(arg0_32.signPool[arg1_32], #arg0_32.signPool[arg1_32])
	else
		if arg1_32 == 1 or arg1_32 == 6 then
			var1_32 = findTF(arg0_32._signRes, "wTask")
		elseif arg1_32 == 2 then
			var1_32 = findTF(arg0_32._signRes, "wDanger")
		elseif arg1_32 == 3 then
			var1_32 = findTF(arg0_32._signRes, "wForbidden")
		elseif arg1_32 == 4 then
			var1_32 = findTF(arg0_32._signRes, "wClickArea")
		elseif arg1_32 == 5 then
			var1_32 = findTF(arg0_32._signRes, "wShowArea")
		end

		var0_32 = tf(Instantiate(var1_32))
	end

	if arg1_32 == 6 then
		local var4_32 = findTF(var0_32, "shadow")
		local var5_32 = LoadSprite(var2_32, var3_32)

		setImageSprite(var4_32, var5_32, true)
	end

	setActive(var0_32, true)
	setParent(var0_32, arg0_32._go.transform)

	var0_32.eulerAngles = Vector3(0, 0, 0)
	var0_32.localScale = Vector3.one

	return var0_32
end

function var0_0.recycleSign(arg0_33, arg1_33, arg2_33)
	if arg0_33.signPool[arg1_33] == nil then
		arg0_33.signPool[arg1_33] = {}
	end

	local var0_33 = arg0_33.signPool[arg1_33]

	if #var0_33 > 3 or arg1_33 == 6 then
		Destroy(arg2_33)
	else
		table.insert(var0_33, arg2_33)
		setParent(arg2_33, arg0_33._signRes)
		setActive(arg2_33, false)
	end
end

function var0_0.destroyAllSign(arg0_34)
	for iter0_34, iter1_34 in ipairs(arg0_34.curSignList) do
		if iter1_34.signTimer ~= nil then
			iter1_34.signTimer:Stop()

			iter1_34.signTimer = nil
		end

		arg0_34:recycleSign(iter1_34.signType, iter1_34.sign)

		arg0_34.curSignList[iter0_34] = nil
	end
end

function var0_0.sendNotifies(arg0_35, arg1_35, arg2_35)
	local var0_35 = {}

	for iter0_35, iter1_35 in ipairs(arg1_35.notifies) do
		table.insert(var0_35, function(arg0_36)
			pg.m02:sendNotification(iter1_35.notify, iter1_35.body)
			arg0_36()
		end)
	end

	seriesAsync(var0_35, function()
		arg0_35:finishCurrEvent(arg1_35, arg2_35)
	end)
end

function var0_0.playStories(arg0_38, arg1_38, arg2_38)
	local var0_38 = {}

	for iter0_38, iter1_38 in ipairs(arg1_38.stories) do
		table.insert(var0_38, function(arg0_39)
			pg.NewStoryMgr.GetInstance():Play(iter1_38, arg0_39, true)
		end)
	end

	seriesAsync(var0_38, function()
		arg0_38:finishCurrEvent(arg1_38, arg2_38)
		pg.m02:sendNotification(GAME.START_GUIDE)
	end)
end

function var0_0.hideUI(arg0_41, arg1_41, arg2_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in ipairs(arg1_41.hideui) do
		table.insert(var0_41, function(arg0_42)
			arg0_41.finder:SearchTimely({
				path = iter1_41.path,
				delay = iter1_41.delay,
				pathIndex = iter1_41.pathIndex,
				found = function(arg0_43)
					SetActive(arg0_43, not iter1_41.ishide)
					arg0_42()
				end,
				notFound = function()
					arg0_41:endGuider(arg2_41)
				end
			})
		end)
	end

	parallelAsync(var0_41, function()
		arg0_41:finishCurrEvent(arg1_41, arg2_41)
	end)
end

function var0_0.findUI(arg0_46, arg1_46, arg2_46)
	local var0_46 = true
	local var1_46 = {
		function(arg0_47)
			if not arg1_46.baseui then
				arg0_47()

				return
			end

			arg0_46.finder:Search({
				path = arg1_46.baseui.path,
				delay = arg1_46.baseui.delay,
				pathIndex = arg1_46.baseui.pathIndex,
				conditionData = arg1_46.baseui.conditionData,
				found = arg0_47,
				notFound = function()
					arg0_46:endGuider(arg2_46)
				end
			})
		end,
		function(arg0_49)
			if not arg1_46.spriteui then
				arg0_49()

				return
			end

			arg0_46:CheckSprite(arg1_46.spriteui, arg0_49, arg2_46)
		end,
		function(arg0_50)
			if not arg1_46.ui then
				arg0_50()

				return
			end

			var0_46 = false

			arg0_46.finder:Search({
				path = arg1_46.ui.path,
				delay = arg1_46.ui.delay,
				pathIndex = arg1_46.ui.pathIndex,
				conditionData = arg1_46.ui.conditionData,
				found = function(arg0_51)
					Canvas.ForceUpdateCanvases()

					arg0_46.cloneTarget = arg0_46:cloneGO(arg0_51.gameObject, arg0_46._go.transform, arg1_46.ui)

					arg0_46:addUIEventTrigger(arg0_51, arg1_46, arg2_46)
					arg0_46:setFinger(arg0_51, arg1_46.ui)
					arg0_50()
				end,
				notFound = function()
					if arg1_46.ui.notfoundSkip then
						arg0_46:finishCurrEvent(arg1_46, arg2_46)
					else
						arg0_46:endGuider(arg2_46)
					end
				end
			})
		end
	}

	seriesAsync(var1_46, function()
		arg0_46:updateUIStyle(arg1_46, var0_46, arg2_46)
	end)
end

function var0_0.CheckSprite(arg0_54, arg1_54, arg2_54, arg3_54)
	local var0_54
	local var1_54
	local var2_54 = 0
	local var3_54 = 10

	local function var4_54()
		var2_54 = var2_54 + 1

		arg0_54:RemoveCheckSpriteTimer()

		local var0_55 = var1_54:GetComponent(typeof(Image))

		if IsNil(var0_55.sprite) or arg1_54.defaultName and var0_55.sprite.name == arg1_54.defaultName then
			if var2_54 >= var3_54 then
				arg2_54()

				return
			end

			arg0_54.srpiteTimer = Timer.New(var4_54, 0.5, 1)

			arg0_54.srpiteTimer:Start()
		else
			arg2_54()
		end
	end

	arg0_54.finder:Search({
		path = arg1_54.path,
		delay = arg1_54.delay,
		pathIndex = arg1_54.pathIndex,
		conditionData = arg1_54.conditionData,
		found = function(arg0_56)
			if arg1_54.childPath then
				var1_54 = arg0_56:Find(arg1_54.childPath)
			else
				var1_54 = arg0_56
			end

			var4_54()
		end,
		notFound = function()
			arg0_54:endGuider(arg3_54)
		end
	})
end

function var0_0.RemoveCheckSpriteTimer(arg0_58)
	if arg0_58.srpiteTimer then
		arg0_58.srpiteTimer:Stop()

		arg0_58.srpiteTimer = nil
	end
end

function var0_0.SetHighLightLine(arg0_59, arg1_59)
	local var0_59 = arg0_59._tf:InverseTransformPoint(arg1_59.position)
	local var1_59 = cloneTplTo(findTF(arg0_59._signRes, "wShowArea"), arg0_59._tf)
	local var2_59 = 15

	var1_59.sizeDelta = Vector2(arg1_59.sizeDelta.x + var2_59, arg1_59.sizeDelta.y + var2_59)
	var1_59.pivot = arg1_59.pivot

	local var3_59 = (arg1_59.pivot.x - 0.5) * var2_59
	local var4_59 = (arg1_59.pivot.y - 0.5) * var2_59
	local var5_59 = Vector3(var3_59, var4_59, 0)

	var1_59.localPosition = Vector3(var0_59.x, var0_59.y, 0) + var5_59

	return var1_59
end

function var0_0.updateUIStyle(arg0_60, arg1_60, arg2_60, arg3_60)
	arg0_60.bgAlpha.alpha = arg1_60.alpha or 0.2

	SetActive(arg0_60.guiderTF, arg1_60.style)

	arg0_60.highLightLines = {}

	local function var0_60(arg0_61)
		if arg1_60.style.ui.lineMode then
			local var0_61 = arg0_60:SetHighLightLine(arg0_61)

			table.insert(arg0_60.highLightLines, var0_61)
		else
			arg0_60.cloneTarget = arg0_60:cloneGO(go(arg0_61), arg0_60._tf, arg1_60.style.ui)
		end
	end

	local function var1_60()
		onButton(arg0_60, arg0_60._go, function()
			if arg1_60.style and arg1_60.style.scene then
				arg0_60:finishCurrEvent(arg1_60, arg3_60)
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE[arg1_60.style.scene])
			elseif arg1_60.style.trigger then
				arg0_60.finder:Search({
					path = arg1_60.style.trigger.path,
					delay = arg1_60.style.trigger.delay,
					pathIndex = arg1_60.style.trigger.pathIndex,
					found = function(arg0_64)
						triggerButton(arg0_64)
						arg0_60:finishCurrEvent(arg1_60, arg3_60)
					end,
					notFound = function()
						arg0_60:endGuider()
					end
				})
			else
				arg0_60:finishCurrEvent(arg1_60, arg3_60)
			end
		end, SFX_PANEL)
		setButtonEnabled(arg0_60._go, arg2_60)
	end

	if arg1_60.style then
		arg0_60:updateContent(arg1_60)

		if arg1_60.style.ui then
			arg0_60.finder:Search({
				path = arg1_60.style.ui.path,
				delay = arg1_60.style.ui.delay,
				pathIndex = arg1_60.style.ui.pathIndex,
				found = var0_60,
				notFound = function()
					arg0_60:endGuider()
				end
			})
			var1_60()
		elseif arg1_60.style.uiset then
			local var2_60 = {}

			for iter0_60, iter1_60 in ipairs(arg1_60.style.uiset) do
				table.insert(var2_60, function(arg0_67)
					arg0_60.finder:Search({
						path = iter1_60.path,
						delay = iter1_60.delay,
						pathIndex = iter1_60.pathIndex,
						found = function(arg0_68)
							local var0_68
							local var1_68

							if arg1_60.style.lineMode then
								var1_68 = arg0_60:SetHighLightLine(arg0_68)
							else
								var0_68 = arg0_60:cloneGO(go(arg0_68), arg0_60._tf, iter1_60)
							end

							if var0_68 then
								table.insert(arg0_60.uisetGos, var0_68)
							end

							if var1_68 then
								table.insert(arg0_60.highLightLines, var1_68)
							end

							arg0_67()
						end,
						notFound = function()
							arg0_60:endGuider()
						end
					})
				end)
			end

			seriesAsync(var2_60, var1_60)
		else
			var1_60()
		end
	else
		var1_60()
	end
end

function var0_0.updateContent(arg0_70, arg1_70)
	local var0_70 = arg1_70.style or {}
	local var1_70 = var0_70.dir or 1
	local var2_70 = var0_70.mode or 1
	local var3_70 = var0_70.posX or 0
	local var4_70 = var0_70.posY or 0

	SetActive(arg0_70.styleTF1, var2_70 == var6_0.MODE1)
	SetActive(arg0_70.styleTF2, var2_70 == var6_0.MODE2)

	local var5_70
	local var6_70

	if var2_70 == var6_0.MODE1 then
		var5_70 = arg0_70.styleTF1
		var6_70 = Vector3(18, -31, 0)
	elseif var2_70 == var6_0.MODE2 then
		var5_70 = arg0_70.styleTF2
		var6_70 = Vector3(-27, 143, 0)

		local var7_70 = var0_70.windowbg == "3"
		local var8_70 = GetSpriteFromAtlas("ui/guide_atlas", "uibg" .. (var7_70 and var0_70.windowbg or "2"))

		var5_70:GetComponent(typeof(Image)).sprite = var8_70

		setAnchoredPosition(var5_70:Find("content"), {
			x = var7_70 and 0 or 17
		})
	end

	local var9_70 = var5_70:Find("char"):GetComponent(typeof(Image))
	local var10_70
	local var11_70 = var0_70.char and var0_70.char == "1" and 2 or var0_70.char and var0_70.char == "amazon" and 3 or 1
	local var12_70 = arg0_70.chars[var11_70]

	var9_70.sprite = var12_70

	var9_70:SetNativeSize()

	if var11_70 == 2 then
		var9_70.material = arg0_70.material
	else
		var9_70.material = nil
	end

	var9_70.gameObject.transform.pivot = getSpritePivot(var12_70)

	if var0_70.charPos then
		setAnchoredPosition(var9_70.gameObject.transform, {
			x = var0_70.charPos[1],
			y = var0_70.charPos[2]
		})
	else
		setAnchoredPosition(var9_70.gameObject.transform, {
			x = var6_70.x,
			y = var6_70.y
		})
	end

	if var0_70.charScale then
		var9_70.gameObject.transform.localScale = Vector3(var0_70.charScale[1], var0_70.charScale[2], 1)
	else
		var9_70.gameObject.transform.localScale = Vector3(1, 1, 1)
	end

	local var13_70 = var1_70 == 1 and Vector3(1, 1, 1) or Vector3(-1, 1, 1)

	var5_70.localScale = var13_70

	local var14_70 = var5_70:Find("content")

	var14_70.localScale = var13_70

	local var15_70 = var0_70.text or ""

	setText(var14_70, HXSet.hxLan(var15_70))

	local var16_70 = var14_70:GetComponent(typeof(Text))

	if #var16_70.text > CHAT_POP_STR_LEN_MIDDLE then
		var16_70.alignment = TextAnchor.MiddleLeft
	else
		var16_70.alignment = TextAnchor.MiddleCenter
	end

	local var17_70 = var16_70.preferredHeight + 120

	if var2_70 == var6_0.MODE2 and var17_70 > arg0_70.initChatBgH then
		var5_70.sizeDelta = Vector2.New(var5_70.sizeDelta.x, var17_70)
	else
		var5_70.sizeDelta = Vector2.New(var5_70.sizeDelta.x, arg0_70.initChatBgH)
	end

	if var2_70 == var6_0.MODE1 then
		local var18_70 = var0_70.hand or {
			w = 0,
			x = -267,
			y = -96
		}

		var5_70:Find("hand").localPosition = Vector3(var18_70.x, var18_70.y, 0)
		var5_70:Find("hand").eulerAngles = Vector3(0, 0, var18_70.w)
	end

	setAnchoredPosition(arg0_70.guiderTF, Vector2(var3_70, var4_70))
end

function var0_0.Finder(arg0_71)
	local var0_71 = {}

	local function var1_71(arg0_72, arg1_72)
		local var0_72 = -1

		for iter0_72 = 1, arg0_72.childCount do
			local var1_72 = arg0_72:GetChild(iter0_72 - 1):GetComponent(typeof(LayoutElement))

			if not var1_72 or not var1_72.ignoreLayout then
				var0_72 = var0_72 + 1

				if var0_72 == arg1_72 then
					break
				end
			end
		end

		return var0_72
	end

	local function var2_71(arg0_73, arg1_73)
		local var0_73 = GameObject.Find(arg0_73)

		if not IsNil(var0_73) then
			if arg1_73 and arg1_73 == -999 then
				local var1_73 = tf(var0_73).childCount

				for iter0_73 = 0, var1_73 do
					local var2_73 = tf(var0_73):GetChild(iter0_73)

					if not IsNil(var2_73) and go(var2_73).activeInHierarchy then
						return var2_73
					end
				end
			elseif arg1_73 and arg1_73 ~= -1 then
				local var3_73 = var1_71(tf(var0_73), arg1_73)

				if var3_73 >= 0 and var3_73 < tf(var0_73).childCount then
					local var4_73 = tf(var0_73):GetChild(var3_73)

					if not IsNil(var4_73) then
						return var4_73
					end
				end
			else
				return tf(var0_73)
			end
		end
	end

	local function var3_71(arg0_74, arg1_74)
		local var0_74 = var2_71(arg0_74, -1)

		if var0_74 ~= nil then
			for iter0_74, iter1_74 in ipairs(arg1_74) do
				local var1_74 = var0_74:Find(iter1_74)

				if var1_74 then
					return var1_74
				end
			end
		end
	end

	function var0_71.Search(arg0_75, arg1_75)
		local var0_75

		if type(arg1_75.path) == "function" then
			var0_75 = arg1_75.path()
		else
			var0_75 = arg1_75.path
		end

		arg0_75:Clear()

		local var1_75 = 0.5
		local var2_75 = 20
		local var3_75 = 0
		local var4_75 = arg1_75.delay or 0

		arg0_75.findUITimer = Timer.New(function()
			var3_75 = var3_75 + var1_75

			if pg.UIMgr.GetInstance():OnLoading() then
				return
			end

			if var3_75 > var4_75 then
				if var2_75 == 0 then
					originalPrint("not found ui >>", var0_75)
					arg0_75:Clear()
					arg1_75.notFound()

					return
				end

				local var0_76

				if arg1_75.conditionData ~= nil then
					var0_76 = var3_71(var0_75, arg1_75.conditionData)
				else
					var0_76 = var2_71(var0_75, arg1_75.pathIndex)
				end

				if var0_76 and go(var0_76).activeInHierarchy then
					arg0_75:Clear()
					arg1_75.found(var0_76)

					return
				end

				var2_75 = var2_75 - 1
			end
		end, var1_75, -1)

		arg0_75.findUITimer:Start()
		arg0_75.findUITimer.func()
	end

	function var0_71.SearchTimely(arg0_77, arg1_77)
		local var0_77

		if type(arg1_77.path) == "function" then
			var0_77 = arg1_77.path()
		else
			var0_77 = arg1_77.path
		end

		arg0_77:Clear()

		local var1_77 = var2_71(var0_77, arg1_77.pathIndex)

		if var1_77 then
			arg1_77.found(var1_77)
		else
			arg1_77.notFound()
		end
	end

	function var0_71.Clear(arg0_78)
		if arg0_78.findUITimer then
			arg0_78.findUITimer:Stop()

			arg0_78.findUITimer = nil
		end
	end

	return var0_71
end

function var0_0.cloneGO(arg0_79, arg1_79, arg2_79, arg3_79)
	local var0_79 = tf(Instantiate(arg1_79))

	var0_79.sizeDelta = tf(arg1_79).sizeDelta

	SetActive(var0_79, true)
	var0_79:SetParent(arg2_79, false)

	if arg3_79.hideChildEvent then
		eachChild(var0_79, function(arg0_80)
			local var0_80 = arg0_80:GetComponent(typeof(Button))

			if var0_80 then
				var0_80.enabled = false
			end
		end)
	end

	if arg3_79.hideAnimtor then
		local var1_79 = var0_79:GetComponent(typeof(Animator))

		if var1_79 then
			var1_79.enabled = false
		end
	end

	if arg3_79.childAdjust then
		for iter0_79, iter1_79 in ipairs(arg3_79.childAdjust) do
			local var2_79 = var0_79:Find(iter1_79[1])

			if LeanTween.isTweening(var2_79.gameObject) then
				LeanTween.cancel(var2_79.gameObject)
			end

			if var2_79 and iter1_79[2] == "scale" then
				var2_79.localScale = Vector3(iter1_79[3][1], iter1_79[3][2], iter1_79[3][3])
			elseif var2_79 and iter1_79[2] == "position" then
				var2_79.anchoredPosition = Vector3(iter1_79[3][1], iter1_79[3][2], iter1_79[3][3])
			end
		end
	end

	if arg0_79.targetTimer then
		arg0_79.targetTimer:Stop()

		arg0_79.targetTimer = nil
	end

	if not arg3_79.pos and not arg3_79.scale and not arg3_79.eulerAngles then
		arg0_79.targetTimer = Timer.New(function()
			if not IsNil(arg1_79) and not IsNil(var0_79) then
				var0_79.position = arg1_79.transform.position

				local var0_81 = var0_79.localPosition

				var0_79.localPosition = Vector3(var0_81.x, var0_81.y, 0)

				local var1_81 = arg1_79.transform.localScale

				var0_79.localScale = Vector3(var1_81.x, var1_81.y, var1_81.z)

				if arg3_79.image and type(arg3_79.image) == "table" then
					local var2_81

					if arg3_79.image.isChild then
						var2_81 = tf(arg1_79):Find(arg3_79.image.source)
					else
						var2_81 = GameObject.Find(arg3_79.image.source)
					end

					local var3_81 = arg3_79.image.isRelative
					local var4_81

					if var3_81 then
						if arg3_79.image.target == "" then
							var4_81 = var0_79
						else
							var4_81 = tf(var0_79):Find(arg3_79.image.target)
						end
					else
						var4_81 = GameObject.Find(arg3_79.image.target)
					end

					if not IsNil(var2_81) and not IsNil(var4_81) then
						local var5_81 = var2_81:GetComponent(typeof(Image))
						local var6_81 = var4_81:GetComponent(typeof(Image))

						if var5_81 and var6_81 then
							local var7_81 = var5_81.sprite
							local var8_81 = var6_81.sprite

							if var7_81 and var8_81 and var7_81 ~= var8_81 then
								var6_81.enabled = var5_81.enabled

								setImageSprite(var4_81, var7_81)
							end
						end
					end
				end
			end
		end, 0.01, -1)

		arg0_79.targetTimer:Start()
		arg0_79.targetTimer.func()
	else
		if arg3_79.pos then
			var0_79.localPosition = Vector3(arg3_79.pos.x, arg3_79.pos.y, arg3_79.pos.z or 0)
		elseif arg3_79.isLevelPoint then
			local var3_79 = GameObject.Find("LevelCamera"):GetComponent(typeof(Camera))
			local var4_79 = arg1_79.transform.parent:TransformPoint(arg1_79.transform.localPosition)
			local var5_79 = var3_79:WorldToScreenPoint(var4_79)
			local var6_79 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

			var0_79.localPosition = LuaHelper.ScreenToLocal(arg2_79, var5_79, var6_79)
		else
			var0_79.position = arg1_79.transform.position

			local var7_79 = var0_79.localPosition

			var0_79.localPosition = Vector3(var7_79.x, var7_79.y, 0)
		end

		local var8_79 = arg3_79.scale or 1

		var0_79.localScale = Vector3(var8_79, var8_79, var8_79)

		if arg3_79.eulerAngles then
			var0_79.eulerAngles = Vector3(arg3_79.eulerAngles[1], arg3_79.eulerAngles[2], arg3_79.eulerAngles[3])
		else
			var0_79.eulerAngles = Vector3(0, 0, 0)
		end
	end

	return var0_79
end

function var0_0.setFinger(arg0_82, arg1_82, arg2_82)
	SetActive(arg0_82.fingerTF, not arg2_82.fingerPos or not arg2_82.fingerPos.hideFinger)

	local var0_82 = arg1_82.sizeDelta.x / 2
	local var1_82 = arg1_82.sizeDelta.y / 2
	local var2_82 = arg2_82.scale and 1 / arg2_82.scale or 1

	arg0_82.fingerTF.localScale = Vector3(var2_82, var2_82, 1)

	local var3_82 = arg2_82.fingerPos and Vector3(arg2_82.fingerPos.posX, arg2_82.fingerPos.posY, 0) or Vector3(var0_82, -var1_82, 0)

	if arg0_82.cloneTarget then
		arg0_82.fingerTF:SetParent(arg0_82.cloneTarget, false)
	end

	setAnchoredPosition(arg0_82.fingerTF, var3_82)
end

function var0_0.addUIEventTrigger(arg0_83, arg1_83, arg2_83, arg3_83)
	local var0_83 = arg2_83.ui
	local var1_83 = arg1_83
	local var2_83 = arg0_83.cloneTarget
	local var3_83 = var2_83:GetComponent(typeof(CanvasGroup))

	if var3_83 then
		var3_83.alpha = 1
	end

	if var0_83.eventIndex then
		var1_83 = arg1_83:GetChild(var0_83.eventIndex)
		var2_83 = arg0_83.cloneTarget:GetChild(var0_83.eventIndex)
	elseif var0_83.eventPath then
		var1_83 = GameObject.Find(var0_83.eventPath)

		if IsNil(var1_83) then
			var1_83 = arg1_83
		end

		if arg0_83.cloneTarget:GetComponent(typeof(Image)) == nil then
			GetOrAddComponent(arg0_83.cloneTarget, typeof(Image)).color = Color(1, 1, 1, 0)
		end
	end

	local var4_83 = var0_83.triggerType and var0_83.triggerType[1] or var1_0

	if var4_83 == var1_0 then
		onButton(arg0_83, var2_83, function()
			if not IsNil(var1_83) then
				arg0_83:finishCurrEvent(arg2_83, arg3_83)

				if var0_83.onClick then
					var0_83.onClick()
				else
					triggerButton(var1_83)
				end
			end
		end, SFX_PANEL)
		setButtonEnabled(var2_83, true)
	elseif var4_83 == var2_0 then
		onToggle(arg0_83, var2_83, function(arg0_85)
			if IsNil(var1_83) then
				return
			end

			arg0_83:finishCurrEvent(arg2_83, arg3_83)

			if var0_83.triggerType[2] ~= nil then
				triggerToggle(var1_83, var0_83.triggerType[2])
			else
				triggerToggle(var1_83, true)
			end
		end, SFX_PANEL)
		setToggleEnabled(var2_83, true)
	elseif var4_83 == var3_0 then
		local var5_83 = var1_83:GetComponent(typeof(EventTriggerListener))
		local var6_83 = var2_83:GetComponent(typeof(EventTriggerListener))

		var6_83:AddPointDownFunc(function(arg0_86, arg1_86)
			if not IsNil(var1_83) then
				var5_83:OnPointerDown(arg1_86)
			end
		end)
		var6_83:AddPointUpFunc(function(arg0_87, arg1_87)
			arg0_83:finishCurrEvent(arg2_83, arg3_83)

			if not IsNil(var1_83) then
				var5_83:OnPointerUp(arg1_87)
			end
		end)
	elseif var4_83 == var4_0 then
		local var7_83 = var2_83:GetComponent(typeof(EventTriggerListener))

		if var7_83 == nil then
			var7_83 = go(var2_83):AddComponent(typeof(EventTriggerListener))
		end

		var7_83:AddPointDownFunc(function(arg0_88, arg1_88)
			if not IsNil(var1_83) then
				arg0_83:finishCurrEvent(arg2_83, arg3_83)
			end
		end)
	elseif var4_83 == var5_0 then
		local var8_83 = var2_83:GetComponent(typeof(EventTriggerListener))

		if var8_83 == nil then
			var8_83 = go(var2_83):AddComponent(typeof(EventTriggerListener))
		end

		var8_83:AddPointUpFunc(function(arg0_89, arg1_89)
			arg0_83:finishCurrEvent(arg2_83, arg3_83)
		end)
	end
end

function var0_0.finishCurrEvent(arg0_90, arg1_90, arg2_90)
	arg0_90.bgAlpha.alpha = 0.2

	removeOnButton(arg0_90._go)
	arg0_90:destroyAllSign()
	SetParent(arg0_90.fingerTF, tf(arg0_90._go), false)
	SetActive(arg0_90.fingerTF, false)
	SetActive(arg0_90.guiderTF, false)

	arg0_90.fingerTF.localScale = Vector3(1, 1, 1)

	if arg0_90.cloneTarget then
		SetActive(arg0_90.cloneTarget, false)
		Destroy(arg0_90.cloneTarget)

		arg0_90.cloneTarget = nil
	end

	if #arg0_90.uisetGos > 0 then
		for iter0_90 = #arg0_90.uisetGos, 1, -1 do
			Destroy(arg0_90.uisetGos[iter0_90])

			arg0_90.uisetGos[iter0_90] = nil
		end

		arg0_90.uisetGos = {}
	end

	if arg0_90.targetTimer then
		arg0_90.targetTimer:Stop()

		arg0_90.targetTimer = nil
	end

	if arg0_90.findUITimer then
		arg0_90.findUITimer:Stop()

		arg0_90.findUITimer = nil
	end

	if arg0_90.highLightLines then
		for iter1_90, iter2_90 in ipairs(arg0_90.highLightLines) do
			Destroy(iter2_90)
		end

		arg0_90.highLightLines = {}
	end

	if arg2_90 then
		arg2_90()
	end
end

local function var7_0(arg0_91)
	arg0_91:clearDelegateInfo()
	arg0_91:RemoveCheckSpriteTimer()

	if arg0_91.delayTimer then
		arg0_91.delayTimer:Stop()

		arg0_91.delayTimer = nil
	end

	if arg0_91.targetTimer then
		arg0_91.targetTimer:Stop()

		arg0_91.targetTimer = nil
	end

	arg0_91:destroyAllSign()
	arg0_91.finder:Clear()

	if arg0_91.cloneTarget then
		SetParent(arg0_91.fingerTF, arg0_91._go)
		Destroy(arg0_91.cloneTarget)

		arg0_91.cloneTarget = nil
	end

	arg0_91._go:SetActive(false)
	removeOnButton(arg0_91._go)

	if arg0_91.curEvents then
		arg0_91.curEvents = nil
	end

	if arg0_91.currentGuide then
		arg0_91.currentGuide = nil
	end

	arg0_91.uiLongPress.onLongPressed:RemoveAllListeners()
end

function var0_0.addDelegateInfo(arg0_92)
	pg.DelegateInfo.New(arg0_92)

	arg0_92.isAddDelegateInfo = true
end

function var0_0.clearDelegateInfo(arg0_93)
	if arg0_93.isAddDelegateInfo then
		pg.DelegateInfo.Dispose(arg0_93)

		arg0_93.isAddDelegateInfo = nil
	end
end

function var0_0.mask(arg0_94)
	SetActive(arg0_94._go, true)
end

function var0_0.unMask(arg0_95)
	SetActive(arg0_95._go, false)
end

function var0_0.endGuider(arg0_96, arg1_96)
	var7_0(arg0_96)

	arg0_96.managerState = var0_0.MANAGER_STATE.IDLE

	pg.m02:sendNotification(GAME.END_GUIDE)

	if arg1_96 then
		arg1_96()
	end
end

function var0_0.onDisconnected(arg0_97)
	if arg0_97._go.activeSelf then
		arg0_97.prevState = arg0_97.managerState
		arg0_97.managerState = var0_0.MANAGER_STATE.BREAK

		SetActive(arg0_97._go, false)

		if arg0_97.cloneTarget then
			SetActive(arg0_97.cloneTarget, false)
		end
	end
end

function var0_0.onReconneceted(arg0_98)
	if arg0_98.prevState then
		arg0_98.managerState = arg0_98.prevState
		arg0_98.prevState = nil

		SetActive(arg0_98._go, true)

		if arg0_98.cloneTarget then
			SetActive(arg0_98.cloneTarget, true)
		end
	end
end
