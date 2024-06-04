local var0 = class("ShinanoframePage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.goBtn = arg0:findTF("GoBtn", arg0.bg)
	arg0.getBtn = arg0:findTF("GetBtn", arg0.bg)
	arg0.gotBtn = arg0:findTF("GotBtn", arg0.bg)
	arg0.switchBtn = arg0:findTF("SwitchBtn", arg0.bg)
	arg0.phaseTF_1 = arg0:findTF("Phase1", arg0.bg)
	arg0.phaseTF_2 = arg0:findTF("Phase2", arg0.bg)
	arg0.gotTag = arg0:findTF("Phase2/GotTag", arg0.bg)
	arg0.frameTF = arg0:findTF("Phase2/Icon", arg0.bg)
	arg0.progressBar = arg0:findTF("Phase2/Progress", arg0.bg)
	arg0.progressText = arg0:findTF("Phase2/ProgressText", arg0.bg)

	setActive(arg0.goBtn, false)
	setActive(arg0.getBtn, false)
	setActive(arg0.gotBtn, false)
	setActive(arg0.gotTag, false)
	setActive(arg0.progressBar, false)
	setActive(arg0.progressText, false)
	setActive(arg0.phaseTF_2, false)
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
	onButton(arg0, arg0.switchBtn, function()
		setActive(arg0.phaseTF_1, not isActive(arg0.phaseTF_1))
		setActive(arg0.phaseTF_2, not isActive(arg0.phaseTF_2))
	end, SFX_PANEL)

	local var0 = arg0.ptData.dropList[1][2]
	local var1 = tostring(var0)
	local var2 = LoadAndInstantiateSync("IconFrame", var1)

	setParent(var2, arg0.frameTF, false)
end

function var0.OnUpdateFlush(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.SHINANO_EXP_ACT_ID)

	if not var0 or var0:isEnd() then
		setActive(arg0.phaseTF_1, false)
		setActive(arg0.phaseTF_2, true)

		local var1, var2, var3 = arg0.ptData:GetResProgress()

		setText(arg0.progressText, var1 .. "/" .. var2)
		setSlider(arg0.progressBar, 0, 1, var3)
		setActive(arg0.progressBar, true)
		setActive(arg0.progressText, true)

		local var4 = arg0.ptData:CanGetAward()
		local var5 = arg0.ptData:CanGetNextAward()
		local var6 = arg0.ptData:CanGetMorePt()

		setActive(arg0.goBtn, var6 and not var4 and var5)
		setActive(arg0.getBtn, var4)
		setActive(arg0.gotBtn, not var5)
		setActive(arg0.gotTag, not var5)
	else
		setActive(arg0.phaseTF_1, true)
		setActive(arg0.phaseTF_2, false)

		local var7, var8, var9 = arg0.ptData:GetResProgress()

		setText(arg0.progressText, var7 .. "/" .. var8)
		setSlider(arg0.progressBar, 0, 1, var9)
		setActive(arg0.progressBar, true)
		setActive(arg0.progressText, true)
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
