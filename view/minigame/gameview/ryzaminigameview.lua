local var0 = class("RyzaMiniGameView", import("view.miniGame.BaseMiniGameView"))

var0.EVENT_CREATE = "RyzaMiniGameView.EVENT_CREATE"
var0.EVENT_DESTROY = "RyzaMiniGameView.EVENT_DESTROY"
var0.EVENT_FINISH = "RyzaMiniGameView.EVENT_FINISH"
var0.EVENT_WINDOW_FOCUS = "RyzaMiniGameView.EVENT_WINDOW_FOCUS"
var0.EVENT_STATUS_SYNC = "RyzaMiniGameView.EVENT_STATUS_SYNC"
var0.EVENT_UPDATE_HIDE = "RyzaMiniGameView.EVENT_UPDATE_HIDE"

function var0.getUIName(arg0)
	return "RyzaMiniGameUI"
end

function var0.didEnter(arg0)
	arg0:initTimer()
	arg0:initUI()
	arg0:initGameUI()
	onNextTick(function()
		arg0:openUI("main")
	end)
end

local function var1(arg0, arg1)
	local var0 = arg0:GetComponentsInChildren(typeof(Animator), true)

	for iter0 = 0, var0.Length - 1 do
		var0[iter0].speed = arg1
	end
end

function var0.openUI(arg0, arg1)
	if arg0.status then
		setActive(arg0.rtTitlePage:Find(arg0.status), false)
	end

	if arg1 then
		setActive(arg0.rtTitlePage:Find(arg1), true)
	end

	arg0.status = arg1

	switch(arg1, {
		main = function()
			arg0:updateMainUI()
		end,
		pause = function()
			arg0:pauseGame()
		end,
		exit = function()
			arg0:pauseGame()
		end,
		result = function()
			local var0 = arg0:GetMGData():GetRuntimeData("elements")
			local var1 = arg0.scoreNum
			local var2 = var0 and #var0 > 0 and var0[1] or 0
			local var3 = arg0.rtTitlePage:Find("result")

			setActive(var3:Find("window/now/new"), var2 < var1)

			if var2 <= var1 then
				var2 = var1

				arg0:StoreDataToServer({
					var2
				})
			end

			setText(var3:Find("window/high/Text"), var2)
			setText(var3:Find("window/now/Text"), var1)

			local var4 = arg0:GetMGHubData()

			if arg0.stageIndex == var4.usedtime + 1 and var4.count > 0 then
				arg0:SendSuccess(0)
			end
		end
	})
end

function var0.updateMainUI(arg0)
	local var0 = arg0:GetMGHubData()
	local var1 = var0:getConfig("reward_need")
	local var2 = var0.usedtime
	local var3 = var2 + var0.count
	local var4 = var2 == var1 and 8 or math.min(var0.usedtime + 1, var3)
	local var5 = arg0.itemList.container
	local var6 = var5.childCount

	for iter0 = 1, var6 do
		local var7 = {}

		if iter0 <= var2 then
			var7.finish = true
		elseif iter0 <= var3 then
			-- block empty
		elseif var2 == var1 then
			var7.finish = false
			var7.lock = false
		else
			var7.lock = true
		end

		local var8 = var5:GetChild(iter0 - 1)

		setActive(var8:Find("finish"), var7.finish)
		setActive(var8:Find("lock"), var7.lock)
		setToggleEnabled(var8, iter0 <= var4)
		triggerToggle(var8, iter0 == var4)
	end

	local var9 = var5:GetChild(0).anchoredPosition.y - var5:GetChild(var4 - 1).anchoredPosition.y
	local var10 = var5.rect.height
	local var11 = var5:GetComponent(typeof(ScrollRect)).viewport.rect.height
	local var12 = math.clamp(var9, 0, var10 - var11) / (var10 - var11)

	scrollTo(var5, nil, 1 - var12)
	setActive(arg0.rtTitlePage:Find("main/tip/Image"), var2 == var1)
	arg0:checkGet()

	if var2 == 1 and var4 == 2 then
		scrollTo(var5, nil, 1)
		pg.NewGuideMgr.GetInstance():Play("Ryza_MiniGame")
	elseif PlayerPrefs.GetInt("ryza_minigame_help", 0) == 0 then
		triggerButton(arg0.rtTitlePage:Find("main/btn_rule"))
	end
end

function var0.checkGet(arg0)
	local var0 = arg0:GetMGHubData()

	if var0.ultimate == 0 then
		if var0.usedtime < var0:getConfig("reward_need") then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0.initUI(arg0)
	arg0.rtTitlePage = arg0._tf:Find("TitlePage")

	local var0 = arg0.rtTitlePage:Find("main")

	onButton(arg0, var0:Find("btn_back"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, var0:Find("btn_rule"), function()
		PlayerPrefs.SetInt("ryza_minigame_help", 1)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ryza_mini_game.tip
		})
	end, SFX_PANEL)

	local var1 = arg0:GetMGData():GetSimpleValue("story")

	onButton(arg0, var0:Find("btn_start"), function()
		local var0 = {}
		local var1 = checkExist(var1, {
			arg0.stageIndex
		}, {
			1
		})

		if var1 then
			table.insert(var0, function(arg0)
				pg.NewStoryMgr.GetInstance():Play(var1, arg0)
			end)
		end

		seriesAsync(var0, function()
			arg0:readyStart()
		end)
	end, SFX_CONFIRM)

	arg0.stageIndex = 0

	local var2 = pg.mini_game[arg0:GetMGData().id].simple_config_data.drop_ids
	local var3 = var0:Find("side_panel/award/content")

	arg0.itemList = UIItemList.New(var3, var3:GetChild(0))

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg2:Find("IconTpl")
			local var1 = {}

			var1.type, var1.id, var1.count = unpack(var2[arg1])

			updateDrop(var0, var1)
			onButton(arg0, var0, function()
				arg0:emit(var0.ON_DROP, var1)
			end, SFX_PANEL)
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0.stageIndex = arg1
				end
			end)
		end
	end)
	arg0.itemList:align(#var2)

	local var4 = arg0:GetMGHubData():getConfig("reward_need")

	setActive(var3:GetChild(var4), true)
	onToggle(arg0, var3:GetChild(var4), function(arg0)
		if arg0 then
			arg0.stageIndex = 0
		end
	end)
	arg0.rtTitlePage:Find("countdown"):Find("bg/Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:openUI()
		arg0:startGame()
	end)

	local var5 = arg0.rtTitlePage:Find("pause")

	onButton(arg0, var5:Find("window/btn_confirm"), function()
		arg0:openUI()
		arg0:resumeGame()
	end, SFX_CONFIRM)

	local var6 = arg0.rtTitlePage:Find("exit")

	onButton(arg0, var6:Find("window/btn_cancel"), function()
		arg0:openUI()
		arg0:resumeGame()
	end, SFX_CANCEL)
	onButton(arg0, var6:Find("window/btn_confirm"), function()
		arg0:openUI()
		arg0:resumeGame()
		arg0:endGame()
	end, SFX_CONFIRM)

	local var7 = arg0.rtTitlePage:Find("result")

	onButton(arg0, var7:Find("window/btn_finish"), function()
		setActive(arg0._tf:Find("Viewport"), false)
		arg0:openUI("main")
		pg.BgmMgr.GetInstance():Push(arg0.__cname, "ryza-5")
	end, SFX_CONFIRM)
end

function var0.initGameUI(arg0)
	arg0.uiMgr = pg.UIMgr.GetInstance()
	arg0.rtResource = arg0._tf:Find("Resource")
	arg0.rtMain = arg0._tf:Find("Viewport/MainContent")
	arg0.rtPlane = arg0.rtMain:Find("plane")
	arg0.sprites = {}

	eachChild(arg0.rtPlane, function(arg0)
		arg0.sprites[arg0.name] = getImageSprite(arg0)
	end)

	arg0.rtController = arg0._tf:Find("Controller")
	arg0.rtJoyStick = arg0.rtController:Find("bottom/handle_stick")

	onButton(arg0, arg0.rtController:Find("bottom/btn_bomb"), function()
		arg0.responder:RyzaBomb()
	end)

	arg0.rtScore = arg0.rtController:Find("top/title/SCORE/Text")
	arg0.rtTime = arg0.rtController:Find("top/title/TIME/Text")

	onButton(arg0, arg0.rtController:Find("top/btn_back"), function()
		arg0:openUI("exit")
	end, SFX_PANEL)
	onButton(arg0, arg0.rtController:Find("top/btn_pause"), function()
		arg0:openUI("pause")
	end, SFX_PANEL)

	arg0.rtStatus = arg0.rtController:Find("bottom/status")
	arg0.rtRyzaHP = arg0.rtController:Find("top/title/HP/heart")
	arg0.rtControllerUI = arg0.rtController:Find("UI")

	eachChild(arg0.rtControllerUI, function(arg0)
		arg0["tplUI" .. arg0.name] = arg0

		setActive(arg0, false)
	end)

	arg0.responder = Responder.New(arg0)

	arg0:bind(var0.EVENT_CREATE, function(arg0, ...)
		arg0:CreateReactor(...)
	end)
	arg0:bind(var0.EVENT_DESTROY, function(arg0, ...)
		arg0:DestroyReactor(...)
	end)
	arg0:bind(var0.EVENT_FINISH, function(arg0, arg1)
		arg0:endGame(arg1)
	end)
	arg0:bind(var0.EVENT_WINDOW_FOCUS, function(arg0, arg1)
		setAnchoredPosition(arg0.rtMain, {
			x = math.clamp(-arg1.x, -arg0.buffer.x, arg0.buffer.x),
			y = math.clamp(-arg1.y, -arg0.buffer.y - 48, arg0.buffer.y - 48)
		})
	end)
	arg0:bind(var0.EVENT_STATUS_SYNC, function(arg0, ...)
		arg0:updateControllerStatus(...)
		arg0:popRyzaUI(...)
	end)
	arg0:bind(var0.EVENT_UPDATE_HIDE, function(arg0, arg1, arg2)
		if isa(arg1, MoveEnemy) then
			GetOrAddComponent(arg0.reactorUIs[arg1], typeof(CanvasGroup)).alpha = arg2 and 0 or 1
		end
	end)
end

function var0.initTimer(arg0)
	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, RyzaMiniGameConfig.TIME_INTERVAL, -1)
end

function var0.readyStart(arg0)
	arg0:resetGame()
	setActive(arg0._tf:Find("Viewport"), true)
	var1(arg0.rtMain, 1)
	arg0:initConfig()
	arg0:buildMap()
	arg0:initController()
	arg0:openUI("countdown")
end

function var0.startGame(arg0)
	pg.BgmMgr.GetInstance():Push(arg0.__cname, "ryza-az-battle")

	arg0.gameStartFlag = true

	arg0:startTimer()
end

function var0.endGame(arg0, arg1)
	if arg1 then
		arg0.scoreNum = arg0.scoreNum + RyzaMiniGameConfig.GetPassGamePoint(arg0.countTime)

		setText(arg0.rtScore, arg0.scoreNum)
	end

	arg0.gameEndFlag = true

	arg0:stopTimer()
	arg0:openUI("result")
end

function var0.pauseGame(arg0)
	arg0.gamePause = true

	arg0:stopTimer()
	arg0:pauseManagedTween()
end

function var0.resumeGame(arg0)
	arg0.gamePause = false

	arg0:startTimer()
	arg0:resumeManagedTween()
end

function var0.resetGame(arg0)
	arg0.gameStartFlag = false
	arg0.gamePause = false
	arg0.gameEndFlag = false
	arg0.scoreNum = 0
	arg0.countTime = 0

	arg0.responder:reset()

	if arg0.reactorUIs then
		for iter0, iter1 in pairs(arg0.reactorUIs) do
			Destroy(iter1)
		end
	end

	arg0.reactorUIs = {}
end

function var0.initConfig(arg0)
	local var0 = arg0.stageIndex == 0 and math.random(7) or arg0.stageIndex
	local var1 = 0
	local var2 = underscore.rest(RyzaMiniGameConfig.ENEMY_TYPE_LIST, 1)
	local var3 = {}
	local var4 = pg.MiniGameTileMgr.GetInstance():getDataLayers("BoomGame", "BoomLevel_" .. var0)

	arg0.config = {}
	arg0.config.mapSize = NewPos(var4[1].width, var4[1].height)
	arg0.config.reactorList = {}

	for iter0, iter1 in ipairs(var4) do
		for iter2, iter3 in ipairs(iter1.layer) do
			if iter3.item then
				local var5 = {
					name = iter3.item
				}

				if arg0.stageIndex == 0 and isa(RyzaMiniGameConfig.CreateInfo(var5.name), TargetMove) then
					if var5.name == "Ryza" then
						-- block empty
					else
						local var6 = math.random(#var2)

						if string.find(var2[var6], "BOSS_") then
							var5.name = table.remove(var2, var6)
							var1 = var1 + 1

							if var1 == RyzaMiniGameConfig.FREE_MAP_BOSS_LIMIT[var0] then
								while string.find(var2[#var2], "BOSS_") do
									table.remove(var2)
								end
							end
						else
							var5.name = var2[var6]
						end

						table.insert(var3, #arg0.config.reactorList + 1)
					end
				elseif iter3.prop then
					for iter4, iter5 in pairs(iter3.prop) do
						var5[iter4] = iter5
					end
				end

				var5.pos = {
					(iter3.index - 1) % arg0.config.mapSize.x,
					math.floor((iter3.index - 1) / arg0.config.mapSize.x)
				}

				table.insert(arg0.config.reactorList, var5)
			end
		end
	end

	if arg0.stageIndex == 0 and var1 == 0 then
		local var7 = math.random(#var3)
		local var8 = arg0.config.reactorList[var7]

		arg0.config.reactorList[var7] = {
			name = "BOSS_" .. var8.name,
			pos = var8.pos
		}
	end
end

function var0.buildMap(arg0)
	setSizeDelta(arg0.rtMain, arg0.config.mapSize * 32)
	eachChild(arg0.rtMain:Find("bg/NW"), function(arg0)
		setActive(arg0, arg0.name == tostring(math.floor((arg0.stageIndex - 1) % 8 / 2) + 1))
	end)

	local var0 = arg0._tf:Find("Viewport").rect
	local var1 = arg0.rtMain.rect

	arg0.buffer = NewPos(math.max(var1.width + 256 - var0.width, 0), math.max(var1.height + 160 - var0.height, 0)) * 0.5

	local var2 = Time.realtimeSinceStartup
	local var3 = arg0.config.mapSize.x
	local var4 = arg0.config.mapSize.y
	local var5 = UIItemList.New(arg0.rtPlane, arg0.rtPlane:GetChild(0))

	var5:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 % var4
			local var1 = math.floor(arg1 / var4)

			arg2.name = var0 .. "_" .. var1

			if math.random() < RyzaMiniGameConfig.GRASS_CHAGNE_RATE then
				setImageAlpha(arg2, 1)

				local var2 = "Grass_" .. 3 + math.random(3)

				setImageSprite(arg2, arg0.sprites[var2])
			else
				setImageAlpha(arg2, 0)
			end
		end
	end)
	var5:align(var3 * var4)
	arg0:soilMapPartition(Vector2.zero, arg0.config.mapSize)

	for iter0, iter1 in ipairs(arg0.config.reactorList) do
		arg0:CreateReactor(iter1)
	end
end

function var0.initController(arg0)
	setText(arg0.rtScore, arg0.scoreNum)
	setText(arg0.rtTime, string.format("%02d:%02d", math.floor(arg0.countTime / 60), math.floor(arg0.countTime % 60)))

	local var0 = arg0.responder.reactorRyza

	arg0:updateControllerStatus(var0, "hp", {
		num = var0.hp
	})
	arg0:updateControllerStatus(var0, "bomb", {
		num = var0.bomb
	})
	arg0:updateControllerStatus(var0, "power", {
		num = var0.power
	})
	arg0:updateControllerStatus(var0, "speed", {
		num = var0.speed
	})
end

function var0.updateControllerStatus(arg0, arg1, arg2, arg3)
	local var0 = arg0.reactorUIs[arg1]

	if isa(arg1, MoveRyza) then
		if arg2 == "hp" then
			eachChild(arg0.rtRyzaHP, function(arg0)
				setActive(arg0:Find("active"), tonumber(arg0.name) <= arg3.num)
			end)
		else
			eachChild(arg0.rtStatus:Find(string.upper(arg2) .. "/bit"), function(arg0)
				setActive(arg0, tonumber(arg0.name) <= arg3.num)
			end)
		end
	elseif isa(arg1, MoveEnemy) then
		setSlider(var0:Find("hp"), 0, arg3.max, arg3.num)
	end
end

function var0.popRyzaUI(arg0, arg1, arg2, arg3)
	if isa(arg1, MoveRyza) then
		local var0 = arg0.reactorUIs[arg1]

		if arg2 == "hp" then
			local var1 = var0:Find("pop/hp_" .. (arg3.delta > 0 and "up" or "down"))

			for iter0 = 1, 2 do
				setActive(var1:Find(iter0), iter0 * iter0 == arg3.delta * arg3.delta)
			end

			setActive(var1, false)
			setActive(var1, true)
		else
			local var2 = var0:Find("pop/" .. arg2 .. "_up")

			setActive(var2, false)
			setActive(var2, true)
		end
	end
end

function var0.CreateReactor(arg0, arg1)
	local var0, var1, var2 = RyzaMiniGameConfig.CreateInfo(arg1.name)

	if not var0 then
		warning(arg1.name)

		return
	end

	local var3 = var0.New(arg1, cloneTplTo(arg0.rtResource:Find(var1), arg0.rtMain:Find(var2)), arg0.responder)

	if isa(var3, MoveRyza) then
		arg0.reactorUIs[var3] = cloneTplTo(arg0.tplUIRyza, arg0.rtControllerUI)

		eachChild(arg0.reactorUIs[var3]:Find("pop"), function(arg0)
			arg0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				setActive(arg0, false)
			end)
		end)

		arg0.reactorUIs[var3].position = var3._tf.position
	elseif isa(var3, MoveEnemy) then
		arg0.reactorUIs[var3] = cloneTplTo(arg0.tplUIEnemy, arg0.rtControllerUI)

		setAnchoredPosition(arg0.reactorUIs[var3]:Find("hp"), {
			y = var3:GetUIHeight()
		})

		arg0.reactorUIs[var3].position = var3._tf.position
	end
end

function var0.DestroyReactor(arg0, arg1, arg2)
	if arg0.reactorUIs[arg1] then
		Destroy(arg0.reactorUIs[arg1])

		arg0.reactorUIs[arg1] = nil
	end

	arg0.scoreNum = arg0.scoreNum + arg2

	setText(arg0.rtScore, arg0.scoreNum)
end

function var0.soilMapPartition(arg0, arg1, arg2)
	local var0 = RyzaMiniGameConfig.SOIL_RANDOM_CONFIG
	local var1 = math.floor(math.min(arg2.x, arg2.y) * (var0.size_rate[1] + math.random() * (var0.size_rate[2] - var0.size_rate[1])))

	if var1 < 2 then
		return
	end

	local var2 = math.random(4) % 4

	arg0:dealSoilMap(NewPos(arg1.x + (var2 % 2 > 0 and arg2.x - var1 or 0), arg1.y + (var2 > 1 and arg2.y - var1 or 0)), var1)

	local var3 = var1 + math.ceil((arg2.x - var1) * var0.spacer_rate)
	local var4 = var1 + math.ceil((arg2.y - var1) * var0.spacer_rate)

	if arg2.x > arg2.y then
		arg0:soilMapPartition(NewPos(arg1.x + (var2 % 2 > 0 and 0 or var3), arg1.y), NewPos(arg2.x - var3, arg2.y))
		arg0:soilMapPartition(NewPos(arg1.x + (var2 % 2 > 0 and arg2.x - var1 or 0), arg1.y + (var2 > 1 and 0 or var4)), NewPos(var1, arg2.y - var4))
	else
		arg0:soilMapPartition(NewPos(arg1.x + (var2 % 2 > 0 and 0 or var3), arg1.y + (var2 > 1 and arg2.y - var1 or 0)), NewPos(arg2.x - var3, var1))
		arg0:soilMapPartition(NewPos(arg1.x, arg1.y + (var2 > 1 and 0 or var4)), NewPos(arg2.x, arg2.y - var4))
	end
end

local var2 = {
	{
		0,
		1
	},
	{
		1,
		0
	},
	{
		0,
		-1
	},
	{
		-1,
		0
	}
}
local var3 = {
	{
		0,
		1
	},
	{
		1,
		0
	},
	{
		0,
		-1
	},
	{
		-1,
		0
	},
	{
		1,
		1
	},
	{
		1,
		-1
	},
	{
		-1,
		-1
	},
	{
		-1,
		1
	}
}

function var0.dealSoilMap(arg0, arg1, arg2)
	local var0 = {}

	for iter0 = 0, 3 do
		table.insert(var0, arg1 + NewPos(iter0 % 2 > 0 and arg2 - 1 or 0, iter0 > 1 and arg2 - 1 or 0))
	end

	local function var1(arg0)
		if arg0.x < arg1.x or arg0.y < arg1.y or arg0.x >= arg1.x + arg2 or arg0.y >= arg1.y + arg2 then
			return false
		else
			return true
		end
	end

	local var2 = {}
	local var3 = function(arg0)
		local var0 = 0
		local var1 = 1

		for iter0, iter1 in ipairs(var3) do
			local var2 = arg0 + NewPos(unpack(iter1))

			if var1(var2) and defaultValue(var2[var2.x .. "_" .. var2.y], true) then
				var0 = var0 + var1
			end

			var1 = var1 + var1
		end

		return var0
	end

	local function var4(arg0)
		for iter0, iter1 in ipairs(var3) do
			local var0 = arg0 + NewPos(unpack(iter1))

			if var1(var0) and defaultValue(var2[var0.x .. "_" .. var0.y], true) and not RyzaMiniGameConfig.SOIL_SPRITES_DIC[var3(var0)] then
				return false
			end
		end

		return true
	end

	local var5 = 0
	local var6 = RyzaMiniGameConfig.SOIL_RANDOM_CONFIG.cancel_rate
	local var7
	local var8 = 0

	while var8 < #var0 do
		var8 = var8 + 1

		local var9 = var0[var8]

		var2[var9.x .. "_" .. var9.y] = false

		if math.random() < var6[1] + var6[2] * (1 - var5 / arg2 / arg2) * (1 - var5 / arg2 / arg2) and var4(var9) then
			var5 = var5 + 1
		else
			var2[var9.x .. "_" .. var9.y] = true
		end

		for iter1, iter2 in ipairs(var2) do
			local var10 = var9 + NewPos(unpack(iter2))

			if var1(var10) and var2[var10.x .. "_" .. var10.y] == nil then
				table.insert(var0, var10)
			end
		end
	end

	local var11 = arg0.config.mapSize.x
	local var12 = arg0.config.mapSize.y

	for iter3 = arg1.x, arg1.x + arg2 - 1 do
		for iter4 = arg1.y, arg1.y + arg2 - 1 do
			if defaultValue(var2[iter3 .. "_" .. iter4], true) then
				local var13 = RyzaMiniGameConfig.SOIL_SPRITES_DIC[var3(NewPos(iter3, iter4))]

				assert(var13)

				local var14 = arg0.rtPlane:GetChild(iter4 * var11 + iter3)

				setImageAlpha(var14, 1)
				setImageSprite(var14, arg0.sprites[var13])
			end
		end
	end
end

function var0.startTimer(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end

	arg0.uiMgr:AttachStickOb(arg0.rtJoyStick)
	var1(arg0.rtMain, 1)
end

function var0.stopTimer(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end

	arg0.uiMgr:ClearStick()
	var1(arg0.rtMain, 0)
end

function var0.onTimer(arg0)
	arg0.countTime = arg0.countTime + RyzaMiniGameConfig.TIME_INTERVAL

	setText(arg0.rtTime, string.format("%02d:%02d", math.floor(arg0.countTime / 60), math.floor(arg0.countTime % 60)))
	arg0.responder:TimeFlow(RyzaMiniGameConfig.TIME_INTERVAL)

	for iter0, iter1 in pairs(arg0.reactorUIs) do
		iter1.position = iter0._tf.position
	end

	local var0 = arg0.responder:GetJoyStick()

	if var0.x ~= 0 or var0.y ~= 0 then
		local var1 = arg0.reactorUIs[arg0.responder.reactorRyza]:Find("dir")

		if var0.x == 0 then
			setLocalEulerAngles(var1, {
				z = var0.y > 0 and 270 or 90
			})
		else
			setLocalEulerAngles(var1, {
				z = math.atan2(-var0.y, var0.x) / math.pi * 180
			})
		end
	end
end

function var0.OnApplicationPaused(arg0, arg1)
	if arg1 then
		-- block empty
	end
end

function var0.onBackPressed(arg0)
	switch(arg0.status, {
		main = function()
			var0.super.onBackPressed(arg0)
		end,
		countdown = function()
			return
		end,
		pause = function()
			arg0:openUI()
			arg0:resumeGame()
		end,
		exit = function()
			arg0:openUI()
			arg0:resumeGame()
		end,
		result = function()
			return
		end
	}, function()
		assert(arg0.gameStartFlag)
		arg0:openUI("pause")
	end)
end

function var0.willExit(arg0)
	return
end

return var0
