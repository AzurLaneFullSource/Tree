local var0 = class("IceCreamGameView", import("..BaseMiniGameView"))
local var1 = "EVENT_ICE_FINISH"
local var2 = "EVENT_UPDATE_WAIT_TIME"
local var3 = 0.05
local var4 = 2
local var5 = {
	{
		6,
		10
	},
	{
		8,
		12
	},
	{
		10,
		14
	}
}
local var6 = 60
local var7 = {
	750,
	250,
	300
}
local var8 = {
	200,
	100
}
local var9 = {
	100,
	50,
	20
}
local var10 = 20
local var11 = {
	point_boost = 100,
	wait_time_boost = 2,
	bullet_time = {
		0.1,
		4,
		0.8,
		5
	}
}
local var12 = {
	{
		1
	},
	{
		0,
		1
	},
	{
		1,
		0,
		2
	}
}
local var13 = {
	{
		1
	},
	{
		2
	},
	{
		1,
		3
	}
}
local var14 = {
	"A",
	"B",
	"C",
	"D"
}
local var15 = {
	"H",
	"J",
	"K",
	"I"
}
local var16

local function var17(arg0)
	if var16 then
		var16:Pause(not arg0)
	elseif arg0 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-icecream_topping", function(arg0)
			assert(arg0)

			var16 = arg0.playback
		end)
	end
end

function var0.getUIName(arg0)
	return "IceCreamGameUI"
end

function var0.initTimer(arg0)
	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, var3, -1)
end

function var0.didEnter(arg0)
	arg0:initTimer()
	arg0:initUI()
	arg0:initGameUI()
	arg0:openMainUI()
end

function var0.initUI(arg0)
	arg0.clickMask = arg0:findTF("ui/click_mask")
	arg0.rtResource = arg0._tf:Find("Resource")
	arg0.mainUI = arg0:findTF("ui/main_ui")
	arg0.listScrollRect = GetComponent(arg0.mainUI:Find("right_panel/item_list/content"), typeof(ScrollRect))

	onButton(arg0, arg0.mainUI:Find("btn_back"), function()
		arg0:emit(var0.ON_BACK_PRESSED)
	end, SFX_PANEL)
	onButton(arg0, arg0.mainUI:Find("bg/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.icecreamgame_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.mainUI:Find("bg/btn_start"), function()
		arg0:readyStart()
	end, SFX_PANEL)

	arg0.totalTimes = arg0:getGameTotalTime()

	local var0 = arg0:getGameUsedTimes() - 4 < 0 and 0 or arg0:getGameUsedTimes() - 4

	scrollTo(arg0.listScrollRect, 0, 1 - var0 / (arg0.totalTimes - 4))
	onButton(arg0, arg0:findTF("right_panel/arrows_up", arg0.mainUI), function()
		local var0 = arg0.listScrollRect.normalizedPosition.y + 1 / (arg0.totalTimes - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.listScrollRect, 0, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("right_panel/arrows_down", arg0.mainUI), function()
		local var0 = arg0.listScrollRect.normalizedPosition.y - 1 / (arg0.totalTimes - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.listScrollRect, 0, var0)
	end, SFX_PANEL)

	local var1 = pg.mini_game[arg0:GetMGData().id].simple_config_data.drop_ids
	local var2 = arg0.mainUI:Find("right_panel/item_list/content")

	arg0.itemList = UIItemList.New(var2, var2:GetChild(0))

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			arg2.name = arg1

			GetImageSpriteFromAtlasAsync("ui/minigameui/icecreamgameui_atlas", "day_" .. arg1, arg2:Find("text"))

			local var0 = arg2:Find("IconTpl")
			local var1 = {}

			var1.type, var1.id, var1.count = unpack(var1[arg1])

			updateDrop(var0, var1)
			onButton(arg0, var0, function()
				arg0:emit(var0.ON_DROP, var1)
			end, SFX_PANEL)
		end
	end)
	arg0.itemList:align(#var1)

	arg0.countUI = arg0:findTF("ui/count_ui")
	arg0.countAnimator = GetComponent(arg0:findTF("count", arg0.countUI), typeof(Animator))
	arg0.countDft = GetOrAddComponent(arg0:findTF("count", arg0.countUI), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		setActive(arg0.countUI, false)
		arg0:startGame()
	end)

	arg0.pauseUI = arg0:findTF("ui/pause_ui")

	onButton(arg0, arg0:findTF("panel/btn_confirm", arg0.pauseUI), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.pauseUI, arg0._tf:Find("ui"))
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()
	end, SFX_PANEL)

	arg0.returnUI = arg0:findTF("ui/return_ui")

	onButton(arg0, arg0:findTF("panel/btn_confirm", arg0.returnUI), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.returnUI, arg0._tf:Find("ui"))
		setActive(arg0.returnUI, false)
		arg0:resumeGame()
		arg0:endGame()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("panel/btn_cancel", arg0.returnUI), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.returnUI, arg0._tf:Find("ui"))
		setActive(arg0.returnUI, false)
		arg0:resumeGame()
	end, SFX_PANEL)

	arg0.endUI = arg0:findTF("ui/end_ui")

	onButton(arg0, arg0:findTF("panel/btn_finish", arg0.endUI), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.endUI, arg0._tf:Find("ui"))
		setActive(arg0.endUI, false)
		arg0:openMainUI()
	end, SFX_PANEL)

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.Update(arg0)
	return
end

function var0.initGameUI(arg0)
	arg0.gameUI = arg0:findTF("ui/game_ui")
	arg0.timeTF = arg0.gameUI:Find("Score/time/Text")
	arg0.scoreTF = arg0.gameUI:Find("Score/point/Text")
	arg0.addScoreTF = arg0.gameUI:Find("Score/add_score")

	onButton(arg0, arg0.gameUI:Find("Button/btn_pause"), function()
		arg0:pauseGame()
		pg.UIMgr.GetInstance():OverlayPanel(arg0.pauseUI)
		setActive(arg0.pauseUI, true)
	end)
	onButton(arg0, arg0.gameUI:Find("Button/btn_back"), function()
		arg0:pauseGame()
		pg.UIMgr.GetInstance():OverlayPanel(arg0.returnUI)
		setActive(arg0.returnUI, true)
	end)

	arg0.rtWalk = arg0.gameUI:Find("Walk")
	arg0.rtMake = arg0.gameUI:Find("Make")
	arg0.rtTime = arg0.gameUI:Find("Time")
	arg0.rtButton = arg0.gameUI:Find("Button")

	for iter0 = 1, 4 do
		onButton(arg0, arg0.rtButton:Find("L" .. iter0), function()
			if not arg0.iceBuild or arg0.iceBuild.isLeftLock then
				return
			end

			local var0 = arg0.targetList[arg0.targetIndex]._info

			if #arg0.iceBuild._info[1] == #var0[1] then
				return
			end

			arg0.iceBuild:MakeBall(iter0)
		end)
		onButton(arg0, arg0.rtButton:Find("R" .. iter0), function()
			if not arg0.iceBuild or arg0.iceBuild.isRightLock then
				return
			end

			local var0 = arg0.targetList[arg0.targetIndex]._info

			if #arg0.iceBuild._info[2] == #var0[2] then
				return
			end

			if not arg0.iceBuild._info[1][var13[#var0[1]][#arg0.iceBuild._info[2] + 1]] then
				arg0.iceBuild:MakeMissTopping(iter0)
			else
				arg0.iceBuild:MakeTopping(iter0)
			end
		end)
	end

	arg0:bind(var1, function(arg0, ...)
		arg0:ResultTarget(...)
	end)
	arg0:bind(var2, function(arg0, arg1, ...)
		eachChild(arg0.rtTime, function(arg0)
			setActive(arg0, arg0.name == arg1)
		end)
		setSlider(arg0.rtTime:Find(arg1), ...)
	end)
end

function var0.updateMainUI(arg0)
	local var0 = arg0:getGameUsedTimes()
	local var1 = arg0:getGameTimes()
	local var2 = arg0.itemList.container
	local var3 = var2.childCount

	for iter0 = 1, var3 do
		local var4 = {
			award = true
		}

		if iter0 <= var0 then
			var4.finish = true
		elseif iter0 == var0 + 1 and var1 >= 1 then
			-- block empty
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			-- block empty
		else
			var4.lock = true
			var4.award = false
		end

		local var5 = var2:GetChild(iter0 - 1)

		setActive(var5:Find("finish"), var4.finish)
		setActive(var5:Find("lock"), var4.lock)
		setActive(var5:Find("IconTpl"), var4.award)
	end

	arg0.totalTimes = arg0:getGameTotalTime()

	local var6 = 1 - (arg0:getGameUsedTimes() - 3 < 0 and 0 or arg0:getGameUsedTimes() - 3) / (arg0.totalTimes - 4)

	if var6 > 1 then
		var6 = 1
	end

	scrollTo(arg0.listScrollRect, 0, var6)
	arg0:checkGet()
end

function var0.checkGet(arg0)
	if arg0:getUltimate() == 0 then
		if arg0:getGameTotalTime() > arg0:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0.openMainUI(arg0)
	setActive(arg0.gameUI, false)
	setActive(arg0.mainUI, true)
	arg0:updateMainUI()
end

function var0.readyStart(arg0)
	setActive(arg0.mainUI, false)
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ddldaoshu2")
	arg0:resetGame()
end

function var0.resetGame(arg0)
	arg0.gameStartFlag = false
	arg0.gamePause = false
	arg0.gameEndFlag = false
	arg0.scoreNum = 0
	arg0.lastTime = var6
	arg0.targetNameList = {}
	arg0.targetList = {}
	arg0.iceBuild = nil
	arg0.countList = {
		0,
		0,
		0
	}
	arg0.effectTrigger = {
		bullet_time = {
			waitTime = 0,
			doingTime = 0
		},
		wait_time_boost = {
			count = 0
		},
		point_boost = {}
	}

	eachChild(arg0.rtResource:Find("Character"), function(arg0)
		table.insert(arg0.targetNameList, arg0.name)
	end)
	removeAllChildren(arg0.rtWalk)
	setActive(arg0.gameUI:Find("BulletTimeMask"), false)
	setActive(arg0.rtMake, false)
	setActive(arg0.rtTime, false)
	setText(arg0.scoreTF, arg0.scoreNum)
	setActive(arg0.addScoreTF, false)
	arg0:setAnimatorSpeed(arg0._tf, 1)
end

local function var18(arg0, arg1, arg2, arg3)
	local var0 = {}

	local function var1(arg0, arg1)
		for iter0 = math.max(#arg1[1], 2), 1, -1 do
			setActive(arg0:Find(iter0), arg1[1][iter0])

			if arg1[1][iter0] then
				local var0 = arg0:Find(iter0)

				GetImageSpriteFromAtlasAsync("ui/minigameui/icecreamgameui_atlas", "Assets/ArtResource/UI/MiniGameUI/IceCreamGameUI/ICE_S/" .. var14[arg1[1][iter0]] .. ".png", var0:Find("Scoop"), true)

				local var1 = arg1[2][var12[#arg1[1]][iter0]]

				setActive(var0:Find("Topping"), var1)

				if var1 then
					GetImageSpriteFromAtlasAsync("ui/minigameui/icecreamgameui_atlas", "Assets/ArtResource/UI/MiniGameUI/IceCreamGameUI/ICE_S/" .. var15[var1] .. ".png", var0:Find("Topping"), true)
				end
			end
		end
	end

	function var0.Ctor(arg0)
		arg0._tf = arg0
		arg0._event = arg1
		arg0._info = arg2
		arg0.time = arg3
		arg0.pointBoost = 100
		arg0.result = nil

		local var0 = #arg2[1] < 3 and "Cone" or "Bowl"

		for iter0, iter1 in ipairs({
			"IceCream",
			"Bubble",
			"BadCream"
		}) do
			eachChild(arg0:Find(iter1), function(arg0)
				setActive(arg0, arg0.name == var0)
			end)
		end

		var1(arg0:Find("Bubble/" .. var0), arg2)
		GetImageSpriteFromAtlasAsync("ui/minigameui/icecreamgameui_atlas", "Assets/ArtResource/UI/MiniGameUI/IceCreamGameUI/ICE_S/bubble_" .. #arg2[1] .. ".png", arg0:Find("Bubble"), true)
		setActive(arg0:Find("Bubble/Boost"), false)

		arg0.animator = GetComponent(arg0._tf, typeof(Animator))

		arg0._tf:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
			arg0.isLeave = true
		end)
	end

	function var0.Result(arg0, arg1, arg2)
		arg0.result = arg1

		local var0 = #arg2[1] < 3 and "Cone" or "Bowl"

		if arg1 == 0 then
			arg0.animator:Play("Bad")
		elseif arg1 == 1 then
			var1(arg0._tf:Find("IceCream/" .. var0), arg2)
			arg0.animator:Play("Hmm")
		elseif arg1 >= 2 then
			var1(arg0._tf:Find("IceCream/" .. var0), arg2)
			arg0.animator:Play("Great")
		else
			assert(false)
		end
	end

	var0:Ctor()

	return var0
end

function var0.CreateTarget(arg0, arg1)
	local var0 = table.remove(arg0.targetNameList, math.random(#arg0.targetNameList))
	local var1 = cloneTplTo(arg0.rtResource:Find("Character/" .. var0), arg0.rtWalk, var0)

	setAnchoredPosition(var1, {
		x = arg1 or -var7[1]
	})

	local var2 = {
		{},
		{}
	}
	local var3 = var0 == "Agir" and {
		1,
		2
	} or {
		1,
		2,
		3
	}

	if #arg0.targetList > 0 then
		table.removebyvalue(var3, #arg0.targetList[#arg0.targetList]._info[1])
	end

	for iter0 = var3[math.random(#var3)], 1, -1 do
		table.insert(var2[1], math.random(4))
	end

	local var4 = {
		1,
		2,
		3,
		4
	}

	for iter1 = math.max(1, #var2[1] - 1), 1, -1 do
		table.insert(var2[2], table.remove(var4, math.random(#var4)))
	end

	local var5 = math.clamp(var5[#var2[1]][2] - arg0.countList[#var2[1]], unpack(var5[#var2[1]]))

	arg0.countList[#var2[1]] = arg0.countList[#var2[1]] + 1

	table.insert(arg0.targetList, var18(var1, arg0, var2, var5))
end

function var0.RemoveTarget(arg0)
	assert(#arg0.targetList > 0)

	local var0 = table.remove(arg0.targetList, 1)

	arg0.targetIndex = arg0.targetIndex - 1

	table.insert(arg0.targetNameList, var0._tf.name)
	Destroy(var0._tf)
end

function var0.ResultTarget(arg0, arg1, arg2, ...)
	assert(#arg0.targetList > 0)

	arg1 = math.ceil(arg1 * arg0.targetList[arg0.targetIndex].pointBoost / 100)

	arg0:addScore(arg1, arg2)
	arg0.targetList[arg0.targetIndex]:Result(arg2, ...)
	arg0:TriggerSpecialEffect(arg2, ...)

	arg0.targetIndex = arg0.targetIndex + 1
	arg0.iceBuild = nil

	onNextTick(function()
		setActive(arg0.rtMake, false)
		setActive(arg0.rtTime, false)
	end)

	local var0 = arg0.effectTrigger.bullet_time

	if var0.doingTime > 0 then
		var0.doingTime = 0

		arg0:setAnimatorSpeed(arg0._tf, 1)
		setActive(arg0.gameUI:Find("BulletTimeMask"), false)
	end
end

function var0.TriggerSpecialEffect(arg0, arg1, arg2)
	if arg1 == 3 then
		local var0 = arg0.targetList[arg0.targetIndex + 1]
		local var1 = arg0.effectTrigger.bullet_time

		if #arg0.targetList[arg0.targetIndex]._info[1] == 3 and var1.waitTime <= 0 and math.random() < var11.bullet_time[3] then
			var0.timeBoost = true
		end

		local var2 = arg0.effectTrigger.wait_time_boost

		var2.count = var2.count + 1

		if var2.count == 2 then
			var2.count = 0
			var0.time = var0.time + var11.wait_time_boost
			var0.isWaitTimeBoost = true
		end

		local var3 = arg0.effectTrigger.point_boost
		local var4 = arg0.targetList[arg0.targetIndex]._tf.name

		if var3[var4] == "finish" then
			-- block empty
		elseif var3[var4] == "count" then
			var0.pointBoost = var0.pointBoost + var11.point_boost

			setActive(var0._tf:Find("Bubble/Boost"), true)

			var3[var4] = "finish"
		else
			var3[var4] = "count"
		end
	else
		local var5 = arg0.effectTrigger.point_boost
		local var6 = arg0.targetList[arg0.targetIndex]._tf.name

		if var5[var6] == "finish" then
			-- block empty
		else
			var5[var6] = nil
		end
	end
end

local function var19(arg0, arg1, arg2, arg3, arg4)
	local var0 = {
		Ctor = function(arg0)
			arg0._tf = arg0
			arg0._event = arg1
			arg0._info = {
				{},
				{}
			}
			arg0.isLeftLock = false
			arg0.isRightLock = false
			arg0.missToppingMark = {}
			arg0.waitTime = arg3
			arg0.isWaitTimeBoost = arg4

			arg0:Reset()
			arg0:NextDeal()
		end,
		NextDeal = function(arg0)
			if arg0.isLeftLock or arg0.isRightLock then
				return
			end

			if #arg0._info[1] < #arg2[1] then
				arg0:ReadyBall()
			elseif #arg0._info[2] < #arg2[2] then
				arg0:ReadyTopping()
			else
				arg0:Result()
			end
		end,
		Result = function(arg0, arg1)
			arg0.isResulted = true

			var17(false)

			local var0 = 0
			local var1 = {
				{
					0,
					0,
					0,
					0
				},
				{
					0,
					0,
					0,
					0
				}
			}

			local function var2(arg0, arg1, arg2)
				local var0 = arg0[arg1]

				arg0[arg1] = arg0[arg1] + arg2

				return math.abs(arg0[arg1]) - math.abs(var0)
			end

			for iter0, iter1 in ipairs(arg0._info) do
				for iter2, iter3 in ipairs(iter1) do
					if var2(var1[iter0], arg2[iter0][iter2], -1) < 0 then
						var0 = var0 + var9[iter0]
					end

					if var2(var1[iter0], iter3, 1) < 0 then
						var0 = var0 + var9[iter0]
					end

					if arg2[iter0][iter2] == iter3 and (iter0 == 1 or not arg0.missToppingMark[iter2]) then
						var0 = var0 + var9[3]
					end
				end
			end

			if arg1 then
				arg0.result = arg1
			else
				local var3 = #arg0._info[1] * var9[1] + #arg0._info[2] * var9[2] + (#arg0._info[1] + #arg0._info[2]) * var9[3]

				if var0 == var3 then
					arg0.result = 3
				elseif table.equal(arg0._info, arg2) then
					arg0.result = 2
				elseif var0 >= var3 / 2 then
					arg0.result = 1
				else
					arg0.result = 0
				end
			end

			local var4 = arg0._tf:GetComponent(typeof(Animator))

			if arg0.result == 3 then
				arg0.point = var0 * (1 + var10 / 100 + arg0.waitTime / arg3)

				var4:Play("Perfect")
				pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-icecream_great")
			elseif arg0.result == 2 then
				arg0.point = var0 * (1 + arg0.waitTime / arg3)

				var4:Play("Pass")
			elseif arg0.result == 1 then
				arg0.point = var0 * (1 + arg0.waitTime / arg3)

				var4:Play("Pass")
			elseif arg0.result == 0 then
				arg0.point = 0

				var4:Play("Fail")
				pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-icecream_fail")
			else
				assert(false)
			end
		end,
		CountDown = function(arg0, arg1, arg2)
			if arg0.isResulted then
				return
			end

			if arg0.waitTime > 0 then
				arg0.waitTime = arg0.waitTime - arg1

				arg0._event:emit(var2, arg2, 0, arg3, arg0.waitTime)
			else
				arg0.waitTime = 0

				arg0:Result(0)
			end

			if not arg0.missTime then
				return
			end

			if arg0.missTime > 0 then
				arg0.missTime = arg0.missTime - var3
			else
				arg0.missTime = nil

				arg0:FailMissTopping()
			end
		end,
		Reset = function(arg0)
			arg0._tf:GetComponent("DftAniEvent"):SetEndEvent(function()
				onNextTick(function()
					setActive(arg0._tf, false)
				end)
				arg0._event:emit(var1, arg0.point, arg0.result, arg0._info)
			end)
			arg0._tf:GetComponent("DftAniEvent"):SetTriggerEvent(function()
				for iter0 = arg0._tf.name == "Cone" and 2 or 3, 1, -1 do
					setActive(arg0._tf:Find(iter0), false)
				end

				setActive(arg0._tf:Find("Back"), false)

				if arg0._tf.name == "Bowl" then
					setActive(arg0._tf:Find("Front"), false)
				end
			end)
			setActive(arg0._tf:Find("Back"), true)

			if arg0._tf.name == "Bowl" then
				setActive(arg0._tf:Find("Front"), true)
			end

			for iter0 = arg0._tf.name == "Cone" and 2 or 3, 1, -1 do
				local var0 = arg0._tf:Find(iter0)

				setActive(var0, iter0 <= #arg2[1])

				if iter0 <= #arg2[1] then
					eachChild(var0, function(arg0)
						setActive(arg0, false)
					end)
					var0:Find("Scoop"):GetComponent("DftAniEvent"):SetEndEvent(function()
						arg0.isLeftLock = false

						if arg0.successLeftLight then
							arg0.successLeftLight = false

							setAnchoredPosition(var0:Find("Good"), {
								x = 0,
								y = -10
							})
							setActive(var0:Find("Good"), false)
							setActive(var0:Find("Good"), true)
						end

						arg0:NextDeal()
					end)
					var0:Find("Topping"):GetComponent("DftAniEvent"):SetEndEvent(function()
						arg0.isRightLock = false

						if arg0.successRightLight then
							arg0.successRightLight = false

							setAnchoredPosition(var0:Find("Good"), {
								x = 10,
								y = 6
							})
							setActive(var0:Find("Good"), false)
							setActive(var0:Find("Good"), true)
						end

						arg0:NextDeal()
					end)
				end
			end
		end,
		ReadyBall = function(arg0)
			local var0 = arg0._tf:Find(#arg0._info[1] + 1)

			setActive(var0:Find("Scoop_Next"), true)
		end,
		MakeBall = function(arg0, arg1)
			arg0.isLeftLock = true

			local var0 = arg0._tf:Find(#arg0._info[1] + 1)

			setActive(var0:Find("Scoop_Next"), false)
			setActive(var0:Find("Scoop"), true)
			var0:Find("Scoop"):GetComponent(typeof(Animator)):Play("Scoop_" .. var14[arg1])
			table.insert(arg0._info[1], arg1)

			arg0.successLeftLight = arg0._info[1][#arg0._info[1]] == arg2[1][#arg0._info[1]]

			if arg0.temporaryKey and var13[#arg2[1]][#arg0._info[2] + 1] == #arg0._info[1] then
				arg0:SafeMissTopping()
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-icecream_flavour")
		end,
		ReadyTopping = function(arg0)
			local var0 = arg0._tf:Find(var13[#arg2[1]][#arg0._info[2] + 1])

			setActive(var0:Find("Topping_Next"), true)
		end,
		MakeTopping = function(arg0, arg1)
			arg0.isRightLock = true

			local var0 = arg0._tf:Find(var13[#arg2[1]][#arg0._info[2] + 1])

			setActive(var0:Find("Topping_Next"), false)
			setActive(var0:Find("Topping"), true)
			var0:Find("Topping"):GetComponent(typeof(Animator)):Play("Topping_" .. var15[arg1])
			table.insert(arg0._info[2], arg1)

			arg0.successRightLight = arg0._info[2][#arg0._info[2]] == arg2[2][#arg0._info[2]]

			pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-icecream_mixer")
		end,
		MakeMissTopping = function(arg0, arg1)
			arg0.isRightLock = true
			arg0.temporaryKey = arg1
			arg0.missTime = var4 * (var13[#arg2[1]][#arg0._info[2] + 1] - #arg0._info[1])

			var17(true)

			local var0 = arg0._tf:Find(var13[#arg2[1]][#arg0._info[2] + 1])

			setActive(var0:Find("Topping_Next"), false)
			setActive(var0:Find("Topping"), true)
			var0:Find("Topping"):GetComponent(typeof(Animator)):Play("Topping_pre_" .. var15[arg1])
		end,
		FailMissTopping = function(arg0)
			arg0.isRightLock = true

			local var0 = arg0.temporaryKey

			arg0.temporaryKey = nil
			arg0.missTime = nil

			var17(false)

			local var1 = arg0._tf:Find(var13[#arg2[1]][#arg0._info[2] + 1])

			setActive(var1:Find("Topping_Next"), false)
			setActive(var1:Find("Topping"), true)
			var1:Find("Topping"):GetComponent(typeof(Animator)):Play("Topping_Err_" .. var15[var0])
		end,
		SafeMissTopping = function(arg0)
			arg0.isRightLock = true

			local var0 = arg0.temporaryKey

			arg0.temporaryKey = nil
			arg0.missTime = nil

			var17(false)

			local var1 = arg0._tf:Find(var13[#arg2[1]][#arg0._info[2] + 1])

			setActive(var1:Find("Topping_Next"), false)
			setActive(var1:Find("Topping"), true)
			var1:Find("Topping"):GetComponent(typeof(Animator)):Play("Topping_safe_" .. var15[var0])
			table.insert(arg0._info[2], var0)

			arg0.successRightLight = arg0._info[2][#arg0._info[2]] == arg2[2][#arg0._info[2]]
			arg0.missToppingMark[#arg0._info[2]] = true

			pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-icecream_mixer")
		end
	}

	var0:Ctor()

	return var0
end

function var0.DoIceCream(arg0)
	setActive(arg0.rtTime, true)
	setActive(arg0.rtMake, true)

	local var0 = arg0.targetList[arg0.targetIndex]
	local var1 = #var0._info[1] < 3 and "Cone" or "Bowl"

	eachChild(arg0.rtMake, function(arg0)
		setActive(arg0, arg0.name == var1)
	end)

	local var2 = arg0.rtMake:Find(var1)

	for iter0 = var1 == "Cone" and 2 or 3, 1, -1 do
		setActive(var2:Find(iter0), false)
	end

	arg0.iceBuild = var19(var2, arg0, var0._info, var0.time, var0.isWaitTimeBoost)

	if var0.timeBoost then
		local var3 = arg0.effectTrigger.bullet_time

		var3.doingTime = var11.bullet_time[2]
		var3.waitTime = var11.bullet_time[4]

		arg0:setAnimatorSpeed(arg0._tf, 0.5)
		arg0:setAnimatorSpeed(arg0.rtMake, 1)
		setActive(arg0.gameUI:Find("BulletTimeMask"), true)
	end
end

function var0.startGame(arg0)
	setActive(arg0.gameUI, true)

	arg0.gameStartFlag = true

	arg0:CreateTarget(-var7[1] / 3)

	arg0.targetIndex = 1

	arg0:RandomBG()
	arg0:timerStart()
end

function var0.RandomBG(arg0)
	arg0.poolBG = arg0.poolBG or {
		GroupD = {
			1
		}
	}

	if not arg0.poolBG.GroupAB or #arg0.poolBG.GroupAB == 0 then
		arg0.poolBG.GroupAB = {
			1,
			2,
			3,
			4,
			5,
			6
		}
	end

	if not arg0.poolBG["GroupC/Other"] or #arg0.poolBG["GroupC/Other"] == 0 then
		arg0.poolBG["GroupC/Other"] = {
			1,
			2,
			3,
			4
		}
	end

	arg0.poolBG["GroupC/Manjuu"] = {
		1,
		2,
		3
	}

	for iter0, iter1 in pairs(arg0.poolBG) do
		local var0 = {}

		for iter2 = iter0 == "GroupC/Manjuu" and 2 or 1, 1, -1 do
			if iter0 == "GroupD" then
				var0[iter1[1]] = true
				iter1[1] = 3 - iter1[1]
			else
				var0[table.remove(iter1, math.random(#iter1))] = true
			end
		end

		local var1 = arg0.gameUI:Find("BG/" .. iter0)

		for iter3 = var1.childCount, 1, -1 do
			setActive(var1:GetChild(iter3 - 1), var0[iter3])
		end
	end
end

function var0.getIntervalTime(arg0)
	if arg0.effectTrigger.bullet_time.doingTime > 0 then
		return var3 * var11.bullet_time[1]
	else
		return var3
	end
end

function var0.onTimer(arg0)
	local var0 = arg0.effectTrigger.bullet_time

	if var0.doingTime > 0 then
		var0.doingTime = var0.doingTime - var3

		if var0.doingTime <= 0 then
			arg0:setAnimatorSpeed(arg0._tf, 1)
			setActive(arg0.gameUI:Find("BulletTimeMask"), false)
		end
	elseif var0.waitTime > 0 then
		var0.waitTime = var0.waitTime - var3
	end

	arg0.lastTime = arg0.lastTime - arg0:getIntervalTime()

	arg0:updateWalker()

	if arg0.lastTime <= 0 then
		arg0:endGame()
	else
		setText(arg0.timeTF, math.floor(arg0.lastTime))

		if not arg0.iceBuild and arg0.targetList[arg0.targetIndex]._tf.anchoredPosition.x > 0 then
			arg0:DoIceCream()
		end

		if #arg0.targetList == arg0.targetIndex then
			arg0:CreateTarget()
		end
	end

	if arg0.iceBuild then
		local var1
		local var2 = var0.doingTime > 0 and "frozen" or arg0.iceBuild.isWaitTimeBoost and "extend" or "base"

		arg0.iceBuild:CountDown(arg0:getIntervalTime(), var2)
	end
end

function var0.updateWalker(arg0)
	for iter0 = #arg0.targetList, 1, -1 do
		local var0 = arg0.targetList[iter0]
		local var1 = var0._tf:GetComponent(typeof(Animator))
		local var2 = var1:GetCurrentAnimatorStateInfo(0)

		if var0.result then
			if var0.isLeave then
				setAnchoredPosition(var0._tf, {
					x = var0._tf.anchoredPosition.x + arg0:getIntervalTime() * var8[1]
				})

				if var0._tf.anchoredPosition.x > var7[1] then
					arg0:RemoveTarget()
				end
			end
		else
			local var3 = var7[3]

			if iter0 > 1 then
				var3 = math.min(var3, arg0.targetList[iter0 - 1]._tf.anchoredPosition.x)
			end

			local var4 = var3 - var0._tf.anchoredPosition.x

			if var4 < var7[3] then
				if not var0.state or var0.state ~= "Stand" then
					var0.state = "Stand"

					var1:Play("Stand")
				end
			elseif var4 < var7[2] then
				setAnchoredPosition(var0._tf, {
					x = var0._tf.anchoredPosition.x + arg0:getIntervalTime() * var8[2]
				})

				if not var0.state or var0.state ~= "Walk" then
					var0.state = "Walk"

					var1:Play("Walk")
				end
			else
				setAnchoredPosition(var0._tf, {
					x = var0._tf.anchoredPosition.x + arg0:getIntervalTime() * var8[1]
				})

				if not var0.state or var0.state ~= "Run" then
					var0.state = "Run"

					var1:Play("Run")
				end
			end
		end
	end
end

function var0.setAnimatorSpeed(arg0, arg1, arg2)
	local var0 = arg1:GetComponentsInChildren(typeof(Animator), true)

	for iter0 = 0, var0.Length - 1 do
		var0[iter0].speed = arg2
	end
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end

	if arg0.effectTrigger.bullet_time.doingTime > 0 then
		arg0:setAnimatorSpeed(arg0._tf, 0.5)
		arg0:setAnimatorSpeed(arg0.rtMake, 1)
	else
		arg0:setAnimatorSpeed(arg0._tf, 1)
	end

	if arg0.iceBuild and arg0.iceBuild.missTime then
		var17(true)
	end
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end

	arg0:setAnimatorSpeed(arg0._tf, 0)

	if arg0.iceBuild and arg0.iceBuild.missTime then
		var17(false)
	end
end

function var0.addScore(arg0, arg1, arg2)
	arg0.scoreNum = arg0.scoreNum + arg1

	setText(arg0.scoreTF, arg0.scoreNum)
	setActive(arg0.addScoreTF, false)
	setActive(arg0.addScoreTF, true)

	local var0 = arg0.addScoreTF:Find("score_tf")

	setText(var0, "+" .. arg1)

	if arg2 == 0 then
		setTextColor(var0, Color.NewHex("ED666DFF"))
	elseif arg2 == 1 then
		setTextColor(var0, Color.NewHex("FAB149FF"))
	elseif arg2 == 2 then
		setTextColor(var0, Color.NewHex("C6CC15FF"))
	elseif arg2 == 3 then
		setTextColor(var0, Color.NewHex("80BF1CFF"))
	else
		assert(false)
	end
end

function var0.pauseGame(arg0)
	arg0.gamePause = true

	arg0:timerStop()
	arg0:pauseManagedTween()
end

function var0.resumeGame(arg0)
	arg0.gamePause = false

	arg0:timerStart()
	arg0:resumeManagedTween()
end

function var0.endGame(arg0)
	if arg0.gameEndFlag then
		return
	end

	arg0:timerStop()

	arg0.gameEndFlag = true

	setActive(arg0.clickMask, true)
	arg0:managedTween(LeanTween.delayedCall, function()
		arg0.gameEndFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
		arg0:showEndUI()
	end, 0.1, nil)
end

function var0.showEndUI(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.endUI)
	setActive(arg0.endUI, true)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = arg0.scoreNum
	local var2 = var0 and #var0 > 0 and var0[1] or 0

	setActive(arg0:findTF("panel/now/Text/new", arg0.endUI), var2 < var1)

	if var2 <= var1 then
		var2 = var1

		arg0:StoreDataToServer({
			var2
		})
	end

	local var3 = arg0:findTF("panel/max/Text", arg0.endUI)
	local var4 = arg0:findTF("panel/now/Text", arg0.endUI)

	setText(var3, var2)
	setText(var4, var1)

	if arg0:getGameTimes() and arg0:getGameTimes() > 0 then
		arg0:SendSuccess(0)
	end
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

function var0.OnApplicationPaused(arg0, arg1)
	if arg1 and not arg0.gameEndFlag and arg0.gameStartFlag and not arg0.gamePause then
		arg0:pauseGame()
		pg.UIMgr.GetInstance():OverlayPanel(arg0.pauseUI)
		setActive(arg0.pauseUI, true)
	end
end

function var0.onBackPressed(arg0)
	if arg0.gameEndFlag then
		return
	end

	if isActive(arg0.pauseUI) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.pauseUI, arg0._tf:Find("ui"))
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()

		return
	end

	if isActive(arg0.returnUI) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.returnUI, arg0._tf:Find("ui"))
		setActive(arg0.returnUI, false)
		arg0:resumeGame()

		return
	end

	if isActive(arg0.endUI) then
		return
	end

	if arg0.gameStartFlag then
		arg0:pauseGame()
		pg.UIMgr.GetInstance():OverlayPanel(arg0.pauseUI)
		setActive(arg0.pauseUI, true)

		return
	end

	arg0:emit(var0.ON_BACK_PRESSED)
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	arg0:cleanManagedTween()

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	Time.timeScale = 1
	arg0.timer = nil
end

return var0
