local var0_0 = class("ShootingGameView", import("..BaseMiniGameView"))

var0_0.animTime = 0.333333333333333
var0_0.moveModulus = 120

function var0_0.getUIName(arg0_1)
	return "ShootingGameUI"
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

	arg0_2.startMaskTF = arg0_2.shootAreaTF:Find("start_mask")
	arg0_2.countdownTF = arg0_2.startMaskTF:Find("count")
	arg0_2.lastTimeTF = arg0_2.shootAreaTF:Find("time_word")
	arg0_2.bottomTF = arg0_2._tf:Find("noAdaptPanel/bottom")
	arg0_2.joyStrickTF = arg0_2.bottomTF:Find("Stick")
	arg0_2.fireBtn = arg0_2.bottomTF:Find("fire/ActCtl")
	arg0_2.fireBtnDelegate = GetOrAddComponent(arg0_2.fireBtn, "EventTriggerListener")

	setActive(arg0_2.fireBtn:Find("block"), false)

	arg0_2.resultPanel = arg0_2._tf:Find("result_panel")

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
					arg0_9:gameFinish(true)
					arg0_9:closeView()
				end,
				onNo = function()
					arg0_9:restartTimers()
				end
			})
		else
			arg0_9:closeView()
		end
	end)
	onButton(arg0_9, arg0_9.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_summer_shooting.tip
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.startMaskTF, function()
		if not arg0_9.isPlaying then
			arg0_9:gameStart()
		end
	end)
	arg0_9:initData()
	arg0_9:updateCount()
	arg0_9:resetTime()
	arg0_9:initFireFunc()
	arg0_9:setFireLink(false)
	setActive(arg0_9.startMaskTF, true)
end

function var0_0.onBackPressed(arg0_15)
	triggerButton(arg0_15.backBtn)
end

local function var1_0(arg0_16, arg1_16)
	return Vector2(math.clamp(arg0_16.x, -arg1_16.x, arg1_16.x), math.clamp(arg0_16.y, -arg1_16.y, arg1_16.y))
end

function var0_0.update(arg0_17)
	local var0_17 = Time.GetTimestamp()

	if not arg0_17.isStopped then
		if arg0_17.isAfterCount and arg0_17.sightTimeMark then
			if not arg0_17.moveRect then
				local var1_17 = tf(arg0_17.sightTF.parent)

				arg0_17.moveRect = Vector2(var1_17.rect.width - arg0_17.sightTF.rect.width, var1_17.rect.height - arg0_17.sightTF.rect.height) / 2
			end

			local var2_17 = Vector2(arg0_17.uiMGR.hrz, arg0_17.uiMGR.vtc) * arg0_17.tempConfig.moveSpeed * (var0_17 - arg0_17.sightTimeMark) * var0_0.moveModulus

			arg0_17.sightTF.anchoredPosition = var1_0(arg0_17.sightTF.anchoredPosition + var2_17 * (arg0_17.isDown and 0.5 or 1), arg0_17.moveRect)
		end

		arg0_17:updateTimers()
	end

	arg0_17.sightTimeMark = var0_17
end

function var0_0.resetTime(arg0_18)
	arg0_18.countdown = arg0_18.tempConfig.waitCountdown

	setText(arg0_18.countdownTF, arg0_18.countdown)

	arg0_18.lastTime = arg0_18.tempConfig.baseTime

	setText(arg0_18.lastTimeTF, arg0_18.lastTime)
end

function var0_0.gameStart(arg0_19)
	arg0_19.isPlaying = true

	UpdateBeat:Add(arg0_19.update, arg0_19)
	setActive(arg0_19.countdownTF, true)
	setActive(arg0_19.startMaskTF:Find("word"), false)

	local function var0_19(arg0_20)
		arg0_19:addTimer("start countdown", 1, function()
			arg0_19.countdown = arg0_19.countdown - 1

			setText(arg0_19.countdownTF, arg0_19.countdown)

			if arg0_19.countdown > 0 then
				arg0_20(arg0_20)
			else
				arg0_19:afterCountDown()
			end
		end)
	end

	var0_19(var0_19)
end

function var0_0.afterCountDown(arg0_22)
	arg0_22.isAfterCount = true

	arg0_22.uiMGR:AttachStickOb(arg0_22.joyStrickTF)
	setActive(arg0_22.sightTF, true)
	setAnchoredPosition(arg0_22.sightTF, Vector2.zero)
	arg0_22:setFireLink(true)
	setActive(arg0_22.startMaskTF, false)

	arg0_22.score = 0

	arg0_22:flushTarget(true)

	local function var0_22(arg0_23)
		arg0_22:addTimer("gamefinish", 1, function()
			arg0_22.lastTime = arg0_22.lastTime - 1

			setText(arg0_22.lastTimeTF, arg0_22.lastTime)

			if arg0_22.lastTime > 0 then
				arg0_23(arg0_23)
			else
				arg0_22:gameFinish()
			end
		end)
	end

	var0_22(var0_22)
end

function var0_0.gameFinish(arg0_25, arg1_25)
	if arg0_25.isAfterCount then
		arg0_25:setFireLink(false)
		arg0_25.uiMGR:ClearStick()

		arg0_25.isAfterCount = false
	end

	arg0_25:clearTimers()
	UpdateBeat:Remove(arg0_25.update, arg0_25)
	setActive(arg0_25.sightTF, false)
	setActive(arg0_25.countdownTF, false)
	arg0_25:resetTime()

	arg0_25.isPlaying = false

	if not arg1_25 then
		for iter0_25 = 1, 3 do
			for iter1_25 = 1, 6 do
				if arg0_25.cell[iter0_25][iter1_25] then
					arg0_25.targetPanel:Find("line_" .. iter0_25):GetChild(iter1_25 - 1):GetChild(0):GetComponent(typeof(Animator)):Play("targetDown")
				end
			end
		end

		Timer.New(function()
			setActive(arg0_25.startMaskTF, true)
			setActive(arg0_25.startMaskTF:Find("word"), true)
		end, var0_0.animTime):Start()
		arg0_25:resultFinish()
	end
end

function var0_0.resultFinish(arg0_27)
	local var0_27 = arg0_27.tempConfig.score_level
	local var1_27

	for iter0_27 = 1, #var0_27 do
		if arg0_27.score >= var0_27[#var0_27 - iter0_27 + 1] then
			var1_27 = iter0_27

			break
		end
	end

	arg0_27.awardLevel = var1_27

	if arg0_27:GetMGHubData().count > 0 then
		arg0_27:SendSuccess(var1_27)
	else
		arg0_27:showResultPanel({})
	end
end

function var0_0.showResultPanel(arg0_28, arg1_28, arg2_28)
	local function var0_28()
		setActive(arg0_28.resultPanel, false)

		if arg2_28 then
			arg2_28()
		else
			arg0_28:updateCount()
		end
	end

	onButton(arg0_28, arg0_28.resultPanel:Find("bg"), var0_28)
	onButton(arg0_28, arg0_28.resultPanel:Find("main/btn_confirm"), var0_28)

	local var1_28 = arg0_28.resultPanel:Find("main")

	if arg0_28.score > arg0_28.bestScore then
		arg0_28:StoreDataToServer({
			arg0_28.score
		})
		GetImageSpriteFromAtlasAsync("ui/minigameui/shootinggameui_atlas", "new_recode", var1_28:Find("success"), true)
	else
		GetImageSpriteFromAtlasAsync("ui/minigameui/shootinggameui_atlas", "success", var1_28:Find("success"), true)
	end

	GetImageSpriteFromAtlasAsync("ui/minigameui/shootinggameui_atlas", "level_" .. #arg0_28.tempConfig.score_level - arg0_28.awardLevel + 1, var1_28:Find("success/level"), true)
	setText(var1_28:Find("right/score/number"), arg0_28.score)
	setActive(var1_28:Find("right/awards/list"), #arg1_28 > 0)
	setActive(var1_28:Find("right/awards/nothing"), #arg1_28 == 0)

	arg0_28.itemList = arg0_28.itemList or UIItemList.New(var1_28:Find("right/awards/list"), var1_28:Find("right/awards/list/item"))

	arg0_28.itemList:make(function(arg0_30, arg1_30, arg2_30)
		if arg0_30 == UIItemList.EventUpdate then
			updateDrop(arg2_30, arg1_28[arg1_30 + 1])
			setText(arg2_30:Find("number"), "x" .. arg1_28[arg1_30 + 1].count)
		end
	end)
	arg0_28.itemList:align(#arg1_28)
	setActive(arg0_28.resultPanel, true)
end

function var0_0.updateAfterFinish(arg0_31)
	local var0_31 = (getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.ShrineGameID):GetRuntimeData("count") or 0) + 1

	pg.m02:sendNotification(GAME.MODIFY_MINI_GAME_DATA, {
		id = MiniGameDataCreator.ShrineGameID,
		map = {
			count = var0_31
		}
	})
end

function var0_0.OnGetAwardDone(arg0_32, arg1_32)
	if arg1_32.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var0_32 = arg0_32:GetMGHubData()

		if var0_32.ultimate == 0 and var0_32.usedtime >= var0_32:getConfig("reward_need") then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var0_32.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	elseif arg1_32.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI2")
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_33, arg1_33)
	arg0_33:updateCount()
end

function var0_0.updateCount(arg0_34)
	setText(arg0_34.ticketTF, arg0_34:GetMGHubData().count)

	arg0_34.bestScore = checkExist(arg0_34:GetMGData():GetRuntimeData("elements"), {
		1
	}) or 0

	setText(arg0_34.bestScoreTF, arg0_34.bestScore)
end

function var0_0.initFireFunc(arg0_35)
	local var0_35 = pg.TipsMgr.GetInstance()
	local var1_35 = pg.TimeMgr.GetInstance()
	local var2_35 = arg0_35.sightTF:Find("sight_base")
	local var3_35 = arg0_35.sightTF:Find("sight_ready")

	setImageAlpha(var2_35, 1)
	setImageAlpha(var3_35, 0)

	local function var4_35()
		setActive(arg0_35.corners, true)
		LeanTween.scale(var2_35, Vector3(1.95, 1.95, 1), 0.1):setOnComplete(System.Action(function()
			LeanTween.alpha(var2_35, 0, 0.1)
			LeanTween.alpha(var3_35, 1, 0.1)
		end))
	end

	local function var5_35()
		setActive(arg0_35.corners, false)
		LeanTween.alpha(var2_35, 1, 0.1)
		LeanTween.alpha(var3_35, 0, 0.1):setOnComplete(System.Action(function()
			LeanTween.scale(var2_35, Vector3.one, 0.1)
		end))
	end

	function arg0_35._downFunc()
		var4_35()
	end

	function arg0_35._upFunc()
		LeanTween.scale(var3_35, Vector3(2, 2, 2), 0.03):setOnComplete(System.Action(function()
			LeanTween.scale(var3_35, Vector3.one, 0.07):setOnComplete(System.Action(function()
				var5_35()
			end))
		end))

		local var0_41, var1_41, var2_41 = arg0_35:checkHit()

		if var0_41 then
			local var3_41 = arg0_35.cell[var1_41][var2_41]

			arg0_35.cell[var1_41][var2_41] = nil
			arg0_35.score = arg0_35.score + arg0_35.tempConfig.targetScore[var3_41]
			arg0_35.targetCount[var3_41] = arg0_35.targetCount[var3_41] - 1
			arg0_35.lastTime = arg0_35.lastTime + arg0_35.tempConfig.bonusTime

			setText(arg0_35.lastTimeTF, arg0_35.lastTime)
			arg0_35.targetPanel:Find("line_" .. var1_41):GetChild(var2_41 - 1):GetChild(0):GetComponent(typeof(Animator)):Play("targetDown")
			arg0_35:addTimer("flush call", 0.2 + var0_0.animTime, function()
				arg0_35:flushTarget()
			end)

			if not _.any(arg0_35.targetCount, function(arg0_45)
				return arg0_45 > 0
			end) then
				arg0_35:gameFinish()
			end
		end

		arg0_35:setFireLink(false)
		arg0_35:addTimer("fire cd", arg0_35.tempConfig.fireCD, function()
			arg0_35:setFireLink(true)
		end)
	end

	function arg0_35._cancelFunc()
		var5_35()
	end

	arg0_35._emptyFunc = nil
end

function var0_0.setFireLink(arg0_48, arg1_48)
	if arg1_48 then
		setButtonEnabled(arg0_48.fireBtn, true)

		if arg0_48._downFunc ~= nil then
			arg0_48.fireBtnDelegate:AddPointDownFunc(function()
				arg0_48.isDown = true

				if arg0_48._main_cannon_sound then
					arg0_48._main_cannon_sound:Stop(true)
				end

				arg0_48._main_cannon_sound = pg.CriMgr.GetInstance():PlaySE_V3("battle-cannon-main-prepared")

				arg0_48._downFunc()
			end)
		end

		if arg0_48._upFunc ~= nil then
			arg0_48.fireBtnDelegate:AddPointUpFunc(function()
				if arg0_48.isDown then
					if arg0_48._main_cannon_sound then
						arg0_48._main_cannon_sound:Stop(true)
					end

					pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/battle/boom2")

					arg0_48.isDown = false

					arg0_48._upFunc()
				end
			end)
		end

		if arg0_48._cancelFunc ~= nil then
			arg0_48.fireBtnDelegate:AddPointExitFunc(function()
				if arg0_48.isDown then
					if arg0_48._main_cannon_sound then
						arg0_48._main_cannon_sound:Stop(true)
					end

					arg0_48.isDown = false

					arg0_48._cancelFunc()
				end
			end)
		end
	else
		if arg0_48.isDown then
			arg0_48.isDown = false

			arg0_48._cancelFunc()
		end

		setButtonEnabled(arg0_48.fireBtn, false)
		arg0_48.fireBtnDelegate:RemovePointDownFunc()
		arg0_48.fireBtnDelegate:RemovePointUpFunc()
		arg0_48.fireBtnDelegate:RemovePointExitFunc()
	end
end

function var0_0.flushTarget(arg0_52, arg1_52)
	if arg1_52 then
		arg0_52.targetCount = {
			2,
			4,
			6
		}
	end

	for iter0_52 = 1, 3 do
		for iter1_52 = 1, 6 do
			removeAllChildren(arg0_52.targetPanel:Find("line_" .. iter0_52):GetChild(iter1_52 - 1))
		end
	end

	local var0_52 = {
		0,
		0,
		0
	}

	arg0_52.cell = {
		{},
		{},
		{}
	}

	for iter2_52, iter3_52 in ipairs(arg0_52.targetCount) do
		for iter4_52 = 1, iter3_52 do
			local var1_52 = math.random(3)
			local var2_52 = math.random(6)

			while arg0_52.cell[var1_52][var2_52] or arg1_52 and var0_52[var1_52] >= 4 do
				var1_52, var2_52 = math.random(3), math.random(6)
			end

			var0_52[var1_52] = var0_52[var1_52] + 1
			arg0_52.cell[var1_52][var2_52] = iter2_52

			cloneTplTo(arg0_52.targetTpl[iter2_52], arg0_52.targetPanel:Find("line_" .. var1_52):GetChild(var2_52 - 1))
		end
	end

	setText(arg0_52.scoreTF, arg0_52.score)
end

function var0_0.checkHit(arg0_53)
	for iter0_53 = 1, 3 do
		for iter1_53 = 1, 6 do
			if arg0_53.cell[iter0_53][iter1_53] then
				local var0_53 = arg0_53.targetPanel:Find("line_" .. iter0_53):GetChild(iter1_53 - 1):GetChild(0):Find("icon/face")
				local var1_53 = arg0_53.sightTF:InverseTransformPoint(var0_53:TransformPoint(var0_53.position))

				if var1_53.x * var1_53.x + var1_53.y * var1_53.y < arg0_53.tempConfig.half * arg0_53.tempConfig.half then
					return true, iter0_53, iter1_53
				end
			end
		end
	end
end

function var0_0.willExit(arg0_54)
	return
end

return var0_0
