local var0_0 = class("PockySkinPage", import("view.base.BaseActivityPage"))

function var0_0.GetCurrentDay()
	local var0_1 = pg.TimeMgr.GetInstance():GetServerTime()

	return pg.TimeMgr.GetInstance():STimeDescS(var0_1, "*t").yday
end

function var0_0.OnInit(arg0_2)
	arg0_2.bg = arg0_2:findTF("AD")
	arg0_2.leftStage = arg0_2.bg:Find("left")
	arg0_2.rightStage = arg0_2.bg:Find("right")
	arg0_2.taskDesc = arg0_2.leftStage:Find("task")
	arg0_2.signDesc = arg0_2.leftStage:Find("signin")
	arg0_2.spine = nil
	arg0_2.spineLRQ = GetSpineRequestPackage.New("beierfasite_4", function(arg0_3)
		SetParent(arg0_3, arg0_2.leftStage:Find("ship"))

		arg0_2.spine = arg0_3
		arg0_2.spine.transform.localScale = Vector3.one

		arg0_2:SetAction("stand")

		arg0_2.spineLRQ = nil
	end):Start()

	local var0_2 = getProxy(PlayerProxy):getRawData().id

	arg0_2.startDay = PlayerPrefs.GetInt("PockySkinSignDay" .. (var0_2 or "-1"), 0)
	arg0_2.usmLRQ = nil
end

function var0_0.OnDataSetting(arg0_4)
	local var0_4 = getProxy(ActivityProxy)
	local var1_4 = arg0_4.activity:getConfig("config_client").linkids
	local var2_4 = false

	arg0_4.ActSignIn = arg0_4.activity
	arg0_4.taskProxy = getProxy(TaskProxy)

	if arg0_4.ActSignIn then
		arg0_4.nday = 0
		arg0_4.taskGroup = arg0_4.ActSignIn:getConfig("config_data")
		var2_4 = var2_4 or updateActivityTaskStatus(arg0_4.ActSignIn)
	end

	arg0_4.ActPT = var0_4:getActivityById(var1_4[1])

	if arg0_4.ActPT then
		if arg0_4.ptData then
			arg0_4.ptData:Update(arg0_4.ActPT)
		else
			arg0_4.ptData = ActivityPtData.New(arg0_4.ActPT)
		end
	end

	arg0_4.ActTaskList = var0_4:getActivityById(var1_4[2])

	if arg0_4.ActTaskList then
		arg0_4.nday2 = 0
		arg0_4.taskGroup2 = arg0_4.ActTaskList:getConfig("config_data")
		var2_4 = var2_4 or updateActivityTaskStatus(arg0_4.ActTaskList)
	end

	arg0_4.ActFinal = var0_4:getActivityById(var1_4[3])

	if arg0_4.ActFinal then
		arg0_4.nday3 = 0
		arg0_4.taskGroup3 = arg0_4.ActFinal:getConfig("config_data")
		var2_4 = var2_4 or updateActivityTaskStatus(arg0_4.ActFinal)
	end

	return var2_4
end

function var0_0.OnFirstFlush(arg0_5)
	onButton(arg0_5, arg0_5.rightStage:Find("display_btn"), function()
		arg0_5:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = arg0_5.ptData.type,
			dropList = arg0_5.ptData.dropList,
			targets = arg0_5.ptData.targets,
			level = arg0_5.ptData.level,
			count = arg0_5.ptData.count,
			resId = arg0_5.ptData.resId
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.rightStage:Find("battle_btn"), function()
		arg0_5:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.rightStage:Find("get_btn"), function()
		local var0_8, var1_8 = arg0_5.ptData:GetResProgress()

		arg0_5:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0_5.ptData:GetId(),
			arg1 = var1_8
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.bg:Find("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.pocky_help.tip
		})
	end, SFX_PANEL)
end

function var0_0.SetAction(arg0_10, arg1_10)
	if not arg0_10.spine then
		return
	end

	local var0_10 = arg0_10.spine:GetComponent("SpineAnimUI")

	if var0_10 then
		var0_10:SetAction(arg1_10, 0)
	end
end

function var0_0.OnUpdateFlush(arg0_11)
	arg0_11:UpdateTaskList()
	arg0_11:UpdatePTList()

	local var0_11 = arg0_11.startDay < arg0_11.GetCurrentDay()
	local var1_11 = "ui"
	local var2_11 = var0_11 and "juu_factory_rest" or "juu_factory"

	if arg0_11.usmLRQ and arg0_11.usmLRQ.name ~= var2_11 then
		arg0_11.usmLRQ:Stop()

		arg0_11.usmLRQ = nil
	end

	if arg0_11.usmName ~= var2_11 then
		arg0_11.usmLRQ = LoadPrefabRequestPackage.New(var1_11 .. "/" .. var2_11, var2_11, function(arg0_12)
			if not IsNil(arg0_11.usm) then
				Destroy(arg0_11.usm)
			end

			arg0_11.usm = arg0_12

			setParent(arg0_12, arg0_11.bg:Find("usm"))
		end):Start()
		arg0_11.usmName = var2_11
	end
end

function var0_0.UpdateTaskList(arg0_13)
	arg0_13.nday = arg0_13.ActSignIn.data3 or 0
	arg0_13.nday2 = arg0_13.ActTaskList.data3 or 0
	arg0_13.nday3 = arg0_13.ActFinal.data3 or 0

	local var0_13 = arg0_13.ActSignIn:getConfig("config_client").story

	if checkExist(var0_13, {
		arg0_13.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0_13[arg0_13.nday][1])
	end

	local var1_13 = arg0_13.leftStage:Find("go_btn")
	local var2_13 = arg0_13.leftStage:Find("get_btn")
	local var3_13 = arg0_13.leftStage:Find("sign_btn")
	local var4_13 = arg0_13.leftStage:Find("got_btn")
	local var5_13 = arg0_13.leftStage:Find("award")
	local var6_13 = arg0_13.leftStage:Find("slider")
	local var7_13 = getProxy(TaskProxy)
	local var8_13 = arg0_13.taskGroup[arg0_13.nday][1]
	local var9_13 = arg0_13.taskGroup2[arg0_13.nday2][1]
	local var10_13 = arg0_13.taskGroup3[arg0_13.nday3][1]
	local var11_13 = var7_13:getTaskVO(var8_13)
	local var12_13 = var7_13:getTaskVO(var9_13)
	local var13_13 = var7_13:getTaskVO(var10_13)
	local var14_13 = var11_13:getTaskStatus()
	local var15_13 = var12_13:getTaskStatus()
	local var16_13 = var13_13:getTaskStatus()

	if not arg0_13.startTaskid then
		arg0_13.startTaskid = var8_13
		arg0_13.startStatus = var14_13
	end

	local var17_13 = false

	if arg0_13.startTaskid ~= var8_13 then
		arg0_13.startTaskid = var8_13
		arg0_13.startStatus = var14_13
		var17_13 = true
	elseif arg0_13.startStatus ~= var14_13 then
		arg0_13.startStatus = var14_13
		var17_13 = true
	end

	local var18_13 = arg0_13.GetCurrentDay()

	if var17_13 and var18_13 > arg0_13.startDay then
		arg0_13.startDay = var18_13

		local var19_13 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("PockySkinSignDay" .. (var19_13 or "-1"), arg0_13.startDay)
	end

	if var16_13 == 2 then
		setActive(var5_13, false)
		setActive(var6_13, false)
		setActive(arg0_13.taskDesc, false)
		setActive(arg0_13.signDesc, true)
		setText(arg0_13.signDesc:Find("title"), i18n("pocky_jiujiu"))
		setText(arg0_13.signDesc:Find("desc"), i18n("pocky_jiujiu_desc"))
		setActive(var1_13, false)
		setActive(var3_13, true)
		setActive(var2_13, false)
		setActive(var4_13, false)
		onButton(arg0_13, var3_13, function()
			local var0_14 = arg0_13.GetCurrentDay()

			if var0_14 > arg0_13.startDay then
				arg0_13.startDay = var0_14

				local var1_14 = getProxy(PlayerProxy):getRawData().id

				PlayerPrefs.SetInt("PockySkinSignDay" .. (var1_14 or "-1"), arg0_13.startDay)
				arg0_13:OnUpdateFlush()
			end
		end, SFX_PANEL)
		removeOnButton(var4_13)

		return
	end

	local var20_13
	local var21_13
	local var22_13

	if arg0_13.ptData.level >= #arg0_13.ptData.targets and arg0_13.nday >= #arg0_13.taskGroup and var14_13 == 2 and arg0_13.nday2 >= #arg0_13.taskGroup2 and var15_13 == 2 then
		setActive(var3_13, false)

		var20_13 = var2_13
		var21_13 = var13_13
	elseif arg0_13.nday <= arg0_13.nday2 and var14_13 ~= 2 then
		setActive(var2_13, false)

		var20_13 = var3_13
		var21_13 = var11_13
	else
		setActive(var3_13, false)

		var20_13 = var2_13
		var21_13 = var12_13
	end

	local var23_13 = var21_13:getConfig("award_display")[1]
	local var24_13 = {
		type = var23_13[1],
		id = var23_13[2],
		count = var23_13[3]
	}

	setActive(var5_13, true)
	updateDrop(var5_13, var24_13)
	onButton(arg0_13, var5_13, function()
		arg0_13:emit(BaseUI.ON_DROP, var24_13)
	end, SFX_PANEL)
	setActive(var6_13, true)
	setActive(arg0_13.taskDesc, true)
	setActive(arg0_13.signDesc, false)

	local var25_13 = var21_13:getProgress()
	local var26_13 = var21_13:getConfig("target_num")

	setText(arg0_13.taskDesc:Find("title"), var21_13:getConfig("name"))
	setText(arg0_13.taskDesc:Find("desc"), var21_13:getConfig("desc"))
	setSlider(var6_13, 0, var26_13, var25_13)

	local var27_13 = var21_13:getTaskStatus()

	setActive(var1_13, var27_13 == 0)
	setActive(var20_13, var27_13 == 1)
	setActive(var4_13, var27_13 == 2)
	onButton(arg0_13, var1_13, function()
		arg0_13:emit(ActivityMediator.ON_TASK_GO, var21_13)
	end, SFX_PANEL)
	onButton(arg0_13, var20_13, function()
		arg0_13:emit(ActivityMediator.ON_TASK_SUBMIT, var21_13)
	end, SFX_PANEL)
end

function var0_0.UpdatePTList(arg0_18)
	if not arg0_18.ptData then
		return
	end

	local var0_18 = arg0_18.ptData:getTargetLevel()
	local var1_18 = arg0_18.ActPT:getConfig("config_client").story

	if checkExist(var1_18, {
		var0_18
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var1_18[var0_18][1])
	end

	local var2_18, var3_18 = arg0_18.ptData:GetResProgress()
	local var4_18 = arg0_18.ptData:GetTotalResRequire()
	local var5_18 = arg0_18.rightStage:Find("slider")

	setSlider(var5_18, 0, 1, math.min(var2_18, var3_18) / var4_18)

	local var6_18 = arg0_18.ptData:GetUnlockedMaxResRequire()
	local var7_18 = arg0_18.rightStage:Find("slider_total")

	setSlider(var7_18, 0, 1, var6_18 / var4_18)

	local var8_18 = arg0_18.ptData:CanGetAward()
	local var9_18 = arg0_18.ptData:CanGetNextAward()
	local var10_18 = arg0_18.ptData:CanGetMorePt()

	setActive(arg0_18.rightStage:Find("battle_btn"), var10_18 and not var8_18 and var9_18)
	setActive(arg0_18.rightStage:Find("get_btn"), var8_18)
	setActive(arg0_18.rightStage:Find("got_btn"), not var9_18)
end

function var0_0.OnDestroy(arg0_19)
	if arg0_19.spineLRQ then
		arg0_19.spineLRQ:Stop()

		arg0_19.spineLRQ = nil
	end

	if arg0_19.spine then
		arg0_19.spine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar("beierfasite_4", arg0_19.spine)

		arg0_19.spine = nil
	end
end

return var0_0
