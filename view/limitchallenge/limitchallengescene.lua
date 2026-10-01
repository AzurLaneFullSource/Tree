local var0_0 = class("LimitChallengeScene", import("..base.BaseUI"))
local var1_0 = LimitChallengeConst

function var0_0.getUIName(arg0_1)
	return "LimitChallengeUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"weaponframes"
	}

	table.insertto(var0_2, arg0_2:getLimitChallengeResList())

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.getLimitChallengeResList(arg0_3)
	local var0_3 = {}
	local var1_3 = pg.constellation_challenge_month and var1_0.GetCurMonthConfig()

	if not var1_3 then
		return var0_3
	end

	for iter0_3, iter1_3 in ipairs(var1_3.stage or {}) do
		local var2_3 = pg.expedition_constellation_challenge_template[iter1_3]

		if var2_3 then
			table.insert(var0_3, "limitchallenge/boss/" .. var2_3.painting)
			table.insert(var0_3, "limitchallenge/name/" .. var2_3.information_icon)
			table.insert(var0_3, "limitchallenge/btn/" .. var2_3.button_style .. "_btn_start")

			for iter2_3 = 1, 3 do
				local var3_3 = string.format("%d_level_%d_selected", var2_3.button_style, iter2_3)

				table.insert(var0_3, "limitchallenge/btn/" .. var3_3)
			end

			for iter3_3, iter4_3 in ipairs(var2_3.description or {}) do
				if iter4_3 then
					local var4_3 = arg0_3:getBuffIconPath(iter1_3, iter3_3)

					table.insert(var0_3, var4_3)
				end
			end

			table.insertto(var0_3, arg0_3:getAwardResList(var2_3.award_display and var2_3.award_display[1]))
		end
	end

	return var0_3
end

function var0_0.getAwardResList(arg0_4, arg1_4)
	local var0_4 = {}

	if not arg1_4 or #arg1_4 == 0 then
		return var0_4
	end

	local var1_4 = arg1_4[1]

	if var1_4 == DROP_TYPE_ICON_FRAME then
		table.insert(var0_4, "Props/icon_frame")
	elseif var1_4 == DROP_TYPE_CHAT_FRAME then
		table.insert(var0_4, "Props/chat_frame")
	end

	return var0_4
end

function var0_0.init(arg0_5)
	arg0_5:initData()
	arg0_5:findUI()
	arg0_5:addListener()
end

function var0_0.didEnter(arg0_6)
	var1_0.SetRedPointMonth()
	arg0_6:updateLeftTime()
	arg0_6:updateToggleList()
	arg0_6:trigeHigestUnlockLevel()
end

function var0_0.onBackPressed(arg0_7)
	arg0_7:closeView()
end

function var0_0.willExit(arg0_8)
	if arg0_8.leftTimer then
		arg0_8.leftTimer:Stop()

		arg0_8.leftTimer = nil
	end
end

function var0_0.initData(arg0_9)
	arg0_9.proxy = getProxy(LimitChallengeProxy)
	arg0_9.levelList = {
		1,
		2,
		3
	}
	arg0_9.curMonth = var1_0.GetCurMonth()
	arg0_9.descList = {}
	arg0_9.nextMonthTS = LimitChallengeConst.GetNextMonthTS()
	arg0_9.curLevel = 0
end

function var0_0.findUI(arg0_10)
	arg0_10.blurPanel = arg0_10._tf:Find("blur_panel")
	arg0_10.homeBtn = arg0_10.blurPanel:Find("adapt/top/option")
	arg0_10.backBtn = arg0_10.blurPanel:Find("adapt/top/back_button")
	arg0_10.helpBtn = arg0_10.blurPanel:Find("adapt/top/HelpBtn")
	arg0_10.shareBtn = arg0_10.blurPanel:Find("adapt/top/ShareBtn")
	arg0_10.levelPanel = arg0_10._tf:Find("Adapt/LevelPanel")
	arg0_10.levelToggleList = {}
	arg0_10.levelToggleLockList = {}

	for iter0_10, iter1_10 in ipairs(arg0_10.levelList) do
		local var0_10 = "Level_" .. iter1_10
		local var1_10 = arg0_10.levelPanel:Find(var0_10)
		local var2_10 = var1_10:Find("Toggle")
		local var3_10 = var1_10:Find("Lock")

		arg0_10.levelToggleList[iter1_10] = var2_10
		arg0_10.levelToggleLockList[iter1_10] = var3_10
	end

	arg0_10.timePanel = arg0_10._tf:Find("Adapt/TimePanel")

	local var4_10 = arg0_10.timePanel:Find("Left/LeftTime")

	arg0_10.leftTipText = var4_10:Find("LeftTip")
	arg0_10.leftDayTipText = var4_10:Find("DayTip")
	arg0_10.leftDayValueText = var4_10:Find("DayValue")
	arg0_10.leftTimeValueText = var4_10:Find("TimeValue")
	arg0_10.passTimeValueText = arg0_10.timePanel:Find("Challenge/Value")

	setText(arg0_10.leftTipText, i18n("time_remaining_tip"))
	setText(arg0_10.leftDayTipText, i18n("word_date"))

	arg0_10.iconContainer = arg0_10._tf:Find("Adapt/DescPanel/ScrollView/Viewport/Container")
	arg0_10.iconTpl = arg0_10._tf:Find("Adapt/DescPanel/IconTpl")

	local var5_10 = arg0_10._tf:Find("Adapt/Award")

	arg0_10.awardIconTF = var5_10:Find("IconTpl")
	arg0_10.awardGotTF = var5_10:Find("Got")
	arg0_10.startBtn = arg0_10._tf:Find("Adapt/StartBtn")
	arg0_10.bgImg = arg0_10._tf:Find("BG")
	arg0_10.nameImg = arg0_10.timePanel:Find("Left")
	arg0_10.debugPanel = arg0_10._tf:Find("Adapt/Debug")
	arg0_10.debugText = arg0_10.debugPanel:Find("Text")
end

function var0_0.addListener(arg0_11)
	onButton(arg0_11, arg0_11.homeBtn, function()
		arg0_11:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	print("-----------", tostring(arg0_11.backBtn))
	onButton(arg0_11, arg0_11.backBtn, function()
		arg0_11:closeView()
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.challenge_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeChallenge)
	end, SFX_PANEL)

	for iter0_11, iter1_11 in ipairs(arg0_11.levelToggleList) do
		onToggle(arg0_11, iter1_11, function()
			arg0_11.curLevel = iter0_11

			arg0_11:updatePassTime()
			arg0_11:updateAward()
			arg0_11:updateDescPanel()
			arg0_11:updateBossImg()
			arg0_11:updateDebug()
		end, SFX_CONFIRM, SFX_CANCEL)
	end

	onButton(arg0_11, arg0_11.startBtn, function()
		local var0_17 = var1_0.GetStageIDByLevel(arg0_11.curLevel)

		arg0_11:emit(var1_0.OPEN_PRE_COMBAT_LAYER, {
			stageID = var0_17
		})
	end, SFX_PANEL)

	arg0_11.iconUIItemList = UIItemList.New(arg0_11.iconContainer, arg0_11.iconTpl)

	arg0_11.iconUIItemList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = arg2_18:Find("Icon")

			arg1_18 = arg1_18 + 1

			if arg0_11.descList[arg1_18] ~= false then
				local var1_18 = var1_0.GetChallengeIDByLevel(arg0_11.curLevel)
				local var2_18, var3_18 = arg0_11:getBuffIconPath(var1_18, arg1_18)

				setImageSprite(var0_18, LoadSprite(var2_18, var3_18))

				local var4_18 = arg0_11.descList[arg1_18][1]
				local var5_18 = arg0_11.descList[arg1_18][2]
				local var6_18 = {}

				table.insert(var6_18, {
					info = var4_18
				})
				table.insert(var6_18, {
					info = var5_18
				})
				onButton(arg0_11, var0_18, function()
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						hideNo = true,
						type = MSGBOX_TYPE_DROP_ITEM,
						name = var4_18,
						content = var5_18,
						iconPath = {
							var2_18,
							var3_18
						}
					})
				end, SFX_PANEL)
			end
		end
	end)
end

function var0_0.updateDebug(arg0_20)
	local var0_20 = arg0_20.curMonth
	local var1_20 = arg0_20.curLevel
	local var2_20 = var1_0.GetChallengeIDByLevel(arg0_20.curLevel)
	local var3_20 = var1_0.GetStageIDByLevel(arg0_20.curLevel)
	local var4_20 = string.format(" 月份: %s \n 选择难度: %s \n 选择挑战ID: %s \n 选择关卡ID: %s \n", tostring(var0_20), tostring(var1_20), tostring(var2_20), tostring(var3_20))

	for iter0_20, iter1_20 in ipairs(arg0_20.levelList) do
		local var5_20 = LimitChallengeConst.GetChallengeIDByLevel(iter1_20)
		local var6_20 = arg0_20.proxy:isAwardedByChallengeID(var5_20)
		local var7_20 = " 难度" .. iter1_20 .. "奖励:" .. (var6_20 and "已领取" or "未领取") .. "\n"

		var4_20 = var4_20 .. var7_20
	end

	for iter2_20, iter3_20 in ipairs(arg0_20.levelList) do
		local var8_20 = LimitChallengeConst.GetChallengeIDByLevel(iter3_20)
		local var9_20 = arg0_20.proxy:getPassTimeByChallengeID(var8_20)
		local var10_20 = " 难度" .. iter3_20 .. "时间:" .. (var9_20 and var9_20 or "没有记录") .. "\n"

		var4_20 = var4_20 .. var10_20
	end

	setText(arg0_20.debugText, var4_20)
end

function var0_0.updateToggleList(arg0_21)
	local var0_21 = arg0_21:getHigestUnlockLevel()

	for iter0_21, iter1_21 in ipairs(arg0_21.levelToggleLockList) do
		local var1_21 = var0_21 < iter0_21

		setActive(iter1_21, var1_21)

		local var2_21 = arg0_21.levelToggleList[iter0_21]

		setActive(var2_21, not var1_21)
	end
end

function var0_0.updateLeftTime(arg0_22)
	if arg0_22.leftTimer then
		arg0_22.leftTimer:Stop()

		arg0_22.leftTimer = nil
	end

	local var0_22 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_22 = arg0_22.nextMonthTS - var0_22

	if var1_22 > 0 then
		if arg0_22.leftTimer then
			arg0_22.leftTimer:Stop()

			arg0_22.leftTimer = nil
		end

		local function var2_22()
			if var1_22 <= 0 and arg0_22.leftTimer then
				arg0_22.leftTimer:Stop()

				arg0_22.leftTimer = nil
			end

			local var0_23, var1_23, var2_23, var3_23 = pg.TimeMgr.GetInstance():parseTimeFrom(var1_22)

			setText(arg0_22.leftDayValueText, var0_23)
			setText(arg0_22.leftTimeValueText, string.format("%02d:%02d:%02d", var1_23, var2_23, var3_23))

			var1_22 = var1_22 - 1
		end

		arg0_22.leftTimer = Timer.New(var2_22, 1, -1)

		arg0_22.leftTimer:Start()
		var2_22()
	end
end

function var0_0.updateBossImg(arg0_24)
	local var0_24 = var1_0.GetChallengeIDByLevel(arg0_24.curLevel)
	local var1_24 = pg.expedition_constellation_challenge_template[var0_24]
	local var2_24 = var1_24.painting
	local var3_24 = var1_24.information_icon
	local var4_24 = "limitchallenge/boss/" .. var2_24

	setImageSprite(arg0_24.bgImg, LoadSprite(var4_24, var2_24))

	local var5_24 = "limitchallenge/name/" .. var3_24

	setImageSprite(arg0_24.nameImg, LoadSprite(var5_24, var3_24), true)

	local var6_24 = var1_24.button_style .. "_btn_start"
	local var7_24 = "limitchallenge/btn/" .. var6_24

	setImageSprite(arg0_24.startBtn, LoadSprite(var7_24, var6_24), true)

	local var8_24 = "%d_level_%d_selected"

	for iter0_24, iter1_24 in ipairs(arg0_24.levelList) do
		local var9_24 = string.format(var8_24, var1_24.button_style, iter1_24)
		local var10_24 = "limitchallenge/btn/" .. var9_24
		local var11_24 = arg0_24.levelToggleList[iter1_24]:Find("Selected")

		setImageSprite(var11_24, LoadSprite(var10_24, var9_24), true)
	end
end

function var0_0.updateDescPanel(arg0_25)
	arg0_25.descList = {}

	local var0_25 = var1_0.GetChallengeIDByLevel(arg0_25.curLevel)

	arg0_25.descList = pg.expedition_constellation_challenge_template[var0_25].description

	local var1_25 = 3 - #arg0_25.descList

	if var1_25 > 0 then
		for iter0_25 = 1, var1_25 do
			table.insert(arg0_25.descList, false)
		end
	end

	arg0_25.iconUIItemList:align(#arg0_25.descList)
end

function var0_0.updatePassTime(arg0_26)
	local var0_26 = LimitChallengeConst.GetChallengeIDByLevel(arg0_26.curLevel)
	local var1_26 = arg0_26.proxy:getPassTimeByChallengeID(var0_26) or 0
	local var2_26 = math.floor(var1_26 / 60)
	local var3_26 = math.floor(var1_26 % 60)
	local var4_26 = string.format("%02d:%02d", var2_26, var3_26)

	setText(arg0_26.passTimeValueText, var4_26)
end

function var0_0.updateAward(arg0_27)
	local var0_27 = LimitChallengeConst.GetChallengeIDByLevel(arg0_27.curLevel)
	local var1_27 = pg.expedition_constellation_challenge_template[var0_27].award_display[1]
	local var2_27 = arg0_27.proxy:isAwardedByChallengeID(var0_27)

	setActive(arg0_27.awardGotTF, var2_27)

	if var1_27 and #var1_27 > 0 then
		local var3_27 = {
			type = var1_27[1],
			id = var1_27[2],
			count = var1_27[3] or 1
		}

		updateDrop(arg0_27.awardIconTF, var3_27)
		onButton(arg0_27, arg0_27.awardIconTF, function()
			arg0_27:emit(BaseUI.ON_DROP, var3_27)
		end, SFX_PANEL)
		setActive(arg0_27.awardIconTF, true)
	else
		setActive(arg0_27.awardIconTF, false)
	end
end

function var0_0.trigeHigestUnlockLevel(arg0_29)
	local var0_29 = arg0_29:getHigestUnlockLevel()

	triggerToggle(arg0_29.levelToggleList[var0_29], true)
end

function var0_0.onReqInfo(arg0_30)
	arg0_30:initData()
	arg0_30:updateLeftTime()
	arg0_30:updateToggleList()
	arg0_30:trigeHigestUnlockLevel()
end

function var0_0.getHigestUnlockLevel(arg0_31)
	for iter0_31 = #arg0_31.levelList, 1, -1 do
		local var0_31 = arg0_31.levelList[iter0_31]

		if arg0_31.proxy:isLevelUnlock(var0_31) then
			return var0_31
		end
	end
end

function var0_0.getBuffIconPath(arg0_32, arg1_32, arg2_32)
	local var0_32 = pg.expedition_constellation_challenge_template[arg1_32]
	local var1_32 = string.format("%s_%d", var0_32.painting, arg2_32)

	return "limitchallenge/icon/" .. var1_32, var1_32
end

return var0_0
