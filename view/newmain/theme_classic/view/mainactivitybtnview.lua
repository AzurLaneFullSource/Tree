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
		MainActDreamlandBtn.New(arg0_2.actBtnTpl, arg0_2.event)
	}
	arg0_2.specailBtns = {
		MainActInsBtn.New(arg0_2._tf, arg0_2.event),
		MainActTraingCampBtn.New(arg0_2._tf, arg0_2.event),
		MainActRefluxBtn.New(arg0_2._tf, arg0_2.event),
		MainActNewServerBtn.New(arg0_2._tf, arg0_2.event),
		MainActDelegationBtn.New(arg0_2._tf, arg0_2.event),
		MainIslandActDelegationBtn.New(arg0_2._tf, arg0_2.event),
		MainVoteEntranceBtn.New(arg0_2._tf, arg0_2.event),
		MainActCompensatBtn.New(arg0_2._tf, arg0_2.event)
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
	arg0_3:bind(MiniGameProxy.ON_HUB_DATA_UPDATE, function(arg0_5)
		arg0_3:Refresh()
	end)
	arg0_3:bind(GAME.SEND_MINI_GAME_OP_DONE, function(arg0_6)
		arg0_3:Refresh()
	end)
	arg0_3:bind(GAME.GET_FEAST_DATA_DONE, function(arg0_7)
		arg0_3:Refresh()
	end)
	arg0_3:bind(GAME.FETCH_VOTE_INFO_DONE, function(arg0_8)
		arg0_3:Refresh()
	end)
	arg0_3:bind(GAME.ZERO_HOUR_OP_DONE, function(arg0_9)
		arg0_3:Refresh()
	end)
	arg0_3:bind(CompensateProxy.UPDATE_ATTACHMENT_COUNT, function(arg0_10)
		arg0_3:Refresh()
	end)
	arg0_3:bind(CompensateProxy.All_Compensate_Remove, function(arg0_11)
		arg0_3:Refresh()
	end)
end

function var0_0.GetBtn(arg0_12, arg1_12)
	for iter0_12, iter1_12 in ipairs(arg0_12.activityBtns) do
		if isa(iter1_12, arg1_12) then
			return iter1_12
		end
	end

	for iter2_12, iter3_12 in ipairs(arg0_12.specailBtns) do
		if isa(iter3_12, arg1_12) then
			return iter3_12
		end
	end

	return nil
end

function var0_0.OnRemoveLayer(arg0_13, arg1_13)
	local var0_13

	if arg1_13.mediator == LotteryMediator then
		var0_13 = arg0_13:GetBtn(MainActLotteryBtn)
	elseif arg1_13.mediator == InstagramMediator then
		var0_13 = arg0_13:GetBtn(MainActInsBtn)
	end

	if var0_13 and var0_13:InShowTime() then
		var0_13:OnInit()
	end
end

function var0_0.Init(arg0_14)
	arg0_14:Flush()

	arg0_14.isInit = true
end

function var0_0.FilterActivityBtns(arg0_15)
	local var0_15 = {}
	local var1_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.activityBtns) do
		if iter1_15:InShowTime() then
			table.insert(var0_15, iter1_15)
		else
			table.insert(var1_15, iter1_15)
		end
	end

	table.sort(var0_15, function(arg0_16, arg1_16)
		return arg0_16.config.group_id < arg1_16.config.group_id
	end)

	return var0_15, var1_15
end

function var0_0.FilterSpActivityBtns(arg0_17)
	local var0_17 = {}
	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(arg0_17.specailBtns) do
		if iter1_17:InShowTime() then
			table.insert(var0_17, iter1_17)
		else
			table.insert(var1_17, iter1_17)
		end
	end

	return var0_17, var1_17
end

function var0_0.Flush(arg0_18)
	if arg0_18.checkNotchRatio ~= NotchAdapt.CheckNotchRatio then
		arg0_18.checkNotchRatio = NotchAdapt.CheckNotchRatio
		arg0_18.initPos = nil
	end

	local var0_18, var1_18 = arg0_18:FilterActivityBtns()

	for iter0_18, iter1_18 in ipairs(var0_18) do
		iter1_18:Init(iter0_18)
	end

	for iter2_18, iter3_18 in ipairs(var1_18) do
		iter3_18:Clear()
	end

	local var2_18 = #var0_18

	assert(var2_18 <= 4, "活动按钮不能超过4个")

	local var3_18 = var2_18 <= 3
	local var4_18 = var3_18 and 1 or 0.85
	local var5_18 = var3_18 and 390 or 420

	arg0_18._tf.localScale = Vector3(var4_18, var4_18, 1)
	arg0_18.initPos = arg0_18.initPos or arg0_18._tf.localPosition
	arg0_18._tf.localPosition = Vector3(arg0_18.initPos.x, var5_18, 0)

	local var6_18, var7_18 = arg0_18:FilterSpActivityBtns()

	for iter4_18, iter5_18 in pairs(var6_18) do
		iter5_18:Init(not var3_18)
	end

	for iter6_18, iter7_18 in pairs(var7_18) do
		iter7_18:Clear()
	end
end

function var0_0.Refresh(arg0_19)
	if not arg0_19.isInit then
		return
	end

	arg0_19:Flush()

	for iter0_19, iter1_19 in ipairs(arg0_19.specailBtns) do
		if iter1_19:InShowTime() then
			iter1_19:Refresh()
		end
	end
end

function var0_0.Disable(arg0_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.specailBtns) do
		if iter1_20:InShowTime() then
			iter1_20:Disable()
		end
	end
end

function var0_0.Dispose(arg0_21)
	var0_0.super.Dispose(arg0_21)
	arg0_21.linkBtnTopFoldableHelper:Dispose()

	for iter0_21, iter1_21 in ipairs(arg0_21.activityBtns) do
		iter1_21:Dispose()
	end

	for iter2_21, iter3_21 in ipairs(arg0_21.specailBtns) do
		iter3_21:Dispose()
	end

	arg0_21.specailBtns = nil
	arg0_21.activityBtns = nil
end

function var0_0.Fold(arg0_22, arg1_22, arg2_22)
	var0_0.super.Fold(arg0_22, arg1_22, arg2_22)
	arg0_22.linkBtnTopFoldableHelper:Fold(arg1_22, arg2_22)
end

function var0_0.GetDirection(arg0_23)
	return Vector2(1, 0)
end

return var0_0
