local var0_0 = class("YamaShiroSwimwearPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.goBtn = arg0_1:findTF("GoBtn")
	arg0_1.gotBtn = arg0_1:findTF("GotBtn")
	arg0_1.stepText = arg0_1:findTF("Step")
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_data")

	arg0_2.taskIDList = _.flatten(var0_2)

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.goBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_5)
	local var0_5, var1_5 = getActivityTask(arg0_5.activity)
	local var2_5 = table.indexof(arg0_5.taskIDList, var0_5, 1)

	setText(arg0_5.stepText, var2_5)

	local var3_5 = var1_5:getTaskStatus()

	setActive(arg0_5.goBtn, var3_5 == 0 or var3_5 == 1)
	setActive(arg0_5.gotBtn, var3_5 == 2)
end

function var0_0.OnDestroy(arg0_6)
	return
end

return var0_0
