local var0_0 = class("CommissionMetaBossBtn")

var0_0.STATE_LOCK = 1
var0_0.STATE_NORMAL = 2
var0_0.STATE_AUTO_BATTLE = 3
var0_0.STATE_FINSH_BATTLE = 4
var0_0.STATE_GET_AWARDS = 5

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.event = arg2_1
	arg0_1.tr = arg1_1
	arg0_1.text = arg0_1.tr:Find("Text"):GetComponent(typeof(Text))
	arg0_1.tip = arg0_1.tr:Find("tip")
	arg0_1.timerIcon = arg0_1.tr:Find("timer")
	arg0_1.finishIcon = arg0_1.tr:Find("finish")

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	return
end

function var0_0.Flush(arg0_3)
	local var0_3 = arg0_3:GetBossState()

	arg0_3:RemoveTimer()

	arg0_3.text.text = ""

	if var0_0.STATE_AUTO_BATTLE == var0_3 then
		arg0_3:SetLeftTime()
	end

	setActive(arg0_3.timerIcon, var0_0.STATE_AUTO_BATTLE == var0_3)
	setActive(arg0_3.tip, var0_0.STATE_GET_AWARDS == var0_3 or var0_0.STATE_FINSH_BATTLE == var0_3)
	setActive(arg0_3.finishIcon, var0_0.STATE_FINSH_BATTLE == var0_3)
	setActive(arg0_3.tr, var0_0.STATE_LOCK ~= var0_3)
	onButton(arg0_3, arg0_3.tr, function()
		if var0_3 ~= var0_0.STATE_LOCK then
			arg0_3.event:emit(CommissionInfoMediator.GO_META_BOSS)
		end
	end, SFX_PANEL)
end

function var0_0.SetLeftTime(arg0_5)
	arg0_5:RemoveTimer()

	arg0_5.timer = Timer.New(function()
		local var0_6 = WorldBossConst.GetAutoBattleLeftTime()

		if var0_6 <= 0 then
			arg0_5:Flush()
		end

		arg0_5.text.text = pg.TimeMgr.GetInstance():DescCDTimeForMinute(var0_6)
	end, 1, -1)

	arg0_5.timer:Start()
	arg0_5.timer.func()
end

function var0_0.RemoveTimer(arg0_7)
	if arg0_7.timer then
		arg0_7.timer:Stop()

		arg0_7.timer = nil
	end
end

function var0_0.GetBossState(arg0_8)
	return WorldBossConst.GetCommissionSceneMetaBossBtnState()
end

function var0_0.Dispose(arg0_9)
	pg.DelegateInfo.Dispose(arg0_9)
	arg0_9:RemoveTimer()
end

return var0_0
