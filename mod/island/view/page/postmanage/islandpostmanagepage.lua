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
	arg0_2.awardDisplayPanel = IslandAwardDisplayInMainPanel.New(arg0_2._tf, arg0_2.event)
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
	eachChild(arg0_5.togglesTF, function(arg0_13)
		onToggle(arg0_5, arg0_13, function(arg0_14)
			if arg0_14 then
				arg0_5.curPage = arg0_13.name
				arg0_5.contextData.curPage = arg0_5.curPage

				arg0_5:SwitchPage()
			end
		end, SFX_PANEL)
	end)

	arg0_5.buildingIds = pg.island_set.post_manage_produce.key_value_varchar
	arg0_5.restIds = pg.island_set.post_manage_operate.key_value_varchar
end

function var0_0.AddListeners(arg0_15)
	arg0_15:AddListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_15.FlushProdPage)
	arg0_15:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_15.OnFlushProdPageAndShipExpDone)
	arg0_15:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_15.OnFlushProdPageAndShipExpDone)
	arg0_15:AddListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_15.FlushRestPage)
	arg0_15:AddListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_15.FlushRestPage)
	arg0_15:AddListener(IslandManageAgecny.ADD_RESTAURANT, arg0_15.FlushRestPage)
	arg0_15:AddListener(IslandManageAgecny.ADD_ASSISTANT, arg0_15.FlushRestPage)
	arg0_15:AddListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_15.FlushRestPage)
	arg0_15:AddListener(GAME.ISLAND_GET_AUTO_COLLECTION_DATA_DONE, arg0_15.OnGetCollctionData)
	arg0_15:AddListener(GAME.ISLAND_TAKE_AUTO_COLLECTION_DONE, arg0_15.OnGetCollctionDone)
end

function var0_0.RemoveListeners(arg0_16)
	arg0_16:RemoveListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_16.FlushProdPage)
	arg0_16:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_16.OnFlushProdPageAndShipExpDone)
	arg0_16:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_16.OnFlushProdPageAndShipExpDone)
	arg0_16:RemoveListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_16.FlushRestPage)
	arg0_16:RemoveListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_16.FlushRestPage)
	arg0_16:RemoveListener(IslandManageAgecny.ADD_RESTAURANT, arg0_16.FlushRestPage)
	arg0_16:RemoveListener(IslandManageAgecny.ADD_ASSISTANT, arg0_16.FlushRestPage)
	arg0_16:RemoveListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_16.FlushRestPage)
	arg0_16:RemoveListener(GAME.ISLAND_GET_AUTO_COLLECTION_DATA_DONE, arg0_16.OnGetCollctionData)
	arg0_16:RemoveListener(GAME.ISLAND_TAKE_AUTO_COLLECTION_DONE, arg0_16.OnGetCollctionDone)
end

function var0_0.SwitchPage(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.pages) do
		if iter0_17 == arg0_17.curPage then
			if arg0_17.curPage == var0_0.PAGE_COLLECTION then
				pg.UIMgr.GetInstance():LoadingOn()
				arg0_17:emit(IslandMediator.GET_AUTO_COLLECTION_DATA, 1)
			else
				iter1_17:ExecuteAction("Show")
			end
		else
			iter1_17:ExecuteAction("Hide")
		end
	end
end

function var0_0.OnGetCollctionData(arg0_18, arg1_18)
	arg0_18.pages[var0_0.PAGE_COLLECTION]:ExecuteAction("Show", arg1_18.data)

	local var0_18 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_18 = getProxy(PlayerProxy):getPlayerId()
	local var2_18 = "IslandSignAutoCollectTime" .. tostring(var1_18)

	PlayerPrefs.SetInt(var2_18, var0_18)
	arg0_18:FlushCollectionTip()
	pg.UIMgr.GetInstance():LoadingOff()
end

function var0_0.OnGetCollctionDone(arg0_19, arg1_19)
	arg0_19.pages[var0_0.PAGE_COLLECTION]:ExecuteAction("OnGetCollctionDone", arg1_19)
end

function var0_0.OnShow(arg0_20)
	arg0_20:BlurPanel()
	triggerToggle(arg0_20.togglesTF:Find(arg0_20.contextData.curPage or var0_0.PAGE_PROD), true)
	arg0_20:FlushTips()
	setActive(arg0_20.signInNoticeTF, getProxy(IslandProxy):GetIsland():GetSignInAgency():CanSignIn())
end

function var0_0.FlushTips(arg0_21)
	arg0_21:FlushProdTip()
	arg0_21:FlushRestTip()
	arg0_21:FlushCollectionTip()
end

function var0_0.FlushProdTip(arg0_22)
	local var0_22 = IslandMainBtnTipHelper.IsPostProdTip()

	setActive(arg0_22.togglesTF:Find("prod/unsel/tip"), var0_22)
	setActive(arg0_22.togglesTF:Find("prod/sel/tip"), var0_22)
end

function var0_0.FlushRestTip(arg0_23)
	local var0_23 = IslandMainBtnTipHelper.IsPostRestTip()

	setActive(arg0_23.togglesTF:Find("rest/unsel/tip"), var0_23)
	setActive(arg0_23.togglesTF:Find("rest/sel/tip"), var0_23)
end

function var0_0.FlushCollectionTip(arg0_24)
	local var0_24 = IslandMainBtnTipHelper.IsPostCollectionTip()

	setActive(arg0_24.togglesTF:Find("collection/unsel/tip"), var0_24)
	setActive(arg0_24.togglesTF:Find("collection/sel/tip"), var0_24)
end

function var0_0.OnFlushProdPageAndShipExpDone(arg0_25, arg1_25)
	if arg1_25.addShipExpData then
		local var0_25 = {}
		local var1_25 = arg1_25.addShipExpData.addShipId
		local var2_25 = arg1_25.addShipExpData.addExp
		local var3_25 = IslandShip.StaticGetPrefab(var1_25)
		local var4_25 = "island/IslandShipIcon/" .. var3_25

		arg0_25.awardDisplayPanel:ExecuteAction("ShowAwards", {
			shipExp = true,
			icon = var4_25,
			num = var2_25
		})
	end

	arg0_25:FlushProdPage(arg1_25)
end

function var0_0.FlushProdPage(arg0_26, arg1_26)
	arg0_26:FlushProdTip()
	arg0_26.pages[var0_0.PAGE_PROD]:ExecuteAction("FlushSlot", arg1_26.slotId)
end

function var0_0.FlushRestPage(arg0_27)
	arg0_27:FlushRestTip()
	arg0_27.pages[var0_0.PAGE_REST]:ExecuteAction("Flush")
end

function var0_0.OnHide(arg0_28)
	arg0_28:UnBlurPanel()

	if arg0_28.awardDisplayPanel then
		arg0_28.awardDisplayPanel:Hide()
	end
end

function var0_0.OnDisable(arg0_29)
	arg0_29:OnHide()
end

function var0_0.OnDestroy(arg0_30)
	arg0_30:UnBlurPanel()

	for iter0_30, iter1_30 in pairs(arg0_30.pages) do
		if iter1_30 then
			iter1_30:Destroy()

			iter1_30 = nil
		end
	end

	if arg0_30.awardDisplayPanel then
		arg0_30.awardDisplayPanel:Destroy()

		arg0_30.awardDisplayPanel = nil
	end
end

return var0_0
