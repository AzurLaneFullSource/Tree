local var0 = class("CourtYardScene", import("..base.BaseUI"))

function var0.forceGC(arg0)
	return true
end

function var0.getUIName(arg0)
	return "CourtYardUI"
end

function var0.PlayBGM(arg0)
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0.preload(arg0, arg1)
	_BackyardMsgBoxMgr = BackyardMsgBoxMgr.New()

	_BackyardMsgBoxMgr:Init(arg0, arg1)
end

function var0.SetDorm(arg0, arg1)
	arg0.dorm = arg1
end

function var0.init(arg0)
	if not arg0.contextData.floor then
		arg0.contextData.floor = 1
	end

	arg0.panels = {
		CourtYardLeftPanel.New(arg0),
		CourtYardRightPanel.New(arg0),
		CourtYardTopPanel.New(arg0),
		CourtYardBottomPanel.New(arg0)
	}
	arg0.mainTF = arg0:findTF("main")
	arg0.mainCG = GetOrAddComponent(arg0.mainTF, typeof(CanvasGroup))
	arg0.bg = arg0:findTF("bg000")
	arg0.animation = arg0._tf:GetComponent(typeof(Animation))
	arg0.emptyFoodPage = CourtYardEmptyFoodPage.New(arg0._tf, arg0.event)
end

function var0.didEnter(arg0)
	arg0:BlockEvents()
	arg0:SetUpCourtYard()
	arg0:FlushMainView()

	arg0.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0)
end

function var0.OnCourtYardLoaded(arg0)
	pg.OSSMgr.GetInstance():Init()
	arg0:AddVisitorShip()

	if arg0.contextData.mode ~= CourtYardConst.SYSTEM_VISIT then
		BackYardThemeTempalteUtil.CheckSaveDirectory()
		pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 1)
	end

	arg0:UnBlockEvents()

	if arg0.contextData.OpenShop then
		local var0 = arg0:GetPanel(CourtYardBottomPanel)

		triggerButton(var0.shopBtn)
	end
end

function var0.UpdateDorm(arg0, arg1, arg2)
	arg0:SetDorm(arg1)
	arg0:FlushMainView(arg2)
end

function var0.SetUpCourtYard(arg0)
	local var0 = arg0.contextData.floor

	arg0:emit(CourtYardMediator.SET_UP, var0)
end

function var0.FlushMainView(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.panels) do
		table.insert(var0, function(arg0)
			iter1:Flush(arg0.dorm, arg1)
			onNextTick(arg0)
		end)
	end

	seriesAsync(var0)
end

function var0.SwitchFloorDone(arg0)
	for iter0, iter1 in ipairs(arg0.panels) do
		iter1:UpdateFloor(arg0.dorm)
	end
end

function var0.ShowAddFoodTip(arg0)
	if arg0.contextData.mode ~= CourtYardConst.SYSTEM_VISIT and arg0.dorm.food == 0 and not arg0.contextData.OpenShop and not pg.NewGuideMgr.GetInstance():IsBusy() and arg0.dorm:GetStateShipCnt(Ship.STATE_TRAIN) > 0 and (not arg0.contextData.fromMediatorName or arg0.contextData.fromMediatorName ~= "DockyardMediator" and arg0.contextData.fromMediatorName ~= "ShipMainMediator") and not arg0.contextData.skipToCharge then
		arg0.emptyFoodPage:ExecuteAction("Flush")

		arg0.contextData.fromMain = nil
	end

	arg0.contextData.skipToCharge = nil
end

function var0.AddVisitorShip(arg0)
	if arg0.contextData.mode == CourtYardConst.SYSTEM_VISIT then
		return
	end

	if arg0.contextData.floor ~= 1 then
		return
	end

	if not getProxy(PlayerProxy):getRawData():GetCommonFlag(SHOW_FIREND_BACKYARD_SHIP_FLAG) then
		return
	end

	arg0:emit(CourtYardMediator.ON_ADD_VISITOR_SHIP)
end

function var0.FoldPanel(arg0, arg1)
	if arg1 then
		arg0.animation:Play("anim_courtyard_mainui_hide")
	else
		arg0.animation:Play("anim_courtyard_mainui_in")
	end
end

function var0.OnEnterOrExitEdit(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.panels) do
		iter1:OnEnterOrExitEdit(arg1)
	end

	Input.multiTouchEnabled = not arg1
end

function var0.BlockEvents(arg0)
	arg0.mainCG.blocksRaycasts = false
end

function var0.UnBlockEvents(arg0)
	arg0.mainCG.blocksRaycasts = true
end

function var0.OnRemoveLayer(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.panels) do
		iter1:OnRemoveLayer(arg1.context.mediator)
	end
end

function var0.OnReconnection(arg0)
	pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 1)
end

function var0.OnAddFurniture(arg0)
	arg0:GetPanel(CourtYardTopPanel):OnFlush(BackYardConst.DORM_UPDATE_TYPE_LEVEL)
end

function var0.GetPanel(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.panels) do
		if isa(iter1, arg1) then
			return iter1
		end
	end
end

function var0.onBackPressed(arg0)
	for iter0, iter1 in ipairs(arg0.panels) do
		if iter1:onBackPressed() then
			return
		end
	end

	if _courtyard then
		_courtyard:GetController():OnBackPressed()
	else
		var0.super.onBackPressed(arg0)
	end
end

function var0.willExit(arg0)
	_BackyardMsgBoxMgr:Destroy()

	_BackyardMsgBoxMgr = nil

	for iter0, iter1 in ipairs(arg0.panels) do
		iter1:Detach()
	end

	arg0.emptyFoodPage:Destroy()

	arg0.emptyFoodPage = nil

	if arg0.bulinTip then
		arg0.bulinTip:Destroy()

		arg0.bulinTip = nil
	end

	if arg0.contextData.mode ~= CourtYardConst.SYSTEM_VISIT then
		pg.m02:sendNotification(GAME.OPEN_ADD_EXP, 0)
	end

	getProxy(DormProxy):ClearNewFlag()
end

return var0
