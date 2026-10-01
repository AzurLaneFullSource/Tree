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

function var0_0.getResource(arg0_3)
	local var0_3 = var0_0.super.getResource(arg0_3)
	local var1_3 = {
		"ui/EducateDatePanel",
		"ui/EducateResPanel",
		"ui/EducateTopPanel",
		"ui/EducateTargetPanel",
		"ui/EducateArchivePanel",
		"ui/EducateSiteDetailUI",
		"ui/educatecommonui_atlas"
	}

	local function var2_3(arg0_4)
		if noEmptyStr(arg0_4) and not table.contains(var1_3, arg0_4) then
			table.insert(var1_3, arg0_4)
		end
	end

	local var3_3 = getProxy(EducateProxy)
	local var4_3 = var3_3 and var3_3:GetShowSiteIds() or {}

	for iter0_3, iter1_3 in ipairs(var4_3) do
		local var5_3 = pg.child_site[iter1_3]

		if var5_3 then
			var2_3("educatesite/" .. var5_3.icon)
			var2_3("educatesite/" .. var5_3.name_pic)
			var2_3("educatesite/" .. var5_3.pic)

			for iter2_3, iter3_3 in ipairs(var5_3.option or {}) do
				local var6_3 = pg.child_site_option[iter3_3]

				if var6_3 and var6_3.type == EducateSiteOption.TYPE_SITE then
					local var7_3 = var6_3.param[1]
					local var8_3 = pg.child_site[var7_3]

					if var8_3 then
						var2_3("educatesite/" .. var8_3.pic)
					end
				end
			end
		end
	end

	for iter4_3, iter5_3 in ipairs(var1_3) do
		if not table.contains(var0_3, iter5_3) then
			table.insert(var0_3, iter5_3)
		end
	end

	return var0_3
end

function var0_0.init(arg0_5)
	arg0_5:initData()
	arg0_5:findUI()
	arg0_5:addListener()
end

function var0_0.initData(arg0_6)
	arg0_6.config = pg.child_site
	arg0_6.siteIdList = getProxy(EducateProxy):GetShowSiteIds()
end

function var0_0.findUI(arg0_7)
	arg0_7.topTF = arg0_7._tf:Find("ui/top")
	arg0_7.homeBtn = arg0_7._tf:Find("ui/home_btn/home_btn")

	setText(arg0_7.homeBtn:Find("Text"), i18n("child_btn_home"))
	setActive(arg0_7.homeBtn, false)

	arg0_7.mapTF = arg0_7._tf:Find("map")
	arg0_7.mapContent = arg0_7.mapTF:Find("content")
	arg0_7.mapSiteTpl = arg0_7.mapTF:Find("site_tpl")

	setText(arg0_7.mapSiteTpl:Find("limit/Text"), i18n("child_option_limit"))
	setActive(arg0_7.mapSiteTpl, false)

	arg0_7.siteUIList = UIItemList.New(arg0_7.mapContent, arg0_7.mapSiteTpl)
	arg0_7.datePanel = EducateDatePanel.New(arg0_7.topTF:Find("date"), arg0_7.event)

	arg0_7.datePanel:RegisterView(arg0_7)
	arg0_7.datePanel:Load()

	arg0_7.resPanel = EducateResPanel.New(arg0_7.topTF:Find("res"), arg0_7.event, {
		showBg = true
	})

	arg0_7.resPanel:RegisterView(arg0_7)
	arg0_7.resPanel:Load()

	arg0_7.topPanel = EducateTopPanel.New(arg0_7.topTF:Find("top_right"), arg0_7.event)

	arg0_7.topPanel:RegisterView(arg0_7)
	arg0_7.topPanel:Load()

	arg0_7.targetPanel = EducateTargetPanel.New(arg0_7._tf:Find("ui/target"), arg0_7.event)

	arg0_7.targetPanel:RegisterView(arg0_7)
	arg0_7.targetPanel:Load()

	arg0_7.archivePanel = EducateArchivePanel.New(arg0_7._tf:Find("ui/archive_panel"), arg0_7.event)

	arg0_7.archivePanel:RegisterView(arg0_7)
	arg0_7.archivePanel:Load()

	arg0_7.detailPanel = EducateSiteDetailPanel.New(arg0_7._tf:Find("ui/detail_panel"), arg0_7.event, {
		onEnter = function()
			arg0_7:MoveTargetPanelLeft()
		end,
		onExit = function()
			arg0_7:MoveTargetPanelRight()
		end
	})

	arg0_7.detailPanel:RegisterView(arg0_7)
	arg0_7.detailPanel:Load()
end

function var0_0.addListener(arg0_10)
	onButton(arg0_10, arg0_10.homeBtn, function()
		arg0_10:emit(EducateBaseUI.EDUCATE_CHANGE_SCENE, SCENE.EDUCATE)
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_12)
	arg0_12:OverlayPanel(arg0_12.topTF)
	arg0_12.siteUIList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			arg0_12:updateSiteItem(arg1_13, arg2_13)
		end
	end)
	arg0_12.siteUIList:align(#arg0_12.siteIdList)
	arg0_12:playAnim()
	arg0_12:CheckTips(function()
		arg0_12.siteUIList:align(#arg0_12.siteIdList)
	end)
end

function var0_0.playAnim(arg0_15)
	arg0_15.siteUIList:each(function(arg0_16, arg1_16)
		setActive(arg1_16, false)
	end)

	local var0_15 = {}

	table.insert(var0_15, function(arg0_17)
		arg0_15:managedTween(LeanTween.delayedCall, function()
			arg0_17()
		end, 0.165, nil)
	end)

	for iter0_15 = 1, #arg0_15.siteIdList do
		table.insert(var0_15, function(arg0_19)
			setActive(arg0_15.siteUIList.container:GetChild(iter0_15 - 1), true)
			arg0_15:managedTween(LeanTween.delayedCall, function()
				arg0_19()
			end, 0.033, nil)
		end)
	end

	seriesAsync(var0_15, function()
		return
	end)
end

function var0_0.CheckTips(arg0_22, arg1_22)
	local var0_22 = {}
	local var1_22 = EducateTipHelper.GetSiteUnlockTipIds()

	if #var1_22 > 0 then
		arg0_22:emit(var0_0.EDUCATE_ON_UNLOCK_TIP, {
			type = EducateUnlockTipLayer.UNLOCK_TYPE_SITE,
			list = var1_22,
			onExit = arg1_22
		})
	end
end

function var0_0.updateSiteItem(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.config[arg0_23.siteIdList[arg1_23 + 1]]

	arg2_23.name = var0_23.id

	LoadImageSpriteAsync("educatesite/" .. var0_23.icon, arg2_23:Find("icon"), true)
	LoadImageSpriteAsync("educatesite/" .. var0_23.name_pic, arg2_23:Find("name"), true)

	local var1_23 = getProxy(EducateProxy):GetOptionsBySiteId(var0_23.id)
	local var2_23 = underscore.any(var1_23, function(arg0_24)
		return arg0_24:IsShowLimit()
	end)

	setActive(arg2_23:Find("limit"), var2_23)
	setActive(arg2_23:Find("new"), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_SITE, var0_23.id))
	setAnchoredPosition(arg2_23, {
		x = var0_23.coordinate[1],
		y = var0_23.coordinate[2]
	})
	onButton(arg0_23, arg2_23, function()
		arg0_23.detailPanel:Show(var0_23.id)
	end, SFX_PANEL)
end

function var0_0.clearNewTip(arg0_26, arg1_26)
	eachChild(arg0_26.mapContent, function(arg0_27)
		if tonumber(arg0_27.name) == arg1_26 then
			setActive(arg0_27:Find("new"), false)
		end
	end)
end

function var0_0.updateRes(arg0_28)
	arg0_28.resPanel:Flush()
end

function var0_0.updateAttrs(arg0_29)
	arg0_29.archivePanel:Flush()
end

function var0_0.updateTime(arg0_30)
	arg0_30.siteUIList:align(#arg0_30.siteIdList)
	arg0_30.datePanel:Flush()
end

function var0_0.updateTarget(arg0_31)
	arg0_31.targetPanel:Flush()
end

function var0_0.updateTimeWeekDay(arg0_32, arg1_32)
	arg0_32.datePanel:UpdateWeekDay(arg1_32)
end

function var0_0.MoveTargetPanelLeft(arg0_33)
	arg0_33.targetPanel:SetPosLeft()
end

function var0_0.MoveTargetPanelRight(arg0_34)
	arg0_34.targetPanel:SetPosRight()
end

function var0_0.ShowSpecEvent(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35)
	arg0_35.detailPanel:showSpecEvent(arg1_35, arg2_35, arg3_35, arg4_35)
end

function var0_0.ShowSitePerform(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36, arg5_36)
	arg0_36.detailPanel:showSitePerform(arg1_36, arg2_36, arg3_36, arg4_36, arg5_36)
end

function var0_0.onBackPressed(arg0_37)
	if arg0_37.detailPanel:isShowing() then
		arg0_37.detailPanel:onClose()
	else
		arg0_37:emit(var0_0.ON_BACK_PRESSED)
	end
end

function var0_0.willExit(arg0_38)
	arg0_38:UnOverlayPanel(arg0_38.topTF, arg0_38._tf:Find("ui"))
	arg0_38.datePanel:Destroy()

	arg0_38.datePanel = nil

	arg0_38.resPanel:Destroy()

	arg0_38.resPanel = nil

	arg0_38.topPanel:Destroy()

	arg0_38.topPanel = nil

	arg0_38.targetPanel:Destroy()

	arg0_38.targetPanel = nil

	arg0_38.archivePanel:Destroy()

	arg0_38.archivePanel = nil

	arg0_38.detailPanel:Destroy()

	arg0_38.detailPanel = nil
end

return var0_0
