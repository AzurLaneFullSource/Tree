local var0_0 = class("ShadowPlayPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.getBtn = arg0_1:findTF("AD/get")
	arg0_1.gotBtn = arg0_1:findTF("AD/got")
	arg0_1.urlBtn = arg0_1:findTF("AD/url")
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.urlBtn, function()
		Application.OpenURL(arg0_2.activity:getConfig("config_client"))
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_4)
	local var0_4 = arg0_4.activity:getConfig("config_data")[1]
	local var1_4 = getProxy(TaskProxy)
	local var2_4 = var1_4:getTaskById(var0_4) or var1_4:getFinishTaskById(var0_4) or Task.New({
		id = var0_4
	})
	local var3_4 = var2_4:isFinish()
	local var4_4 = var2_4:isReceive()

	setActive(arg0_4.getBtn, var2_4 and var3_4 and not var4_4)
	setActive(arg0_4.gotBtn, var2_4 and var4_4)
	onButton(arg0_4, arg0_4.getBtn, function()
		if var2_4 and var3_4 and not var4_4 then
			arg0_4:emit(ActivityMediator.ON_TASK_SUBMIT, var2_4)
		end
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_6)
	return
end

return var0_0
