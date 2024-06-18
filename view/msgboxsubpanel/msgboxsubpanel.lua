local var0_0 = class("MsgboxSubPanel", BaseSubPanel)

function var0_0.Load(arg0_1)
	if arg0_1._state ~= var0_0.STATES.NONE then
		return
	end

	arg0_1._state = var0_0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0_1 = PoolMgr.GetInstance()

	var0_1:GetUI(arg0_1:getUIName(), false, function(arg0_2)
		if arg0_1._state == var0_0.STATES.DESTROY then
			pg.UIMgr.GetInstance():LoadingOff()
			var0_1:ReturnUI(arg0_1:getUIName(), arg0_2)
		else
			arg0_1:Loaded(arg0_2)
			arg0_1:Init()
		end
	end)
end

function var0_0.SetWindowSize(arg0_3, arg1_3)
	setSizeDelta(arg0_3.viewParent._window, arg1_3)
end

function var0_0.UpdateView(arg0_4, arg1_4)
	arg0_4:PreRefresh(arg1_4)
	arg0_4:OnRefresh(arg1_4)
	arg0_4:PostRefresh(arg1_4)
end

function var0_0.PreRefresh(arg0_5, arg1_5)
	arg0_5.viewParent:commonSetting(arg1_5)
	arg0_5:Show()
end

function var0_0.PostRefresh(arg0_6, arg1_6)
	arg0_6.viewParent:Loaded(arg1_6)
end

function var0_0.OnRefresh(arg0_7, arg1_7)
	return
end

function var0_0.closeView(arg0_8)
	pg.MsgboxMgr.GetInstance():hide()
end

return var0_0
