local var0_0 = class("NeptuneTecCatchupPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.itemTF = arg0_1:findTF("Award", arg0_1.bg)
	arg0_1.sliderTF = arg0_1:findTF("Slider", arg0_1.bg)
	arg0_1.progressText = arg0_1:findTF("Progress", arg0_1.bg)
	arg0_1.goBtn = arg0_1:findTF("GoBtn", arg0_1.bg)
	arg0_1.finishBtn = arg0_1:findTF("FinishBtn", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.curCount = arg0_2.activity.data1

	local var0_2 = arg0_2.activity:getConfig("config_id")

	arg0_2.maxCount = pg.activity_event_blueprint_catchup[var0_2].obtain_max
	arg0_2.itemID = arg0_2.activity:getConfig("config_client").itemid
end

function var0_0.OnFirstFlush(arg0_3)
	local var0_3 = {
		type = DROP_TYPE_ITEM,
		id = arg0_3.itemID
	}

	updateDrop(arg0_3.itemTF, var0_3)
	onButton(arg0_3, arg0_3.itemTF, function()
		arg0_3:emit(BaseUI.ON_DROP, var0_3)
	end, SFX_PANEL)
	setSlider(arg0_3.sliderTF, 0, arg0_3.maxCount, arg0_3.curCount)
	setText(arg0_3.progressText, arg0_3.curCount .. "/" .. arg0_3.maxCount)
	onButton(arg0_3, arg0_3.goBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TECHNOLOGY)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6 = arg0_6.curCount >= arg0_6.maxCount

	setActive(arg0_6.goBtn, not var0_6)

	if arg0_6.finishBtn then
		setActive(arg0_6.finishBtn, var0_6)
	end
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
