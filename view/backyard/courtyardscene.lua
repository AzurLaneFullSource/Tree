local var0_0 = class("CourtYardScene", import("..base.BaseUI"))

function var0_0.forceGC(arg0_1)
	return true
end

function var0_0.getUIName(arg0_2)
	return "CourtYardUI"
end

function var0_0.PlayBGM(arg0_3)
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0_0.preload(arg0_4, arg1_4)
	_BackyardMsgBoxMgr = BackyardMsgBoxMgr.New()

	_BackyardMsgBoxMgr:Init(arg0_4, arg1_4)
end

function var0_0.SetDorm(arg0_5, arg1_5)
	arg0_5.dorm = arg1_5
end

function var0_0.init(arg0_6)
	if not arg0_6.contextData.floor then
		arg0_6.contextData.floor = 1
	end

	arg0_6.panels = {
		CourtYardLeftPanel.New(arg0_6),
		CourtYardRightPanel.New(arg0_6),
		CourtYardTopPanel.New(arg0_6),
		CourtYardBottomPanel.New(arg0_6)
	}
	arg0_6.mainTF = arg0_6._tf:Find("main")
	arg0_6.mainCG = GetOrAddComponent(arg0_6.mainTF, typeof(CanvasGroup))
	arg0_6.bg = arg0_6._tf:Find("bg000")
	arg0_6.animation = arg0_6._tf:GetComponent(typeof(Animation))
	arg0_6.emptyFoodPage = CourtYardEmptyFoodPage.New(arg0_6._tf, arg0_6.event)
end

function var0_0.didEnter(arg0_7)
	arg0_7:BlockEvents()
	arg0_7:SetUpCourtYard()
	arg0_7:FlushMainView()

	arg0_7.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_7)
end

function var0_0.OnCourtYardLoaded(arg0_8)
	pg.OSSMgr.GetInstance():Init()
	arg0_8:AddVisitorShip()

	if arg0_8.contextData.mode ~= CourtYardConst.SYSTEM_VISIT then
		BackYardThemeTempalteUtil.CheckSaveDirectory()
		pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 1)
	end

	arg0_8:UnBlockEvents()

	if arg0_8.contextData.OpenShop then
		local var0_8 = arg0_8:GetPanel(CourtYardBottomPanel)

		triggerButton(var0_8.shopBtn)
	end
end

function var0_0.UpdateDorm(arg0_9, arg1_9, arg2_9)
	arg0_9:SetDorm(arg1_9)
	arg0_9:FlushMainView(arg2_9)
end

function var0_0.SetUpCourtYard(arg0_10)
	seriesAsync({
		function(arg0_11)
			if (arg0_10.contextData.mode or CourtYardConst.SYSTEM_VISIT) ~= CourtYardConst.SYSTEM_VISIT then
				arg0_11()

				return
			end

			arg0_10:emit(CourtYardMediator.ON_ADD_VISITOR_SHIP, arg0_11)
		end
	}, function()
		local var0_12 = arg0_10.contextData.floor

		arg0_10:emit(CourtYardMediator.SET_UP, var0_12)
	end)
end

function var0_0.FlushMainView(arg0_13, arg1_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13.panels) do
		table.insert(var0_13, function(arg0_14)
			iter1_13:Flush(arg0_13.dorm, arg1_13)
			onNextTick(arg0_14)
		end)
	end

	seriesAsync(var0_13)
end

function var0_0.SwitchFloorDone(arg0_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.panels) do
		iter1_15:UpdateFloor(arg0_15.dorm)
	end
end

function var0_0.ShowAddFoodTip(arg0_16)
	if arg0_16.contextData.mode ~= CourtYardConst.SYSTEM_VISIT and arg0_16.dorm.food == 0 and not arg0_16.contextData.OpenShop and not pg.NewGuideMgr.GetInstance():IsBusy() and arg0_16.dorm:GetFloorShipCnt(DormShip.FLOOR_1) > 0 and (not arg0_16.contextData.fromMediatorName or arg0_16.contextData.fromMediatorName ~= "DockyardMediator" and arg0_16.contextData.fromMediatorName ~= "ShipMainMediator") and not arg0_16.contextData.skipToCharge then
		arg0_16.emptyFoodPage:ExecuteAction("Flush")

		arg0_16.contextData.fromMain = nil
	end

	arg0_16.contextData.skipToCharge = nil
end

function var0_0.AddVisitorShip(arg0_17)
	if arg0_17.contextData.mode == CourtYardConst.SYSTEM_VISIT then
		return
	end

	if arg0_17.contextData.floor ~= 1 then
		return
	end

	if not getProxy(PlayerProxy):getRawData():GetCommonFlag(SHOW_FIREND_BACKYARD_SHIP_FLAG) then
		return
	end

	local var0_17 = getProxy(DormProxy):GetVisitorShip()

	if var0_17 then
		_courtyard:GetController():AddVisitorShip(var0_17)
	end
end

function var0_0.FoldPanel(arg0_18, arg1_18)
	if arg1_18 then
		arg0_18.animation:Play("anim_courtyard_mainui_hide")
	else
		arg0_18.animation:Play("anim_courtyard_mainui_in")
	end
end

function var0_0.OnEnterOrExitEdit(arg0_19, arg1_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.panels) do
		iter1_19:OnEnterOrExitEdit(arg1_19)
	end

	Input.multiTouchEnabled = not arg1_19
end

function var0_0.BlockEvents(arg0_20)
	arg0_20.mainCG.blocksRaycasts = false
end

function var0_0.UnBlockEvents(arg0_21)
	arg0_21.mainCG.blocksRaycasts = true
end

function var0_0.OnRemoveLayer(arg0_22, arg1_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.panels) do
		iter1_22:OnRemoveLayer(arg1_22.context.mediator)
	end
end

function var0_0.OnReconnection(arg0_23)
	pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 1)
end

function var0_0.OnAddFurniture(arg0_24)
	arg0_24:GetPanel(CourtYardTopPanel):OnFlush(BackYardConst.DORM_UPDATE_TYPE_LEVEL)
end

function var0_0.GetPanel(arg0_25, arg1_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.panels) do
		if isa(iter1_25, arg1_25) then
			return iter1_25
		end
	end
end

function var0_0.onBackPressed(arg0_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.panels) do
		if iter1_26:onBackPressed() then
			return
		end
	end

	if _courtyard then
		_courtyard:GetController():OnBackPressed()
	else
		var0_0.super.onBackPressed(arg0_26)
	end
end

function var0_0.willExit(arg0_27)
	_BackyardMsgBoxMgr:Destroy()

	_BackyardMsgBoxMgr = nil

	for iter0_27, iter1_27 in ipairs(arg0_27.panels) do
		iter1_27:Detach()
	end

	arg0_27.emptyFoodPage:Destroy()

	arg0_27.emptyFoodPage = nil

	if arg0_27.bulinTip then
		arg0_27.bulinTip:Destroy()

		arg0_27.bulinTip = nil
	end

	if arg0_27.contextData.mode ~= CourtYardConst.SYSTEM_VISIT then
		pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 0)
	end

	getProxy(DormProxy):getRawData():ClearNewFlag()
end

return var0_0
