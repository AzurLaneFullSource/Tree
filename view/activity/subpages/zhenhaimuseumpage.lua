local var0_0 = class("ZhenhaiMuseumPage", import(".TemplatePage.SkinTemplatePage"))
local var1_0 = 7
local var2_0

function var0_0.initSkin(arg0_1)
	arg0_1.showItemNum = arg0_1.activity.data3 < var1_0 and arg0_1.activity.data3 or var1_0
	arg0_1.skinTf = findTF(arg0_1._tf, "AD/skinPage")

	setActive(arg0_1.skinTf, false)

	arg0_1.descClose = findTF(arg0_1._tf, "AD/skinPage/descClose")

	setText(arg0_1.descClose, i18n("island_act_tips1"))

	arg0_1.skinIndex = 0

	arg0_1:pageUpdate()

	arg0_1.bottom = findTF(arg0_1.skinTf, "bottom")

	onButton(arg0_1, arg0_1.bottom, function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 0.5 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_1.playHandle then
			arg0_1.playHandle()

			arg0_1.playHandle = nil
		end

		arg0_1:displayWindow(false)
	end)
	onButton(arg0_1, findTF(arg0_1.skinTf, "left"), function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 0.5 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_1.skinIndex > 0 then
			local var0_3 = arg0_1.skinIndex

			arg0_1.skinIndex = arg0_1.skinIndex - 1

			arg0_1:updateSkinUI()
			setActive(findTF(arg0_1.skinTf, "skins/skin" .. var0_3), true)
			arg0_1:StartTimer(function()
				setActive(findTF(arg0_1.skinTf, "skins/skin" .. var0_3), false)
			end)
			findTF(arg0_1.skinTf, "skins/skin" .. var0_3):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_left")
		end
	end)
	onButton(arg0_1, findTF(arg0_1.skinTf, "right"), function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 0.5 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_1.skinIndex < arg0_1.showItemNum then
			local var0_5 = arg0_1.skinIndex

			arg0_1.skinIndex = arg0_1.skinIndex + 1

			arg0_1:updateSkinUI()
			setActive(findTF(arg0_1.skinTf, "skins/skin" .. var0_5), true)
			arg0_1:StartTimer(function()
				setActive(findTF(arg0_1.skinTf, "skins/skin" .. var0_5), false)
			end)
			findTF(arg0_1.skinTf, "skins/skin" .. arg0_1.skinIndex):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_right")
		end
	end)

	for iter0_1 = 0, var1_0 do
		onButton(arg0_1, findTF(arg0_1.skinTf, "page/" .. iter0_1), function()
			if var2_0 and Time.realtimeSinceStartup - var2_0 < 0.5 then
				return
			end

			var2_0 = Time.realtimeSinceStartup

			if arg0_1.skinIndex ~= iter0_1 then
				local var0_7 = arg0_1.skinIndex

				if arg0_1.skinIndex < iter0_1 then
					arg0_1.skinIndex = arg0_1.skinIndex + 1

					arg0_1:updateSkinUI()
					setActive(findTF(arg0_1.skinTf, "skins/skin" .. var0_7), true)
					arg0_1:StartTimer(function()
						setActive(findTF(arg0_1.skinTf, "skins/skin" .. var0_7), false)
					end)
					findTF(arg0_1.skinTf, "skins/skin" .. arg0_1.skinIndex):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_right")
				else
					arg0_1.skinIndex = arg0_1.skinIndex - 1

					arg0_1:updateSkinUI()
					setActive(findTF(arg0_1.skinTf, "skins/skin" .. var0_7), true)
					arg0_1:StartTimer(function()
						setActive(findTF(arg0_1.skinTf, "skins/skin" .. var0_7), false)
					end)
					findTF(arg0_1.skinTf, "skins/skin" .. var0_7):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_left")
				end
			end
		end)
		setActive(findTF(arg0_1.skinTf, "page/" .. iter0_1), iter0_1 <= arg0_1.showItemNum)
	end

	setActive(arg0_1.skinTf, false)
end

function var0_0.UpdateTask(arg0_10, arg1_10, arg2_10)
	var0_0.super.UpdateTask(arg0_10, arg1_10, arg2_10)

	local var0_10 = arg1_10 + 1
	local var1_10 = arg0_10.taskGroup[arg0_10.nday][var0_10]
	local var2_10 = arg0_10.taskProxy:getTaskById(var1_10) or arg0_10.taskProxy:getFinishTaskById(var1_10)
	local var3_10 = arg0_10:findTF("get_btn", arg2_10)

	onButton(arg0_10, var3_10, function()
		if arg0_10.nday <= var1_0 then
			arg0_10.skinIndex = arg0_10.nday

			function arg0_10.playHandle()
				arg0_10:emit(ActivityMediator.ON_TASK_SUBMIT, var2_10)
			end

			arg0_10:displayWindow(true)
		else
			arg0_10:emit(ActivityMediator.ON_TASK_SUBMIT, var2_10)
		end
	end, SFX_PANEL)

	local var4_10 = arg0_10:findTF("got_btn", arg2_10)

	onButton(arg0_10, var4_10, function()
		arg0_10:displayWindow(true)
	end, SFX_PANEL)

	local var5_10 = arg0_10:findTF("review_btn", arg0_10.bg)

	onButton(arg0_10, var5_10, function()
		arg0_10:displayWindow(true)
	end, SFX_PANEL)
end

function var0_0.pageUpdate(arg0_15)
	for iter0_15 = 0, var1_0 do
		setActive(findTF(arg0_15.skinTf, "page/" .. iter0_15), iter0_15 <= arg0_15.showItemNum)
		setActive(findTF(arg0_15.skinTf, "page/" .. iter0_15 .. "/selected"), arg0_15.skinIndex == iter0_15)
		setActive(findTF(arg0_15.skinTf, "skins/skin" .. iter0_15), arg0_15.skinIndex == iter0_15)

		findTF(arg0_15.skinTf, "skins/skin" .. iter0_15):GetComponent(typeof(Image)).fillAmount = 1
	end
end

function var0_0.OnFirstFlush(arg0_16)
	var0_0.super.OnFirstFlush(arg0_16)

	arg0_16.skinIndex = arg0_16.activity.data3 > var1_0 and 0 or arg0_16.activity.data3

	arg0_16:initSkin()
end

function var0_0.OnUpdateFlush(arg0_17)
	arg0_17.nday = arg0_17.activity.data3

	local var0_17 = arg0_17.activity:getConfig("config_client").story

	if checkExist(var0_17, {
		1
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0_17[1][1])
	end

	arg0_17.uilist:align(#arg0_17.taskGroup[arg0_17.nday])
end

function var0_0.updateSkinUI(arg0_18)
	if arg0_18.playHandle then
		setActive(findTF(arg0_18.skinTf, "left"), false)
		setActive(findTF(arg0_18.skinTf, "right"), false)
		setActive(findTF(arg0_18.skinTf, "page"), false)
	else
		setActive(findTF(arg0_18.skinTf, "left"), arg0_18.skinIndex > 0)
		setActive(findTF(arg0_18.skinTf, "right"), arg0_18.skinIndex < arg0_18.showItemNum)
		setActive(findTF(arg0_18.skinTf, "page"), true)
	end

	arg0_18:pageUpdate()
end

function var0_0.displayWindow(arg0_19, arg1_19)
	if arg0_19.blurFlag == arg1_19 then
		return
	end

	if arg1_19 then
		setActive(arg0_19.skinTf, true)
		arg0_19.skinTf:GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_in")
		pg.UIMgr.GetInstance():BlurPanel(arg0_19.skinTf, true)

		local var0_19 = arg0_19.taskGroup[arg0_19.nday][1]
		local var1_19 = (arg0_19.taskProxy:getTaskById(var0_19) or arg0_19.taskProxy:getFinishTaskById(var0_19)):getTaskStatus()

		arg0_19.showItemNum = arg0_19.activity.data3 < var1_0 and arg0_19.activity.data3 or var1_0

		if var1_19 ~= 2 then
			arg0_19.showItemNum = arg0_19.showItemNum - 1
		end

		arg0_19:updateSkinUI()

		if arg0_19.playHandle then
			local var2_19 = arg0_19.nday - 1

			setActive(findTF(arg0_19.skinTf, "skins/skin" .. var2_19), true)
			arg0_19:StartTimer(function()
				setActive(findTF(arg0_19.skinTf, "skins/skin" .. var2_19), false)
			end)
			findTF(arg0_19.skinTf, "skins/skin" .. arg0_19.skinIndex):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_right")
		end
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_19.skinTf)
		arg0_19.skinTf:GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_out")
		arg0_19:StartTimer(function()
			setActive(arg0_19.skinTf, false)
		end)
	end

	arg0_19.blurFlag = arg1_19
end

function var0_0.StartTimer(arg0_22, arg1_22)
	arg0_22:RemoveTimer()

	arg0_22.timer = Timer.New(arg1_22, 0.5, 1)

	arg0_22.timer:Start()
end

function var0_0.RemoveTimer(arg0_23)
	if arg0_23.timer then
		arg0_23.timer:Stop()

		arg0_23.timer = nil
	end
end

function var0_0.OnDestroy(arg0_24)
	var0_0.super.OnDestroy(arg0_24)
	arg0_24:displayWindow(false)
	arg0_24:RemoveTimer()
end

function var0_0.GetProgressColor(arg0_25)
	return "#435271", "#5D7B97"
end

return var0_0
