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

function var0_0.getResource(arg0_3, arg1_3)
	local var0_3 = {
		"ui/xueyuan02",
		"ui/resourcefieldui_atlas"
	}
	local var1_3 = (function()
		local var0_4 = {}
		local var1_4 = pg.activity_banner.get_id_list_by_type[GAMEUI_BANNER_13]

		for iter0_4, iter1_4 in ipairs(var1_4) do
			local var2_4 = pg.activity_banner[iter1_4]
			local var3_4

			var3_4 = var2_4 and var2_4.pic

			local var4_4 = var2_4 and var2_4.resource_path or "NavalAcademyUI"

			table.insert(var0_4, "ui/" .. var4_4)
		end

		return var0_4
	end)()
	local var2_3 = NavalAcademyShipsView.GetCharResList()

	return ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_3, arg1_3), var0_3, var1_3, var2_3)
end

function var0_0.ResUISettings(arg0_5)
	return true
end

function var0_0.SetOilResField(arg0_6, arg1_6)
	arg0_6.oilResField = arg1_6
end

function var0_0.SetGoldResField(arg0_7, arg1_7)
	arg0_7.goldResField = arg1_7
end

function var0_0.SetClassResField(arg0_8, arg1_8)
	arg0_8.classResField = arg1_8
end

function var0_0.SetPlayer(arg0_9, arg1_9)
	arg0_9.player = arg1_9
end

function var0_0.UpdatePlayer(arg0_10, arg1_10)
	arg0_10.player = arg1_10
end

function var0_0.onUILoaded(arg0_11, arg1_11)
	arg1_11.name = "NavalAcademyUI"

	var0_0.super.onUILoaded(arg0_11, arg1_11)
end

function var0_0.init(arg0_12)
	arg0_12.backBtn = arg0_12._tf:Find("blur_container/adapt/top/title/back")
	arg0_12._blurLayer = arg0_12._tf:Find("blur_container")
	arg0_12._topPanel = arg0_12._blurLayer:Find("adapt/top")
	arg0_12.bg = arg0_12._tf:Find("academyMap/map")
	arg0_12.buildings = {
		ShopBuiding.New(arg0_12),
		CanteenBuiding.New(arg0_12),
		ClassRoomBuilding.New(arg0_12),
		FountainBuiding.New(arg0_12),
		TacticRoomBuilding.New(arg0_12),
		CommanderBuilding.New(arg0_12),
		SupplyShopBuilding.New(arg0_12),
		MinigameHallBuilding.New(arg0_12)
	}
	arg0_12.shipsView = NavalAcademyShipsView.New(arg0_12)
	arg0_12.resPage = ResourcePage.New(arg0_12._tf, arg0_12.event)
end

function var0_0.didEnter(arg0_13)
	onButton(arg0_13, arg0_13.backBtn, function()
		arg0_13:ExitAnim()
		arg0_13:emit(var0_0.ON_BACK, nil, 0.3)
	end, SFX_CANCEL)
	arg0_13:InitBuildings()
	arg0_13.shipsView:BindBuildings(arg0_13.buildings)
	arg0_13:UpdatePlayer(arg0_13.player)
	arg0_13:LoadEffects()
	arg0_13:OpenDefaultLayer()
	arg0_13:EnterAnim()
	arg0_13:InitChars()

	arg0_13.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_13)
end

function var0_0.InitBuildings(arg0_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.buildings) do
		iter1_15:Init()
	end
end

function var0_0.EnterAnim(arg0_16)
	setAnchoredPosition(arg0_16._topPanel, {
		y = 84
	})
	shiftPanel(arg0_16._topPanel, nil, 0, 0.3, 0, true, true)
end

function var0_0.ExitAnim(arg0_17)
	shiftPanel(arg0_17._topPanel, nil, arg0_17._topPanel.rect.height, 0.3, 0, true, true)
end

function var0_0.OpenDefaultLayer(arg0_18)
	arg0_18.warp = arg0_18.contextData.warp
	arg0_18.contextData.warp = nil

	if arg0_18.warp == var0_0.WARP_TO_TACTIC then
		arg0_18:emit(NavalAcademyMediator.ON_OPEN_TACTICROOM)
	end
end

function var0_0.LoadEffects(arg0_19)
	arg0_19:LoadWaveEffect()
	arg0_19:LoadMainEffect()
end

function var0_0.LoadWaveEffect(arg0_20)
	arg0_20:GetEffect("xueyuan02", function(arg0_21)
		setParent(arg0_21, arg0_20.bg)

		arg0_20.waveEffect = arg0_21
	end)
end

function var0_0.LoadMainEffect(arg0_22)
	return
end

function var0_0.InitChars(arg0_23)
	arg0_23.shipsView:Init()
end

function var0_0.OpenGoldResField(arg0_24)
	arg0_24.resPage:ExecuteAction("Flush", arg0_24.goldResField)
end

function var0_0.OpenOilResField(arg0_25)
	arg0_25.resPage:ExecuteAction("Flush", arg0_25.oilResField)
end

function var0_0.OnAddLayer(arg0_26)
	arg0_26.layerCnt = (arg0_26.layerCnt or 0) + 1

	if arg0_26.layerCnt == 1 then
		arg0_26:EnableEffects(false)
	end
end

function var0_0.OnRemoveLayer(arg0_27, arg1_27)
	arg0_27.layerCnt = (arg0_27.layerCnt or 0) - 1

	if arg0_27.layerCnt <= 0 then
		arg0_27.layerCnt = 0

		arg0_27:EnableEffects(true)
	end

	if arg1_27.context.mediator == NewNavalTacticsMediator then
		arg0_27.buildings[5]:RefreshTip()
	end
end

function var0_0.EnableEffects(arg0_28, arg1_28)
	if arg0_28.waveEffect then
		setActive(arg0_28.waveEffect, arg1_28)
	end

	if arg0_28.mainEffect then
		setActive(arg0_28.mainEffect, arg1_28)
	end
end

function var0_0.OnGetRes(arg0_29, arg1_29, arg2_29)
	if arg0_29.buildings[arg1_29] then
		arg0_29.buildings[arg1_29]:PlayGetResAnim(arg2_29)
	end
end

function var0_0.OnStartUpgradeResField(arg0_30, arg1_30)
	local var0_30

	if isa(arg1_30, OilResourceField) then
		var0_30 = arg0_30.buildings[2]
		page = arg0_30.resPage
	elseif isa(arg1_30, GoldResourceField) then
		var0_30 = arg0_30.buildings[1]
		page = arg0_30.resPage
	elseif isa(arg1_30, ClassResourceField) then
		var0_30 = arg0_30.buildings[3]
	end

	if var0_30 then
		var0_30:UpdateResField()
	end

	if page and page:GetLoaded() and page:isShowing() and page.resourceField and page.resourceField:GetKeyWord() == arg1_30:GetKeyWord() then
		page:Update(arg1_30)
	end
end

function var0_0.OnResFieldLevelUp(arg0_31, arg1_31)
	arg0_31:OnStartUpgradeResField(arg1_31)
end

function var0_0.OnCollectionUpdate(arg0_32)
	arg0_32.buildings[4]:RefreshTip()
end

function var0_0.RefreshChars(arg0_33)
	arg0_33.shipsView:Refresh()
end

function var0_0.willExit(arg0_34)
	for iter0_34, iter1_34 in ipairs(arg0_34.buildings) do
		iter1_34:Dispose()
	end

	arg0_34.buildings = nil

	if arg0_34.resPage then
		arg0_34.resPage:Destroy()

		arg0_34.resPage = nil
	end

	if arg0_34.mainEffect then
		Destroy(arg0_34.mainEffect)

		arg0_34.mainEffect = nil
	end

	if arg0_34.waveEffect then
		Destroy(arg0_34.waveEffect)

		arg0_34.waveEffect = nil
	end

	if arg0_34.bulinTip then
		arg0_34.bulinTip:Destroy()

		arg0_34.bulinTip = nil
	end

	if arg0_34.shipsView then
		arg0_34.shipsView:Dispose()

		arg0_34.shipsView = nil
	end
end

function var0_0.GetEffect(arg0_35, arg1_35, arg2_35)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg1_35, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_36)
		if arg0_35.exited then
			return
		end

		arg2_35(Instantiate(arg0_36))
	end), true, true)
end

return var0_0
