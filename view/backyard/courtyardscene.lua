local var0_0 = class("CourtYardScene", import("..base.BaseUI"))

function var0_0.forceGC(arg0_1)
	return true
end

function var0_0.getUIName(arg0_2)
	return "CourtYardUI"
end

function var0_0.getAggressivePreloadResList(arg0_3, arg1_3)
	return {
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
end

function var0_0.getResource(arg0_4, arg1_4)
	local var0_4 = var0_0.super.getResource(arg0_4, arg1_4)
	local var1_4 = {}

	for iter0_4, iter1_4 in ipairs(var0_4) do
		var1_4[iter1_4] = true
	end

	for iter2_4, iter3_4 in ipairs(arg0_4:getAggressivePreloadResList(arg1_4)) do
		if not var1_4[iter3_4] then
			var1_4[iter3_4] = true

			table.insert(var0_4, iter3_4)
		end
	end

	local var2_4 = getProxy(DormProxy):getData():GetPurchasedFurnitures()

	for iter4_4, iter5_4 in pairs(var2_4) do
		local var3_4 = pg.furniture_data_template[iter5_4.id].icon
		local var4_4 = "furnitrues/" .. pg.furniture_data_template[iter5_4.id].picture
		local var5_4 = "furnitureicon/" .. var3_4

		if not var1_4[var5_4] then
			var1_4[var5_4] = true

			table.insert(var0_4, var5_4)
		end

		local var6_4 = pg.furniture_data_template[iter5_4.id].type
		local var7_4 = pg.furniture_data_template[iter5_4.id].tag

		if var6_4 == 1 and var7_4 == 3 then
			for iter6_4 = 1, 4 do
				if not var1_4[var4_4 .. iter6_4] then
					var1_4[var4_4 .. iter6_4] = true

					table.insert(var0_4, var4_4 .. iter6_4)
				end
			end
		elseif not var1_4[var4_4] then
			var1_4[var4_4] = true

			table.insert(var0_4, var4_4)
		end
	end

	for iter7_4 = 1, 4 do
		local var8_4 = "furnitrues/base/road_" .. iter7_4
		local var9_4 = "furnitrues/base/wall_" .. iter7_4

		if not var1_4[var8_4] then
			var1_4[var8_4] = true

			table.insert(var0_4, var8_4)
		end

		if not var1_4[var9_4] then
			var1_4[var9_4] = true

			table.insert(var0_4, var9_4)
		end
	end

	return var0_4
end

function var0_0.PlayBGM(arg0_5)
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0_0.preload(arg0_6, arg1_6)
	_BackyardMsgBoxMgr = BackyardMsgBoxMgr.New()

	_BackyardMsgBoxMgr:Init(arg0_6, arg1_6)
end

function var0_0.SetDorm(arg0_7, arg1_7)
	arg0_7.dorm = arg1_7
end

function var0_0.init(arg0_8)
	if not arg0_8.contextData.floor then
		arg0_8.contextData.floor = 1
	end

	arg0_8.panels = {
		CourtYardLeftPanel.New(arg0_8),
		CourtYardRightPanel.New(arg0_8),
		CourtYardTopPanel.New(arg0_8),
		CourtYardBottomPanel.New(arg0_8)
	}
	arg0_8.mainTF = arg0_8._tf:Find("main")
	arg0_8.mainCG = GetOrAddComponent(arg0_8.mainTF, typeof(CanvasGroup))
	arg0_8.bg = arg0_8._tf:Find("bg000")
	arg0_8.animation = arg0_8._tf:GetComponent(typeof(Animation))
	arg0_8.emptyFoodPage = CourtYardEmptyFoodPage.New(arg0_8._tf, arg0_8.event)
end

function var0_0.didEnter(arg0_9)
	arg0_9:BlockEvents()
	arg0_9:SetUpCourtYard()
	arg0_9:FlushMainView()

	arg0_9.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_9)
end

function var0_0.OnCourtYardLoaded(arg0_10)
	pg.OSSMgr.GetInstance():Init()
	arg0_10:AddVisitorShip()

	if arg0_10.contextData.mode ~= CourtYardConst.SYSTEM_VISIT then
		BackYardThemeTempalteUtil.CheckSaveDirectory()
		pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 1)
	end

	arg0_10:UnBlockEvents()

	if arg0_10.contextData.OpenShop then
		local var0_10 = arg0_10:GetPanel(CourtYardBottomPanel)

		triggerButton(var0_10.shopBtn)
	end
end

function var0_0.UpdateDorm(arg0_11, arg1_11, arg2_11)
	arg0_11:SetDorm(arg1_11)
	arg0_11:FlushMainView(arg2_11)
end

function var0_0.SetUpCourtYard(arg0_12)
	seriesAsync({
		function(arg0_13)
			if (arg0_12.contextData.mode or CourtYardConst.SYSTEM_VISIT) ~= CourtYardConst.SYSTEM_VISIT then
				arg0_13()

				return
			end

			arg0_12:emit(CourtYardMediator.ON_ADD_VISITOR_SHIP, arg0_13)
		end
	}, function()
		local var0_14 = arg0_12.contextData.floor

		arg0_12:emit(CourtYardMediator.SET_UP, var0_14)
	end)
end

function var0_0.FlushMainView(arg0_15, arg1_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.panels) do
		table.insert(var0_15, function(arg0_16)
			iter1_15:Flush(arg0_15.dorm, arg1_15)
			onNextTick(arg0_16)
		end)
	end

	seriesAsync(var0_15)
end

function var0_0.SwitchFloorDone(arg0_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.panels) do
		iter1_17:UpdateFloor(arg0_17.dorm)
	end
end

function var0_0.ShowAddFoodTip(arg0_18)
	if arg0_18.contextData.mode ~= CourtYardConst.SYSTEM_VISIT and arg0_18.dorm.food == 0 and not arg0_18.contextData.OpenShop and not pg.NewGuideMgr.GetInstance():IsBusy() and arg0_18.dorm:GetFloorShipCnt(DormShip.FLOOR_1) > 0 and (not arg0_18.contextData.fromMediatorName or arg0_18.contextData.fromMediatorName ~= "DockyardMediator" and arg0_18.contextData.fromMediatorName ~= "ShipMainMediator") and not arg0_18.contextData.skipToCharge then
		arg0_18.emptyFoodPage:ExecuteAction("Flush")

		arg0_18.contextData.fromMain = nil
	end

	arg0_18.contextData.skipToCharge = nil
end

function var0_0.AddVisitorShip(arg0_19)
	if arg0_19.contextData.mode == CourtYardConst.SYSTEM_VISIT then
		return
	end

	if arg0_19.contextData.floor ~= 1 then
		return
	end

	if not getProxy(PlayerProxy):getRawData():GetCommonFlag(SHOW_FIREND_BACKYARD_SHIP_FLAG) then
		return
	end

	local var0_19 = getProxy(DormProxy):GetVisitorShip()

	if var0_19 then
		_courtyard:GetController():AddVisitorShip(var0_19)
	end
end

function var0_0.FoldPanel(arg0_20, arg1_20)
	if arg1_20 then
		arg0_20.animation:Play("anim_courtyard_mainui_hide")
	else
		arg0_20.animation:Play("anim_courtyard_mainui_in")
	end
end

function var0_0.OnEnterOrExitEdit(arg0_21, arg1_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.panels) do
		iter1_21:OnEnterOrExitEdit(arg1_21)
	end

	Input.multiTouchEnabled = not arg1_21
end

function var0_0.BlockEvents(arg0_22)
	arg0_22.mainCG.blocksRaycasts = false
end

function var0_0.UnBlockEvents(arg0_23)
	arg0_23.mainCG.blocksRaycasts = true
end

function var0_0.OnRemoveLayer(arg0_24, arg1_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.panels) do
		iter1_24:OnRemoveLayer(arg1_24.context.mediator)
	end
end

function var0_0.OnReconnection(arg0_25)
	pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 1)
end

function var0_0.OnAddFurniture(arg0_26)
	arg0_26:GetPanel(CourtYardTopPanel):OnFlush(BackYardConst.DORM_UPDATE_TYPE_LEVEL)
end

function var0_0.GetPanel(arg0_27, arg1_27)
	for iter0_27, iter1_27 in ipairs(arg0_27.panels) do
		if isa(iter1_27, arg1_27) then
			return iter1_27
		end
	end
end

function var0_0.onBackPressed(arg0_28)
	for iter0_28, iter1_28 in ipairs(arg0_28.panels) do
		if iter1_28:onBackPressed() then
			return
		end
	end

	if _courtyard then
		_courtyard:GetController():OnBackPressed()
	else
		var0_0.super.onBackPressed(arg0_28)
	end
end

function var0_0.willExit(arg0_29)
	_BackyardMsgBoxMgr:Destroy()

	_BackyardMsgBoxMgr = nil

	for iter0_29, iter1_29 in ipairs(arg0_29.panels) do
		iter1_29:Detach()
	end

	arg0_29.emptyFoodPage:Destroy()

	arg0_29.emptyFoodPage = nil

	if arg0_29.bulinTip then
		arg0_29.bulinTip:Destroy()

		arg0_29.bulinTip = nil
	end

	if arg0_29.contextData.mode ~= CourtYardConst.SYSTEM_VISIT then
		pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 0)
	end

	getProxy(DormProxy):getRawData():ClearNewFlag()
end

return var0_0
