local var0_0 = class("HalloweenSkinPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.stage = arg0_1:findTF("AD/Text"):GetComponent(typeof(Text))
	arg0_1.goBtn = arg0_1:findTF("AD/go_btn")
	arg0_1.gotBtn = arg0_1:findTF("AD/got_btn")
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.tasks = _.flatten(arg0_2.activity:getConfig("config_data"))

	onButton(arg0_2, arg0_2.goBtn, function()
		if arg0_2:LastTaskBeFinished() then
			return
		end

		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NAVALACADEMYSCENE)
	end, SFX_PANEL)
end

function var0_0.LastTaskBeFinished(arg0_4)
	local var0_4 = getProxy(TaskProxy)
	local var1_4 = arg0_4.tasks[#arg0_4.tasks]
	local var2_4 = var0_4:getTaskVO(var1_4)

	if var2_4 and var2_4:isReceive() then
		return true
	end

	return false
end

function var0_0.OnUpdateFlush(arg0_5)
	local var0_5 = arg0_5.activity
	local var1_5 = 0
	local var2_5 = getProxy(TaskProxy)

	for iter0_5 = #arg0_5.tasks, 1, -1 do
		local var3_5 = arg0_5.tasks[iter0_5]
		local var4_5 = var2_5:getTaskVO(var3_5)

		if var4_5 and var4_5:isReceive() then
			var1_5 = iter0_5
		elseif var4_5 and not var4_5:isReceive() then
			var1_5 = iter0_5 - 1
		end
	end

	arg0_5.stage.text = var1_5 .. "/" .. #arg0_5.tasks

	local var5_5 = arg0_5:LastTaskBeFinished()

	setActive(arg0_5.gotBtn, var5_5)
end

function var0_0.OnDestroy(arg0_6)
	return
end

return var0_0
