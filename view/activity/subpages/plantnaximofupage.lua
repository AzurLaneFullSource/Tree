local var0_0 = class("PlantNaximofuPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.clickTime = nil
end

function var0_0.initSkin(arg0_2)
	arg0_2.showItemNum = arg0_2.activity.data3 < arg0_2.itmeNum and arg0_2.activity.data3 or arg0_2.itmeNum
	arg0_2.skinTf = findTF(arg0_2._tf, "AD/skinPage")

	setActive(arg0_2.skinTf, false)

	arg0_2.descClose = findTF(arg0_2._tf, "AD/skinPage/descClose")

	setText(arg0_2.descClose, i18n("island_act_tips1"))

	arg0_2.skinIndex = 1

	arg0_2:pageUpdate()

	arg0_2.bottom = findTF(arg0_2.skinTf, "bottom")

	onButton(arg0_2, arg0_2.bottom, function()
		if arg0_2.clickTime and Time.realtimeSinceStartup - arg0_2.clickTime < 0.5 then
			return
		end

		arg0_2.clickTime = Time.realtimeSinceStartup

		arg0_2:displayWindow(false)

		if arg0_2.playHandle then
			arg0_2.playHandle()

			arg0_2.playHandle = nil
		end
	end)
	onButton(arg0_2, findTF(arg0_2.skinTf, "leftGo/left"), function()
		if arg0_2.clickTime and Time.realtimeSinceStartup - arg0_2.clickTime < 0.5 then
			return
		end

		arg0_2.clickTime = Time.realtimeSinceStartup

		if arg0_2.skinIndex > 1 then
			local var0_4 = arg0_2.displayDayList[arg0_2.skinIndex]

			arg0_2.skinIndex = arg0_2.skinIndex - 1

			arg0_2:updateSkinUI()
			setActive(findTF(arg0_2.skinTf, "skins/skin" .. var0_4), true)
			arg0_2:StartTimer(function()
				setActive(findTF(arg0_2.skinTf, "skins/skin" .. var0_4), false)
			end)
			findTF(arg0_2.skinTf, "skins/skin" .. var0_4):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_left")
		end
	end)
	onButton(arg0_2, findTF(arg0_2.skinTf, "rightGo/right"), function()
		if arg0_2.clickTime and Time.realtimeSinceStartup - arg0_2.clickTime < 0.5 then
			return
		end

		arg0_2.clickTime = Time.realtimeSinceStartup

		if arg0_2.displayDayList[arg0_2.skinIndex] < arg0_2.showItemNum then
			local var0_6 = arg0_2.displayDayList[arg0_2.skinIndex]

			arg0_2.skinIndex = arg0_2.skinIndex + 1

			arg0_2:updateSkinUI()
			setActive(findTF(arg0_2.skinTf, "skins/skin" .. var0_6), true)
			arg0_2:StartTimer(function()
				setActive(findTF(arg0_2.skinTf, "skins/skin" .. var0_6), false)
			end)
			findTF(arg0_2.skinTf, "skins/skin" .. arg0_2.displayDayList[arg0_2.skinIndex]):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_right")
		end
	end)

	for iter0_2 = 1, #arg0_2.displayDayList do
		local var0_2 = arg0_2.displayDayList[iter0_2]

		onButton(arg0_2, findTF(arg0_2.skinTf, "page/" .. var0_2), function()
			if arg0_2.clickTime and Time.realtimeSinceStartup - arg0_2.clickTime < 0.5 then
				return
			end

			arg0_2.clickTime = Time.realtimeSinceStartup

			if arg0_2.skinIndex ~= iter0_2 then
				local var0_8 = arg0_2.displayDayList[arg0_2.skinIndex]

				if arg0_2.skinIndex < iter0_2 then
					arg0_2.skinIndex = arg0_2.skinIndex + 1

					arg0_2:updateSkinUI()
					setActive(findTF(arg0_2.skinTf, "skins/skin" .. var0_8), true)
					arg0_2:StartTimer(function()
						setActive(findTF(arg0_2.skinTf, "skins/skin" .. var0_8), false)
					end)
					findTF(arg0_2.skinTf, "skins/skin" .. arg0_2.displayDayList[arg0_2.skinIndex]):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_right")
				elseif arg0_2.skinIndex > 1 then
					arg0_2.skinIndex = arg0_2.skinIndex - 1

					arg0_2:updateSkinUI()
					setActive(findTF(arg0_2.skinTf, "skins/skin" .. var0_8), true)
					arg0_2:StartTimer(function()
						setActive(findTF(arg0_2.skinTf, "skins/skin" .. var0_8), false)
					end)
					findTF(arg0_2.skinTf, "skins/skin" .. var0_8):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_left")
				end
			end
		end)
		setActive(findTF(arg0_2.skinTf, "page/" .. var0_2), var0_2 <= arg0_2.showItemNum)
	end
end

function var0_0.UpdateTask(arg0_11, arg1_11, arg2_11)
	var0_0.super.UpdateTask(arg0_11, arg1_11, arg2_11)

	local var0_11 = arg1_11 + 1
	local var1_11 = arg0_11.taskGroup[arg0_11.nday][var0_11]
	local var2_11 = arg0_11.taskProxy:getTaskById(var1_11) or arg0_11.taskProxy:getFinishTaskById(var1_11)
	local var3_11 = arg0_11:findTF("get_btn", arg2_11)

	onButton(arg0_11, var3_11, function()
		if arg0_11.nday <= arg0_11.itmeNum then
			function arg0_11.playHandle()
				arg0_11:emit(ActivityMediator.ON_TASK_SUBMIT, var2_11)
			end

			if arg0_11:GetDayIndex(arg0_11.displayDayList, arg0_11.nday) then
				arg0_11.skinIndex = arg0_11:GetNextDayIndex(arg0_11.displayDayList, arg0_11.nday)

				arg0_11:displayWindow(true)
			else
				arg0_11.playHandle()

				arg0_11.playHandle = nil
			end
		else
			arg0_11:emit(ActivityMediator.ON_TASK_SUBMIT, var2_11)
		end
	end, SFX_PANEL)

	local var4_11 = arg0_11:findTF("got_btn", arg2_11)

	onButton(arg0_11, var4_11, function()
		arg0_11:displayWindow(true)
	end, SFX_PANEL)

	local var5_11 = arg0_11:findTF("review_btn", arg0_11.bg)

	onButton(arg0_11, var5_11, function()
		arg0_11:displayWindow(true)
	end, SFX_PANEL)
end

function var0_0.GetDayIndex(arg0_16, arg1_16, arg2_16)
	for iter0_16, iter1_16 in ipairs(arg1_16) do
		if iter1_16 == arg2_16 then
			return iter0_16
		end
	end
end

function var0_0.GetNextDayIndex(arg0_17, arg1_17, arg2_17)
	for iter0_17, iter1_17 in ipairs(arg1_17) do
		if arg2_17 <= iter1_17 then
			return iter0_17
		end
	end

	return 1
end

function var0_0.GetLastDay(arg0_18, arg1_18, arg2_18)
	for iter0_18, iter1_18 in ipairs(arg1_18) do
		if iter1_18 == arg2_18 then
			return arg0_18.displayDayList[iter0_18 - 1]
		end
	end

	return 0
end

function var0_0.pageUpdate(arg0_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.displayDayList) do
		setActive(findTF(arg0_19.skinTf, "page/" .. iter1_19), iter1_19 <= arg0_19.showItemNum)
		setActive(findTF(arg0_19.skinTf, "page/" .. iter1_19 .. "/selected"), arg0_19.skinIndex == iter0_19)
		setActive(findTF(arg0_19.skinTf, "skins/skin" .. iter1_19), arg0_19.skinIndex == iter0_19)

		findTF(arg0_19.skinTf, "skins/skin" .. iter1_19):GetComponent(typeof(Image)).fillAmount = 1
	end
end

function var0_0.OnFirstFlush(arg0_20)
	arg0_20.displayDayList = arg0_20.activity:getConfig("config_client").displayDay or {
		0,
		1,
		2,
		3,
		4,
		5,
		6,
		7
	}
	arg0_20.itmeNum = #arg0_20.activity:getConfig("config_data")

	var0_0.super.OnFirstFlush(arg0_20)

	arg0_20.skinIndex = arg0_20:GetNextDayIndex(arg0_20.displayDayList, arg0_20.activity.data3 > arg0_20.itmeNum and 0 or arg0_20.activity.data3)

	arg0_20:initSkin()
end

function var0_0.OnUpdateFlush(arg0_21)
	arg0_21.nday = arg0_21.activity.data3

	local var0_21 = arg0_21.activity:getConfig("config_client").story

	if checkExist(var0_21, {
		1
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0_21[1][1])
	end

	arg0_21.uilist:align(#arg0_21.taskGroup[arg0_21.nday])
end

function var0_0.updateSkinUI(arg0_22)
	if arg0_22.playHandle then
		setActive(findTF(arg0_22.skinTf, "leftGo"), false)
		setActive(findTF(arg0_22.skinTf, "rightGo"), false)
		setActive(findTF(arg0_22.skinTf, "page"), false)
	else
		if arg0_22.skinIndex > 1 then
			findTF(arg0_22.skinTf, "leftGo/left"):GetComponent(typeof(CanvasGroup)).alpha = 1
		else
			findTF(arg0_22.skinTf, "leftGo/left"):GetComponent(typeof(CanvasGroup)).alpha = 0.2
		end

		if arg0_22.displayDayList[arg0_22.skinIndex] < arg0_22.showItemNum then
			findTF(arg0_22.skinTf, "rightGo/right"):GetComponent(typeof(CanvasGroup)).alpha = 1
		else
			findTF(arg0_22.skinTf, "rightGo/right"):GetComponent(typeof(CanvasGroup)).alpha = 0.2
		end

		setActive(findTF(arg0_22.skinTf, "page"), true)
	end

	arg0_22:pageUpdate()
end

function var0_0.displayWindow(arg0_23, arg1_23)
	if arg0_23.blurFlag == arg1_23 then
		return
	end

	if arg1_23 then
		setActive(arg0_23.skinTf, true)
		arg0_23.skinTf:GetComponent(typeof(Animation)):Play("anim_plantNaximofu_in")
		pg.UIMgr.GetInstance():BlurPanel(arg0_23.skinTf, {
			staticBlur = true
		})

		local var0_23 = arg0_23.taskGroup[arg0_23.nday][1]
		local var1_23 = (arg0_23.taskProxy:getTaskById(var0_23) or arg0_23.taskProxy:getFinishTaskById(var0_23)):getTaskStatus()

		arg0_23.showItemNum = arg0_23.activity.data3 < arg0_23.itmeNum and arg0_23.activity.data3 or arg0_23.itmeNum

		if var1_23 ~= 2 then
			arg0_23.showItemNum = arg0_23.showItemNum - 1
		end

		arg0_23:updateSkinUI()

		if arg0_23.playHandle then
			local var2_23 = arg0_23:GetLastDay(arg0_23.displayDayList, arg0_23.nday)

			setActive(findTF(arg0_23.skinTf, "skins/skin" .. var2_23), true)
			arg0_23:StartTimer(function()
				setActive(findTF(arg0_23.skinTf, "skins/skin" .. var2_23), false)
			end)
			findTF(arg0_23.skinTf, "skins/skin" .. arg0_23.displayDayList[arg0_23.skinIndex]):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_right")
		end
	else
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_23.skinTf)
		arg0_23.skinTf:GetComponent(typeof(Animation)):Play("anim_plantNaximofu_out")
		arg0_23:StartTimer(function()
			setActive(arg0_23.skinTf, false)
			SetParent(arg0_23.skinTf, arg0_23._tf)
		end)
	end

	arg0_23.blurFlag = arg1_23
end

function var0_0.StartTimer(arg0_26, arg1_26)
	arg0_26:RemoveTimer()

	arg0_26.timer = Timer.New(arg1_26, 0.5, 1)

	arg0_26.timer:Start()
end

function var0_0.RemoveTimer(arg0_27)
	if arg0_27.timer then
		arg0_27.timer:Stop()

		arg0_27.timer = nil
	end
end

function var0_0.OnDestroy(arg0_28)
	var0_0.super.OnDestroy(arg0_28)
	arg0_28:displayWindow(false)
	arg0_28:RemoveTimer()
end

function var0_0.GetProgressColor(arg0_29)
	return "#34480CFF", "#34480C66"
end

return var0_0
