local var0_0 = class("IceCreamGameView", import("..BaseMiniGameView"))
local var1_0 = "EVENT_ICE_FINISH"
local var2_0 = "EVENT_UPDATE_WAIT_TIME"
local var3_0 = 0.05
local var4_0 = 2
local var5_0 = {
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
local var6_0 = 60
local var7_0 = {
	750,
	250,
	300
}
local var8_0 = {
	200,
	100
}
local var9_0 = {
	100,
	50,
	20
}
local var10_0 = 20
local var11_0 = {
	point_boost = 100,
	wait_time_boost = 2,
	bullet_time = {
		0.1,
		4,
		0.8,
		5
	}
}
local var12_0 = {
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
local var13_0 = {
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
local var14_0 = {
	"A",
	"B",
	"C",
	"D"
}
local var15_0 = {
	"H",
	"J",
	"K",
	"I"
}
local var16_0

local function var17_0(arg0_1)
	if var16_0 then
		var16_0:Pause(not arg0_1)
	elseif arg0_1 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-icecream_topping", function(arg0_2)
			assert(arg0_2)

			var16_0 = arg0_2.playback
		end)
	end
end

function var0_0.getUIName(arg0_3)
	return "IceCreamGameUI"
end

function var0_0.initTimer(arg0_4)
	arg0_4.timer = Timer.New(function()
		arg0_4:onTimer()
	end, var3_0, -1)
end

function var0_0.didEnter(arg0_6)
	arg0_6:initTimer()
	arg0_6:initUI()
	arg0_6:initGameUI()
	arg0_6:openMainUI()
end

function var0_0.initUI(arg0_7)
	arg0_7.clickMask = arg0_7:findTF("ui/click_mask")
	arg0_7.rtResource = arg0_7._tf:Find("Resource")
	arg0_7.mainUI = arg0_7:findTF("ui/main_ui")
	arg0_7.listScrollRect = GetComponent(arg0_7.mainUI:Find("right_panel/item_list/content"), typeof(ScrollRect))

	onButton(arg0_7, arg0_7.mainUI:Find("btn_back"), function()
		arg0_7:emit(var0_0.ON_BACK_PRESSED)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.mainUI:Find("bg/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.icecreamgame_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.mainUI:Find("bg/btn_start"), function()
		arg0_7:readyStart()
	end, SFX_PANEL)

	arg0_7.totalTimes = arg0_7:getGameTotalTime()

	local var0_7 = arg0_7:getGameUsedTimes() - 4 < 0 and 0 or arg0_7:getGameUsedTimes() - 4

	scrollTo(arg0_7.listScrollRect, 0, 1 - var0_7 / (arg0_7.totalTimes - 4))
	onButton(arg0_7, arg0_7:findTF("right_panel/arrows_up", arg0_7.mainUI), function()
		local var0_11 = arg0_7.listScrollRect.normalizedPosition.y + 1 / (arg0_7.totalTimes - 4)

		if var0_11 > 1 then
			var0_11 = 1
		end

		scrollTo(arg0_7.listScrollRect, 0, var0_11)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7:findTF("right_panel/arrows_down", arg0_7.mainUI), function()
		local var0_12 = arg0_7.listScrollRect.normalizedPosition.y - 1 / (arg0_7.totalTimes - 4)

		if var0_12 < 0 then
			var0_12 = 0
		end

		scrollTo(arg0_7.listScrollRect, 0, var0_12)
	end, SFX_PANEL)

	local var1_7 = pg.mini_game[arg0_7:GetMGData().id].simple_config_data.drop_ids
	local var2_7 = arg0_7.mainUI:Find("right_panel/item_list/content")

	arg0_7.itemList = UIItemList.New(var2_7, var2_7:GetChild(0))

	arg0_7.itemList:make(function(arg0_13, arg1_13, arg2_13)
		arg1_13 = arg1_13 + 1

		if arg0_13 == UIItemList.EventUpdate then
			arg2_13.name = arg1_13

			GetImageSpriteFromAtlasAsync("ui/minigameui/icecreamgameui_atlas", "day_" .. arg1_13, arg2_13:Find("text"))

			local var0_13 = arg2_13:Find("IconTpl")
			local var1_13 = {}

			var1_13.type, var1_13.id, var1_13.count = unpack(var1_7[arg1_13])

			updateDrop(var0_13, var1_13)
			onButton(arg0_7, var0_13, function()
				arg0_7:emit(var0_0.ON_DROP, var1_13)
			end, SFX_PANEL)
		end
	end)
	arg0_7.itemList:align(#var1_7)

	arg0_7.countUI = arg0_7:findTF("ui/count_ui")
	arg0_7.countAnimator = GetComponent(arg0_7:findTF("count", arg0_7.countUI), typeof(Animator))
	arg0_7.countDft = GetOrAddComponent(arg0_7:findTF("count", arg0_7.countUI), typeof(DftAniEvent))

	arg0_7.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_7.countDft:SetEndEvent(function()
		setActive(arg0_7.countUI, false)
		arg0_7:startGame()
	end)

	arg0_7.pauseUI = arg0_7:findTF("ui/pause_ui")

	onButton(arg0_7, arg0_7:findTF("panel/btn_confirm", arg0_7.pauseUI), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7.pauseUI, arg0_7._tf:Find("ui"))
		setActive(arg0_7.pauseUI, false)
		arg0_7:resumeGame()
	end, SFX_PANEL)

	arg0_7.returnUI = arg0_7:findTF("ui/return_ui")

	onButton(arg0_7, arg0_7:findTF("panel/btn_confirm", arg0_7.returnUI), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7.returnUI, arg0_7._tf:Find("ui"))
		setActive(arg0_7.returnUI, false)
		arg0_7:resumeGame()
		arg0_7:endGame()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7:findTF("panel/btn_cancel", arg0_7.returnUI), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7.returnUI, arg0_7._tf:Find("ui"))
		setActive(arg0_7.returnUI, false)
		arg0_7:resumeGame()
	end, SFX_PANEL)

	arg0_7.endUI = arg0_7:findTF("ui/end_ui")

	onButton(arg0_7, arg0_7:findTF("panel/btn_finish", arg0_7.endUI), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7.endUI, arg0_7._tf:Find("ui"))
		setActive(arg0_7.endUI, false)
		arg0_7:openMainUI()
	end, SFX_PANEL)

	if not arg0_7.handle then
		arg0_7.handle = UpdateBeat:CreateListener(arg0_7.Update, arg0_7)
	end

	UpdateBeat:AddListener(arg0_7.handle)
end

function var0_0.Update(arg0_21)
	return
end

function var0_0.initGameUI(arg0_22)
	arg0_22.gameUI = arg0_22:findTF("ui/game_ui")
	arg0_22.timeTF = arg0_22.gameUI:Find("Score/time/Text")
	arg0_22.scoreTF = arg0_22.gameUI:Find("Score/point/Text")
	arg0_22.addScoreTF = arg0_22.gameUI:Find("Score/add_score")

	onButton(arg0_22, arg0_22.gameUI:Find("Button/btn_pause"), function()
		arg0_22:pauseGame()
		pg.UIMgr.GetInstance():OverlayPanel(arg0_22.pauseUI)
		setActive(arg0_22.pauseUI, true)
	end)
	onButton(arg0_22, arg0_22.gameUI:Find("Button/btn_back"), function()
		arg0_22:pauseGame()
		pg.UIMgr.GetInstance():OverlayPanel(arg0_22.returnUI)
		setActive(arg0_22.returnUI, true)
	end)

	arg0_22.rtWalk = arg0_22.gameUI:Find("Walk")
	arg0_22.rtMake = arg0_22.gameUI:Find("Make")
	arg0_22.rtTime = arg0_22.gameUI:Find("Time")
	arg0_22.rtButton = arg0_22.gameUI:Find("Button")

	for iter0_22 = 1, 4 do
		onButton(arg0_22, arg0_22.rtButton:Find("L" .. iter0_22), function()
			if not arg0_22.iceBuild or arg0_22.iceBuild.isLeftLock then
				return
			end

			local var0_25 = arg0_22.targetList[arg0_22.targetIndex]._info

			if #arg0_22.iceBuild._info[1] == #var0_25[1] then
				return
			end

			arg0_22.iceBuild:MakeBall(iter0_22)
		end)
		onButton(arg0_22, arg0_22.rtButton:Find("R" .. iter0_22), function()
			if not arg0_22.iceBuild or arg0_22.iceBuild.isRightLock then
				return
			end

			local var0_26 = arg0_22.targetList[arg0_22.targetIndex]._info

			if #arg0_22.iceBuild._info[2] == #var0_26[2] then
				return
			end

			if not arg0_22.iceBuild._info[1][var13_0[#var0_26[1]][#arg0_22.iceBuild._info[2] + 1]] then
				arg0_22.iceBuild:MakeMissTopping(iter0_22)
			else
				arg0_22.iceBuild:MakeTopping(iter0_22)
			end
		end)
	end

	arg0_22:bind(var1_0, function(arg0_27, ...)
		arg0_22:ResultTarget(...)
	end)
	arg0_22:bind(var2_0, function(arg0_28, arg1_28, ...)
		eachChild(arg0_22.rtTime, function(arg0_29)
			setActive(arg0_29, arg0_29.name == arg1_28)
		end)
		setSlider(arg0_22.rtTime:Find(arg1_28), ...)
	end)
end

function var0_0.updateMainUI(arg0_30)
	local var0_30 = arg0_30:getGameUsedTimes()
	local var1_30 = arg0_30:getGameTimes()
	local var2_30 = arg0_30.itemList.container
	local var3_30 = var2_30.childCount

	for iter0_30 = 1, var3_30 do
		local var4_30 = {
			award = true
		}

		if iter0_30 <= var0_30 then
			var4_30.finish = true
		elseif iter0_30 == var0_30 + 1 and var1_30 >= 1 then
			-- block empty
		elseif var0_30 < iter0_30 and iter0_30 <= var0_30 + var1_30 then
			-- block empty
		else
			var4_30.lock = true
			var4_30.award = false
		end

		local var5_30 = var2_30:GetChild(iter0_30 - 1)

		setActive(var5_30:Find("finish"), var4_30.finish)
		setActive(var5_30:Find("lock"), var4_30.lock)
		setActive(var5_30:Find("IconTpl"), var4_30.award)
	end

	arg0_30.totalTimes = arg0_30:getGameTotalTime()

	local var6_30 = 1 - (arg0_30:getGameUsedTimes() - 3 < 0 and 0 or arg0_30:getGameUsedTimes() - 3) / (arg0_30.totalTimes - 4)

	if var6_30 > 1 then
		var6_30 = 1
	end

	scrollTo(arg0_30.listScrollRect, 0, var6_30)
	arg0_30:checkGet()
end

function var0_0.checkGet(arg0_31)
	if arg0_31:getUltimate() == 0 then
		if arg0_31:getGameTotalTime() > arg0_31:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_31:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0_0.openMainUI(arg0_32)
	setActive(arg0_32.gameUI, false)
	setActive(arg0_32.mainUI, true)
	arg0_32:updateMainUI()
end

function var0_0.readyStart(arg0_33)
	setActive(arg0_33.mainUI, false)
	setActive(arg0_33.countUI, true)
	arg0_33.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ddldaoshu2")
	arg0_33:resetGame()
end

function var0_0.resetGame(arg0_34)
	arg0_34.gameStartFlag = false
	arg0_34.gamePause = false
	arg0_34.gameEndFlag = false
	arg0_34.scoreNum = 0
	arg0_34.lastTime = var6_0
	arg0_34.targetNameList = {}
	arg0_34.targetList = {}
	arg0_34.iceBuild = nil
	arg0_34.countList = {
		0,
		0,
		0
	}
	arg0_34.effectTrigger = {
		bullet_time = {
			waitTime = 0,
			doingTime = 0
		},
		wait_time_boost = {
			count = 0
		},
		point_boost = {}
	}

	eachChild(arg0_34.rtResource:Find("Character"), function(arg0_35)
		table.insert(arg0_34.targetNameList, arg0_35.name)
	end)
	removeAllChildren(arg0_34.rtWalk)
	setActive(arg0_34.gameUI:Find("BulletTimeMask"), false)
	setActive(arg0_34.rtMake, false)
	setActive(arg0_34.rtTime, false)
	setText(arg0_34.scoreTF, arg0_34.scoreNum)
	setActive(arg0_34.addScoreTF, false)
	arg0_34:setAnimatorSpeed(arg0_34._tf, 1)
end

local function var18_0(arg0_36, arg1_36, arg2_36, arg3_36)
	local var0_36 = {}

	local function var1_36(arg0_37, arg1_37)
		for iter0_37 = math.max(#arg1_37[1], 2), 1, -1 do
			setActive(arg0_37:Find(iter0_37), arg1_37[1][iter0_37])

			if arg1_37[1][iter0_37] then
				local var0_37 = arg0_37:Find(iter0_37)

				GetImageSpriteFromAtlasAsync("ui/minigameui/icecreamgameui_atlas", "Assets/ArtResource/UI/MiniGameUI/IceCreamGameUI/ICE_S/" .. var14_0[arg1_37[1][iter0_37]] .. ".png", var0_37:Find("Scoop"), true)

				local var1_37 = arg1_37[2][var12_0[#arg1_37[1]][iter0_37]]

				setActive(var0_37:Find("Topping"), var1_37)

				if var1_37 then
					GetImageSpriteFromAtlasAsync("ui/minigameui/icecreamgameui_atlas", "Assets/ArtResource/UI/MiniGameUI/IceCreamGameUI/ICE_S/" .. var15_0[var1_37] .. ".png", var0_37:Find("Topping"), true)
				end
			end
		end
	end

	function var0_36.Ctor(arg0_38)
		arg0_38._tf = arg0_36
		arg0_38._event = arg1_36
		arg0_38._info = arg2_36
		arg0_38.time = arg3_36
		arg0_38.pointBoost = 100
		arg0_38.result = nil

		local var0_38 = #arg2_36[1] < 3 and "Cone" or "Bowl"

		for iter0_38, iter1_38 in ipairs({
			"IceCream",
			"Bubble",
			"BadCream"
		}) do
			eachChild(arg0_36:Find(iter1_38), function(arg0_39)
				setActive(arg0_39, arg0_39.name == var0_38)
			end)
		end

		var1_36(arg0_36:Find("Bubble/" .. var0_38), arg2_36)
		GetImageSpriteFromAtlasAsync("ui/minigameui/icecreamgameui_atlas", "Assets/ArtResource/UI/MiniGameUI/IceCreamGameUI/ICE_S/bubble_" .. #arg2_36[1] .. ".png", arg0_36:Find("Bubble"), true)
		setActive(arg0_36:Find("Bubble/Boost"), false)

		arg0_38.animator = GetComponent(arg0_38._tf, typeof(Animator))

		arg0_38._tf:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
			arg0_38.isLeave = true
		end)
	end

	function var0_36.Result(arg0_41, arg1_41, arg2_41)
		arg0_41.result = arg1_41

		local var0_41 = #arg2_41[1] < 3 and "Cone" or "Bowl"

		if arg1_41 == 0 then
			arg0_41.animator:Play("Bad")
		elseif arg1_41 == 1 then
			var1_36(arg0_41._tf:Find("IceCream/" .. var0_41), arg2_41)
			arg0_41.animator:Play("Hmm")
		elseif arg1_41 >= 2 then
			var1_36(arg0_41._tf:Find("IceCream/" .. var0_41), arg2_41)
			arg0_41.animator:Play("Great")
		else
			assert(false)
		end
	end

	var0_36:Ctor()

	return var0_36
end

function var0_0.CreateTarget(arg0_42, arg1_42)
	local var0_42 = table.remove(arg0_42.targetNameList, math.random(#arg0_42.targetNameList))
	local var1_42 = cloneTplTo(arg0_42.rtResource:Find("Character/" .. var0_42), arg0_42.rtWalk, var0_42)

	setAnchoredPosition(var1_42, {
		x = arg1_42 or -var7_0[1]
	})

	local var2_42 = {
		{},
		{}
	}
	local var3_42 = var0_42 == "Agir" and {
		1,
		2
	} or {
		1,
		2,
		3
	}

	if #arg0_42.targetList > 0 then
		table.removebyvalue(var3_42, #arg0_42.targetList[#arg0_42.targetList]._info[1])
	end

	for iter0_42 = var3_42[math.random(#var3_42)], 1, -1 do
		table.insert(var2_42[1], math.random(4))
	end

	local var4_42 = {
		1,
		2,
		3,
		4
	}

	for iter1_42 = math.max(1, #var2_42[1] - 1), 1, -1 do
		table.insert(var2_42[2], table.remove(var4_42, math.random(#var4_42)))
	end

	local var5_42 = math.clamp(var5_0[#var2_42[1]][2] - arg0_42.countList[#var2_42[1]], unpack(var5_0[#var2_42[1]]))

	arg0_42.countList[#var2_42[1]] = arg0_42.countList[#var2_42[1]] + 1

	table.insert(arg0_42.targetList, var18_0(var1_42, arg0_42, var2_42, var5_42))
end

function var0_0.RemoveTarget(arg0_43)
	assert(#arg0_43.targetList > 0)

	local var0_43 = table.remove(arg0_43.targetList, 1)

	arg0_43.targetIndex = arg0_43.targetIndex - 1

	table.insert(arg0_43.targetNameList, var0_43._tf.name)
	Destroy(var0_43._tf)
end

function var0_0.ResultTarget(arg0_44, arg1_44, arg2_44, ...)
	assert(#arg0_44.targetList > 0)

	arg1_44 = math.ceil(arg1_44 * arg0_44.targetList[arg0_44.targetIndex].pointBoost / 100)

	arg0_44:addScore(arg1_44, arg2_44)
	arg0_44.targetList[arg0_44.targetIndex]:Result(arg2_44, ...)
	arg0_44:TriggerSpecialEffect(arg2_44, ...)

	arg0_44.targetIndex = arg0_44.targetIndex + 1
	arg0_44.iceBuild = nil

	onNextTick(function()
		setActive(arg0_44.rtMake, false)
		setActive(arg0_44.rtTime, false)
	end)

	local var0_44 = arg0_44.effectTrigger.bullet_time

	if var0_44.doingTime > 0 then
		var0_44.doingTime = 0

		arg0_44:setAnimatorSpeed(arg0_44._tf, 1)
		setActive(arg0_44.gameUI:Find("BulletTimeMask"), false)
	end
end

function var0_0.TriggerSpecialEffect(arg0_46, arg1_46, arg2_46)
	if arg1_46 == 3 then
		local var0_46 = arg0_46.targetList[arg0_46.targetIndex + 1]
		local var1_46 = arg0_46.effectTrigger.bullet_time

		if #arg0_46.targetList[arg0_46.targetIndex]._info[1] == 3 and var1_46.waitTime <= 0 and math.random() < var11_0.bullet_time[3] then
			var0_46.timeBoost = true
		end

		local var2_46 = arg0_46.effectTrigger.wait_time_boost

		var2_46.count = var2_46.count + 1

		if var2_46.count == 2 then
			var2_46.count = 0
			var0_46.time = var0_46.time + var11_0.wait_time_boost
			var0_46.isWaitTimeBoost = true
		end

		local var3_46 = arg0_46.effectTrigger.point_boost
		local var4_46 = arg0_46.targetList[arg0_46.targetIndex]._tf.name

		if var3_46[var4_46] == "finish" then
			-- block empty
		elseif var3_46[var4_46] == "count" then
			var0_46.pointBoost = var0_46.pointBoost + var11_0.point_boost

			setActive(var0_46._tf:Find("Bubble/Boost"), true)

			var3_46[var4_46] = "finish"
		else
			var3_46[var4_46] = "count"
		end
	else
		local var5_46 = arg0_46.effectTrigger.point_boost
		local var6_46 = arg0_46.targetList[arg0_46.targetIndex]._tf.name

		if var5_46[var6_46] == "finish" then
			-- block empty
		else
			var5_46[var6_46] = nil
		end
	end
end

local function var19_0(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47)
	local var0_47 = {
		Ctor = function(arg0_48)
			arg0_48._tf = arg0_47
			arg0_48._event = arg1_47
			arg0_48._info = {
				{},
				{}
			}
			arg0_48.isLeftLock = false
			arg0_48.isRightLock = false
			arg0_48.missToppingMark = {}
			arg0_48.waitTime = arg3_47
			arg0_48.isWaitTimeBoost = arg4_47

			arg0_48:Reset()
			arg0_48:NextDeal()
		end,
		NextDeal = function(arg0_49)
			if arg0_49.isLeftLock or arg0_49.isRightLock then
				return
			end

			if #arg0_49._info[1] < #arg2_47[1] then
				arg0_49:ReadyBall()
			elseif #arg0_49._info[2] < #arg2_47[2] then
				arg0_49:ReadyTopping()
			else
				arg0_49:Result()
			end
		end,
		Result = function(arg0_50, arg1_50)
			arg0_50.isResulted = true

			var17_0(false)

			local var0_50 = 0
			local var1_50 = {
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

			local function var2_50(arg0_51, arg1_51, arg2_51)
				local var0_51 = arg0_51[arg1_51]

				arg0_51[arg1_51] = arg0_51[arg1_51] + arg2_51

				return math.abs(arg0_51[arg1_51]) - math.abs(var0_51)
			end

			for iter0_50, iter1_50 in ipairs(arg0_50._info) do
				for iter2_50, iter3_50 in ipairs(iter1_50) do
					if var2_50(var1_50[iter0_50], arg2_47[iter0_50][iter2_50], -1) < 0 then
						var0_50 = var0_50 + var9_0[iter0_50]
					end

					if var2_50(var1_50[iter0_50], iter3_50, 1) < 0 then
						var0_50 = var0_50 + var9_0[iter0_50]
					end

					if arg2_47[iter0_50][iter2_50] == iter3_50 and (iter0_50 == 1 or not arg0_50.missToppingMark[iter2_50]) then
						var0_50 = var0_50 + var9_0[3]
					end
				end
			end

			if arg1_50 then
				arg0_50.result = arg1_50
			else
				local var3_50 = #arg0_50._info[1] * var9_0[1] + #arg0_50._info[2] * var9_0[2] + (#arg0_50._info[1] + #arg0_50._info[2]) * var9_0[3]

				if var0_50 == var3_50 then
					arg0_50.result = 3
				elseif table.equal(arg0_50._info, arg2_47) then
					arg0_50.result = 2
				elseif var0_50 >= var3_50 / 2 then
					arg0_50.result = 1
				else
					arg0_50.result = 0
				end
			end

			local var4_50 = arg0_50._tf:GetComponent(typeof(Animator))

			if arg0_50.result == 3 then
				arg0_50.point = var0_50 * (1 + var10_0 / 100 + arg0_50.waitTime / arg3_47)

				var4_50:Play("Perfect")
				pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-icecream_great")
			elseif arg0_50.result == 2 then
				arg0_50.point = var0_50 * (1 + arg0_50.waitTime / arg3_47)

				var4_50:Play("Pass")
			elseif arg0_50.result == 1 then
				arg0_50.point = var0_50 * (1 + arg0_50.waitTime / arg3_47)

				var4_50:Play("Pass")
			elseif arg0_50.result == 0 then
				arg0_50.point = 0

				var4_50:Play("Fail")
				pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-icecream_fail")
			else
				assert(false)
			end
		end,
		CountDown = function(arg0_52, arg1_52, arg2_52)
			if arg0_52.isResulted then
				return
			end

			if arg0_52.waitTime > 0 then
				arg0_52.waitTime = arg0_52.waitTime - arg1_52

				arg0_52._event:emit(var2_0, arg2_52, 0, arg3_47, arg0_52.waitTime)
			else
				arg0_52.waitTime = 0

				arg0_52:Result(0)
			end

			if not arg0_52.missTime then
				return
			end

			if arg0_52.missTime > 0 then
				arg0_52.missTime = arg0_52.missTime - var3_0
			else
				arg0_52.missTime = nil

				arg0_52:FailMissTopping()
			end
		end,
		Reset = function(arg0_53)
			arg0_53._tf:GetComponent("DftAniEvent"):SetEndEvent(function()
				onNextTick(function()
					setActive(arg0_53._tf, false)
				end)
				arg0_53._event:emit(var1_0, arg0_53.point, arg0_53.result, arg0_53._info)
			end)
			arg0_53._tf:GetComponent("DftAniEvent"):SetTriggerEvent(function()
				for iter0_56 = arg0_53._tf.name == "Cone" and 2 or 3, 1, -1 do
					setActive(arg0_53._tf:Find(iter0_56), false)
				end

				setActive(arg0_53._tf:Find("Back"), false)

				if arg0_53._tf.name == "Bowl" then
					setActive(arg0_53._tf:Find("Front"), false)
				end
			end)
			setActive(arg0_53._tf:Find("Back"), true)

			if arg0_53._tf.name == "Bowl" then
				setActive(arg0_53._tf:Find("Front"), true)
			end

			for iter0_53 = arg0_53._tf.name == "Cone" and 2 or 3, 1, -1 do
				local var0_53 = arg0_53._tf:Find(iter0_53)

				setActive(var0_53, iter0_53 <= #arg2_47[1])

				if iter0_53 <= #arg2_47[1] then
					eachChild(var0_53, function(arg0_57)
						setActive(arg0_57, false)
					end)
					var0_53:Find("Scoop"):GetComponent("DftAniEvent"):SetEndEvent(function()
						arg0_53.isLeftLock = false

						if arg0_53.successLeftLight then
							arg0_53.successLeftLight = false

							setAnchoredPosition(var0_53:Find("Good"), {
								x = 0,
								y = -10
							})
							setActive(var0_53:Find("Good"), false)
							setActive(var0_53:Find("Good"), true)
						end

						arg0_53:NextDeal()
					end)
					var0_53:Find("Topping"):GetComponent("DftAniEvent"):SetEndEvent(function()
						arg0_53.isRightLock = false

						if arg0_53.successRightLight then
							arg0_53.successRightLight = false

							setAnchoredPosition(var0_53:Find("Good"), {
								x = 10,
								y = 6
							})
							setActive(var0_53:Find("Good"), false)
							setActive(var0_53:Find("Good"), true)
						end

						arg0_53:NextDeal()
					end)
				end
			end
		end,
		ReadyBall = function(arg0_60)
			local var0_60 = arg0_60._tf:Find(#arg0_60._info[1] + 1)

			setActive(var0_60:Find("Scoop_Next"), true)
		end,
		MakeBall = function(arg0_61, arg1_61)
			arg0_61.isLeftLock = true

			local var0_61 = arg0_61._tf:Find(#arg0_61._info[1] + 1)

			setActive(var0_61:Find("Scoop_Next"), false)
			setActive(var0_61:Find("Scoop"), true)
			var0_61:Find("Scoop"):GetComponent(typeof(Animator)):Play("Scoop_" .. var14_0[arg1_61])
			table.insert(arg0_61._info[1], arg1_61)

			arg0_61.successLeftLight = arg0_61._info[1][#arg0_61._info[1]] == arg2_47[1][#arg0_61._info[1]]

			if arg0_61.temporaryKey and var13_0[#arg2_47[1]][#arg0_61._info[2] + 1] == #arg0_61._info[1] then
				arg0_61:SafeMissTopping()
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-icecream_flavour")
		end,
		ReadyTopping = function(arg0_62)
			local var0_62 = arg0_62._tf:Find(var13_0[#arg2_47[1]][#arg0_62._info[2] + 1])

			setActive(var0_62:Find("Topping_Next"), true)
		end,
		MakeTopping = function(arg0_63, arg1_63)
			arg0_63.isRightLock = true

			local var0_63 = arg0_63._tf:Find(var13_0[#arg2_47[1]][#arg0_63._info[2] + 1])

			setActive(var0_63:Find("Topping_Next"), false)
			setActive(var0_63:Find("Topping"), true)
			var0_63:Find("Topping"):GetComponent(typeof(Animator)):Play("Topping_" .. var15_0[arg1_63])
			table.insert(arg0_63._info[2], arg1_63)

			arg0_63.successRightLight = arg0_63._info[2][#arg0_63._info[2]] == arg2_47[2][#arg0_63._info[2]]

			pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-icecream_mixer")
		end,
		MakeMissTopping = function(arg0_64, arg1_64)
			arg0_64.isRightLock = true
			arg0_64.temporaryKey = arg1_64
			arg0_64.missTime = var4_0 * (var13_0[#arg2_47[1]][#arg0_64._info[2] + 1] - #arg0_64._info[1])

			var17_0(true)

			local var0_64 = arg0_64._tf:Find(var13_0[#arg2_47[1]][#arg0_64._info[2] + 1])

			setActive(var0_64:Find("Topping_Next"), false)
			setActive(var0_64:Find("Topping"), true)
			var0_64:Find("Topping"):GetComponent(typeof(Animator)):Play("Topping_pre_" .. var15_0[arg1_64])
		end,
		FailMissTopping = function(arg0_65)
			arg0_65.isRightLock = true

			local var0_65 = arg0_65.temporaryKey

			arg0_65.temporaryKey = nil
			arg0_65.missTime = nil

			var17_0(false)

			local var1_65 = arg0_65._tf:Find(var13_0[#arg2_47[1]][#arg0_65._info[2] + 1])

			setActive(var1_65:Find("Topping_Next"), false)
			setActive(var1_65:Find("Topping"), true)
			var1_65:Find("Topping"):GetComponent(typeof(Animator)):Play("Topping_Err_" .. var15_0[var0_65])
		end,
		SafeMissTopping = function(arg0_66)
			arg0_66.isRightLock = true

			local var0_66 = arg0_66.temporaryKey

			arg0_66.temporaryKey = nil
			arg0_66.missTime = nil

			var17_0(false)

			local var1_66 = arg0_66._tf:Find(var13_0[#arg2_47[1]][#arg0_66._info[2] + 1])

			setActive(var1_66:Find("Topping_Next"), false)
			setActive(var1_66:Find("Topping"), true)
			var1_66:Find("Topping"):GetComponent(typeof(Animator)):Play("Topping_safe_" .. var15_0[var0_66])
			table.insert(arg0_66._info[2], var0_66)

			arg0_66.successRightLight = arg0_66._info[2][#arg0_66._info[2]] == arg2_47[2][#arg0_66._info[2]]
			arg0_66.missToppingMark[#arg0_66._info[2]] = true

			pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-icecream_mixer")
		end
	}

	var0_47:Ctor()

	return var0_47
end

function var0_0.DoIceCream(arg0_67)
	setActive(arg0_67.rtTime, true)
	setActive(arg0_67.rtMake, true)

	local var0_67 = arg0_67.targetList[arg0_67.targetIndex]
	local var1_67 = #var0_67._info[1] < 3 and "Cone" or "Bowl"

	eachChild(arg0_67.rtMake, function(arg0_68)
		setActive(arg0_68, arg0_68.name == var1_67)
	end)

	local var2_67 = arg0_67.rtMake:Find(var1_67)

	for iter0_67 = var1_67 == "Cone" and 2 or 3, 1, -1 do
		setActive(var2_67:Find(iter0_67), false)
	end

	arg0_67.iceBuild = var19_0(var2_67, arg0_67, var0_67._info, var0_67.time, var0_67.isWaitTimeBoost)

	if var0_67.timeBoost then
		local var3_67 = arg0_67.effectTrigger.bullet_time

		var3_67.doingTime = var11_0.bullet_time[2]
		var3_67.waitTime = var11_0.bullet_time[4]

		arg0_67:setAnimatorSpeed(arg0_67._tf, 0.5)
		arg0_67:setAnimatorSpeed(arg0_67.rtMake, 1)
		setActive(arg0_67.gameUI:Find("BulletTimeMask"), true)
	end
end

function var0_0.startGame(arg0_69)
	setActive(arg0_69.gameUI, true)

	arg0_69.gameStartFlag = true

	arg0_69:CreateTarget(-var7_0[1] / 3)

	arg0_69.targetIndex = 1

	arg0_69:RandomBG()
	arg0_69:timerStart()
end

function var0_0.RandomBG(arg0_70)
	arg0_70.poolBG = arg0_70.poolBG or {
		GroupD = {
			1
		}
	}

	if not arg0_70.poolBG.GroupAB or #arg0_70.poolBG.GroupAB == 0 then
		arg0_70.poolBG.GroupAB = {
			1,
			2,
			3,
			4,
			5,
			6
		}
	end

	if not arg0_70.poolBG["GroupC/Other"] or #arg0_70.poolBG["GroupC/Other"] == 0 then
		arg0_70.poolBG["GroupC/Other"] = {
			1,
			2,
			3,
			4
		}
	end

	arg0_70.poolBG["GroupC/Manjuu"] = {
		1,
		2,
		3
	}

	for iter0_70, iter1_70 in pairs(arg0_70.poolBG) do
		local var0_70 = {}

		for iter2_70 = iter0_70 == "GroupC/Manjuu" and 2 or 1, 1, -1 do
			if iter0_70 == "GroupD" then
				var0_70[iter1_70[1]] = true
				iter1_70[1] = 3 - iter1_70[1]
			else
				var0_70[table.remove(iter1_70, math.random(#iter1_70))] = true
			end
		end

		local var1_70 = arg0_70.gameUI:Find("BG/" .. iter0_70)

		for iter3_70 = var1_70.childCount, 1, -1 do
			setActive(var1_70:GetChild(iter3_70 - 1), var0_70[iter3_70])
		end
	end
end

function var0_0.getIntervalTime(arg0_71)
	if arg0_71.effectTrigger.bullet_time.doingTime > 0 then
		return var3_0 * var11_0.bullet_time[1]
	else
		return var3_0
	end
end

function var0_0.onTimer(arg0_72)
	local var0_72 = arg0_72.effectTrigger.bullet_time

	if var0_72.doingTime > 0 then
		var0_72.doingTime = var0_72.doingTime - var3_0

		if var0_72.doingTime <= 0 then
			arg0_72:setAnimatorSpeed(arg0_72._tf, 1)
			setActive(arg0_72.gameUI:Find("BulletTimeMask"), false)
		end
	elseif var0_72.waitTime > 0 then
		var0_72.waitTime = var0_72.waitTime - var3_0
	end

	arg0_72.lastTime = arg0_72.lastTime - arg0_72:getIntervalTime()

	arg0_72:updateWalker()

	if arg0_72.lastTime <= 0 then
		arg0_72:endGame()
	else
		setText(arg0_72.timeTF, math.floor(arg0_72.lastTime))

		if not arg0_72.iceBuild and arg0_72.targetList[arg0_72.targetIndex]._tf.anchoredPosition.x > 0 then
			arg0_72:DoIceCream()
		end

		if #arg0_72.targetList == arg0_72.targetIndex then
			arg0_72:CreateTarget()
		end
	end

	if arg0_72.iceBuild then
		local var1_72
		local var2_72 = var0_72.doingTime > 0 and "frozen" or arg0_72.iceBuild.isWaitTimeBoost and "extend" or "base"

		arg0_72.iceBuild:CountDown(arg0_72:getIntervalTime(), var2_72)
	end
end

function var0_0.updateWalker(arg0_73)
	for iter0_73 = #arg0_73.targetList, 1, -1 do
		local var0_73 = arg0_73.targetList[iter0_73]
		local var1_73 = var0_73._tf:GetComponent(typeof(Animator))
		local var2_73 = var1_73:GetCurrentAnimatorStateInfo(0)

		if var0_73.result then
			if var0_73.isLeave then
				setAnchoredPosition(var0_73._tf, {
					x = var0_73._tf.anchoredPosition.x + arg0_73:getIntervalTime() * var8_0[1]
				})

				if var0_73._tf.anchoredPosition.x > var7_0[1] then
					arg0_73:RemoveTarget()
				end
			end
		else
			local var3_73 = var7_0[3]

			if iter0_73 > 1 then
				var3_73 = math.min(var3_73, arg0_73.targetList[iter0_73 - 1]._tf.anchoredPosition.x)
			end

			local var4_73 = var3_73 - var0_73._tf.anchoredPosition.x

			if var4_73 < var7_0[3] then
				if not var0_73.state or var0_73.state ~= "Stand" then
					var0_73.state = "Stand"

					var1_73:Play("Stand")
				end
			elseif var4_73 < var7_0[2] then
				setAnchoredPosition(var0_73._tf, {
					x = var0_73._tf.anchoredPosition.x + arg0_73:getIntervalTime() * var8_0[2]
				})

				if not var0_73.state or var0_73.state ~= "Walk" then
					var0_73.state = "Walk"

					var1_73:Play("Walk")
				end
			else
				setAnchoredPosition(var0_73._tf, {
					x = var0_73._tf.anchoredPosition.x + arg0_73:getIntervalTime() * var8_0[1]
				})

				if not var0_73.state or var0_73.state ~= "Run" then
					var0_73.state = "Run"

					var1_73:Play("Run")
				end
			end
		end
	end
end

function var0_0.setAnimatorSpeed(arg0_74, arg1_74, arg2_74)
	local var0_74 = arg1_74:GetComponentsInChildren(typeof(Animator), true)

	for iter0_74 = 0, var0_74.Length - 1 do
		var0_74[iter0_74].speed = arg2_74
	end
end

function var0_0.timerStart(arg0_75)
	if not arg0_75.timer.running then
		arg0_75.timer:Start()
	end

	if arg0_75.effectTrigger.bullet_time.doingTime > 0 then
		arg0_75:setAnimatorSpeed(arg0_75._tf, 0.5)
		arg0_75:setAnimatorSpeed(arg0_75.rtMake, 1)
	else
		arg0_75:setAnimatorSpeed(arg0_75._tf, 1)
	end

	if arg0_75.iceBuild and arg0_75.iceBuild.missTime then
		var17_0(true)
	end
end

function var0_0.timerStop(arg0_76)
	if arg0_76.timer.running then
		arg0_76.timer:Stop()
	end

	arg0_76:setAnimatorSpeed(arg0_76._tf, 0)

	if arg0_76.iceBuild and arg0_76.iceBuild.missTime then
		var17_0(false)
	end
end

function var0_0.addScore(arg0_77, arg1_77, arg2_77)
	arg0_77.scoreNum = arg0_77.scoreNum + arg1_77

	setText(arg0_77.scoreTF, arg0_77.scoreNum)
	setActive(arg0_77.addScoreTF, false)
	setActive(arg0_77.addScoreTF, true)

	local var0_77 = arg0_77.addScoreTF:Find("score_tf")

	setText(var0_77, "+" .. arg1_77)

	if arg2_77 == 0 then
		setTextColor(var0_77, Color.NewHex("ED666DFF"))
	elseif arg2_77 == 1 then
		setTextColor(var0_77, Color.NewHex("FAB149FF"))
	elseif arg2_77 == 2 then
		setTextColor(var0_77, Color.NewHex("C6CC15FF"))
	elseif arg2_77 == 3 then
		setTextColor(var0_77, Color.NewHex("80BF1CFF"))
	else
		assert(false)
	end
end

function var0_0.pauseGame(arg0_78)
	arg0_78.gamePause = true

	arg0_78:timerStop()
	arg0_78:pauseManagedTween()
end

function var0_0.resumeGame(arg0_79)
	arg0_79.gamePause = false

	arg0_79:timerStart()
	arg0_79:resumeManagedTween()
end

function var0_0.endGame(arg0_80)
	if arg0_80.gameEndFlag then
		return
	end

	arg0_80:timerStop()

	arg0_80.gameEndFlag = true

	setActive(arg0_80.clickMask, true)
	arg0_80:managedTween(LeanTween.delayedCall, function()
		arg0_80.gameEndFlag = false
		arg0_80.gameStartFlag = false

		setActive(arg0_80.clickMask, false)
		arg0_80:showEndUI()
	end, 0.1, nil)
end

function var0_0.showEndUI(arg0_82)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_82.endUI)
	setActive(arg0_82.endUI, true)

	local var0_82 = arg0_82:GetMGData():GetRuntimeData("elements")
	local var1_82 = arg0_82.scoreNum
	local var2_82 = var0_82 and #var0_82 > 0 and var0_82[1] or 0

	setActive(arg0_82:findTF("panel/now/Text/new", arg0_82.endUI), var2_82 < var1_82)

	if var2_82 <= var1_82 then
		var2_82 = var1_82

		arg0_82:StoreDataToServer({
			var2_82
		})
	end

	local var3_82 = arg0_82:findTF("panel/max/Text", arg0_82.endUI)
	local var4_82 = arg0_82:findTF("panel/now/Text", arg0_82.endUI)

	setText(var3_82, var2_82)
	setText(var4_82, var1_82)

	if arg0_82:getGameTimes() and arg0_82:getGameTimes() > 0 then
		arg0_82:SendSuccess(0)
	end
end

function var0_0.getGameTimes(arg0_83)
	return arg0_83:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_84)
	return arg0_84:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_85)
	return arg0_85:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_86)
	return (arg0_86:GetMGHubData():getConfig("reward_need"))
end

function var0_0.OnApplicationPaused(arg0_87, arg1_87)
	if arg1_87 and not arg0_87.gameEndFlag and arg0_87.gameStartFlag and not arg0_87.gamePause then
		arg0_87:pauseGame()
		pg.UIMgr.GetInstance():OverlayPanel(arg0_87.pauseUI)
		setActive(arg0_87.pauseUI, true)
	end
end

function var0_0.onBackPressed(arg0_88)
	if arg0_88.gameEndFlag then
		return
	end

	if isActive(arg0_88.pauseUI) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_88.pauseUI, arg0_88._tf:Find("ui"))
		setActive(arg0_88.pauseUI, false)
		arg0_88:resumeGame()

		return
	end

	if isActive(arg0_88.returnUI) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_88.returnUI, arg0_88._tf:Find("ui"))
		setActive(arg0_88.returnUI, false)
		arg0_88:resumeGame()

		return
	end

	if isActive(arg0_88.endUI) then
		return
	end

	if arg0_88.gameStartFlag then
		arg0_88:pauseGame()
		pg.UIMgr.GetInstance():OverlayPanel(arg0_88.pauseUI)
		setActive(arg0_88.pauseUI, true)

		return
	end

	arg0_88:emit(var0_0.ON_BACK_PRESSED)
end

function var0_0.willExit(arg0_89)
	if arg0_89.handle then
		UpdateBeat:RemoveListener(arg0_89.handle)
	end

	arg0_89:cleanManagedTween()

	if arg0_89.timer and arg0_89.timer.running then
		arg0_89.timer:Stop()
	end

	Time.timeScale = 1
	arg0_89.timer = nil
end

return var0_0
