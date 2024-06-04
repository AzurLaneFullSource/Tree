local var0 = class("TWCelebrationPage2", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.getBtn = arg0:findTF("AD/get_btn")
	arg0.gotBtn = arg0:findTF("AD/got_btn")
	arg0.goBtn = arg0:findTF("AD/battle_btn")
	arg0.mark = arg0:findTF("AD/mark")
end

function var0.OnFirstFlush(arg0)
	return
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity:getConfig("config_data")[1]
	local var1 = getProxy(TaskProxy)
	local var2 = var1:getTaskById(var0) or var1:getFinishTaskById(var0) or Task.New({
		id = var0
	})
	local var3 = var2:isFinish()
	local var4 = var2:isReceive()

	setActive(arg0.getBtn, var2 and var3 and not var4)
	setActive(arg0.gotBtn, var2 and var4)
	setActive(arg0.mark, var2 and var4)
	setActive(arg0.goBtn, var2 and not var3)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		if var2 and var3 and not var4 then
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var2)
		end
	end, SFX_PANEL)
end

return var0
