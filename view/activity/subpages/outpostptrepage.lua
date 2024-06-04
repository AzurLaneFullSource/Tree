local var0 = class("OutPostPtRePage", import(".TemplatePage.NewFrameTemplatePage"))
local var1 = {
	16851,
	16852,
	16853,
	16854
}

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.bg = arg0:findTF("AD")
	arg0.switchBtn = arg0:findTF("AD/switcher/switch_btn")
	arg0.bar = arg0:findTF("AD/switcher/phase2/Image/bar")
	arg0.displayBtn = arg0:findTF("AD/display_btn")
	arg0.gotTag = arg0:findTF("AD/switcher/phase2/Image/got")

	local var0 = arg0.displayBtn:Find("Image1")
	local var1 = arg0.displayBtn:Find("Image2")
	local var2, var3 = arg0:GetActTask()
	local var4 = var2 and var2:isReceive() and var3

	setActive(var0, not var4)
	setActive(var1, var4)

	local var5

	onButton(arg0, arg0.displayBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity",
			targetId = var5
		})
	end)
end

function var0.GetActTask(arg0)
	local var0 = var1
	local var1 = getProxy(TaskProxy)
	local var2
	local var3 = false

	for iter0 = #var0, 1, -1 do
		local var4 = var0[iter0]
		local var5 = var1:getTaskById(var4) or var1:getFinishTaskById(var4)

		if var5 then
			var2 = var5

			if iter0 == #var0 then
				var3 = true
			end

			break
		end
	end

	return var2, var3
end

return var0
