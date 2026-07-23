local var0_0 = class("MainActivityBtnView", import("...base.MainBaseView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.initPos = nil
	arg0_1.isInit = nil
	arg0_1.actBtnTpl = arg1_1:Find("actBtn")
	arg0_1.linkBtnTopFoldableHelper = MainFoldableHelper.New(arg0_1._tf.parent:Find("link_top"), Vector2(0, 1))
	arg0_1.checkNotchRatio = NotchAdapt.CheckNotchRatio

	arg0_1:InitBtns()
	arg0_1:Register()
end

function var0_0.GetActivityBtnList()
	return {
		MainActSummaryBtn,
		MainCoreActivityBtn,
		MainActEscortBtn,
		MainActMapBtn,
		MainActBossBtn,
		MainActBackHillBtn,
		MainActAtelierBtn,
		MainLanternFestivalBtn,
		MainActBossRushBtn,
		MainActAprilFoolBtn,
		MainActMedalCollectionBtn,
		MainActSenranBtn,
		MainActBossSingleBtn,
		MainActLayerBtn,
		MainActDreamlandBtn,
		MainActBoatAdBtn,
		MainActBlackFridaySalesBtn,
		MainActToLoveBtn,
		MainActHolidayVillaBtn,
		MainCoreActivityBtn2
	}
end

function var0_0.GetSpecailBtns()
	return {
		MainActInsBtn,
		MainActTraingCampBtn,
		MainActRefluxBtn,
		MainActNewServerBtn,
		MainActDelegationBtn,
		MainIslandActDelegationBtn,
		MainVoteEntranceBtn,
		MainActCompensatBtn
	}
end

function var0_0.InitBtns(arg0_4)
	arg0_4.activityBtns = {}

	for iter0_4, iter1_4 in ipairs(var0_0.GetActivityBtnList()) do
		if iter0_4 == 1 then
			table.insert(arg0_4.activityBtns, iter1_4.New(arg0_4.actBtnTpl, arg0_4.event, true))
		elseif iter0_4 == 2 then
			table.insert(arg0_4.activityBtns, iter1_4.New(arg0_4.actBtnTpl, arg0_4.event, false))
		else
			table.insert(arg0_4.activityBtns, iter1_4.New(arg0_4.actBtnTpl, arg0_4.event))
		end
	end

	arg0_4.specailBtns = {}

	for iter2_4, iter3_4 in ipairs(var0_0.GetSpecailBtns()) do
		table.insert(arg0_4.specailBtns, iter3_4.New(arg0_4._tf, arg0_4.event))
	end

	if pg.SdkMgr.GetInstance():CheckAudit() then
		arg0_4.specailBtns = {
			MainActTraingCampBtn.New(arg0_4._tf, arg0_4.event)
		}
	end
end

function var0_0.Register(arg0_5)
	arg0_5:bind(GAME.REMOVE_LAYERS, function(arg0_6, arg1_6)
		arg0_5:OnRemoveLayer(arg1_6.context)
	end)
	arg0_5:bind(GAME.REQ_NEW_INSTAGRAM_DATA_DONE, function(arg0_7)
		arg0_5:OnInstagramDataUpdate()
	end)
	arg0_5:bind(MiniGameProxy.ON_HUB_DATA_UPDATE, function(arg0_8)
		arg0_5:Refresh()
	end)
	arg0_5:bind(GAME.SEND_MINI_GAME_OP_DONE, function(arg0_9)
		arg0_5:Refresh()
	end)
	arg0_5:bind(GAME.GET_FEAST_DATA_DONE, function(arg0_10)
		arg0_5:Refresh()
	end)
	arg0_5:bind(GAME.FETCH_VOTE_INFO_DONE, function(arg0_11)
		arg0_5:Refresh()
	end)
	arg0_5:bind(GAME.ZERO_HOUR_OP_DONE, function(arg0_12)
		arg0_5:Refresh()
	end)
	arg0_5:bind(CompensateProxy.UPDATE_ATTACHMENT_COUNT, function(arg0_13)
		arg0_5:Refresh()
	end)
	arg0_5:bind(CompensateProxy.All_Compensate_Remove, function(arg0_14)
		arg0_5:Refresh()
	end)
end

function var0_0.GetBtn(arg0_15, arg1_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.activityBtns) do
		if isa(iter1_15, arg1_15) then
			return iter1_15
		end
	end

	for iter2_15, iter3_15 in ipairs(arg0_15.specailBtns) do
		if isa(iter3_15, arg1_15) then
			return iter3_15
		end
	end

	return nil
end

function var0_0.OnRemoveLayer(arg0_16, arg1_16)
	local var0_16

	if arg1_16.mediator == LotteryMediator then
		var0_16 = arg0_16:GetBtn(MainActLotteryBtn)
	elseif arg1_16.mediator == InstagramMainMediator then
		var0_16 = arg0_16:GetBtn(MainActInsBtn)
	end

	if var0_16 and var0_16:InShowTime() then
		var0_16:OnInit()
	end
end

function var0_0.OnInstagramDataUpdate(arg0_17)
	local var0_17 = arg0_17:GetBtn(MainActInsBtn)

	if var0_17 and var0_17:InShowTime() then
		var0_17:OnInit()
	end
end

function var0_0.Init(arg0_18)
	arg0_18:Flush()

	arg0_18.isInit = true
end

function var0_0.FilterActivityBtns(arg0_19)
	local var0_19 = {}
	local var1_19 = {}

	for iter0_19, iter1_19 in ipairs(arg0_19.activityBtns) do
		if iter1_19:InShowTime() then
			table.insert(var0_19, iter1_19)
		else
			table.insert(var1_19, iter1_19)
		end
	end

	table.sort(var0_19, CompareFuncs({
		function(arg0_20)
			return arg0_20.config.group_id
		end
	}))

	return var0_19, var1_19
end

function var0_0.FilterSpActivityBtns(arg0_21)
	local var0_21 = {}
	local var1_21 = {}

	for iter0_21, iter1_21 in ipairs(arg0_21.specailBtns) do
		if iter1_21:InShowTime() then
			table.insert(var0_21, iter1_21)
		else
			table.insert(var1_21, iter1_21)
		end
	end

	return var0_21, var1_21
end

function var0_0.Flush(arg0_22)
	if arg0_22.checkNotchRatio ~= NotchAdapt.CheckNotchRatio then
		arg0_22.checkNotchRatio = NotchAdapt.CheckNotchRatio
		arg0_22.initPos = nil
	end

	local var0_22, var1_22 = arg0_22:FilterActivityBtns()

	for iter0_22, iter1_22 in ipairs(var0_22) do
		iter1_22:Init(iter0_22)
	end

	for iter2_22, iter3_22 in ipairs(var1_22) do
		iter3_22:Clear()
	end

	local var2_22 = #var0_22
	local var3_22 = var2_22 <= 3
	local var4_22 = var3_22 and 1 or 0.85
	local var5_22 = var3_22 and 390 or 420

	arg0_22._tf.localScale = Vector3(var4_22, var4_22, 1)
	arg0_22.initPos = arg0_22.initPos or arg0_22._tf.localPosition

	onNextTick(function()
		if not IsNil(arg0_22._tf) then
			arg0_22._tf.localPosition = Vector3(arg0_22.initPos.x, var5_22, 0)
		end
	end)

	local var6_22, var7_22 = arg0_22:FilterSpActivityBtns()

	for iter4_22, iter5_22 in pairs(var6_22) do
		iter5_22:Init(not var3_22, var2_22 >= 5)
	end

	for iter6_22, iter7_22 in pairs(var7_22) do
		iter7_22:Clear()
	end
end

function var0_0.Refresh(arg0_24)
	if not arg0_24.isInit then
		return
	end

	arg0_24:Flush()

	for iter0_24, iter1_24 in ipairs(arg0_24.specailBtns) do
		if iter1_24:InShowTime() then
			iter1_24:Refresh()
		end
	end
end

function var0_0.Disable(arg0_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.specailBtns) do
		if iter1_25:InShowTime() then
			iter1_25:Disable()
		end
	end
end

function var0_0.Dispose(arg0_26)
	var0_0.super.Dispose(arg0_26)
	arg0_26.linkBtnTopFoldableHelper:Dispose()

	for iter0_26, iter1_26 in ipairs(arg0_26.activityBtns) do
		iter1_26:Dispose()
	end

	for iter2_26, iter3_26 in ipairs(arg0_26.specailBtns) do
		iter3_26:Dispose()
	end

	arg0_26.specailBtns = nil
	arg0_26.activityBtns = nil
end

function var0_0.Fold(arg0_27, arg1_27, arg2_27)
	var0_0.super.Fold(arg0_27, arg1_27, arg2_27)
	arg0_27.linkBtnTopFoldableHelper:Fold(arg1_27, arg2_27)
end

function var0_0.GetDirection(arg0_28)
	return Vector2(1, 0)
end

return var0_0
