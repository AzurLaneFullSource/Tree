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
	arg0_6.mainTF = arg0_6:findTF("main")
	arg0_6.mainCG = GetOrAddComponent(arg0_6.mainTF, typeof(CanvasGroup))
	arg0_6.bg = arg0_6:findTF("bg000")
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
	local var0_10 = arg0_10.contextData.floor

	arg0_10:emit(CourtYardMediator.SET_UP, var0_10)
end

function var0_0.FlushMainView(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in ipairs(arg0_11.panels) do
		table.insert(var0_11, function(arg0_12)
			iter1_11:Flush(arg0_11.dorm, arg1_11)
			onNextTick(arg0_12)
		end)
	end

	seriesAsync(var0_11)
end

function var0_0.SwitchFloorDone(arg0_13)
	for iter0_13, iter1_13 in ipairs(arg0_13.panels) do
		iter1_13:UpdateFloor(arg0_13.dorm)
	end
end

function var0_0.ShowAddFoodTip(arg0_14)
	if arg0_14.contextData.mode ~= CourtYardConst.SYSTEM_VISIT and arg0_14.dorm.food == 0 and not arg0_14.contextData.OpenShop and not pg.NewGuideMgr.GetInstance():IsBusy() and arg0_14.dorm:GetStateShipCnt(Ship.STATE_TRAIN) > 0 and (not arg0_14.contextData.fromMediatorName or arg0_14.contextData.fromMediatorName ~= "DockyardMediator" and arg0_14.contextData.fromMediatorName ~= "ShipMainMediator") and not arg0_14.contextData.skipToCharge then
		arg0_14.emptyFoodPage:ExecuteAction("Flush")

		arg0_14.contextData.fromMain = nil
	end

	arg0_14.contextData.skipToCharge = nil
end

function var0_0.AddVisitorShip(arg0_15)
	if arg0_15.contextData.mode == CourtYardConst.SYSTEM_VISIT then
		return
	end

	if arg0_15.contextData.floor ~= 1 then
		return
	end

	if not getProxy(PlayerProxy):getRawData():GetCommonFlag(SHOW_FIREND_BACKYARD_SHIP_FLAG) then
		return
	end

	arg0_15:emit(CourtYardMediator.ON_ADD_VISITOR_SHIP)
end

function var0_0.FoldPanel(arg0_16, arg1_16)
	if arg1_16 then
		arg0_16.animation:Play("anim_courtyard_mainui_hide")
	else
		arg0_16.animation:Play("anim_courtyard_mainui_in")
	end
end

function var0_0.OnEnterOrExitEdit(arg0_17, arg1_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.panels) do
		iter1_17:OnEnterOrExitEdit(arg1_17)
	end

	Input.multiTouchEnabled = not arg1_17
end

function var0_0.BlockEvents(arg0_18)
	arg0_18.mainCG.blocksRaycasts = false
end

function var0_0.UnBlockEvents(arg0_19)
	arg0_19.mainCG.blocksRaycasts = true
end

function var0_0.OnRemoveLayer(arg0_20, arg1_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.panels) do
		iter1_20:OnRemoveLayer(arg1_20.context.mediator)
	end
end

function var0_0.OnReconnection(arg0_21)
	pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 1)
end

function var0_0.OnAddFurniture(arg0_22)
	arg0_22:GetPanel(CourtYardTopPanel):OnFlush(BackYardConst.DORM_UPDATE_TYPE_LEVEL)
end

function var0_0.GetPanel(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.panels) do
		if isa(iter1_23, arg1_23) then
			return iter1_23
		end
	end
end

function var0_0.onBackPressed(arg0_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.panels) do
		if iter1_24:onBackPressed() then
			return
		end
	end

	if _courtyard then
		_courtyard:GetController():OnBackPressed()
	else
		var0_0.super.onBackPressed(arg0_24)
	end
end

function var0_0.willExit(arg0_25)
	_BackyardMsgBoxMgr:Destroy()

	_BackyardMsgBoxMgr = nil

	for iter0_25, iter1_25 in ipairs(arg0_25.panels) do
		iter1_25:Detach()
	end

	arg0_25.emptyFoodPage:Destroy()

	arg0_25.emptyFoodPage = nil

	if arg0_25.bulinTip then
		arg0_25.bulinTip:Destroy()

		arg0_25.bulinTip = nil
	end

	if arg0_25.contextData.mode ~= CourtYardConst.SYSTEM_VISIT then
		pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 0)
	end

	getProxy(DormProxy):ClearNewFlag()
end

return var0_0
