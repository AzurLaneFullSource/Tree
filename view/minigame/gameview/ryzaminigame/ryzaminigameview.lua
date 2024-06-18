local var0_0 = class("RyzaMiniGameView", import("view.miniGame.BaseMiniGameView"))

var0_0.EVENT_CREATE = "RyzaMiniGameView.EVENT_CREATE"
var0_0.EVENT_DESTROY = "RyzaMiniGameView.EVENT_DESTROY"
var0_0.EVENT_FINISH = "RyzaMiniGameView.EVENT_FINISH"
var0_0.EVENT_WINDOW_FOCUS = "RyzaMiniGameView.EVENT_WINDOW_FOCUS"
var0_0.EVENT_STATUS_SYNC = "RyzaMiniGameView.EVENT_STATUS_SYNC"
var0_0.EVENT_UPDATE_HIDE = "RyzaMiniGameView.EVENT_UPDATE_HIDE"

function var0_0.getUIName(arg0_1)
	return "RyzaMiniGameUI"
end

function var0_0.didEnter(arg0_2)
	arg0_2:initTimer()
	arg0_2:initUI()
	arg0_2:initGameUI()
	onNextTick(function()
		arg0_2:openUI("main")
	end)
end

local function var1_0(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetComponentsInChildren(typeof(Animator), true)

	for iter0_4 = 0, var0_4.Length - 1 do
		var0_4[iter0_4].speed = arg1_4
	end
end

function var0_0.openUI(arg0_5, arg1_5)
	if arg0_5.status then
		setActive(arg0_5.rtTitlePage:Find(arg0_5.status), false)
	end

	if arg1_5 then
		setActive(arg0_5.rtTitlePage:Find(arg1_5), true)
	end

	arg0_5.status = arg1_5

	switch(arg1_5, {
		main = function()
			arg0_5:updateMainUI()
		end,
		pause = function()
			arg0_5:pauseGame()
		end,
		exit = function()
			arg0_5:pauseGame()
		end,
		result = function()
			local var0_9 = arg0_5:GetMGData():GetRuntimeData("elements")
			local var1_9 = arg0_5.scoreNum
			local var2_9 = var0_9 and #var0_9 > 0 and var0_9[1] or 0
			local var3_9 = arg0_5.rtTitlePage:Find("result")

			setActive(var3_9:Find("window/now/new"), var2_9 < var1_9)

			if var2_9 <= var1_9 then
				var2_9 = var1_9

				arg0_5:StoreDataToServer({
					var2_9
				})
			end

			setText(var3_9:Find("window/high/Text"), var2_9)
			setText(var3_9:Find("window/now/Text"), var1_9)

			local var4_9 = arg0_5:GetMGHubData()

			if arg0_5.stageIndex == var4_9.usedtime + 1 and var4_9.count > 0 then
				arg0_5:SendSuccess(0)
			end
		end
	})
end

function var0_0.updateMainUI(arg0_10)
	local var0_10 = arg0_10:GetMGHubData()
	local var1_10 = var0_10:getConfig("reward_need")
	local var2_10 = var0_10.usedtime
	local var3_10 = var2_10 + var0_10.count
	local var4_10 = var2_10 == var1_10 and 8 or math.min(var0_10.usedtime + 1, var3_10)
	local var5_10 = arg0_10.itemList.container
	local var6_10 = var5_10.childCount

	for iter0_10 = 1, var6_10 do
		local var7_10 = {}

		if iter0_10 <= var2_10 then
			var7_10.finish = true
		elseif iter0_10 <= var3_10 then
			-- block empty
		elseif var2_10 == var1_10 then
			var7_10.finish = false
			var7_10.lock = false
		else
			var7_10.lock = true
		end

		local var8_10 = var5_10:GetChild(iter0_10 - 1)

		setActive(var8_10:Find("finish"), var7_10.finish)
		setActive(var8_10:Find("lock"), var7_10.lock)
		setToggleEnabled(var8_10, iter0_10 <= var4_10)
		triggerToggle(var8_10, iter0_10 == var4_10)
	end

	local var9_10 = var5_10:GetChild(0).anchoredPosition.y - var5_10:GetChild(var4_10 - 1).anchoredPosition.y
	local var10_10 = var5_10.rect.height
	local var11_10 = var5_10:GetComponent(typeof(ScrollRect)).viewport.rect.height
	local var12_10 = math.clamp(var9_10, 0, var10_10 - var11_10) / (var10_10 - var11_10)

	scrollTo(var5_10, nil, 1 - var12_10)
	setActive(arg0_10.rtTitlePage:Find("main/tip/Image"), var2_10 == var1_10)
	arg0_10:checkGet()

	if var2_10 == 1 and var4_10 == 2 then
		scrollTo(var5_10, nil, 1)
		pg.NewGuideMgr.GetInstance():Play("Ryza_MiniGame")
	elseif PlayerPrefs.GetInt("ryza_minigame_help", 0) == 0 then
		triggerButton(arg0_10.rtTitlePage:Find("main/btn_rule"))
	end
end

function var0_0.checkGet(arg0_11)
	local var0_11 = arg0_11:GetMGHubData()

	if var0_11.ultimate == 0 then
		if var0_11.usedtime < var0_11:getConfig("reward_need") then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_11.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0_0.initUI(arg0_12)
	arg0_12.rtTitlePage = arg0_12._tf:Find("TitlePage")

	local var0_12 = arg0_12.rtTitlePage:Find("main")

	onButton(arg0_12, var0_12:Find("btn_back"), function()
		arg0_12:closeView()
	end, SFX_CANCEL)
	onButton(arg0_12, var0_12:Find("btn_rule"), function()
		PlayerPrefs.SetInt("ryza_minigame_help", 1)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ryza_mini_game.tip
		})
	end, SFX_PANEL)

	local var1_12 = arg0_12:GetMGData():GetSimpleValue("story")

	onButton(arg0_12, var0_12:Find("btn_start"), function()
		local var0_15 = {}
		local var1_15 = checkExist(var1_12, {
			arg0_12.stageIndex
		}, {
			1
		})

		if var1_15 then
			table.insert(var0_15, function(arg0_16)
				pg.NewStoryMgr.GetInstance():Play(var1_15, arg0_16)
			end)
		end

		seriesAsync(var0_15, function()
			arg0_12:readyStart()
		end)
	end, SFX_CONFIRM)

	arg0_12.stageIndex = 0

	local var2_12 = pg.mini_game[arg0_12:GetMGData().id].simple_config_data.drop_ids
	local var3_12 = var0_12:Find("side_panel/award/content")

	arg0_12.itemList = UIItemList.New(var3_12, var3_12:GetChild(0))

	arg0_12.itemList:make(function(arg0_18, arg1_18, arg2_18)
		arg1_18 = arg1_18 + 1

		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = arg2_18:Find("IconTpl")
			local var1_18 = {}

			var1_18.type, var1_18.id, var1_18.count = unpack(var2_12[arg1_18])

			updateDrop(var0_18, var1_18)
			onButton(arg0_12, var0_18, function()
				arg0_12:emit(var0_0.ON_DROP, var1_18)
			end, SFX_PANEL)
			onToggle(arg0_12, arg2_18, function(arg0_20)
				if arg0_20 then
					arg0_12.stageIndex = arg1_18
				end
			end)
		end
	end)
	arg0_12.itemList:align(#var2_12)

	local var4_12 = arg0_12:GetMGHubData():getConfig("reward_need")

	setActive(var3_12:GetChild(var4_12), true)
	onToggle(arg0_12, var3_12:GetChild(var4_12), function(arg0_21)
		if arg0_21 then
			arg0_12.stageIndex = 0
		end
	end)
	arg0_12.rtTitlePage:Find("countdown"):Find("bg/Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_12:openUI()
		arg0_12:startGame()
	end)

	local var5_12 = arg0_12.rtTitlePage:Find("pause")

	onButton(arg0_12, var5_12:Find("window/btn_confirm"), function()
		arg0_12:openUI()
		arg0_12:resumeGame()
	end, SFX_CONFIRM)

	local var6_12 = arg0_12.rtTitlePage:Find("exit")

	onButton(arg0_12, var6_12:Find("window/btn_cancel"), function()
		arg0_12:openUI()
		arg0_12:resumeGame()
	end, SFX_CANCEL)
	onButton(arg0_12, var6_12:Find("window/btn_confirm"), function()
		arg0_12:openUI()
		arg0_12:resumeGame()
		arg0_12:endGame()
	end, SFX_CONFIRM)

	local var7_12 = arg0_12.rtTitlePage:Find("result")

	onButton(arg0_12, var7_12:Find("window/btn_finish"), function()
		setActive(arg0_12._tf:Find("Viewport"), false)
		arg0_12:openUI("main")
		pg.CriMgr.GetInstance():PlayBGM("ryza-5")
	end, SFX_CONFIRM)
end

function var0_0.initGameUI(arg0_27)
	arg0_27.uiMgr = pg.UIMgr.GetInstance()
	arg0_27.rtResource = arg0_27._tf:Find("Resource")
	arg0_27.rtMain = arg0_27._tf:Find("Viewport/MainContent")
	arg0_27.rtPlane = arg0_27.rtMain:Find("plane")
	arg0_27.sprites = {}

	eachChild(arg0_27.rtPlane, function(arg0_28)
		arg0_27.sprites[arg0_28.name] = getImageSprite(arg0_28)
	end)

	arg0_27.rtController = arg0_27._tf:Find("Controller")
	arg0_27.rtJoyStick = arg0_27.rtController:Find("bottom/handle_stick")

	onButton(arg0_27, arg0_27.rtController:Find("bottom/btn_bomb"), function()
		arg0_27.responder:RyzaBomb()
	end)

	arg0_27.rtScore = arg0_27.rtController:Find("top/title/SCORE/Text")
	arg0_27.rtTime = arg0_27.rtController:Find("top/title/TIME/Text")

	onButton(arg0_27, arg0_27.rtController:Find("top/btn_back"), function()
		arg0_27:openUI("exit")
	end, SFX_PANEL)
	onButton(arg0_27, arg0_27.rtController:Find("top/btn_pause"), function()
		arg0_27:openUI("pause")
	end, SFX_PANEL)

	arg0_27.rtStatus = arg0_27.rtController:Find("bottom/status")
	arg0_27.rtRyzaHP = arg0_27.rtController:Find("top/title/HP/heart")
	arg0_27.rtControllerUI = arg0_27.rtController:Find("UI")

	eachChild(arg0_27.rtControllerUI, function(arg0_32)
		arg0_27["tplUI" .. arg0_32.name] = arg0_32

		setActive(arg0_32, false)
	end)

	arg0_27.responder = Responder.New(arg0_27)

	arg0_27:bind(var0_0.EVENT_CREATE, function(arg0_33, ...)
		arg0_27:CreateReactor(...)
	end)
	arg0_27:bind(var0_0.EVENT_DESTROY, function(arg0_34, ...)
		arg0_27:DestroyReactor(...)
	end)
	arg0_27:bind(var0_0.EVENT_FINISH, function(arg0_35, arg1_35)
		arg0_27:endGame(arg1_35)
	end)
	arg0_27:bind(var0_0.EVENT_WINDOW_FOCUS, function(arg0_36, arg1_36)
		setAnchoredPosition(arg0_27.rtMain, {
			x = math.clamp(-arg1_36.x, -arg0_27.buffer.x, arg0_27.buffer.x),
			y = math.clamp(-arg1_36.y, -arg0_27.buffer.y - 48, arg0_27.buffer.y - 48)
		})
	end)
	arg0_27:bind(var0_0.EVENT_STATUS_SYNC, function(arg0_37, ...)
		arg0_27:updateControllerStatus(...)
		arg0_27:popRyzaUI(...)
	end)
	arg0_27:bind(var0_0.EVENT_UPDATE_HIDE, function(arg0_38, arg1_38, arg2_38)
		if isa(arg1_38, MoveEnemy) then
			GetOrAddComponent(arg0_27.reactorUIs[arg1_38], typeof(CanvasGroup)).alpha = arg2_38 and 0 or 1
		end
	end)
end

function var0_0.initTimer(arg0_39)
	arg0_39.timer = Timer.New(function()
		arg0_39:onTimer()
	end, RyzaMiniGameConfig.TIME_INTERVAL, -1)
end

function var0_0.readyStart(arg0_41)
	arg0_41:resetGame()
	setActive(arg0_41._tf:Find("Viewport"), true)
	var1_0(arg0_41.rtMain, 1)
	arg0_41:initConfig()
	arg0_41:buildMap()
	arg0_41:initController()
	arg0_41:openUI("countdown")
end

function var0_0.startGame(arg0_42)
	pg.CriMgr.GetInstance():PlayBGM("ryza-az-battle")

	arg0_42.gameStartFlag = true

	arg0_42:startTimer()
end

function var0_0.endGame(arg0_43, arg1_43)
	if arg1_43 then
		arg0_43.scoreNum = arg0_43.scoreNum + RyzaMiniGameConfig.GetPassGamePoint(arg0_43.countTime)

		setText(arg0_43.rtScore, arg0_43.scoreNum)
	end

	arg0_43.gameEndFlag = true

	arg0_43:stopTimer()
	arg0_43:openUI("result")
end

function var0_0.pauseGame(arg0_44)
	arg0_44.gamePause = true

	arg0_44:stopTimer()
	arg0_44:pauseManagedTween()
end

function var0_0.resumeGame(arg0_45)
	arg0_45.gamePause = false

	arg0_45:startTimer()
	arg0_45:resumeManagedTween()
end

function var0_0.resetGame(arg0_46)
	arg0_46.gameStartFlag = false
	arg0_46.gamePause = false
	arg0_46.gameEndFlag = false
	arg0_46.scoreNum = 0
	arg0_46.countTime = 0

	arg0_46.responder:reset()

	if arg0_46.reactorUIs then
		for iter0_46, iter1_46 in pairs(arg0_46.reactorUIs) do
			Destroy(iter1_46)
		end
	end

	arg0_46.reactorUIs = {}
end

function var0_0.initConfig(arg0_47)
	local var0_47 = arg0_47.stageIndex == 0 and math.random(7) or arg0_47.stageIndex
	local var1_47 = 0
	local var2_47 = underscore.rest(RyzaMiniGameConfig.ENEMY_TYPE_LIST, 1)
	local var3_47 = {}
	local var4_47 = pg.MiniGameTileMgr.GetInstance():getDataLayers("BoomGame", "BoomLevel_" .. var0_47)

	arg0_47.config = {}
	arg0_47.config.mapSize = NewPos(var4_47[1].width, var4_47[1].height)
	arg0_47.config.reactorList = {}

	for iter0_47, iter1_47 in ipairs(var4_47) do
		for iter2_47, iter3_47 in ipairs(iter1_47.layer) do
			if iter3_47.item then
				local var5_47 = {
					name = iter3_47.item
				}

				if arg0_47.stageIndex == 0 and isa(RyzaMiniGameConfig.CreateInfo(var5_47.name), TargetMove) then
					if var5_47.name == "Ryza" then
						-- block empty
					else
						local var6_47 = math.random(#var2_47)

						if string.find(var2_47[var6_47], "BOSS_") then
							var5_47.name = table.remove(var2_47, var6_47)
							var1_47 = var1_47 + 1

							if var1_47 == RyzaMiniGameConfig.FREE_MAP_BOSS_LIMIT[var0_47] then
								while string.find(var2_47[#var2_47], "BOSS_") do
									table.remove(var2_47)
								end
							end
						else
							var5_47.name = var2_47[var6_47]
						end

						table.insert(var3_47, #arg0_47.config.reactorList + 1)
					end
				elseif iter3_47.prop then
					for iter4_47, iter5_47 in pairs(iter3_47.prop) do
						var5_47[iter4_47] = iter5_47
					end
				end

				var5_47.pos = {
					(iter3_47.index - 1) % arg0_47.config.mapSize.x,
					math.floor((iter3_47.index - 1) / arg0_47.config.mapSize.x)
				}

				table.insert(arg0_47.config.reactorList, var5_47)
			end
		end
	end

	if arg0_47.stageIndex == 0 and var1_47 == 0 then
		local var7_47 = math.random(#var3_47)
		local var8_47 = arg0_47.config.reactorList[var7_47]

		arg0_47.config.reactorList[var7_47] = {
			name = "BOSS_" .. var8_47.name,
			pos = var8_47.pos
		}
	end
end

function var0_0.buildMap(arg0_48)
	setSizeDelta(arg0_48.rtMain, arg0_48.config.mapSize * 32)
	eachChild(arg0_48.rtMain:Find("bg/NW"), function(arg0_49)
		setActive(arg0_49, arg0_49.name == tostring(math.floor((arg0_48.stageIndex - 1) % 8 / 2) + 1))
	end)

	local var0_48 = arg0_48._tf:Find("Viewport").rect
	local var1_48 = arg0_48.rtMain.rect

	arg0_48.buffer = NewPos(math.max(var1_48.width + 256 - var0_48.width, 0), math.max(var1_48.height + 160 - var0_48.height, 0)) * 0.5

	local var2_48 = Time.realtimeSinceStartup
	local var3_48 = arg0_48.config.mapSize.x
	local var4_48 = arg0_48.config.mapSize.y
	local var5_48 = UIItemList.New(arg0_48.rtPlane, arg0_48.rtPlane:GetChild(0))

	var5_48:make(function(arg0_50, arg1_50, arg2_50)
		if arg0_50 == UIItemList.EventUpdate then
			local var0_50 = arg1_50 % var4_48
			local var1_50 = math.floor(arg1_50 / var4_48)

			arg2_50.name = var0_50 .. "_" .. var1_50

			if math.random() < RyzaMiniGameConfig.GRASS_CHAGNE_RATE then
				setImageAlpha(arg2_50, 1)

				local var2_50 = "Grass_" .. 3 + math.random(3)

				setImageSprite(arg2_50, arg0_48.sprites[var2_50])
			else
				setImageAlpha(arg2_50, 0)
			end
		end
	end)
	var5_48:align(var3_48 * var4_48)
	arg0_48:soilMapPartition(Vector2.zero, arg0_48.config.mapSize)

	for iter0_48, iter1_48 in ipairs(arg0_48.config.reactorList) do
		arg0_48:CreateReactor(iter1_48)
	end
end

function var0_0.initController(arg0_51)
	setText(arg0_51.rtScore, arg0_51.scoreNum)
	setText(arg0_51.rtTime, string.format("%02d:%02d", math.floor(arg0_51.countTime / 60), math.floor(arg0_51.countTime % 60)))

	local var0_51 = arg0_51.responder.reactorRyza

	arg0_51:updateControllerStatus(var0_51, "hp", {
		num = var0_51.hp
	})
	arg0_51:updateControllerStatus(var0_51, "bomb", {
		num = var0_51.bomb
	})
	arg0_51:updateControllerStatus(var0_51, "power", {
		num = var0_51.power
	})
	arg0_51:updateControllerStatus(var0_51, "speed", {
		num = var0_51.speed
	})
end

function var0_0.updateControllerStatus(arg0_52, arg1_52, arg2_52, arg3_52)
	local var0_52 = arg0_52.reactorUIs[arg1_52]

	if isa(arg1_52, MoveRyza) then
		if arg2_52 == "hp" then
			eachChild(arg0_52.rtRyzaHP, function(arg0_53)
				setActive(arg0_53:Find("active"), tonumber(arg0_53.name) <= arg3_52.num)
			end)
		else
			eachChild(arg0_52.rtStatus:Find(string.upper(arg2_52) .. "/bit"), function(arg0_54)
				setActive(arg0_54, tonumber(arg0_54.name) <= arg3_52.num)
			end)
		end
	elseif isa(arg1_52, MoveEnemy) then
		setSlider(var0_52:Find("hp"), 0, arg3_52.max, arg3_52.num)
	end
end

function var0_0.popRyzaUI(arg0_55, arg1_55, arg2_55, arg3_55)
	if isa(arg1_55, MoveRyza) then
		local var0_55 = arg0_55.reactorUIs[arg1_55]

		if arg2_55 == "hp" then
			local var1_55 = var0_55:Find("pop/hp_" .. (arg3_55.delta > 0 and "up" or "down"))

			for iter0_55 = 1, 2 do
				setActive(var1_55:Find(iter0_55), iter0_55 * iter0_55 == arg3_55.delta * arg3_55.delta)
			end

			setActive(var1_55, false)
			setActive(var1_55, true)
		else
			local var2_55 = var0_55:Find("pop/" .. arg2_55 .. "_up")

			setActive(var2_55, false)
			setActive(var2_55, true)
		end
	end
end

function var0_0.CreateReactor(arg0_56, arg1_56)
	local var0_56, var1_56, var2_56 = RyzaMiniGameConfig.CreateInfo(arg1_56.name)

	if not var0_56 then
		warning(arg1_56.name)

		return
	end

	local var3_56 = var0_56.New(arg1_56, cloneTplTo(arg0_56.rtResource:Find(var1_56), arg0_56.rtMain:Find(var2_56)), arg0_56.responder)

	if isa(var3_56, MoveRyza) then
		arg0_56.reactorUIs[var3_56] = cloneTplTo(arg0_56.tplUIRyza, arg0_56.rtControllerUI)

		eachChild(arg0_56.reactorUIs[var3_56]:Find("pop"), function(arg0_57)
			arg0_57:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				setActive(arg0_57, false)
			end)
		end)

		arg0_56.reactorUIs[var3_56].position = var3_56._tf.position
	elseif isa(var3_56, MoveEnemy) then
		arg0_56.reactorUIs[var3_56] = cloneTplTo(arg0_56.tplUIEnemy, arg0_56.rtControllerUI)

		setAnchoredPosition(arg0_56.reactorUIs[var3_56]:Find("hp"), {
			y = var3_56:GetUIHeight()
		})

		arg0_56.reactorUIs[var3_56].position = var3_56._tf.position
	end
end

function var0_0.DestroyReactor(arg0_59, arg1_59, arg2_59)
	if arg0_59.reactorUIs[arg1_59] then
		Destroy(arg0_59.reactorUIs[arg1_59])

		arg0_59.reactorUIs[arg1_59] = nil
	end

	arg0_59.scoreNum = arg0_59.scoreNum + arg2_59

	setText(arg0_59.rtScore, arg0_59.scoreNum)
end

function var0_0.soilMapPartition(arg0_60, arg1_60, arg2_60)
	local var0_60 = RyzaMiniGameConfig.SOIL_RANDOM_CONFIG
	local var1_60 = math.floor(math.min(arg2_60.x, arg2_60.y) * (var0_60.size_rate[1] + math.random() * (var0_60.size_rate[2] - var0_60.size_rate[1])))

	if var1_60 < 2 then
		return
	end

	local var2_60 = math.random(4) % 4

	arg0_60:dealSoilMap(NewPos(arg1_60.x + (var2_60 % 2 > 0 and arg2_60.x - var1_60 or 0), arg1_60.y + (var2_60 > 1 and arg2_60.y - var1_60 or 0)), var1_60)

	local var3_60 = var1_60 + math.ceil((arg2_60.x - var1_60) * var0_60.spacer_rate)
	local var4_60 = var1_60 + math.ceil((arg2_60.y - var1_60) * var0_60.spacer_rate)

	if arg2_60.x > arg2_60.y then
		arg0_60:soilMapPartition(NewPos(arg1_60.x + (var2_60 % 2 > 0 and 0 or var3_60), arg1_60.y), NewPos(arg2_60.x - var3_60, arg2_60.y))
		arg0_60:soilMapPartition(NewPos(arg1_60.x + (var2_60 % 2 > 0 and arg2_60.x - var1_60 or 0), arg1_60.y + (var2_60 > 1 and 0 or var4_60)), NewPos(var1_60, arg2_60.y - var4_60))
	else
		arg0_60:soilMapPartition(NewPos(arg1_60.x + (var2_60 % 2 > 0 and 0 or var3_60), arg1_60.y + (var2_60 > 1 and arg2_60.y - var1_60 or 0)), NewPos(arg2_60.x - var3_60, var1_60))
		arg0_60:soilMapPartition(NewPos(arg1_60.x, arg1_60.y + (var2_60 > 1 and 0 or var4_60)), NewPos(arg2_60.x, arg2_60.y - var4_60))
	end
end

local var2_0 = {
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
local var3_0 = {
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

function var0_0.dealSoilMap(arg0_61, arg1_61, arg2_61)
	local var0_61 = {}

	for iter0_61 = 0, 3 do
		table.insert(var0_61, arg1_61 + NewPos(iter0_61 % 2 > 0 and arg2_61 - 1 or 0, iter0_61 > 1 and arg2_61 - 1 or 0))
	end

	local function var1_61(arg0_62)
		if arg0_62.x < arg1_61.x or arg0_62.y < arg1_61.y or arg0_62.x >= arg1_61.x + arg2_61 or arg0_62.y >= arg1_61.y + arg2_61 then
			return false
		else
			return true
		end
	end

	local var2_61 = {}

	local function var3_61(arg0_63)
		local var0_63 = 0
		local var1_63 = 1

		for iter0_63, iter1_63 in ipairs(var3_0) do
			local var2_63 = arg0_63 + NewPos(unpack(iter1_63))

			if var1_61(var2_63) and defaultValue(var2_61[var2_63.x .. "_" .. var2_63.y], true) then
				var0_63 = var0_63 + var1_63
			end

			var1_63 = var1_63 + var1_63
		end

		return var0_63
	end

	local function var4_61(arg0_64)
		for iter0_64, iter1_64 in ipairs(var3_0) do
			local var0_64 = arg0_64 + NewPos(unpack(iter1_64))

			if var1_61(var0_64) and defaultValue(var2_61[var0_64.x .. "_" .. var0_64.y], true) and not RyzaMiniGameConfig.SOIL_SPRITES_DIC[var3_61(var0_64)] then
				return false
			end
		end

		return true
	end

	local var5_61 = 0
	local var6_61 = RyzaMiniGameConfig.SOIL_RANDOM_CONFIG.cancel_rate
	local var7_61
	local var8_61 = 0

	while var8_61 < #var0_61 do
		var8_61 = var8_61 + 1

		local var9_61 = var0_61[var8_61]

		var2_61[var9_61.x .. "_" .. var9_61.y] = false

		if math.random() < var6_61[1] + var6_61[2] * (1 - var5_61 / arg2_61 / arg2_61) * (1 - var5_61 / arg2_61 / arg2_61) and var4_61(var9_61) then
			var5_61 = var5_61 + 1
		else
			var2_61[var9_61.x .. "_" .. var9_61.y] = true
		end

		for iter1_61, iter2_61 in ipairs(var2_0) do
			local var10_61 = var9_61 + NewPos(unpack(iter2_61))

			if var1_61(var10_61) and var2_61[var10_61.x .. "_" .. var10_61.y] == nil then
				table.insert(var0_61, var10_61)
			end
		end
	end

	local var11_61 = arg0_61.config.mapSize.x
	local var12_61 = arg0_61.config.mapSize.y

	for iter3_61 = arg1_61.x, arg1_61.x + arg2_61 - 1 do
		for iter4_61 = arg1_61.y, arg1_61.y + arg2_61 - 1 do
			if defaultValue(var2_61[iter3_61 .. "_" .. iter4_61], true) then
				local var13_61 = RyzaMiniGameConfig.SOIL_SPRITES_DIC[var3_61(NewPos(iter3_61, iter4_61))]

				assert(var13_61)

				local var14_61 = arg0_61.rtPlane:GetChild(iter4_61 * var11_61 + iter3_61)

				setImageAlpha(var14_61, 1)
				setImageSprite(var14_61, arg0_61.sprites[var13_61])
			end
		end
	end
end

function var0_0.startTimer(arg0_65)
	if not arg0_65.timer.running then
		arg0_65.timer:Start()
	end

	arg0_65.uiMgr:AttachStickOb(arg0_65.rtJoyStick)
	var1_0(arg0_65.rtMain, 1)
end

function var0_0.stopTimer(arg0_66)
	if arg0_66.timer.running then
		arg0_66.timer:Stop()
	end

	arg0_66.uiMgr:ClearStick()
	var1_0(arg0_66.rtMain, 0)
end

function var0_0.onTimer(arg0_67)
	arg0_67.countTime = arg0_67.countTime + RyzaMiniGameConfig.TIME_INTERVAL

	setText(arg0_67.rtTime, string.format("%02d:%02d", math.floor(arg0_67.countTime / 60), math.floor(arg0_67.countTime % 60)))
	arg0_67.responder:TimeFlow(RyzaMiniGameConfig.TIME_INTERVAL)

	for iter0_67, iter1_67 in pairs(arg0_67.reactorUIs) do
		iter1_67.position = iter0_67._tf.position
	end

	local var0_67 = arg0_67.responder:GetJoyStick()

	if var0_67.x ~= 0 or var0_67.y ~= 0 then
		local var1_67 = arg0_67.reactorUIs[arg0_67.responder.reactorRyza]:Find("dir")

		if var0_67.x == 0 then
			setLocalEulerAngles(var1_67, {
				z = var0_67.y > 0 and 270 or 90
			})
		else
			setLocalEulerAngles(var1_67, {
				z = math.atan2(-var0_67.y, var0_67.x) / math.pi * 180
			})
		end
	end
end

function var0_0.OnApplicationPaused(arg0_68, arg1_68)
	if arg1_68 then
		-- block empty
	end
end

function var0_0.onBackPressed(arg0_69)
	switch(arg0_69.status, {
		main = function()
			var0_0.super.onBackPressed(arg0_69)
		end,
		countdown = function()
			return
		end,
		pause = function()
			arg0_69:openUI()
			arg0_69:resumeGame()
		end,
		exit = function()
			arg0_69:openUI()
			arg0_69:resumeGame()
		end,
		result = function()
			return
		end
	}, function()
		assert(arg0_69.gameStartFlag)
		arg0_69:openUI("pause")
	end)
end

function var0_0.willExit(arg0_76)
	return
end

return var0_0
