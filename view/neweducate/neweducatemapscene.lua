local var0_0 = class("NewEducateMapScene", import("view.newEducate.base.NewEducateBaseUI"))

var0_0.DEFAULT_SCALE = 1
var0_0.SCALE = 1.15
var0_0.SPEED = 65
var0_0.ALPHA_TIME = 0.25

function var0_0.getUIName(arg0_1)
	return "NewEducateMapUI"
end

function var0_0.SetData(arg0_2)
	arg0_2.shopSiteId = arg0_2.contextData.char:GetSiteId(NewEducateConst.SITE_TYPE.SHOP)
	arg0_2.workSiteId = arg0_2.contextData.char:GetSiteId(NewEducateConst.SITE_TYPE.WORK)
	arg0_2.travelSiteId = arg0_2.contextData.char:GetSiteId(NewEducateConst.SITE_TYPE.TRAVEL)
end

function var0_0.init(arg0_3)
	arg0_3.uiTF = arg0_3._tf:Find("ui")
	arg0_3.mapTF = arg0_3._tf:Find("map")

	setLocalScale(arg0_3.mapTF, {
		x = var0_0.DEFAULT_SCALE,
		y = var0_0.DEFAULT_SCALE,
		z = var0_0.DEFAULT_SCALE
	})

	arg0_3.travelTF = arg0_3.mapTF:Find("content/travel")
	arg0_3.workTF = arg0_3.mapTF:Find("content/work")
	arg0_3.shopTF = arg0_3.mapTF:Find("content/shop")

	local var0_3 = arg0_3.mapTF:Find("content/events")

	arg0_3.eventUIList = UIItemList.New(var0_3, var0_3:Find("tpl"))

	local var1_3 = arg0_3.mapTF:Find("content/ships")

	arg0_3.shipUIList = UIItemList.New(var1_3, var1_3:Find("tpl"))
	arg0_3.personalityTipPanel = NewEducatePersonalityTipPanel.New(arg0_3.adaptTF, arg0_3.event, arg0_3.contextData)

	arg0_3.personalityTipPanel:RegisterView(arg0_3)

	arg0_3.topPanel = NewEducateTopPanel.New(arg0_3.uiTF, arg0_3.event, setmetatable({
		showBack = true
	}, {
		__index = arg0_3.contextData
	}))

	arg0_3.topPanel:RegisterView(arg0_3)

	arg0_3.infoPanel = NewEducateInfoPanel.New(arg0_3.uiTF, arg0_3.event, setmetatable({
		hide = true
	}, {
		__index = arg0_3.contextData
	}))

	arg0_3.infoPanel:RegisterView(arg0_3)

	arg0_3.detailPanel = NewEducateSiteDetailPanel.New(arg0_3.uiTF, arg0_3.event, setmetatable({
		onHide = function()
			arg0_3:OnDetailHide()
		end,
		onClickUpEntryGood = function(arg0_5)
			arg0_3:onClickUpEntryGood(arg0_5)
		end
	}, {
		__index = arg0_3.contextData
	}))

	arg0_3.detailPanel:RegisterView(arg0_3)

	arg0_3.nodePanel = NewEducateNodePanel.New(arg0_3.adaptTF, arg0_3.event, setmetatable({
		onHide = function()
			arg0_3:OnDetailHide()
			arg0_3:FlushView()
		end,
		onSiteEnd = function()
			arg0_3:ShowInfoUI(true)
		end,
		onNormal = function()
			arg0_3.infoPanel:ExecuteAction("HidePanel", true)
			arg0_3.topPanel:ExecuteAction("Hide")
		end,
		view = arg0_3
	}, {
		__index = arg0_3.contextData
	}))

	arg0_3.nodePanel:RegisterView(arg0_3)

	arg0_3.extendLimit = Vector2(arg0_3.mapTF.rect.width - arg0_3._tf.rect.width, arg0_3.mapTF.rect.height - arg0_3._tf.rect.height) / 2
	arg0_3.duration = 0.5
	arg0_3.curSiteId = 0
	arg0_3.playerID = getProxy(PlayerProxy):getRawData().id
end

function var0_0.didEnter(arg0_9)
	arg0_9:SetData()
	arg0_9.topPanel:Load()
	arg0_9.infoPanel:Load()
	onButton(arg0_9, arg0_9.travelTF, function()
		arg0_9:FocusTF(arg0_9.travelTF)

		arg0_9.curSiteId = arg0_9.travelSiteId

		arg0_9.detailPanel:ExecuteAction("Show", arg0_9.travelSiteId)
		arg0_9:ShowInfoUI()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.workTF, function()
		arg0_9:FocusTF(arg0_9.workTF)

		arg0_9.curSiteId = arg0_9.workSiteId

		arg0_9.detailPanel:ExecuteAction("Show", arg0_9.workSiteId)
		arg0_9:ShowInfoUI()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.shopTF, function()
		arg0_9:FocusTF(arg0_9.shopTF)

		arg0_9.curSiteId = arg0_9.shopSiteId

		arg0_9.detailPanel:ExecuteAction("Show", arg0_9.shopSiteId)
		arg0_9:ShowInfoUI()
		arg0_9.infoPanel:ExecuteAction("SetShopOpen", true)
	end, SFX_PANEL)
	arg0_9.eventUIList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = arg0_9.eventSiteIds[arg1_13 + 1]

			arg2_13.name = var0_13

			local var1_13 = pg.child2_site_display[var0_13]

			LoadImageSpriteAsync("neweducateicon/" .. var1_13.event_icon, arg2_13, true)
			LoadImageSpriteAsync("neweducateicon/" .. var1_13.event_title, arg2_13:Find("name"), true)
			setAnchoredPosition(arg2_13, {
				x = var1_13.position[1],
				y = var1_13.position[2]
			})
			onButton(arg0_9, arg2_13, function()
				arg0_9:FocusTF(arg2_13)

				arg0_9.curSiteId = var0_13

				arg0_9.detailPanel:ExecuteAction("Show", var0_13)
				arg0_9:ShowInfoUI()
			end, SFX_PANEL)
		end
	end)
	arg0_9.shipUIList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			arg0_9:UpdateShipSite(arg1_15, arg2_15)
		end
	end)
	arg0_9:FlushView()

	if arg0_9.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_9.curSiteId = arg0_9.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.MAP):GetCurSiteId()

		arg0_9:ShowInfoUI()
		arg0_9:OnNodeStart(arg0_9.contextData.char:GetFSM():GetCurNode())
	else
		arg0_9:CheckEventPerformance()

		if arg0_9.contextData.openShop then
			triggerButton(arg0_9.shopTF)
		end
	end
end

function var0_0.CheckEventPerformance(arg0_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in ipairs(arg0_16.eventSiteIds) do
		local var1_16 = pg.child2_site_display[iter1_16].param
		local var2_16 = pg.child2_site_event_group[var1_16].performance

		if #var2_16 > 0 and PlayerPrefs.GetInt(arg0_16:GetEventLocalKey(var1_16)) ~= 1 then
			table.insert(var0_16, function(arg0_17)
				arg0_16.nodePanel:ExecuteAction("PlayWordIds", var2_16, arg0_17)
				PlayerPrefs.SetInt(arg0_16:GetEventLocalKey(var1_16), 1)
			end)
		end
	end

	seriesAsync(var0_16, function()
		return
	end)
end

function var0_0.GetEventLocalKey(arg0_19, arg1_19)
	return NewEducateConst.NEW_EDUCATE_EVENT_TIP .. "_" .. arg0_19.playerID .. "_" .. arg0_19.contextData.char.id .. "_" .. arg0_19.contextData.char:GetGameCnt() .. "_" .. arg1_19
end

function var0_0.ShowInfoUI(arg0_20, arg1_20)
	arg0_20.infoPanel:ExecuteAction("ShowPanel")
	arg0_20.topPanel:ExecuteAction("Flush")

	if arg1_20 then
		return
	end

	arg0_20.hideTFList = {}

	local var0_20 = pg.child2_site_display[arg0_20.curSiteId].type

	if var0_20 ~= NewEducateConst.SITE_TYPE.WORK then
		table.insert(arg0_20.hideTFList, arg0_20.workTF)
	end

	if var0_20 ~= NewEducateConst.SITE_TYPE.TRAVEL then
		table.insert(arg0_20.hideTFList, arg0_20.travelTF)
	end

	if var0_20 ~= NewEducateConst.SITE_TYPE.SHOP then
		table.insert(arg0_20.hideTFList, arg0_20.shopTF)
	end

	eachChild(arg0_20.eventUIList.container, function(arg0_21)
		if arg0_20.curSiteId ~= tonumber(arg0_21.name) then
			table.insert(arg0_20.hideTFList, arg0_21)
		end
	end)
	eachChild(arg0_20.shipUIList.container, function(arg0_22)
		if arg0_20.curSiteId ~= tonumber(arg0_22.name) then
			table.insert(arg0_20.hideTFList, arg0_22)
		end
	end)

	for iter0_20, iter1_20 in ipairs(arg0_20.hideTFList) do
		arg0_20:managedTween(LeanTween.value, nil, go(iter1_20), 1, 0, var0_0.ALPHA_TIME):setOnUpdate(System.Action_float(function(arg0_23)
			GetOrAddComponent(iter1_20, "CanvasGroup").alpha = arg0_23
		end))
	end
end

function var0_0.OnDetailHide(arg0_24)
	arg0_24.infoPanel:ExecuteAction("HidePanel")
	arg0_24.infoPanel:ExecuteAction("SetShopOpen", false)
	arg0_24.topPanel:ExecuteAction("Flush")
	arg0_24.topPanel:ExecuteAction("Show")
	arg0_24:managedTween(LeanTween.value, nil, go(arg0_24.mapTF), var0_0.SCALE, var0_0.DEFAULT_SCALE, arg0_24.duration):setOnUpdate(System.Action_float(function(arg0_25)
		setLocalScale(arg0_24.mapTF, {
			x = arg0_25,
			y = arg0_25,
			z = arg0_25
		})
	end))
	SetCompomentEnabled(arg0_24.mapTF, typeof(ScrollRect), false)

	arg0_24.twFocusId = LeanTween.move(arg0_24.mapTF, Vector3(0, 0, 0), arg0_24.duration):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		setSizeDelta(arg0_24.mapTF, Vector2(2400, 1478))
		SetCompomentEnabled(arg0_24.mapTF, typeof(ScrollRect), true)
	end)).uniqueId

	for iter0_24, iter1_24 in ipairs(arg0_24.hideTFList or {}) do
		arg0_24:managedTween(LeanTween.value, nil, go(iter1_24), 0, 1, var0_0.ALPHA_TIME):setOnUpdate(System.Action_float(function(arg0_27)
			GetOrAddComponent(iter1_24, "CanvasGroup").alpha = arg0_27
		end))
	end
end

function var0_0.onClickUpEntryGood(arg0_28, arg1_28)
	arg0_28:emit(var0_0.GO_SUBLAYER, Context.New({
		mediator = NewEducateTarotEntryMediator,
		viewComponent = NewEducateTarotEntryLayer,
		data = {
			goodId = arg1_28.id,
			type = NewEducateTarotEntryLayer.TYPE.SHOP,
			cost = arg1_28:getConfig("resource_num")
		}
	}))
end

function var0_0.FlushView(arg0_29)
	local var0_29 = arg0_29.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.MAP)

	arg0_29.eventSiteIds = underscore.map(var0_29:GetEvents(), function(arg0_30)
		return arg0_29.contextData.char:GetSiteId(NewEducateConst.SITE_TYPE.EVENT, arg0_30)
	end)

	table.sort(arg0_29.eventSiteIds, CompareFuncs({
		function(arg0_31)
			return pg.child2_site_display[arg0_31].position[1]
		end
	}))

	local var1_29 = arg0_29.contextData.char:GetShipIds()
	local var2_29 = underscore.select(var1_29, function(arg0_32)
		return not arg0_29:IsMaxShip(arg0_32) and not var0_29:IsSelectedShip(arg0_32)
	end)

	arg0_29.shipSiteIds = underscore.map(var2_29, function(arg0_33)
		return arg0_29.contextData.char:GetSiteId(NewEducateConst.SITE_TYPE.SHIP, arg0_33)
	end)

	arg0_29.eventUIList:align(#arg0_29.eventSiteIds)
	arg0_29.shipUIList:align(#arg0_29.shipSiteIds)
	arg0_29:InitPermanentNodes()
	setActive(arg0_29.shopTF, arg0_29.contextData.char:IsUnlock("shop"))
	arg0_29:CheckUpgradeNormalSite()
end

function var0_0.InitPermanentNodes(arg0_34)
	if arg0_34.travelSiteId then
		arg0_34:InitPermanent(arg0_34.travelSiteId, arg0_34.travelTF)
	end

	if arg0_34.workSiteId then
		arg0_34:InitPermanent(arg0_34.workSiteId, arg0_34.workTF)
	end

	if arg0_34.shopSiteId then
		arg0_34:InitPermanent(arg0_34.shopSiteId, arg0_34.shopTF)
	end
end

function var0_0.InitPermanent(arg0_35, arg1_35, arg2_35)
	local var0_35 = pg.child2_site_display[arg1_35]

	LoadImageSpriteAsync("neweducateicon/" .. var0_35.event_icon, arg2_35, true)
	LoadImageSpriteAsync("neweducateicon/" .. var0_35.event_title, arg2_35:Find("name"), true)
	setAnchoredPosition(arg2_35, {
		x = var0_35.position[1],
		y = var0_35.position[2]
	})
end

function var0_0.IsMaxShip(arg0_36, arg1_36)
	local var0_36 = pg.child2_site_character[arg1_36]
	local var1_36 = pg.child2_site_character.get_id_list_by_group[var0_36.group]

	return not underscore.detect(var1_36, function(arg0_37)
		return pg.child2_site_character[arg0_37].level == var0_36.level + 1
	end)
end

function var0_0.IsMaxNormal(arg0_38, arg1_38)
	local var0_38 = pg.child2_site_normal[arg1_38]
	local var1_38 = pg.child2_site_normal.get_id_list_by_character[arg0_38.contextData.char.id]

	return not underscore.detect(var1_38, function(arg0_39)
		local var0_39 = pg.child2_site_normal[arg0_39]

		return var0_39.type == var0_38.type and var0_39.site_lv == var0_38.site_lv + 1
	end)
end

function var0_0.CheckUpgradeNormalSite(arg0_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in pairs(NewEducateConst.SITE_NORMAL_TYPE) do
		local var1_40 = arg0_40.contextData.char:GetNormalIdByType(iter1_40)
		local var2_40 = pg.child2_site_normal[var1_40].special_args
		local var3_40 = arg0_40.contextData.char:IsMatchComplex(var2_40)

		if not arg0_40:IsMaxNormal(var1_40) and var3_40 then
			table.insert(var0_40, var1_40)
		end
	end

	if #var0_40 > 0 then
		local var4_40 = {}

		for iter2_40, iter3_40 in ipairs(var0_40) do
			table.insert(var4_40, function(arg0_41)
				arg0_40:emit(NewEducateMapMediator.ON_UPGRADE_NORMAL, iter3_40, arg0_41)
			end)
		end

		seriesAsync(var4_40, function()
			if arg0_40.detailPanel:isShowing() then
				arg0_40.detailPanel:ExecuteAction("Flush")
			end
		end)
	end
end

function var0_0.UpdateShipSite(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43.shipSiteIds[arg1_43 + 1]

	arg2_43.name = var0_43

	local var1_43 = pg.child2_site_display[var0_43]
	local var2_43 = arg2_43:Find("bottom/name_mask/name")

	setScrollText(var2_43, var1_43.name)
	setAnchoredPosition(arg2_43, {
		x = var1_43.position[1],
		y = var1_43.position[2]
	})
	LoadImageSpriteAsync("squareicon/" .. var1_43.icon, arg2_43:Find("top/mask/icon"), true)

	local var3_43 = pg.child2_site_character[var1_43.param].level

	eachChild(arg2_43:Find("top/lv"), function(arg0_44)
		setActive(arg0_44, tonumber(arg0_44.name) <= var3_43)
	end)
	setActive(arg2_43:Find("top/red"), var1_43.bg == "red")
	setActive(arg2_43:Find("top/blue"), var1_43.bg == "blue")
	setActive(arg2_43:Find("bottom/red"), var1_43.bg == "red")
	setActive(arg2_43:Find("bottom/blue"), var1_43.bg == "blue")
	setActive(arg2_43:Find("bottom/grey"), false)
	onButton(arg0_43, arg2_43, function()
		if arg0_43.contextData.char:GetFSM():CheckPriorityStystem() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("child2_priority_tip"))

			return
		end

		arg0_43:FocusTF(arg2_43)

		arg0_43.curSiteId = var0_43

		arg0_43.detailPanel:ExecuteAction("Show", var0_43)
		arg0_43:ShowInfoUI()
	end, SFX_PANEL)
end

function var0_0.UpdateShipLv(arg0_46)
	eachChild(arg0_46.shipUIList.container, function(arg0_47)
		if tonumber(arg0_47.name) == arg0_46.curSiteId then
			local var0_47 = pg.child2_site_display[arg0_46.curSiteId]
			local var1_47 = pg.child2_site_character[var0_47.param].level + 1

			eachChild(arg0_47:Find("top/lv"), function(arg0_48)
				setActive(arg0_48, tonumber(arg0_48.name) <= var1_47)
			end)
		end
	end)
end

function var0_0.OnShoppingDone(arg0_49)
	arg0_49.detailPanel:ExecuteAction("FlushShop")
	arg0_49:emit(var0_0.ON_PRIORITY_STATE)
end

function var0_0.OnRefreshShopDone(arg0_50)
	arg0_50.detailPanel:ExecuteAction("FlushShop")
end

function var0_0.OnResUpdate(arg0_51)
	arg0_51.topPanel:ExecuteAction("FlushRes")
end

function var0_0.OnAttrUpdate(arg0_52)
	arg0_52.infoPanel:ExecuteAction("FlushAttrs")
	arg0_52.topPanel:ExecuteAction("FlushProgress")
end

function var0_0.OnPersonalityUpdate(arg0_53, arg1_53, arg2_53)
	arg0_53.personalityTipPanel:ExecuteAction("FlushPersonality", arg1_53, arg2_53)
end

function var0_0.OnTalentUpdate(arg0_54)
	arg0_54.infoPanel:ExecuteAction("FlushTalents")
end

function var0_0.OnStatusUpdate(arg0_55)
	arg0_55.infoPanel:ExecuteAction("FlushStatus")
end

function var0_0.OnTarotUpdate(arg0_56)
	arg0_56.infoPanel:ExecuteAction("FlushTarot")
end

function var0_0.OnNodeStart(arg0_57, arg1_57)
	arg0_57.nodePanel:ExecuteAction("StartNode", arg1_57)
end

function var0_0.OnNextNode(arg0_58, arg1_58)
	arg0_58.nodePanel:ExecuteAction("ProceedNode", arg1_58.node, arg1_58.drop, arg1_58.noNextCb)
end

function var0_0.FocusTF(arg0_59, arg1_59, arg2_59)
	setSizeDelta(arg0_59.mapTF, Vector2(3280, 2038))

	arg0_59.extendLimit = Vector2(arg0_59.mapTF.rect.width * var0_0.SCALE - arg0_59._tf.rect.width, arg0_59.mapTF.rect.height * var0_0.SCALE - arg0_59._tf.rect.height) / 2

	local var0_59 = arg1_59.anchoredPosition * -1

	var0_59.x = math.clamp(var0_59.x, -arg0_59.extendLimit.x, arg0_59.extendLimit.x) * var0_0.SCALE
	var0_59.y = math.clamp(var0_59.y, -arg0_59.extendLimit.y, arg0_59.extendLimit.y) * var0_0.SCALE

	if arg0_59.twFocusId then
		LeanTween.cancel(arg0_59.twFocusId)

		arg0_59.twFocusId = nil
	end

	local var1_59 = {}

	table.insert(var1_59, function(arg0_60)
		SetCompomentEnabled(arg0_59.mapTF, typeof(ScrollRect), false)

		local var0_60 = (arg0_59.mapTF.anchoredPosition - var0_59).magnitude

		arg0_59.duration = var0_60 > 0 and var0_60 / (var0_0.SPEED * math.sqrt(var0_60)) or 0

		arg0_59:managedTween(LeanTween.value, nil, go(arg0_59.mapTF), var0_0.DEFAULT_SCALE, var0_0.SCALE, arg0_59.duration):setOnUpdate(System.Action_float(function(arg0_61)
			setLocalScale(arg0_59.mapTF, {
				x = arg0_61,
				y = arg0_61,
				z = arg0_61
			})
		end))

		arg0_59.twFocusId = LeanTween.move(arg0_59.mapTF, Vector3(var0_59.x, var0_59.y, 0), arg0_59.duration):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg0_60)).uniqueId
	end)
	seriesAsync(var1_59, function()
		SetCompomentEnabled(arg0_59.mapTF, typeof(ScrollRect), true)

		if arg2_59 then
			arg2_59()
		end
	end)
end

function var0_0.onBackPressed(arg0_63)
	if arg0_63.nodePanel:isShowing() then
		return
	end

	if arg0_63.detailPanel:isShowing() then
		arg0_63.detailPanel:Hide()
	else
		arg0_63.super.onBackPressed(arg0_63)
	end
end

function var0_0.willExit(arg0_64)
	if arg0_64.topPanel then
		arg0_64.topPanel:Destroy()

		arg0_64.topPanel = nil
	end

	if arg0_64.infoPanel then
		arg0_64.infoPanel:Destroy()

		arg0_64.infoPanel = nil
	end

	if arg0_64.detailPanel then
		arg0_64.detailPanel:Destroy()

		arg0_64.detailPanel = nil
	end

	if arg0_64.personalityTipPanel then
		arg0_64.personalityTipPanel:Destroy()

		arg0_64.personalityTipPanel = nil
	end

	if arg0_64.nodePanel then
		arg0_64.nodePanel:Destroy()

		arg0_64.nodePanel = nil
	end
end

return var0_0
