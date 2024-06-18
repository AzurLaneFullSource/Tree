local var0_0 = class("ShinanoframePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.goBtn = arg0_1:findTF("GoBtn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("GetBtn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("GotBtn", arg0_1.bg)
	arg0_1.switchBtn = arg0_1:findTF("SwitchBtn", arg0_1.bg)
	arg0_1.phaseTF_1 = arg0_1:findTF("Phase1", arg0_1.bg)
	arg0_1.phaseTF_2 = arg0_1:findTF("Phase2", arg0_1.bg)
	arg0_1.gotTag = arg0_1:findTF("Phase2/GotTag", arg0_1.bg)
	arg0_1.frameTF = arg0_1:findTF("Phase2/Icon", arg0_1.bg)
	arg0_1.progressBar = arg0_1:findTF("Phase2/Progress", arg0_1.bg)
	arg0_1.progressText = arg0_1:findTF("Phase2/ProgressText", arg0_1.bg)

	setActive(arg0_1.goBtn, false)
	setActive(arg0_1.getBtn, false)
	setActive(arg0_1.gotBtn, false)
	setActive(arg0_1.gotTag, false)
	setActive(arg0_1.progressBar, false)
	setActive(arg0_1.progressText, false)
	setActive(arg0_1.phaseTF_2, false)
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
	onButton(arg0_3, arg0_3.switchBtn, function()
		setActive(arg0_3.phaseTF_1, not isActive(arg0_3.phaseTF_1))
		setActive(arg0_3.phaseTF_2, not isActive(arg0_3.phaseTF_2))
	end, SFX_PANEL)

	local var0_3 = arg0_3.ptData.dropList[1][2]
	local var1_3 = tostring(var0_3)
	local var2_3 = LoadAndInstantiateSync("IconFrame", var1_3)

	setParent(var2_3, arg0_3.frameTF, false)
end

function var0_0.OnUpdateFlush(arg0_7)
	local var0_7 = getProxy(ActivityProxy):getActivityById(ActivityConst.SHINANO_EXP_ACT_ID)

	if not var0_7 or var0_7:isEnd() then
		setActive(arg0_7.phaseTF_1, false)
		setActive(arg0_7.phaseTF_2, true)

		local var1_7, var2_7, var3_7 = arg0_7.ptData:GetResProgress()

		setText(arg0_7.progressText, var1_7 .. "/" .. var2_7)
		setSlider(arg0_7.progressBar, 0, 1, var3_7)
		setActive(arg0_7.progressBar, true)
		setActive(arg0_7.progressText, true)

		local var4_7 = arg0_7.ptData:CanGetAward()
		local var5_7 = arg0_7.ptData:CanGetNextAward()
		local var6_7 = arg0_7.ptData:CanGetMorePt()

		setActive(arg0_7.goBtn, var6_7 and not var4_7 and var5_7)
		setActive(arg0_7.getBtn, var4_7)
		setActive(arg0_7.gotBtn, not var5_7)
		setActive(arg0_7.gotTag, not var5_7)
	else
		setActive(arg0_7.phaseTF_1, true)
		setActive(arg0_7.phaseTF_2, false)

		local var7_7, var8_7, var9_7 = arg0_7.ptData:GetResProgress()

		setText(arg0_7.progressText, var7_7 .. "/" .. var8_7)
		setSlider(arg0_7.progressBar, 0, 1, var9_7)
		setActive(arg0_7.progressBar, true)
		setActive(arg0_7.progressText, true)
	end
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
