ys = ys or {}

local var0 = ys

var0.Battle.BattleControllerCommand = class("BattleControllerCommand", var0.MVC.Command)
var0.Battle.BattleControllerCommand.__name = "BattleControllerCommand"

function var0.Battle.BattleControllerCommand.Ctor(arg0)
	var0.Battle.BattleControllerCommand.super.Ctor(arg0)
end

function var0.Battle.BattleControllerCommand.Initialize(arg0)
	var0.Battle.BattleControllerCommand.super.Initialize(arg0)

	arg0._dataProxy = arg0._state:GetProxyByName(var0.Battle.BattleDataProxy.__name)

	arg0:InitBattleEvent()
end

function var0.Battle.BattleControllerCommand.InitBattleEvent(arg0)
	return
end

function var0.Battle.BattleControllerCommand.addSpeed(arg0)
	var0.Battle.BattleConfig.BASIC_TIME_SCALE = var0.Battle.BattleConfig.BASIC_TIME_SCALE * arg0

	var0.Battle.BattleVariable.AppendIFFFactor(var0.Battle.BattleConfig.FOE_CODE, "cheat_speed_up_" .. var0.Battle.BattleConfig.BASIC_TIME_SCALE, arg0)
	var0.Battle.BattleVariable.AppendIFFFactor(var0.Battle.BattleConfig.FRIENDLY_CODE, "cheat_speed_up_" .. var0.Battle.BattleConfig.BASIC_TIME_SCALE, arg0)
end

function var0.Battle.BattleControllerCommand.removeSpeed(arg0)
	var0.Battle.BattleVariable.RemoveIFFFactor(var0.Battle.BattleConfig.FOE_CODE, "cheat_speed_up_" .. var0.Battle.BattleConfig.BASIC_TIME_SCALE)
	var0.Battle.BattleVariable.RemoveIFFFactor(var0.Battle.BattleConfig.FRIENDLY_CODE, "cheat_speed_up_" .. var0.Battle.BattleConfig.BASIC_TIME_SCALE)

	var0.Battle.BattleConfig.BASIC_TIME_SCALE = var0.Battle.BattleConfig.BASIC_TIME_SCALE * arg0
end

function var0.Battle.BattleControllerCommand.scaleTime(arg0)
	pg.TipsMgr.GetInstance():ShowTips("┏━━━━━━━━━━━━┓")
	pg.TipsMgr.GetInstance():ShowTips("┃ヽ(•̀ω•́ )ゝ嗑药 X" .. var0.Battle.BattleConfig.BASIC_TIME_SCALE .. " ！(ง •̀_•́)ง┃")
	pg.TipsMgr.GetInstance():ShowTips("┗━━━━━━━━━━━━┛")
	arg0._state:ScaleTimer()
end
