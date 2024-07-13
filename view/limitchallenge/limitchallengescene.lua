local var0_0 = class("LimitChallengeScene", import("..base.BaseUI"))
local var1_0 = LimitChallengeConst

function var0_0.getUIName(arg0_1)
	return "LimitChallengeUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	var1_0.SetRedPointMonth()
	arg0_3:updateLeftTime()
	arg0_3:updateToggleList()
	arg0_3:trigeHigestUnlockLevel()
end

function var0_0.onBackPressed(arg0_4)
	arg0_4:closeView()
end

function var0_0.willExit(arg0_5)
	if arg0_5.leftTimer then
		arg0_5.leftTimer:Stop()

		arg0_5.leftTimer = nil
	end
end

function var0_0.initData(arg0_6)
	arg0_6.proxy = getProxy(LimitChallengeProxy)
	arg0_6.levelList = {
		1,
		2,
		3
	}
	arg0_6.curMonth = var1_0.GetCurMonth()
	arg0_6.descList = {}
	arg0_6.nextMonthTS = LimitChallengeConst.GetNextMonthTS()
	arg0_6.curLevel = 0
end

function var0_0.findUI(arg0_7)
	arg0_7.blurPanel = arg0_7:findTF("blur_panel")
	arg0_7.homeBtn = arg0_7:findTF("adapt/top/option", arg0_7.blurPanel)
	arg0_7.backBtn = arg0_7:findTF("adapt/top/back_button", arg0_7.blurPanel)
	arg0_7.helpBtn = arg0_7:findTF("adapt/top/HelpBtn", arg0_7.blurPanel)
	arg0_7.shareBtn = arg0_7:findTF("adapt/top/ShareBtn", arg0_7.blurPanel)
	arg0_7.levelPanel = arg0_7:findTF("Adapt/LevelPanel")
	arg0_7.levelToggleList = {}
	arg0_7.levelToggleLockList = {}

	for iter0_7, iter1_7 in ipairs(arg0_7.levelList) do
		local var0_7 = "Level_" .. iter1_7
		local var1_7 = arg0_7:findTF(var0_7, arg0_7.levelPanel)
		local var2_7 = arg0_7:findTF("Toggle", var1_7)
		local var3_7 = arg0_7:findTF("Lock", var1_7)

		arg0_7.levelToggleList[iter1_7] = var2_7
		arg0_7.levelToggleLockList[iter1_7] = var3_7
	end

	arg0_7.timePanel = arg0_7:findTF("Adapt/TimePanel")

	local var4_7 = arg0_7:findTF("Left/LeftTime", arg0_7.timePanel)

	arg0_7.leftTipText = arg0_7:findTF("LeftTip", var4_7)
	arg0_7.leftDayTipText = arg0_7:findTF("DayTip", var4_7)
	arg0_7.leftDayValueText = arg0_7:findTF("DayValue", var4_7)
	arg0_7.leftTimeValueText = arg0_7:findTF("TimeValue", var4_7)
	arg0_7.passTimeValueText = arg0_7:findTF("Challenge/Value", arg0_7.timePanel)

	setText(arg0_7.leftTipText, i18n("time_remaining_tip"))
	setText(arg0_7.leftDayTipText, i18n("word_date"))

	arg0_7.iconContainer = arg0_7:findTF("Adapt/DescPanel/ScrollView/Viewport/Container")
	arg0_7.iconTpl = arg0_7:findTF("Adapt/DescPanel/IconTpl")

	local var5_7 = arg0_7:findTF("Adapt/Award")

	arg0_7.awardIconTF = arg0_7:findTF("IconTpl", var5_7)
	arg0_7.awardGotTF = arg0_7:findTF("Got", var5_7)
	arg0_7.startBtn = arg0_7:findTF("Adapt/StartBtn")
	arg0_7.bgImg = arg0_7:findTF("BG")
	arg0_7.nameImg = arg0_7:findTF("Left", arg0_7.timePanel)
	arg0_7.debugPanel = arg0_7:findTF("Adapt/Debug")
	arg0_7.debugText = arg0_7:findTF("Text", arg0_7.debugPanel)
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.homeBtn, function()
		arg0_8:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	print("-----------", tostring(arg0_8.backBtn))
	onButton(arg0_8, arg0_8.backBtn, function()
		arg0_8:closeView()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.challenge_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeChallenge)
	end, SFX_PANEL)

	for iter0_8, iter1_8 in ipairs(arg0_8.levelToggleList) do
		onToggle(arg0_8, iter1_8, function()
			arg0_8.curLevel = iter0_8

			arg0_8:updatePassTime()
			arg0_8:updateAward()
			arg0_8:updateDescPanel()
			arg0_8:updateBossImg()
			arg0_8:updateDebug()
		end, SFX_CONFIRM, SFX_CANCEL)
	end

	onButton(arg0_8, arg0_8.startBtn, function()
		local var0_14 = var1_0.GetStageIDByLevel(arg0_8.curLevel)

		arg0_8:emit(var1_0.OPEN_PRE_COMBAT_LAYER, {
			stageID = var0_14
		})
	end, SFX_PANEL)

	arg0_8.iconUIItemList = UIItemList.New(arg0_8.iconContainer, arg0_8.iconTpl)

	arg0_8.iconUIItemList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg0_8:findTF("Icon", arg2_15)

			arg1_15 = arg1_15 + 1

			if arg0_8.descList[arg1_15] ~= false then
				local var1_15 = var1_0.GetChallengeIDByLevel(arg0_8.curLevel)
				local var2_15, var3_15 = arg0_8:getBuffIconPath(var1_15, arg1_15)

				setImageSprite(var0_15, LoadSprite(var2_15, var3_15))

				local var4_15 = arg0_8.descList[arg1_15][1]
				local var5_15 = arg0_8.descList[arg1_15][2]
				local var6_15 = {}

				table.insert(var6_15, {
					info = var4_15
				})
				table.insert(var6_15, {
					info = var5_15
				})
				onButton(arg0_8, var0_15, function()
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						hideNo = true,
						type = MSGBOX_TYPE_DROP_ITEM,
						name = var4_15,
						content = var5_15,
						iconPath = {
							var2_15,
							var3_15
						}
					})
				end, SFX_PANEL)
			end
		end
	end)
end

function var0_0.updateDebug(arg0_17)
	local var0_17 = arg0_17.curMonth
	local var1_17 = arg0_17.curLevel
	local var2_17 = var1_0.GetChallengeIDByLevel(arg0_17.curLevel)
	local var3_17 = var1_0.GetStageIDByLevel(arg0_17.curLevel)
	local var4_17 = string.format(" 月份: %s \n 选择难度: %s \n 选择挑战ID: %s \n 选择关卡ID: %s \n", tostring(var0_17), tostring(var1_17), tostring(var2_17), tostring(var3_17))

	for iter0_17, iter1_17 in ipairs(arg0_17.levelList) do
		local var5_17 = LimitChallengeConst.GetChallengeIDByLevel(iter1_17)
		local var6_17 = arg0_17.proxy:isAwardedByChallengeID(var5_17)
		local var7_17 = " 难度" .. iter1_17 .. "奖励:" .. (var6_17 and "已领取" or "未领取") .. "\n"

		var4_17 = var4_17 .. var7_17
	end

	for iter2_17, iter3_17 in ipairs(arg0_17.levelList) do
		local var8_17 = LimitChallengeConst.GetChallengeIDByLevel(iter3_17)
		local var9_17 = arg0_17.proxy:getPassTimeByChallengeID(var8_17)
		local var10_17 = " 难度" .. iter3_17 .. "时间:" .. (var9_17 and var9_17 or "没有记录") .. "\n"

		var4_17 = var4_17 .. var10_17
	end

	setText(arg0_17.debugText, var4_17)
end

function var0_0.updateToggleList(arg0_18)
	local var0_18 = arg0_18:getHigestUnlockLevel()

	for iter0_18, iter1_18 in ipairs(arg0_18.levelToggleLockList) do
		local var1_18 = var0_18 < iter0_18

		setActive(iter1_18, var1_18)

		local var2_18 = arg0_18.levelToggleList[iter0_18]

		setActive(var2_18, not var1_18)
	end
end

function var0_0.updateLeftTime(arg0_19)
	if arg0_19.leftTimer then
		arg0_19.leftTimer:Stop()

		arg0_19.leftTimer = nil
	end

	local var0_19 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_19 = arg0_19.nextMonthTS - var0_19

	if var1_19 > 0 then
		if arg0_19.leftTimer then
			arg0_19.leftTimer:Stop()

			arg0_19.leftTimer = nil
		end

		local function var2_19()
			if var1_19 <= 0 and arg0_19.leftTimer then
				arg0_19.leftTimer:Stop()

				arg0_19.leftTimer = nil
			end

			local var0_20, var1_20, var2_20, var3_20 = pg.TimeMgr.GetInstance():parseTimeFrom(var1_19)

			setText(arg0_19.leftDayValueText, var0_20)
			setText(arg0_19.leftTimeValueText, string.format("%02d:%02d:%02d", var1_20, var2_20, var3_20))

			var1_19 = var1_19 - 1
		end

		arg0_19.leftTimer = Timer.New(var2_19, 1, -1)

		arg0_19.leftTimer:Start()
		var2_19()
	end
end

function var0_0.updateBossImg(arg0_21)
	local var0_21 = var1_0.GetChallengeIDByLevel(arg0_21.curLevel)
	local var1_21 = pg.expedition_constellation_challenge_template[var0_21]
	local var2_21 = var1_21.painting
	local var3_21 = var1_21.information_icon
	local var4_21 = "limitchallenge/boss/" .. var2_21

	setImageSprite(arg0_21.bgImg, LoadSprite(var4_21, var2_21))

	local var5_21 = "limitchallenge/name/" .. var3_21

	setImageSprite(arg0_21.nameImg, LoadSprite(var5_21, var3_21), true)

	local var6_21 = var1_21.button_style .. "_btn_start"
	local var7_21 = "limitchallenge/btn/" .. var6_21

	setImageSprite(arg0_21.startBtn, LoadSprite(var7_21, var6_21), true)

	local var8_21 = "%d_level_%d_selected"

	for iter0_21, iter1_21 in ipairs(arg0_21.levelList) do
		local var9_21 = string.format(var8_21, var1_21.button_style, iter1_21)
		local var10_21 = "limitchallenge/btn/" .. var9_21
		local var11_21 = arg0_21:findTF("Selected", arg0_21.levelToggleList[iter1_21])

		setImageSprite(var11_21, LoadSprite(var10_21, var9_21), true)
	end
end

function var0_0.updateDescPanel(arg0_22)
	arg0_22.descList = {}

	local var0_22 = var1_0.GetChallengeIDByLevel(arg0_22.curLevel)

	arg0_22.descList = pg.expedition_constellation_challenge_template[var0_22].description

	local var1_22 = 3 - #arg0_22.descList

	if var1_22 > 0 then
		for iter0_22 = 1, var1_22 do
			table.insert(arg0_22.descList, false)
		end
	end

	arg0_22.iconUIItemList:align(#arg0_22.descList)
end

function var0_0.updatePassTime(arg0_23)
	local var0_23 = LimitChallengeConst.GetChallengeIDByLevel(arg0_23.curLevel)
	local var1_23 = arg0_23.proxy:getPassTimeByChallengeID(var0_23) or 0
	local var2_23 = math.floor(var1_23 / 60)
	local var3_23 = math.floor(var1_23 % 60)
	local var4_23 = string.format("%02d:%02d", var2_23, var3_23)

	setText(arg0_23.passTimeValueText, var4_23)
end

function var0_0.updateAward(arg0_24)
	local var0_24 = LimitChallengeConst.GetChallengeIDByLevel(arg0_24.curLevel)
	local var1_24 = pg.expedition_constellation_challenge_template[var0_24].award_display[1]
	local var2_24 = arg0_24.proxy:isAwardedByChallengeID(var0_24)

	setActive(arg0_24.awardGotTF, var2_24)

	if var1_24 and #var1_24 > 0 then
		local var3_24 = {
			type = var1_24[1],
			id = var1_24[2],
			count = var1_24[3] or 1
		}

		updateDrop(arg0_24.awardIconTF, var3_24)
		onButton(arg0_24, arg0_24.awardIconTF, function()
			arg0_24:emit(BaseUI.ON_DROP, var3_24)
		end, SFX_PANEL)
		setActive(arg0_24.awardIconTF, true)
	else
		setActive(arg0_24.awardIconTF, false)
	end
end

function var0_0.trigeHigestUnlockLevel(arg0_26)
	local var0_26 = arg0_26:getHigestUnlockLevel()

	triggerToggle(arg0_26.levelToggleList[var0_26], true)
end

function var0_0.onReqInfo(arg0_27)
	arg0_27:initData()
	arg0_27:updateLeftTime()
	arg0_27:updateToggleList()
	arg0_27:trigeHigestUnlockLevel()
end

function var0_0.getHigestUnlockLevel(arg0_28)
	for iter0_28 = #arg0_28.levelList, 1, -1 do
		local var0_28 = arg0_28.levelList[iter0_28]

		if arg0_28.proxy:isLevelUnlock(var0_28) then
			return var0_28
		end
	end
end

function var0_0.getBuffIconPath(arg0_29, arg1_29, arg2_29)
	local var0_29 = pg.expedition_constellation_challenge_template[arg1_29]
	local var1_29 = string.format("%s_%d", var0_29.painting, arg2_29)

	return "limitchallenge/icon/" .. var1_29, var1_29
end

return var0_0
