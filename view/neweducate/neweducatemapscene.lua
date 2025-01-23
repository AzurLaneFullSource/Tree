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
	arg0_3.topPanel = NewEducateTopPanel.New(arg0_3.uiTF, arg0_3.event, setmetatable({
		showBack = true
	}, {
		__index = arg0_3.contextData
	}))
	arg0_3.infoPanel = NewEducateInfoPanel.New(arg0_3.uiTF, arg0_3.event, setmetatable({
		hide = true,
		weight = LayerWeightConst.BASE_LAYER + 3
	}, {
		__index = arg0_3.contextData
	}))
	arg0_3.detailPanel = NewEducateSiteDetailPanel.New(arg0_3.uiTF, arg0_3.event, setmetatable({
		onHide = function()
			arg0_3:OnDetailHide()
		end
	}, {
		__index = arg0_3.contextData
	}))
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
		end
	}, {
		__index = arg0_3.contextData
	}))
	arg0_3.extendLimit = Vector2(arg0_3.mapTF.rect.width - arg0_3._tf.rect.width, arg0_3.mapTF.rect.height - arg0_3._tf.rect.height) / 2
	arg0_3.duration = 0.5
	arg0_3.curSiteId = 0
	arg0_3.playerID = getProxy(PlayerProxy):getRawData().id
end

function var0_0.didEnter(arg0_8)
	arg0_8:SetData()
	arg0_8.topPanel:Load()
	arg0_8.infoPanel:Load()
	onButton(arg0_8, arg0_8.travelTF, function()
		arg0_8:FocusTF(arg0_8.travelTF)

		arg0_8.curSiteId = arg0_8.travelSiteId

		arg0_8.detailPanel:ExecuteAction("Show", arg0_8.travelSiteId)
		arg0_8:ShowInfoUI()
	end, SFX_PANEL)

	local var0_8 = pg.child2_site_display[arg0_8.travelSiteId].position

	setAnchoredPosition(arg0_8.travelTF, {
		x = var0_8[1],
		y = var0_8[2]
	})
	onButton(arg0_8, arg0_8.workTF, function()
		arg0_8:FocusTF(arg0_8.workTF)

		arg0_8.curSiteId = arg0_8.workSiteId

		arg0_8.detailPanel:ExecuteAction("Show", arg0_8.workSiteId)
		arg0_8:ShowInfoUI()
	end, SFX_PANEL)

	local var1_8 = pg.child2_site_display[arg0_8.workSiteId].position

	setAnchoredPosition(arg0_8.workTF, {
		x = var1_8[1],
		y = var1_8[2]
	})
	onButton(arg0_8, arg0_8.shopTF, function()
		arg0_8:FocusTF(arg0_8.shopTF)

		arg0_8.curSiteId = arg0_8.shopSiteId

		arg0_8.detailPanel:ExecuteAction("Show", arg0_8.shopSiteId)
		arg0_8:ShowInfoUI()
	end, SFX_PANEL)

	local var2_8 = pg.child2_site_display[arg0_8.shopSiteId].position

	setAnchoredPosition(arg0_8.shopTF, {
		x = var2_8[1],
		y = var2_8[2]
	})
	arg0_8.eventUIList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg0_8.eventSiteIds[arg1_12 + 1]

			arg2_12.name = var0_12

			local var1_12 = pg.child2_site_display[var0_12]

			LoadImageSpriteAsync("neweducateicon/" .. var1_12.event_icon, arg2_12, true)
			LoadImageSpriteAsync("neweducateicon/" .. var1_12.event_title, arg2_12:Find("name"), true)
			setAnchoredPosition(arg2_12, {
				x = var1_12.position[1],
				y = var1_12.position[2]
			})
			onButton(arg0_8, arg2_12, function()
				arg0_8:FocusTF(arg2_12)

				arg0_8.curSiteId = var0_12

				arg0_8.detailPanel:ExecuteAction("Show", var0_12)
				arg0_8:ShowInfoUI()
			end, SFX_PANEL)
		end
	end)
	arg0_8.shipUIList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			arg0_8:UpdateShipSite(arg1_14, arg2_14)
		end
	end)
	arg0_8:FlushView()

	if arg0_8.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_8.curSiteId = arg0_8.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.MAP):GetCurSiteId()

		arg0_8:ShowInfoUI()
		arg0_8:OnNodeStart(arg0_8.contextData.char:GetFSM():GetCurNode())
	else
		arg0_8:CheckEventPerformance()
	end
end

function var0_0.CheckEventPerformance(arg0_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.eventSiteIds) do
		local var1_15 = pg.child2_site_display[iter1_15].param
		local var2_15 = pg.child2_site_event_group[var1_15].performance

		if #var2_15 > 0 and PlayerPrefs.GetInt(arg0_15:GetEventLocalKey(var1_15)) ~= 1 then
			table.insert(var0_15, function(arg0_16)
				arg0_15.nodePanel:ExecuteAction("PlayWordIds", var2_15, arg0_16)
				PlayerPrefs.SetInt(arg0_15:GetEventLocalKey(var1_15), 1)
			end)
		end
	end

	seriesAsync(var0_15, function()
		return
	end)
end

function var0_0.GetEventLocalKey(arg0_18, arg1_18)
	return NewEducateConst.NEW_EDUCATE_EVENT_TIP .. "_" .. arg0_18.playerID .. "_" .. arg0_18.contextData.char.id .. "_" .. arg0_18.contextData.char:GetGameCnt() .. "_" .. arg1_18
end

function var0_0.ShowInfoUI(arg0_19, arg1_19)
	arg0_19.infoPanel:ExecuteAction("ShowPanel")
	arg0_19.topPanel:ExecuteAction("ShowDetail")

	if arg1_19 then
		return
	end

	arg0_19.hideTFList = {}

	local var0_19 = pg.child2_site_display[arg0_19.curSiteId].type

	if var0_19 ~= NewEducateConst.SITE_TYPE.WORK then
		table.insert(arg0_19.hideTFList, arg0_19.workTF)
	end

	if var0_19 ~= NewEducateConst.SITE_TYPE.TRAVEL then
		table.insert(arg0_19.hideTFList, arg0_19.travelTF)
	end

	if var0_19 ~= NewEducateConst.SITE_TYPE.SHOP then
		table.insert(arg0_19.hideTFList, arg0_19.shopTF)
	end

	eachChild(arg0_19.eventUIList.container, function(arg0_20)
		if arg0_19.curSiteId ~= tonumber(arg0_20.name) then
			table.insert(arg0_19.hideTFList, arg0_20)
		end
	end)
	eachChild(arg0_19.shipUIList.container, function(arg0_21)
		if arg0_19.curSiteId ~= tonumber(arg0_21.name) then
			table.insert(arg0_19.hideTFList, arg0_21)
		end
	end)

	for iter0_19, iter1_19 in ipairs(arg0_19.hideTFList) do
		arg0_19:managedTween(LeanTween.value, nil, go(iter1_19), 1, 0, var0_0.ALPHA_TIME):setOnUpdate(System.Action_float(function(arg0_22)
			GetOrAddComponent(iter1_19, "CanvasGroup").alpha = arg0_22
		end))
	end
end

function var0_0.OnDetailHide(arg0_23)
	arg0_23.infoPanel:ExecuteAction("HidePanel")
	arg0_23.topPanel:ExecuteAction("ShowBack")
	arg0_23:managedTween(LeanTween.value, nil, go(arg0_23.mapTF), var0_0.SCALE, var0_0.DEFAULT_SCALE, arg0_23.duration):setOnUpdate(System.Action_float(function(arg0_24)
		setLocalScale(arg0_23.mapTF, {
			x = arg0_24,
			y = arg0_24,
			z = arg0_24
		})
	end))
	SetCompomentEnabled(arg0_23.mapTF, typeof(ScrollRect), false)

	arg0_23.twFocusId = LeanTween.move(arg0_23.mapTF, Vector3(0, 0, 0), arg0_23.duration):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		setSizeDelta(arg0_23.mapTF, Vector2(2400, 1478))
		SetCompomentEnabled(arg0_23.mapTF, typeof(ScrollRect), true)
	end)).uniqueId

	for iter0_23, iter1_23 in ipairs(arg0_23.hideTFList or {}) do
		arg0_23:managedTween(LeanTween.value, nil, go(iter1_23), 0, 1, var0_0.ALPHA_TIME):setOnUpdate(System.Action_float(function(arg0_26)
			GetOrAddComponent(iter1_23, "CanvasGroup").alpha = arg0_26
		end))
	end
end

function var0_0.FlushView(arg0_27)
	local var0_27 = arg0_27.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.MAP)

	arg0_27.eventSiteIds = underscore.map(var0_27:GetEvents(), function(arg0_28)
		return arg0_27.contextData.char:GetSiteId(NewEducateConst.SITE_TYPE.EVENT, arg0_28)
	end)

	table.sort(arg0_27.eventSiteIds, CompareFuncs({
		function(arg0_29)
			return pg.child2_site_display[arg0_29].position[1]
		end
	}))

	local var1_27 = arg0_27.contextData.char:GetShipIds()
	local var2_27 = underscore.select(var1_27, function(arg0_30)
		return not arg0_27:IsMaxShip(arg0_30) and not var0_27:IsSelectedShip(arg0_30)
	end)

	arg0_27.shipSiteIds = underscore.map(var2_27, function(arg0_31)
		return arg0_27.contextData.char:GetSiteId(NewEducateConst.SITE_TYPE.SHIP, arg0_31)
	end)

	arg0_27.eventUIList:align(#arg0_27.eventSiteIds)
	arg0_27.shipUIList:align(#arg0_27.shipSiteIds)
	setActive(arg0_27.shopTF, arg0_27.contextData.char:IsUnlock("shop"))
	arg0_27:CheckUpgradeNormalSite()
end

function var0_0.IsMaxShip(arg0_32, arg1_32)
	local var0_32 = pg.child2_site_character[arg1_32]
	local var1_32 = pg.child2_site_character.get_id_list_by_group[var0_32.group]

	return not underscore.detect(var1_32, function(arg0_33)
		return pg.child2_site_character[arg0_33].level == var0_32.level + 1
	end)
end

function var0_0.IsMaxNormal(arg0_34, arg1_34)
	local var0_34 = pg.child2_site_normal[arg1_34]
	local var1_34 = pg.child2_site_normal.get_id_list_by_character[arg0_34.contextData.char.id]

	return not underscore.detect(var1_34, function(arg0_35)
		local var0_35 = pg.child2_site_normal[arg0_35]

		return var0_35.type == var0_34.type and var0_35.site_lv == var0_34.site_lv + 1
	end)
end

function var0_0.CheckUpgradeNormalSite(arg0_36)
	local var0_36 = {}

	for iter0_36, iter1_36 in pairs(NewEducateConst.SITE_NORMAL_TYPE) do
		local var1_36 = arg0_36.contextData.char:GetNormalIdByType(iter1_36)
		local var2_36 = pg.child2_site_normal[var1_36].special_args
		local var3_36 = arg0_36.contextData.char:IsMatchComplex(var2_36)

		if not arg0_36:IsMaxNormal(var1_36) and var3_36 then
			table.insert(var0_36, var1_36)
		end
	end

	if #var0_36 > 0 then
		local var4_36 = {}

		for iter2_36, iter3_36 in ipairs(var0_36) do
			table.insert(var4_36, function(arg0_37)
				arg0_36:emit(NewEducateMapMediator.ON_UPGRADE_NORMAL, iter3_36, arg0_37)
			end)
		end

		seriesAsync(var4_36, function()
			if arg0_36.detailPanel:isShowing() then
				arg0_36.detailPanel:ExecuteAction("Flush")
			end
		end)
	end
end

function var0_0.UpdateShipSite(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg0_39.shipSiteIds[arg1_39 + 1]

	arg2_39.name = var0_39

	local var1_39 = pg.child2_site_display[var0_39]
	local var2_39 = arg2_39:Find("bottom/name_mask/name")

	setScrollText(var2_39, var1_39.name)
	setAnchoredPosition(arg2_39, {
		x = var1_39.position[1],
		y = var1_39.position[2]
	})
	LoadImageSpriteAsync("squareicon/" .. var1_39.icon, arg2_39:Find("top/mask/icon"), true)

	local var3_39 = pg.child2_site_character[var1_39.param].level

	eachChild(arg2_39:Find("top/lv"), function(arg0_40)
		setActive(arg0_40, tonumber(arg0_40.name) <= var3_39)
	end)
	setActive(arg2_39:Find("top/red"), var1_39.bg == "red")
	setActive(arg2_39:Find("top/blue"), var1_39.bg == "blue")
	setActive(arg2_39:Find("bottom/red"), var1_39.bg == "red")
	setActive(arg2_39:Find("bottom/blue"), var1_39.bg == "blue")
	setActive(arg2_39:Find("bottom/grey"), false)
	onButton(arg0_39, arg2_39, function()
		arg0_39:FocusTF(arg2_39)

		arg0_39.curSiteId = var0_39

		arg0_39.detailPanel:ExecuteAction("Show", var0_39)
		arg0_39:ShowInfoUI()
	end, SFX_PANEL)
end

function var0_0.UpdateShipLv(arg0_42)
	eachChild(arg0_42.shipUIList.container, function(arg0_43)
		if tonumber(arg0_43.name) == arg0_42.curSiteId then
			local var0_43 = pg.child2_site_display[arg0_42.curSiteId]
			local var1_43 = pg.child2_site_character[var0_43.param].level + 1

			eachChild(arg0_43:Find("top/lv"), function(arg0_44)
				setActive(arg0_44, tonumber(arg0_44.name) <= var1_43)
			end)
		end
	end)
end

function var0_0.OnShoppingDone(arg0_45)
	arg0_45.detailPanel:ExecuteAction("FlushShop")
end

function var0_0.OnResUpdate(arg0_46)
	arg0_46.topPanel:ExecuteAction("FlushRes")
end

function var0_0.OnAttrUpdate(arg0_47)
	arg0_47.infoPanel:ExecuteAction("FlushAttrs")
	arg0_47.topPanel:ExecuteAction("FlushProgress")
end

function var0_0.OnPersonalityUpdate(arg0_48, arg1_48, arg2_48)
	arg0_48.personalityTipPanel:ExecuteAction("FlushPersonality", arg1_48, arg2_48)
end

function var0_0.OnTalentUpdate(arg0_49)
	arg0_49.infoPanel:ExecuteAction("FlushTalents")
end

function var0_0.OnStatusUpdate(arg0_50)
	arg0_50.infoPanel:ExecuteAction("FlushStatus")
end

function var0_0.OnNodeStart(arg0_51, arg1_51)
	arg0_51.nodePanel:ExecuteAction("StartNode", arg1_51)
end

function var0_0.OnNextNode(arg0_52, arg1_52)
	arg0_52.nodePanel:ExecuteAction("ProceedNode", arg1_52.node, arg1_52.drop, arg1_52.noNextCb)
end

function var0_0.FocusTF(arg0_53, arg1_53, arg2_53)
	setSizeDelta(arg0_53.mapTF, Vector2(3280, 2038))

	arg0_53.extendLimit = Vector2(arg0_53.mapTF.rect.width * var0_0.SCALE - arg0_53._tf.rect.width, arg0_53.mapTF.rect.height * var0_0.SCALE - arg0_53._tf.rect.height) / 2

	local var0_53 = arg1_53.anchoredPosition * -1

	var0_53.x = math.clamp(var0_53.x, -arg0_53.extendLimit.x, arg0_53.extendLimit.x) * var0_0.SCALE
	var0_53.y = math.clamp(var0_53.y, -arg0_53.extendLimit.y, arg0_53.extendLimit.y) * var0_0.SCALE

	if arg0_53.twFocusId then
		LeanTween.cancel(arg0_53.twFocusId)

		arg0_53.twFocusId = nil
	end

	local var1_53 = {}

	table.insert(var1_53, function(arg0_54)
		SetCompomentEnabled(arg0_53.mapTF, typeof(ScrollRect), false)

		local var0_54 = (arg0_53.mapTF.anchoredPosition - var0_53).magnitude

		arg0_53.duration = var0_54 > 0 and var0_54 / (var0_0.SPEED * math.sqrt(var0_54)) or 0

		arg0_53:managedTween(LeanTween.value, nil, go(arg0_53.mapTF), var0_0.DEFAULT_SCALE, var0_0.SCALE, arg0_53.duration):setOnUpdate(System.Action_float(function(arg0_55)
			setLocalScale(arg0_53.mapTF, {
				x = arg0_55,
				y = arg0_55,
				z = arg0_55
			})
		end))

		arg0_53.twFocusId = LeanTween.move(arg0_53.mapTF, Vector3(var0_53.x, var0_53.y, 0), arg0_53.duration):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg0_54)).uniqueId
	end)
	seriesAsync(var1_53, function()
		SetCompomentEnabled(arg0_53.mapTF, typeof(ScrollRect), true)

		if arg2_53 then
			arg2_53()
		end
	end)
end

function var0_0.onBackPressed(arg0_57)
	if arg0_57.nodePanel:isShowing() then
		return
	end

	if arg0_57.detailPanel:isShowing() then
		arg0_57.detailPanel:Hide()
	else
		arg0_57.super.onBackPressed(arg0_57)
	end
end

function var0_0.willExit(arg0_58)
	if arg0_58.topPanel then
		arg0_58.topPanel:Destroy()

		arg0_58.topPanel = nil
	end

	if arg0_58.infoPanel then
		arg0_58.infoPanel:Destroy()

		arg0_58.infoPanel = nil
	end

	if arg0_58.detailPanel then
		arg0_58.detailPanel:Destroy()

		arg0_58.detailPanel = nil
	end

	if arg0_58.personalityTipPanel then
		arg0_58.personalityTipPanel:Destroy()

		arg0_58.personalityTipPanel = nil
	end

	if arg0_58.nodePanel then
		arg0_58.nodePanel:Destroy()

		arg0_58.nodePanel = nil
	end
end

return var0_0
