local var0_0 = class("OutPostPtRePage", import(".TemplatePage.NewFrameTemplatePage"))
local var1_0 = {
	16851,
	16852,
	16853,
	16854
}

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.switchBtn = arg0_1:findTF("AD/switcher/switch_btn")
	arg0_1.bar = arg0_1:findTF("AD/switcher/phase2/Image/bar")
	arg0_1.displayBtn = arg0_1:findTF("AD/display_btn")
	arg0_1.gotTag = arg0_1:findTF("AD/switcher/phase2/Image/got")

	local var0_1 = arg0_1.displayBtn:Find("Image1")
	local var1_1 = arg0_1.displayBtn:Find("Image2")
	local var2_1, var3_1 = arg0_1:GetActTask()
	local var4_1 = var2_1 and var2_1:isReceive() and var3_1

	setActive(var0_1, not var4_1)
	setActive(var1_1, var4_1)

	local var5_1

	onButton(arg0_1, arg0_1.displayBtn, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity",
			targetId = var5_1
		})
	end)
end

function var0_0.GetActTask(arg0_3)
	local var0_3 = var1_0
	local var1_3 = getProxy(TaskProxy)
	local var2_3
	local var3_3 = false

	for iter0_3 = #var0_3, 1, -1 do
		local var4_3 = var0_3[iter0_3]
		local var5_3 = var1_3:getTaskById(var4_3) or var1_3:getFinishTaskById(var4_3)

		if var5_3 then
			var2_3 = var5_3

			if iter0_3 == #var0_3 then
				var3_3 = true
			end

			break
		end
	end

	return var2_3, var3_3
end

return var0_0
