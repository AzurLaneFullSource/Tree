local var0 = class("CourtYardLeftPanel", import(".CourtYardBasePanel"))

function var0.GetUIName(arg0)
	return "main/leftPanel"
end

function var0.init(arg0)
	arg0.viewBtn = arg0:findTF("eye_btn")
end

function var0.OnRegister(arg0)
	onToggle(arg0, arg0.viewBtn, function(arg0)
		arg0:emit(CourtYardMediator.FOLD, arg0)
	end, SFX_PANEL)
end

function var0.OnEnterEditMode(arg0)
	var0.super.OnEnterEditMode(arg0)
	setActive(arg0.viewBtn, false)
end

function var0.OnExitEditMode(arg0)
	var0.super.OnExitEditMode(arg0)
	setActive(arg0.viewBtn, true)
end

function var0.UpdateFloor(arg0)
	return
end

function var0.OnVisitRegister(arg0)
	onToggle(arg0, arg0.viewBtn, function(arg0)
		arg0:emit(CourtYardMediator.FOLD, arg0)
	end, SFX_PANEL)
end

function var0.GetMoveX(arg0)
	return {}
end

function var0.OnFlush(arg0, arg1)
	return
end

return var0
