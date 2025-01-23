local var0_0 = class("EducateMapScene", import("..base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateMapUI"
end

function var0_0.preload(arg0_2, arg1_2)
	if getProxy(EducateProxy):NeedRequestOptsData() then
		pg.m02:sendNotification(GAME.EDUCATE_REQUEST_OPTION, {
			callback = arg1_2
		})
	else
		arg1_2()
	end
end

function var0_0.init(arg0_3)
	arg0_3:initData()
	arg0_3:findUI()
	arg0_3:addListener()
end

function var0_0.initData(arg0_4)
	arg0_4.config = pg.child_site
	arg0_4.siteIdList = getProxy(EducateProxy):GetShowSiteIds()
end

function var0_0.findUI(arg0_5)
	arg0_5.topTF = arg0_5:findTF("ui/top")
	arg0_5.homeBtn = arg0_5:findTF("ui/home_btn/home_btn")

	setText(arg0_5:findTF("Text", arg0_5.homeBtn), i18n("child_btn_home"))
	setActive(arg0_5.homeBtn, false)

	arg0_5.mapTF = arg0_5:findTF("map")
	arg0_5.mapContent = arg0_5:findTF("content", arg0_5.mapTF)
	arg0_5.mapSiteTpl = arg0_5:findTF("site_tpl", arg0_5.mapTF)

	setText(arg0_5:findTF("limit/Text", arg0_5.mapSiteTpl), i18n("child_option_limit"))
	setActive(arg0_5.mapSiteTpl, false)

	arg0_5.siteUIList = UIItemList.New(arg0_5.mapContent, arg0_5.mapSiteTpl)
	arg0_5.datePanel = EducateDatePanel.New(arg0_5:findTF("date", arg0_5.topTF), arg0_5.event)

	arg0_5.datePanel:Load()

	arg0_5.resPanel = EducateResPanel.New(arg0_5:findTF("res", arg0_5.topTF), arg0_5.event, {
		showBg = true
	})

	arg0_5.resPanel:Load()

	arg0_5.topPanel = EducateTopPanel.New(arg0_5:findTF("top_right", arg0_5.topTF), arg0_5.event)

	arg0_5.topPanel:Load()

	arg0_5.targetPanel = EducateTargetPanel.New(arg0_5:findTF("ui/target"), arg0_5.event)

	arg0_5.targetPanel:Load()

	arg0_5.archivePanel = EducateArchivePanel.New(arg0_5:findTF("ui/archive_panel"), arg0_5.event)

	arg0_5.archivePanel:Load()

	arg0_5.detailPanel = EducateSiteDetailPanel.New(arg0_5:findTF("ui/detail_panel"), arg0_5.event, {
		onEnter = function()
			arg0_5:MoveTargetPanelLeft()
		end,
		onExit = function()
			arg0_5:MoveTargetPanelRight()
		end
	})

	arg0_5.detailPanel:Load()
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.homeBtn, function()
		arg0_8:emit(EducateBaseUI.EDUCATE_CHANGE_SCENE, SCENE.EDUCATE)
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_10)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_10.topTF, {
		groupName = arg0_10:getGroupNameFromData(),
		weight = arg0_10:getWeightFromData()
	})
	arg0_10.siteUIList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_10:updateSiteItem(arg1_11, arg2_11)
		end
	end)
	arg0_10.siteUIList:align(#arg0_10.siteIdList)
	arg0_10:playAnim()
	arg0_10:CheckTips(function()
		arg0_10.siteUIList:align(#arg0_10.siteIdList)
	end)
end

function var0_0.playAnim(arg0_13)
	arg0_13.siteUIList:each(function(arg0_14, arg1_14)
		setActive(arg1_14, false)
	end)

	local var0_13 = {}

	table.insert(var0_13, function(arg0_15)
		arg0_13:managedTween(LeanTween.delayedCall, function()
			arg0_15()
		end, 0.165, nil)
	end)

	for iter0_13 = 1, #arg0_13.siteIdList do
		table.insert(var0_13, function(arg0_17)
			setActive(arg0_13.siteUIList.container:GetChild(iter0_13 - 1), true)
			arg0_13:managedTween(LeanTween.delayedCall, function()
				arg0_17()
			end, 0.033, nil)
		end)
	end

	seriesAsync(var0_13, function()
		return
	end)
end

function var0_0.CheckTips(arg0_20, arg1_20)
	local var0_20 = {}
	local var1_20 = EducateTipHelper.GetSiteUnlockTipIds()

	if #var1_20 > 0 then
		arg0_20:emit(var0_0.EDUCATE_ON_UNLOCK_TIP, {
			type = EducateUnlockTipLayer.UNLOCK_TYPE_SITE,
			list = var1_20,
			onExit = arg1_20
		})
	end
end

function var0_0.updateSiteItem(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.config[arg0_21.siteIdList[arg1_21 + 1]]

	arg2_21.name = var0_21.id

	LoadImageSpriteAsync("educatesite/" .. var0_21.icon, arg0_21:findTF("icon", arg2_21), true)
	LoadImageSpriteAsync("educatesite/" .. var0_21.name_pic, arg0_21:findTF("name", arg2_21), true)

	local var1_21 = getProxy(EducateProxy):GetOptionsBySiteId(var0_21.id)
	local var2_21 = underscore.any(var1_21, function(arg0_22)
		return arg0_22:IsShowLimit()
	end)

	setActive(arg0_21:findTF("limit", arg2_21), var2_21)
	setActive(arg0_21:findTF("new", arg2_21), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_SITE, var0_21.id))
	setAnchoredPosition(arg2_21, {
		x = var0_21.coordinate[1],
		y = var0_21.coordinate[2]
	})
	onButton(arg0_21, arg2_21, function()
		arg0_21.detailPanel:Show(var0_21.id)
	end, SFX_PANEL)
end

function var0_0.clearNewTip(arg0_24, arg1_24)
	eachChild(arg0_24.mapContent, function(arg0_25)
		if tonumber(arg0_25.name) == arg1_24 then
			setActive(arg0_24:findTF("new", arg0_25), false)
		end
	end)
end

function var0_0.updateRes(arg0_26)
	arg0_26.resPanel:Flush()
end

function var0_0.updateAttrs(arg0_27)
	arg0_27.archivePanel:Flush()
end

function var0_0.updateTime(arg0_28)
	arg0_28.siteUIList:align(#arg0_28.siteIdList)
	arg0_28.datePanel:Flush()
end

function var0_0.updateTarget(arg0_29)
	arg0_29.targetPanel:Flush()
end

function var0_0.updateTimeWeekDay(arg0_30, arg1_30)
	arg0_30.datePanel:UpdateWeekDay(arg1_30)
end

function var0_0.MoveTargetPanelLeft(arg0_31)
	arg0_31.targetPanel:SetPosLeft()
end

function var0_0.MoveTargetPanelRight(arg0_32)
	arg0_32.targetPanel:SetPosRight()
end

function var0_0.ShowSpecEvent(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	arg0_33.detailPanel:showSpecEvent(arg1_33, arg2_33, arg3_33, arg4_33)
end

function var0_0.ShowSitePerform(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34, arg5_34)
	arg0_34.detailPanel:showSitePerform(arg1_34, arg2_34, arg3_34, arg4_34, arg5_34)
end

function var0_0.onBackPressed(arg0_35)
	if arg0_35.detailPanel:isShowing() then
		arg0_35.detailPanel:onClose()
	else
		arg0_35:emit(var0_0.ON_BACK_PRESSED)
	end
end

function var0_0.willExit(arg0_36)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_36.topTF, arg0_36:findTF("ui"))
	arg0_36.datePanel:Destroy()

	arg0_36.datePanel = nil

	arg0_36.resPanel:Destroy()

	arg0_36.resPanel = nil

	arg0_36.topPanel:Destroy()

	arg0_36.topPanel = nil

	arg0_36.targetPanel:Destroy()

	arg0_36.targetPanel = nil

	arg0_36.archivePanel:Destroy()

	arg0_36.archivePanel = nil

	arg0_36.detailPanel:Destroy()

	arg0_36.detailPanel = nil
end

return var0_0
