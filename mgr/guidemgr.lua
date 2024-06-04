pg = pg or {}
pg.GuideMgr = singletonClass("GuideMgr")

local var0 = pg.GuideMgr

var0.ENABLE_GUIDE = true
var0.MANAGER_STATE = {
	IDLE = 1,
	BUSY = 2,
	LOADING = 0,
	BREAK = 4,
	STOP = 3
}

local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 5
local var6 = {
	MODE1 = 1,
	MODE2 = 2
}

function var0.Init(arg0, arg1)
	print("initializing guide manager...")

	arg0.managerState = var0.MANAGER_STATE.LOADING
	arg0.sceneStore = {}
	arg0.uisetGos = {}

	PoolMgr.GetInstance():GetUI("GuideUI", true, function(arg0)
		arg0._go = arg0
		arg0._tf = arg0._go.transform

		arg0._go:SetActive(false)

		arg0.UIOverlay = tf(GameObject.Find("Overlay/UIOverlay"))

		arg0._go.transform:SetParent(arg0.UIOverlay, false)

		arg0.guiderTF = findTF(arg0._go, "Guider")
		arg0.styleTF1 = findTF(arg0.guiderTF, "mode1")
		arg0.styleTF2 = findTF(arg0.guiderTF, "mode2")
		arg0.initChatBgH = arg0.styleTF2.sizeDelta.y

		SetActive(arg0.guiderTF, false)

		arg0._bg = findTF(arg0._go, "BG")
		arg0.bgAlpha = arg0._bg:GetComponent(typeof(CanvasGroup))
		arg0.bgAlpha.alpha = 0.2
		arg0._closeBtn = arg0._bg:Find("close_btn")
		arg0.uiLongPress = GetOrAddComponent(arg0._closeBtn, typeof(UILongPressTrigger))
		arg0.uiLongPress.longPressThreshold = 10
		arg0.fingerTF = findTF(arg0._go, "finger")

		SetActive(arg0.fingerTF, false)

		arg0._signRes = findTF(arg0._go, "signRes")
		arg0.signPool = {}
		arg0.curSignList = {}
		arg0.fingerSprites = {}

		eachChild(findTF(arg0._go, "resources"), function(arg0)
			local var0 = arg0:GetComponent(typeof(Image)).sprite

			table.insert(arg0.fingerSprites, var0)
		end)

		arg0.sceneFunc = nil
		arg0.inited = true
		arg0.finder = arg0:Finder()
		arg0.managerState = var0.MANAGER_STATE.IDLE
		arg0.chars = {
			arg0.styleTF1:Find("char"):GetComponent(typeof(Image)).sprite,
			GetSpriteFromAtlas("ui/guide_atlas", "guide1"),
			GetSpriteFromAtlas("ui/share/guider_atlas", "amazon")
		}
		arg0.material = arg0._tf:Find("resources/material"):GetComponent(typeof(Image)).material

		arg1()
	end)
end

function var0.isRuning(arg0)
	return arg0.managerState == var0.MANAGER_STATE.BUSY
end

function var0.transformPos(arg0, arg1)
	return tf(arg0._go):InverseTransformPoint(arg1)
end

function var0.canPlay(arg0)
	if pg.MsgboxMgr.GetInstance()._go.activeSelf then
		return false, 1
	end

	if pg.NewStoryMgr.GetInstance():IsRunning() then
		return false, 2
	end

	if arg0.managerState == var0.MANAGER_STATE.BUSY then
		return false, 3
	end

	return true
end

function var0.onSceneAnimDone(arg0, arg1)
	if not arg0.inited then
		return
	end

	if not table.contains(arg0.sceneStore, arg1.view) then
		table.insert(arg0.sceneStore, arg1.view)
	end

	if arg0.sceneFunc then
		arg0.sceneFunc(arg1.view)
	end
end

function var0.onSceneExit(arg0, arg1)
	if not arg0.inited then
		return
	end

	if table.contains(arg0.sceneStore, arg1.view) then
		table.removebyvalue(arg0.sceneStore, arg1.view)
	end
end

function var0.checkModuleOpen(arg0, arg1)
	return table.contains(arg0.sceneStore, arg1)
end

function var0.isPlayed(arg0, arg1)
	return pg.NewStoryMgr.GetInstance():IsPlayed(arg1)
end

function var0.play(arg0, arg1, arg2, arg3, arg4)
	if not var0.ENABLE_GUIDE then
		return
	end

	local var0, var1 = arg0:canPlay()

	originalPrint("play guide >>", arg1, var0)

	arg0.erroCallback = arg4

	if var0 then
		arg0.currentGuide = require("GameCfg.guide.newguide.segments." .. arg1)

		arg0:addDelegateInfo()

		local var2 = Clone(arg0.currentGuide.events)

		if arg2 then
			arg0.curEvents = _.select(var2, function(arg0)
				if not arg0.code then
					return true
				elseif type(arg0.code) == "table" then
					return _.any(arg2, function(arg0)
						return table.contains(arg0.code, arg0)
					end)
				else
					return table.contains(arg2, arg0.code)
				end
			end)
		else
			arg0.curEvents = var2
		end

		arg0:prepareGuider(arg3)

		local var3 = {}

		for iter0, iter1 in ipairs(arg0.curEvents or {}) do
			table.insert(var3, function(arg0)
				local var0 = function()
					if arg0.managerState ~= var0.MANAGER_STATE.IDLE then
						arg0.scenes = {}

						arg0()
					else
						arg0.erroCallback()

						arg0.erroCallback = nil
					end
				end

				arg0:doCurrEvent(iter1, var0)
			end)
		end

		arg0.managerState = var0.MANAGER_STATE.BUSY

		seriesAsync(var3, function()
			arg0:endGuider(arg3)
		end)
	elseif arg3 then
		arg3()
	end
end

function var0.prepareGuider(arg0, arg1)
	pg.m02:sendNotification(GAME.START_GUIDE)
	arg0._go.transform:SetAsLastSibling()
	arg0._go:SetActive(true)
	SetActive(arg0.fingerTF, false)

	arg0.bgAlpha.alpha = 0.2

	arg0.uiLongPress.onLongPressed:AddListener(function()
		arg0:endGuider(arg1)
	end)
end

function var0.doCurrEvent(arg0, arg1, arg2)
	local function var0(arg0)
		if arg1.waitScene and arg1.waitScene ~= "" and not table.contains(arg0.scenes, arg1.waitScene) then
			function arg0.sceneFunc(arg0)
				if arg1.waitScene == arg0 or table.contains(arg0.sceneStore, arg1.waitScene) then
					arg0.sceneFunc = nil

					arg0()
				end
			end

			arg0.sceneFunc()
		else
			arg0()
		end
	end

	local function var1()
		if arg1.hideui then
			arg0:hideUI(arg1, arg2)
		elseif arg1.stories then
			arg0:playStories(arg1, arg2)
		elseif arg1.notifies then
			arg0:sendNotifies(arg1, arg2)
		elseif arg1.showSign then
			arg0:showSign(arg1, arg2)
		elseif arg1.doFunc then
			arg1.doFunc()
			arg2()
		elseif arg1.doNothing then
			arg2()
		else
			arg0:findUI(arg1, arg2)
		end
	end

	if arg1.delay ~= nil then
		arg0.delayTimer = Timer.New(function()
			var0(var1)
		end, arg1.delay, 1)

		arg0.delayTimer:Start()
	else
		var0(var1)
	end
end

function var0.showSign(arg0, arg1, arg2)
	local var0 = arg1.showSign

	;(function()
		local var0 = var0.type
		local var1 = var0.duration
		local var2 = var0.simultaneously
		local var3 = var0.clickUI
		local var4 = var0.clickArea
		local var5 = var0.longPress
		local var6 = var0.signList
		local var7 = {}

		for iter0, iter1 in ipairs(var6) do
			local var8 = iter1.signType
			local var9 = iter1.pos
			local var10 = iter1.cachedIndex
			local var11 = arg0:getSign(var8, iter1)
			local var12 = #arg0.curSignList + 1

			arg0.curSignList[var12] = {
				signType = var8,
				sign = var11
			}

			if type(var9) == "string" then
				if var9 == "useCachePos" then
					var9 = WorldGuider.GetInstance():GetTempGridPos(var10)
				end
			elseif type(var9) == "table" then
				var9 = Vector3.New(var9[1], var9[2], var9[3])
			end

			if var9 then
				setLocalPosition(var11, var9)
			end

			var7[#var7 + 1] = var12
		end

		function recycle_handler()
			for iter0, iter1 in ipairs(var7) do
				local var0 = arg0.curSignList[iter1]

				arg0:recycleSign(var0.signType, var0.sign)

				arg0.curSignList[iter1] = nil
			end

			if not var2 then
				arg0:finishCurrEvent(arg1, arg2)
			end
		end

		local var13 = var7[1]
		local var14 = arg0.curSignList[var13].sign

		if var0 == 2 then
			arg0:updateUIStyle(arg1, false, nil)

			local var15 = findTF(var14, "btn")

			if var3 then
				setActive(var14, false)
				arg0.finder:Search({
					path = var3.path,
					delay = var3.delay,
					pathIndex = var3.pathIndex,
					conditionData = var3.conditionData,
					found = function(arg0)
						arg0.cloneTarget = arg0:cloneGO(go(arg0), arg0._tf, var3)

						setActive(arg0.cloneTarget, false)

						local var0 = Vector3(arg0.cloneTarget.sizeDelta.x * (arg0.cloneTarget.pivot.x - 0.5), arg0.cloneTarget.sizeDelta.y * (arg0.cloneTarget.pivot.y - 0.5), 0)

						var14.localPosition = arg0.cloneTarget.localPosition - var0

						if var3.sizeDeltaPlus then
							local var1 = Vector2(var3.sizeDeltaPlus[1], var3.sizeDeltaPlus[2])

							var15.sizeDelta = arg0.cloneTarget.sizeDelta + var1
						else
							var15.sizeDelta = arg0.cloneTarget.sizeDelta
						end

						setActive(var14, true)
					end,
					notFound = function()
						arg0:endGuider(arg2)
					end
				})
			elseif var4 then
				var15.sizeDelta = Vector2.New(var4[1], var4[2])
			end

			local var16 = GetOrAddComponent(var15, typeof(UILongPressTrigger))

			var16.onLongPressed:RemoveAllListeners()
			var16.onReleased:RemoveAllListeners()

			if var5 == 1 then
				var16.onLongPressed:AddListener(function()
					recycle_handler()
				end)
			else
				var16.onReleased:AddListener(function()
					recycle_handler()
				end)
			end
		elseif var0 == 3 then
			var14.sizeDelta = Vector2.New(var4[1], var4[2])

			arg0:updateUIStyle(arg1, true, arg2)
		else
			if var2 then
				arg0:finishCurrEvent(arg1, arg2)
			end

			if var1 ~= nil then
				arg0.curSignList[var13].signTimer = Timer.New(function()
					recycle_handler()
				end, var1, 1)

				arg0.curSignList[var13].signTimer:Start()
			end
		end
	end)()
end

function var0.getSign(arg0, arg1, arg2)
	local var0
	local var1
	local var2 = arg2.atlasName
	local var3 = arg2.fileName

	if arg0.signPool[arg1] ~= nil and #arg0.signPool[arg1] > 0 then
		var0 = table.remove(arg0.signPool[arg1], #arg0.signPool[arg1])
	else
		if arg1 == 1 or arg1 == 6 then
			var1 = findTF(arg0._signRes, "wTask")
		elseif arg1 == 2 then
			var1 = findTF(arg0._signRes, "wDanger")
		elseif arg1 == 3 then
			var1 = findTF(arg0._signRes, "wForbidden")
		elseif arg1 == 4 then
			var1 = findTF(arg0._signRes, "wClickArea")
		elseif arg1 == 5 then
			var1 = findTF(arg0._signRes, "wShowArea")
		end

		var0 = tf(Instantiate(var1))
	end

	if arg1 == 6 then
		local var4 = findTF(var0, "shadow")
		local var5 = LoadSprite(var2, var3)

		setImageSprite(var4, var5, true)
	end

	setActive(var0, true)
	setParent(var0, arg0._go.transform)

	var0.eulerAngles = Vector3(0, 0, 0)
	var0.localScale = Vector3.one

	return var0
end

function var0.recycleSign(arg0, arg1, arg2)
	if arg0.signPool[arg1] == nil then
		arg0.signPool[arg1] = {}
	end

	local var0 = arg0.signPool[arg1]

	if #var0 > 3 or arg1 == 6 then
		Destroy(arg2)
	else
		table.insert(var0, arg2)
		setParent(arg2, arg0._signRes)
		setActive(arg2, false)
	end
end

function var0.destroyAllSign(arg0)
	for iter0, iter1 in ipairs(arg0.curSignList) do
		if iter1.signTimer ~= nil then
			iter1.signTimer:Stop()

			iter1.signTimer = nil
		end

		arg0:recycleSign(iter1.signType, iter1.sign)

		arg0.curSignList[iter0] = nil
	end
end

function var0.sendNotifies(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1.notifies) do
		table.insert(var0, function(arg0)
			pg.m02:sendNotification(iter1.notify, iter1.body)
			arg0()
		end)
	end

	seriesAsync(var0, function()
		arg0:finishCurrEvent(arg1, arg2)
	end)
end

function var0.playStories(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1.stories) do
		table.insert(var0, function(arg0)
			pg.NewStoryMgr.GetInstance():Play(iter1, arg0, true)
		end)
	end

	seriesAsync(var0, function()
		arg0:finishCurrEvent(arg1, arg2)
		pg.m02:sendNotification(GAME.START_GUIDE)
	end)
end

function var0.hideUI(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1.hideui) do
		table.insert(var0, function(arg0)
			arg0.finder:SearchTimely({
				path = iter1.path,
				delay = iter1.delay,
				pathIndex = iter1.pathIndex,
				found = function(arg0)
					SetActive(arg0, not iter1.ishide)
					arg0()
				end,
				notFound = function()
					arg0:endGuider(arg2)
				end
			})
		end)
	end

	parallelAsync(var0, function()
		arg0:finishCurrEvent(arg1, arg2)
	end)
end

function var0.findUI(arg0, arg1, arg2)
	local var0 = true
	local var1 = {
		function(arg0)
			if not arg1.baseui then
				arg0()

				return
			end

			arg0.finder:Search({
				path = arg1.baseui.path,
				delay = arg1.baseui.delay,
				pathIndex = arg1.baseui.pathIndex,
				conditionData = arg1.baseui.conditionData,
				found = arg0,
				notFound = function()
					arg0:endGuider(arg2)
				end
			})
		end,
		function(arg0)
			if not arg1.spriteui then
				arg0()

				return
			end

			arg0:CheckSprite(arg1.spriteui, arg0, arg2)
		end,
		function(arg0)
			if not arg1.ui then
				arg0()

				return
			end

			var0 = false

			arg0.finder:Search({
				path = arg1.ui.path,
				delay = arg1.ui.delay,
				pathIndex = arg1.ui.pathIndex,
				conditionData = arg1.ui.conditionData,
				found = function(arg0)
					Canvas.ForceUpdateCanvases()

					arg0.cloneTarget = arg0:cloneGO(arg0.gameObject, arg0._go.transform, arg1.ui)

					arg0:addUIEventTrigger(arg0, arg1, arg2)
					arg0:setFinger(arg0, arg1.ui)
					arg0()
				end,
				notFound = function()
					if arg1.ui.notfoundSkip then
						arg0:finishCurrEvent(arg1, arg2)
					else
						arg0:endGuider(arg2)
					end
				end
			})
		end
	}

	seriesAsync(var1, function()
		arg0:updateUIStyle(arg1, var0, arg2)
	end)
end

function var0.CheckSprite(arg0, arg1, arg2, arg3)
	local var0
	local var1
	local var2 = 0
	local var3 = 10

	local function var4()
		var2 = var2 + 1

		arg0:RemoveCheckSpriteTimer()

		local var0 = var1:GetComponent(typeof(Image))

		if IsNil(var0.sprite) or arg1.defaultName and var0.sprite.name == arg1.defaultName then
			if var2 >= var3 then
				arg2()

				return
			end

			arg0.srpiteTimer = Timer.New(var4, 0.5, 1)

			arg0.srpiteTimer:Start()
		else
			arg2()
		end
	end

	arg0.finder:Search({
		path = arg1.path,
		delay = arg1.delay,
		pathIndex = arg1.pathIndex,
		conditionData = arg1.conditionData,
		found = function(arg0)
			if arg1.childPath then
				var1 = arg0:Find(arg1.childPath)
			else
				var1 = arg0
			end

			var4()
		end,
		notFound = function()
			arg0:endGuider(arg3)
		end
	})
end

function var0.RemoveCheckSpriteTimer(arg0)
	if arg0.srpiteTimer then
		arg0.srpiteTimer:Stop()

		arg0.srpiteTimer = nil
	end
end

function var0.SetHighLightLine(arg0, arg1)
	local var0 = arg0._tf:InverseTransformPoint(arg1.position)
	local var1 = cloneTplTo(findTF(arg0._signRes, "wShowArea"), arg0._tf)
	local var2 = 15

	var1.sizeDelta = Vector2(arg1.sizeDelta.x + var2, arg1.sizeDelta.y + var2)
	var1.pivot = arg1.pivot

	local var3 = (arg1.pivot.x - 0.5) * var2
	local var4 = (arg1.pivot.y - 0.5) * var2
	local var5 = Vector3(var3, var4, 0)

	var1.localPosition = Vector3(var0.x, var0.y, 0) + var5

	return var1
end

function var0.updateUIStyle(arg0, arg1, arg2, arg3)
	arg0.bgAlpha.alpha = arg1.alpha or 0.2

	SetActive(arg0.guiderTF, arg1.style)

	arg0.highLightLines = {}

	local function var0(arg0)
		if arg1.style.ui.lineMode then
			local var0 = arg0:SetHighLightLine(arg0)

			table.insert(arg0.highLightLines, var0)
		else
			arg0.cloneTarget = arg0:cloneGO(go(arg0), arg0._tf, arg1.style.ui)
		end
	end

	local function var1()
		onButton(arg0, arg0._go, function()
			if arg1.style and arg1.style.scene then
				arg0:finishCurrEvent(arg1, arg3)
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE[arg1.style.scene])
			elseif arg1.style.trigger then
				arg0.finder:Search({
					path = arg1.style.trigger.path,
					delay = arg1.style.trigger.delay,
					pathIndex = arg1.style.trigger.pathIndex,
					found = function(arg0)
						triggerButton(arg0)
						arg0:finishCurrEvent(arg1, arg3)
					end,
					notFound = function()
						arg0:endGuider()
					end
				})
			else
				arg0:finishCurrEvent(arg1, arg3)
			end
		end, SFX_PANEL)
		setButtonEnabled(arg0._go, arg2)
	end

	if arg1.style then
		arg0:updateContent(arg1)

		if arg1.style.ui then
			arg0.finder:Search({
				path = arg1.style.ui.path,
				delay = arg1.style.ui.delay,
				pathIndex = arg1.style.ui.pathIndex,
				found = var0,
				notFound = function()
					arg0:endGuider()
				end
			})
			var1()
		elseif arg1.style.uiset then
			local var2 = {}

			for iter0, iter1 in ipairs(arg1.style.uiset) do
				table.insert(var2, function(arg0)
					arg0.finder:Search({
						path = iter1.path,
						delay = iter1.delay,
						pathIndex = iter1.pathIndex,
						found = function(arg0)
							local var0
							local var1

							if arg1.style.lineMode then
								var1 = arg0:SetHighLightLine(arg0)
							else
								var0 = arg0:cloneGO(go(arg0), arg0._tf, iter1)
							end

							if var0 then
								table.insert(arg0.uisetGos, var0)
							end

							if var1 then
								table.insert(arg0.highLightLines, var1)
							end

							arg0()
						end,
						notFound = function()
							arg0:endGuider()
						end
					})
				end)
			end

			seriesAsync(var2, var1)
		else
			var1()
		end
	else
		var1()
	end
end

function var0.updateContent(arg0, arg1)
	local var0 = arg1.style or {}
	local var1 = var0.dir or 1
	local var2 = var0.mode or 1
	local var3 = var0.posX or 0
	local var4 = var0.posY or 0

	SetActive(arg0.styleTF1, var2 == var6.MODE1)
	SetActive(arg0.styleTF2, var2 == var6.MODE2)

	local var5
	local var6

	if var2 == var6.MODE1 then
		var5 = arg0.styleTF1
		var6 = Vector3(18, -31, 0)
	elseif var2 == var6.MODE2 then
		var5 = arg0.styleTF2
		var6 = Vector3(-27, 143, 0)

		local var7 = var0.windowbg == "3"
		local var8 = GetSpriteFromAtlas("ui/guide_atlas", "uibg" .. (var7 and var0.windowbg or "2"))

		var5:GetComponent(typeof(Image)).sprite = var8

		setAnchoredPosition(var5:Find("content"), {
			x = var7 and 0 or 17
		})
	end

	local var9 = var5:Find("char"):GetComponent(typeof(Image))
	local var10
	local var11 = var0.char and var0.char == "1" and 2 or var0.char and var0.char == "amazon" and 3 or 1
	local var12 = arg0.chars[var11]

	var9.sprite = var12

	var9:SetNativeSize()

	if var11 == 2 then
		var9.material = arg0.material
	else
		var9.material = nil
	end

	var9.gameObject.transform.pivot = getSpritePivot(var12)

	if var0.charPos then
		setAnchoredPosition(var9.gameObject.transform, {
			x = var0.charPos[1],
			y = var0.charPos[2]
		})
	else
		setAnchoredPosition(var9.gameObject.transform, {
			x = var6.x,
			y = var6.y
		})
	end

	if var0.charScale then
		var9.gameObject.transform.localScale = Vector3(var0.charScale[1], var0.charScale[2], 1)
	else
		var9.gameObject.transform.localScale = Vector3(1, 1, 1)
	end

	local var13 = var1 == 1 and Vector3(1, 1, 1) or Vector3(-1, 1, 1)

	var5.localScale = var13

	local var14 = var5:Find("content")

	var14.localScale = var13

	local var15 = var0.text or ""

	setText(var14, HXSet.hxLan(var15))

	local var16 = var14:GetComponent(typeof(Text))

	if #var16.text > CHAT_POP_STR_LEN_MIDDLE then
		var16.alignment = TextAnchor.MiddleLeft
	else
		var16.alignment = TextAnchor.MiddleCenter
	end

	local var17 = var16.preferredHeight + 120

	if var2 == var6.MODE2 and var17 > arg0.initChatBgH then
		var5.sizeDelta = Vector2.New(var5.sizeDelta.x, var17)
	else
		var5.sizeDelta = Vector2.New(var5.sizeDelta.x, arg0.initChatBgH)
	end

	if var2 == var6.MODE1 then
		local var18 = var0.hand or {
			w = 0,
			x = -267,
			y = -96
		}

		var5:Find("hand").localPosition = Vector3(var18.x, var18.y, 0)
		var5:Find("hand").eulerAngles = Vector3(0, 0, var18.w)
	end

	setAnchoredPosition(arg0.guiderTF, Vector2(var3, var4))
end

function var0.Finder(arg0)
	local var0 = {}

	local function var1(arg0, arg1)
		local var0 = -1

		for iter0 = 1, arg0.childCount do
			local var1 = arg0:GetChild(iter0 - 1):GetComponent(typeof(LayoutElement))

			if not var1 or not var1.ignoreLayout then
				var0 = var0 + 1

				if var0 == arg1 then
					break
				end
			end
		end

		return var0
	end

	local function var2(arg0, arg1)
		local var0 = GameObject.Find(arg0)

		if not IsNil(var0) then
			if arg1 and arg1 == -999 then
				local var1 = tf(var0).childCount

				for iter0 = 0, var1 do
					local var2 = tf(var0):GetChild(iter0)

					if not IsNil(var2) and go(var2).activeInHierarchy then
						return var2
					end
				end
			elseif arg1 and arg1 ~= -1 then
				local var3 = var1(tf(var0), arg1)

				if var3 >= 0 and var3 < tf(var0).childCount then
					local var4 = tf(var0):GetChild(var3)

					if not IsNil(var4) then
						return var4
					end
				end
			else
				return tf(var0)
			end
		end
	end

	local function var3(arg0, arg1)
		local var0 = var2(arg0, -1)

		if var0 ~= nil then
			for iter0, iter1 in ipairs(arg1) do
				local var1 = var0:Find(iter1)

				if var1 then
					return var1
				end
			end
		end
	end

	function var0.Search(arg0, arg1)
		local var0

		if type(arg1.path) == "function" then
			var0 = arg1.path()
		else
			var0 = arg1.path
		end

		arg0:Clear()

		local var1 = 0.5
		local var2 = 20
		local var3 = 0
		local var4 = arg1.delay or 0

		arg0.findUITimer = Timer.New(function()
			var3 = var3 + var1

			if pg.UIMgr.GetInstance():OnLoading() then
				return
			end

			if var3 > var4 then
				if var2 == 0 then
					originalPrint("not found ui >>", var0)
					arg0:Clear()
					arg1.notFound()

					return
				end

				local var0

				if arg1.conditionData ~= nil then
					var0 = var3(var0, arg1.conditionData)
				else
					var0 = var2(var0, arg1.pathIndex)
				end

				if var0 and go(var0).activeInHierarchy then
					arg0:Clear()
					arg1.found(var0)

					return
				end

				var2 = var2 - 1
			end
		end, var1, -1)

		arg0.findUITimer:Start()
		arg0.findUITimer.func()
	end

	function var0.SearchTimely(arg0, arg1)
		local var0

		if type(arg1.path) == "function" then
			var0 = arg1.path()
		else
			var0 = arg1.path
		end

		arg0:Clear()

		local var1 = var2(var0, arg1.pathIndex)

		if var1 then
			arg1.found(var1)
		else
			arg1.notFound()
		end
	end

	function var0.Clear(arg0)
		if arg0.findUITimer then
			arg0.findUITimer:Stop()

			arg0.findUITimer = nil
		end
	end

	return var0
end

function var0.cloneGO(arg0, arg1, arg2, arg3)
	local var0 = tf(Instantiate(arg1))

	var0.sizeDelta = tf(arg1).sizeDelta

	SetActive(var0, true)
	var0:SetParent(arg2, false)

	if arg3.hideChildEvent then
		eachChild(var0, function(arg0)
			local var0 = arg0:GetComponent(typeof(Button))

			if var0 then
				var0.enabled = false
			end
		end)
	end

	if arg3.hideAnimtor then
		local var1 = var0:GetComponent(typeof(Animator))

		if var1 then
			var1.enabled = false
		end
	end

	if arg3.childAdjust then
		for iter0, iter1 in ipairs(arg3.childAdjust) do
			local var2 = var0:Find(iter1[1])

			if LeanTween.isTweening(var2.gameObject) then
				LeanTween.cancel(var2.gameObject)
			end

			if var2 and iter1[2] == "scale" then
				var2.localScale = Vector3(iter1[3][1], iter1[3][2], iter1[3][3])
			elseif var2 and iter1[2] == "position" then
				var2.anchoredPosition = Vector3(iter1[3][1], iter1[3][2], iter1[3][3])
			end
		end
	end

	if arg0.targetTimer then
		arg0.targetTimer:Stop()

		arg0.targetTimer = nil
	end

	if not arg3.pos and not arg3.scale and not arg3.eulerAngles then
		arg0.targetTimer = Timer.New(function()
			if not IsNil(arg1) and not IsNil(var0) then
				var0.position = arg1.transform.position

				local var0 = var0.localPosition

				var0.localPosition = Vector3(var0.x, var0.y, 0)

				local var1 = arg1.transform.localScale

				var0.localScale = Vector3(var1.x, var1.y, var1.z)

				if arg3.image and type(arg3.image) == "table" then
					local var2

					if arg3.image.isChild then
						var2 = tf(arg1):Find(arg3.image.source)
					else
						var2 = GameObject.Find(arg3.image.source)
					end

					local var3 = arg3.image.isRelative
					local var4

					if var3 then
						if arg3.image.target == "" then
							var4 = var0
						else
							var4 = tf(var0):Find(arg3.image.target)
						end
					else
						var4 = GameObject.Find(arg3.image.target)
					end

					if not IsNil(var2) and not IsNil(var4) then
						local var5 = var2:GetComponent(typeof(Image))
						local var6 = var4:GetComponent(typeof(Image))

						if var5 and var6 then
							local var7 = var5.sprite
							local var8 = var6.sprite

							if var7 and var8 and var7 ~= var8 then
								var6.enabled = var5.enabled

								setImageSprite(var4, var7)
							end
						end
					end
				end
			end
		end, 0.01, -1)

		arg0.targetTimer:Start()
		arg0.targetTimer.func()
	else
		if arg3.pos then
			var0.localPosition = Vector3(arg3.pos.x, arg3.pos.y, arg3.pos.z or 0)
		elseif arg3.isLevelPoint then
			local var3 = GameObject.Find("LevelCamera"):GetComponent(typeof(Camera))
			local var4 = arg1.transform.parent:TransformPoint(arg1.transform.localPosition)
			local var5 = var3:WorldToScreenPoint(var4)
			local var6 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

			var0.localPosition = LuaHelper.ScreenToLocal(arg2, var5, var6)
		else
			var0.position = arg1.transform.position

			local var7 = var0.localPosition

			var0.localPosition = Vector3(var7.x, var7.y, 0)
		end

		local var8 = arg3.scale or 1

		var0.localScale = Vector3(var8, var8, var8)

		if arg3.eulerAngles then
			var0.eulerAngles = Vector3(arg3.eulerAngles[1], arg3.eulerAngles[2], arg3.eulerAngles[3])
		else
			var0.eulerAngles = Vector3(0, 0, 0)
		end
	end

	return var0
end

function var0.setFinger(arg0, arg1, arg2)
	SetActive(arg0.fingerTF, not arg2.fingerPos or not arg2.fingerPos.hideFinger)

	local var0 = arg1.sizeDelta.x / 2
	local var1 = arg1.sizeDelta.y / 2
	local var2 = arg2.scale and 1 / arg2.scale or 1

	arg0.fingerTF.localScale = Vector3(var2, var2, 1)

	local var3 = arg2.fingerPos and Vector3(arg2.fingerPos.posX, arg2.fingerPos.posY, 0) or Vector3(var0, -var1, 0)

	if arg0.cloneTarget then
		arg0.fingerTF:SetParent(arg0.cloneTarget, false)
	end

	setAnchoredPosition(arg0.fingerTF, var3)
end

function var0.addUIEventTrigger(arg0, arg1, arg2, arg3)
	local var0 = arg2.ui
	local var1 = arg1
	local var2 = arg0.cloneTarget
	local var3 = var2:GetComponent(typeof(CanvasGroup))

	if var3 then
		var3.alpha = 1
	end

	if var0.eventIndex then
		var1 = arg1:GetChild(var0.eventIndex)
		var2 = arg0.cloneTarget:GetChild(var0.eventIndex)
	elseif var0.eventPath then
		var1 = GameObject.Find(var0.eventPath)

		if IsNil(var1) then
			var1 = arg1
		end

		if arg0.cloneTarget:GetComponent(typeof(Image)) == nil then
			GetOrAddComponent(arg0.cloneTarget, typeof(Image)).color = Color(1, 1, 1, 0)
		end
	end

	local var4 = var0.triggerType and var0.triggerType[1] or var1

	if var4 == var1 then
		onButton(arg0, var2, function()
			if not IsNil(var1) then
				arg0:finishCurrEvent(arg2, arg3)

				if var0.onClick then
					var0.onClick()
				else
					triggerButton(var1)
				end
			end
		end, SFX_PANEL)
		setButtonEnabled(var2, true)
	elseif var4 == var2 then
		onToggle(arg0, var2, function(arg0)
			if IsNil(var1) then
				return
			end

			arg0:finishCurrEvent(arg2, arg3)

			if var0.triggerType[2] ~= nil then
				triggerToggle(var1, var0.triggerType[2])
			else
				triggerToggle(var1, true)
			end
		end, SFX_PANEL)
		setToggleEnabled(var2, true)
	elseif var4 == var3 then
		local var5 = var1:GetComponent(typeof(EventTriggerListener))
		local var6 = var2:GetComponent(typeof(EventTriggerListener))

		var6:AddPointDownFunc(function(arg0, arg1)
			if not IsNil(var1) then
				var5:OnPointerDown(arg1)
			end
		end)
		var6:AddPointUpFunc(function(arg0, arg1)
			arg0:finishCurrEvent(arg2, arg3)

			if not IsNil(var1) then
				var5:OnPointerUp(arg1)
			end
		end)
	elseif var4 == var4 then
		local var7 = var2:GetComponent(typeof(EventTriggerListener))

		if var7 == nil then
			var7 = go(var2):AddComponent(typeof(EventTriggerListener))
		end

		var7:AddPointDownFunc(function(arg0, arg1)
			if not IsNil(var1) then
				arg0:finishCurrEvent(arg2, arg3)
			end
		end)
	elseif var4 == var5 then
		local var8 = var2:GetComponent(typeof(EventTriggerListener))

		if var8 == nil then
			var8 = go(var2):AddComponent(typeof(EventTriggerListener))
		end

		var8:AddPointUpFunc(function(arg0, arg1)
			arg0:finishCurrEvent(arg2, arg3)
		end)
	end
end

function var0.finishCurrEvent(arg0, arg1, arg2)
	arg0.bgAlpha.alpha = 0.2

	removeOnButton(arg0._go)
	arg0:destroyAllSign()
	SetParent(arg0.fingerTF, tf(arg0._go), false)
	SetActive(arg0.fingerTF, false)
	SetActive(arg0.guiderTF, false)

	arg0.fingerTF.localScale = Vector3(1, 1, 1)

	if arg0.cloneTarget then
		SetActive(arg0.cloneTarget, false)
		Destroy(arg0.cloneTarget)

		arg0.cloneTarget = nil
	end

	if #arg0.uisetGos > 0 then
		for iter0 = #arg0.uisetGos, 1, -1 do
			Destroy(arg0.uisetGos[iter0])

			arg0.uisetGos[iter0] = nil
		end

		arg0.uisetGos = {}
	end

	if arg0.targetTimer then
		arg0.targetTimer:Stop()

		arg0.targetTimer = nil
	end

	if arg0.findUITimer then
		arg0.findUITimer:Stop()

		arg0.findUITimer = nil
	end

	if arg0.highLightLines then
		for iter1, iter2 in ipairs(arg0.highLightLines) do
			Destroy(iter2)
		end

		arg0.highLightLines = {}
	end

	if arg2 then
		arg2()
	end
end

local function var7(arg0)
	arg0:clearDelegateInfo()
	arg0:RemoveCheckSpriteTimer()

	if arg0.delayTimer then
		arg0.delayTimer:Stop()

		arg0.delayTimer = nil
	end

	if arg0.targetTimer then
		arg0.targetTimer:Stop()

		arg0.targetTimer = nil
	end

	arg0:destroyAllSign()
	arg0.finder:Clear()

	if arg0.cloneTarget then
		SetParent(arg0.fingerTF, arg0._go)
		Destroy(arg0.cloneTarget)

		arg0.cloneTarget = nil
	end

	arg0._go:SetActive(false)
	removeOnButton(arg0._go)

	if arg0.curEvents then
		arg0.curEvents = nil
	end

	if arg0.currentGuide then
		arg0.currentGuide = nil
	end

	arg0.uiLongPress.onLongPressed:RemoveAllListeners()
end

function var0.addDelegateInfo(arg0)
	pg.DelegateInfo.New(arg0)

	arg0.isAddDelegateInfo = true
end

function var0.clearDelegateInfo(arg0)
	if arg0.isAddDelegateInfo then
		pg.DelegateInfo.Dispose(arg0)

		arg0.isAddDelegateInfo = nil
	end
end

function var0.mask(arg0)
	SetActive(arg0._go, true)
end

function var0.unMask(arg0)
	SetActive(arg0._go, false)
end

function var0.endGuider(arg0, arg1)
	var7(arg0)

	arg0.managerState = var0.MANAGER_STATE.IDLE

	pg.m02:sendNotification(GAME.END_GUIDE)

	if arg1 then
		arg1()
	end
end

function var0.onDisconnected(arg0)
	if arg0._go.activeSelf then
		arg0.prevState = arg0.managerState
		arg0.managerState = var0.MANAGER_STATE.BREAK

		SetActive(arg0._go, false)

		if arg0.cloneTarget then
			SetActive(arg0.cloneTarget, false)
		end
	end
end

function var0.onReconneceted(arg0)
	if arg0.prevState then
		arg0.managerState = arg0.prevState
		arg0.prevState = nil

		SetActive(arg0._go, true)

		if arg0.cloneTarget then
			SetActive(arg0.cloneTarget, true)
		end
	end
end
