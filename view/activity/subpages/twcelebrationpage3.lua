local var0_0 = class("TWCelebrationPage3", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.getBtn = arg0_1:findTF("AD/get")
	arg0_1.gotBtn = arg0_1:findTF("AD/got")
	arg0_1.share = arg0_1:findTF("AD/share")
	arg0_1.mask = arg0_1:findTF("AD/mask")
	arg0_1.finished = arg0_1:findTF("AD/finished")
	arg0_1.unfinished = arg0_1:findTF("AD/unfinished")
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
	setActive(arg0_3.share, var2_3 and not var3_3)
	setActive(arg0_3.finished, var2_3 and var3_3)
	setActive(arg0_3.unfinished, var2_3 and not var3_3)
	onButton(arg0_3, arg0_3.share, function()
		arg0_3:share()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		if var2_3 and var3_3 and not var4_3 then
			arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, var2_3)
		end
	end, SFX_PANEL)
end

function var0_0.share(arg0_6)
	arg0_6:initShare()
end

function var0_0.initShare(arg0_7)
	PoolMgr.GetInstance():GetUI("TWCelebrationShare", false, function(arg0_8)
		local var0_8 = GameObject.Find("UICamera"):GetComponent(typeof(Camera)).transform:GetChild(0)

		SetParent(arg0_8, var0_8, false)
	end)
end

return var0_0
