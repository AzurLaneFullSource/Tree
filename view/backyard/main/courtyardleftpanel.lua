local var0_0 = class("CourtYardLeftPanel", import(".CourtYardBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "main/leftPanel"
end

function var0_0.init(arg0_2)
	arg0_2.viewBtn = arg0_2:findTF("eye_btn")
end

function var0_0.OnRegister(arg0_3)
	onToggle(arg0_3, arg0_3.viewBtn, function(arg0_4)
		arg0_3:emit(CourtYardMediator.FOLD, arg0_4)
	end, SFX_PANEL)
end

function var0_0.OnEnterEditMode(arg0_5)
	var0_0.super.OnEnterEditMode(arg0_5)
	setActive(arg0_5.viewBtn, false)
end

function var0_0.OnExitEditMode(arg0_6)
	var0_0.super.OnExitEditMode(arg0_6)
	setActive(arg0_6.viewBtn, true)
end

function var0_0.UpdateFloor(arg0_7)
	return
end

function var0_0.OnVisitRegister(arg0_8)
	onToggle(arg0_8, arg0_8.viewBtn, function(arg0_9)
		arg0_8:emit(CourtYardMediator.FOLD, arg0_9)
	end, SFX_PANEL)
end

function var0_0.GetMoveX(arg0_10)
	return {}
end

function var0_0.OnFlush(arg0_11, arg1_11)
	return
end

return var0_0
