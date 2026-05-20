local var0_0 = class("MallMapScene", import("view.base.BaseUI"))

var0_0.TYPE2INFOS = {
	[MallActivity.POINT_TYPE.SITE] = {
		"name_bg_blue",
		i18n("mall_point_name_type1"),
		"icon_site"
	},
	[MallActivity.POINT_TYPE.MAIN_STORY] = {
		"name_bg_green",
		i18n("mall_point_name_type2"),
		"icon_branch"
	},
	[MallActivity.POINT_TYPE.BRANCH_STORY] = {
		"name_bg_green",
		i18n("mall_point_name_type3"),
		"icon_branch"
	},
	[MallActivity.POINT_TYPE.INTERACT_STORY] = {
		"name_bg_orange",
		i18n("mall_point_name_type4"),
		""
	}
}

function var0_0.getUIName(arg0_1)
	return "MallMapUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiBackBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiHomeBtn, function()
		arg0_2:quickExitFunc()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiHelpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.mall_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiMallBtn, function()
		arg0_2:emit(MallMapMediator.CHANGE_SCENE, SCENE.MALL)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiBookBtn, function()
		arg0_2:emit(MallMapMediator.GO_SUBLAYER, Context.New({
			mediator = MallStoryLineMediator,
			viewComponent = MallStoryLineLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiOrderBtn, function()
		arg0_2:emit(MallMapMediator.GO_SUBLAYER, Context.New({
			mediator = MallOrderMediator,
			viewComponent = MallOrderLayer,
			data = {
				onExit = function()
					arg0_2:UpdateOrderTip()
				end
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiSummaryBtn, function()
		arg0_2:ShowSummaryBox()
	end, SFX_PANEL)

	arg0_2.pointUIList = UIItemList.New(arg0_2.uiContentTF, arg0_2.uiContentTF:Find("tpl"))

	arg0_2.pointUIList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_2:UpdatePointTpl(arg1_11, arg2_11)
		end
	end)

	arg0_2.siteBox = MallSiteBox.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.summaryBox = MallSummaryBox.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)

	setText(arg0_2.uiTitleText, i18n("mall_title"))
	setText(arg0_2.uiTitleEnText, i18n("mall_title_en"))
end

function var0_0.didEnter(arg0_12)
	arg0_12:UpdateData()
	arg0_12:UpdateView()
	arg0_12:UpdateBg()
	arg0_12:CheckGuide()
end

function var0_0.CheckGuide(arg0_13)
	if not pg.NewStoryMgr.GetInstance():IsPlayed("MALL_GUIDE") then
		pg.NewGuideMgr.GetInstance():Play("MALL_GUIDE")
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "MALL_GUIDE"
		})

		return
	end

	if not pg.NewStoryMgr.GetInstance():IsPlayed("MALL_GUIDE_2") then
		pg.NewGuideMgr.GetInstance():Play("MALL_GUIDE_2")
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "MALL_GUIDE_2"
		})

		return
	end
end

function var0_0.UpdateData(arg0_14)
	arg0_14.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)

	assert(arg0_14.activity and not arg0_14.activity:isEnd(), "not exist mall act, type: " .. ActivityConst.ACTIVITY_TYPE_MALL)

	arg0_14.triggeredIds = arg0_14.activity:GetTriggeredPointIds()

	local var0_14 = arg0_14.activity:GetLevelData():GetUnlockStoryIdsByType()

	arg0_14.showPointIds = {}

	for iter0_14, iter1_14 in pairs(var0_14) do
		local var1_14 = iter0_14 ~= MallActivity.POINT_TYPE.SITE
		local var2_14 = underscore.detect(iter1_14, function(arg0_15)
			local var0_15 = pg.activity_mall_story[arg0_15]

			return not table.contains(arg0_14.triggeredIds, arg0_15) or var1_14 and var0_15.lua ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_15.lua)
		end)

		if var2_14 then
			table.insert(arg0_14.showPointIds, var2_14)
		end
	end

	arg0_14.bgConfig = arg0_14.activity:getConfig("config_client").bg_switch
end

function var0_0.UpdateView(arg0_16)
	arg0_16.pointUIList:align(#arg0_16.showPointIds)
	arg0_16:UpdateOrderBtn()
	arg0_16:UpdateTips()
end

function var0_0.UpdateBg(arg0_17)
	local var0_17 = arg0_17:GetCurBg()

	if var0_17 then
		setImageSprite(arg0_17.uiBgTF, LoadSprite("bg/" .. var0_17), false)
	end
end

function var0_0.GetCurBg(arg0_18)
	for iter0_18 = #arg0_18.bgConfig, 1, -1 do
		local var0_18 = arg0_18.bgConfig[iter0_18]

		if pg.NewStoryMgr.GetInstance():IsPlayed(var0_18[1]) then
			return var0_18[2]
		end
	end

	return nil
end

function var0_0.UpdateOrderBtn(arg0_19)
	setActive(arg0_19.uiOrderTimeTF, false)

	arg0_19.orderData = arg0_19.activity:GetOrderData()

	if arg0_19.orderData.id ~= 0 then
		if pg.TimeMgr.GetInstance():GetServerTime() < arg0_19.orderData:GetEndTime() then
			setActive(arg0_19.uiOrderTimeTF, true)
			arg0_19:StartTimer()
		end
	else
		arg0_19:StopTimer()
	end
end

function var0_0.UpdateTips(arg0_20)
	setActive(arg0_20.uiMallTip, var0_0.IsMallTip())
	arg0_20:UpdateOrderTip()
end

function var0_0.UpdateOrderTip(arg0_21)
	setActive(arg0_21.uiOrderTip, MallScene.IsOrderTip())
end

function var0_0.UpdatePointTpl(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.showPointIds[arg1_22 + 1]

	arg2_22.name = var0_22

	local var1_22 = pg.activity_mall_story[var0_22]

	setAnchoredPosition(arg2_22, {
		x = var1_22.posion[1],
		y = var1_22.posion[2]
	})

	local var2_22 = var1_22.type
	local var3_22 = var0_0.TYPE2INFOS[var2_22]

	GetImageSpriteFromAtlasAsync("ui/mallmapui_atlas", var3_22[1], arg2_22:Find("name"), true)
	setText(arg2_22:Find("name/Text"), var3_22[2])

	local var4_22 = var2_22 == MallActivity.POINT_TYPE.INTERACT_STORY

	setActive(arg2_22:Find("ship"), var4_22)
	setActive(arg2_22:Find("icon"), not var4_22)

	if var4_22 then
		GetImageSpriteFromAtlasAsync(var1_22.icon, "", arg2_22:Find("ship"))
	else
		GetImageSpriteFromAtlasAsync("ui/mallmapui_atlas", var3_22[3], arg2_22:Find("icon"), true)
	end

	onButton(arg0_22, arg2_22, function()
		if not table.contains(arg0_22.triggeredIds, var0_22) then
			arg0_22:emit(MallMapMediator.TRIGGER_POINT, arg0_22.activity.id, var0_22)
		end

		if var2_22 == MallActivity.POINT_TYPE.SITE then
			arg0_22.siteBox:ExecuteAction("Show", var0_22)
		else
			pg.NewStoryMgr.GetInstance():Play(var1_22.lua, function()
				arg0_22:didEnter()
			end)
		end
	end, SFX_PANEL)
end

function var0_0.StartTimer(arg0_25)
	arg0_25:StopTimer()

	arg0_25.orderEndTime = arg0_25.orderData:GetEndTime()
	arg0_25.timer = Timer.New(function()
		local var0_26 = arg0_25.orderEndTime - pg.TimeMgr.GetInstance():GetServerTime()

		setText(arg0_25.uiOrderTimeTF:Find("Text"), pg.TimeMgr.GetInstance():DescCDTime(var0_26))

		if var0_26 <= 0 then
			arg0_25:UpdateOrderBtn()
			setActive(arg0_25.uiOrderTip, true)
		end
	end, 1, -1)

	arg0_25.timer:Start()
	arg0_25.timer.func()
end

function var0_0.StopTimer(arg0_27)
	if arg0_27.timer then
		arg0_27.timer:Stop()

		arg0_27.timer = nil
	end
end

function var0_0.ShowSummaryBox(arg0_28)
	arg0_28.summaryBox:ExecuteAction("Show")
end

function var0_0.onBackPressed(arg0_29)
	if arg0_29.siteBox and arg0_29.siteBox:isShowing() then
		arg0_29.siteBox:ExecuteAction("Hide")

		return
	end

	if arg0_29.summaryBox and arg0_29.summaryBox:isShowing() then
		arg0_29.summaryBox:ExecuteAction("Hide")

		return
	end

	var0_0.super.onBackPressed(arg0_29)
end

function var0_0.willExit(arg0_30)
	if arg0_30.siteBox then
		arg0_30.siteBox:Destroy()

		arg0_30.siteBox = nil
	end

	if arg0_30.summaryBox then
		arg0_30.summaryBox:Destroy()

		arg0_30.summaryBox = nil
	end

	arg0_30:StopTimer()
end

function var0_0.IsMallTip()
	return MallScene.IsAwardTip() or MallScene.IsOrderTip()
end

function var0_0.IsEntranceTip()
	local var0_32 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)

	if not var0_32 or var0_32:isEnd() then
		return false
	end

	return MallScene.IsMapTip() or var0_0.IsMallTip()
end

return var0_0
