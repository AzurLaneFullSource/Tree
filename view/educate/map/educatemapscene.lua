local var0 = class("EducateMapScene", import("..base.EducateBaseUI"))

function var0.getUIName(arg0)
	return "EducateMapUI"
end

function var0.preload(arg0, arg1)
	if getProxy(EducateProxy):NeedRequestOptsData() then
		pg.m02:sendNotification(GAME.EDUCATE_REQUEST_OPTION, {
			callback = arg1
		})
	else
		arg1()
	end
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	arg0.config = pg.child_site
	arg0.siteIdList = getProxy(EducateProxy):GetShowSiteIds()
end

function var0.findUI(arg0)
	arg0.topTF = arg0:findTF("ui/top")
	arg0.homeBtn = arg0:findTF("ui/home_btn/home_btn")

	setText(arg0:findTF("Text", arg0.homeBtn), i18n("child_btn_home"))

	arg0.mapTF = arg0:findTF("map")
	arg0.mapContent = arg0:findTF("content", arg0.mapTF)
	arg0.mapSiteTpl = arg0:findTF("site_tpl", arg0.mapTF)

	setText(arg0:findTF("limit/Text", arg0.mapSiteTpl), i18n("child_option_limit"))
	setActive(arg0.mapSiteTpl, false)

	arg0.siteUIList = UIItemList.New(arg0.mapContent, arg0.mapSiteTpl)
	arg0.datePanel = EducateDatePanel.New(arg0:findTF("date", arg0.topTF), arg0.event)

	arg0.datePanel:Load()

	arg0.resPanel = EducateResPanel.New(arg0:findTF("res", arg0.topTF), arg0.event, {
		showBg = true
	})

	arg0.resPanel:Load()

	arg0.topPanel = EducateTopPanel.New(arg0:findTF("top_right", arg0.topTF), arg0.event)

	arg0.topPanel:Load()

	arg0.targetPanel = EducateTargetPanel.New(arg0:findTF("ui/target"), arg0.event)

	arg0.targetPanel:Load()

	arg0.archivePanel = EducateArchivePanel.New(arg0:findTF("ui/archive_panel"), arg0.event)

	arg0.archivePanel:Load()

	arg0.detailPanel = EducateSiteDetailPanel.New(arg0:findTF("ui/detail_panel"), arg0.event, {
		onEnter = function()
			arg0:MoveTargetPanelLeft()
		end,
		onExit = function()
			arg0:MoveTargetPanelRight()
		end
	})

	arg0.detailPanel:Load()
end

function var0.addListener(arg0)
	onButton(arg0, arg0.homeBtn, function()
		arg0:emit(EducateBaseUI.EDUCATE_CHANGE_SCENE, SCENE.EDUCATE)
	end, SFX_PANEL)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.topTF, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData()
	})
	arg0.siteUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateSiteItem(arg1, arg2)
		end
	end)
	arg0.siteUIList:align(#arg0.siteIdList)
	arg0:playAnim()
	arg0:CheckTips(function()
		arg0.siteUIList:align(#arg0.siteIdList)
	end)
end

function var0.playAnim(arg0)
	arg0.siteUIList:each(function(arg0, arg1)
		setActive(arg1, false)
	end)

	local var0 = {}

	table.insert(var0, function(arg0)
		arg0:managedTween(LeanTween.delayedCall, function()
			arg0()
		end, 0.165, nil)
	end)

	for iter0 = 1, #arg0.siteIdList do
		table.insert(var0, function(arg0)
			setActive(arg0.siteUIList.container:GetChild(iter0 - 1), true)
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0()
			end, 0.033, nil)
		end)
	end

	seriesAsync(var0, function()
		return
	end)
end

function var0.CheckTips(arg0, arg1)
	local var0 = {}
	local var1 = EducateTipHelper.GetSiteUnlockTipIds()

	if #var1 > 0 then
		arg0:emit(var0.EDUCATE_ON_UNLOCK_TIP, {
			type = EducateUnlockTipLayer.UNLOCK_TYPE_SITE,
			list = var1,
			onExit = arg1
		})
	end
end

function var0.updateSiteItem(arg0, arg1, arg2)
	local var0 = arg0.config[arg0.siteIdList[arg1 + 1]]

	arg2.name = var0.id

	LoadImageSpriteAsync("educatesite/" .. var0.icon, arg0:findTF("icon", arg2), true)
	LoadImageSpriteAsync("educatesite/" .. var0.name_pic, arg0:findTF("name", arg2), true)

	local var1 = getProxy(EducateProxy):GetOptionsBySiteId(var0.id)
	local var2 = underscore.any(var1, function(arg0)
		return arg0:IsShowLimit()
	end)

	setActive(arg0:findTF("limit", arg2), var2)
	setActive(arg0:findTF("new", arg2), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_SITE, var0.id))
	setAnchoredPosition(arg2, {
		x = var0.coordinate[1],
		y = var0.coordinate[2]
	})
	onButton(arg0, arg2, function()
		arg0.detailPanel:Show(var0.id)
	end, SFX_PANEL)
end

function var0.clearNewTip(arg0, arg1)
	eachChild(arg0.mapContent, function(arg0)
		if tonumber(arg0.name) == arg1 then
			setActive(arg0:findTF("new", arg0), false)
		end
	end)
end

function var0.updateRes(arg0)
	arg0.resPanel:Flush()
end

function var0.updateAttrs(arg0)
	arg0.archivePanel:Flush()
end

function var0.updateTime(arg0)
	arg0.siteUIList:align(#arg0.siteIdList)
	arg0.datePanel:Flush()
end

function var0.updateTarget(arg0)
	arg0.targetPanel:Flush()
end

function var0.updateTimeWeekDay(arg0, arg1)
	arg0.datePanel:UpdateWeekDay(arg1)
end

function var0.MoveTargetPanelLeft(arg0)
	arg0.targetPanel:SetPosLeft()
end

function var0.MoveTargetPanelRight(arg0)
	arg0.targetPanel:SetPosRight()
end

function var0.ShowSpecEvent(arg0, arg1, arg2, arg3, arg4)
	arg0.detailPanel:showSpecEvent(arg1, arg2, arg3, arg4)
end

function var0.ShowSitePerform(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0.detailPanel:showSitePerform(arg1, arg2, arg3, arg4, arg5)
end

function var0.onBackPressed(arg0)
	if arg0.detailPanel:isShowing() then
		arg0.detailPanel:onClose()
	else
		arg0:emit(var0.ON_BACK_PRESSED)
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.topTF, arg0:findTF("ui"))
	arg0.datePanel:Destroy()

	arg0.datePanel = nil

	arg0.resPanel:Destroy()

	arg0.resPanel = nil

	arg0.topPanel:Destroy()

	arg0.topPanel = nil

	arg0.targetPanel:Destroy()

	arg0.targetPanel = nil

	arg0.archivePanel:Destroy()

	arg0.archivePanel = nil

	arg0.detailPanel:Destroy()

	arg0.detailPanel = nil
end

return var0
