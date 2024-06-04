local var0 = class("LimitChallengeScene", import("..base.BaseUI"))
local var1 = LimitChallengeConst

function var0.getUIName(arg0)
	return "LimitChallengeUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	var1.SetRedPointMonth()
	arg0:updateLeftTime()
	arg0:updateToggleList()
	arg0:trigeHigestUnlockLevel()
end

function var0.onBackPressed(arg0)
	arg0:closeView()
end

function var0.willExit(arg0)
	if arg0.leftTimer then
		arg0.leftTimer:Stop()

		arg0.leftTimer = nil
	end
end

function var0.initData(arg0)
	arg0.proxy = getProxy(LimitChallengeProxy)
	arg0.levelList = {
		1,
		2,
		3
	}
	arg0.curMonth = var1.GetCurMonth()
	arg0.descList = {}
	arg0.nextMonthTS = LimitChallengeConst.GetNextMonthTS()
	arg0.curLevel = 0
end

function var0.findUI(arg0)
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.homeBtn = arg0:findTF("adapt/top/option", arg0.blurPanel)
	arg0.backBtn = arg0:findTF("adapt/top/back_button", arg0.blurPanel)
	arg0.helpBtn = arg0:findTF("adapt/top/HelpBtn", arg0.blurPanel)
	arg0.shareBtn = arg0:findTF("adapt/top/ShareBtn", arg0.blurPanel)
	arg0.levelPanel = arg0:findTF("Adapt/LevelPanel")
	arg0.levelToggleList = {}
	arg0.levelToggleLockList = {}

	for iter0, iter1 in ipairs(arg0.levelList) do
		local var0 = "Level_" .. iter1
		local var1 = arg0:findTF(var0, arg0.levelPanel)
		local var2 = arg0:findTF("Toggle", var1)
		local var3 = arg0:findTF("Lock", var1)

		arg0.levelToggleList[iter1] = var2
		arg0.levelToggleLockList[iter1] = var3
	end

	arg0.timePanel = arg0:findTF("Adapt/TimePanel")

	local var4 = arg0:findTF("Left/LeftTime", arg0.timePanel)

	arg0.leftTipText = arg0:findTF("LeftTip", var4)
	arg0.leftDayTipText = arg0:findTF("DayTip", var4)
	arg0.leftDayValueText = arg0:findTF("DayValue", var4)
	arg0.leftTimeValueText = arg0:findTF("TimeValue", var4)
	arg0.passTimeValueText = arg0:findTF("Challenge/Value", arg0.timePanel)

	setText(arg0.leftTipText, i18n("time_remaining_tip"))
	setText(arg0.leftDayTipText, i18n("word_date"))

	arg0.iconContainer = arg0:findTF("Adapt/DescPanel/ScrollView/Viewport/Container")
	arg0.iconTpl = arg0:findTF("Adapt/DescPanel/IconTpl")

	local var5 = arg0:findTF("Adapt/Award")

	arg0.awardIconTF = arg0:findTF("IconTpl", var5)
	arg0.awardGotTF = arg0:findTF("Got", var5)
	arg0.startBtn = arg0:findTF("Adapt/StartBtn")
	arg0.bgImg = arg0:findTF("BG")
	arg0.nameImg = arg0:findTF("Left", arg0.timePanel)
	arg0.debugPanel = arg0:findTF("Adapt/Debug")
	arg0.debugText = arg0:findTF("Text", arg0.debugPanel)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.homeBtn, function()
		arg0:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	print("-----------", tostring(arg0.backBtn))
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.challenge_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeChallenge)
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.levelToggleList) do
		onToggle(arg0, iter1, function()
			arg0.curLevel = iter0

			arg0:updatePassTime()
			arg0:updateAward()
			arg0:updateDescPanel()
			arg0:updateBossImg()
			arg0:updateDebug()
		end, SFX_CONFIRM, SFX_CANCEL)
	end

	onButton(arg0, arg0.startBtn, function()
		local var0 = var1.GetStageIDByLevel(arg0.curLevel)

		arg0:emit(var1.OPEN_PRE_COMBAT_LAYER, {
			stageID = var0
		})
	end, SFX_PANEL)

	arg0.iconUIItemList = UIItemList.New(arg0.iconContainer, arg0.iconTpl)

	arg0.iconUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("Icon", arg2)

			arg1 = arg1 + 1

			if arg0.descList[arg1] ~= false then
				local var1 = var1.GetChallengeIDByLevel(arg0.curLevel)
				local var2, var3 = arg0:getBuffIconPath(var1, arg1)

				setImageSprite(var0, LoadSprite(var2, var3))

				local var4 = arg0.descList[arg1][1]
				local var5 = arg0.descList[arg1][2]
				local var6 = {}

				table.insert(var6, {
					info = var4
				})
				table.insert(var6, {
					info = var5
				})
				onButton(arg0, var0, function()
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						hideNo = true,
						type = MSGBOX_TYPE_DROP_ITEM,
						name = var4,
						content = var5,
						iconPath = {
							var2,
							var3
						}
					})
				end, SFX_PANEL)
			end
		end
	end)
end

function var0.updateDebug(arg0)
	local var0 = arg0.curMonth
	local var1 = arg0.curLevel
	local var2 = var1.GetChallengeIDByLevel(arg0.curLevel)
	local var3 = var1.GetStageIDByLevel(arg0.curLevel)
	local var4 = string.format(" 月份: %s \n 选择难度: %s \n 选择挑战ID: %s \n 选择关卡ID: %s \n", tostring(var0), tostring(var1), tostring(var2), tostring(var3))

	for iter0, iter1 in ipairs(arg0.levelList) do
		local var5 = LimitChallengeConst.GetChallengeIDByLevel(iter1)
		local var6 = arg0.proxy:isAwardedByChallengeID(var5)
		local var7 = " 难度" .. iter1 .. "奖励:" .. (var6 and "已领取" or "未领取") .. "\n"

		var4 = var4 .. var7
	end

	for iter2, iter3 in ipairs(arg0.levelList) do
		local var8 = LimitChallengeConst.GetChallengeIDByLevel(iter3)
		local var9 = arg0.proxy:getPassTimeByChallengeID(var8)
		local var10 = " 难度" .. iter3 .. "时间:" .. (var9 and var9 or "没有记录") .. "\n"

		var4 = var4 .. var10
	end

	setText(arg0.debugText, var4)
end

function var0.updateToggleList(arg0)
	local var0 = arg0:getHigestUnlockLevel()

	for iter0, iter1 in ipairs(arg0.levelToggleLockList) do
		local var1 = var0 < iter0

		setActive(iter1, var1)

		local var2 = arg0.levelToggleList[iter0]

		setActive(var2, not var1)
	end
end

function var0.updateLeftTime(arg0)
	if arg0.leftTimer then
		arg0.leftTimer:Stop()

		arg0.leftTimer = nil
	end

	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = arg0.nextMonthTS - var0

	if var1 > 0 then
		if arg0.leftTimer then
			arg0.leftTimer:Stop()

			arg0.leftTimer = nil
		end

		local function var2()
			if var1 <= 0 and arg0.leftTimer then
				arg0.leftTimer:Stop()

				arg0.leftTimer = nil
			end

			local var0, var1, var2, var3 = pg.TimeMgr.GetInstance():parseTimeFrom(var1)

			setText(arg0.leftDayValueText, var0)
			setText(arg0.leftTimeValueText, string.format("%02d:%02d:%02d", var1, var2, var3))

			var1 = var1 - 1
		end

		arg0.leftTimer = Timer.New(var2, 1, -1)

		arg0.leftTimer:Start()
		var2()
	end
end

function var0.updateBossImg(arg0)
	local var0 = var1.GetChallengeIDByLevel(arg0.curLevel)
	local var1 = pg.expedition_constellation_challenge_template[var0]
	local var2 = var1.painting
	local var3 = var1.information_icon
	local var4 = "limitchallenge/boss/" .. var2

	setImageSprite(arg0.bgImg, LoadSprite(var4, var2))

	local var5 = "limitchallenge/name/" .. var3

	setImageSprite(arg0.nameImg, LoadSprite(var5, var3), true)

	local var6 = var1.button_style .. "_btn_start"
	local var7 = "limitchallenge/btn/" .. var6

	setImageSprite(arg0.startBtn, LoadSprite(var7, var6), true)

	local var8 = "%d_level_%d_selected"

	for iter0, iter1 in ipairs(arg0.levelList) do
		local var9 = string.format(var8, var1.button_style, iter1)
		local var10 = "limitchallenge/btn/" .. var9
		local var11 = arg0:findTF("Selected", arg0.levelToggleList[iter1])

		setImageSprite(var11, LoadSprite(var10, var9), true)
	end
end

function var0.updateDescPanel(arg0)
	arg0.descList = {}

	local var0 = var1.GetChallengeIDByLevel(arg0.curLevel)

	arg0.descList = pg.expedition_constellation_challenge_template[var0].description

	local var1 = 3 - #arg0.descList

	if var1 > 0 then
		for iter0 = 1, var1 do
			table.insert(arg0.descList, false)
		end
	end

	arg0.iconUIItemList:align(#arg0.descList)
end

function var0.updatePassTime(arg0)
	local var0 = LimitChallengeConst.GetChallengeIDByLevel(arg0.curLevel)
	local var1 = arg0.proxy:getPassTimeByChallengeID(var0) or 0
	local var2 = math.floor(var1 / 60)
	local var3 = math.floor(var1 % 60)
	local var4 = string.format("%02d:%02d", var2, var3)

	setText(arg0.passTimeValueText, var4)
end

function var0.updateAward(arg0)
	local var0 = LimitChallengeConst.GetChallengeIDByLevel(arg0.curLevel)
	local var1 = pg.expedition_constellation_challenge_template[var0].award_display[1]
	local var2 = arg0.proxy:isAwardedByChallengeID(var0)

	setActive(arg0.awardGotTF, var2)

	if var1 and #var1 > 0 then
		local var3 = {
			type = var1[1],
			id = var1[2],
			count = var1[3] or 1
		}

		updateDrop(arg0.awardIconTF, var3)
		onButton(arg0, arg0.awardIconTF, function()
			arg0:emit(BaseUI.ON_DROP, var3)
		end, SFX_PANEL)
		setActive(arg0.awardIconTF, true)
	else
		setActive(arg0.awardIconTF, false)
	end
end

function var0.trigeHigestUnlockLevel(arg0)
	local var0 = arg0:getHigestUnlockLevel()

	triggerToggle(arg0.levelToggleList[var0], true)
end

function var0.onReqInfo(arg0)
	arg0:initData()
	arg0:updateLeftTime()
	arg0:updateToggleList()
	arg0:trigeHigestUnlockLevel()
end

function var0.getHigestUnlockLevel(arg0)
	for iter0 = #arg0.levelList, 1, -1 do
		local var0 = arg0.levelList[iter0]

		if arg0.proxy:isLevelUnlock(var0) then
			return var0
		end
	end
end

function var0.getBuffIconPath(arg0, arg1, arg2)
	local var0 = pg.expedition_constellation_challenge_template[arg1]
	local var1 = string.format("%s_%d", var0.painting, arg2)

	return "limitchallenge/icon/" .. var1, var1
end

return var0
