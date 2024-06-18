ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleControllerCommand = class("BattleControllerCommand", var0_0.MVC.Command)
var0_0.Battle.BattleControllerCommand.__name = "BattleControllerCommand"

function var0_0.Battle.BattleControllerCommand.Ctor(arg0_1)
	var0_0.Battle.BattleControllerCommand.super.Ctor(arg0_1)
end

function var0_0.Battle.BattleControllerCommand.Initialize(arg0_2)
	var0_0.Battle.BattleControllerCommand.super.Initialize(arg0_2)

	arg0_2._dataProxy = arg0_2._state:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)

	arg0_2:InitBattleEvent()
end

function var0_0.Battle.BattleControllerCommand.InitBattleEvent(arg0_3)
	return
end

function var0_0.Battle.BattleControllerCommand.addSpeed(arg0_4)
	var0_0.Battle.BattleConfig.BASIC_TIME_SCALE = var0_0.Battle.BattleConfig.BASIC_TIME_SCALE * arg0_4

	var0_0.Battle.BattleVariable.AppendIFFFactor(var0_0.Battle.BattleConfig.FOE_CODE, "cheat_speed_up_" .. var0_0.Battle.BattleConfig.BASIC_TIME_SCALE, arg0_4)
	var0_0.Battle.BattleVariable.AppendIFFFactor(var0_0.Battle.BattleConfig.FRIENDLY_CODE, "cheat_speed_up_" .. var0_0.Battle.BattleConfig.BASIC_TIME_SCALE, arg0_4)
end

function var0_0.Battle.BattleControllerCommand.removeSpeed(arg0_5)
	var0_0.Battle.BattleVariable.RemoveIFFFactor(var0_0.Battle.BattleConfig.FOE_CODE, "cheat_speed_up_" .. var0_0.Battle.BattleConfig.BASIC_TIME_SCALE)
	var0_0.Battle.BattleVariable.RemoveIFFFactor(var0_0.Battle.BattleConfig.FRIENDLY_CODE, "cheat_speed_up_" .. var0_0.Battle.BattleConfig.BASIC_TIME_SCALE)

	var0_0.Battle.BattleConfig.BASIC_TIME_SCALE = var0_0.Battle.BattleConfig.BASIC_TIME_SCALE * arg0_5
end

function var0_0.Battle.BattleControllerCommand.scaleTime(arg0_6)
	pg.TipsMgr.GetInstance():ShowTips("┏━━━━━━━━━━━━┓")
	pg.TipsMgr.GetInstance():ShowTips("┃ヽ(•̀ω•́ )ゝ嗑药 X" .. var0_0.Battle.BattleConfig.BASIC_TIME_SCALE .. " ！(ง •̀_•́)ง┃")
	pg.TipsMgr.GetInstance():ShowTips("┗━━━━━━━━━━━━┛")
	arg0_6._state:ScaleTimer()
end
