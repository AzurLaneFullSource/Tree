local var0 = class("LuyijiushiTecCatchupPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.itemTF = arg0:findTF("Award", arg0.bg)
	arg0.sliderTF = arg0:findTF("Slider", arg0.bg)
	arg0.progressText = arg0:findTF("Progress", arg0.bg)
	arg0.goBtn = arg0:findTF("GoBtn", arg0.bg)
	arg0.finishBtn = arg0:findTF("FinishBtn", arg0.bg)
end

function var0.OnDataSetting(arg0)
	arg0.curCount = arg0.activity.data1

	local var0 = arg0.activity:getConfig("config_id")

	arg0.maxCount = pg.activity_event_blueprint_catchup[var0].obtain_max
	arg0.itemID = arg0.activity:getConfig("config_client").itemid
end

function var0.OnFirstFlush(arg0)
	local var0 = {
		type = DROP_TYPE_ITEM,
		id = arg0.itemID
	}

	updateDrop(arg0.itemTF, var0)
	onButton(arg0, arg0.itemTF, function()
		arg0:emit(BaseUI.ON_DROP, var0)
	end, SFX_PANEL)
	setSlider(arg0.sliderTF, 0, arg0.maxCount, arg0.curCount)
	setText(arg0.progressText, arg0.curCount .. "/" .. arg0.maxCount)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TECHNOLOGY)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.curCount >= arg0.maxCount

	setActive(arg0.goBtn, not var0)
	setActive(arg0.finishBtn, var0)
end

function var0.OnDestroy(arg0)
	return
end

return var0
