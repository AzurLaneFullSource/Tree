local var0 = class("CommissionMetaBossBtn")

var0.STATE_LOCK = 1
var0.STATE_NORMAL = 2
var0.STATE_AUTO_BATTLE = 3
var0.STATE_FINSH_BATTLE = 4
var0.STATE_GET_AWARDS = 5

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0.event = arg2
	arg0.tr = arg1
	arg0.text = arg0.tr:Find("Text"):GetComponent(typeof(Text))
	arg0.tip = arg0.tr:Find("tip")
	arg0.timerIcon = arg0.tr:Find("timer")
	arg0.finishIcon = arg0.tr:Find("finish")

	arg0:Init()
end

function var0.Init(arg0)
	return
end

function var0.Flush(arg0)
	local var0 = arg0:GetBossState()

	arg0:RemoveTimer()

	arg0.text.text = ""

	if var0.STATE_AUTO_BATTLE == var0 then
		arg0:SetLeftTime()
	end

	setActive(arg0.timerIcon, var0.STATE_AUTO_BATTLE == var0)
	setActive(arg0.tip, var0.STATE_GET_AWARDS == var0 or var0.STATE_FINSH_BATTLE == var0)
	setActive(arg0.finishIcon, var0.STATE_FINSH_BATTLE == var0)
	setActive(arg0.tr, var0.STATE_LOCK ~= var0)
	onButton(arg0, arg0.tr, function()
		if var0 ~= var0.STATE_LOCK then
			arg0.event:emit(CommissionInfoMediator.GO_META_BOSS)
		end
	end, SFX_PANEL)
end

function var0.SetLeftTime(arg0)
	arg0:RemoveTimer()

	arg0.timer = Timer.New(function()
		local var0 = WorldBossConst.GetAutoBattleLeftTime()

		if var0 <= 0 then
			arg0:Flush()
		end

		arg0.text.text = pg.TimeMgr.GetInstance():DescCDTimeForMinute(var0)
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.GetBossState(arg0)
	return WorldBossConst.GetCommissionSceneMetaBossBtnState()
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:RemoveTimer()
end

return var0
