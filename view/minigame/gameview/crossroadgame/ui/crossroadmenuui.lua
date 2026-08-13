local var0_0 = class("CrossRoadMenuUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1.totalTimes = arg0_1._gameVo:GetTotalTimes()

	arg0_1:initUI()
end

function var0_0.initUI(arg0_2)
	arg0_2.menuUI = findTF(arg0_2._tf, "ui/menuUI")
	arg0_2.ui = findTF(arg0_2.menuUI, "ui")

	onButton(arg0_2._event, findTF(arg0_2.menuUI, "ui/btnBack"), function()
		arg0_2:Show(false)
		arg0_2._event:emit(SimpleMGEvent.CLOSE_GAME)
	end, SFX_CANCEL)

	arg0_2.btnRule = findTF(arg0_2.menuUI, "ui/btnRule")

	onButton(arg0_2._event, arg0_2.btnRule, function()
		arg0_2._event:emit(SimpleMGEvent.SHOW_RULE, true)
	end, SFX_CANCEL)

	arg0_2.btnStart = findTF(arg0_2.menuUI, "ui/btnStart")

	onButton(arg0_2._event, arg0_2.btnStart, function()
		arg0_2:Show(false)
		arg0_2._event:emit(SimpleMGEvent.READY_START)
	end, SFX_CANCEL)
end

function var0_0.Show(arg0_6, arg1_6)
	local var0_6 = pg.UIMgr.GetInstance()

	if arg1_6 then
		setActive(arg0_6.menuUI, true)
		var0_6:BlurPanel(arg0_6.menuUI)
	else
		var0_6:UnOverlayPanel(arg0_6.menuUI, arg0_6._tf)
		setActive(arg0_6.menuUI, false)
	end
end

function var0_0.Update(arg0_7)
	return
end

return var0_0
