local var0_0 = class("WorldPortLayer", import("..base.BaseUI"))

var0_0.Listeners = {
	onUpdateGoods = "OnUpdateGoods",
	onUpdateMoneyCount = "OnUpdateMoneyCount",
	onUpdateTasks = "OnUpdateTasks",
	onUpdateNGoods = "OnUpdateNGoods"
}
var0_0.TitleName = {
	"text_gangkou",
	"text_operation",
	"text_supply"
}
var0_0.PageMain = 0
var0_0.PageTask = 1
var0_0.PageShop = 2
var0_0.PageDockyard = 3
var0_0.PageNShop = 4
var0_0.BlurPages = {
	[var0_0.PageTask] = true,
	[var0_0.PageShop] = true,
	[var0_0.PageNShop] = true
}
var0_0.optionsPath = {
	"blur_panel/adapt/top/title/option"
}

function var0_0.getUIName(arg0_1)
	return "WorldPortUI"
end

function var0_0.init(arg0_2)
	for iter0_2, iter1_2 in pairs(var0_0.Listeners) do
		arg0_2[iter0_2] = function(...)
			var0_0[iter1_2](arg0_2, ...)
		end
	end

	arg0_2.rtBg = arg0_2:findTF("bg")
	arg0_2.rtEnterIcon = arg0_2.rtBg:Find("enter_icon")
	arg0_2.rtBgNShop = arg0_2._tf:Find("bg_2")
	arg0_2.rtBlurPanel = arg0_2:findTF("blur_panel")
	arg0_2.rtTasks = arg0_2.rtBlurPanel:Find("adapt/tasks")
	arg0_2.rtShop = arg0_2.rtBlurPanel:Find("adapt/shop")
	arg0_2.rtPainting = arg0_2.rtShop:Find("paint")
	arg0_2.btnPainting = arg0_2.rtShop:Find("paint_touch")

	setActive(arg0_2.btnPainting, false)

	arg0_2.rtChat = arg0_2.rtShop:Find("chat")

	setActive(arg0_2.rtChat, false)

	arg0_2.rtNShop = arg0_2.rtBlurPanel:Find("adapt/new_shop")
	arg0_2.containerPort = arg0_2.rtNShop:Find("frame/content/left")
	arg0_2.tplPort = arg0_2.containerPort:Find("port_tpl")
	arg0_2.poolTplPort = {
		arg0_2.tplPort
	}
	arg0_2.rtNGoodsContainer = arg0_2.rtNShop:Find("frame/content/right/page/view/content")
	arg0_2.rtNShopRes = arg0_2.rtNShop:Find("frame/content/right/page/title/res")

	local var0_2 = Drop.New({
		type = DROP_TYPE_WORLD_ITEM,
		id = WorldItem.PortMoneyId
	})

	GetImageSpriteFromAtlasAsync(var0_2:getIcon(), "", arg0_2.rtNShopRes:Find("icon/Image"), false)
	setText(arg0_2.rtNShopRes:Find("icon/name"), var0_2:getName())

	arg0_2.rtTop = arg0_2.rtBlurPanel:Find("adapt/top")
	arg0_2.btnBack = arg0_2.rtTop:Find("title/back_button")
	arg0_2.rtTopTitle = arg0_2.rtTop:Find("title")
	arg0_2.rtImageTitle = arg0_2.rtTopTitle:Find("print/title")
	arg0_2.rtImageTitleTask = arg0_2.rtTopTitle:Find("print/title_task")
	arg0_2.rtImageTitleShop = arg0_2.rtTopTitle:Find("print/title_shop")
	arg0_2.rtTopLeft = arg0_2.rtTop:Find("left_stage")
	arg0_2.rtTopRight = arg0_2.rtTop:Find("right_stage")
	arg0_2.wsWorldInfo = WSWorldInfo.New()
	arg0_2.wsWorldInfo.transform = arg0_2.rtTopRight:Find("display_panel/world_info")

	arg0_2.wsWorldInfo:Setup()
	setText(arg0_2.rtTopRight:Find("display_panel/title/title"), i18n("world_map_title_tips"))
	setText(arg0_2.rtTopRight:Find("display_panel/title/title_en"), i18n("world_map_title_tips_en"))
	setText(arg0_2.wsWorldInfo.transform:Find("power/bg/Word"), i18n("world_total_power"))
	setText(arg0_2.wsWorldInfo.transform:Find("explore/mileage/Text"), i18n("world_mileage"))
	setText(arg0_2.wsWorldInfo.transform:Find("explore/pressing/Text"), i18n("world_pressing"))

	arg0_2.rtTopBottom = arg0_2.rtTop:Find("bottom_stage")
	arg0_2.btnOperation = arg0_2.rtTopBottom:Find("btn/operation")
	arg0_2.btnSupply = arg0_2.rtTopBottom:Find("btn/supply")
	arg0_2.btnDockyard = arg0_2.rtTopBottom:Find("btn/dockyard")
	arg0_2.resPanel = WorldResource.New()

	arg0_2.resPanel._tf:SetParent(arg0_2.rtTop:Find("title/resources"), false)

	arg0_2.rtTaskWindow = arg0_2:findTF("task_window")
	arg0_2.wsTasks = {}
	arg0_2.wsGoods = {}
	arg0_2.page = -1
	arg0_2.dirtyFlags = {}
	arg0_2.cdTF = arg0_2.rtShop:Find("timer_bg")
	arg0_2.emptyTF = arg0_2.rtShop:Find("frame/scrollview/empty")
	arg0_2.refreshBtn = arg0_2.rtShop:Find("refresh_btn")

	setActive(arg0_2.refreshBtn, false)

	arg0_2.glitchArtMaterial = arg0_2:findTF("resource/material1"):GetComponent(typeof(Image)).material
	arg0_2.singleWindow = OriginShopSingleWindow.New(arg0_2._tf, arg0_2.event)
	arg0_2.multiWindow = OriginShopMultiWindow.New(arg0_2._tf, arg0_2.event)
end

function var0_0.didEnter(arg0_4)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf, {
		groupName = arg0_4:getGroupNameFromData()
	})
	onButton(arg0_4, arg0_4.btnBack, function()
		if arg0_4.isTweening then
			return
		end

		if arg0_4.port:IsTempPort() or arg0_4.page == var0_0.PageMain then
			arg0_4:EaseOutUI(function()
				arg0_4:closeView()
			end)
		else
			arg0_4:SetPage(var0_0.PageMain)
		end
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.btnOperation, function()
		arg0_4:SetPage(var0_0.PageTask)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnSupply, function()
		if nowWorld():UsePortNShop() then
			arg0_4:SetPage(var0_0.PageNShop)
		else
			arg0_4:SetPage(var0_0.PageShop)
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnDockyard, function()
		arg0_4:emit(WorldPortMediator.OnOpenBay)
	end, SFX_PANEL)
	arg0_4:UpdatePainting(arg0_4:GetPaintingInfo())
	arg0_4:UpdateTaskTip()
	arg0_4:UpdateCDTip()
	arg0_4:UpdateNShopTip()

	if arg0_4.port:IsTempPort() then
		arg0_4.contextData.page = WorldPortLayer.PageShop
	elseif arg0_4.contextData.page == WorldPortLayer.PageDockyard then
		arg0_4.contextData.page = nil
	end

	arg0_4:SetPage(arg0_4.contextData.page or WorldPortLayer.PageMain)
	arg0_4:EaseInUI()
end

function var0_0.onBackPressed(arg0_10)
	triggerButton(arg0_10.btnBack)
end

function var0_0.willExit(arg0_11)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf)
	arg0_11:RecyclePainting(arg0_11.rtPainting)
	arg0_11.singleWindow:Destroy()
	arg0_11.multiWindow:Destroy()

	arg0_11.contextData.isEnter = true

	if var0_0.BlurPages[arg0_11.page] then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_11.rtBlurPanel, arg0_11._tf)
	end

	arg0_11:CancelUITween()
	arg0_11:DisposeTopUI()
	arg0_11:DisposeTasks()
	arg0_11:DisposeGoods()
	arg0_11.atlas:RemoveListener(WorldAtlas.EventUpdateNGoodsCount, arg0_11.onUpdateNGoods)

	arg0_11.atlas = nil

	arg0_11.port:RemoveListener(WorldMapPort.EventUpdateTaskIds, arg0_11.onUpdateTasks)
	arg0_11.port:RemoveListener(WorldMapPort.EventUpdateGoods, arg0_11.onUpdateGoods)

	arg0_11.port = nil

	arg0_11.resPanel:exit()

	arg0_11.resPanel = nil

	arg0_11.refreshTimer:Stop()

	arg0_11.refreshTimer = nil

	arg0_11.inventory:RemoveListener(WorldInventoryProxy.EventUpdateItem, arg0_11.onUpdateMoneyCount)

	arg0_11.inventory = nil

	arg0_11.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateTask, arg0_11.onUpdateTasks)

	arg0_11.taskProxy = nil

	arg0_11.wsWorldInfo:Dispose()

	arg0_11.wsWorldInfo = nil
end

function var0_0.GetPaintingInfo(arg0_12)
	if arg0_12.port:IsTempPort() then
		return "mingshi", false
	else
		return "tbniang", true
	end
end

function var0_0.UpdatePainting(arg0_13, arg1_13, arg2_13)
	arg0_13.paintingName = arg1_13

	setPaintingPrefab(arg0_13.rtPainting, arg1_13, "chuanwu")

	if arg2_13 then
		arg0_13:AddGlitchArtEffectForPating(arg0_13.rtPainting)
	end
end

function var0_0.AddGlitchArtEffectForPating(arg0_14, arg1_14)
	local var0_14 = arg1_14:GetComponentsInChildren(typeof(Image))

	for iter0_14 = 0, var0_14.Length - 1 do
		var0_14[iter0_14].material = arg0_14.glitchArtMaterial
	end
end

function var0_0.RecyclePainting(arg0_15, arg1_15)
	if arg1_15:Find("fitter").childCount > 0 then
		local var0_15 = arg1_15:GetComponentsInChildren(typeof(Image))

		for iter0_15 = 0, var0_15.Length - 1 do
			local var1_15 = var0_15[iter0_15]
			local var2_15 = Color.white

			if var1_15.material ~= var1_15.defaultGraphicMaterial then
				var1_15.material = var1_15.defaultGraphicMaterial

				var1_15.material:SetColor("_Color", var2_15)
			end
		end

		setGray(arg1_15, false, true)

		local var3_15 = arg1_15:Find("fitter"):GetChild(0)

		retPaintingPrefab(arg1_15, var3_15.name)

		local var4_15 = var3_15:Find("temp_mask")

		if var4_15 then
			Destroy(var4_15)
		end
	end
end

function var0_0.DisplayTopUI(arg0_16, arg1_16)
	setActive(arg0_16.rtImageTitle, arg1_16 == var0_0.PageMain)
	setActive(arg0_16.rtImageTitleTask, arg1_16 == var0_0.PageTask)
	setActive(arg0_16.rtImageTitleShop, arg1_16 == var0_0.PageShop or arg1_16 == var0_0.PageNShop)
	setActive(arg0_16.rtTopLeft, arg1_16 ~= var0_0.PageNShop)
	setActive(arg0_16.rtTopRight, arg1_16 == var0_0.PageMain)
	setActive(arg0_16.rtTopBottom, arg1_16 == var0_0.PageMain)
	setActive(arg0_16.rtBg, arg1_16 ~= var0_0.PageNShop)
	setActive(arg0_16.rtBgNShop, arg1_16 == var0_0.PageNShop)
end

function var0_0.DisposeTopUI(arg0_17)
	arg0_17.wsPortLeft:Dispose()
end

function var0_0.NewPortLeft(arg0_18)
	local var0_18 = WSPortLeft.New()

	var0_18.transform = arg0_18.rtTopLeft

	var0_18:Setup()
	var0_18:UpdateMap(nowWorld():GetActiveMap())

	return var0_18
end

function var0_0.EnterPortAnim(arg0_19, arg1_19)
	local var0_19 = arg0_19.rtEnterIcon:GetComponent(typeof(DftAniEvent))

	if var0_19 then
		var0_19:SetTriggerEvent(function(arg0_20)
			arg1_19()
		end)
		var0_19:SetEndEvent(function(arg0_21)
			setActive(arg0_19.rtEnterIcon, false)
		end)
	end

	setActive(arg0_19.rtEnterIcon, true)
end

function var0_0.EaseInUI(arg0_22, arg1_22)
	arg0_22.isTweening = true

	local var0_22 = {}

	arg0_22:CancelUITween()

	if #arg0_22.enterIcon > 0 and not arg0_22.contextData.isEnter then
		table.insert(var0_22, function(arg0_23)
			setActive(arg0_22.rtTop, false)
			arg0_22:EnterPortAnim(function()
				setActive(arg0_22.rtTop, true)

				return arg0_23()
			end)
		end)
	else
		setActive(arg0_22.rtEnterIcon, false)
	end

	seriesAsync(var0_22, function()
		setAnchoredPosition(arg0_22.rtTopLeft, {
			x = -arg0_22.rtTopLeft.rect.width
		})
		setAnchoredPosition(arg0_22.rtTopRight, {
			x = arg0_22.rtTopRight.rect.width
		})
		setAnchoredPosition(arg0_22.rtTopTitle, {
			y = arg0_22.rtTopTitle.rect.height
		})
		setAnchoredPosition(arg0_22.rtTopBottom, {
			y = -arg0_22.rtTopRight.rect.height
		})
		LeanTween.moveX(arg0_22.rtTopLeft, 0, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
		LeanTween.moveX(arg0_22.rtTopRight, 0, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
		LeanTween.moveY(arg0_22.rtTopTitle, 0, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
		LeanTween.moveY(arg0_22.rtTopBottom, 0, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function()
			arg0_22.isTweening = false

			return existCall(arg1_22)
		end))
	end)
end

function var0_0.EaseOutUI(arg0_27, arg1_27)
	arg0_27:CancelUITween()
	LeanTween.moveX(arg0_27.rtTopLeft, -arg0_27.rtTopLeft.rect.width, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
	LeanTween.moveX(arg0_27.rtTopRight, arg0_27.rtTopRight.rect.width, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
	LeanTween.moveY(arg0_27.rtTopTitle, arg0_27.rtTopTitle.rect.height, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
	LeanTween.moveY(arg0_27.rtTopBottom, -arg0_27.rtTopRight.rect.height, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function()
		arg0_27.isTweening = false

		return existCall(arg1_27)
	end))
end

function var0_0.CancelUITween(arg0_29)
	LeanTween.cancel(go(arg0_29.rtTopTitle))
	LeanTween.cancel(go(arg0_29.rtTopLeft))
	LeanTween.cancel(go(arg0_29.rtTopRight))
	LeanTween.cancel(go(arg0_29.rtTopBottom))
end

function var0_0.SetPlayer(arg0_30, arg1_30)
	arg0_30.player = arg1_30

	arg0_30.resPanel:setPlayer(arg1_30)
end

function var0_0.SetAtlas(arg0_31, arg1_31)
	arg0_31.atlas = arg1_31

	arg0_31.atlas:AddListener(WorldAtlas.EventUpdateNGoodsCount, arg0_31.onUpdateNGoods)

	arg0_31.nGoodsDic = {}
	arg0_31.nGoodsPortDic = {}

	for iter0_31, iter1_31 in pairs(arg1_31.nShopGoodsDic) do
		arg0_31.nGoodsDic[iter0_31] = Goods.Create({
			id = iter0_31,
			count = iter1_31
		}, Goods.TYPE_WORLD_NSHOP)

		local var0_31 = arg0_31.nGoodsDic[iter0_31]:getConfig("port_id")

		arg0_31.nGoodsPortDic[var0_31] = arg0_31.nGoodsPortDic[var0_31] or {}

		table.insert(arg0_31.nGoodsPortDic[var0_31], arg0_31.nGoodsDic[iter0_31])
	end

	for iter2_31, iter3_31 in pairs(arg0_31.nGoodsPortDic) do
		table.sort(iter3_31, CompareFuncs({
			function(arg0_32)
				return -arg0_32:getConfig("priority")
			end,
			function(arg0_33)
				return arg0_33.id
			end
		}))
	end
end

function var0_0.SetPort(arg0_34, arg1_34)
	local var0_34 = nowWorld()

	arg0_34.port = arg1_34

	arg0_34.port:AddListener(WorldMapPort.EventUpdateTaskIds, arg0_34.onUpdateTasks)
	arg0_34.port:AddListener(WorldMapPort.EventUpdateGoods, arg0_34.onUpdateGoods)
	arg0_34:SetBg(arg0_34.port.id)

	arg0_34.refreshTimer = Timer.New(function()
		if arg0_34.port:IsValid() then
			arg0_34:UpdateRefreshTime(arg0_34.port.expiredTime - pg.TimeMgr.GetInstance():GetServerTime())
		else
			arg0_34:emit(WorldPortMediator.OnReqPort, var0_34:GetActiveMap().id)
		end
	end, 1, -1)

	arg0_34.refreshTimer:Start()
	arg0_34.refreshTimer.func()

	local var1_34 = var0_34:GetActiveMap():GetFleet()

	arg0_34.wsPortLeft = arg0_34:NewPortLeft()

	local var2_34 = arg0_34.port:GetRealm()

	setActive(arg0_34.btnOperation, var2_34 == 0 or var2_34 == var0_34:GetRealm())
	setActive(arg0_34.btnDockyard, var2_34 == 0 or var2_34 == var0_34:GetRealm())
	setActive(arg0_34.btnSupply, arg0_34.nGoodsPortDic[arg1_34.id])
	setActive(arg0_34.resPanel._tf, var0_34:IsSystemOpen(WorldConst.SystemResource))

	arg0_34.inventory = var0_34:GetInventoryProxy()

	arg0_34.inventory:AddListener(WorldInventoryProxy.EventUpdateItem, arg0_34.onUpdateMoneyCount)
	arg0_34:OnUpdateMoneyCount()

	arg0_34.taskProxy = var0_34:GetTaskProxy()

	arg0_34.taskProxy:AddListener(WorldTaskProxy.EventUpdateTask, arg0_34.onUpdateTasks)
end

function var0_0.SetBg(arg0_36, arg1_36)
	arg0_36.portBg = pg.world_port_data[arg1_36].port_bg

	setImageAlpha(arg0_36.rtBg, #arg0_36.portBg > 0 and 1 or 0)

	if #arg0_36.portBg > 0 then
		GetImageSpriteFromAtlasAsync("world/port/" .. arg0_36.portBg, "", arg0_36.rtBg)
	end

	arg0_36.enterIcon = pg.world_port_data[arg1_36].port_entrance_icon

	setActive(arg0_36.rtEnterIcon, #arg0_36.enterIcon > 0)

	if #arg0_36.enterIcon > 0 then
		GetImageSpriteFromAtlasAsync("world/porttitle/" .. arg0_36.enterIcon, "", arg0_36.rtEnterIcon, false)
	end

	GetImageSpriteFromAtlasAsync("world/portword/" .. arg0_36.portBg, "", arg0_36.rtImageTitle, true)
	GetImageSpriteFromAtlasAsync("world/portword/" .. arg0_36.portBg .. "_en", "", arg0_36.rtImageTitle:Find("Image"), true)
end

function var0_0.OnUpdateTasks(arg0_37)
	arg0_37:UpdateTaskTip()
	arg0_37:SetPageDirty(var0_0.PageTask)

	if arg0_37.page == var0_0.PageTask then
		arg0_37:UpdateTasks()
	end
end

function var0_0.OnUpdateGoods(arg0_38)
	arg0_38:UpdateCDTip()
	arg0_38:SetPageDirty(var0_0.PageShop)

	if arg0_38.page == var0_0.PageShop then
		arg0_38:UpdateGoods()
	end
end

function var0_0.OnUpdateNGoods(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39)
	if arg0_39.page == var0_0.PageNShop then
		local var0_39 = arg0_39.nGoodsDic[arg3_39]

		var0_39.buyCount = arg4_39

		local var1_39 = arg0_39.rtNGoodsDic[arg3_39]

		setText(var1_39:Find("count_contain/count"), var0_39:GetPurchasableCnt() .. "/" .. var0_39:GetLimitGoodCount())
		setActive(var1_39:Find("mask"), not var0_39:canPurchase())
		setActive(var1_39:Find("new"), false)
	else
		arg0_39:SetPageDirty(var0_0.PageNShop)
	end
end

function var0_0.SetPage(arg0_40, arg1_40)
	if arg0_40.page ~= arg1_40 then
		if var0_0.BlurPages[arg0_40.page or 0] ~= var0_0.BlurPages[arg1_40] then
			if var0_0.BlurPages[arg1_40] then
				pg.UIMgr.GetInstance():BlurPanel(arg0_40.rtBlurPanel, false)
			else
				pg.UIMgr.GetInstance():UnblurPanel(arg0_40.rtBlurPanel, arg0_40._tf)
			end
		end

		if arg1_40 == var0_0.PageShop and arg0_40.paintingName == "buzhihuo_shop" then
			arg0_40:showRandomShipWord(pg.navalacademy_shoppingstreet_template[1].words_enter, true, "enter")
		end

		arg0_40.page = arg1_40

		arg0_40:UpdatePage()

		arg0_40.contextData.page = arg1_40
	end
end

function var0_0.SetPageDirty(arg0_41, arg1_41)
	arg0_41.dirtyFlags[arg1_41] = true
end

function var0_0.IsPageDirty(arg0_42, arg1_42)
	return arg0_42.dirtyFlags[arg1_42] == true or arg0_42.dirtyFlags[arg1_42] == nil
end

function var0_0.UpdatePage(arg0_43)
	local var0_43 = arg0_43.page

	arg0_43:DisplayTopUI(var0_43)
	setActive(arg0_43.rtTasks, var0_43 == var0_0.PageTask)
	setActive(arg0_43.rtShop, var0_43 == var0_0.PageShop)
	setActive(arg0_43.rtNShop, var0_43 == var0_0.PageNShop)

	if arg0_43:IsPageDirty(var0_43) then
		if var0_43 == var0_0.PageTask then
			arg0_43:UpdateTasks()
		elseif var0_43 == var0_0.PageShop then
			arg0_43:UpdateGoods()
		elseif var0_43 == var0_0.PageNShop then
			arg0_43:UpdateNShopPorts()
		end
	end
end

function var0_0.UpdateTasks(arg0_44)
	arg0_44.dirtyFlags[var0_0.PageTask] = false

	local var0_44 = arg0_44.rtTasks:Find("frame/viewport/content")
	local var1_44 = var0_44:GetChild(0)
	local var2_44 = _.map(arg0_44.port.taskIds, function(arg0_45)
		return WorldTask.New({
			id = arg0_45
		})
	end)

	table.sort(var2_44, CompareFuncs(WorldTask.sortDic))
	UIItemList.StaticAlign(var0_44, var1_44, #var2_44, function(arg0_46, arg1_46, arg2_46)
		local var0_46 = arg1_46 + 1

		if arg0_46 == UIItemList.EventUpdate then
			local var1_46 = var2_44[var0_46]

			arg0_44.wsTasks[var0_46] = arg0_44.wsTasks[var0_46] or WSPortTask.New(arg2_46)

			local var2_46 = arg0_44.wsTasks[var0_46]

			var2_46:Setup(var1_46)
			onButton(arg0_44, var2_46.btnInactive, function()
				arg0_44:emit(WorldPortMediator.OnAccepetTask, var1_46, arg0_44.port.id)
			end, SFX_PANEL)
			onButton(arg0_44, var2_46.btnOnGoing, function()
				arg0_44:showTaskWindow(var1_46)
			end, SFX_PANEL)
			onButton(arg0_44, var2_46.btnFinished, function()
				arg0_44:emit(WorldPortMediator.OnSubmitTask, var1_46)
			end, SFX_PANEL)

			function var2_46.onDrop(arg0_50)
				arg0_44:emit(var0_0.ON_DROP, arg0_50)
			end
		end
	end)

	local var3_44 = arg0_44.rtTasks:Find("frame/empty")

	setActive(var3_44, #var2_44 == 0)
end

function var0_0.DisposeTasks(arg0_51)
	_.each(arg0_51.wsTasks, function(arg0_52)
		arg0_52:Dispose()
	end)

	arg0_51.wsTasks = {}
end

function var0_0.UpdateGoods(arg0_53)
	arg0_53.dirtyFlags[var0_0.PageShop] = false

	local var0_53 = arg0_53.rtShop:Find("frame/scrollview/view")
	local var1_53 = var0_53:GetChild(0)
	local var2_53 = underscore.rest(arg0_53.port.goods, 1)

	table.sort(var2_53, CompareFuncs({
		function(arg0_54)
			return -arg0_54.config.priority
		end,
		function(arg0_55)
			return arg0_55.id
		end
	}))
	UIItemList.StaticAlign(var0_53, var1_53, #var2_53, function(arg0_56, arg1_56, arg2_56)
		arg1_56 = arg1_56 + 1

		if arg0_56 == UIItemList.EventUpdate then
			local var0_56 = var2_53[arg1_56]

			arg0_53.wsGoods[arg1_56] = arg0_53.wsGoods[arg1_56] or WSPortGoods.New(arg2_56)

			local var1_56 = arg0_53.wsGoods[arg1_56]

			var1_56:Setup(var0_56)
			onButton(arg0_53, var1_56.transform, function()
				if var0_56.count > 0 then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						yesText = "text_buy",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = var0_56.item,
						onYes = function()
							arg0_53:emit(WorldPortMediator.OnBuyGoods, var0_56)
						end
					})
				end
			end, SFX_PANEL)
		end
	end)
end

function var0_0.DisposeGoods(arg0_59)
	_.each(arg0_59.wsGoods, function(arg0_60)
		arg0_60:Dispose()
	end)

	arg0_59.wsGoods = {}
end

function var0_0.UpdateNShopPorts(arg0_61)
	arg0_61.dirtyFlags[var0_0.PageNShop] = false

	local var0_61 = underscore.keys(arg0_61.nGoodsPortDic)

	table.sort(var0_61)

	for iter0_61, iter1_61 in ipairs(var0_61) do
		if not arg0_61.poolTplPort[iter0_61] then
			table.insert(arg0_61.poolTplPort, cloneTplTo(arg0_61.tplPort, arg0_61.containerPort))
		end

		local var1_61 = arg0_61.poolTplPort[iter0_61]

		setText(var1_61:Find("Text"), pg.world_port_data[iter1_61].name)
		setActive(var1_61:Find("tip"), arg0_61.atlas.markPortDic.newGoods[iter1_61])
		onToggle(arg0_61, var1_61, function(arg0_62)
			if arg0_62 then
				if arg0_61.nShopPortId == iter1_61 then
					return
				end

				setActive(var1_61:Find("tip"), false)
				arg0_61.atlas:UpdatePortMarkNShop(iter1_61, false)
				arg0_61:UpdateNShopTip()
				arg0_61:UpdateNShopGoods(iter1_61)
			end
		end, SFX_PANEL)
		triggerToggle(var1_61, iter1_61 == arg0_61.port.id)
	end
end

function var0_0.UpdateNShopGoods(arg0_63, arg1_63)
	arg0_63.nShopPortId = arg1_63

	local var0_63 = arg0_63.atlas:GetPressingUnlockCount()
	local var1_63 = arg0_63.atlas:GetPressingUnlockRecordCount(arg1_63)
	local var2_63 = {}

	for iter0_63, iter1_63 in ipairs(arg0_63.nGoodsPortDic[arg1_63]) do
		local var3_63 = iter1_63:getConfig("unlock_num")

		var2_63[var3_63] = var2_63[var3_63] or {}

		table.insert(var2_63[var3_63], iter1_63)
	end

	arg0_63.rtNGoodsDic = {}

	local var4_63 = underscore.keys(var2_63)

	table.sort(var4_63)
	UIItemList.StaticAlign(arg0_63.rtNGoodsContainer, arg0_63.rtNGoodsContainer:Find("group"), #var4_63, function(arg0_64, arg1_64, arg2_64)
		arg1_64 = arg1_64 + 1

		if arg0_64 == UIItemList.EventUpdate then
			local var0_64 = var4_63[arg1_64]

			setActive(arg2_64:Find("title"), arg1_64 > 1)
			setText(arg2_64:Find("title/other/Text"), i18n("world_instruction_port_goods_locked"))
			setText(arg2_64:Find("title/other/progress"), math.min(var0_63, var0_64) .. "/" .. var0_64)

			local var1_64 = arg2_64:Find("container")

			UIItemList.StaticAlign(var1_64, var1_64:Find("item_tpl"), #var2_63[var0_64], function(arg0_65, arg1_65, arg2_65)
				arg1_65 = arg1_65 + 1

				if arg0_65 == UIItemList.EventUpdate then
					local var0_65 = var2_63[var0_64][arg1_65]

					arg0_63.rtNGoodsDic[var0_65.id] = arg2_65

					local var1_65 = var0_65:GetDropInfo()

					updateDrop(arg2_65:Find("IconTpl"), var1_65)
					setText(arg2_65:Find("name_mask/name"), shortenString(var1_65:getConfig("name"), 6))

					local var2_65 = var0_65:GetPriceInfo()

					GetImageSpriteFromAtlasAsync(var2_65:getIcon(), "", arg2_65:Find("consume/contain/icon"), false)
					setText(arg2_65:Find("consume/contain/Text"), var2_65.count)
					setText(arg2_65:Find("count_contain/count"), var0_65:GetPurchasableCnt() .. "/" .. var0_65:GetLimitGoodCount())
					setText(arg2_65:Find("count_contain/label"), i18n("activity_shop_exchange_count"))
					setText(arg2_65:Find("mask/tag/sellout_tag"), i18n("word_sell_out"))
					setActive(arg2_65:Find("mask"), not var0_65:canPurchase())
					setText(arg2_65:Find("lock/Image/Text"), i18n("word_sell_lock"))
					setActive(arg2_65:Find("lock"), var0_63 < var0_64)
					setActive(arg2_65:Find("new"), var0_65.buyCount == 0 and var1_63 < var0_64 and var0_64 <= var0_63)
					onButton(arg0_63, arg2_65, function()
						(var0_65:GetLimitGoodCount() > 1 and arg0_63.multiWindow or arg0_63.singleWindow):ExecuteAction("Open", var0_65, function(arg0_67, arg1_67)
							arg0_63:emit(WorldPortMediator.OnBuyNShopGoods, arg0_67, arg1_67)
						end)
					end, SFX_PANEL)
				end
			end)
		end
	end)
	arg0_63.atlas:SetPressingUnlockRecordCount(arg1_63, var0_63)
end

function var0_0.OnUpdateMoneyCount(arg0_68, arg1_68, arg2_68, arg3_68)
	if not arg1_68 or arg3_68.id == WorldItem.PortMoneyId then
		local var0_68 = arg0_68.inventory:GetItemCount(WorldItem.PortMoneyId)

		setText(arg0_68.rtShop:Find("quick_count/value"), var0_68)
		setText(arg0_68.rtNShopRes:Find("Text"), var0_68)
	end
end

function var0_0.UpdateRefreshTime(arg0_69, arg1_69)
	setText(arg0_69.cdTF:Find("Text"), pg.TimeMgr.GetInstance():DescCDTime(arg1_69))
end

function var0_0.UpdateCDTip(arg0_70)
	setActive(arg0_70.cdTF, #arg0_70.port.goods > 0 and not arg0_70.port:IsTempPort())
	setActive(arg0_70.emptyTF, #arg0_70.port.goods == 0)

	if not nowWorld():UsePortNShop() then
		setActive(arg0_70.btnSupply:Find("new"), nowWorld():GetAtlas().markPortDic.goods[arg0_70.port.id])
	end
end

function var0_0.UpdateTaskTip(arg0_71)
	setActive(arg0_71.btnOperation:Find("new"), false)
end

function var0_0.UpdateNShopTip(arg0_72)
	if nowWorld():UsePortNShop() then
		setActive(arg0_72.btnSupply:Find("new"), arg0_72.atlas:GetAnyPortMarkNShop())
	end
end

function var0_0.showTaskWindow(arg0_73, arg1_73)
	local var0_73 = arg1_73.config.rare_task_icon
	local var1_73 = arg0_73.rtTaskWindow:Find("main_window/left_panel")

	setActive(var1_73:Find("bg"), arg1_73:IsSpecialType())

	if #var0_73 > 0 then
		GetImageSpriteFromAtlasAsync("shipyardicon/" .. var0_73, "", var1_73:Find("card"), true)
	else
		GetImageSpriteFromAtlasAsync("ui/worldportui_atlas", "nobody", var1_73:Find("card"), true)
	end

	local var2_73 = arg0_73.rtTaskWindow:Find("main_window/right_panel")

	setText(var2_73:Find("title/Text"), arg1_73.config.name)
	setText(var2_73:Find("content/desc"), arg1_73.config.rare_task_text)
	setText(var2_73:Find("content/slider_progress/Text"), arg1_73:getProgress() .. "/" .. arg1_73:getMaxProgress())
	setSlider(var2_73:Find("content/slider"), 0, arg1_73:getMaxProgress(), arg1_73:getProgress())

	local var3_73 = var2_73:Find("content/item_tpl")
	local var4_73 = var2_73:Find("content/award_bg/panel/content")
	local var5_73 = arg1_73.config.show

	removeAllChildren(var4_73)

	for iter0_73, iter1_73 in ipairs(var5_73) do
		local var6_73 = cloneTplTo(var3_73, var4_73)
		local var7_73 = {
			type = iter1_73[1],
			id = iter1_73[2],
			count = iter1_73[3]
		}

		updateDrop(var6_73, var7_73)
		onButton(arg0_73, var6_73, function()
			arg0_73:emit(var0_0.ON_DROP, var7_73)
		end, SFX_PANEL)
		setActive(var6_73, true)
	end

	setActive(var3_73, false)
	setActive(var2_73:Find("content/award_bg/arror"), #var5_73 > 3)
	onButton(arg0_73, var2_73:Find("btn_close"), function()
		arg0_73:hideTaskWindow()
	end, SFX_CANCEL)
	onButton(arg0_73, arg0_73.rtTaskWindow:Find("bg"), function()
		arg0_73:hideTaskWindow()
	end, SFX_CANCEL)
	onButton(arg0_73, var2_73:Find("btn_go"), function()
		arg0_73:hideTaskWindow()
		arg0_73:emit(WorldPortMediator.OnTaskGoto, arg1_73.id)
	end, SFX_PANEL)
	setButtonEnabled(var2_73:Find("btn_go"), arg1_73:GetFollowingAreaId() or arg1_73:GetFollowingEntrance())
	setActive(arg0_73.rtTaskWindow, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_73.rtTaskWindow, arg0_73._tf)
end

function var0_0.hideTaskWindow(arg0_78)
	setActive(arg0_78.rtTaskWindow, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_78.rtTaskWindow, arg0_78._tf)
end

return var0_0
