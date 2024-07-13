local var0_0 = class("TWCelebrationPage2", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.getBtn = arg0_1:findTF("AD/get_btn")
	arg0_1.gotBtn = arg0_1:findTF("AD/got_btn")
	arg0_1.goBtn = arg0_1:findTF("AD/battle_btn")
	arg0_1.mark = arg0_1:findTF("AD/mark")
end

function var0_0.OnFirstFlush(arg0_2)
	return
end

function var0_0.OnUpdateFlush(arg0_3)
	local var0_3 = arg0_3.activity:getConfig("config_data")[1]
	local var1_3 = getProxy(TaskProxy)
	local var2_3 = var1_3:getTaskById(var0_3) or var1_3:getFinishTaskById(var0_3) or Task.New({
		id = var0_3
	})
	local var3_3 = var2_3:isFinish()
	local var4_3 = var2_3:isReceive()

	setActive(arg0_3.getBtn, var2_3 and var3_3 and not var4_3)
	setActive(arg0_3.gotBtn, var2_3 and var4_3)
	setActive(arg0_3.mark, var2_3 and var4_3)
	setActive(arg0_3.goBtn, var2_3 and not var3_3)
	onButton(arg0_3, arg0_3.goBtn, function()
		arg0_3:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		if var2_3 and var3_3 and not var4_3 then
			arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, var2_3)
		end
	end, SFX_PANEL)
end

return var0_0
