local var0 = class("GameRoomShootingView", import("..BaseMiniGameView"))

var0.animTime = 0.333333333333333
var0.moveModulus = 120

function var0.getUIName(arg0)
	return "GameRoomShootingUI"
end

function var0.init(arg0)
	arg0.uiMGR = pg.UIMgr.GetInstance()
	arg0.blurPanel = arg0._tf:Find("noAdaptPanel/blur_panel")
	arg0.top = arg0.blurPanel:Find("top")
	arg0.backBtn = arg0.top:Find("back")
	arg0.scoreTF = arg0.top:Find("score/Text")

	setText(arg0.scoreTF, 0)

	arg0.bestScoreTF = arg0.top:Find("score_heightest/Text")
	arg0.ticketTF = arg0.top:Find("ticket/Text")
	arg0.helpBtn = arg0.top:Find("help_btn")

	setActive(arg0.helpBtn, false)

	arg0.sightTF = arg0.blurPanel:Find("MoveArea/Sight")

	setActive(arg0.sightTF, false)

	arg0.corners = arg0.blurPanel:Find("Corners")
	arg0.shootAreaTF = arg0._tf:Find("noAdaptPanel/ShootArea")
	arg0.targetPanel = arg0.shootAreaTF:Find("target_panel")
	arg0.targetTpl = {}

	local var0 = arg0.shootAreaTF:Find("tpl")

	for iter0 = 1, var0.childCount do
		arg0.targetTpl[iter0] = var0:GetChild(iter0 - 1)
	end

	setActive(var0, false)

	arg0.startMaskTF = arg0._tf:Find("noAdaptPanel/blur_panel/start_mask")
	arg0.countdownTF = arg0._tf:Find("noAdaptPanel/blur_panel/countUI")
	arg0.lastTimeTF = arg0.shootAreaTF:Find("time_word")
	arg0.bottomTF = arg0._tf:Find("noAdaptPanel/bottom")
	arg0.joyStrickTF = arg0.bottomTF:Find("Stick")
	arg0.fireBtn = arg0.bottomTF:Find("fire/ActCtl")
	arg0.fireBtnDelegate = GetOrAddComponent(arg0.fireBtn, "EventTriggerListener")

	setActive(arg0.fireBtn:Find("block"), false)

	arg0.resultPanel = arg0._tf:Find("result_panel")

	setText(findTF(arg0.resultPanel, "main/right/score/Text"), i18n("game_room_shooting_tip"))
	setActive(arg0.resultPanel, false)
end

function var0.initData(arg0)
	arg0.tempConfig = arg0:GetMGData():getConfig("simple_config_data")
	arg0.tempConfig.waitCountdown = 3
	arg0.tempConfig.half = 56
end

function var0.addTimer(arg0, arg1, arg2, arg3)
	arg0.timerList = arg0.timerList or {}

	assert(arg0.timerList[arg1] == nil, "error Timers")
	assert(arg2 > 0, "duration must >0")

	arg0.timerList[arg1] = {
		timeMark = Time.realtimeSinceStartup + arg2,
		func = arg3
	}
end

function var0.updateTimers(arg0)
	local var0 = Time.realtimeSinceStartup

	for iter0, iter1 in pairs(arg0.timerList) do
		if var0 > iter1.timeMark then
			local var1 = iter1.func

			arg0.timerList[iter0] = nil

			var1()
		end
	end
end

function var0.stopTimers(arg0)
	arg0.isStopped = true

	local var0 = Time.realtimeSinceStartup

	for iter0, iter1 in pairs(arg0.timerList) do
		iter1.timeMark = iter1.timeMark - var0
	end
end

function var0.restartTimers(arg0)
	arg0.isStopped = false

	local var0 = Time.realtimeSinceStartup

	for iter0, iter1 in pairs(arg0.timerList) do
		iter1.timeMark = iter1.timeMark + var0
	end
end

function var0.clearTimers(arg0)
	arg0.timerList = {}
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		if arg0.isPlaying then
			arg0:stopTimers()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tips_summergame_exit"),
				onYes = function()
					arg0.lastTime = 0

					arg0:restartTimers()
					arg0:gameFinish()
				end,
				onNo = function()
					arg0:restartTimers()
				end
			})
		else
			arg0:closeView()
		end
	end)
	onButton(arg0, findTF(arg0.startMaskTF, "startGame"), function()
		if not arg0.isPlaying then
			arg0:openCoinLayer(false)
			arg0:gameStart()
		end
	end)

	if arg0:getGameRoomData() then
		arg0.gameHelpTip = arg0:getGameRoomData().game_help
	end

	onButton(arg0, findTF(arg0.startMaskTF, "ruleGame"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0.gameHelpTip
		})
	end)
	arg0:initData()
	arg0:updateCount()
	arg0:resetTime()
	arg0:initFireFunc()
	arg0:setFireLink(false)
	arg0:changeStartMaskUI(true)
end

function var0.changeStartMaskUI(arg0, arg1)
	setActive(arg0.bottomTF, not arg1)
	setActive(arg0.startMaskTF, arg1)
end

function var0.onBackPressed(arg0)
	triggerButton(arg0.backBtn)
end

local function var1(arg0, arg1)
	return Vector2(math.clamp(arg0.x, -arg1.x, arg1.x), math.clamp(arg0.y, -arg1.y, arg1.y))
end

function var0.update(arg0)
	local var0 = Time.GetTimestamp()

	if not arg0.isStopped then
		if arg0.isAfterCount and arg0.sightTimeMark then
			if not arg0.moveRect then
				local var1 = tf(arg0.sightTF.parent)

				arg0.moveRect = Vector2(var1.rect.width - arg0.sightTF.rect.width, var1.rect.height - arg0.sightTF.rect.height) / 2
			end

			local var2 = Vector2(arg0.uiMGR.hrz, arg0.uiMGR.vtc) * arg0.tempConfig.moveSpeed * (var0 - arg0.sightTimeMark) * var0.moveModulus

			arg0.sightTF.anchoredPosition = var1(arg0.sightTF.anchoredPosition + var2 * (arg0.isDown and 0.5 or 1), arg0.moveRect)
		end

		arg0:updateTimers()
	end

	arg0.sightTimeMark = var0
end

function var0.resetTime(arg0)
	arg0.countdown = arg0.tempConfig.waitCountdown

	setText(findTF(arg0.countdownTF, "count"), arg0.countdown)

	arg0.lastTime = arg0.tempConfig.baseTime

	setText(arg0.lastTimeTF, arg0.lastTime)
end

function var0.gameStart(arg0)
	arg0.isPlaying = true

	arg0:changeStartMaskUI(false)
	UpdateBeat:Add(arg0.update, arg0)
	setActive(arg0.countdownTF, true)

	local function var0(arg0)
		arg0:addTimer("start countdown", 1, function()
			arg0.countdown = arg0.countdown - 1

			setText(findTF(arg0.countdownTF, "count"), arg0.countdown)

			if arg0.countdown > 0 then
				arg0(arg0)
			else
				arg0:afterCountDown()
			end
		end)
	end

	var0(var0)
end

function var0.afterCountDown(arg0)
	arg0.isAfterCount = true

	arg0.uiMGR:AttachStickOb(arg0.joyStrickTF)
	setActive(arg0.sightTF, true)
	setActive(arg0.countdownTF, false)
	setAnchoredPosition(arg0.sightTF, Vector2.zero)
	arg0:setFireLink(true)

	arg0.score = 0

	arg0:flushTarget(true)

	local function var0(arg0)
		arg0:addTimer("gamefinish", 1, function()
			arg0.lastTime = arg0.lastTime - 1

			setText(arg0.lastTimeTF, arg0.lastTime)

			if arg0.lastTime > 0 then
				arg0(arg0)
			else
				arg0:gameFinish()
			end
		end)
	end

	var0(var0)
end

function var0.gameFinish(arg0, arg1)
	if arg0.isAfterCount then
		arg0:setFireLink(false)
		arg0.uiMGR:ClearStick()

		arg0.isAfterCount = false
	end

	arg0:clearTimers()
	UpdateBeat:Remove(arg0.update, arg0)
	setActive(arg0.sightTF, false)
	setActive(arg0.countdownTF, false)
	arg0:resetTime()

	arg0.isPlaying = false

	if not arg1 then
		for iter0 = 1, 3 do
			for iter1 = 1, 6 do
				if arg0.cell[iter0][iter1] then
					arg0.targetPanel:Find("line_" .. iter0):GetChild(iter1 - 1):GetChild(0):GetComponent(typeof(Animator)):Play("targetDown")
				end
			end
		end

		Timer.New(function()
			arg0:changeStartMaskUI(true)
		end, var0.animTime):Start()
		arg0:resultFinish()
	end
end

function var0.resultFinish(arg0)
	local var0 = arg0.tempConfig.score_level
	local var1 = 1

	for iter0 = 1, #var0 do
		if arg0.score >= var0[iter0] then
			var1 = iter0
		end
	end

	arg0.awardLevel = var1

	arg0:SendSuccess(arg0.score)
	arg0:showResultPanel({})
end

function var0.showResultPanel(arg0, arg1, arg2)
	local function var0()
		setActive(arg0.resultPanel, false)
		arg0:openCoinLayer(true)

		if arg2 then
			arg2()
		else
			arg0:updateCount()
		end
	end

	onButton(arg0, arg0.resultPanel:Find("bg"), var0)
	onButton(arg0, arg0.resultPanel:Find("main/btn_confirm"), var0)

	local var1 = arg0.resultPanel:Find("main")

	if arg0.score > arg0.bestScore then
		arg0:StoreDataToServer({
			arg0.score
		})
		GetImageSpriteFromAtlasAsync("ui/minigameui/shootinggameui_atlas", "new_recode", var1:Find("success"), true)
	else
		GetImageSpriteFromAtlasAsync("ui/minigameui/shootinggameui_atlas", "success", var1:Find("success"), true)
	end

	GetImageSpriteFromAtlasAsync("ui/minigameui/shootinggameui_atlas", "level_" .. arg0.awardLevel, var1:Find("success/level"), true)
	setText(var1:Find("right/score/number"), arg0.score)
	setActive(var1:Find("right/awards/list"), #arg1 > 0)
	setActive(var1:Find("right/awards/nothing"), #arg1 == 0)

	arg0.itemList = arg0.itemList or UIItemList.New(var1:Find("right/awards/list"), var1:Find("right/awards/list/item"))

	arg0.itemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			updateDrop(arg2, arg1[arg1 + 1])
			setText(arg2:Find("number"), "x" .. arg1[arg1 + 1].count)
		end
	end)
	arg0.itemList:align(#arg1)
	setActive(arg0.resultPanel, true)
end

function var0.OnSendMiniGameOPDone(arg0, arg1)
	arg0:updateCount()
end

function var0.updateCount(arg0)
	setText(arg0.ticketTF, arg0:GetMGHubData().count)

	arg0.bestScore = checkExist(arg0:GetMGData():GetRuntimeData("elements"), {
		1
	}) or 0

	setText(arg0.bestScoreTF, arg0.bestScore)
end

function var0.initFireFunc(arg0)
	local var0 = pg.TipsMgr.GetInstance()
	local var1 = pg.TimeMgr.GetInstance()
	local var2 = arg0.sightTF:Find("sight_base")
	local var3 = arg0.sightTF:Find("sight_ready")

	setImageAlpha(var2, 1)
	setImageAlpha(var3, 0)

	local function var4()
		setActive(arg0.corners, true)
		LeanTween.scale(var2, Vector3(1.95, 1.95, 1), 0.1):setOnComplete(System.Action(function()
			LeanTween.alpha(var2, 0, 0.1)
			LeanTween.alpha(var3, 1, 0.1)
		end))
	end

	local function var5()
		setActive(arg0.corners, false)
		LeanTween.alpha(var2, 1, 0.1)
		LeanTween.alpha(var3, 0, 0.1):setOnComplete(System.Action(function()
			LeanTween.scale(var2, Vector3.one, 0.1)
		end))
	end

	function arg0._downFunc()
		var4()
	end

	function arg0._upFunc()
		LeanTween.scale(var3, Vector3(2, 2, 2), 0.03):setOnComplete(System.Action(function()
			LeanTween.scale(var3, Vector3.one, 0.07):setOnComplete(System.Action(function()
				var5()
			end))
		end))

		local var0, var1, var2 = arg0:checkHit()

		if var0 then
			local var3 = arg0.cell[var1][var2]

			arg0.cell[var1][var2] = nil
			arg0.score = arg0.score + arg0.tempConfig.targetScore[var3]
			arg0.targetCount[var3] = arg0.targetCount[var3] - 1
			arg0.lastTime = arg0.lastTime + arg0.tempConfig.bonusTime

			setText(arg0.lastTimeTF, arg0.lastTime)
			arg0.targetPanel:Find("line_" .. var1):GetChild(var2 - 1):GetChild(0):GetComponent(typeof(Animator)):Play("targetDown")
			arg0:addTimer("flush call", 0.2 + var0.animTime, function()
				arg0:flushTarget()
			end)

			if not _.any(arg0.targetCount, function(arg0)
				return arg0 > 0
			end) then
				arg0:gameFinish()
			end
		end

		arg0:setFireLink(false)
		arg0:addTimer("fire cd", arg0.tempConfig.fireCD, function()
			arg0:setFireLink(true)
		end)
	end

	function arg0._cancelFunc()
		var5()
	end

	arg0._emptyFunc = nil
end

function var0.setFireLink(arg0, arg1)
	if arg1 then
		setButtonEnabled(arg0.fireBtn, true)

		if arg0._downFunc ~= nil then
			arg0.fireBtnDelegate:AddPointDownFunc(function()
				arg0.isDown = true

				if arg0._main_cannon_sound then
					arg0._main_cannon_sound:Stop(true)
				end

				arg0._main_cannon_sound = pg.CriMgr.GetInstance():PlaySE_V3("battle-cannon-main-prepared")

				arg0._downFunc()
			end)
		end

		if arg0._upFunc ~= nil then
			arg0.fireBtnDelegate:AddPointUpFunc(function()
				if arg0.isDown then
					if arg0._main_cannon_sound then
						arg0._main_cannon_sound:Stop(true)
					end

					pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/battle/boom2")

					arg0.isDown = false

					arg0._upFunc()
				end
			end)
		end

		if arg0._cancelFunc ~= nil then
			arg0.fireBtnDelegate:AddPointExitFunc(function()
				if arg0.isDown then
					if arg0._main_cannon_sound then
						arg0._main_cannon_sound:Stop(true)
					end

					arg0.isDown = false

					arg0._cancelFunc()
				end
			end)
		end
	else
		if arg0.isDown then
			arg0.isDown = false

			arg0._cancelFunc()
		end

		setButtonEnabled(arg0.fireBtn, false)
		arg0.fireBtnDelegate:RemovePointDownFunc()
		arg0.fireBtnDelegate:RemovePointUpFunc()
		arg0.fireBtnDelegate:RemovePointExitFunc()
	end
end

function var0.flushTarget(arg0, arg1)
	if arg1 then
		arg0.targetCount = {
			2,
			4,
			6
		}
	end

	for iter0 = 1, 3 do
		for iter1 = 1, 6 do
			removeAllChildren(arg0.targetPanel:Find("line_" .. iter0):GetChild(iter1 - 1))
		end
	end

	local var0 = {
		0,
		0,
		0
	}

	arg0.cell = {
		{},
		{},
		{}
	}

	for iter2, iter3 in ipairs(arg0.targetCount) do
		for iter4 = 1, iter3 do
			local var1 = math.random(3)
			local var2 = math.random(6)

			while arg0.cell[var1][var2] or arg1 and var0[var1] >= 4 do
				var1, var2 = math.random(3), math.random(6)
			end

			var0[var1] = var0[var1] + 1
			arg0.cell[var1][var2] = iter2

			cloneTplTo(arg0.targetTpl[iter2], arg0.targetPanel:Find("line_" .. var1):GetChild(var2 - 1))
		end
	end

	setText(arg0.scoreTF, arg0.score)
end

function var0.checkHit(arg0)
	for iter0 = 1, 3 do
		for iter1 = 1, 6 do
			if arg0.cell[iter0][iter1] then
				local var0 = arg0.targetPanel:Find("line_" .. iter0):GetChild(iter1 - 1):GetChild(0):Find("icon/face")
				local var1 = arg0.sightTF:InverseTransformPoint(var0:TransformPoint(var0.position))

				if var1.x * var1.x + var1.y * var1.y < arg0.tempConfig.half * arg0.tempConfig.half then
					return true, iter0, iter1
				end
			end
		end
	end
end

function var0.willExit(arg0)
	return
end

return var0
