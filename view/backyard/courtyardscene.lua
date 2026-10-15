local var0_0 = class("CourtYardScene", import("..base.BaseUI"))

function var0_0.forceGC(arg0_1)
	return true
end

function var0_0.getUIName(arg0_2)
	return "CourtYardUI"
end

var0_0.AggressivePreloadResList = {
	"ui/BackYardMsgBox",
	"ui/CourtyardUI_atlas",
	"ui/BackyardFeedUI",
	"ui/BackYardFeedShopPanel",
	"ui/BackYardFeedExtendPanel",
	"ui/NewBackYardShipInfoUI",
	"shipframeb",
	"shiptype",
	"ui/proposeShipCard",
	"ui/NewBackYardShopUI",
	"ui/NewBackYardShopUI_atlas",
	"ui/BackYardThemePage",
	"ui/BackYardThemeInfoPage",
	"ui/BackYardFurniturePage",
	"ui/FurnitureMsgboxPage",
	"ui/ThemeMsgboxPage",
	"ui/BackYardIndexUI",
	"BackYardTheme/theme_1",
	"BackYardTheme/1",
	"furnitureicon/default_theme",
	"QIcon/unknown",
	"weaponframes",
	"ui/BackYardInterActionPreview",
	"ui/BackYardDecorationUI",
	"ui/NewBackYardDecorateUI_atlas",
	"ui/BackYardDecorationThemePage",
	"ui/BackYardDecorationFurniturePage",
	"ui/BackYardPutListPage",
	"ui/BackYardDecorationMsgBox",
	"ui/BackYardDecorationDescUI",
	"ui/BackYardStatisticsUI",
	"UI/CourtYardStoreyModule",
	"UI/CourtYardFeastStoreyModule",
	"UI/CourtYardStoreyPreviewModule",
	"ui/CourtYardFurniture",
	"ui/CourtYardGrid",
	"ui/CourtYardShip",
	"ui/CourtYardWallGrid",
	"Effect/Heart"
}

function var0_0.getResource(arg0_3)
	local var0_3 = var0_0.super.getResource(arg0_3)
	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		var1_3[iter1_3] = true
	end

	for iter2_3, iter3_3 in ipairs(var0_0.AggressivePreloadResList) do
		if not var1_3[iter3_3] then
			var1_3[iter3_3] = true

			table.insert(var0_3, iter3_3)
		end
	end

	local var2_3 = getProxy(DormProxy):getData():GetPurchasedFurnitures()

	for iter4_3, iter5_3 in pairs(var2_3) do
		local var3_3 = pg.furniture_data_template[iter5_3.id].icon
		local var4_3 = "furnitrues/" .. pg.furniture_data_template[iter5_3.id].picture
		local var5_3 = "furnitureicon/" .. var3_3

		if not var1_3[var5_3] then
			var1_3[var5_3] = true

			table.insert(var0_3, var5_3)
		end

		local var6_3 = pg.furniture_data_template[iter5_3.id].type
		local var7_3 = pg.furniture_data_template[iter5_3.id].tag

		if var6_3 == 1 and var7_3 == 3 then
			for iter6_3 = 1, 4 do
				if not var1_3[var4_3 .. iter6_3] then
					var1_3[var4_3 .. iter6_3] = true

					table.insert(var0_3, var4_3 .. iter6_3)
				end
			end
		elseif not var1_3[var4_3] then
			var1_3[var4_3] = true

			table.insert(var0_3, var4_3)
		end
	end

	for iter7_3 = 1, 4 do
		local var8_3 = "furnitrues/base/road_" .. iter7_3
		local var9_3 = "furnitrues/base/wall_" .. iter7_3

		if not var1_3[var8_3] then
			var1_3[var8_3] = true

			table.insert(var0_3, var8_3)
		end

		if not var1_3[var9_3] then
			var1_3[var9_3] = true

			table.insert(var0_3, var9_3)
		end
	end

	return var0_3
end

function var0_0.PlayBGM(arg0_4)
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0_0.preload(arg0_5, arg1_5)
	_BackyardMsgBoxMgr = BackyardMsgBoxMgr.New()

	_BackyardMsgBoxMgr:Init(arg0_5, arg1_5)
end

function var0_0.SetDorm(arg0_6, arg1_6)
	arg0_6.dorm = arg1_6
end

function var0_0.init(arg0_7)
	if not arg0_7.contextData.floor then
		arg0_7.contextData.floor = 1
	end

	arg0_7.panels = {
		CourtYardLeftPanel.New(arg0_7),
		CourtYardRightPanel.New(arg0_7),
		CourtYardTopPanel.New(arg0_7),
		CourtYardBottomPanel.New(arg0_7)
	}
	arg0_7.mainTF = arg0_7._tf:Find("main")
	arg0_7.mainCG = GetOrAddComponent(arg0_7.mainTF, typeof(CanvasGroup))
	arg0_7.bg = arg0_7._tf:Find("bg000")
	arg0_7.animation = arg0_7._tf:GetComponent(typeof(Animation))
	arg0_7.emptyFoodPage = CourtYardEmptyFoodPage.New(arg0_7._tf, arg0_7.event)
end

function var0_0.didEnter(arg0_8)
	arg0_8:BlockEvents()
	arg0_8:SetUpCourtYard()
	arg0_8:FlushMainView()

	arg0_8.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_8)
end

function var0_0.OnCourtYardLoaded(arg0_9)
	pg.OSSMgr.GetInstance():Init()
	arg0_9:AddVisitorShip()

	if arg0_9.contextData.mode ~= CourtYardConst.SYSTEM_VISIT then
		BackYardThemeTempalteUtil.CheckSaveDirectory()
		pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 1)
	end

	arg0_9:UnBlockEvents()

	if arg0_9.contextData.OpenShop then
		local var0_9 = arg0_9:GetPanel(CourtYardBottomPanel)

		triggerButton(var0_9.shopBtn)
	end
end

function var0_0.UpdateDorm(arg0_10, arg1_10, arg2_10)
	arg0_10:SetDorm(arg1_10)
	arg0_10:FlushMainView(arg2_10)
end

function var0_0.SetUpCourtYard(arg0_11)
	seriesAsync({
		function(arg0_12)
			if (arg0_11.contextData.mode or CourtYardConst.SYSTEM_VISIT) ~= CourtYardConst.SYSTEM_VISIT then
				arg0_12()

				return
			end

			arg0_11:emit(CourtYardMediator.ON_ADD_VISITOR_SHIP, arg0_12)
		end
	}, function()
		local var0_13 = arg0_11.contextData.floor

		arg0_11:emit(CourtYardMediator.SET_UP, var0_13)
	end)
end

function var0_0.FlushMainView(arg0_14, arg1_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14.panels) do
		table.insert(var0_14, function(arg0_15)
			iter1_14:Flush(arg0_14.dorm, arg1_14)
			onNextTick(arg0_15)
		end)
	end

	seriesAsync(var0_14)
end

function var0_0.SwitchFloorDone(arg0_16)
	for iter0_16, iter1_16 in ipairs(arg0_16.panels) do
		iter1_16:UpdateFloor(arg0_16.dorm)
	end
end

function var0_0.ShowAddFoodTip(arg0_17)
	if arg0_17.contextData.mode ~= CourtYardConst.SYSTEM_VISIT and arg0_17.dorm.food == 0 and not arg0_17.contextData.OpenShop and not pg.NewGuideMgr.GetInstance():IsBusy() and arg0_17.dorm:GetFloorShipCnt(DormShip.FLOOR_1) > 0 and (not arg0_17.contextData.fromMediatorName or arg0_17.contextData.fromMediatorName ~= "DockyardMediator" and arg0_17.contextData.fromMediatorName ~= "ShipMainMediator") and not arg0_17.contextData.skipToCharge then
		arg0_17.emptyFoodPage:ExecuteAction("Flush")

		arg0_17.contextData.fromMain = nil
	end

	arg0_17.contextData.skipToCharge = nil
end

function var0_0.AddVisitorShip(arg0_18)
	if arg0_18.contextData.mode == CourtYardConst.SYSTEM_VISIT then
		return
	end

	if arg0_18.contextData.floor ~= 1 then
		return
	end

	if not getProxy(PlayerProxy):getRawData():GetCommonFlag(SHOW_FIREND_BACKYARD_SHIP_FLAG) then
		return
	end

	local var0_18 = getProxy(DormProxy):GetVisitorShip()

	if var0_18 then
		_courtyard:GetController():AddVisitorShip(var0_18)
	end
end

function var0_0.FoldPanel(arg0_19, arg1_19)
	if arg1_19 then
		arg0_19.animation:Play("anim_courtyard_mainui_hide")
	else
		arg0_19.animation:Play("anim_courtyard_mainui_in")
	end
end

function var0_0.OnEnterOrExitEdit(arg0_20, arg1_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.panels) do
		iter1_20:OnEnterOrExitEdit(arg1_20)
	end

	Input.multiTouchEnabled = not arg1_20
end

function var0_0.BlockEvents(arg0_21)
	arg0_21.mainCG.blocksRaycasts = false
end

function var0_0.UnBlockEvents(arg0_22)
	arg0_22.mainCG.blocksRaycasts = true
end

function var0_0.OnRemoveLayer(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.panels) do
		iter1_23:OnRemoveLayer(arg1_23.context.mediator)
	end
end

function var0_0.OnReconnection(arg0_24)
	pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 1)
end

function var0_0.OnAddFurniture(arg0_25)
	arg0_25:GetPanel(CourtYardTopPanel):OnFlush(BackYardConst.DORM_UPDATE_TYPE_LEVEL)
end

function var0_0.GetPanel(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.panels) do
		if isa(iter1_26, arg1_26) then
			return iter1_26
		end
	end
end

function var0_0.onBackPressed(arg0_27)
	for iter0_27, iter1_27 in ipairs(arg0_27.panels) do
		if iter1_27:onBackPressed() then
			return
		end
	end

	if _courtyard then
		_courtyard:GetController():OnBackPressed()
	else
		var0_0.super.onBackPressed(arg0_27)
	end
end

function var0_0.willExit(arg0_28)
	_BackyardMsgBoxMgr:Destroy()

	_BackyardMsgBoxMgr = nil

	for iter0_28, iter1_28 in ipairs(arg0_28.panels) do
		iter1_28:Detach()
	end

	arg0_28.emptyFoodPage:Destroy()

	arg0_28.emptyFoodPage = nil

	if arg0_28.bulinTip then
		arg0_28.bulinTip:Destroy()

		arg0_28.bulinTip = nil
	end

	if arg0_28.contextData.mode ~= CourtYardConst.SYSTEM_VISIT then
		pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 0)
	end

	getProxy(DormProxy):getRawData():ClearNewFlag()
end

return var0_0
