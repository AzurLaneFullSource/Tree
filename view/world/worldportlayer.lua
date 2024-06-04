local var0 = class("WorldPortLayer", import("..base.BaseUI"))

var0.Listeners = {
	onUpdateGoods = "OnUpdateGoods",
	onUpdateMoneyCount = "OnUpdateMoneyCount",
	onUpdateTasks = "OnUpdateTasks",
	onUpdateNGoods = "OnUpdateNGoods"
}
var0.TitleName = {
	"text_gangkou",
	"text_operation",
	"text_supply"
}
var0.PageMain = 0
var0.PageTask = 1
var0.PageShop = 2
var0.PageDockyard = 3
var0.PageNShop = 4
var0.BlurPages = {
	[var0.PageTask] = true,
	[var0.PageShop] = true,
	[var0.PageNShop] = true
}
var0.optionsPath = {
	"blur_panel/adapt/top/title/option"
}

function var0.getUIName(arg0)
	return "WorldPortUI"
end

function var0.init(arg0)
	for iter0, iter1 in pairs(var0.Listeners) do
		arg0[iter0] = function(...)
			var0[iter1](arg0, ...)
		end
	end

	arg0.rtBg = arg0:findTF("bg")
	arg0.rtEnterIcon = arg0.rtBg:Find("enter_icon")
	arg0.rtBgNShop = arg0._tf:Find("bg_2")
	arg0.rtBlurPanel = arg0:findTF("blur_panel")
	arg0.rtTasks = arg0.rtBlurPanel:Find("adapt/tasks")
	arg0.rtShop = arg0.rtBlurPanel:Find("adapt/shop")
	arg0.rtPainting = arg0.rtShop:Find("paint")
	arg0.btnPainting = arg0.rtShop:Find("paint_touch")

	setActive(arg0.btnPainting, false)

	arg0.rtChat = arg0.rtShop:Find("chat")

	setActive(arg0.rtChat, false)

	arg0.rtNShop = arg0.rtBlurPanel:Find("adapt/new_shop")
	arg0.containerPort = arg0.rtNShop:Find("frame/content/left")
	arg0.tplPort = arg0.containerPort:Find("port_tpl")
	arg0.poolTplPort = {
		arg0.tplPort
	}
	arg0.rtNGoodsContainer = arg0.rtNShop:Find("frame/content/right/page/view/content")
	arg0.rtNShopRes = arg0.rtNShop:Find("frame/content/right/page/title/res")

	local var0 = Drop.New({
		type = DROP_TYPE_WORLD_ITEM,
		id = WorldItem.PortMoneyId
	})

	GetImageSpriteFromAtlasAsync(var0:getIcon(), "", arg0.rtNShopRes:Find("icon/Image"), false)
	setText(arg0.rtNShopRes:Find("icon/name"), var0:getName())

	arg0.rtTop = arg0.rtBlurPanel:Find("adapt/top")
	arg0.btnBack = arg0.rtTop:Find("title/back_button")
	arg0.rtTopTitle = arg0.rtTop:Find("title")
	arg0.rtImageTitle = arg0.rtTopTitle:Find("print/title")
	arg0.rtImageTitleTask = arg0.rtTopTitle:Find("print/title_task")
	arg0.rtImageTitleShop = arg0.rtTopTitle:Find("print/title_shop")
	arg0.rtTopLeft = arg0.rtTop:Find("left_stage")
	arg0.rtTopRight = arg0.rtTop:Find("right_stage")
	arg0.wsWorldInfo = WSWorldInfo.New()
	arg0.wsWorldInfo.transform = arg0.rtTopRight:Find("display_panel/world_info")

	arg0.wsWorldInfo:Setup()
	setText(arg0.rtTopRight:Find("display_panel/title/title"), i18n("world_map_title_tips"))
	setText(arg0.rtTopRight:Find("display_panel/title/title_en"), i18n("world_map_title_tips_en"))
	setText(arg0.wsWorldInfo.transform:Find("power/bg/Word"), i18n("world_total_power"))
	setText(arg0.wsWorldInfo.transform:Find("explore/mileage/Text"), i18n("world_mileage"))
	setText(arg0.wsWorldInfo.transform:Find("explore/pressing/Text"), i18n("world_pressing"))

	arg0.rtTopBottom = arg0.rtTop:Find("bottom_stage")
	arg0.btnOperation = arg0.rtTopBottom:Find("btn/operation")
	arg0.btnSupply = arg0.rtTopBottom:Find("btn/supply")
	arg0.btnDockyard = arg0.rtTopBottom:Find("btn/dockyard")
	arg0.resPanel = WorldResource.New()

	arg0.resPanel._tf:SetParent(arg0.rtTop:Find("title/resources"), false)

	arg0.rtTaskWindow = arg0:findTF("task_window")
	arg0.wsTasks = {}
	arg0.wsGoods = {}
	arg0.page = -1
	arg0.dirtyFlags = {}
	arg0.cdTF = arg0.rtShop:Find("timer_bg")
	arg0.emptyTF = arg0.rtShop:Find("frame/scrollview/empty")
	arg0.refreshBtn = arg0.rtShop:Find("refresh_btn")

	setActive(arg0.refreshBtn, false)

	arg0.glitchArtMaterial = arg0:findTF("resource/material1"):GetComponent(typeof(Image)).material
	arg0.singleWindow = OriginShopSingleWindow.New(arg0._tf, arg0.event)
	arg0.multiWindow = OriginShopMultiWindow.New(arg0._tf, arg0.event)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData()
	})
	onButton(arg0, arg0.btnBack, function()
		if arg0.isTweening then
			return
		end

		if arg0.port:IsTempPort() or arg0.page == var0.PageMain then
			arg0:EaseOutUI(function()
				arg0:closeView()
			end)
		else
			arg0:SetPage(var0.PageMain)
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnOperation, function()
		arg0:SetPage(var0.PageTask)
	end, SFX_PANEL)
	onButton(arg0, arg0.btnSupply, function()
		if nowWorld():UsePortNShop() then
			arg0:SetPage(var0.PageNShop)
		else
			arg0:SetPage(var0.PageShop)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.btnDockyard, function()
		arg0:emit(WorldPortMediator.OnOpenBay)
	end, SFX_PANEL)
	arg0:UpdatePainting(arg0:GetPaintingInfo())
	arg0:UpdateTaskTip()
	arg0:UpdateCDTip()
	arg0:UpdateNShopTip()

	if arg0.port:IsTempPort() then
		arg0.contextData.page = WorldPortLayer.PageShop
	elseif arg0.contextData.page == WorldPortLayer.PageDockyard then
		arg0.contextData.page = nil
	end

	arg0:SetPage(arg0.contextData.page or WorldPortLayer.PageMain)
	arg0:EaseInUI()
end

function var0.onBackPressed(arg0)
	triggerButton(arg0.btnBack)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0:RecyclePainting(arg0.rtPainting)
	arg0.singleWindow:Destroy()
	arg0.multiWindow:Destroy()

	arg0.contextData.isEnter = true

	if var0.BlurPages[arg0.page] then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.rtBlurPanel, arg0._tf)
	end

	arg0:CancelUITween()
	arg0:DisposeTopUI()
	arg0:DisposeTasks()
	arg0:DisposeGoods()
	arg0.atlas:RemoveListener(WorldAtlas.EventUpdateNGoodsCount, arg0.onUpdateNGoods)

	arg0.atlas = nil

	arg0.port:RemoveListener(WorldMapPort.EventUpdateTaskIds, arg0.onUpdateTasks)
	arg0.port:RemoveListener(WorldMapPort.EventUpdateGoods, arg0.onUpdateGoods)

	arg0.port = nil

	arg0.resPanel:exit()

	arg0.resPanel = nil

	arg0.refreshTimer:Stop()

	arg0.refreshTimer = nil

	arg0.inventory:RemoveListener(WorldInventoryProxy.EventUpdateItem, arg0.onUpdateMoneyCount)

	arg0.inventory = nil

	arg0.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateTask, arg0.onUpdateTasks)

	arg0.taskProxy = nil

	arg0.wsWorldInfo:Dispose()

	arg0.wsWorldInfo = nil
end

function var0.GetPaintingInfo(arg0)
	if arg0.port:IsTempPort() then
		return "mingshi", false
	else
		return "tbniang", true
	end
end

function var0.UpdatePainting(arg0, arg1, arg2)
	arg0.paintingName = arg1

	setPaintingPrefab(arg0.rtPainting, arg1, "chuanwu")

	if arg2 then
		arg0:AddGlitchArtEffectForPating(arg0.rtPainting)
	end
end

function var0.AddGlitchArtEffectForPating(arg0, arg1)
	local var0 = arg1:GetComponentsInChildren(typeof(Image))

	for iter0 = 0, var0.Length - 1 do
		var0[iter0].material = arg0.glitchArtMaterial
	end
end

function var0.RecyclePainting(arg0, arg1)
	if arg1:Find("fitter").childCount > 0 then
		local var0 = arg1:GetComponentsInChildren(typeof(Image))

		for iter0 = 0, var0.Length - 1 do
			local var1 = var0[iter0]
			local var2 = Color.white

			if var1.material ~= var1.defaultGraphicMaterial then
				var1.material = var1.defaultGraphicMaterial

				var1.material:SetColor("_Color", var2)
			end
		end

		setGray(arg1, false, true)

		local var3 = arg1:Find("fitter"):GetChild(0)

		retPaintingPrefab(arg1, var3.name)

		local var4 = var3:Find("temp_mask")

		if var4 then
			Destroy(var4)
		end
	end
end

function var0.DisplayTopUI(arg0, arg1)
	setActive(arg0.rtImageTitle, arg1 == var0.PageMain)
	setActive(arg0.rtImageTitleTask, arg1 == var0.PageTask)
	setActive(arg0.rtImageTitleShop, arg1 == var0.PageShop or arg1 == var0.PageNShop)
	setActive(arg0.rtTopLeft, arg1 ~= var0.PageNShop)
	setActive(arg0.rtTopRight, arg1 == var0.PageMain)
	setActive(arg0.rtTopBottom, arg1 == var0.PageMain)
	setActive(arg0.rtBg, arg1 ~= var0.PageNShop)
	setActive(arg0.rtBgNShop, arg1 == var0.PageNShop)
end

function var0.DisposeTopUI(arg0)
	arg0.wsPortLeft:Dispose()
end

function var0.NewPortLeft(arg0)
	local var0 = WSPortLeft.New()

	var0.transform = arg0.rtTopLeft

	var0:Setup()
	var0:UpdateMap(nowWorld():GetActiveMap())

	return var0
end

function var0.EnterPortAnim(arg0, arg1)
	local var0 = arg0.rtEnterIcon:GetComponent(typeof(DftAniEvent))

	if var0 then
		var0:SetTriggerEvent(function(arg0)
			arg1()
		end)
		var0:SetEndEvent(function(arg0)
			setActive(arg0.rtEnterIcon, false)
		end)
	end

	setActive(arg0.rtEnterIcon, true)
end

function var0.EaseInUI(arg0, arg1)
	arg0.isTweening = true

	local var0 = {}

	arg0:CancelUITween()

	if #arg0.enterIcon > 0 and not arg0.contextData.isEnter then
		table.insert(var0, function(arg0)
			setActive(arg0.rtTop, false)
			arg0:EnterPortAnim(function()
				setActive(arg0.rtTop, true)

				return arg0()
			end)
		end)
	else
		setActive(arg0.rtEnterIcon, false)
	end

	seriesAsync(var0, function()
		setAnchoredPosition(arg0.rtTopLeft, {
			x = -arg0.rtTopLeft.rect.width
		})
		setAnchoredPosition(arg0.rtTopRight, {
			x = arg0.rtTopRight.rect.width
		})
		setAnchoredPosition(arg0.rtTopTitle, {
			y = arg0.rtTopTitle.rect.height
		})
		setAnchoredPosition(arg0.rtTopBottom, {
			y = -arg0.rtTopRight.rect.height
		})
		LeanTween.moveX(arg0.rtTopLeft, 0, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
		LeanTween.moveX(arg0.rtTopRight, 0, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
		LeanTween.moveY(arg0.rtTopTitle, 0, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
		LeanTween.moveY(arg0.rtTopBottom, 0, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function()
			arg0.isTweening = false

			return existCall(arg1)
		end))
	end)
end

function var0.EaseOutUI(arg0, arg1)
	arg0:CancelUITween()
	LeanTween.moveX(arg0.rtTopLeft, -arg0.rtTopLeft.rect.width, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
	LeanTween.moveX(arg0.rtTopRight, arg0.rtTopRight.rect.width, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
	LeanTween.moveY(arg0.rtTopTitle, arg0.rtTopTitle.rect.height, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
	LeanTween.moveY(arg0.rtTopBottom, -arg0.rtTopRight.rect.height, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function()
		arg0.isTweening = false

		return existCall(arg1)
	end))
end

function var0.CancelUITween(arg0)
	LeanTween.cancel(go(arg0.rtTopTitle))
	LeanTween.cancel(go(arg0.rtTopLeft))
	LeanTween.cancel(go(arg0.rtTopRight))
	LeanTween.cancel(go(arg0.rtTopBottom))
end

function var0.SetPlayer(arg0, arg1)
	arg0.player = arg1

	arg0.resPanel:setPlayer(arg1)
end

function var0.SetAtlas(arg0, arg1)
	arg0.atlas = arg1

	arg0.atlas:AddListener(WorldAtlas.EventUpdateNGoodsCount, arg0.onUpdateNGoods)

	arg0.nGoodsDic = {}
	arg0.nGoodsPortDic = {}

	for iter0, iter1 in pairs(arg1.nShopGoodsDic) do
		arg0.nGoodsDic[iter0] = Goods.Create({
			id = iter0,
			count = iter1
		}, Goods.TYPE_WORLD_NSHOP)

		local var0 = arg0.nGoodsDic[iter0]:getConfig("port_id")

		arg0.nGoodsPortDic[var0] = arg0.nGoodsPortDic[var0] or {}

		table.insert(arg0.nGoodsPortDic[var0], arg0.nGoodsDic[iter0])
	end

	for iter2, iter3 in pairs(arg0.nGoodsPortDic) do
		table.sort(iter3, CompareFuncs({
			function(arg0)
				return -arg0:getConfig("priority")
			end,
			function(arg0)
				return arg0.id
			end
		}))
	end
end

function var0.SetPort(arg0, arg1)
	local var0 = nowWorld()

	arg0.port = arg1

	arg0.port:AddListener(WorldMapPort.EventUpdateTaskIds, arg0.onUpdateTasks)
	arg0.port:AddListener(WorldMapPort.EventUpdateGoods, arg0.onUpdateGoods)
	arg0:SetBg(arg0.port.id)

	arg0.refreshTimer = Timer.New(function()
		if arg0.port:IsValid() then
			arg0:UpdateRefreshTime(arg0.port.expiredTime - pg.TimeMgr.GetInstance():GetServerTime())
		else
			arg0:emit(WorldPortMediator.OnReqPort, var0:GetActiveMap().id)
		end
	end, 1, -1)

	arg0.refreshTimer:Start()
	arg0.refreshTimer.func()

	local var1 = var0:GetActiveMap():GetFleet()

	arg0.wsPortLeft = arg0:NewPortLeft()

	local var2 = arg0.port:GetRealm()

	setActive(arg0.btnOperation, var2 == 0 or var2 == var0:GetRealm())
	setActive(arg0.btnDockyard, var2 == 0 or var2 == var0:GetRealm())
	setActive(arg0.btnSupply, arg0.nGoodsPortDic[arg1.id])
	setActive(arg0.resPanel._tf, var0:IsSystemOpen(WorldConst.SystemResource))

	arg0.inventory = var0:GetInventoryProxy()

	arg0.inventory:AddListener(WorldInventoryProxy.EventUpdateItem, arg0.onUpdateMoneyCount)
	arg0:OnUpdateMoneyCount()

	arg0.taskProxy = var0:GetTaskProxy()

	arg0.taskProxy:AddListener(WorldTaskProxy.EventUpdateTask, arg0.onUpdateTasks)
end

function var0.SetBg(arg0, arg1)
	arg0.portBg = pg.world_port_data[arg1].port_bg

	setImageAlpha(arg0.rtBg, #arg0.portBg > 0 and 1 or 0)

	if #arg0.portBg > 0 then
		GetImageSpriteFromAtlasAsync("world/port/" .. arg0.portBg, "", arg0.rtBg)
	end

	arg0.enterIcon = pg.world_port_data[arg1].port_entrance_icon

	setActive(arg0.rtEnterIcon, #arg0.enterIcon > 0)

	if #arg0.enterIcon > 0 then
		GetImageSpriteFromAtlasAsync("world/porttitle/" .. arg0.enterIcon, "", arg0.rtEnterIcon, false)
	end

	GetImageSpriteFromAtlasAsync("world/portword/" .. arg0.portBg, "", arg0.rtImageTitle, true)
	GetImageSpriteFromAtlasAsync("world/portword/" .. arg0.portBg .. "_en", "", arg0.rtImageTitle:Find("Image"), true)
end

function var0.OnUpdateTasks(arg0)
	arg0:UpdateTaskTip()
	arg0:SetPageDirty(var0.PageTask)

	if arg0.page == var0.PageTask then
		arg0:UpdateTasks()
	end
end

function var0.OnUpdateGoods(arg0)
	arg0:UpdateCDTip()
	arg0:SetPageDirty(var0.PageShop)

	if arg0.page == var0.PageShop then
		arg0:UpdateGoods()
	end
end

function var0.OnUpdateNGoods(arg0, arg1, arg2, arg3, arg4)
	if arg0.page == var0.PageNShop then
		local var0 = arg0.nGoodsDic[arg3]

		var0.buyCount = arg4

		local var1 = arg0.rtNGoodsDic[arg3]

		setText(var1:Find("count_contain/count"), var0:GetPurchasableCnt() .. "/" .. var0:GetLimitGoodCount())
		setActive(var1:Find("mask"), not var0:canPurchase())
		setActive(var1:Find("new"), false)
	else
		arg0:SetPageDirty(var0.PageNShop)
	end
end

function var0.SetPage(arg0, arg1)
	if arg0.page ~= arg1 then
		if var0.BlurPages[arg0.page or 0] ~= var0.BlurPages[arg1] then
			if var0.BlurPages[arg1] then
				pg.UIMgr.GetInstance():BlurPanel(arg0.rtBlurPanel, false)
			else
				pg.UIMgr.GetInstance():UnblurPanel(arg0.rtBlurPanel, arg0._tf)
			end
		end

		if arg1 == var0.PageShop and arg0.paintingName == "buzhihuo_shop" then
			arg0:showRandomShipWord(pg.navalacademy_shoppingstreet_template[1].words_enter, true, "enter")
		end

		arg0.page = arg1

		arg0:UpdatePage()

		arg0.contextData.page = arg1
	end
end

function var0.SetPageDirty(arg0, arg1)
	arg0.dirtyFlags[arg1] = true
end

function var0.IsPageDirty(arg0, arg1)
	return arg0.dirtyFlags[arg1] == true or arg0.dirtyFlags[arg1] == nil
end

function var0.UpdatePage(arg0)
	local var0 = arg0.page

	arg0:DisplayTopUI(var0)
	setActive(arg0.rtTasks, var0 == var0.PageTask)
	setActive(arg0.rtShop, var0 == var0.PageShop)
	setActive(arg0.rtNShop, var0 == var0.PageNShop)

	if arg0:IsPageDirty(var0) then
		if var0 == var0.PageTask then
			arg0:UpdateTasks()
		elseif var0 == var0.PageShop then
			arg0:UpdateGoods()
		elseif var0 == var0.PageNShop then
			arg0:UpdateNShopPorts()
		end
	end
end

function var0.UpdateTasks(arg0)
	arg0.dirtyFlags[var0.PageTask] = false

	local var0 = arg0.rtTasks:Find("frame/viewport/content")
	local var1 = var0:GetChild(0)
	local var2 = _.map(arg0.port.taskIds, function(arg0)
		return WorldTask.New({
			id = arg0
		})
	end)

	table.sort(var2, CompareFuncs(WorldTask.sortDic))
	UIItemList.StaticAlign(var0, var1, #var2, function(arg0, arg1, arg2)
		local var0 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var1 = var2[var0]

			arg0.wsTasks[var0] = arg0.wsTasks[var0] or WSPortTask.New(arg2)

			local var2 = arg0.wsTasks[var0]

			var2:Setup(var1)
			onButton(arg0, var2.btnInactive, function()
				arg0:emit(WorldPortMediator.OnAccepetTask, var1, arg0.port.id)
			end, SFX_PANEL)
			onButton(arg0, var2.btnOnGoing, function()
				arg0:showTaskWindow(var1)
			end, SFX_PANEL)
			onButton(arg0, var2.btnFinished, function()
				arg0:emit(WorldPortMediator.OnSubmitTask, var1)
			end, SFX_PANEL)

			function var2.onDrop(arg0)
				arg0:emit(var0.ON_DROP, arg0)
			end
		end
	end)

	local var3 = arg0.rtTasks:Find("frame/empty")

	setActive(var3, #var2 == 0)
end

function var0.DisposeTasks(arg0)
	_.each(arg0.wsTasks, function(arg0)
		arg0:Dispose()
	end)

	arg0.wsTasks = {}
end

function var0.UpdateGoods(arg0)
	arg0.dirtyFlags[var0.PageShop] = false

	local var0 = arg0.rtShop:Find("frame/scrollview/view")
	local var1 = var0:GetChild(0)
	local var2 = underscore.rest(arg0.port.goods, 1)

	table.sort(var2, CompareFuncs({
		function(arg0)
			return -arg0.config.priority
		end,
		function(arg0)
			return arg0.id
		end
	}))
	UIItemList.StaticAlign(var0, var1, #var2, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var2[arg1]

			arg0.wsGoods[arg1] = arg0.wsGoods[arg1] or WSPortGoods.New(arg2)

			local var1 = arg0.wsGoods[arg1]

			var1:Setup(var0)
			onButton(arg0, var1.transform, function()
				if var0.count > 0 then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						yesText = "text_buy",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = var0.item,
						onYes = function()
							arg0:emit(WorldPortMediator.OnBuyGoods, var0)
						end
					})
				end
			end, SFX_PANEL)
		end
	end)
end

function var0.DisposeGoods(arg0)
	_.each(arg0.wsGoods, function(arg0)
		arg0:Dispose()
	end)

	arg0.wsGoods = {}
end

function var0.UpdateNShopPorts(arg0)
	arg0.dirtyFlags[var0.PageNShop] = false

	local var0 = underscore.keys(arg0.nGoodsPortDic)

	table.sort(var0)

	for iter0, iter1 in ipairs(var0) do
		if not arg0.poolTplPort[iter0] then
			table.insert(arg0.poolTplPort, cloneTplTo(arg0.tplPort, arg0.containerPort))
		end

		local var1 = arg0.poolTplPort[iter0]

		setText(var1:Find("Text"), pg.world_port_data[iter1].name)
		setActive(var1:Find("tip"), arg0.atlas.markPortDic.newGoods[iter1])
		onToggle(arg0, var1, function(arg0)
			if arg0 then
				if arg0.nShopPortId == iter1 then
					return
				end

				setActive(var1:Find("tip"), false)
				arg0.atlas:UpdatePortMarkNShop(iter1, false)
				arg0:UpdateNShopTip()
				arg0:UpdateNShopGoods(iter1)
			end
		end, SFX_PANEL)
		triggerToggle(var1, iter1 == arg0.port.id)
	end
end

function var0.UpdateNShopGoods(arg0, arg1)
	arg0.nShopPortId = arg1

	local var0 = arg0.atlas:GetPressingUnlockCount()
	local var1 = arg0.atlas:GetPressingUnlockRecordCount(arg1)
	local var2 = {}

	for iter0, iter1 in ipairs(arg0.nGoodsPortDic[arg1]) do
		local var3 = iter1:getConfig("unlock_num")

		var2[var3] = var2[var3] or {}

		table.insert(var2[var3], iter1)
	end

	arg0.rtNGoodsDic = {}

	local var4 = underscore.keys(var2)

	table.sort(var4)
	UIItemList.StaticAlign(arg0.rtNGoodsContainer, arg0.rtNGoodsContainer:Find("group"), #var4, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var4[arg1]

			setActive(arg2:Find("title"), arg1 > 1)
			setText(arg2:Find("title/other/Text"), i18n("world_instruction_port_goods_locked"))
			setText(arg2:Find("title/other/progress"), math.min(var0, var0) .. "/" .. var0)

			local var1 = arg2:Find("container")

			UIItemList.StaticAlign(var1, var1:Find("item_tpl"), #var2[var0], function(arg0, arg1, arg2)
				arg1 = arg1 + 1

				if arg0 == UIItemList.EventUpdate then
					local var0 = var2[var0][arg1]

					arg0.rtNGoodsDic[var0.id] = arg2

					local var1 = var0:GetDropInfo()

					updateDrop(arg2:Find("IconTpl"), var1)
					setText(arg2:Find("name_mask/name"), shortenString(var1:getConfig("name"), 6))

					local var2 = var0:GetPriceInfo()

					GetImageSpriteFromAtlasAsync(var2:getIcon(), "", arg2:Find("consume/contain/icon"), false)
					setText(arg2:Find("consume/contain/Text"), var2.count)
					setText(arg2:Find("count_contain/count"), var0:GetPurchasableCnt() .. "/" .. var0:GetLimitGoodCount())
					setText(arg2:Find("count_contain/label"), i18n("activity_shop_exchange_count"))
					setText(arg2:Find("mask/tag/sellout_tag"), i18n("word_sell_out"))
					setActive(arg2:Find("mask"), not var0:canPurchase())
					setText(arg2:Find("lock/Image/Text"), i18n("word_sell_lock"))
					setActive(arg2:Find("lock"), var0 < var0)
					setActive(arg2:Find("new"), var0.buyCount == 0 and var1 < var0 and var0 <= var0)
					onButton(arg0, arg2, function()
						(var0:GetLimitGoodCount() > 1 and arg0.multiWindow or arg0.singleWindow):ExecuteAction("Open", var0, function(arg0, arg1)
							arg0:emit(WorldPortMediator.OnBuyNShopGoods, arg0, arg1)
						end)
					end, SFX_PANEL)
				end
			end)
		end
	end)
	arg0.atlas:SetPressingUnlockRecordCount(arg1, var0)
end

function var0.OnUpdateMoneyCount(arg0, arg1, arg2, arg3)
	if not arg1 or arg3.id == WorldItem.PortMoneyId then
		local var0 = arg0.inventory:GetItemCount(WorldItem.PortMoneyId)

		setText(arg0.rtShop:Find("quick_count/value"), var0)
		setText(arg0.rtNShopRes:Find("Text"), var0)
	end
end

function var0.UpdateRefreshTime(arg0, arg1)
	setText(arg0.cdTF:Find("Text"), pg.TimeMgr.GetInstance():DescCDTime(arg1))
end

function var0.UpdateCDTip(arg0)
	setActive(arg0.cdTF, #arg0.port.goods > 0 and not arg0.port:IsTempPort())
	setActive(arg0.emptyTF, #arg0.port.goods == 0)

	if not nowWorld():UsePortNShop() then
		setActive(arg0.btnSupply:Find("new"), nowWorld():GetAtlas().markPortDic.goods[arg0.port.id])
	end
end

function var0.UpdateTaskTip(arg0)
	setActive(arg0.btnOperation:Find("new"), false)
end

function var0.UpdateNShopTip(arg0)
	if nowWorld():UsePortNShop() then
		setActive(arg0.btnSupply:Find("new"), arg0.atlas:GetAnyPortMarkNShop())
	end
end

function var0.showTaskWindow(arg0, arg1)
	local var0 = arg1.config.rare_task_icon
	local var1 = arg0.rtTaskWindow:Find("main_window/left_panel")

	setActive(var1:Find("bg"), arg1:IsSpecialType())

	if #var0 > 0 then
		GetImageSpriteFromAtlasAsync("shipyardicon/" .. var0, "", var1:Find("card"), true)
	else
		GetImageSpriteFromAtlasAsync("ui/worldportui_atlas", "nobody", var1:Find("card"), true)
	end

	local var2 = arg0.rtTaskWindow:Find("main_window/right_panel")

	setText(var2:Find("title/Text"), arg1.config.name)
	setText(var2:Find("content/desc"), arg1.config.rare_task_text)
	setText(var2:Find("content/slider_progress/Text"), arg1:getProgress() .. "/" .. arg1:getMaxProgress())
	setSlider(var2:Find("content/slider"), 0, arg1:getMaxProgress(), arg1:getProgress())

	local var3 = var2:Find("content/item_tpl")
	local var4 = var2:Find("content/award_bg/panel/content")
	local var5 = arg1.config.show

	removeAllChildren(var4)

	for iter0, iter1 in ipairs(var5) do
		local var6 = cloneTplTo(var3, var4)
		local var7 = {
			type = iter1[1],
			id = iter1[2],
			count = iter1[3]
		}

		updateDrop(var6, var7)
		onButton(arg0, var6, function()
			arg0:emit(var0.ON_DROP, var7)
		end, SFX_PANEL)
		setActive(var6, true)
	end

	setActive(var3, false)
	setActive(var2:Find("content/award_bg/arror"), #var5 > 3)
	onButton(arg0, var2:Find("btn_close"), function()
		arg0:hideTaskWindow()
	end, SFX_CANCEL)
	onButton(arg0, arg0.rtTaskWindow:Find("bg"), function()
		arg0:hideTaskWindow()
	end, SFX_CANCEL)
	onButton(arg0, var2:Find("btn_go"), function()
		arg0:hideTaskWindow()
		arg0:emit(WorldPortMediator.OnTaskGoto, arg1.id)
	end, SFX_PANEL)
	setButtonEnabled(var2:Find("btn_go"), arg1:GetFollowingAreaId() or arg1:GetFollowingEntrance())
	setActive(arg0.rtTaskWindow, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.rtTaskWindow, arg0._tf)
end

function var0.hideTaskWindow(arg0)
	setActive(arg0.rtTaskWindow, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.rtTaskWindow, arg0._tf)
end

return var0
