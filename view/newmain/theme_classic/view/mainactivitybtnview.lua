local var0 = class("MainActivityBtnView", import("...base.MainBaseView"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.initPos = nil
	arg0.isInit = nil
	arg0.actBtnTpl = arg1:Find("actBtn")
	arg0.linkBtnTopFoldableHelper = MainFoldableHelper.New(arg0._tf.parent:Find("link_top"), Vector2(0, 1))
	arg0.checkNotchRatio = NotchAdapt.CheckNotchRatio

	arg0:InitBtns()
	arg0:Register()
end

function var0.InitBtns(arg0)
	arg0.activityBtns = {
		MainActSummaryBtn.New(arg0.actBtnTpl, arg0.event, true),
		MainActEscortBtn.New(arg0.actBtnTpl, arg0.event),
		MainActMapBtn.New(arg0.actBtnTpl, arg0.event),
		MainActBossBtn.New(arg0.actBtnTpl, arg0.event),
		MainActBackHillBtn.New(arg0.actBtnTpl, arg0.event),
		MainActAtelierBtn.New(arg0.actBtnTpl, arg0.event),
		MainLanternFestivalBtn.New(arg0.actBtnTpl, arg0.event),
		MainActBossRushBtn.New(arg0.actBtnTpl, arg0.event),
		MainActAprilFoolBtn.New(arg0.actBtnTpl, arg0.event),
		MainActMedalCollectionBtn.New(arg0.actBtnTpl, arg0.event),
		MainActSenranBtn.New(arg0.actBtnTpl, arg0.event),
		MainActBossSingleBtn.New(tpl, event)
	}
	arg0.specailBtns = {
		MainActInsBtn.New(arg0._tf, arg0.event),
		MainActTraingCampBtn.New(arg0._tf, arg0.event),
		MainActRefluxBtn.New(arg0._tf, arg0.event),
		MainActNewServerBtn.New(arg0._tf, arg0.event),
		MainActDelegationBtn.New(arg0._tf, arg0.event),
		MainIslandActDelegationBtn.New(arg0._tf, arg0.event),
		MainVoteEntranceBtn.New(arg0._tf, arg0.event)
	}

	if pg.SdkMgr.GetInstance():CheckAudit() then
		arg0.specailBtns = {
			MainActTraingCampBtn.New(arg0._tf, arg0.event)
		}
	end
end

function var0.Register(arg0)
	arg0:bind(GAME.REMOVE_LAYERS, function(arg0, arg1)
		arg0:OnRemoveLayer(arg1.context)
	end)
	arg0:bind(MiniGameProxy.ON_HUB_DATA_UPDATE, function(arg0)
		arg0:Refresh()
	end)
	arg0:bind(GAME.SEND_MINI_GAME_OP_DONE, function(arg0)
		arg0:Refresh()
	end)
	arg0:bind(GAME.GET_FEAST_DATA_DONE, function(arg0)
		arg0:Refresh()
	end)
	arg0:bind(GAME.FETCH_VOTE_INFO_DONE, function(arg0)
		arg0:Refresh()
	end)
	arg0:bind(GAME.ZERO_HOUR_OP_DONE, function(arg0)
		arg0:Refresh()
	end)
end

function var0.GetBtn(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.activityBtns) do
		if isa(iter1, arg1) then
			return iter1
		end
	end

	for iter2, iter3 in ipairs(arg0.specailBtns) do
		if isa(iter3, arg1) then
			return iter3
		end
	end

	return nil
end

function var0.OnRemoveLayer(arg0, arg1)
	local var0

	if arg1.mediator == LotteryMediator then
		var0 = arg0:GetBtn(MainActLotteryBtn)
	elseif arg1.mediator == InstagramMediator then
		var0 = arg0:GetBtn(MainActInsBtn)
	end

	if var0 and var0:InShowTime() then
		var0:OnInit()
	end
end

function var0.Init(arg0)
	arg0:Flush()

	arg0.isInit = true
end

function var0.FilterActivityBtns(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.activityBtns) do
		if iter1:InShowTime() then
			table.insert(var0, iter1)
		else
			table.insert(var1, iter1)
		end
	end

	table.sort(var0, function(arg0, arg1)
		return arg0.config.group_id < arg1.config.group_id
	end)

	return var0, var1
end

function var0.FilterSpActivityBtns(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.specailBtns) do
		if iter1:InShowTime() then
			table.insert(var0, iter1)
		else
			table.insert(var1, iter1)
		end
	end

	return var0, var1
end

function var0.Flush(arg0)
	if arg0.checkNotchRatio ~= NotchAdapt.CheckNotchRatio then
		arg0.checkNotchRatio = NotchAdapt.CheckNotchRatio
		arg0.initPos = nil
	end

	local var0, var1 = arg0:FilterActivityBtns()

	for iter0, iter1 in ipairs(var0) do
		iter1:Init(iter0)
	end

	for iter2, iter3 in ipairs(var1) do
		iter3:Clear()
	end

	local var2 = #var0

	assert(var2 <= 4, "活动按钮不能超过4个")

	local var3 = var2 <= 3
	local var4 = var3 and 1 or 0.85
	local var5 = var3 and 390 or 420

	arg0._tf.localScale = Vector3(var4, var4, 1)
	arg0.initPos = arg0.initPos or arg0._tf.localPosition
	arg0._tf.localPosition = Vector3(arg0.initPos.x, var5, 0)

	local var6, var7 = arg0:FilterSpActivityBtns()

	for iter4, iter5 in pairs(var6) do
		iter5:Init(not var3)
	end

	for iter6, iter7 in pairs(var7) do
		iter7:Clear()
	end
end

function var0.Refresh(arg0)
	if not arg0.isInit then
		return
	end

	arg0:Flush()

	for iter0, iter1 in ipairs(arg0.specailBtns) do
		if iter1:InShowTime() then
			iter1:Refresh()
		end
	end
end

function var0.Disable(arg0)
	for iter0, iter1 in ipairs(arg0.specailBtns) do
		if iter1:InShowTime() then
			iter1:Disable()
		end
	end
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0.linkBtnTopFoldableHelper:Dispose()

	for iter0, iter1 in ipairs(arg0.activityBtns) do
		iter1:Dispose()
	end

	for iter2, iter3 in ipairs(arg0.specailBtns) do
		iter3:Dispose()
	end

	arg0.specailBtns = nil
	arg0.activityBtns = nil
end

function var0.Fold(arg0, arg1, arg2)
	var0.super.Fold(arg0, arg1, arg2)
	arg0.linkBtnTopFoldableHelper:Fold(arg1, arg2)
end

function var0.GetDirection(arg0)
	return Vector2(1, 0)
end

return var0
