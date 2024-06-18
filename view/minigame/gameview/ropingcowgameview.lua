local var0_0 = class("RopingCowGameView", import("..BaseMiniGameView"))
local var1_0 = "SailAwayJustice-inst"
local var2_0 = "event:/ui/ddldaoshu2"
local var3_0 = "event:/ui/niujiao"
local var4_0 = "event:/ui/taosheng"
local var5_0 = 60
local var6_0 = {
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
local var7_0 = {
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
local var8_0 = {
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
local var9_0 = {
	-50,
	50
}
local var10_0 = 0.75
local var11_0 = 1700
local var12_0 = 4
local var13_0 = 0
local var14_0 = 1
local var15_0 = 2
local var16_0 = "cow_event_capture"
local var17_0 = "player_event_capture"
local var18_0 = "player_event_get"
local var19_0 = "player_event_miss"
local var20_0 = "player_event_cd"
local var21_0 = "idol"
local var22_0 = "miss"
local var23_0 = "get"
local var24_0 = "throw"
local var25_0 = "event_capture"
local var26_0 = "scene_item_type_time"
local var27_0 = "scene_item_type_event"
local var28_0 = {
	{
		name = "backGround/2/jiujiuA",
		type = var26_0,
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
		type = var26_0,
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
		type = var26_0,
		params = {
			15,
			20
		}
	},
	{
		trigger = true,
		name = "backGround/3/jiujiuD",
		type = var26_0,
		params = {
			20,
			22
		}
	},
	{
		trigger = true,
		name = "backGround/3/train",
		type = var26_0,
		params = {
			20,
			23
		}
	},
	{
		name = "backGround/2/saloon",
		type = var26_0,
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
		type = var26_0,
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
		type = var27_0,
		events = {
			var19_0,
			var18_0,
			var20_0
		},
		states = {
			1,
			2,
			3
		}
	}
}
local var29_0 = "state"
local var30_0 = "trigger"

local function var31_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = {
		ctor = function(arg0_2)
			arg0_2._tplCows = arg0_1
			arg0_2._container = arg1_1
			arg0_2._event = arg2_1
			arg0_2.cows = {}
			arg0_2.cowWeights = {}

			for iter0_2 = 1, #var8_0 do
				arg0_2.cowWeights[iter0_2] = {}

				local var0_2 = var8_0[iter0_2][2]
				local var1_2 = 0

				for iter1_2, iter2_2 in ipairs(var0_2) do
					var1_2 = var1_2 + iter2_2

					table.insert(arg0_2.cowWeights[iter0_2], var1_2)
				end
			end
		end,
		start = function(arg0_3)
			arg0_3.nextCreateTime = 0
			arg0_3.lastTime = var5_0

			arg0_3:clear()
		end,
		step = function(arg0_4, arg1_4)
			arg0_4.lastTime = arg0_4.lastTime - Time.deltaTime

			if arg1_4 > arg0_4.nextCreateTime then
				arg0_4.nextCreateTime = arg1_4 + arg0_4:getNextCreateCowTime()

				arg0_4:createCow()
			end

			for iter0_4 = 1, #arg0_4.cows do
				local var0_4 = arg0_4.cows[iter0_4].tf
				local var1_4 = var0_4.anchoredPosition.x
				local var2_4 = var0_4.anchoredPosition

				var2_4.x = var2_4.x - arg0_4.cows[iter0_4].data.speed * Time.deltaTime

				local var3_4 = var2_4.x

				if var1_4 >= 0 and var3_4 <= 0 then
					arg0_4:setCowAniamtion(var0_4, var15_0)
				end

				var0_4.anchoredPosition = var2_4
			end

			for iter1_4 = #arg0_4.cows, 1, -1 do
				local var4_4 = arg0_4.cows[iter1_4].tf
				local var5_4 = var4_4.anchoredPosition

				if var4_4.anchoredPosition.x <= -var11_0 then
					local var6_4 = table.remove(arg0_4.cows, iter1_4)

					arg0_4:cowLeave(var6_4.tf)
				end
			end
		end,
		captureCow = function(arg0_5, arg1_5)
			local var0_5

			for iter0_5 = #arg0_5.cows, 1, -1 do
				local var1_5 = arg0_5.cows[iter0_5].tf
				local var2_5 = var1_5.anchoredPosition

				if var1_5.anchoredPosition.x >= var9_0[1] and var1_5.anchoredPosition.x <= var9_0[2] then
					if not var0_5 then
						var0_5 = iter0_5
					elseif arg0_5.cows[var0_5].tf.anchoredPosition.x - var1_5.anchoredPosition.x >= 0 then
						var0_5 = iter0_5
					end
				end
			end

			if var0_5 then
				local var3_5 = table.remove(arg0_5.cows, var0_5)

				arg0_5:setCowAniamtion(var3_5.tf, var14_0)

				if arg1_5 then
					arg1_5(true)
				end

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3_0)
				arg0_5._event:emit(var16_0, var3_5.data.score)
			elseif arg1_5 then
				arg1_5(false)
			end
		end,
		clear = function(arg0_6)
			for iter0_6 = 1, #arg0_6.cows do
				Destroy(arg0_6.cows[iter0_6].tf)
			end

			arg0_6.cows = {}
		end,
		destroy = function(arg0_7)
			arg0_7:clear()
		end,
		createCow = function(arg0_8)
			local var0_8 = arg0_8:getCowWeightIndex()
			local var1_8 = arg0_8.cowWeights[var0_8]
			local var2_8 = math.random(0, var1_8[#var1_8])
			local var3_8

			for iter0_8 = 1, #var1_8 do
				if var2_8 < var1_8[iter0_8] then
					var3_8 = iter0_8

					break
				end
			end

			var3_8 = var3_8 or math.random(1, #var7_0)

			local var4_8 = tf(Instantiate(arg0_8._tplCows[var3_8]))

			SetActive(var4_8, true)
			SetParent(var4_8, arg0_8._container)

			var4_8.anchoredPosition = Vector3(var11_0, 0, 0)

			arg0_8:setCowAniamtion(var4_8, var13_0)

			local var5_8 = Clone(var7_0[var3_8])

			GetOrAddComponent(findTF(var4_8, "anim"), typeof(DftAniEvent)):SetEndEvent(function()
				arg0_8:cowLeave(var4_8)
			end)
			table.insert(arg0_8.cows, {
				tf = var4_8,
				data = var5_8
			})
		end,
		getCowWeightIndex = function(arg0_10)
			for iter0_10 = 1, #var8_0 do
				if arg0_10.lastTime and arg0_10.lastTime < var8_0[iter0_10][1] then
					return iter0_10
				end
			end

			return #var8_0
		end,
		getNextCreateCowTime = function(arg0_11)
			local var0_11

			for iter0_11 = 1, #var6_0 do
				if arg0_11.lastTime < var6_0[iter0_11][1] then
					local var1_11 = var6_0[iter0_11][2]

					return 0.3 + var1_11[1] + math.random() * (var1_11[2] - var1_11[1])
				end
			end

			local var2_11 = var6_0[#var6_0][2]

			return math.random(var2_11[1], var2_11[2])
		end,
		setCowAniamtion = function(arg0_12, arg1_12, arg2_12)
			GetComponent(findTF(arg1_12, "anim"), typeof(Animator)):SetInteger("state", arg2_12)
		end,
		cowLeave = function(arg0_13, arg1_13)
			Destroy(arg1_13)
		end
	}

	var0_1:ctor()

	return var0_1
end

local function var32_0(arg0_14, arg1_14)
	local var0_14 = {
		ctor = function(arg0_15)
			arg0_15._playerTf = arg0_14
			arg0_15._initPosition = arg0_15._playerTf.anchoredPosition
			arg0_15._animator = GetComponent(findTF(arg0_15._playerTf, "img"), typeof(Animator))

			arg0_15:setPlayerAnim(var21_0)

			arg0_15._event = arg1_14
			arg0_15.playerDft = GetOrAddComponent(findTF(arg0_15._playerTf, "img"), typeof(DftAniEvent))

			arg0_15.playerDft:SetTriggerEvent(function()
				arg0_15._event:emit(var25_0, nil, function(arg0_17)
					if arg0_17 then
						arg0_15:setPlayerAnim(var23_0)
						arg0_15._event:emit(var18_0)
					else
						arg0_15:setPlayerAnim(var22_0)
					end
				end)
			end)
			arg0_15.playerDft:SetEndEvent(function()
				arg0_15._event:emit(var19_0)
			end)
		end,
		throw = function(arg0_19)
			if arg0_19.captureCdTime then
				return
			end

			arg0_19.captureCdTime = var10_0

			arg0_19:setPlayerAnim(var24_0)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4_0)
		end,
		setPlayerAnim = function(arg0_20, arg1_20)
			arg0_20._animator:SetTrigger(arg1_20)
		end,
		start = function(arg0_21)
			arg0_21.captureCdTime = 0
		end,
		getThrowTime = function(arg0_22)
			return arg0_22.captureCdTime
		end,
		step = function(arg0_23, arg1_23)
			if arg0_23.captureCdTime then
				if arg0_23.captureCdTime < 0 then
					arg0_23.captureCdTime = nil

					arg0_23:setPlayerAnim(var21_0)
					arg0_23._event:emit(var20_0)
				else
					arg0_23.captureCdTime = arg0_23.captureCdTime - Time.deltaTime
				end
			end
		end,
		destory = function(arg0_24)
			return
		end
	}

	var0_14:ctor()

	return var0_14
end

local function var33_0(arg0_25)
	local var0_25 = {
		ctor = function(arg0_26)
			arg0_26._backSceneTf = arg0_25

			if not arg0_26.sceneItems then
				arg0_26.sceneItems = {}

				for iter0_26 = 1, #var28_0 do
					local var0_26 = findTF(arg0_26._backSceneTf, var28_0[iter0_26].name)

					table.insert(arg0_26.sceneItems, {
						tf = var0_26,
						data = var28_0[iter0_26]
					})
				end
			end
		end,
		onEventHandle = function(arg0_27, arg1_27)
			for iter0_27 = 1, #arg0_27.sceneItems do
				local var0_27 = arg0_27.sceneItems[iter0_27].data
				local var1_27 = arg0_27.sceneItems[iter0_27].tf

				if var0_27.type == var27_0 then
					local var2_27 = var0_27.events

					for iter1_27, iter2_27 in ipairs(var2_27) do
						if iter2_27 == arg1_27 and var0_27.states then
							arg0_27:changeSceneItemAnim(var29_0, var0_27.states[iter1_27], var1_27)
						end
					end
				end
			end
		end,
		step = function(arg0_28, arg1_28)
			for iter0_28 = 1, #arg0_28.sceneItems do
				local var0_28 = arg0_28.sceneItems[iter0_28]
				local var1_28 = var0_28.data
				local var2_28 = var0_28.tf

				if var1_28.type == var26_0 then
					if not var0_28.time then
						var0_28.time = math.random(var1_28.params[1], var1_28.params[2])
					elseif var0_28.time > 0 then
						var0_28.time = var0_28.time - Time.deltaTime
					else
						var0_28.time = math.random(var1_28.params[1], var1_28.params[2])

						if var1_28.states then
							arg0_28:changeSceneItemAnim(var29_0, var1_28.states[math.random(1, #var1_28.states)], var2_28)
						elseif var1_28.trigger then
							arg0_28:changeSceneItemAnim(var30_0, nil, var2_28)
						end
					end
				end
			end
		end,
		changeSceneItemAnim = function(arg0_29, arg1_29, arg2_29, arg3_29)
			local var0_29 = GetComponent(arg3_29, typeof(Animator))

			if arg1_29 == var29_0 then
				var0_29:SetInteger("state", arg2_29)
			elseif arg1_29 == var30_0 then
				var0_29:SetTrigger("trigger")
			end
		end
	}

	var0_25:ctor()

	return var0_25
end

function var0_0.getUIName(arg0_30)
	return "RopingCowGameUI"
end

function var0_0.getBGM(arg0_31)
	return var1_0
end

function var0_0.didEnter(arg0_32)
	arg0_32:initEvent()
	arg0_32:initData()
	arg0_32:initUI()
	arg0_32:initGameUI()
	arg0_32:updateMenuUI()
	arg0_32:openMenuUI()
end

function var0_0.initEvent(arg0_33)
	arg0_33:bind(var16_0, function(arg0_34, arg1_34, arg2_34)
		arg0_33:addScore(arg1_34)
		arg0_33:onEventHandle(var16_0)
	end)
	arg0_33:bind(var25_0, function(arg0_35, arg1_35, arg2_35)
		if arg0_33._cowController then
			arg0_33._cowController:captureCow(arg2_35)
		end

		arg0_33:onEventHandle(var25_0)
	end)
	arg0_33:bind(var18_0, function(arg0_36, arg1_36, arg2_36)
		arg0_33:onEventHandle(var18_0)
	end)
	arg0_33:bind(var19_0, function(arg0_37, arg1_37, arg2_37)
		arg0_33:onEventHandle(var19_0)
	end)
	arg0_33:bind(var20_0, function(arg0_38, arg1_38, arg2_38)
		arg0_33:onEventHandle(var20_0)
	end)
end

function var0_0.onEventHandle(arg0_39, arg1_39)
	if arg0_39._sceneItemController then
		arg0_39._sceneItemController:onEventHandle(arg1_39)
	end
end

function var0_0.initData(arg0_40)
	local var0_40 = Application.targetFrameRate or 60

	if var0_40 > 60 then
		var0_40 = 60
	end

	arg0_40.timer = Timer.New(function()
		arg0_40:onTimer()
	end, 1 / var0_40, -1)
end

function var0_0.initUI(arg0_42)
	arg0_42.backSceneTf = findTF(arg0_42._tf, "scene_background")
	arg0_42.sceneTf = findTF(arg0_42._tf, "scene")
	arg0_42.clickMask = findTF(arg0_42._tf, "clickMask")
	arg0_42.countUI = findTF(arg0_42._tf, "pop/CountUI")
	arg0_42.countAnimator = GetComponent(findTF(arg0_42.countUI, "count"), typeof(Animator))
	arg0_42.countDft = GetOrAddComponent(findTF(arg0_42.countUI, "count"), typeof(DftAniEvent))

	arg0_42.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_42.countDft:SetEndEvent(function()
		setActive(arg0_42.countUI, false)
		arg0_42:gameStart()
	end)

	arg0_42.leaveUI = findTF(arg0_42._tf, "pop/LeaveUI")

	onButton(arg0_42, findTF(arg0_42.leaveUI, "ad/btnOk"), function()
		arg0_42:resumeGame()
		arg0_42:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0_42, findTF(arg0_42.leaveUI, "ad/btnCancel"), function()
		arg0_42:resumeGame()
	end, SFX_CANCEL)

	arg0_42.pauseUI = findTF(arg0_42._tf, "pop/pauseUI")

	onButton(arg0_42, findTF(arg0_42.pauseUI, "ad/btnOk"), function()
		setActive(arg0_42.pauseUI, false)
		arg0_42:resumeGame()
	end, SFX_CANCEL)

	arg0_42.settlementUI = findTF(arg0_42._tf, "pop/SettleMentUI")

	onButton(arg0_42, findTF(arg0_42.settlementUI, "ad/btnOver"), function()
		setActive(arg0_42.settlementUI, false)
		arg0_42:openMenuUI()
	end, SFX_CANCEL)

	arg0_42.menuUI = findTF(arg0_42._tf, "pop/menuUI")
	arg0_42.battleScrollRect = GetComponent(findTF(arg0_42.menuUI, "battList"), typeof(ScrollRect))
	arg0_42.totalTimes = arg0_42:getGameTotalTime()

	local var0_42 = arg0_42:getGameUsedTimes() - 4 < 0 and 0 or arg0_42:getGameUsedTimes() - 4

	scrollTo(arg0_42.battleScrollRect, 0, 1 - var0_42 / (arg0_42.totalTimes - 4))
	onButton(arg0_42, findTF(arg0_42.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_49 = arg0_42.battleScrollRect.normalizedPosition.y + 1 / (arg0_42.totalTimes - 4)

		if var0_49 > 1 then
			var0_49 = 1
		end

		scrollTo(arg0_42.battleScrollRect, 0, var0_49)
	end, SFX_CANCEL)
	onButton(arg0_42, findTF(arg0_42.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_50 = arg0_42.battleScrollRect.normalizedPosition.y - 1 / (arg0_42.totalTimes - 4)

		if var0_50 < 0 then
			var0_50 = 0
		end

		scrollTo(arg0_42.battleScrollRect, 0, var0_50)
	end, SFX_CANCEL)
	onButton(arg0_42, findTF(arg0_42.menuUI, "btnBack"), function()
		arg0_42:closeView()
	end, SFX_CANCEL)
	onButton(arg0_42, findTF(arg0_42.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.cowboy_tips.tip
		})
	end, SFX_CANCEL)
	onButton(arg0_42, findTF(arg0_42.menuUI, "btnStart"), function()
		setActive(arg0_42.menuUI, false)
		arg0_42:readyStart()
	end, SFX_CANCEL)

	local var1_42 = findTF(arg0_42.menuUI, "tplBattleItem")

	arg0_42.battleItems = {}
	arg0_42.dropItems = {}

	local var2_42 = pg.mini_game[arg0_42:GetMGData().id].simple_config_data.drop

	for iter0_42 = 1, #var2_42 do
		local var3_42 = tf(instantiate(var1_42))

		var3_42.name = "battleItem_" .. iter0_42

		setParent(var3_42, findTF(arg0_42.menuUI, "battList/Viewport/Content"))

		local var4_42 = iter0_42

		GetSpriteFromAtlasAsync("ui/minigameui/ropingcowgameui_atlas", "battleDesc" .. var4_42, function(arg0_54)
			setImageSprite(findTF(var3_42, "state_open/buttomDesc"), arg0_54, true)
			setImageSprite(findTF(var3_42, "state_clear/buttomDesc"), arg0_54, true)
			setImageSprite(findTF(var3_42, "state_current/buttomDesc"), arg0_54, true)
			setImageSprite(findTF(var3_42, "state_closed/buttomDesc"), arg0_54, true)
		end)

		local var5_42 = findTF(var3_42, "icon")
		local var6_42 = {
			type = var2_42[iter0_42][1],
			id = var2_42[iter0_42][2],
			amount = var2_42[iter0_42][3]
		}

		updateDrop(var5_42, var6_42)
		onButton(arg0_42, var5_42, function()
			arg0_42:emit(BaseUI.ON_DROP, var6_42)
		end, SFX_PANEL)
		table.insert(arg0_42.dropItems, var5_42)
		setActive(var3_42, true)
		table.insert(arg0_42.battleItems, var3_42)
	end

	if not arg0_42.handle then
		arg0_42.handle = UpdateBeat:CreateListener(arg0_42.Update, arg0_42)
	end

	UpdateBeat:AddListener(arg0_42.handle)
end

function var0_0.initGameUI(arg0_56)
	arg0_56.gameUI = findTF(arg0_56._tf, "ui/gameUI")

	onButton(arg0_56, findTF(arg0_56.gameUI, "topRight/btnStop"), function()
		arg0_56:stopGame()
		setActive(arg0_56.pauseUI, true)
	end)
	onButton(arg0_56, findTF(arg0_56.gameUI, "btnLeave"), function()
		arg0_56:stopGame()
		setActive(arg0_56.leaveUI, true)
	end)

	arg0_56.gameTimeS = findTF(arg0_56.gameUI, "top/time/s")
	arg0_56.scoreTf = findTF(arg0_56.gameUI, "top/score")
	arg0_56.btnCapture = findTF(arg0_56.gameUI, "btnCapture")
	arg0_56.captureButton = GetOrAddComponent(arg0_56.btnCapture, "EventTriggerListener")

	arg0_56.captureButton:AddPointDownFunc(function(arg0_59, arg1_59)
		if arg0_56._playerController then
			arg0_56._playerController:throw()
		end
	end)

	local var0_56 = findTF(arg0_56.sceneTf, "cowContainer")
	local var1_56 = {}

	for iter0_56 = 1, var12_0 do
		local var2_56 = findTF(arg0_56.sceneTf, "cow" .. iter0_56)

		table.insert(var1_56, var2_56)
	end

	arg0_56.sceneScoreTf = findTF(arg0_56.sceneTf, "score")
	arg0_56._playerController = var32_0(findTF(arg0_56.sceneTf, "player"), arg0_56)
	arg0_56._cowController = var31_0(var1_56, var0_56, arg0_56)
	arg0_56._sceneItemController = var33_0(arg0_56.backSceneTf)
end

function var0_0.Update(arg0_60)
	arg0_60:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_61)
	if arg0_61.gameStop or arg0_61.settlementFlag then
		return
	end

	if IsUnityEditor and Input.GetKeyDown(KeyCode.S) and arg0_61._playerController then
		arg0_61._playerController:throw()
	end
end

function var0_0.updateMenuUI(arg0_62)
	local var0_62 = arg0_62:getGameUsedTimes()
	local var1_62 = arg0_62:getGameTimes()

	for iter0_62 = 1, #arg0_62.battleItems do
		setActive(findTF(arg0_62.battleItems[iter0_62], "state_open"), false)
		setActive(findTF(arg0_62.battleItems[iter0_62], "state_closed"), false)
		setActive(findTF(arg0_62.battleItems[iter0_62], "state_clear"), false)
		setActive(findTF(arg0_62.battleItems[iter0_62], "state_current"), false)

		if iter0_62 <= var0_62 then
			SetParent(arg0_62.dropItems[iter0_62], findTF(arg0_62.battleItems[iter0_62], "state_clear/icon"))
			setActive(arg0_62.dropItems[iter0_62], true)
			setActive(findTF(arg0_62.battleItems[iter0_62], "state_clear"), true)
		elseif iter0_62 == var0_62 + 1 and var1_62 >= 1 then
			setActive(findTF(arg0_62.battleItems[iter0_62], "state_current"), true)
			SetParent(arg0_62.dropItems[iter0_62], findTF(arg0_62.battleItems[iter0_62], "state_current/icon"))
			setActive(arg0_62.dropItems[iter0_62], true)
		elseif var0_62 < iter0_62 and iter0_62 <= var0_62 + var1_62 then
			setActive(findTF(arg0_62.battleItems[iter0_62], "state_open"), true)
			SetParent(arg0_62.dropItems[iter0_62], findTF(arg0_62.battleItems[iter0_62], "state_open/icon"))
			setActive(arg0_62.dropItems[iter0_62], true)
		else
			setActive(findTF(arg0_62.battleItems[iter0_62], "state_closed"), true)
			setActive(arg0_62.dropItems[iter0_62], false)
		end
	end

	arg0_62.totalTimes = arg0_62:getGameTotalTime()

	local var2_62 = 1 - (arg0_62:getGameUsedTimes() - 3 < 0 and 0 or arg0_62:getGameUsedTimes() - 3) / (arg0_62.totalTimes - 4)

	if var2_62 > 1 then
		var2_62 = 1
	end

	scrollTo(arg0_62.battleScrollRect, 0, var2_62)
	setActive(findTF(arg0_62.menuUI, "btnStart/tip"), var1_62 > 0)
	arg0_62:CheckGet()
end

function var0_0.CheckGet(arg0_63)
	setActive(findTF(arg0_63.menuUI, "got"), false)

	if arg0_63:getUltimate() and arg0_63:getUltimate() ~= 0 then
		setActive(findTF(arg0_63.menuUI, "got"), true)
	end

	if arg0_63:getUltimate() == 0 then
		if arg0_63:getGameTotalTime() > arg0_63:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_63:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_63.menuUI, "got"), true)
	end
end

function var0_0.openMenuUI(arg0_64)
	setActive(findTF(arg0_64._tf, "scene_front"), false)
	setActive(findTF(arg0_64._tf, "scene_background"), false)
	setActive(findTF(arg0_64._tf, "scene"), false)
	setActive(arg0_64.gameUI, false)
	setActive(arg0_64.menuUI, true)
	arg0_64:updateMenuUI()
end

function var0_0.clearUI(arg0_65)
	setActive(arg0_65.sceneTf, false)
	setActive(arg0_65.settlementUI, false)
	setActive(arg0_65.countUI, false)
	setActive(arg0_65.menuUI, false)
	setActive(arg0_65.gameUI, false)
end

function var0_0.readyStart(arg0_66)
	setActive(arg0_66.countUI, true)
	arg0_66.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_0)
end

function var0_0.gameStart(arg0_67)
	setActive(findTF(arg0_67._tf, "scene_front"), true)
	setActive(findTF(arg0_67._tf, "scene_background"), true)
	setActive(findTF(arg0_67._tf, "scene"), true)
	setActive(arg0_67.gameUI, true)

	arg0_67.gameStartFlag = true
	arg0_67.scoreNum = 0
	arg0_67.playerPosIndex = 2
	arg0_67.gameStepTime = 0
	arg0_67.heart = 3
	arg0_67.gameTime = var5_0

	if arg0_67._cowController then
		arg0_67._cowController:start()
	end

	if arg0_67._playerController then
		arg0_67._playerController:start()
	end

	arg0_67:updateGameUI()
	arg0_67:timerStart()
end

function var0_0.getGameTimes(arg0_68)
	return arg0_68:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_69)
	return arg0_69:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_70)
	return arg0_70:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_71)
	return (arg0_71:GetMGHubData():getConfig("reward_need"))
end

function var0_0.changeSpeed(arg0_72, arg1_72)
	return
end

function var0_0.onTimer(arg0_73)
	arg0_73:gameStep()
end

function var0_0.gameStep(arg0_74)
	arg0_74.gameTime = arg0_74.gameTime - Time.deltaTime

	if arg0_74.gameTime < 0 then
		arg0_74.gameTime = 0
	end

	arg0_74.gameStepTime = arg0_74.gameStepTime + Time.deltaTime

	if arg0_74._cowController then
		arg0_74._cowController:step(arg0_74.gameStepTime)
	end

	if arg0_74._playerController then
		arg0_74._playerController:step(arg0_74.gameStepTime)
	end

	if arg0_74._sceneItemController then
		arg0_74._sceneItemController:step(arg0_74.gameStepTime)
	end

	arg0_74:updateGameUI()

	if arg0_74.gameTime <= 0 then
		arg0_74:onGameOver()

		return
	end
end

function var0_0.timerStart(arg0_75)
	if not arg0_75.timer.running then
		arg0_75.timer:Start()
	end
end

function var0_0.timerStop(arg0_76)
	if arg0_76.timer.running then
		arg0_76.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_77)
	setText(arg0_77.scoreTf, arg0_77.scoreNum)
	setText(arg0_77.gameTimeS, math.ceil(arg0_77.gameTime))

	if not arg0_77.captureCdMaskImg then
		arg0_77.captureCdMaskImg = GetComponent(findTF(arg0_77.btnCapture, "cd"), typeof(Image))
	end

	if arg0_77._playerController then
		local var0_77 = arg0_77._playerController:getThrowTime()

		if var0_77 and var0_77 > 0 then
			local var1_77 = var0_77 / var10_0

			arg0_77.captureCdMaskImg.fillAmount = var1_77
		else
			arg0_77.captureCdMaskImg.fillAmount = 0
		end
	end
end

function var0_0.addScore(arg0_78, arg1_78)
	arg0_78.scoreNum = arg0_78.scoreNum + arg1_78

	if arg0_78.scoreNum < 0 then
		arg0_78.scoreNum = 0
	end

	setActive(arg0_78.sceneScoreTf, false)

	for iter0_78 = 0, arg0_78.sceneScoreTf.childCount - 1 do
		local var0_78 = arg0_78.sceneScoreTf:GetChild(iter0_78)

		if var0_78.name == tostring(arg1_78) then
			setActive(var0_78, true)
		else
			setActive(var0_78, false)
		end
	end

	setActive(arg0_78.sceneScoreTf, true)
end

function var0_0.onGameOver(arg0_79)
	if arg0_79.settlementFlag then
		return
	end

	arg0_79:timerStop()

	arg0_79.settlementFlag = true

	setActive(arg0_79.sceneScoreTf, false)
	setActive(arg0_79.clickMask, true)

	if arg0_79._cowController then
		arg0_79._cowController:clear()
	end

	LeanTween.delayedCall(go(arg0_79._tf), 0.1, System.Action(function()
		arg0_79.settlementFlag = false
		arg0_79.gameStartFlag = false

		setActive(arg0_79.clickMask, false)
		arg0_79:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_81)
	setActive(arg0_81.settlementUI, true)
	GetComponent(findTF(arg0_81.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_81 = arg0_81:GetMGData():GetRuntimeData("elements")
	local var1_81 = arg0_81.scoreNum
	local var2_81 = var0_81 and #var0_81 > 0 and var0_81[1] or 0

	setActive(findTF(arg0_81.settlementUI, "ad/new"), var2_81 < var1_81)

	if var2_81 <= var1_81 then
		var2_81 = var1_81

		arg0_81:StoreDataToServer({
			var2_81
		})
	end

	local var3_81 = findTF(arg0_81.settlementUI, "ad/highText")
	local var4_81 = findTF(arg0_81.settlementUI, "ad/currentText")

	setText(var3_81, var2_81)
	setText(var4_81, var1_81)

	if arg0_81:getGameTimes() and arg0_81:getGameTimes() > 0 then
		arg0_81.sendSuccessFlag = true

		arg0_81:SendSuccess(0)
	end
end

function var0_0.resumeGame(arg0_82)
	arg0_82.gameStop = false

	setActive(arg0_82.leaveUI, false)
	arg0_82:changeSpeed(1)
	arg0_82:timerStart()
end

function var0_0.stopGame(arg0_83)
	arg0_83.gameStop = true

	arg0_83:timerStop()
	arg0_83:changeSpeed(0)
end

function var0_0.onBackPressed(arg0_84)
	if not arg0_84.gameStartFlag then
		arg0_84:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_84.settlementFlag then
			return
		end

		if isActive(arg0_84.pauseUI) then
			setActive(arg0_84.pauseUI, false)
		end

		arg0_84:stopGame()
		setActive(arg0_84.leaveUI, true)
	end
end

function var0_0.willExit(arg0_85)
	if arg0_85.handle then
		UpdateBeat:RemoveListener(arg0_85.handle)
	end

	if arg0_85._tf and LeanTween.isTweening(go(arg0_85._tf)) then
		LeanTween.cancel(go(arg0_85._tf))
	end

	if arg0_85.timer and arg0_85.timer.running then
		arg0_85.timer:Stop()
	end

	Time.timeScale = 1
	arg0_85.timer = nil
end

return var0_0
