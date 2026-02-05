local var0_0 = class("IslandPostManagePage", import("...base.IslandBasePage"))

var0_0.PAGE_PROD = "prod"
var0_0.PAGE_REST = "rest"
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
	arg0_2.togglesTF = arg0_2._tf:Find("Adapt/types/content")

	setText(arg0_2.togglesTF:Find("prod/unsel"), i18n("island_post_produce"))
	setText(arg0_2.togglesTF:Find("prod/sel/content/Text"), i18n("island_post_produce"))
	setText(arg0_2.togglesTF:Find("rest/unsel"), i18n("island_post_operate"))
	setText(arg0_2.togglesTF:Find("rest/sel/content/Text"), i18n("island_post_operate"))

	arg0_2.signInNoticeTF = arg0_2._tf:Find("Adapt/signInBtn/notice")
	arg0_2.awardDisplayPanel = IslandAwardDisplayInMainPanel.New(arg0_2._tf, arg0_2.event)
end

function var0_0.OnInit(arg0_4)
	arg0_4:bind(var0_0.EVENT_SHOW_SP_EVENT_TIP, function(arg0_5, arg1_5, arg2_5)
		setParent(arg0_4._tf, pg.UIMgr.GetInstance().UIMain)
		arg0_4:ShowMsgBox({
			type = IslandMsgBox.TYPE_ISLAND_POST_EVENT,
			rest = arg1_5,
			isNew = arg2_5,
			onHide = function()
				setParent(arg0_4._tf, pg.UIMgr.GetInstance().OverlayMain)
			end,
			onYes = function()
				arg0_4.pages[var0_0.PAGE_REST]:TriggerEvent(arg1_5.id)
			end
		})
	end)
	onButton(arg0_4, arg0_4._tf:Find("top/title/help"), function()
		arg0_4:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_helpbtn_commission")
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("top/back"), function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("top/home"), function()
		arg0_4:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("Adapt/signInBtn"), function()
		arg0_4:Hide()
		arg0_4:emit(IslandBaseMediator.SWITCH_MAP, IslandConst.AGORA_MAP_ID, IslandConst.SIGNIN_SP)
	end, SFX_PANEL)
	eachChild(arg0_4.togglesTF, function(arg0_12)
		onToggle(arg0_4, arg0_12, function(arg0_13)
			if arg0_13 then
				arg0_4.curPage = arg0_12.name
				arg0_4.contextData.curPage = arg0_4.curPage

				arg0_4:SwitchPage()
			end
		end, SFX_PANEL)
	end)

	arg0_4.buildingIds = pg.island_set.post_manage_produce.key_value_varchar
	arg0_4.restIds = pg.island_set.post_manage_operate.key_value_varchar
end

function var0_0.AddListeners(arg0_14)
	arg0_14:AddListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_14.FlushProdPage)
	arg0_14:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_14.OnFlushProdPageAndShipExpDone)
	arg0_14:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_14.OnFlushProdPageAndShipExpDone)
	arg0_14:AddListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_14.FlushRestPage)
	arg0_14:AddListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_14.FlushRestPage)
	arg0_14:AddListener(IslandManageAgecny.ADD_RESTAURANT, arg0_14.FlushRestPage)
	arg0_14:AddListener(IslandManageAgecny.ADD_ASSISTANT, arg0_14.FlushRestPage)
	arg0_14:AddListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_14.FlushRestPage)
end

function var0_0.RemoveListeners(arg0_15)
	arg0_15:RemoveListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_15.FlushProdPage)
	arg0_15:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_15.OnFlushProdPageAndShipExpDone)
	arg0_15:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_15.OnFlushProdPageAndShipExpDone)
	arg0_15:RemoveListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_15.FlushRestPage)
	arg0_15:RemoveListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_15.FlushRestPage)
	arg0_15:RemoveListener(IslandManageAgecny.ADD_RESTAURANT, arg0_15.FlushRestPage)
	arg0_15:RemoveListener(IslandManageAgecny.ADD_ASSISTANT, arg0_15.FlushRestPage)
	arg0_15:RemoveListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_15.FlushRestPage)
end

function var0_0.SwitchPage(arg0_16)
	for iter0_16, iter1_16 in pairs(arg0_16.pages) do
		if iter0_16 == arg0_16.curPage then
			iter1_16:ExecuteAction("Show")
		else
			iter1_16:ExecuteAction("Hide")
		end
	end
end

function var0_0.OnShow(arg0_17)
	arg0_17:BlurPanel()
	triggerToggle(arg0_17.togglesTF:Find(arg0_17.contextData.curPage or var0_0.PAGE_PROD), true)
	arg0_17:FlushTips()
	setActive(arg0_17.signInNoticeTF, getProxy(IslandProxy):GetIsland():GetSignInAgency():CanSignIn())
end

function var0_0.FlushTips(arg0_18)
	arg0_18:FlushProdTip()
	arg0_18:FlushRestTip()
end

function var0_0.FlushProdTip(arg0_19)
	local var0_19 = IslandMainBtnTipHelper.IsPostProdTip()

	setActive(arg0_19.togglesTF:Find("prod/unsel/tip"), var0_19)
	setActive(arg0_19.togglesTF:Find("prod/sel/tip"), var0_19)
end

function var0_0.FlushRestTip(arg0_20)
	local var0_20 = IslandMainBtnTipHelper.IsPostRestTip()

	setActive(arg0_20.togglesTF:Find("rest/unsel/tip"), var0_20)
	setActive(arg0_20.togglesTF:Find("rest/sel/tip"), var0_20)
end

function var0_0.OnFlushProdPageAndShipExpDone(arg0_21, arg1_21)
	if arg1_21.addShipExpData then
		local var0_21 = {}
		local var1_21 = arg1_21.addShipExpData.addShipId
		local var2_21 = arg1_21.addShipExpData.addExp
		local var3_21 = IslandShip.StaticGetPrefab(var1_21)
		local var4_21 = "island/IslandShipIcon/" .. var3_21

		arg0_21.awardDisplayPanel:ExecuteAction("ShowAwards", {
			shipExp = true,
			icon = var4_21,
			num = var2_21
		})
	end

	arg0_21:FlushProdPage(arg1_21)
end

function var0_0.FlushProdPage(arg0_22, arg1_22)
	arg0_22:FlushProdTip()
	arg0_22.pages[var0_0.PAGE_PROD]:ExecuteAction("FlushSlot", arg1_22.slotId)
end

function var0_0.FlushRestPage(arg0_23)
	arg0_23:FlushRestTip()
	arg0_23.pages[var0_0.PAGE_REST]:ExecuteAction("Flush")
end

function var0_0.OnHide(arg0_24)
	arg0_24:UnBlurPanel()

	if arg0_24.awardDisplayPanel then
		arg0_24.awardDisplayPanel:Hide()
	end
end

function var0_0.OnDisable(arg0_25)
	arg0_25:OnHide()
end

function var0_0.OnDestroy(arg0_26)
	arg0_26:UnBlurPanel()

	for iter0_26, iter1_26 in pairs(arg0_26.pages) do
		if iter1_26 then
			iter1_26:Destroy()

			iter1_26 = nil
		end
	end

	if arg0_26.awardDisplayPanel then
		arg0_26.awardDisplayPanel:Destroy()

		arg0_26.awardDisplayPanel = nil
	end
end

return var0_0
