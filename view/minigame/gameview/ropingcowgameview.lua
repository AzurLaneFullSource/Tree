local var0 = class("RopingCowGameView", import("..BaseMiniGameView"))
local var1 = "SailAwayJustice-inst"
local var2 = "event:/ui/ddldaoshu2"
local var3 = "event:/ui/niujiao"
local var4 = "event:/ui/taosheng"
local var5 = 60
local var6 = {
	{
		20,
		{
			0,
			0.25
		}
	},
	{
		40,
		{
			0.5,
			0.5
		}
	},
	{
		50,
		{
			0.5,
			1
		}
	},
	{
		60,
		{
			1,
			1.5
		}
	}
}
local var7 = {
	{
		speed = 800,
		score = 300
	},
	{
		speed = 700,
		score = 200
	},
	{
		speed = 600,
		score = 100
	},
	{
		speed = 500,
		score = 50
	}
}
local var8 = {
	{
		20,
		{
			300,
			300,
			200,
			200
		}
	},
	{
		40,
		{
			200,
			300,
			300,
			200
		}
	},
	{
		50,
		{
			150,
			250,
			300,
			300
		}
	},
	{
		60,
		{
			100,
			100,
			400,
			400
		}
	}
}
local var9 = {
	-50,
	50
}
local var10 = 0.75
local var11 = 1700
local var12 = 4
local var13 = 0
local var14 = 1
local var15 = 2
local var16 = "cow_event_capture"
local var17 = "player_event_capture"
local var18 = "player_event_get"
local var19 = "player_event_miss"
local var20 = "player_event_cd"
local var21 = "idol"
local var22 = "miss"
local var23 = "get"
local var24 = "throw"
local var25 = "event_capture"
local var26 = "scene_item_type_time"
local var27 = "scene_item_type_event"
local var28 = {
	{
		name = "backGround/2/jiujiuA",
		type = var26,
		params = {
			15,
			20
		},
		states = {
			1,
			2,
			3
		}
	},
	{
		name = "backGround/2/jiujiuB",
		type = var26,
		params = {
			15,
			20
		},
		states = {
			1,
			2
		}
	},
	{
		trigger = true,
		name = "backGround/2/jiujiuC",
		type = var26,
		params = {
			15,
			20
		}
	},
	{
		trigger = true,
		name = "backGround/3/jiujiuD",
		type = var26,
		params = {
			20,
			22
		}
	},
	{
		trigger = true,
		name = "backGround/3/train",
		type = var26,
		params = {
			20,
			23
		}
	},
	{
		name = "backGround/2/saloon",
		type = var26,
		params = {
			15,
			20
		},
		states = {
			1,
			2,
			3
		}
	},
	{
		name = "backGround/1/meow",
		type = var26,
		params = {
			15,
			20
		},
		states = {
			1,
			2
		}
	},
	{
		name = "backGround/1/sheriff",
		type = var27,
		events = {
			var19,
			var18,
			var20
		},
		states = {
			1,
			2,
			3
		}
	}
}
local var29 = "state"
local var30 = "trigger"

local function var31(arg0, arg1, arg2)
	local var0 = {
		ctor = function(arg0)
			arg0._tplCows = arg0
			arg0._container = arg1
			arg0._event = arg2
			arg0.cows = {}
			arg0.cowWeights = {}

			for iter0 = 1, #var8 do
				arg0.cowWeights[iter0] = {}

				local var0 = var8[iter0][2]
				local var1 = 0

				for iter1, iter2 in ipairs(var0) do
					var1 = var1 + iter2

					table.insert(arg0.cowWeights[iter0], var1)
				end
			end
		end,
		start = function(arg0)
			arg0.nextCreateTime = 0
			arg0.lastTime = var5

			arg0:clear()
		end,
		step = function(arg0, arg1)
			arg0.lastTime = arg0.lastTime - Time.deltaTime

			if arg1 > arg0.nextCreateTime then
				arg0.nextCreateTime = arg1 + arg0:getNextCreateCowTime()

				arg0:createCow()
			end

			for iter0 = 1, #arg0.cows do
				local var0 = arg0.cows[iter0].tf
				local var1 = var0.anchoredPosition.x
				local var2 = var0.anchoredPosition

				var2.x = var2.x - arg0.cows[iter0].data.speed * Time.deltaTime

				local var3 = var2.x

				if var1 >= 0 and var3 <= 0 then
					arg0:setCowAniamtion(var0, var15)
				end

				var0.anchoredPosition = var2
			end

			for iter1 = #arg0.cows, 1, -1 do
				local var4 = arg0.cows[iter1].tf
				local var5 = var4.anchoredPosition

				if var4.anchoredPosition.x <= -var11 then
					local var6 = table.remove(arg0.cows, iter1)

					arg0:cowLeave(var6.tf)
				end
			end
		end,
		captureCow = function(arg0, arg1)
			local var0

			for iter0 = #arg0.cows, 1, -1 do
				local var1 = arg0.cows[iter0].tf
				local var2 = var1.anchoredPosition

				if var1.anchoredPosition.x >= var9[1] and var1.anchoredPosition.x <= var9[2] then
					if not var0 then
						var0 = iter0
					elseif arg0.cows[var0].tf.anchoredPosition.x - var1.anchoredPosition.x >= 0 then
						var0 = iter0
					end
				end
			end

			if var0 then
				local var3 = table.remove(arg0.cows, var0)

				arg0:setCowAniamtion(var3.tf, var14)

				if arg1 then
					arg1(true)
				end

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3)
				arg0._event:emit(var16, var3.data.score)
			elseif arg1 then
				arg1(false)
			end
		end,
		clear = function(arg0)
			for iter0 = 1, #arg0.cows do
				Destroy(arg0.cows[iter0].tf)
			end

			arg0.cows = {}
		end,
		destroy = function(arg0)
			arg0:clear()
		end,
		createCow = function(arg0)
			local var0 = arg0:getCowWeightIndex()
			local var1 = arg0.cowWeights[var0]
			local var2 = math.random(0, var1[#var1])
			local var3

			for iter0 = 1, #var1 do
				if var2 < var1[iter0] then
					var3 = iter0

					break
				end
			end

			var3 = var3 or math.random(1, #var7)

			local var4 = tf(Instantiate(arg0._tplCows[var3]))

			SetActive(var4, true)
			SetParent(var4, arg0._container)

			var4.anchoredPosition = Vector3(var11, 0, 0)

			arg0:setCowAniamtion(var4, var13)

			local var5 = Clone(var7[var3])

			GetOrAddComponent(findTF(var4, "anim"), typeof(DftAniEvent)):SetEndEvent(function()
				arg0:cowLeave(var4)
			end)
			table.insert(arg0.cows, {
				tf = var4,
				data = var5
			})
		end,
		getCowWeightIndex = function(arg0)
			for iter0 = 1, #var8 do
				if arg0.lastTime and arg0.lastTime < var8[iter0][1] then
					return iter0
				end
			end

			return #var8
		end,
		getNextCreateCowTime = function(arg0)
			local var0

			for iter0 = 1, #var6 do
				if arg0.lastTime < var6[iter0][1] then
					local var1 = var6[iter0][2]

					return 0.3 + var1[1] + math.random() * (var1[2] - var1[1])
				end
			end

			local var2 = var6[#var6][2]

			return math.random(var2[1], var2[2])
		end,
		setCowAniamtion = function(arg0, arg1, arg2)
			GetComponent(findTF(arg1, "anim"), typeof(Animator)):SetInteger("state", arg2)
		end,
		cowLeave = function(arg0, arg1)
			Destroy(arg1)
		end
	}

	var0:ctor()

	return var0
end

local function var32(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._playerTf = arg0
			arg0._initPosition = arg0._playerTf.anchoredPosition
			arg0._animator = GetComponent(findTF(arg0._playerTf, "img"), typeof(Animator))

			arg0:setPlayerAnim(var21)

			arg0._event = arg1
			arg0.playerDft = GetOrAddComponent(findTF(arg0._playerTf, "img"), typeof(DftAniEvent))

			arg0.playerDft:SetTriggerEvent(function()
				arg0._event:emit(var25, nil, function(arg0)
					if arg0 then
						arg0:setPlayerAnim(var23)
						arg0._event:emit(var18)
					else
						arg0:setPlayerAnim(var22)
					end
				end)
			end)
			arg0.playerDft:SetEndEvent(function()
				arg0._event:emit(var19)
			end)
		end,
		throw = function(arg0)
			if arg0.captureCdTime then
				return
			end

			arg0.captureCdTime = var10

			arg0:setPlayerAnim(var24)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4)
		end,
		setPlayerAnim = function(arg0, arg1)
			arg0._animator:SetTrigger(arg1)
		end,
		start = function(arg0)
			arg0.captureCdTime = 0
		end,
		getThrowTime = function(arg0)
			return arg0.captureCdTime
		end,
		step = function(arg0, arg1)
			if arg0.captureCdTime then
				if arg0.captureCdTime < 0 then
					arg0.captureCdTime = nil

					arg0:setPlayerAnim(var21)
					arg0._event:emit(var20)
				else
					arg0.captureCdTime = arg0.captureCdTime - Time.deltaTime
				end
			end
		end,
		destory = function(arg0)
			return
		end
	}

	var0:ctor()

	return var0
end

local function var33(arg0)
	local var0 = {
		ctor = function(arg0)
			arg0._backSceneTf = arg0

			if not arg0.sceneItems then
				arg0.sceneItems = {}

				for iter0 = 1, #var28 do
					local var0 = findTF(arg0._backSceneTf, var28[iter0].name)

					table.insert(arg0.sceneItems, {
						tf = var0,
						data = var28[iter0]
					})
				end
			end
		end,
		onEventHandle = function(arg0, arg1)
			for iter0 = 1, #arg0.sceneItems do
				local var0 = arg0.sceneItems[iter0].data
				local var1 = arg0.sceneItems[iter0].tf

				if var0.type == var27 then
					local var2 = var0.events

					for iter1, iter2 in ipairs(var2) do
						if iter2 == arg1 and var0.states then
							arg0:changeSceneItemAnim(var29, var0.states[iter1], var1)
						end
					end
				end
			end
		end,
		step = function(arg0, arg1)
			for iter0 = 1, #arg0.sceneItems do
				local var0 = arg0.sceneItems[iter0]
				local var1 = var0.data
				local var2 = var0.tf

				if var1.type == var26 then
					if not var0.time then
						var0.time = math.random(var1.params[1], var1.params[2])
					elseif var0.time > 0 then
						var0.time = var0.time - Time.deltaTime
					else
						var0.time = math.random(var1.params[1], var1.params[2])

						if var1.states then
							arg0:changeSceneItemAnim(var29, var1.states[math.random(1, #var1.states)], var2)
						elseif var1.trigger then
							arg0:changeSceneItemAnim(var30, nil, var2)
						end
					end
				end
			end
		end,
		changeSceneItemAnim = function(arg0, arg1, arg2, arg3)
			local var0 = GetComponent(arg3, typeof(Animator))

			if arg1 == var29 then
				var0:SetInteger("state", arg2)
			elseif arg1 == var30 then
				var0:SetTrigger("trigger")
			end
		end
	}

	var0:ctor()

	return var0
end

function var0.getUIName(arg0)
	return "RopingCowGameUI"
end

function var0.getBGM(arg0)
	return var1
end

function var0.didEnter(arg0)
	arg0:initEvent()
	arg0:initData()
	arg0:initUI()
	arg0:initGameUI()
	arg0:updateMenuUI()
	arg0:openMenuUI()
end

function var0.initEvent(arg0)
	arg0:bind(var16, function(arg0, arg1, arg2)
		arg0:addScore(arg1)
		arg0:onEventHandle(var16)
	end)
	arg0:bind(var25, function(arg0, arg1, arg2)
		if arg0._cowController then
			arg0._cowController:captureCow(arg2)
		end

		arg0:onEventHandle(var25)
	end)
	arg0:bind(var18, function(arg0, arg1, arg2)
		arg0:onEventHandle(var18)
	end)
	arg0:bind(var19, function(arg0, arg1, arg2)
		arg0:onEventHandle(var19)
	end)
	arg0:bind(var20, function(arg0, arg1, arg2)
		arg0:onEventHandle(var20)
	end)
end

function var0.onEventHandle(arg0, arg1)
	if arg0._sceneItemController then
		arg0._sceneItemController:onEventHandle(arg1)
	end
end

function var0.initData(arg0)
	local var0 = Application.targetFrameRate or 60

	if var0 > 60 then
		var0 = 60
	end

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 1 / var0, -1)
end

function var0.initUI(arg0)
	arg0.backSceneTf = findTF(arg0._tf, "scene_background")
	arg0.sceneTf = findTF(arg0._tf, "scene")
	arg0.clickMask = findTF(arg0._tf, "clickMask")
	arg0.countUI = findTF(arg0._tf, "pop/CountUI")
	arg0.countAnimator = GetComponent(findTF(arg0.countUI, "count"), typeof(Animator))
	arg0.countDft = GetOrAddComponent(findTF(arg0.countUI, "count"), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		setActive(arg0.countUI, false)
		arg0:gameStart()
	end)

	arg0.leaveUI = findTF(arg0._tf, "pop/LeaveUI")

	onButton(arg0, findTF(arg0.leaveUI, "ad/btnOk"), function()
		arg0:resumeGame()
		arg0:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.leaveUI, "ad/btnCancel"), function()
		arg0:resumeGame()
	end, SFX_CANCEL)

	arg0.pauseUI = findTF(arg0._tf, "pop/pauseUI")

	onButton(arg0, findTF(arg0.pauseUI, "ad/btnOk"), function()
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()
	end, SFX_CANCEL)

	arg0.settlementUI = findTF(arg0._tf, "pop/SettleMentUI")

	onButton(arg0, findTF(arg0.settlementUI, "ad/btnOver"), function()
		setActive(arg0.settlementUI, false)
		arg0:openMenuUI()
	end, SFX_CANCEL)

	arg0.menuUI = findTF(arg0._tf, "pop/menuUI")
	arg0.battleScrollRect = GetComponent(findTF(arg0.menuUI, "battList"), typeof(ScrollRect))
	arg0.totalTimes = arg0:getGameTotalTime()

	local var0 = arg0:getGameUsedTimes() - 4 < 0 and 0 or arg0:getGameUsedTimes() - 4

	scrollTo(arg0.battleScrollRect, 0, 1 - var0 / (arg0.totalTimes - 4))
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowUp"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y + 1 / (arg0.totalTimes - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowDown"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y - 1 / (arg0.totalTimes - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.cowboy_tips.tip
		})
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnStart"), function()
		setActive(arg0.menuUI, false)
		arg0:readyStart()
	end, SFX_CANCEL)

	local var1 = findTF(arg0.menuUI, "tplBattleItem")

	arg0.battleItems = {}
	arg0.dropItems = {}

	local var2 = pg.mini_game[arg0:GetMGData().id].simple_config_data.drop

	for iter0 = 1, #var2 do
		local var3 = tf(instantiate(var1))

		var3.name = "battleItem_" .. iter0

		setParent(var3, findTF(arg0.menuUI, "battList/Viewport/Content"))

		local var4 = iter0

		GetSpriteFromAtlasAsync("ui/minigameui/ropingcowgameui_atlas", "battleDesc" .. var4, function(arg0)
			setImageSprite(findTF(var3, "state_open/buttomDesc"), arg0, true)
			setImageSprite(findTF(var3, "state_clear/buttomDesc"), arg0, true)
			setImageSprite(findTF(var3, "state_current/buttomDesc"), arg0, true)
			setImageSprite(findTF(var3, "state_closed/buttomDesc"), arg0, true)
		end)

		local var5 = findTF(var3, "icon")
		local var6 = {
			type = var2[iter0][1],
			id = var2[iter0][2],
			amount = var2[iter0][3]
		}

		updateDrop(var5, var6)
		onButton(arg0, var5, function()
			arg0:emit(BaseUI.ON_DROP, var6)
		end, SFX_PANEL)
		table.insert(arg0.dropItems, var5)
		setActive(var3, true)
		table.insert(arg0.battleItems, var3)
	end

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.initGameUI(arg0)
	arg0.gameUI = findTF(arg0._tf, "ui/gameUI")

	onButton(arg0, findTF(arg0.gameUI, "topRight/btnStop"), function()
		arg0:stopGame()
		setActive(arg0.pauseUI, true)
	end)
	onButton(arg0, findTF(arg0.gameUI, "btnLeave"), function()
		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end)

	arg0.gameTimeS = findTF(arg0.gameUI, "top/time/s")
	arg0.scoreTf = findTF(arg0.gameUI, "top/score")
	arg0.btnCapture = findTF(arg0.gameUI, "btnCapture")
	arg0.captureButton = GetOrAddComponent(arg0.btnCapture, "EventTriggerListener")

	arg0.captureButton:AddPointDownFunc(function(arg0, arg1)
		if arg0._playerController then
			arg0._playerController:throw()
		end
	end)

	local var0 = findTF(arg0.sceneTf, "cowContainer")
	local var1 = {}

	for iter0 = 1, var12 do
		local var2 = findTF(arg0.sceneTf, "cow" .. iter0)

		table.insert(var1, var2)
	end

	arg0.sceneScoreTf = findTF(arg0.sceneTf, "score")
	arg0._playerController = var32(findTF(arg0.sceneTf, "player"), arg0)
	arg0._cowController = var31(var1, var0, arg0)
	arg0._sceneItemController = var33(arg0.backSceneTf)
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end

	if IsUnityEditor and Input.GetKeyDown(KeyCode.S) and arg0._playerController then
		arg0._playerController:throw()
	end
end

function var0.updateMenuUI(arg0)
	local var0 = arg0:getGameUsedTimes()
	local var1 = arg0:getGameTimes()

	for iter0 = 1, #arg0.battleItems do
		setActive(findTF(arg0.battleItems[iter0], "state_open"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_closed"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_clear"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_current"), false)

		if iter0 <= var0 then
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_clear/icon"))
			setActive(arg0.dropItems[iter0], true)
			setActive(findTF(arg0.battleItems[iter0], "state_clear"), true)
		elseif iter0 == var0 + 1 and var1 >= 1 then
			setActive(findTF(arg0.battleItems[iter0], "state_current"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_current/icon"))
			setActive(arg0.dropItems[iter0], true)
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			setActive(findTF(arg0.battleItems[iter0], "state_open"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_open/icon"))
			setActive(arg0.dropItems[iter0], true)
		else
			setActive(findTF(arg0.battleItems[iter0], "state_closed"), true)
			setActive(arg0.dropItems[iter0], false)
		end
	end

	arg0.totalTimes = arg0:getGameTotalTime()

	local var2 = 1 - (arg0:getGameUsedTimes() - 3 < 0 and 0 or arg0:getGameUsedTimes() - 3) / (arg0.totalTimes - 4)

	if var2 > 1 then
		var2 = 1
	end

	scrollTo(arg0.battleScrollRect, 0, var2)
	setActive(findTF(arg0.menuUI, "btnStart/tip"), var1 > 0)
	arg0:CheckGet()
end

function var0.CheckGet(arg0)
	setActive(findTF(arg0.menuUI, "got"), false)

	if arg0:getUltimate() and arg0:getUltimate() ~= 0 then
		setActive(findTF(arg0.menuUI, "got"), true)
	end

	if arg0:getUltimate() == 0 then
		if arg0:getGameTotalTime() > arg0:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0.menuUI, "got"), true)
	end
end

function var0.openMenuUI(arg0)
	setActive(findTF(arg0._tf, "scene_front"), false)
	setActive(findTF(arg0._tf, "scene_background"), false)
	setActive(findTF(arg0._tf, "scene"), false)
	setActive(arg0.gameUI, false)
	setActive(arg0.menuUI, true)
	arg0:updateMenuUI()
end

function var0.clearUI(arg0)
	setActive(arg0.sceneTf, false)
	setActive(arg0.settlementUI, false)
	setActive(arg0.countUI, false)
	setActive(arg0.menuUI, false)
	setActive(arg0.gameUI, false)
end

function var0.readyStart(arg0)
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2)
end

function var0.gameStart(arg0)
	setActive(findTF(arg0._tf, "scene_front"), true)
	setActive(findTF(arg0._tf, "scene_background"), true)
	setActive(findTF(arg0._tf, "scene"), true)
	setActive(arg0.gameUI, true)

	arg0.gameStartFlag = true
	arg0.scoreNum = 0
	arg0.playerPosIndex = 2
	arg0.gameStepTime = 0
	arg0.heart = 3
	arg0.gameTime = var5

	if arg0._cowController then
		arg0._cowController:start()
	end

	if arg0._playerController then
		arg0._playerController:start()
	end

	arg0:updateGameUI()
	arg0:timerStart()
end

function var0.getGameTimes(arg0)
	return arg0:GetMGHubData().count
end

function var0.getGameUsedTimes(arg0)
	return arg0:GetMGHubData().usedtime
end

function var0.getUltimate(arg0)
	return arg0:GetMGHubData().ultimate
end

function var0.getGameTotalTime(arg0)
	return (arg0:GetMGHubData():getConfig("reward_need"))
end

function var0.changeSpeed(arg0, arg1)
	return
end

function var0.onTimer(arg0)
	arg0:gameStep()
end

function var0.gameStep(arg0)
	arg0.gameTime = arg0.gameTime - Time.deltaTime

	if arg0.gameTime < 0 then
		arg0.gameTime = 0
	end

	arg0.gameStepTime = arg0.gameStepTime + Time.deltaTime

	if arg0._cowController then
		arg0._cowController:step(arg0.gameStepTime)
	end

	if arg0._playerController then
		arg0._playerController:step(arg0.gameStepTime)
	end

	if arg0._sceneItemController then
		arg0._sceneItemController:step(arg0.gameStepTime)
	end

	arg0:updateGameUI()

	if arg0.gameTime <= 0 then
		arg0:onGameOver()

		return
	end
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.updateGameUI(arg0)
	setText(arg0.scoreTf, arg0.scoreNum)
	setText(arg0.gameTimeS, math.ceil(arg0.gameTime))

	if not arg0.captureCdMaskImg then
		arg0.captureCdMaskImg = GetComponent(findTF(arg0.btnCapture, "cd"), typeof(Image))
	end

	if arg0._playerController then
		local var0 = arg0._playerController:getThrowTime()

		if var0 and var0 > 0 then
			local var1 = var0 / var10

			arg0.captureCdMaskImg.fillAmount = var1
		else
			arg0.captureCdMaskImg.fillAmount = 0
		end
	end
end

function var0.addScore(arg0, arg1)
	arg0.scoreNum = arg0.scoreNum + arg1

	if arg0.scoreNum < 0 then
		arg0.scoreNum = 0
	end

	setActive(arg0.sceneScoreTf, false)

	for iter0 = 0, arg0.sceneScoreTf.childCount - 1 do
		local var0 = arg0.sceneScoreTf:GetChild(iter0)

		if var0.name == tostring(arg1) then
			setActive(var0, true)
		else
			setActive(var0, false)
		end
	end

	setActive(arg0.sceneScoreTf, true)
end

function var0.onGameOver(arg0)
	if arg0.settlementFlag then
		return
	end

	arg0:timerStop()

	arg0.settlementFlag = true

	setActive(arg0.sceneScoreTf, false)
	setActive(arg0.clickMask, true)

	if arg0._cowController then
		arg0._cowController:clear()
	end

	LeanTween.delayedCall(go(arg0._tf), 0.1, System.Action(function()
		arg0.settlementFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
		arg0:showSettlement()
	end))
end

function var0.showSettlement(arg0)
	setActive(arg0.settlementUI, true)
	GetComponent(findTF(arg0.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = arg0.scoreNum
	local var2 = var0 and #var0 > 0 and var0[1] or 0

	setActive(findTF(arg0.settlementUI, "ad/new"), var2 < var1)

	if var2 <= var1 then
		var2 = var1

		arg0:StoreDataToServer({
			var2
		})
	end

	local var3 = findTF(arg0.settlementUI, "ad/highText")
	local var4 = findTF(arg0.settlementUI, "ad/currentText")

	setText(var3, var2)
	setText(var4, var1)

	if arg0:getGameTimes() and arg0:getGameTimes() > 0 then
		arg0.sendSuccessFlag = true

		arg0:SendSuccess(0)
	end
end

function var0.resumeGame(arg0)
	arg0.gameStop = false

	setActive(arg0.leaveUI, false)
	arg0:changeSpeed(1)
	arg0:timerStart()
end

function var0.stopGame(arg0)
	arg0.gameStop = true

	arg0:timerStop()
	arg0:changeSpeed(0)
end

function var0.onBackPressed(arg0)
	if not arg0.gameStartFlag then
		arg0:emit(var0.ON_BACK_PRESSED)
	else
		if arg0.settlementFlag then
			return
		end

		if isActive(arg0.pauseUI) then
			setActive(arg0.pauseUI, false)
		end

		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	if arg0._tf and LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	Time.timeScale = 1
	arg0.timer = nil
end

return var0
