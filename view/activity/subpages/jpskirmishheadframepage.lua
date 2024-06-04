local var0 = class("JPSkirmishHeadFramePage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.goBtn = arg0:findTF("GoBtn", arg0.bg)
	arg0.getBtn = arg0:findTF("GetBtn", arg0.bg)
	arg0.gotBtn = arg0:findTF("GotBtn", arg0.bg)
	arg0.gotTag = arg0:findTF("GotTag", arg0.bg)
	arg0.progressBar = arg0:findTF("Progress", arg0.bg)
	arg0.progressText = arg0:findTF("ProgressText", arg0.bg)

	setActive(arg0.goBtn, false)
	setActive(arg0.getBtn, false)
	setActive(arg0.gotBtn, false)
	setActive(arg0.gotTag, false)
end

function var0.OnDataSetting(arg0)
	if arg0.ptData then
		arg0.ptData:Update(arg0.activity)
	else
		arg0.ptData = ActivityPtData.New(arg0.activity)
	end
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		local var0, var1 = arg0.ptData:GetResProgress()

		arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0.ptData:GetId(),
			arg1 = var1
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity:getConfig("config_client").linkExpActID
	local var1 = getProxy(ActivityProxy):getActivityById(var0)

	if not var1 or var1:isEnd() then
		local var2 = arg0.ptData:CanGetAward()
		local var3 = arg0.ptData:CanGetNextAward()
		local var4 = arg0.ptData:CanGetMorePt()

		setActive(arg0.goBtn, var4 and not var2 and var3)
		setActive(arg0.getBtn, var2)
		setActive(arg0.gotBtn, not var3)
		setActive(arg0.gotTag, not var3)
	end

	local var5, var6, var7 = arg0.ptData:GetResProgress()

	setText(arg0.progressText, setColorStr(var5, "#487CFFFF") .. "/" .. var6)
	setSlider(arg0.progressBar, 0, 1, var7)
	setActive(arg0.progressText, true)
end

function var0.OnDestroy(arg0)
	return
end

return var0
