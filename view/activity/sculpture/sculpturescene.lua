local var0 = class("SculptureScene", import("view.base.BaseUI"))

var0.OPEN_GRATITUDE_PAGE = "SculptureScene:OPEN_GRATITUDE_PAGE"

local var1 = 5
local var2 = 6

function var0.getUIName(arg0)
	return "SculptureUI"
end

function var0.SetActivity(arg0, arg1)
	arg0.activity = arg1
end

function var0.GetBaseActivity(arg0)
	return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)
end

function var0.OnUpdateActivity(arg0, arg1, arg2, arg3)
	arg0:SetActivity(arg3)

	for iter0, iter1 in ipairs(arg0.cards) do
		if iter1.id == arg2 then
			iter1:Flush(arg3)

			break
		end
	end

	if arg1 == SculptureActivity.STATE_FINSIH then
		if arg0.gratitudePage and arg0.gratitudePage:GetLoaded() then
			arg0.gratitudePage:Flush(arg3)
		end

		arg0:UpdateAward()
	elseif arg1 == SculptureActivity.STATE_UNLOCK then
		arg0:EnterDrawLinePage(arg2)
		arg0:UpdateRes()
	elseif arg1 == SculptureActivity.STATE_DRAW then
		arg0:EnterPuzzlePage(arg2)
	elseif arg1 == SculptureActivity.STATE_JOINT then
		arg0:EnterPresentedPage(arg2)
	end
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("back")
	arg0.helpBtn = arg0:findTF("help")
	arg0.awardBtn = arg0:findTF("award")
	arg0.awardTxt = arg0:findTF("award/Text"):GetComponent(typeof(Text))
	arg0.ore = arg0:findTF("ore")
	arg0.oreIcon = arg0:findTF("ore/icon"):GetComponent(typeof(Image))
	arg0.oreTxt = arg0:findTF("ore/Text"):GetComponent(typeof(Text))
	arg0.feather = arg0:findTF("feather")
	arg0.featherIcon = arg0:findTF("feather/icon"):GetComponent(typeof(Image))
	arg0.featherTxt = arg0:findTF("feather/Text"):GetComponent(typeof(Text))
	arg0.tpl = arg0:findTF("frame/content/tpl")

	setActive(arg0.tpl, false)

	arg0.tpls = {}
	arg0.drawLinePage = SculptureDrawLinePage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.puzzlePage = SculpturePuzzlePage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.presentedPage = SculpturePresentedPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.gratitudePage = SculptureGratitudePage.New(arg0._tf, arg0.event, arg0.contextDat)
	arg0.awardInfoPage = SculptureAwardInfoPage.New(arg0._tf, arg0.event, arg0.contextDat)
	arg0.resMsgBoxPage = SculptureResMsgBoxPage.New(arg0._tf, arg0.event)
	arg0.contextData.msgBoxPage = SculptureMsgBoxPage.New(arg0._tf, arg0.event)
	arg0.contextData.tipPage = SculptureTipPage.New(arg0._tf, arg0.event)
	arg0.contextData.miniMsgBox = SculptureMiniMsgBoxPage.New(arg0._tf, arg0.event)
	Input.multiTouchEnabled = false

	arg0:bind(var0.OPEN_GRATITUDE_PAGE, function(arg0, arg1)
		arg0.gratitudePage:ExecuteAction("Show", arg1, arg0.activity, function()
			if arg0.presentedPage and arg0.presentedPage:GetLoaded() then
				arg0.presentedPage:Hide()
			end
		end)
	end)
end

function var0.didEnter(arg0)
	seriesAsync({
		function(arg0)
			arg0:UpdateResIcon()
			arg0:UpdateRes()
			arg0:UpdateAward()
			arg0:InitMainView(arg0)
		end,
		function(arg0)
			arg0:RegisterEvent(arg0)
		end
	})
end

function var0.UpdateResIcon(arg0)
	local var0 = pg.activity_workbench_item[var1]

	arg0.oreIcon.sprite = LoadSprite("props/" .. var0.icon)

	local var1 = pg.activity_workbench_item[var2]

	arg0.featherIcon.sprite = LoadSprite("props/" .. var1.icon)
	rtf(arg0.oreIcon.gameObject).sizeDelta = Vector2(80, 80)
	rtf(arg0.featherIcon.gameObject).sizeDelta = Vector2(80, 80)
end

function var0.InitMainView(arg0, arg1)
	arg0.cards = {}

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.activity:getConfig("config_data")) do
		table.insert(var0, function(arg0)
			local var0 = #arg0.tpls > 0
			local var1 = var0 and table.remove(arg0.tpls, 1) or Object.Instantiate(arg0.tpl, arg0.tpl.parent).transform

			setActive(var1, true)

			local var2 = arg0:CreateNewCard(var1, iter1)

			table.insert(arg0.cards, var2)

			if not var0 then
				onNextTick(arg0)
			else
				arg0()
			end
		end)
	end

	seriesAsync(var0, arg1)
end

function var0.UpdateRes(arg0)
	local var0 = arg0:GetBaseActivity()

	arg0.oreTxt.text = var0:getVitemNumber(var1)
	arg0.featherTxt.text = var0:getVitemNumber(var2)
end

function var0.UpdateAward(arg0)
	local var0, var1 = arg0.activity:GetAwardProgress()

	arg0.awardTxt.text = var0 .. "/" .. var1
end

function var0.CreateNewCard(arg0, arg1, arg2)
	local var0 = SculptureCard.New(arg1)

	var0:Update(arg2, arg0.activity)
	onButton(arg0, var0.continueBtn, function()
		local var0 = arg0.activity:GetSculptureState(arg2)

		if var0 == SculptureActivity.STATE_UNLOCK then
			arg0:EnterDrawLinePage(arg2)
		elseif var0 == SculptureActivity.STATE_DRAW then
			arg0:EnterPuzzlePage(arg2)
		end
	end, SFX_PANEL)
	onButton(arg0, var0.lockBtn, function()
		local var0, var1 = arg0.activity:_GetComsume(arg2)
		local var2 = arg0.activity:GetResorceName(arg2)

		arg0.contextData.msgBoxPage:ExecuteAction("Show", {
			nextBtn = true,
			content = arg0.activity:getDataConfig(arg2, "describe"),
			consume = var1,
			consumeId = var0,
			onYes = function()
				arg0:emit(SculptureMediator.ON_UNLOCK_SCULPTURE, arg2)
			end,
			iconName = arg0.activity:GetResorceName(arg2),
			title = var2 .. "_title"
		})
	end, SFX_PANEL)
	onButton(arg0, var0.finishBtn, function()
		local var0 = arg0.activity:GetResorceName(arg2)

		arg0.contextData.msgBoxPage:ExecuteAction("Show", {
			content = arg0.activity:getDataConfig(arg2, "describe"),
			title = var0 .. "_title"
		})
	end, SFX_PANEL)
	onButton(arg0, var0.tr, function()
		if arg0.activity:GetSculptureState(arg2) == SculptureActivity.STATE_FINSIH then
			triggerButton(var0.finishBtn)
		else
			triggerButton(var0.continueBtn)
		end
	end, SFX_PANEL)
	onButton(arg0, var0.presentedBtn, function()
		arg0:EnterPresentedPage(arg2)
	end, SFX_PANEL)

	return var0
end

function var0.RegisterEvent(arg0, arg1)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0, arg0.awardBtn, function()
		arg0.awardInfoPage:ExecuteAction("Show", arg0.activity)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.gift_act_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.ore, function()
		arg0.resMsgBoxPage:ExecuteAction("Show", var1)
	end, SFX_PANEL)
	onButton(arg0, arg0.feather, function()
		arg0.resMsgBoxPage:ExecuteAction("Show", var2)
	end, SFX_PANEL)
end

function var0.EnterDrawLinePage(arg0, arg1)
	arg0.drawLinePage:ExecuteAction("Show", arg1, arg0.activity)
end

function var0.EnterPresentedPage(arg0, arg1)
	arg0.presentedPage:ExecuteAction("Show", arg1, arg0.activity, function()
		if arg0.puzzlePage and arg0.puzzlePage:GetLoaded() then
			arg0.puzzlePage:Hide()
		end
	end)
end

function var0.EnterPuzzlePage(arg0, arg1)
	arg0.puzzlePage:ExecuteAction("Show", arg1, arg0.activity, function()
		if arg0.drawLinePage and arg0.drawLinePage:GetLoaded() then
			arg0.drawLinePage:Hide()
		end
	end)
end

function var0.onBackPressed(arg0)
	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	for iter0, iter1 in ipairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.cards = nil

	if arg0.contextData.msgBoxPage then
		arg0.contextData.msgBoxPage:Destroy()

		arg0.contextData.msgBoxPage = nil
	end

	if arg0.drawLinePage then
		arg0.drawLinePage:Destroy()

		arg0.drawLinePage = nil
	end

	if arg0.contextData.tipPage then
		arg0.contextData.tipPage:Destroy()

		arg0.contextData.tipPage = nil
	end

	if arg0.puzzlePage then
		arg0.puzzlePage:Destroy()

		arg0.puzzlePage = nil
	end

	if arg0.contextData.miniMsgBox then
		arg0.contextData.miniMsgBox:Destroy()

		arg0.contextData.miniMsgBox = nil
	end

	if arg0.awardInfoPage then
		arg0.awardInfoPage:Destroy()

		arg0.awardInfoPage = nil
	end

	if arg0.resMsgBoxPage then
		arg0.resMsgBoxPage:Destroy()

		arg0.resMsgBoxPage = nil
	end

	Input.multiTouchEnabled = true
end

return var0
