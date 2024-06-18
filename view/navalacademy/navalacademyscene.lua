local var0_0 = class("NavalAcademyScene", import("..base.BaseUI"))

var0_0.WARP_TO_TACTIC = "WARP_TO_TACTIC"

function var0_0.getUIName(arg0_1)
	local var0_1 = pg.activity_banner.get_id_list_by_type[GAMEUI_BANNER_13]
	local var1_1 = _.filter(var0_1, function(arg0_2)
		local var0_2 = pg.activity_banner[arg0_2].time

		return pg.TimeMgr.GetInstance():inTime(var0_2)
	end)
	local var2_1 = pg.activity_banner[var1_1[1]]
	local var3_1 = var2_1 and var2_1.pic
	local var4_1 = pg.naval_academy_theme[var3_1]

	return var4_1 and var4_1.resource_path or "NavalAcademyUI"
end

function var0_0.ResUISettings(arg0_3)
	return true
end

function var0_0.SetOilResField(arg0_4, arg1_4)
	arg0_4.oilResField = arg1_4
end

function var0_0.SetGoldResField(arg0_5, arg1_5)
	arg0_5.goldResField = arg1_5
end

function var0_0.SetClassResField(arg0_6, arg1_6)
	arg0_6.classResField = arg1_6
end

function var0_0.SetPlayer(arg0_7, arg1_7)
	arg0_7.player = arg1_7
end

function var0_0.UpdatePlayer(arg0_8, arg1_8)
	arg0_8.player = arg1_8
end

function var0_0.onUILoaded(arg0_9, arg1_9)
	arg1_9.name = "NavalAcademyUI"

	var0_0.super.onUILoaded(arg0_9, arg1_9)
end

function var0_0.init(arg0_10)
	arg0_10.backBtn = arg0_10:findTF("blur_container/adapt/top/title/back")
	arg0_10._blurLayer = arg0_10:findTF("blur_container")
	arg0_10._topPanel = arg0_10._blurLayer:Find("adapt/top")
	arg0_10.bg = arg0_10:findTF("academyMap/map")
	arg0_10.buildings = {
		ShopBuiding.New(arg0_10),
		CanteenBuiding.New(arg0_10),
		ClassRoomBuilding.New(arg0_10),
		FountainBuiding.New(arg0_10),
		TacticRoomBuilding.New(arg0_10),
		CommanderBuilding.New(arg0_10),
		SupplyShopBuilding.New(arg0_10),
		MinigameHallBuilding.New(arg0_10)
	}
	arg0_10.shipsView = NavalAcademyShipsView.New(arg0_10)
	arg0_10.resPage = ResourcePage.New(arg0_10._tf, arg0_10.event)
end

function var0_0.didEnter(arg0_11)
	onButton(arg0_11, arg0_11.backBtn, function()
		arg0_11:ExitAnim()
		arg0_11:emit(var0_0.ON_BACK, nil, 0.3)
	end, SFX_CANCEL)
	arg0_11:InitBuildings()
	arg0_11.shipsView:BindBuildings(arg0_11.buildings)
	arg0_11:UpdatePlayer(arg0_11.player)
	arg0_11:LoadEffects()
	arg0_11:OpenDefaultLayer()
	arg0_11:EnterAnim()
	arg0_11:InitChars()

	arg0_11.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_11)
end

function var0_0.InitBuildings(arg0_13)
	for iter0_13, iter1_13 in ipairs(arg0_13.buildings) do
		iter1_13:Init()
	end
end

function var0_0.EnterAnim(arg0_14)
	setAnchoredPosition(arg0_14._topPanel, {
		y = 84
	})
	shiftPanel(arg0_14._topPanel, nil, 0, 0.3, 0, true, true)
end

function var0_0.ExitAnim(arg0_15)
	shiftPanel(arg0_15._topPanel, nil, arg0_15._topPanel.rect.height, 0.3, 0, true, true)
end

function var0_0.OpenDefaultLayer(arg0_16)
	arg0_16.warp = arg0_16.contextData.warp
	arg0_16.contextData.warp = nil

	if arg0_16.warp == var0_0.WARP_TO_TACTIC then
		arg0_16:emit(NavalAcademyMediator.ON_OPEN_TACTICROOM)
	end
end

function var0_0.LoadEffects(arg0_17)
	arg0_17:LoadWaveEffect()
	arg0_17:LoadMainEffect()
end

function var0_0.LoadWaveEffect(arg0_18)
	arg0_18:GetEffect("xueyuan02", function(arg0_19)
		setParent(arg0_19, arg0_18.bg)

		arg0_18.waveEffect = arg0_19
	end)
end

function var0_0.LoadMainEffect(arg0_20)
	return
end

function var0_0.InitChars(arg0_21)
	arg0_21.shipsView:Init()
end

function var0_0.OpenGoldResField(arg0_22)
	arg0_22.resPage:ExecuteAction("Flush", arg0_22.goldResField)
end

function var0_0.OpenOilResField(arg0_23)
	arg0_23.resPage:ExecuteAction("Flush", arg0_23.oilResField)
end

function var0_0.OnAddLayer(arg0_24)
	arg0_24.layerCnt = (arg0_24.layerCnt or 0) + 1

	if arg0_24.layerCnt == 1 then
		arg0_24:EnableEffects(false)
	end
end

function var0_0.OnRemoveLayer(arg0_25, arg1_25)
	arg0_25.layerCnt = (arg0_25.layerCnt or 0) - 1

	if arg0_25.layerCnt <= 0 then
		arg0_25.layerCnt = 0

		arg0_25:EnableEffects(true)
	end

	if arg1_25.context.mediator == NewNavalTacticsMediator then
		arg0_25.buildings[5]:RefreshTip()
	end
end

function var0_0.EnableEffects(arg0_26, arg1_26)
	if arg0_26.waveEffect then
		setActive(arg0_26.waveEffect, arg1_26)
	end

	if arg0_26.mainEffect then
		setActive(arg0_26.mainEffect, arg1_26)
	end
end

function var0_0.OnGetRes(arg0_27, arg1_27, arg2_27)
	if arg0_27.buildings[arg1_27] then
		arg0_27.buildings[arg1_27]:PlayGetResAnim(arg2_27)
	end
end

function var0_0.OnStartUpgradeResField(arg0_28, arg1_28)
	local var0_28

	if isa(arg1_28, OilResourceField) then
		var0_28 = arg0_28.buildings[2]
		page = arg0_28.resPage
	elseif isa(arg1_28, GoldResourceField) then
		var0_28 = arg0_28.buildings[1]
		page = arg0_28.resPage
	elseif isa(arg1_28, ClassResourceField) then
		var0_28 = arg0_28.buildings[3]
	end

	if var0_28 then
		var0_28:UpdateResField()
	end

	if page and page:GetLoaded() and page:isShowing() and page.resourceField and page.resourceField:GetKeyWord() == arg1_28:GetKeyWord() then
		page:Update(arg1_28)
	end
end

function var0_0.OnResFieldLevelUp(arg0_29, arg1_29)
	arg0_29:OnStartUpgradeResField(arg1_29)
end

function var0_0.OnCollectionUpdate(arg0_30)
	arg0_30.buildings[4]:RefreshTip()
end

function var0_0.RefreshChars(arg0_31)
	arg0_31.shipsView:Refresh()
end

function var0_0.willExit(arg0_32)
	for iter0_32, iter1_32 in ipairs(arg0_32.buildings) do
		iter1_32:Dispose()
	end

	arg0_32.buildings = nil

	if arg0_32.resPage then
		arg0_32.resPage:Destroy()

		arg0_32.resPage = nil
	end

	if arg0_32.mainEffect then
		Destroy(arg0_32.mainEffect)

		arg0_32.mainEffect = nil
	end

	if arg0_32.waveEffect then
		Destroy(arg0_32.waveEffect)

		arg0_32.waveEffect = nil
	end

	if arg0_32.bulinTip then
		arg0_32.bulinTip:Destroy()

		arg0_32.bulinTip = nil
	end

	if arg0_32.shipsView then
		arg0_32.shipsView:Dispose()

		arg0_32.shipsView = nil
	end
end

function var0_0.GetEffect(arg0_33, arg1_33, arg2_33)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg1_33, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_34)
		if arg0_33.exited then
			return
		end

		arg2_33(Instantiate(arg0_34))
	end), true, true)
end

return var0_0
