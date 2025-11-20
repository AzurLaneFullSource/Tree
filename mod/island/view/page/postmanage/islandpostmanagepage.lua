local var0_0 = class("IslandPostManagePage", import("...base.IslandBasePage"))

var0_0.PAGE_PROD = "prod"
var0_0.PAGE_REST = "rest"

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
	eachChild(arg0_4.togglesTF, function(arg0_9)
		onToggle(arg0_4, arg0_9, function(arg0_10)
			if arg0_10 then
				arg0_4.curPage = arg0_9.name
				arg0_4.contextData.curPage = arg0_4.curPage

				arg0_4:SwitchPage()
			end
		end, SFX_PANEL)
	end)

	arg0_4.buildingIds = pg.island_set.post_manage_produce.key_value_varchar
	arg0_4.restIds = pg.island_set.post_manage_operate.key_value_varchar
end

function var0_0.AddListeners(arg0_11)
	arg0_11:AddListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_11.FlushProdPage)
	arg0_11:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_11.OnFlushProdPageAndShipExpDone)
	arg0_11:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_11.OnFlushProdPageAndShipExpDone)
	arg0_11:AddListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_11.FlushRestPage)
	arg0_11:AddListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_11.FlushRestPage)
	arg0_11:AddListener(IslandManageAgecny.ADD_RESTAURANT, arg0_11.FlushRestPage)
	arg0_11:AddListener(IslandManageAgecny.ADD_ASSISTANT, arg0_11.FlushRestPage)
	arg0_11:AddListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_11.FlushRestPage)
end

function var0_0.RemoveListeners(arg0_12)
	arg0_12:RemoveListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_12.FlushProdPage)
	arg0_12:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_12.OnFlushProdPageAndShipExpDone)
	arg0_12:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_12.OnFlushProdPageAndShipExpDone)
	arg0_12:RemoveListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_12.FlushRestPage)
	arg0_12:RemoveListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_12.FlushRestPage)
	arg0_12:RemoveListener(IslandManageAgecny.ADD_RESTAURANT, arg0_12.FlushRestPage)
	arg0_12:RemoveListener(IslandManageAgecny.ADD_ASSISTANT, arg0_12.FlushRestPage)
	arg0_12:RemoveListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_12.FlushRestPage)
end

function var0_0.SwitchPage(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.pages) do
		if iter0_13 == arg0_13.curPage then
			iter1_13:ExecuteAction("Show")
		else
			iter1_13:ExecuteAction("Hide")
		end
	end
end

function var0_0.OnShow(arg0_14)
	arg0_14:BlurPanel()
	triggerToggle(arg0_14.togglesTF:Find(arg0_14.contextData.curPage or var0_0.PAGE_PROD), true)
	arg0_14:FlushTips()
	setActive(arg0_14.signInNoticeTF, getProxy(IslandProxy):GetIsland():GetSignInAgency():CanSignIn())
end

function var0_0.FlushTips(arg0_15)
	arg0_15:FlushProdTip()
	arg0_15:FlushRestTip()
end

function var0_0.FlushProdTip(arg0_16)
	local var0_16 = IslandMainBtnTipHelper.IsPostProdTip()

	setActive(arg0_16.togglesTF:Find("prod/unsel/tip"), var0_16)
	setActive(arg0_16.togglesTF:Find("prod/sel/tip"), var0_16)
end

function var0_0.FlushRestTip(arg0_17)
	local var0_17 = IslandMainBtnTipHelper.IsPostRestTip()

	setActive(arg0_17.togglesTF:Find("rest/unsel/tip"), var0_17)
	setActive(arg0_17.togglesTF:Find("rest/sel/tip"), var0_17)
end

function var0_0.OnFlushProdPageAndShipExpDone(arg0_18, arg1_18)
	if arg1_18.addShipExpData then
		local var0_18 = {}
		local var1_18 = arg1_18.addShipExpData.addShipId
		local var2_18 = arg1_18.addShipExpData.addExp
		local var3_18 = IslandShip.StaticGetPrefab(var1_18)
		local var4_18 = "island/IslandShipIcon/" .. var3_18

		arg0_18.awardDisplayPanel:ExecuteAction("ShowAwards", {
			shipExp = true,
			icon = var4_18,
			num = var2_18
		})
	end

	arg0_18:FlushProdPage(arg1_18)
end

function var0_0.FlushProdPage(arg0_19, arg1_19)
	arg0_19:FlushProdTip()
	arg0_19.pages[var0_0.PAGE_PROD]:ExecuteAction("FlushSlot", arg1_19.slotId)
end

function var0_0.FlushRestPage(arg0_20)
	arg0_20:FlushRestTip()
	arg0_20.pages[var0_0.PAGE_REST]:ExecuteAction("Flush")
end

function var0_0.OnHide(arg0_21)
	arg0_21:UnBlurPanel()

	if arg0_21.awardDisplayPanel then
		arg0_21.awardDisplayPanel:Hide()
	end
end

function var0_0.OnDisable(arg0_22)
	arg0_22:OnHide()
end

function var0_0.OnDestroy(arg0_23)
	arg0_23:UnBlurPanel()

	for iter0_23, iter1_23 in pairs(arg0_23.pages) do
		if iter1_23 then
			iter1_23:Destroy()

			iter1_23 = nil
		end
	end

	if arg0_23.awardDisplayPanel then
		arg0_23.awardDisplayPanel:Destroy()

		arg0_23.awardDisplayPanel = nil
	end
end

return var0_0
