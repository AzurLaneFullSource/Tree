local var0 = class("MsgboxSubPanel", BaseSubPanel)

function var0.Load(arg0)
	if arg0._state ~= var0.STATES.NONE then
		return
	end

	arg0._state = var0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0 = PoolMgr.GetInstance()

	var0:GetUI(arg0:getUIName(), false, function(arg0)
		if arg0._state == var0.STATES.DESTROY then
			pg.UIMgr.GetInstance():LoadingOff()
			var0:ReturnUI(arg0:getUIName(), arg0)
		else
			arg0:Loaded(arg0)
			arg0:Init()
		end
	end)
end

function var0.SetWindowSize(arg0, arg1)
	setSizeDelta(arg0.viewParent._window, arg1)
end

function var0.UpdateView(arg0, arg1)
	arg0:PreRefresh(arg1)
	arg0:OnRefresh(arg1)
	arg0:PostRefresh(arg1)
end

function var0.PreRefresh(arg0, arg1)
	arg0.viewParent:commonSetting(arg1)
	arg0:Show()
end

function var0.PostRefresh(arg0, arg1)
	arg0.viewParent:Loaded(arg1)
end

function var0.OnRefresh(arg0, arg1)
	return
end

function var0.closeView(arg0)
	pg.MsgboxMgr.GetInstance():hide()
end

return var0
