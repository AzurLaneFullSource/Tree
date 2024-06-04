local var0 = class("NavalAcademyScene", import("..base.BaseUI"))

var0.WARP_TO_TACTIC = "WARP_TO_TACTIC"

function var0.getUIName(arg0)
	local var0 = pg.activity_banner.get_id_list_by_type[GAMEUI_BANNER_13]
	local var1 = _.filter(var0, function(arg0)
		local var0 = pg.activity_banner[arg0].time

		return pg.TimeMgr.GetInstance():inTime(var0)
	end)
	local var2 = pg.activity_banner[var1[1]]
	local var3 = var2 and var2.pic
	local var4 = pg.naval_academy_theme[var3]

	return var4 and var4.resource_path or "NavalAcademyUI"
end

function var0.ResUISettings(arg0)
	return true
end

function var0.SetOilResField(arg0, arg1)
	arg0.oilResField = arg1
end

function var0.SetGoldResField(arg0, arg1)
	arg0.goldResField = arg1
end

function var0.SetClassResField(arg0, arg1)
	arg0.classResField = arg1
end

function var0.SetPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.UpdatePlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.onUILoaded(arg0, arg1)
	arg1.name = "NavalAcademyUI"

	var0.super.onUILoaded(arg0, arg1)
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("blur_container/adapt/top/title/back")
	arg0._blurLayer = arg0:findTF("blur_container")
	arg0._topPanel = arg0._blurLayer:Find("adapt/top")
	arg0.bg = arg0:findTF("academyMap/map")
	arg0.buildings = {
		ShopBuiding.New(arg0),
		CanteenBuiding.New(arg0),
		ClassRoomBuilding.New(arg0),
		FountainBuiding.New(arg0),
		TacticRoomBuilding.New(arg0),
		CommanderBuilding.New(arg0),
		SupplyShopBuilding.New(arg0),
		MinigameHallBuilding.New(arg0)
	}
	arg0.shipsView = NavalAcademyShipsView.New(arg0)
	arg0.resPage = ResourcePage.New(arg0._tf, arg0.event)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:ExitAnim()
		arg0:emit(var0.ON_BACK, nil, 0.3)
	end, SFX_CANCEL)
	arg0:InitBuildings()
	arg0.shipsView:BindBuildings(arg0.buildings)
	arg0:UpdatePlayer(arg0.player)
	arg0:LoadEffects()
	arg0:OpenDefaultLayer()
	arg0:EnterAnim()
	arg0:InitChars()

	arg0.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0)
end

function var0.InitBuildings(arg0)
	for iter0, iter1 in ipairs(arg0.buildings) do
		iter1:Init()
	end
end

function var0.EnterAnim(arg0)
	setAnchoredPosition(arg0._topPanel, {
		y = 84
	})
	shiftPanel(arg0._topPanel, nil, 0, 0.3, 0, true, true)
end

function var0.ExitAnim(arg0)
	shiftPanel(arg0._topPanel, nil, arg0._topPanel.rect.height, 0.3, 0, true, true)
end

function var0.OpenDefaultLayer(arg0)
	arg0.warp = arg0.contextData.warp
	arg0.contextData.warp = nil

	if arg0.warp == var0.WARP_TO_TACTIC then
		arg0:emit(NavalAcademyMediator.ON_OPEN_TACTICROOM)
	end
end

function var0.LoadEffects(arg0)
	arg0:LoadWaveEffect()
	arg0:LoadMainEffect()
end

function var0.LoadWaveEffect(arg0)
	arg0:GetEffect("xueyuan02", function(arg0)
		setParent(arg0, arg0.bg)

		arg0.waveEffect = arg0
	end)
end

function var0.LoadMainEffect(arg0)
	return
end

function var0.InitChars(arg0)
	arg0.shipsView:Init()
end

function var0.OpenGoldResField(arg0)
	arg0.resPage:ExecuteAction("Flush", arg0.goldResField)
end

function var0.OpenOilResField(arg0)
	arg0.resPage:ExecuteAction("Flush", arg0.oilResField)
end

function var0.OnAddLayer(arg0)
	arg0.layerCnt = (arg0.layerCnt or 0) + 1

	if arg0.layerCnt == 1 then
		arg0:EnableEffects(false)
	end
end

function var0.OnRemoveLayer(arg0, arg1)
	arg0.layerCnt = (arg0.layerCnt or 0) - 1

	if arg0.layerCnt <= 0 then
		arg0.layerCnt = 0

		arg0:EnableEffects(true)
	end

	if arg1.context.mediator == NewNavalTacticsMediator then
		arg0.buildings[5]:RefreshTip()
	end
end

function var0.EnableEffects(arg0, arg1)
	if arg0.waveEffect then
		setActive(arg0.waveEffect, arg1)
	end

	if arg0.mainEffect then
		setActive(arg0.mainEffect, arg1)
	end
end

function var0.OnGetRes(arg0, arg1, arg2)
	if arg0.buildings[arg1] then
		arg0.buildings[arg1]:PlayGetResAnim(arg2)
	end
end

function var0.OnStartUpgradeResField(arg0, arg1)
	local var0

	if isa(arg1, OilResourceField) then
		var0 = arg0.buildings[2]
		page = arg0.resPage
	elseif isa(arg1, GoldResourceField) then
		var0 = arg0.buildings[1]
		page = arg0.resPage
	elseif isa(arg1, ClassResourceField) then
		var0 = arg0.buildings[3]
	end

	if var0 then
		var0:UpdateResField()
	end

	if page and page:GetLoaded() and page:isShowing() and page.resourceField and page.resourceField:GetKeyWord() == arg1:GetKeyWord() then
		page:Update(arg1)
	end
end

function var0.OnResFieldLevelUp(arg0, arg1)
	arg0:OnStartUpgradeResField(arg1)
end

function var0.OnCollectionUpdate(arg0)
	arg0.buildings[4]:RefreshTip()
end

function var0.RefreshChars(arg0)
	arg0.shipsView:Refresh()
end

function var0.willExit(arg0)
	for iter0, iter1 in ipairs(arg0.buildings) do
		iter1:Dispose()
	end

	arg0.buildings = nil

	if arg0.resPage then
		arg0.resPage:Destroy()

		arg0.resPage = nil
	end

	if arg0.mainEffect then
		Destroy(arg0.mainEffect)

		arg0.mainEffect = nil
	end

	if arg0.waveEffect then
		Destroy(arg0.waveEffect)

		arg0.waveEffect = nil
	end

	if arg0.bulinTip then
		arg0.bulinTip:Destroy()

		arg0.bulinTip = nil
	end

	if arg0.shipsView then
		arg0.shipsView:Dispose()

		arg0.shipsView = nil
	end
end

function var0.GetEffect(arg0, arg1, arg2)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg1, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited then
			return
		end

		arg2(Instantiate(arg0))
	end), true, true)
end

return var0
