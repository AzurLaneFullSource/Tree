local var0_0 = class("JPSkirmishHeadFramePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.goBtn = arg0_1:findTF("GoBtn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("GetBtn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("GotBtn", arg0_1.bg)
	arg0_1.gotTag = arg0_1:findTF("GotTag", arg0_1.bg)
	arg0_1.progressBar = arg0_1:findTF("Progress", arg0_1.bg)
	arg0_1.progressText = arg0_1:findTF("ProgressText", arg0_1.bg)

	setActive(arg0_1.goBtn, false)
	setActive(arg0_1.getBtn, false)
	setActive(arg0_1.gotBtn, false)
	setActive(arg0_1.gotTag, false)
end

function var0_0.OnDataSetting(arg0_2)
	if arg0_2.ptData then
		arg0_2.ptData:Update(arg0_2.activity)
	else
		arg0_2.ptData = ActivityPtData.New(arg0_2.activity)
	end
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.goBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		local var0_5, var1_5 = arg0_3.ptData:GetResProgress()

		arg0_3:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0_3.ptData:GetId(),
			arg1 = var1_5
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6 = arg0_6.activity:getConfig("config_client").linkExpActID
	local var1_6 = getProxy(ActivityProxy):getActivityById(var0_6)

	if not var1_6 or var1_6:isEnd() then
		local var2_6 = arg0_6.ptData:CanGetAward()
		local var3_6 = arg0_6.ptData:CanGetNextAward()
		local var4_6 = arg0_6.ptData:CanGetMorePt()

		setActive(arg0_6.goBtn, var4_6 and not var2_6 and var3_6)
		setActive(arg0_6.getBtn, var2_6)
		setActive(arg0_6.gotBtn, not var3_6)
		setActive(arg0_6.gotTag, not var3_6)
	end

	local var5_6, var6_6, var7_6 = arg0_6.ptData:GetResProgress()

	setText(arg0_6.progressText, setColorStr(var5_6, "#487CFFFF") .. "/" .. var6_6)
	setSlider(arg0_6.progressBar, 0, 1, var7_6)
	setActive(arg0_6.progressText, true)
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
