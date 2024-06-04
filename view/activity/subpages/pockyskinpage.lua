local var0 = class("PockySkinPage", import("view.base.BaseActivityPage"))

function var0.GetCurrentDay()
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return pg.TimeMgr.GetInstance():STimeDescS(var0, "*t").yday
end

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.leftStage = arg0.bg:Find("left")
	arg0.rightStage = arg0.bg:Find("right")
	arg0.taskDesc = arg0.leftStage:Find("task")
	arg0.signDesc = arg0.leftStage:Find("signin")
	arg0.spine = nil
	arg0.spineLRQ = GetSpineRequestPackage.New("beierfasite_4", function(arg0)
		SetParent(arg0, arg0.leftStage:Find("ship"))

		arg0.spine = arg0
		arg0.spine.transform.localScale = Vector3.one

		arg0:SetAction("stand")

		arg0.spineLRQ = nil
	end):Start()

	local var0 = getProxy(PlayerProxy):getRawData().id

	arg0.startDay = PlayerPrefs.GetInt("PockySkinSignDay" .. (var0 or "-1"), 0)
	arg0.usmLRQ = nil
end

function var0.OnDataSetting(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1 = arg0.activity:getConfig("config_client").linkids
	local var2 = false

	arg0.ActSignIn = arg0.activity
	arg0.taskProxy = getProxy(TaskProxy)

	if arg0.ActSignIn then
		arg0.nday = 0
		arg0.taskGroup = arg0.ActSignIn:getConfig("config_data")
		var2 = var2 or updateActivityTaskStatus(arg0.ActSignIn)
	end

	arg0.ActPT = var0:getActivityById(var1[1])

	if arg0.ActPT then
		if arg0.ptData then
			arg0.ptData:Update(arg0.ActPT)
		else
			arg0.ptData = ActivityPtData.New(arg0.ActPT)
		end
	end

	arg0.ActTaskList = var0:getActivityById(var1[2])

	if arg0.ActTaskList then
		arg0.nday2 = 0
		arg0.taskGroup2 = arg0.ActTaskList:getConfig("config_data")
		var2 = var2 or updateActivityTaskStatus(arg0.ActTaskList)
	end

	arg0.ActFinal = var0:getActivityById(var1[3])

	if arg0.ActFinal then
		arg0.nday3 = 0
		arg0.taskGroup3 = arg0.ActFinal:getConfig("config_data")
		var2 = var2 or updateActivityTaskStatus(arg0.ActFinal)
	end

	return var2
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.rightStage:Find("display_btn"), function()
		arg0:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = arg0.ptData.type,
			dropList = arg0.ptData.dropList,
			targets = arg0.ptData.targets,
			level = arg0.ptData.level,
			count = arg0.ptData.count,
			resId = arg0.ptData.resId
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.rightStage:Find("battle_btn"), function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.rightStage:Find("get_btn"), function()
		local var0, var1 = arg0.ptData:GetResProgress()

		arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0.ptData:GetId(),
			arg1 = var1
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.bg:Find("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.pocky_help.tip
		})
	end, SFX_PANEL)
end

function var0.SetAction(arg0, arg1)
	if not arg0.spine then
		return
	end

	local var0 = arg0.spine:GetComponent("SpineAnimUI")

	if var0 then
		var0:SetAction(arg1, 0)
	end
end

function var0.OnUpdateFlush(arg0)
	arg0:UpdateTaskList()
	arg0:UpdatePTList()

	local var0 = arg0.startDay < arg0.GetCurrentDay()
	local var1 = "ui"
	local var2 = var0 and "juu_factory_rest" or "juu_factory"

	if arg0.usmLRQ and arg0.usmLRQ.name ~= var2 then
		arg0.usmLRQ:Stop()

		arg0.usmLRQ = nil
	end

	if arg0.usmName ~= var2 then
		arg0.usmLRQ = LoadPrefabRequestPackage.New(var1 .. "/" .. var2, var2, function(arg0)
			if not IsNil(arg0.usm) then
				Destroy(arg0.usm)
			end

			arg0.usm = arg0

			setParent(arg0, arg0.bg:Find("usm"))
		end):Start()
		arg0.usmName = var2
	end
end

function var0.UpdateTaskList(arg0)
	arg0.nday = arg0.ActSignIn.data3 or 0
	arg0.nday2 = arg0.ActTaskList.data3 or 0
	arg0.nday3 = arg0.ActFinal.data3 or 0

	local var0 = arg0.ActSignIn:getConfig("config_client").story

	if checkExist(var0, {
		arg0.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0[arg0.nday][1])
	end

	local var1 = arg0.leftStage:Find("go_btn")
	local var2 = arg0.leftStage:Find("get_btn")
	local var3 = arg0.leftStage:Find("sign_btn")
	local var4 = arg0.leftStage:Find("got_btn")
	local var5 = arg0.leftStage:Find("award")
	local var6 = arg0.leftStage:Find("slider")
	local var7 = getProxy(TaskProxy)
	local var8 = arg0.taskGroup[arg0.nday][1]
	local var9 = arg0.taskGroup2[arg0.nday2][1]
	local var10 = arg0.taskGroup3[arg0.nday3][1]
	local var11 = var7:getTaskVO(var8)
	local var12 = var7:getTaskVO(var9)
	local var13 = var7:getTaskVO(var10)
	local var14 = var11:getTaskStatus()
	local var15 = var12:getTaskStatus()
	local var16 = var13:getTaskStatus()

	if not arg0.startTaskid then
		arg0.startTaskid = var8
		arg0.startStatus = var14
	end

	local var17 = false

	if arg0.startTaskid ~= var8 then
		arg0.startTaskid = var8
		arg0.startStatus = var14
		var17 = true
	elseif arg0.startStatus ~= var14 then
		arg0.startStatus = var14
		var17 = true
	end

	local var18 = arg0.GetCurrentDay()

	if var17 and var18 > arg0.startDay then
		arg0.startDay = var18

		local var19 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("PockySkinSignDay" .. (var19 or "-1"), arg0.startDay)
	end

	if var16 == 2 then
		setActive(var5, false)
		setActive(var6, false)
		setActive(arg0.taskDesc, false)
		setActive(arg0.signDesc, true)
		setText(arg0.signDesc:Find("title"), i18n("pocky_jiujiu"))
		setText(arg0.signDesc:Find("desc"), i18n("pocky_jiujiu_desc"))
		setActive(var1, false)
		setActive(var3, true)
		setActive(var2, false)
		setActive(var4, false)
		onButton(arg0, var3, function()
			local var0 = arg0.GetCurrentDay()

			if var0 > arg0.startDay then
				arg0.startDay = var0

				local var1 = getProxy(PlayerProxy):getRawData().id

				PlayerPrefs.SetInt("PockySkinSignDay" .. (var1 or "-1"), arg0.startDay)
				arg0:OnUpdateFlush()
			end
		end, SFX_PANEL)
		removeOnButton(var4)

		return
	end

	local var20
	local var21
	local var22

	if arg0.ptData.level >= #arg0.ptData.targets and arg0.nday >= #arg0.taskGroup and var14 == 2 and arg0.nday2 >= #arg0.taskGroup2 and var15 == 2 then
		setActive(var3, false)

		var20 = var2
		var21 = var13
	elseif arg0.nday <= arg0.nday2 and var14 ~= 2 then
		setActive(var2, false)

		var20 = var3
		var21 = var11
	else
		setActive(var3, false)

		var20 = var2
		var21 = var12
	end

	local var23 = var21:getConfig("award_display")[1]
	local var24 = {
		type = var23[1],
		id = var23[2],
		count = var23[3]
	}

	setActive(var5, true)
	updateDrop(var5, var24)
	onButton(arg0, var5, function()
		arg0:emit(BaseUI.ON_DROP, var24)
	end, SFX_PANEL)
	setActive(var6, true)
	setActive(arg0.taskDesc, true)
	setActive(arg0.signDesc, false)

	local var25 = var21:getProgress()
	local var26 = var21:getConfig("target_num")

	setText(arg0.taskDesc:Find("title"), var21:getConfig("name"))
	setText(arg0.taskDesc:Find("desc"), var21:getConfig("desc"))
	setSlider(var6, 0, var26, var25)

	local var27 = var21:getTaskStatus()

	setActive(var1, var27 == 0)
	setActive(var20, var27 == 1)
	setActive(var4, var27 == 2)
	onButton(arg0, var1, function()
		arg0:emit(ActivityMediator.ON_TASK_GO, var21)
	end, SFX_PANEL)
	onButton(arg0, var20, function()
		arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var21)
	end, SFX_PANEL)
end

function var0.UpdatePTList(arg0)
	if not arg0.ptData then
		return
	end

	local var0 = arg0.ptData:getTargetLevel()
	local var1 = arg0.ActPT:getConfig("config_client").story

	if checkExist(var1, {
		var0
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var1[var0][1])
	end

	local var2, var3 = arg0.ptData:GetResProgress()
	local var4 = arg0.ptData:GetTotalResRequire()
	local var5 = arg0.rightStage:Find("slider")

	setSlider(var5, 0, 1, math.min(var2, var3) / var4)

	local var6 = arg0.ptData:GetUnlockedMaxResRequire()
	local var7 = arg0.rightStage:Find("slider_total")

	setSlider(var7, 0, 1, var6 / var4)

	local var8 = arg0.ptData:CanGetAward()
	local var9 = arg0.ptData:CanGetNextAward()
	local var10 = arg0.ptData:CanGetMorePt()

	setActive(arg0.rightStage:Find("battle_btn"), var10 and not var8 and var9)
	setActive(arg0.rightStage:Find("get_btn"), var8)
	setActive(arg0.rightStage:Find("got_btn"), not var9)
end

function var0.OnDestroy(arg0)
	if arg0.spineLRQ then
		arg0.spineLRQ:Stop()

		arg0.spineLRQ = nil
	end

	if arg0.spine then
		arg0.spine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar("beierfasite_4", arg0.spine)

		arg0.spine = nil
	end
end

return var0
