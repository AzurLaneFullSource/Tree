local var0_0 = class("IslandPostManagePage", import("...base.IslandBasePage"))

var0_0.PAGE_PROD = "prod"
var0_0.PAGE_REST = "rest"
var0_0.PAGE_COLLECTION = "collection"
var0_0.EVENT_SHOW_SP_EVENT_TIP = "IslandPostManagePage:EVENT_SHOW_SP_EVENT_TIP"

function var0_0.getUIName(arg0_1)
	return "IslandPostManageUI"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_post_manage"))

	local var0_2 = arg0_2._tf:Find("Adapt/pages")

	arg0_2.pages = {}
	arg0_2.pages[var0_0.PAGE_PROD] = IslandPostProdPanel.New(var0_2, arg0_2.event, setmetatable({
		ShowMsgBox = function(arg0_3, arg1_3)
			arg0_2:ShowMsgBox(arg1_3)
		end
	}, {
		__index = arg0_2.contextData
	}))
	arg0_2.pages[var0_0.PAGE_REST] = IslandPostRestPanel.New(var0_2, arg0_2.event)
	arg0_2.pages[var0_0.PAGE_COLLECTION] = IslandCollectionPanel.New(var0_2, arg0_2.event, setmetatable({
		ShowMsgBox = function(arg0_4, arg1_4)
			arg0_2:ShowMsgBox(arg1_4)
		end
	}, {
		__index = arg0_2.contextData
	}))
	arg0_2.togglesTF = arg0_2._tf:Find("Adapt/types/content")

	setText(arg0_2.togglesTF:Find("prod/unsel"), i18n("island_post_produce"))
	setText(arg0_2.togglesTF:Find("prod/sel/content/Text"), i18n("island_post_produce"))
	setText(arg0_2.togglesTF:Find("rest/unsel"), i18n("island_post_operate"))
	setText(arg0_2.togglesTF:Find("rest/sel/content/Text"), i18n("island_post_operate"))
	setText(arg0_2.togglesTF:Find("collection/unsel"), i18n("island_chara_gather_tip"))
	setText(arg0_2.togglesTF:Find("collection/sel/content/Text"), i18n("island_chara_gather_tip"))

	arg0_2.signInNoticeTF = arg0_2._tf:Find("Adapt/signInBtn/notice")
	arg0_2.bookBtn = arg0_2._tf:Find("Adapt/book_btn")
	arg0_2.awardDisplayPanel = IslandAwardDisplayInMainPanel.New(arg0_2._tf, arg0_2.event)

	setText(arg0_2.bookBtn:Find("Text"), i18n("island_post_btn_set_meal"))
	setText(arg0_2._tf:Find("Adapt/signInBtn/Text"), i18n("island_post_btn_sign"))
end

function var0_0.OnInit(arg0_5)
	arg0_5:bind(var0_0.EVENT_SHOW_SP_EVENT_TIP, function(arg0_6, arg1_6, arg2_6)
		setParent(arg0_5._tf, pg.UIMgr.GetInstance().UIMain)
		arg0_5:ShowMsgBox({
			type = IslandMsgBox.TYPE_ISLAND_POST_EVENT,
			rest = arg1_6,
			isNew = arg2_6,
			onHide = function()
				setParent(arg0_5._tf, pg.UIMgr.GetInstance().OverlayMain)
			end,
			onYes = function()
				arg0_5.pages[var0_0.PAGE_REST]:TriggerEvent(arg1_6.id)
			end
		})
	end)
	onButton(arg0_5, arg0_5.bookBtn, function()
		arg0_5:OpenPage(IslandSetMealHandbookPage)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("top/title/help"), function()
		arg0_5:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_helpbtn_commission")
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("top/back"), function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("top/home"), function()
		arg0_5:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("Adapt/signInBtn"), function()
		arg0_5:Hide()
		arg0_5:emit(IslandBaseMediator.SWITCH_MAP, IslandConst.AGORA_MAP_ID, IslandConst.SIGNIN_SP)
	end, SFX_PANEL)
	eachChild(arg0_5.togglesTF, function(arg0_14)
		onToggle(arg0_5, arg0_14, function(arg0_15)
			if arg0_15 then
				arg0_5.curPage = arg0_14.name
				arg0_5.contextData.curPage = arg0_5.curPage

				arg0_5:SwitchPage()
			end
		end, SFX_PANEL)
	end)

	arg0_5.buildingIds = pg.island_set.post_manage_produce.key_value_varchar
	arg0_5.restIds = pg.island_set.post_manage_operate.key_value_varchar

	setActive(arg0_5.bookBtn, arg0_5:GetSelfIsland():GetAblityAgency():HasAbility(IslandAblityAgency.SET_MEAL_ID))
end

function var0_0.AddListeners(arg0_16)
	arg0_16:AddListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_16.FlushProdPage)
	arg0_16:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_16.OnFlushProdPageAndShipExpDone)
	arg0_16:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_16.OnFlushProdPageAndShipExpDone)
	arg0_16:AddListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_16.FlushRestPage)
	arg0_16:AddListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_16.FlushRestPage)
	arg0_16:AddListener(IslandManageAgecny.ADD_RESTAURANT, arg0_16.FlushRestPage)
	arg0_16:AddListener(IslandManageAgecny.ADD_ASSISTANT, arg0_16.FlushRestPage)
	arg0_16:AddListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_16.FlushRestPage)
	arg0_16:AddListener(GAME.ISLAND_GET_AUTO_COLLECTION_DATA_DONE, arg0_16.OnGetCollctionData)
	arg0_16:AddListener(GAME.ISLAND_TAKE_AUTO_COLLECTION_DONE, arg0_16.OnGetCollctionDone)
end

function var0_0.RemoveListeners(arg0_17)
	arg0_17:RemoveListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_17.FlushProdPage)
	arg0_17:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_17.OnFlushProdPageAndShipExpDone)
	arg0_17:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_17.OnFlushProdPageAndShipExpDone)
	arg0_17:RemoveListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_17.FlushRestPage)
	arg0_17:RemoveListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_17.FlushRestPage)
	arg0_17:RemoveListener(IslandManageAgecny.ADD_RESTAURANT, arg0_17.FlushRestPage)
	arg0_17:RemoveListener(IslandManageAgecny.ADD_ASSISTANT, arg0_17.FlushRestPage)
	arg0_17:RemoveListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_17.FlushRestPage)
	arg0_17:RemoveListener(GAME.ISLAND_GET_AUTO_COLLECTION_DATA_DONE, arg0_17.OnGetCollctionData)
	arg0_17:RemoveListener(GAME.ISLAND_TAKE_AUTO_COLLECTION_DONE, arg0_17.OnGetCollctionDone)
end

function var0_0.SwitchPage(arg0_18)
	for iter0_18, iter1_18 in pairs(arg0_18.pages) do
		if iter0_18 == arg0_18.curPage then
			if arg0_18.curPage == var0_0.PAGE_COLLECTION then
				pg.UIMgr.GetInstance():LoadingOn()
				arg0_18:emit(IslandMediator.GET_AUTO_COLLECTION_DATA, 1)
			else
				iter1_18:ExecuteAction("Show")
			end
		else
			iter1_18:ExecuteAction("Hide")
		end
	end
end

function var0_0.OnGetCollctionData(arg0_19, arg1_19)
	arg0_19.pages[var0_0.PAGE_COLLECTION]:ExecuteAction("Show", arg1_19.data)

	local var0_19 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_19 = getProxy(PlayerProxy):getPlayerId()
	local var2_19 = "IslandSignAutoCollectTime" .. tostring(var1_19)

	PlayerPrefs.SetInt(var2_19, var0_19)
	arg0_19:FlushCollectionTip()
	pg.UIMgr.GetInstance():LoadingOff()
end

function var0_0.OnGetCollctionDone(arg0_20, arg1_20)
	arg0_20.pages[var0_0.PAGE_COLLECTION]:ExecuteAction("OnGetCollctionDone", arg1_20)
end

function var0_0.OnShow(arg0_21)
	arg0_21:BlurPanel()
	triggerToggle(arg0_21.togglesTF:Find(arg0_21.contextData.curPage or var0_0.PAGE_PROD), true)
	arg0_21:FlushTips()
	setActive(arg0_21.signInNoticeTF, getProxy(IslandProxy):GetIsland():GetSignInAgency():CanSignIn())
end

function var0_0.FlushTips(arg0_22)
	arg0_22:FlushProdTip()
	arg0_22:FlushRestTip()
	arg0_22:FlushCollectionTip()
end

function var0_0.FlushProdTip(arg0_23)
	local var0_23 = IslandMainBtnTipHelper.IsPostProdTip()

	setActive(arg0_23.togglesTF:Find("prod/unsel/tip"), var0_23)
	setActive(arg0_23.togglesTF:Find("prod/sel/tip"), var0_23)
end

function var0_0.FlushRestTip(arg0_24)
	local var0_24 = IslandMainBtnTipHelper.IsPostRestTip()

	setActive(arg0_24.togglesTF:Find("rest/unsel/tip"), var0_24)
	setActive(arg0_24.togglesTF:Find("rest/sel/tip"), var0_24)
end

function var0_0.FlushCollectionTip(arg0_25)
	local var0_25 = IslandMainBtnTipHelper.IsPostCollectionTip()

	setActive(arg0_25.togglesTF:Find("collection/unsel/tip"), var0_25)
	setActive(arg0_25.togglesTF:Find("collection/sel/tip"), var0_25)
end

function var0_0.OnFlushProdPageAndShipExpDone(arg0_26, arg1_26)
	if arg1_26.addShipExpData then
		local var0_26 = {}
		local var1_26 = arg1_26.addShipExpData.addShipId
		local var2_26 = arg1_26.addShipExpData.addExp
		local var3_26 = IslandShip.StaticGetPrefab(var1_26)
		local var4_26 = "island/IslandShipIcon/" .. var3_26

		arg0_26.awardDisplayPanel:ExecuteAction("ShowAwards", {
			shipExp = true,
			icon = var4_26,
			num = var2_26
		})
	end

	arg0_26:FlushProdPage(arg1_26)
end

function var0_0.FlushProdPage(arg0_27, arg1_27)
	arg0_27:FlushProdTip()
	arg0_27.pages[var0_0.PAGE_PROD]:ExecuteAction("FlushSlot", arg1_27.slotId)
end

function var0_0.FlushRestPage(arg0_28)
	arg0_28:FlushRestTip()
	arg0_28.pages[var0_0.PAGE_REST]:ExecuteAction("Flush")
end

function var0_0.OnHide(arg0_29)
	arg0_29:UnBlurPanel()

	if arg0_29.awardDisplayPanel then
		arg0_29.awardDisplayPanel:Hide()
	end
end

function var0_0.OnDisable(arg0_30)
	arg0_30:OnHide()
end

function var0_0.OnDestroy(arg0_31)
	arg0_31:UnBlurPanel()

	for iter0_31, iter1_31 in pairs(arg0_31.pages) do
		if iter1_31 then
			iter1_31:Destroy()

			iter1_31 = nil
		end
	end

	if arg0_31.awardDisplayPanel then
		arg0_31.awardDisplayPanel:Destroy()

		arg0_31.awardDisplayPanel = nil
	end
end

return var0_0
