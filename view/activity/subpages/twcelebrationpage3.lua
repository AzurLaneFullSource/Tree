local var0 = class("TWCelebrationPage3", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.getBtn = arg0:findTF("AD/get")
	arg0.gotBtn = arg0:findTF("AD/got")
	arg0.share = arg0:findTF("AD/share")
	arg0.mask = arg0:findTF("AD/mask")
	arg0.finished = arg0:findTF("AD/finished")
	arg0.unfinished = arg0:findTF("AD/unfinished")
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
	setActive(arg0.share, var2 and not var3)
	setActive(arg0.finished, var2 and var3)
	setActive(arg0.unfinished, var2 and not var3)
	onButton(arg0, arg0.share, function()
		arg0:share()
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		if var2 and var3 and not var4 then
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var2)
		end
	end, SFX_PANEL)
end

function var0.share(arg0)
	arg0:initShare()
end

function var0.initShare(arg0)
	PoolMgr.GetInstance():GetUI("TWCelebrationShare", false, function(arg0)
		local var0 = GameObject.Find("UICamera"):GetComponent(typeof(Camera)).transform:GetChild(0)

		SetParent(arg0, var0, false)
	end)
end

return var0
