local var0 = class("YamaShiroSwimwearPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.goBtn = arg0:findTF("GoBtn")
	arg0.gotBtn = arg0:findTF("GotBtn")
	arg0.stepText = arg0:findTF("Step")
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity:getConfig("config_data")

	arg0.taskIDList = _.flatten(var0)

	return updateActivityTaskStatus(arg0.activity)
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0, var1 = getActivityTask(arg0.activity)
	local var2 = table.indexof(arg0.taskIDList, var0, 1)

	setText(arg0.stepText, var2)

	local var3 = var1:getTaskStatus()

	setActive(arg0.goBtn, var3 == 0 or var3 == 1)
	setActive(arg0.gotBtn, var3 == 2)
end

function var0.OnDestroy(arg0)
	return
end

return var0
