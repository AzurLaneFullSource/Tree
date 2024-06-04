local var0 = class("HalloweenSkinPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.stage = arg0:findTF("AD/Text"):GetComponent(typeof(Text))
	arg0.goBtn = arg0:findTF("AD/go_btn")
	arg0.gotBtn = arg0:findTF("AD/got_btn")
end

function var0.OnFirstFlush(arg0)
	arg0.tasks = _.flatten(arg0.activity:getConfig("config_data"))

	onButton(arg0, arg0.goBtn, function()
		if arg0:LastTaskBeFinished() then
			return
		end

		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NAVALACADEMYSCENE)
	end, SFX_PANEL)
end

function var0.LastTaskBeFinished(arg0)
	local var0 = getProxy(TaskProxy)
	local var1 = arg0.tasks[#arg0.tasks]
	local var2 = var0:getTaskVO(var1)

	if var2 and var2:isReceive() then
		return true
	end

	return false
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity
	local var1 = 0
	local var2 = getProxy(TaskProxy)

	for iter0 = #arg0.tasks, 1, -1 do
		local var3 = arg0.tasks[iter0]
		local var4 = var2:getTaskVO(var3)

		if var4 and var4:isReceive() then
			var1 = iter0
		elseif var4 and not var4:isReceive() then
			var1 = iter0 - 1
		end
	end

	arg0.stage.text = var1 .. "/" .. #arg0.tasks

	local var5 = arg0:LastTaskBeFinished()

	setActive(arg0.gotBtn, var5)
end

function var0.OnDestroy(arg0)
	return
end

return var0
