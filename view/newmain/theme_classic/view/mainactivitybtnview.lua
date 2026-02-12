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

function var0_0.InitBtns(arg0_2)
	arg0_2.activityBtns = {
		MainActSummaryBtn.New(arg0_2.actBtnTpl, arg0_2.event, true),
		MainCoreActivityBtn.New(arg0_2.actBtnTpl, arg0_2.event, false),
		MainActEscortBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActMapBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActBossBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActBackHillBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActAtelierBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainLanternFestivalBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActBossRushBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActAprilFoolBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActMedalCollectionBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActSenranBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActBossSingleBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActLayerBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActDreamlandBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActBoatAdBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActBlackFridaySalesBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActToLoveBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainActHolidayVillaBtn.New(arg0_2.actBtnTpl, arg0_2.event),
		MainCoreActivityBtn2.New(arg0_2.actBtnTpl, arg0_2.event)
	}
	arg0_2.specailBtns = {
		MainActInsBtn.New(arg0_2._tf, arg0_2.event),
		MainActTraingCampBtn.New(arg0_2._tf, arg0_2.event),
		MainActRefluxBtn.New(arg0_2._tf, arg0_2.event),
		MainActNewServerBtn.New(arg0_2._tf, arg0_2.event),
		MainActDelegationBtn.New(arg0_2._tf, arg0_2.event),
		MainIslandActDelegationBtn.New(arg0_2._tf, arg0_2.event),
		MainVoteEntranceBtn.New(arg0_2._tf, arg0_2.event),
		MainActCompensatBtn.New(arg0_2._tf, arg0_2.event),
		MainLoveLetterDelegationBtn.New(arg0_2._tf, arg0_2.event)
	}

	if pg.SdkMgr.GetInstance():CheckAudit() then
		arg0_2.specailBtns = {
			MainActTraingCampBtn.New(arg0_2._tf, arg0_2.event)
		}
	end
end

function var0_0.Register(arg0_3)
	arg0_3:bind(GAME.REMOVE_LAYERS, function(arg0_4, arg1_4)
		arg0_3:OnRemoveLayer(arg1_4.context)
	end)
	arg0_3:bind(GAME.REQ_NEW_INSTAGRAM_DATA_DONE, function(arg0_5)
		arg0_3:OnInstagramDataUpdate()
	end)
	arg0_3:bind(MiniGameProxy.ON_HUB_DATA_UPDATE, function(arg0_6)
		arg0_3:Refresh()
	end)
	arg0_3:bind(GAME.SEND_MINI_GAME_OP_DONE, function(arg0_7)
		arg0_3:Refresh()
	end)
	arg0_3:bind(GAME.GET_FEAST_DATA_DONE, function(arg0_8)
		arg0_3:Refresh()
	end)
	arg0_3:bind(GAME.FETCH_VOTE_INFO_DONE, function(arg0_9)
		arg0_3:Refresh()
	end)
	arg0_3:bind(GAME.ZERO_HOUR_OP_DONE, function(arg0_10)
		arg0_3:Refresh()
	end)
	arg0_3:bind(CompensateProxy.UPDATE_ATTACHMENT_COUNT, function(arg0_11)
		arg0_3:Refresh()
	end)
	arg0_3:bind(CompensateProxy.All_Compensate_Remove, function(arg0_12)
		arg0_3:Refresh()
	end)
end

function var0_0.GetBtn(arg0_13, arg1_13)
	for iter0_13, iter1_13 in ipairs(arg0_13.activityBtns) do
		if isa(iter1_13, arg1_13) then
			return iter1_13
		end
	end

	for iter2_13, iter3_13 in ipairs(arg0_13.specailBtns) do
		if isa(iter3_13, arg1_13) then
			return iter3_13
		end
	end

	return nil
end

function var0_0.OnRemoveLayer(arg0_14, arg1_14)
	local var0_14

	if arg1_14.mediator == LotteryMediator then
		var0_14 = arg0_14:GetBtn(MainActLotteryBtn)
	elseif arg1_14.mediator == InstagramMainMediator then
		var0_14 = arg0_14:GetBtn(MainActInsBtn)
	end

	if var0_14 and var0_14:InShowTime() then
		var0_14:OnInit()
	end
end

function var0_0.OnInstagramDataUpdate(arg0_15)
	local var0_15 = arg0_15:GetBtn(MainActInsBtn)

	if var0_15 and var0_15:InShowTime() then
		var0_15:OnInit()
	end
end

function var0_0.Init(arg0_16)
	arg0_16:Flush()

	arg0_16.isInit = true
end

function var0_0.FilterActivityBtns(arg0_17)
	local var0_17 = {}
	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(arg0_17.activityBtns) do
		if iter1_17:InShowTime() then
			table.insert(var0_17, iter1_17)
		else
			table.insert(var1_17, iter1_17)
		end
	end

	table.sort(var0_17, CompareFuncs({
		function(arg0_18)
			return arg0_18.config.group_id
		end
	}))

	return var0_17, var1_17
end

function var0_0.FilterSpActivityBtns(arg0_19)
	local var0_19 = {}
	local var1_19 = {}

	for iter0_19, iter1_19 in ipairs(arg0_19.specailBtns) do
		if iter1_19:InShowTime() then
			table.insert(var0_19, iter1_19)
		else
			table.insert(var1_19, iter1_19)
		end
	end

	return var0_19, var1_19
end

function var0_0.Flush(arg0_20)
	if arg0_20.checkNotchRatio ~= NotchAdapt.CheckNotchRatio then
		arg0_20.checkNotchRatio = NotchAdapt.CheckNotchRatio
		arg0_20.initPos = nil
	end

	local var0_20, var1_20 = arg0_20:FilterActivityBtns()

	for iter0_20, iter1_20 in ipairs(var0_20) do
		iter1_20:Init(iter0_20)
	end

	for iter2_20, iter3_20 in ipairs(var1_20) do
		iter3_20:Clear()
	end

	local var2_20 = #var0_20

	assert(var2_20 <= 4, "活动按钮不能超过4个")

	local var3_20 = var2_20 <= 3
	local var4_20 = var3_20 and 1 or 0.85
	local var5_20 = var3_20 and 390 or 420

	arg0_20._tf.localScale = Vector3(var4_20, var4_20, 1)
	arg0_20.initPos = arg0_20.initPos or arg0_20._tf.localPosition

	onNextTick(function()
		if not IsNil(arg0_20._tf) then
			arg0_20._tf.localPosition = Vector3(arg0_20.initPos.x, var5_20, 0)
		end
	end)

	local var6_20, var7_20 = arg0_20:FilterSpActivityBtns()

	for iter4_20, iter5_20 in pairs(var6_20) do
		iter5_20:Init(not var3_20)
	end

	for iter6_20, iter7_20 in pairs(var7_20) do
		iter7_20:Clear()
	end
end

function var0_0.Refresh(arg0_22)
	if not arg0_22.isInit then
		return
	end

	arg0_22:Flush()

	for iter0_22, iter1_22 in ipairs(arg0_22.specailBtns) do
		if iter1_22:InShowTime() then
			iter1_22:Refresh()
		end
	end
end

function var0_0.Disable(arg0_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.specailBtns) do
		if iter1_23:InShowTime() then
			iter1_23:Disable()
		end
	end
end

function var0_0.Dispose(arg0_24)
	var0_0.super.Dispose(arg0_24)
	arg0_24.linkBtnTopFoldableHelper:Dispose()

	for iter0_24, iter1_24 in ipairs(arg0_24.activityBtns) do
		iter1_24:Dispose()
	end

	for iter2_24, iter3_24 in ipairs(arg0_24.specailBtns) do
		iter3_24:Dispose()
	end

	arg0_24.specailBtns = nil
	arg0_24.activityBtns = nil
end

function var0_0.Fold(arg0_25, arg1_25, arg2_25)
	var0_0.super.Fold(arg0_25, arg1_25, arg2_25)
	arg0_25.linkBtnTopFoldableHelper:Fold(arg1_25, arg2_25)
end

function var0_0.GetDirection(arg0_26)
	return Vector2(1, 0)
end

return var0_0
