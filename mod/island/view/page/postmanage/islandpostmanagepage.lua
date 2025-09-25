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
	arg0_2.pages[var0_0.PAGE_PROD] = IslandPostProdPanel.New(var0_2, arg0_2.event)
	arg0_2.pages[var0_0.PAGE_REST] = IslandPostRestPanel.New(var0_2, arg0_2.event)
	arg0_2.togglesTF = arg0_2._tf:Find("Adapt/types/content")

	setText(arg0_2.togglesTF:Find("prod/unsel"), i18n("island_post_produce"))
	setText(arg0_2.togglesTF:Find("prod/sel/content/Text"), i18n("island_post_produce"))
	setText(arg0_2.togglesTF:Find("rest/unsel"), i18n("island_post_operate"))
	setText(arg0_2.togglesTF:Find("rest/sel/content/Text"), i18n("island_post_operate"))

	arg0_2.signInNoticeTF = arg0_2._tf:Find("Adapt/signInBtn/notice")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("top/back"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("top/home"), function()
		arg0_3:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("Adapt/signInBtn"), function()
		arg0_3:Hide()
		arg0_3:emit(IslandBaseMediator.SWITCH_MAP, IslandConst.AGORA_MAP_ID, IslandConst.SIGNIN_SP)
	end, SFX_PANEL)
	eachChild(arg0_3.togglesTF, function(arg0_7)
		onToggle(arg0_3, arg0_7, function(arg0_8)
			if arg0_8 then
				arg0_3.curPage = arg0_7.name

				arg0_3:SwitchPage()
			end
		end, SFX_PANEL)
	end)

	arg0_3.buildingIds = pg.island_set.post_manage_produce.key_value_varchar
	arg0_3.restIds = pg.island_set.post_manage_operate.key_value_varchar
end

function var0_0.AddListeners(arg0_9)
	arg0_9:AddListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_9.FlushProdPage)
	arg0_9:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_9.FlushProdPage)
	arg0_9:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_9.FlushProdPage)
	arg0_9:AddListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_9.FlushRestPage)
	arg0_9:AddListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_9.FlushRestPage)
	arg0_9:AddListener(IslandManageAgecny.ADD_RESTAURANT, arg0_9.FlushRestPage)
	arg0_9:AddListener(IslandManageAgecny.ADD_ASSISTANT, arg0_9.FlushRestPage)
	arg0_9:AddListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_9.FlushRestPage)
end

function var0_0.RemoveListeners(arg0_10)
	arg0_10:RemoveListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_10.FlushProdPage)
	arg0_10:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_10.FlushProdPage)
	arg0_10:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_10.FlushProdPage)
	arg0_10:RemoveListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_10.FlushRestPage)
	arg0_10:RemoveListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_10.FlushRestPage)
	arg0_10:RemoveListener(IslandManageAgecny.ADD_RESTAURANT, arg0_10.FlushRestPage)
	arg0_10:RemoveListener(IslandManageAgecny.ADD_ASSISTANT, arg0_10.FlushRestPage)
	arg0_10:RemoveListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_10.FlushRestPage)
end

function var0_0.SwitchPage(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.pages) do
		if iter0_11 == arg0_11.curPage then
			iter1_11:ExecuteAction("Show")
		else
			iter1_11:ExecuteAction("Hide")
		end
	end
end

function var0_0.OnShow(arg0_12)
	arg0_12:BlurPanel()
	triggerToggle(arg0_12.togglesTF:Find(var0_0.PAGE_PROD), true)
	arg0_12:FlushTips()
	setActive(arg0_12.signInNoticeTF, getProxy(IslandProxy):GetIsland():GetSignInAgency():CanSignIn())
end

function var0_0.FlushTips(arg0_13)
	arg0_13:FlushProdTip()
	arg0_13:FlushRestTip()
end

function var0_0.FlushProdTip(arg0_14)
	local var0_14 = IslandMainBtnTipHelper.IsPostProdTip()

	setActive(arg0_14.togglesTF:Find("prod/unsel/tip"), var0_14)
	setActive(arg0_14.togglesTF:Find("prod/sel/tip"), var0_14)
end

function var0_0.FlushRestTip(arg0_15)
	local var0_15 = IslandMainBtnTipHelper.IsPostRestTip()

	setActive(arg0_15.togglesTF:Find("rest/unsel/tip"), var0_15)
	setActive(arg0_15.togglesTF:Find("rest/sel/tip"), var0_15)
end

function var0_0.FlushProdPage(arg0_16, arg1_16)
	arg0_16:FlushProdTip()
	arg0_16.pages[var0_0.PAGE_PROD]:ExecuteAction("FlushSlot", arg1_16.slotId)
end

function var0_0.FlushRestPage(arg0_17)
	arg0_17:FlushRestTip()
	arg0_17.pages[var0_0.PAGE_REST]:ExecuteAction("Flush")
end

function var0_0.OnHide(arg0_18)
	arg0_18:UnBlurPanel()
end

function var0_0.OnDisable(arg0_19)
	arg0_19:OnHide()
end

function var0_0.OnDestroy(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.pages) do
		if iter1_20 then
			iter1_20:Destroy()

			iter1_20 = nil
		end
	end
end

return var0_0
