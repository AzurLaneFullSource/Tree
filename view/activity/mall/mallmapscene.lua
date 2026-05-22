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
	arg0_12:CheckOrderStory()
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

function var0_0.CheckOrderStory(arg0_14)
	local var0_14 = arg0_14.activity:GetOrderData():GetFinishedList()
	local var1_14 = {}

	for iter0_14, iter1_14 in ipairs(var0_14) do
		local var2_14 = pg.activity_mall_custom_order[iter1_14].story_unlock

		if var2_14 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var2_14) then
			table.insert(var1_14, var2_14)
		end
	end

	if #var1_14 > 0 then
		local var3_14 = {}

		for iter2_14, iter3_14 in ipairs(var1_14) do
			table.insert(var3_14, function(arg0_15)
				pg.NewStoryMgr.GetInstance():Play(iter3_14, arg0_15)
			end)
		end

		seriesAsync(var3_14, function()
			return
		end)
	end
end

function var0_0.UpdateData(arg0_17)
	arg0_17.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)

	assert(arg0_17.activity and not arg0_17.activity:isEnd(), "not exist mall act, type: " .. ActivityConst.ACTIVITY_TYPE_MALL)

	arg0_17.triggeredIds = arg0_17.activity:GetTriggeredPointIds()

	local var0_17 = arg0_17.activity:GetLevelData():GetUnlockStoryIdsByType()

	arg0_17.showPointIds = {}

	for iter0_17, iter1_17 in pairs(var0_17) do
		local var1_17 = iter0_17 ~= MallActivity.POINT_TYPE.SITE
		local var2_17 = underscore.detect(iter1_17, function(arg0_18)
			local var0_18 = pg.activity_mall_story[arg0_18]

			return not table.contains(arg0_17.triggeredIds, arg0_18) or var1_17 and var0_18.lua ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_18.lua)
		end)

		if var2_17 then
			table.insert(arg0_17.showPointIds, var2_17)
		end
	end

	arg0_17.bgConfig = arg0_17.activity:getConfig("config_client").bg_switch
end

function var0_0.UpdateView(arg0_19)
	arg0_19.pointUIList:align(#arg0_19.showPointIds)
	arg0_19:UpdateOrderBtn()
	arg0_19:UpdateTips()
end

function var0_0.UpdateBg(arg0_20)
	local var0_20 = arg0_20:GetCurBg()

	if var0_20 then
		setImageSprite(arg0_20.uiBgTF, LoadSprite("bg/" .. var0_20), false)
	end
end

function var0_0.GetCurBg(arg0_21)
	for iter0_21 = #arg0_21.bgConfig, 1, -1 do
		local var0_21 = arg0_21.bgConfig[iter0_21]

		if pg.NewStoryMgr.GetInstance():IsPlayed(var0_21[1]) then
			return var0_21[2]
		end
	end

	return nil
end

function var0_0.UpdateOrderBtn(arg0_22)
	setActive(arg0_22.uiOrderTimeTF, false)

	arg0_22.orderData = arg0_22.activity:GetOrderData()

	if arg0_22.orderData.id ~= 0 then
		if pg.TimeMgr.GetInstance():GetServerTime() < arg0_22.orderData:GetEndTime() then
			setActive(arg0_22.uiOrderTimeTF, true)
			arg0_22:StartTimer()
		end
	else
		arg0_22:StopTimer()
	end
end

function var0_0.UpdateTips(arg0_23)
	setActive(arg0_23.uiMallTip, var0_0.IsMallTip())
	arg0_23:UpdateOrderTip()
end

function var0_0.UpdateOrderTip(arg0_24)
	setActive(arg0_24.uiOrderTip, MallScene.IsOrderTip())
end

function var0_0.UpdatePointTpl(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.showPointIds[arg1_25 + 1]

	arg2_25.name = var0_25

	local var1_25 = pg.activity_mall_story[var0_25]

	setAnchoredPosition(arg2_25, {
		x = var1_25.posion[1],
		y = var1_25.posion[2]
	})

	local var2_25 = var1_25.type
	local var3_25 = var0_0.TYPE2INFOS[var2_25]

	GetImageSpriteFromAtlasAsync("ui/mallmapui_atlas", var3_25[1], arg2_25:Find("name"), true)
	setText(arg2_25:Find("name/Text"), var3_25[2])

	local var4_25 = var2_25 == MallActivity.POINT_TYPE.INTERACT_STORY

	setActive(arg2_25:Find("ship"), var4_25)
	setActive(arg2_25:Find("icon"), not var4_25)

	if var4_25 then
		GetImageSpriteFromAtlasAsync(var1_25.icon, "", arg2_25:Find("ship"))
	else
		GetImageSpriteFromAtlasAsync("ui/mallmapui_atlas", var3_25[3], arg2_25:Find("icon"), true)
	end

	onButton(arg0_25, arg2_25, function()
		if not table.contains(arg0_25.triggeredIds, var0_25) then
			arg0_25:emit(MallMapMediator.TRIGGER_POINT, arg0_25.activity.id, var0_25)
		end

		if var2_25 == MallActivity.POINT_TYPE.SITE then
			arg0_25.siteBox:ExecuteAction("Show", var0_25)
		else
			pg.NewStoryMgr.GetInstance():Play(var1_25.lua, function()
				arg0_25:didEnter()
			end)
		end
	end, SFX_PANEL)
end

function var0_0.StartTimer(arg0_28)
	arg0_28:StopTimer()

	arg0_28.orderEndTime = arg0_28.orderData:GetEndTime()
	arg0_28.timer = Timer.New(function()
		local var0_29 = arg0_28.orderEndTime - pg.TimeMgr.GetInstance():GetServerTime()

		setText(arg0_28.uiOrderTimeTF:Find("Text"), pg.TimeMgr.GetInstance():DescCDTime(var0_29))

		if var0_29 <= 0 then
			arg0_28:UpdateOrderBtn()
			setActive(arg0_28.uiOrderTip, true)
		end
	end, 1, -1)

	arg0_28.timer:Start()
	arg0_28.timer.func()
end

function var0_0.StopTimer(arg0_30)
	if arg0_30.timer then
		arg0_30.timer:Stop()

		arg0_30.timer = nil
	end
end

function var0_0.ShowSummaryBox(arg0_31)
	arg0_31.summaryBox:ExecuteAction("Show")
end

function var0_0.onBackPressed(arg0_32)
	if arg0_32.siteBox and arg0_32.siteBox:isShowing() then
		arg0_32.siteBox:ExecuteAction("Hide")

		return
	end

	if arg0_32.summaryBox and arg0_32.summaryBox:isShowing() then
		arg0_32.summaryBox:ExecuteAction("Hide")

		return
	end

	var0_0.super.onBackPressed(arg0_32)
end

function var0_0.willExit(arg0_33)
	if arg0_33.siteBox then
		arg0_33.siteBox:Destroy()

		arg0_33.siteBox = nil
	end

	if arg0_33.summaryBox then
		arg0_33.summaryBox:Destroy()

		arg0_33.summaryBox = nil
	end

	arg0_33:StopTimer()
end

function var0_0.IsMallTip()
	return MallScene.IsAwardTip() or MallScene.IsOrderTip()
end

function var0_0.IsEntranceTip()
	local var0_35 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)

	if not var0_35 or var0_35:isEnd() then
		return false
	end

	return MallScene.IsMapTip() or var0_0.IsMallTip()
end

return var0_0
