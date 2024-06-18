local var0_0 = class("SculptureScene", import("view.base.BaseUI"))

var0_0.OPEN_GRATITUDE_PAGE = "SculptureScene:OPEN_GRATITUDE_PAGE"

local var1_0 = 5
local var2_0 = 6

function var0_0.getUIName(arg0_1)
	return "SculptureUI"
end

function var0_0.SetActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2
end

function var0_0.GetBaseActivity(arg0_3)
	return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)
end

function var0_0.OnUpdateActivity(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4:SetActivity(arg3_4)

	for iter0_4, iter1_4 in ipairs(arg0_4.cards) do
		if iter1_4.id == arg2_4 then
			iter1_4:Flush(arg3_4)

			break
		end
	end

	if arg1_4 == SculptureActivity.STATE_FINSIH then
		if arg0_4.gratitudePage and arg0_4.gratitudePage:GetLoaded() then
			arg0_4.gratitudePage:Flush(arg3_4)
		end

		arg0_4:UpdateAward()
	elseif arg1_4 == SculptureActivity.STATE_UNLOCK then
		arg0_4:EnterDrawLinePage(arg2_4)
		arg0_4:UpdateRes()
	elseif arg1_4 == SculptureActivity.STATE_DRAW then
		arg0_4:EnterPuzzlePage(arg2_4)
	elseif arg1_4 == SculptureActivity.STATE_JOINT then
		arg0_4:EnterPresentedPage(arg2_4)
	end
end

function var0_0.init(arg0_5)
	arg0_5.backBtn = arg0_5:findTF("back")
	arg0_5.helpBtn = arg0_5:findTF("help")
	arg0_5.awardBtn = arg0_5:findTF("award")
	arg0_5.awardTxt = arg0_5:findTF("award/Text"):GetComponent(typeof(Text))
	arg0_5.ore = arg0_5:findTF("ore")
	arg0_5.oreIcon = arg0_5:findTF("ore/icon"):GetComponent(typeof(Image))
	arg0_5.oreTxt = arg0_5:findTF("ore/Text"):GetComponent(typeof(Text))
	arg0_5.feather = arg0_5:findTF("feather")
	arg0_5.featherIcon = arg0_5:findTF("feather/icon"):GetComponent(typeof(Image))
	arg0_5.featherTxt = arg0_5:findTF("feather/Text"):GetComponent(typeof(Text))
	arg0_5.tpl = arg0_5:findTF("frame/content/tpl")

	setActive(arg0_5.tpl, false)

	arg0_5.tpls = {}
	arg0_5.drawLinePage = SculptureDrawLinePage.New(arg0_5._tf, arg0_5.event, arg0_5.contextData)
	arg0_5.puzzlePage = SculpturePuzzlePage.New(arg0_5._tf, arg0_5.event, arg0_5.contextData)
	arg0_5.presentedPage = SculpturePresentedPage.New(arg0_5._tf, arg0_5.event, arg0_5.contextData)
	arg0_5.gratitudePage = SculptureGratitudePage.New(arg0_5._tf, arg0_5.event, arg0_5.contextDat)
	arg0_5.awardInfoPage = SculptureAwardInfoPage.New(arg0_5._tf, arg0_5.event, arg0_5.contextDat)
	arg0_5.resMsgBoxPage = SculptureResMsgBoxPage.New(arg0_5._tf, arg0_5.event)
	arg0_5.contextData.msgBoxPage = SculptureMsgBoxPage.New(arg0_5._tf, arg0_5.event)
	arg0_5.contextData.tipPage = SculptureTipPage.New(arg0_5._tf, arg0_5.event)
	arg0_5.contextData.miniMsgBox = SculptureMiniMsgBoxPage.New(arg0_5._tf, arg0_5.event)
	Input.multiTouchEnabled = false

	arg0_5:bind(var0_0.OPEN_GRATITUDE_PAGE, function(arg0_6, arg1_6)
		arg0_5.gratitudePage:ExecuteAction("Show", arg1_6, arg0_5.activity, function()
			if arg0_5.presentedPage and arg0_5.presentedPage:GetLoaded() then
				arg0_5.presentedPage:Hide()
			end
		end)
	end)
end

function var0_0.didEnter(arg0_8)
	seriesAsync({
		function(arg0_9)
			arg0_8:UpdateResIcon()
			arg0_8:UpdateRes()
			arg0_8:UpdateAward()
			arg0_8:InitMainView(arg0_9)
		end,
		function(arg0_10)
			arg0_8:RegisterEvent(arg0_10)
		end
	})
end

function var0_0.UpdateResIcon(arg0_11)
	local var0_11 = pg.activity_workbench_item[var1_0]

	arg0_11.oreIcon.sprite = LoadSprite("props/" .. var0_11.icon)

	local var1_11 = pg.activity_workbench_item[var2_0]

	arg0_11.featherIcon.sprite = LoadSprite("props/" .. var1_11.icon)
	rtf(arg0_11.oreIcon.gameObject).sizeDelta = Vector2(80, 80)
	rtf(arg0_11.featherIcon.gameObject).sizeDelta = Vector2(80, 80)
end

function var0_0.InitMainView(arg0_12, arg1_12)
	arg0_12.cards = {}

	local var0_12 = {}

	for iter0_12, iter1_12 in ipairs(arg0_12.activity:getConfig("config_data")) do
		table.insert(var0_12, function(arg0_13)
			local var0_13 = #arg0_12.tpls > 0
			local var1_13 = var0_13 and table.remove(arg0_12.tpls, 1) or Object.Instantiate(arg0_12.tpl, arg0_12.tpl.parent).transform

			setActive(var1_13, true)

			local var2_13 = arg0_12:CreateNewCard(var1_13, iter1_12)

			table.insert(arg0_12.cards, var2_13)

			if not var0_13 then
				onNextTick(arg0_13)
			else
				arg0_13()
			end
		end)
	end

	seriesAsync(var0_12, arg1_12)
end

function var0_0.UpdateRes(arg0_14)
	local var0_14 = arg0_14:GetBaseActivity()

	arg0_14.oreTxt.text = var0_14:getVitemNumber(var1_0)
	arg0_14.featherTxt.text = var0_14:getVitemNumber(var2_0)
end

function var0_0.UpdateAward(arg0_15)
	local var0_15, var1_15 = arg0_15.activity:GetAwardProgress()

	arg0_15.awardTxt.text = var0_15 .. "/" .. var1_15
end

function var0_0.CreateNewCard(arg0_16, arg1_16, arg2_16)
	local var0_16 = SculptureCard.New(arg1_16)

	var0_16:Update(arg2_16, arg0_16.activity)
	onButton(arg0_16, var0_16.continueBtn, function()
		local var0_17 = arg0_16.activity:GetSculptureState(arg2_16)

		if var0_17 == SculptureActivity.STATE_UNLOCK then
			arg0_16:EnterDrawLinePage(arg2_16)
		elseif var0_17 == SculptureActivity.STATE_DRAW then
			arg0_16:EnterPuzzlePage(arg2_16)
		end
	end, SFX_PANEL)
	onButton(arg0_16, var0_16.lockBtn, function()
		local var0_18, var1_18 = arg0_16.activity:_GetComsume(arg2_16)
		local var2_18 = arg0_16.activity:GetResorceName(arg2_16)

		arg0_16.contextData.msgBoxPage:ExecuteAction("Show", {
			nextBtn = true,
			content = arg0_16.activity:getDataConfig(arg2_16, "describe"),
			consume = var1_18,
			consumeId = var0_18,
			onYes = function()
				arg0_16:emit(SculptureMediator.ON_UNLOCK_SCULPTURE, arg2_16)
			end,
			iconName = arg0_16.activity:GetResorceName(arg2_16),
			title = var2_18 .. "_title"
		})
	end, SFX_PANEL)
	onButton(arg0_16, var0_16.finishBtn, function()
		local var0_20 = arg0_16.activity:GetResorceName(arg2_16)

		arg0_16.contextData.msgBoxPage:ExecuteAction("Show", {
			content = arg0_16.activity:getDataConfig(arg2_16, "describe"),
			title = var0_20 .. "_title"
		})
	end, SFX_PANEL)
	onButton(arg0_16, var0_16.tr, function()
		if arg0_16.activity:GetSculptureState(arg2_16) == SculptureActivity.STATE_FINSIH then
			triggerButton(var0_16.finishBtn)
		else
			triggerButton(var0_16.continueBtn)
		end
	end, SFX_PANEL)
	onButton(arg0_16, var0_16.presentedBtn, function()
		arg0_16:EnterPresentedPage(arg2_16)
	end, SFX_PANEL)

	return var0_16
end

function var0_0.RegisterEvent(arg0_23, arg1_23)
	onButton(arg0_23, arg0_23.backBtn, function()
		arg0_23:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_23, arg0_23.awardBtn, function()
		arg0_23.awardInfoPage:ExecuteAction("Show", arg0_23.activity)
	end, SFX_PANEL)
	onButton(arg0_23, arg0_23.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.gift_act_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_23, arg0_23.ore, function()
		arg0_23.resMsgBoxPage:ExecuteAction("Show", var1_0)
	end, SFX_PANEL)
	onButton(arg0_23, arg0_23.feather, function()
		arg0_23.resMsgBoxPage:ExecuteAction("Show", var2_0)
	end, SFX_PANEL)
end

function var0_0.EnterDrawLinePage(arg0_29, arg1_29)
	arg0_29.drawLinePage:ExecuteAction("Show", arg1_29, arg0_29.activity)
end

function var0_0.EnterPresentedPage(arg0_30, arg1_30)
	arg0_30.presentedPage:ExecuteAction("Show", arg1_30, arg0_30.activity, function()
		if arg0_30.puzzlePage and arg0_30.puzzlePage:GetLoaded() then
			arg0_30.puzzlePage:Hide()
		end
	end)
end

function var0_0.EnterPuzzlePage(arg0_32, arg1_32)
	arg0_32.puzzlePage:ExecuteAction("Show", arg1_32, arg0_32.activity, function()
		if arg0_32.drawLinePage and arg0_32.drawLinePage:GetLoaded() then
			arg0_32.drawLinePage:Hide()
		end
	end)
end

function var0_0.onBackPressed(arg0_34)
	var0_0.super.onBackPressed(arg0_34)
end

function var0_0.willExit(arg0_35)
	for iter0_35, iter1_35 in ipairs(arg0_35.cards) do
		iter1_35:Dispose()
	end

	arg0_35.cards = nil

	if arg0_35.contextData.msgBoxPage then
		arg0_35.contextData.msgBoxPage:Destroy()

		arg0_35.contextData.msgBoxPage = nil
	end

	if arg0_35.drawLinePage then
		arg0_35.drawLinePage:Destroy()

		arg0_35.drawLinePage = nil
	end

	if arg0_35.contextData.tipPage then
		arg0_35.contextData.tipPage:Destroy()

		arg0_35.contextData.tipPage = nil
	end

	if arg0_35.puzzlePage then
		arg0_35.puzzlePage:Destroy()

		arg0_35.puzzlePage = nil
	end

	if arg0_35.contextData.miniMsgBox then
		arg0_35.contextData.miniMsgBox:Destroy()

		arg0_35.contextData.miniMsgBox = nil
	end

	if arg0_35.awardInfoPage then
		arg0_35.awardInfoPage:Destroy()

		arg0_35.awardInfoPage = nil
	end

	if arg0_35.resMsgBoxPage then
		arg0_35.resMsgBoxPage:Destroy()

		arg0_35.resMsgBoxPage = nil
	end

	Input.multiTouchEnabled = true
end

return var0_0
