local var0 = class("ZhenhaiMuseumPage", import(".TemplatePage.SkinTemplatePage"))
local var1 = 7
local var2

function var0.initSkin(arg0)
	arg0.showItemNum = arg0.activity.data3 < var1 and arg0.activity.data3 or var1
	arg0.skinTf = findTF(arg0._tf, "AD/skinPage")

	setActive(arg0.skinTf, false)

	arg0.descClose = findTF(arg0._tf, "AD/skinPage/descClose")

	setText(arg0.descClose, i18n("island_act_tips1"))

	arg0.skinIndex = 0

	arg0:pageUpdate()

	arg0.bottom = findTF(arg0.skinTf, "bottom")

	onButton(arg0, arg0.bottom, function()
		if var2 and Time.realtimeSinceStartup - var2 < 0.5 then
			return
		end

		var2 = Time.realtimeSinceStartup

		if arg0.playHandle then
			arg0.playHandle()

			arg0.playHandle = nil
		end

		arg0:displayWindow(false)
	end)
	onButton(arg0, findTF(arg0.skinTf, "left"), function()
		if var2 and Time.realtimeSinceStartup - var2 < 0.5 then
			return
		end

		var2 = Time.realtimeSinceStartup

		if arg0.skinIndex > 0 then
			local var0 = arg0.skinIndex

			arg0.skinIndex = arg0.skinIndex - 1

			arg0:updateSkinUI()
			setActive(findTF(arg0.skinTf, "skins/skin" .. var0), true)
			arg0:StartTimer(function()
				setActive(findTF(arg0.skinTf, "skins/skin" .. var0), false)
			end)
			findTF(arg0.skinTf, "skins/skin" .. var0):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_left")
		end
	end)
	onButton(arg0, findTF(arg0.skinTf, "right"), function()
		if var2 and Time.realtimeSinceStartup - var2 < 0.5 then
			return
		end

		var2 = Time.realtimeSinceStartup

		if arg0.skinIndex < arg0.showItemNum then
			local var0 = arg0.skinIndex

			arg0.skinIndex = arg0.skinIndex + 1

			arg0:updateSkinUI()
			setActive(findTF(arg0.skinTf, "skins/skin" .. var0), true)
			arg0:StartTimer(function()
				setActive(findTF(arg0.skinTf, "skins/skin" .. var0), false)
			end)
			findTF(arg0.skinTf, "skins/skin" .. arg0.skinIndex):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_right")
		end
	end)

	for iter0 = 0, var1 do
		onButton(arg0, findTF(arg0.skinTf, "page/" .. iter0), function()
			if var2 and Time.realtimeSinceStartup - var2 < 0.5 then
				return
			end

			var2 = Time.realtimeSinceStartup

			if arg0.skinIndex ~= iter0 then
				local var0 = arg0.skinIndex

				if arg0.skinIndex < iter0 then
					arg0.skinIndex = arg0.skinIndex + 1

					arg0:updateSkinUI()
					setActive(findTF(arg0.skinTf, "skins/skin" .. var0), true)
					arg0:StartTimer(function()
						setActive(findTF(arg0.skinTf, "skins/skin" .. var0), false)
					end)
					findTF(arg0.skinTf, "skins/skin" .. arg0.skinIndex):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_right")
				else
					arg0.skinIndex = arg0.skinIndex - 1

					arg0:updateSkinUI()
					setActive(findTF(arg0.skinTf, "skins/skin" .. var0), true)
					arg0:StartTimer(function()
						setActive(findTF(arg0.skinTf, "skins/skin" .. var0), false)
					end)
					findTF(arg0.skinTf, "skins/skin" .. var0):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_left")
				end
			end
		end)
		setActive(findTF(arg0.skinTf, "page/" .. iter0), iter0 <= arg0.showItemNum)
	end

	setActive(arg0.skinTf, false)
end

function var0.UpdateTask(arg0, arg1, arg2)
	var0.super.UpdateTask(arg0, arg1, arg2)

	local var0 = arg1 + 1
	local var1 = arg0.taskGroup[arg0.nday][var0]
	local var2 = arg0.taskProxy:getTaskById(var1) or arg0.taskProxy:getFinishTaskById(var1)
	local var3 = arg0:findTF("get_btn", arg2)

	onButton(arg0, var3, function()
		if arg0.nday <= var1 then
			arg0.skinIndex = arg0.nday

			function arg0.playHandle()
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var2)
			end

			arg0:displayWindow(true)
		else
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var2)
		end
	end, SFX_PANEL)

	local var4 = arg0:findTF("got_btn", arg2)

	onButton(arg0, var4, function()
		arg0:displayWindow(true)
	end, SFX_PANEL)

	local var5 = arg0:findTF("review_btn", arg0.bg)

	onButton(arg0, var5, function()
		arg0:displayWindow(true)
	end, SFX_PANEL)
end

function var0.pageUpdate(arg0)
	for iter0 = 0, var1 do
		setActive(findTF(arg0.skinTf, "page/" .. iter0), iter0 <= arg0.showItemNum)
		setActive(findTF(arg0.skinTf, "page/" .. iter0 .. "/selected"), arg0.skinIndex == iter0)
		setActive(findTF(arg0.skinTf, "skins/skin" .. iter0), arg0.skinIndex == iter0)

		findTF(arg0.skinTf, "skins/skin" .. iter0):GetComponent(typeof(Image)).fillAmount = 1
	end
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	arg0.skinIndex = arg0.activity.data3 > var1 and 0 or arg0.activity.data3

	arg0:initSkin()
end

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data3

	local var0 = arg0.activity:getConfig("config_client").story

	if checkExist(var0, {
		1
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0[1][1])
	end

	arg0.uilist:align(#arg0.taskGroup[arg0.nday])
end

function var0.updateSkinUI(arg0)
	if arg0.playHandle then
		setActive(findTF(arg0.skinTf, "left"), false)
		setActive(findTF(arg0.skinTf, "right"), false)
		setActive(findTF(arg0.skinTf, "page"), false)
	else
		setActive(findTF(arg0.skinTf, "left"), arg0.skinIndex > 0)
		setActive(findTF(arg0.skinTf, "right"), arg0.skinIndex < arg0.showItemNum)
		setActive(findTF(arg0.skinTf, "page"), true)
	end

	arg0:pageUpdate()
end

function var0.displayWindow(arg0, arg1)
	if arg0.blurFlag == arg1 then
		return
	end

	if arg1 then
		setActive(arg0.skinTf, true)
		arg0.skinTf:GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_in")
		pg.UIMgr.GetInstance():BlurPanel(arg0.skinTf, true)

		local var0 = arg0.taskGroup[arg0.nday][1]
		local var1 = (arg0.taskProxy:getTaskById(var0) or arg0.taskProxy:getFinishTaskById(var0)):getTaskStatus()

		arg0.showItemNum = arg0.activity.data3 < var1 and arg0.activity.data3 or var1

		if var1 ~= 2 then
			arg0.showItemNum = arg0.showItemNum - 1
		end

		arg0:updateSkinUI()

		if arg0.playHandle then
			local var2 = arg0.nday - 1

			setActive(findTF(arg0.skinTf, "skins/skin" .. var2), true)
			arg0:StartTimer(function()
				setActive(findTF(arg0.skinTf, "skins/skin" .. var2), false)
			end)
			findTF(arg0.skinTf, "skins/skin" .. arg0.skinIndex):GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_skin_right")
		end
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0.skinTf)
		arg0.skinTf:GetComponent(typeof(Animation)):Play("anim_zhenhaimuseum_out")
		arg0:StartTimer(function()
			setActive(arg0.skinTf, false)
		end)
	end

	arg0.blurFlag = arg1
end

function var0.StartTimer(arg0, arg1)
	arg0:RemoveTimer()

	arg0.timer = Timer.New(arg1, 0.5, 1)

	arg0.timer:Start()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)
	arg0:displayWindow(false)
	arg0:RemoveTimer()
end

function var0.GetProgressColor(arg0)
	return "#435271", "#5D7B97"
end

return var0
