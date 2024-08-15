local var0_0 = class("GameRoomShootingView", import("..BaseMiniGameView"))

var0_0.animTime = 0.333333333333333
var0_0.moveModulus = 120

function var0_0.getUIName(arg0_1)
	return "GameRoomShootingUI"
end

function var0_0.init(arg0_2)
	arg0_2.uiMGR = pg.UIMgr.GetInstance()
	arg0_2.blurPanel = arg0_2._tf:Find("noAdaptPanel/blur_panel")
	arg0_2.top = arg0_2.blurPanel:Find("top")
	arg0_2.backBtn = arg0_2.top:Find("back")
	arg0_2.scoreTF = arg0_2.top:Find("score/Text")

	setText(arg0_2.scoreTF, 0)

	arg0_2.bestScoreTF = arg0_2.top:Find("score_heightest/Text")
	arg0_2.ticketTF = arg0_2.top:Find("ticket/Text")
	arg0_2.helpBtn = arg0_2.top:Find("help_btn")

	setActive(arg0_2.helpBtn, false)

	arg0_2.sightTF = arg0_2.blurPanel:Find("MoveArea/Sight")

	setActive(arg0_2.sightTF, false)

	arg0_2.corners = arg0_2.blurPanel:Find("Corners")
	arg0_2.shootAreaTF = arg0_2._tf:Find("noAdaptPanel/ShootArea")
	arg0_2.targetPanel = arg0_2.shootAreaTF:Find("target_panel")
	arg0_2.targetTpl = {}

	local var0_2 = arg0_2.shootAreaTF:Find("tpl")

	for iter0_2 = 1, var0_2.childCount do
		arg0_2.targetTpl[iter0_2] = var0_2:GetChild(iter0_2 - 1)
	end

	setActive(var0_2, false)

	arg0_2.startMaskTF = arg0_2._tf:Find("noAdaptPanel/blur_panel/start_mask")
	arg0_2.countdownTF = arg0_2._tf:Find("noAdaptPanel/blur_panel/countUI")
	arg0_2.lastTimeTF = arg0_2.shootAreaTF:Find("time_word")
	arg0_2.bottomTF = arg0_2._tf:Find("noAdaptPanel/bottom")
	arg0_2.joyStrickTF = arg0_2.bottomTF:Find("Stick")
	arg0_2.fireBtn = arg0_2.bottomTF:Find("fire/ActCtl")
	arg0_2.fireBtnDelegate = GetOrAddComponent(arg0_2.fireBtn, "EventTriggerListener")

	setActive(arg0_2.fireBtn:Find("block"), false)

	arg0_2.resultPanel = arg0_2._tf:Find("result_panel")

	setText(findTF(arg0_2.resultPanel, "main/right/score/Text"), i18n("game_room_shooting_tip"))
	setActive(arg0_2.resultPanel, false)
end

function var0_0.initData(arg0_3)
	arg0_3.tempConfig = arg0_3:GetMGData():getConfig("simple_config_data")
	arg0_3.tempConfig.waitCountdown = 3
	arg0_3.tempConfig.half = 56
end

function var0_0.addTimer(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4.timerList = arg0_4.timerList or {}

	assert(arg0_4.timerList[arg1_4] == nil, "error Timers")
	assert(arg2_4 > 0, "duration must >0")

	arg0_4.timerList[arg1_4] = {
		timeMark = Time.realtimeSinceStartup + arg2_4,
		func = arg3_4
	}
end

function var0_0.updateTimers(arg0_5)
	local var0_5 = Time.realtimeSinceStartup

	for iter0_5, iter1_5 in pairs(arg0_5.timerList) do
		if var0_5 > iter1_5.timeMark then
			local var1_5 = iter1_5.func

			arg0_5.timerList[iter0_5] = nil

			var1_5()
		end
	end
end

function var0_0.stopTimers(arg0_6)
	arg0_6.isStopped = true

	local var0_6 = Time.realtimeSinceStartup

	for iter0_6, iter1_6 in pairs(arg0_6.timerList) do
		iter1_6.timeMark = iter1_6.timeMark - var0_6
	end
end

function var0_0.restartTimers(arg0_7)
	arg0_7.isStopped = false

	local var0_7 = Time.realtimeSinceStartup

	for iter0_7, iter1_7 in pairs(arg0_7.timerList) do
		iter1_7.timeMark = iter1_7.timeMark + var0_7
	end
end

function var0_0.clearTimers(arg0_8)
	arg0_8.timerList = {}
end

function var0_0.didEnter(arg0_9)
	onButton(arg0_9, arg0_9.backBtn, function()
		if arg0_9.isPlaying then
			arg0_9:stopTimers()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tips_summergame_exit"),
				onYes = function()
					arg0_9.lastTime = 0

					arg0_9:restartTimers()
					arg0_9:gameFinish()
				end,
				onNo = function()
					arg0_9:restartTimers()
				end
			})
		else
			arg0_9:closeView()
		end
	end)
	onButton(arg0_9, findTF(arg0_9.startMaskTF, "startGame"), function()
		if not arg0_9.isPlaying then
			arg0_9:openCoinLayer(false)
			arg0_9:gameStart()
		end
	end)

	if arg0_9:getGameRoomData() then
		arg0_9.gameHelpTip = arg0_9:getGameRoomData().game_help
	end

	onButton(arg0_9, findTF(arg0_9.startMaskTF, "ruleGame"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0_9.gameHelpTip
		})
	end)
	arg0_9:initData()
	arg0_9:updateCount()
	arg0_9:resetTime()
	arg0_9:initFireFunc()
	arg0_9:setFireLink(false)
	arg0_9:changeStartMaskUI(true)
end

function var0_0.changeStartMaskUI(arg0_15, arg1_15)
	setActive(arg0_15.bottomTF, not arg1_15)
	setActive(arg0_15.startMaskTF, arg1_15)
end

function var0_0.onBackPressed(arg0_16)
	triggerButton(arg0_16.backBtn)
end

local function var1_0(arg0_17, arg1_17)
	return Vector2(math.clamp(arg0_17.x, -arg1_17.x, arg1_17.x), math.clamp(arg0_17.y, -arg1_17.y, arg1_17.y))
end

function var0_0.update(arg0_18)
	local var0_18 = Time.GetTimestamp()

	if not arg0_18.isStopped then
		if arg0_18.isAfterCount and arg0_18.sightTimeMark then
			if not arg0_18.moveRect then
				local var1_18 = tf(arg0_18.sightTF.parent)

				arg0_18.moveRect = Vector2(var1_18.rect.width - arg0_18.sightTF.rect.width, var1_18.rect.height - arg0_18.sightTF.rect.height) / 2
			end

			local var2_18 = Vector2(arg0_18.uiMGR.hrz, arg0_18.uiMGR.vtc) * arg0_18.tempConfig.moveSpeed * (var0_18 - arg0_18.sightTimeMark) * var0_0.moveModulus

			arg0_18.sightTF.anchoredPosition = var1_0(arg0_18.sightTF.anchoredPosition + var2_18 * (arg0_18.isDown and 0.5 or 1), arg0_18.moveRect)
		end

		arg0_18:updateTimers()
	end

	arg0_18.sightTimeMark = var0_18
end

function var0_0.resetTime(arg0_19)
	arg0_19.countdown = arg0_19.tempConfig.waitCountdown

	setText(findTF(arg0_19.countdownTF, "count"), arg0_19.countdown)

	arg0_19.lastTime = arg0_19.tempConfig.baseTime

	setText(arg0_19.lastTimeTF, arg0_19.lastTime)
end

function var0_0.gameStart(arg0_20)
	arg0_20.isPlaying = true

	arg0_20:changeStartMaskUI(false)
	UpdateBeat:Add(arg0_20.update, arg0_20)
	setActive(arg0_20.countdownTF, true)

	local function var0_20(arg0_21)
		arg0_20:addTimer("start countdown", 1, function()
			arg0_20.countdown = arg0_20.countdown - 1

			setText(findTF(arg0_20.countdownTF, "count"), arg0_20.countdown)

			if arg0_20.countdown > 0 then
				arg0_21(arg0_21)
			else
				arg0_20:afterCountDown()
			end
		end)
	end

	var0_20(var0_20)
end

function var0_0.afterCountDown(arg0_23)
	arg0_23.isAfterCount = true

	arg0_23.uiMGR:AttachStickOb(arg0_23.joyStrickTF)
	setActive(arg0_23.sightTF, true)
	setActive(arg0_23.countdownTF, false)
	setAnchoredPosition(arg0_23.sightTF, Vector2.zero)
	arg0_23:setFireLink(true)

	arg0_23.score = 0

	arg0_23:flushTarget(true)

	local function var0_23(arg0_24)
		arg0_23:addTimer("gamefinish", 1, function()
			arg0_23.lastTime = arg0_23.lastTime - 1

			setText(arg0_23.lastTimeTF, arg0_23.lastTime)

			if arg0_23.lastTime > 0 then
				arg0_24(arg0_24)
			else
				arg0_23:gameFinish()
			end
		end)
	end

	var0_23(var0_23)
end

function var0_0.gameFinish(arg0_26, arg1_26)
	if arg0_26.isAfterCount then
		arg0_26:setFireLink(false)
		arg0_26.uiMGR:ClearStick()

		arg0_26.isAfterCount = false
	end

	arg0_26:clearTimers()
	UpdateBeat:Remove(arg0_26.update, arg0_26)
	setActive(arg0_26.sightTF, false)
	setActive(arg0_26.countdownTF, false)
	arg0_26:resetTime()

	arg0_26.isPlaying = false

	if not arg1_26 then
		for iter0_26 = 1, 3 do
			for iter1_26 = 1, 6 do
				if arg0_26.cell[iter0_26][iter1_26] then
					arg0_26.targetPanel:Find("line_" .. iter0_26):GetChild(iter1_26 - 1):GetChild(0):GetComponent(typeof(Animator)):Play("targetDown")
				end
			end
		end

		Timer.New(function()
			arg0_26:changeStartMaskUI(true)
		end, var0_0.animTime):Start()
		arg0_26:resultFinish()
	end
end

function var0_0.resultFinish(arg0_28)
	local var0_28 = arg0_28.tempConfig.score_level
	local var1_28 = 1

	for iter0_28 = 1, #var0_28 do
		if arg0_28.score >= var0_28[iter0_28] then
			var1_28 = iter0_28
		end
	end

	arg0_28.awardLevel = var1_28

	arg0_28:SendSuccess(arg0_28.score)
	arg0_28:showResultPanel({})
end

function var0_0.showResultPanel(arg0_29, arg1_29, arg2_29)
	local function var0_29()
		setActive(arg0_29.resultPanel, false)
		arg0_29:openCoinLayer(true)

		if arg2_29 then
			arg2_29()
		else
			arg0_29:updateCount()
		end
	end

	onButton(arg0_29, arg0_29.resultPanel:Find("bg"), var0_29)
	onButton(arg0_29, arg0_29.resultPanel:Find("main/btn_confirm"), var0_29)

	local var1_29 = arg0_29.resultPanel:Find("main")

	if arg0_29.score > arg0_29.bestScore then
		arg0_29:StoreDataToServer({
			arg0_29.score
		})
		GetImageSpriteFromAtlasAsync("ui/minigameui/shootinggameui_atlas", "new_recode", var1_29:Find("success"), true)
	else
		GetImageSpriteFromAtlasAsync("ui/minigameui/shootinggameui_atlas", "success", var1_29:Find("success"), true)
	end

	GetImageSpriteFromAtlasAsync("ui/minigameui/shootinggameui_atlas", "level_" .. arg0_29.awardLevel, var1_29:Find("success/level"), true)
	setText(var1_29:Find("right/score/number"), arg0_29.score)
	setActive(var1_29:Find("right/awards/list"), #arg1_29 > 0)
	setActive(var1_29:Find("right/awards/nothing"), #arg1_29 == 0)

	arg0_29.itemList = arg0_29.itemList or UIItemList.New(var1_29:Find("right/awards/list"), var1_29:Find("right/awards/list/item"))

	arg0_29.itemList:make(function(arg0_31, arg1_31, arg2_31)
		if arg0_31 == UIItemList.EventUpdate then
			updateDrop(arg2_31, arg1_29[arg1_31 + 1])
			setText(arg2_31:Find("number"), "x" .. arg1_29[arg1_31 + 1].count)
		end
	end)
	arg0_29.itemList:align(#arg1_29)
	setActive(arg0_29.resultPanel, true)
end

function var0_0.OnSendMiniGameOPDone(arg0_32, arg1_32)
	arg0_32:updateCount()
end

function var0_0.updateCount(arg0_33)
	setText(arg0_33.ticketTF, arg0_33:GetMGHubData().count)

	arg0_33.bestScore = getProxy(GameRoomProxy):getRoomScore(arg0_33:getGameRoomData().id)

	setText(arg0_33.bestScoreTF, arg0_33.bestScore)
end

function var0_0.initFireFunc(arg0_34)
	local var0_34 = pg.TipsMgr.GetInstance()
	local var1_34 = pg.TimeMgr.GetInstance()
	local var2_34 = arg0_34.sightTF:Find("sight_base")
	local var3_34 = arg0_34.sightTF:Find("sight_ready")

	setImageAlpha(var2_34, 1)
	setImageAlpha(var3_34, 0)

	local function var4_34()
		setActive(arg0_34.corners, true)
		LeanTween.scale(var2_34, Vector3(1.95, 1.95, 1), 0.1):setOnComplete(System.Action(function()
			LeanTween.alpha(var2_34, 0, 0.1)
			LeanTween.alpha(var3_34, 1, 0.1)
		end))
	end

	local function var5_34()
		setActive(arg0_34.corners, false)
		LeanTween.alpha(var2_34, 1, 0.1)
		LeanTween.alpha(var3_34, 0, 0.1):setOnComplete(System.Action(function()
			LeanTween.scale(var2_34, Vector3.one, 0.1)
		end))
	end

	function arg0_34._downFunc()
		var4_34()
	end

	function arg0_34._upFunc()
		LeanTween.scale(var3_34, Vector3(2, 2, 2), 0.03):setOnComplete(System.Action(function()
			LeanTween.scale(var3_34, Vector3.one, 0.07):setOnComplete(System.Action(function()
				var5_34()
			end))
		end))

		local var0_40, var1_40, var2_40 = arg0_34:checkHit()

		if var0_40 then
			local var3_40 = arg0_34.cell[var1_40][var2_40]

			arg0_34.cell[var1_40][var2_40] = nil
			arg0_34.score = arg0_34.score + arg0_34.tempConfig.targetScore[var3_40]
			arg0_34.targetCount[var3_40] = arg0_34.targetCount[var3_40] - 1
			arg0_34.lastTime = arg0_34.lastTime + arg0_34.tempConfig.bonusTime

			setText(arg0_34.lastTimeTF, arg0_34.lastTime)
			arg0_34.targetPanel:Find("line_" .. var1_40):GetChild(var2_40 - 1):GetChild(0):GetComponent(typeof(Animator)):Play("targetDown")
			arg0_34:addTimer("flush call", 0.2 + var0_0.animTime, function()
				arg0_34:flushTarget()
			end)

			if not _.any(arg0_34.targetCount, function(arg0_44)
				return arg0_44 > 0
			end) then
				arg0_34:gameFinish()
			end
		end

		arg0_34:setFireLink(false)
		arg0_34:addTimer("fire cd", arg0_34.tempConfig.fireCD, function()
			arg0_34:setFireLink(true)
		end)
	end

	function arg0_34._cancelFunc()
		var5_34()
	end

	arg0_34._emptyFunc = nil
end

function var0_0.setFireLink(arg0_47, arg1_47)
	if arg1_47 then
		setButtonEnabled(arg0_47.fireBtn, true)

		if arg0_47._downFunc ~= nil then
			arg0_47.fireBtnDelegate:AddPointDownFunc(function()
				arg0_47.isDown = true

				if arg0_47._main_cannon_sound then
					arg0_47._main_cannon_sound:Stop(true)
				end

				arg0_47._main_cannon_sound = pg.CriMgr.GetInstance():PlaySE_V3("battle-cannon-main-prepared")

				arg0_47._downFunc()
			end)
		end

		if arg0_47._upFunc ~= nil then
			arg0_47.fireBtnDelegate:AddPointUpFunc(function()
				if arg0_47.isDown then
					if arg0_47._main_cannon_sound then
						arg0_47._main_cannon_sound:Stop(true)
					end

					pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/battle/boom2")

					arg0_47.isDown = false

					arg0_47._upFunc()
				end
			end)
		end

		if arg0_47._cancelFunc ~= nil then
			arg0_47.fireBtnDelegate:AddPointExitFunc(function()
				if arg0_47.isDown then
					if arg0_47._main_cannon_sound then
						arg0_47._main_cannon_sound:Stop(true)
					end

					arg0_47.isDown = false

					arg0_47._cancelFunc()
				end
			end)
		end
	else
		if arg0_47.isDown then
			arg0_47.isDown = false

			arg0_47._cancelFunc()
		end

		setButtonEnabled(arg0_47.fireBtn, false)
		arg0_47.fireBtnDelegate:RemovePointDownFunc()
		arg0_47.fireBtnDelegate:RemovePointUpFunc()
		arg0_47.fireBtnDelegate:RemovePointExitFunc()
	end
end

function var0_0.flushTarget(arg0_51, arg1_51)
	if arg1_51 then
		arg0_51.targetCount = {
			2,
			4,
			6
		}
	end

	for iter0_51 = 1, 3 do
		for iter1_51 = 1, 6 do
			removeAllChildren(arg0_51.targetPanel:Find("line_" .. iter0_51):GetChild(iter1_51 - 1))
		end
	end

	local var0_51 = {
		0,
		0,
		0
	}

	arg0_51.cell = {
		{},
		{},
		{}
	}

	for iter2_51, iter3_51 in ipairs(arg0_51.targetCount) do
		for iter4_51 = 1, iter3_51 do
			local var1_51 = math.random(3)
			local var2_51 = math.random(6)

			while arg0_51.cell[var1_51][var2_51] or arg1_51 and var0_51[var1_51] >= 4 do
				var1_51, var2_51 = math.random(3), math.random(6)
			end

			var0_51[var1_51] = var0_51[var1_51] + 1
			arg0_51.cell[var1_51][var2_51] = iter2_51

			cloneTplTo(arg0_51.targetTpl[iter2_51], arg0_51.targetPanel:Find("line_" .. var1_51):GetChild(var2_51 - 1))
		end
	end

	setText(arg0_51.scoreTF, arg0_51.score)
end

function var0_0.checkHit(arg0_52)
	for iter0_52 = 1, 3 do
		for iter1_52 = 1, 6 do
			if arg0_52.cell[iter0_52][iter1_52] then
				local var0_52 = arg0_52.targetPanel:Find("line_" .. iter0_52):GetChild(iter1_52 - 1):GetChild(0):Find("icon/face")
				local var1_52 = arg0_52.sightTF:InverseTransformPoint(var0_52:TransformPoint(var0_52.position))

				if var1_52.x * var1_52.x + var1_52.y * var1_52.y < arg0_52.tempConfig.half * arg0_52.tempConfig.half then
					return true, iter0_52, iter1_52
				end
			end
		end
	end
end

function var0_0.willExit(arg0_53)
	return
end

return var0_0
