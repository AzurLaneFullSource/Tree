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
		MainActBossSingleBtn.New(tpl, event)
	}
	arg0_2.specailBtns = {
		MainActInsBtn.New(arg0_2._tf, arg0_2.event),
		MainActTraingCampBtn.New(arg0_2._tf, arg0_2.event),
		MainActRefluxBtn.New(arg0_2._tf, arg0_2.event),
		MainActNewServerBtn.New(arg0_2._tf, arg0_2.event),
		MainActDelegationBtn.New(arg0_2._tf, arg0_2.event),
		MainIslandActDelegationBtn.New(arg0_2._tf, arg0_2.event),
		MainVoteEntranceBtn.New(arg0_2._tf, arg0_2.event)
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
end

function var0_0.GetBtn(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.activityBtns) do
		if isa(iter1_10, arg1_10) then
			return iter1_10
		end
	end

	for iter2_10, iter3_10 in ipairs(arg0_10.specailBtns) do
		if isa(iter3_10, arg1_10) then
			return iter3_10
		end
	end

	return nil
end

function var0_0.OnRemoveLayer(arg0_11, arg1_11)
	local var0_11

	if arg1_11.mediator == LotteryMediator then
		var0_11 = arg0_11:GetBtn(MainActLotteryBtn)
	elseif arg1_11.mediator == InstagramMediator then
		var0_11 = arg0_11:GetBtn(MainActInsBtn)
	end

	if var0_11 and var0_11:InShowTime() then
		var0_11:OnInit()
	end
end

function var0_0.Init(arg0_12)
	arg0_12:Flush()

	arg0_12.isInit = true
end

function var0_0.FilterActivityBtns(arg0_13)
	local var0_13 = {}
	local var1_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13.activityBtns) do
		if iter1_13:InShowTime() then
			table.insert(var0_13, iter1_13)
		else
			table.insert(var1_13, iter1_13)
		end
	end

	table.sort(var0_13, function(arg0_14, arg1_14)
		return arg0_14.config.group_id < arg1_14.config.group_id
	end)

	return var0_13, var1_13
end

function var0_0.FilterSpActivityBtns(arg0_15)
	local var0_15 = {}
	local var1_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.specailBtns) do
		if iter1_15:InShowTime() then
			table.insert(var0_15, iter1_15)
		else
			table.insert(var1_15, iter1_15)
		end
	end

	return var0_15, var1_15
end

function var0_0.Flush(arg0_16)
	if arg0_16.checkNotchRatio ~= NotchAdapt.CheckNotchRatio then
		arg0_16.checkNotchRatio = NotchAdapt.CheckNotchRatio
		arg0_16.initPos = nil
	end

	local var0_16, var1_16 = arg0_16:FilterActivityBtns()

	for iter0_16, iter1_16 in ipairs(var0_16) do
		iter1_16:Init(iter0_16)
	end

	for iter2_16, iter3_16 in ipairs(var1_16) do
		iter3_16:Clear()
	end

	local var2_16 = #var0_16

	assert(var2_16 <= 4, "活动按钮不能超过4个")

	local var3_16 = var2_16 <= 3
	local var4_16 = var3_16 and 1 or 0.85
	local var5_16 = var3_16 and 390 or 420

	arg0_16._tf.localScale = Vector3(var4_16, var4_16, 1)
	arg0_16.initPos = arg0_16.initPos or arg0_16._tf.localPosition
	arg0_16._tf.localPosition = Vector3(arg0_16.initPos.x, var5_16, 0)

	local var6_16, var7_16 = arg0_16:FilterSpActivityBtns()

	for iter4_16, iter5_16 in pairs(var6_16) do
		iter5_16:Init(not var3_16)
	end

	for iter6_16, iter7_16 in pairs(var7_16) do
		iter7_16:Clear()
	end
end

function var0_0.Refresh(arg0_17)
	if not arg0_17.isInit then
		return
	end

	arg0_17:Flush()

	for iter0_17, iter1_17 in ipairs(arg0_17.specailBtns) do
		if iter1_17:InShowTime() then
			iter1_17:Refresh()
		end
	end
end

function var0_0.Disable(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.specailBtns) do
		if iter1_18:InShowTime() then
			iter1_18:Disable()
		end
	end
end

function var0_0.Dispose(arg0_19)
	var0_0.super.Dispose(arg0_19)
	arg0_19.linkBtnTopFoldableHelper:Dispose()

	for iter0_19, iter1_19 in ipairs(arg0_19.activityBtns) do
		iter1_19:Dispose()
	end

	for iter2_19, iter3_19 in ipairs(arg0_19.specailBtns) do
		iter3_19:Dispose()
	end

	arg0_19.specailBtns = nil
	arg0_19.activityBtns = nil
end

function var0_0.Fold(arg0_20, arg1_20, arg2_20)
	var0_0.super.Fold(arg0_20, arg1_20, arg2_20)
	arg0_20.linkBtnTopFoldableHelper:Fold(arg1_20, arg2_20)
end

function var0_0.GetDirection(arg0_21)
	return Vector2(1, 0)
end

return var0_0
