local var0_0 = class("Mv1PtPage", import(".TemplatePage.SkinTemplatePage"))
local var1_0 = 3
local var2_0

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
end

function var0_0.initMv(arg0_2)
	arg0_2.showItemNum = var1_0
	arg0_2.mvTf = findTF(arg0_2._tf, "AD/mvPage")

	setActive(arg0_2.mvTf, false)

	arg0_2.mvContent = findTF(arg0_2._tf, "AD/mvPage/movie/view/content")
	arg0_2.movieWord = findTF(arg0_2._tf, "AD/mvPage/movie/movieWord")
	arg0_2.descClose = findTF(arg0_2._tf, "AD/mvPage/descClose")

	setText(arg0_2.descClose, i18n("island_act_tips1"))

	arg0_2.mvIndex = 1

	arg0_2:pageUpdate()

	arg0_2.mvBottom = findTF(arg0_2.mvTf, "bottom")
	arg0_2.btnPlay = findTF(arg0_2.mvTf, "movie/btnPlay")
	arg0_2.btnStop = findTF(arg0_2.mvTf, "movie/btnStop")
	arg0_2.btnRepeat = findTF(arg0_2.mvTf, "movie/btnRepeat")

	onButton(arg0_2, arg0_2.btnPlay, function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 1 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_2.mvManaCpkUI and not arg0_2.mvCompleteFlag then
			print("恢复播放")
			arg0_2.mvManaCpkUI:Pause(false)
			arg0_2:onPlayerStart()
		end
	end)
	onButton(arg0_2, arg0_2.btnStop, function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 1 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_2.mvManaCpkUI and not arg0_2.mvCompleteFlag then
			print("暂停播放")
			arg0_2.mvManaCpkUI:Pause(true)
			arg0_2:onPlayerStop()
		end
	end)
	onButton(arg0_2, arg0_2.btnRepeat, function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 1 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_2.mvManaCpkUI and arg0_2.mvCompleteFlag then
			print("重新播放")
			arg0_2:loadMv()
		end
	end)
	onButton(arg0_2, arg0_2.mvBottom, function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 1 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_2.isLoading then
			return
		end

		if arg0_2.playHandle then
			arg0_2.playHandle()

			arg0_2.playHandle = nil
		end

		arg0_2:displayWindow(false)
		arg0_2:clearMovie()
	end)
	onButton(arg0_2, findTF(arg0_2.mvTf, "left"), function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 1 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_2.mvIndex > 1 and not arg0_2.isLoading then
			arg0_2.mvIndex = arg0_2.mvIndex - 1

			arg0_2:pageChange()
		end
	end)
	onButton(arg0_2, findTF(arg0_2.mvTf, "right"), function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 1 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_2.mvIndex < arg0_2.showItemNum and not arg0_2.isLoading then
			arg0_2.mvIndex = arg0_2.mvIndex + 1

			arg0_2:pageChange()
		end
	end)
	onButton(arg0_2, findTF(arg0_2._tf, "AD/chapter"), function()
		arg0_2:displayWindow(true)
	end, SFX_PANEL)
	onButton(arg0_2, findTF(arg0_2._tf, "AD/left"), function()
		if arg0_2.mvIndex > 1 and not arg0_2.isLoading then
			arg0_2.mvIndex = arg0_2.mvIndex - 1

			arg0_2:pageUpdate()
		end
	end)
	onButton(arg0_2, findTF(arg0_2._tf, "AD/right"), function()
		if arg0_2.mvIndex < arg0_2.showItemNum and not arg0_2.isLoading then
			arg0_2.mvIndex = arg0_2.mvIndex + 1

			arg0_2:pageUpdate()
		end
	end)

	for iter0_2 = 1, var1_0 do
		local var0_2 = iter0_2

		onButton(arg0_2, findTF(arg0_2.mvTf, "page/" .. iter0_2), function()
			if var2_0 and Time.realtimeSinceStartup - var2_0 < 1 then
				return
			end

			var2_0 = Time.realtimeSinceStartup

			if arg0_2.nday < 6 then
				return
			end

			if arg0_2.mvIndex ~= var0_2 and not arg0_2.isLoading then
				arg0_2.mvIndex = var0_2

				arg0_2:pageUpdate()
			end
		end)
		setActive(findTF(arg0_2.mvTf, "page/" .. iter0_2), iter0_2 <= arg0_2.showItemNum)
	end

	setActive(arg0_2.mvTf, false)
end

function var0_0.UpdateTask(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg1_13 + 1
	local var1_13 = arg0_13:findTF("itemMask/item", arg2_13)
	local var2_13 = arg0_13.taskGroup[arg0_13.nday][var0_13]
	local var3_13 = arg0_13.taskProxy:getTaskById(var2_13) or arg0_13.taskProxy:getFinishTaskById(var2_13)

	assert(var3_13, "without this task by id: " .. var2_13)

	local var4_13 = var3_13:getConfig("award_display")[1]
	local var5_13 = {
		type = var4_13[1],
		id = var4_13[2],
		count = var4_13[3]
	}

	updateDrop(var1_13, var5_13)
	onButton(arg0_13, var1_13, function()
		arg0_13:emit(BaseUI.ON_DROP, var5_13)
	end, SFX_PANEL)

	local var6_13 = var3_13:getProgress()
	local var7_13 = var3_13:getConfig("target_num")

	setText(arg0_13:findTF("description", arg2_13), var3_13:getConfig("desc"))

	local var8_13, var9_13 = arg0_13:GetProgressColor()
	local var10_13

	var10_13 = var8_13 and setColorStr(var6_13, var8_13) or var6_13

	local var11_13

	var11_13 = var9_13 and setColorStr("/" .. var7_13, var9_13) or "/" .. var7_13

	setText(arg0_13:findTF("progressText", arg2_13), var10_13 .. var11_13)
	setSlider(arg0_13:findTF("progress", arg2_13), 0, var7_13, var6_13)

	local var12_13 = arg0_13:findTF("go_btn", arg2_13)
	local var13_13 = arg0_13:findTF("get_btn", arg2_13)
	local var14_13 = arg0_13:findTF("got_btn", arg2_13)
	local var15_13 = var3_13:getTaskStatus()

	setActive(var12_13, var15_13 == 0)
	setActive(var13_13, var15_13 == 1)
	setActive(var14_13, var15_13 == 2)
	onButton(arg0_13, var12_13, function()
		arg0_13:emit(ActivityMediator.ON_TASK_GO, var3_13)
	end, SFX_PANEL)
	onButton(arg0_13, var13_13, function()
		arg0_13:emit(ActivityMediator.ON_TASK_SUBMIT, var3_13)
	end, SFX_PANEL)

	local var16_13 = arg0_13:findTF("get_btn", arg2_13)
	local var17_13 = arg1_13 + 1
	local var18_13 = arg0_13.taskGroup[arg0_13.nday][var17_13]
	local var19_13 = arg0_13.taskProxy:getTaskById(var18_13) or arg0_13.taskProxy:getFinishTaskById(var18_13)

	onButton(arg0_13, var16_13, function()
		if arg0_13.nday <= var1_0 then
			arg0_13.mvIndex = arg0_13.nday

			arg0_13:emit(ActivityMediator.ON_TASK_SUBMIT, var19_13)
		else
			local var0_17 = arg0_13.activity:getConfig("config_client").story

			if checkExist(var0_17, {
				arg0_13.nday
			}, {
				1
			}) then
				pg.NewStoryMgr.GetInstance():Play(var0_17[arg0_13.nday][1], function()
					arg0_13:emit(ActivityMediator.ON_TASK_SUBMIT, var19_13)
				end)
			else
				arg0_13:emit(ActivityMediator.ON_TASK_SUBMIT, var19_13)
			end
		end
	end, SFX_PANEL)

	local var20_13 = arg0_13:findTF("got_btn", arg2_13)

	onButton(arg0_13, var20_13, function()
		arg0_13:displayWindow(true)
	end, SFX_PANEL)
end

function var0_0.pageChange(arg0_20)
	arg0_20:pageUpdate()
	arg0_20:loadMv()
end

function var0_0.pageUpdate(arg0_21)
	for iter0_21 = 1, var1_0 do
		setActive(findTF(arg0_21.mvTf, "page/" .. iter0_21 .. "/selected"), arg0_21.mvIndex == iter0_21)
	end

	for iter1_21 = 1, var1_0 do
		setActive(findTF(arg0_21._tf, "AD/page/" .. iter1_21 .. "/selected"), arg0_21.mvIndex == iter1_21)
	end

	for iter2_21 = 1, var1_0 do
		setActive(findTF(arg0_21._tf, "AD/chapter/" .. iter2_21), arg0_21.mvIndex == iter2_21)
	end

	setActive(findTF(arg0_21._tf, "AD/right"), arg0_21.mvIndex ~= arg0_21.showItemNum)
	setActive(findTF(arg0_21._tf, "AD/left"), arg0_21.mvIndex ~= 1)
end

function var0_0.OnFirstFlush(arg0_22)
	var0_0.super.OnFirstFlush(arg0_22)

	arg0_22.mvIndex = arg0_22.activity.data3 > var1_0 and 1 or arg0_22.activity.data3

	arg0_22:initMv()
end

function var0_0.OnUpdateFlush(arg0_23)
	arg0_23.nday = arg0_23.activity.data3

	if arg0_23.dayTF then
		setText(arg0_23.dayTF, tostring(arg0_23.nday))
	end

	arg0_23.uilist:align(#arg0_23.taskGroup[arg0_23.nday])
end

function var0_0.updateMvUI(arg0_24)
	arg0_24.showItemNum = var1_0

	if arg0_24.playHandle then
		setActive(findTF(arg0_24.mvTf, "left"), false)
		setActive(findTF(arg0_24.mvTf, "right"), false)
	else
		setActive(findTF(arg0_24.mvTf, "left"), arg0_24.showItemNum > 1)
		setActive(findTF(arg0_24.mvTf, "right"), arg0_24.showItemNum > 1)
	end

	for iter0_24 = 1, var1_0 do
		setActive(findTF(arg0_24.mvTf, "page/" .. iter0_24 .. "/selected"), arg0_24.mvIndex == iter0_24)
		setActive(findTF(arg0_24.mvTf, "page/" .. iter0_24), iter0_24 <= arg0_24.showItemNum)
	end
end

function var0_0.displayWindow(arg0_25, arg1_25)
	if not arg1_25 and not arg0_25.blurFlag then
		return
	end

	if arg0_25.isLoading then
		return
	end

	if arg0_25.blurFlag == arg1_25 then
		return
	end

	if arg1_25 then
		setActive(arg0_25.mvTf, true)

		local var0_25 = Screen.width
		local var1_25 = Screen.height

		setSizeDelta(findTF(arg0_25.mvTf, "bottom"), Vector2(Screen.width, Screen.height))
		pg.UIMgr.GetInstance():BlurPanel(arg0_25.mvTf, true)
		arg0_25:updateMvUI()
		arg0_25:loadMv()
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_25.mvTf)
		setActive(arg0_25.mvTf, false)
	end

	arg0_25.blurFlag = arg1_25
end

function var0_0.OnDestroy(arg0_26)
	var0_0.super.OnDestroy(arg0_26)

	arg0_26.isLoading = false

	arg0_26:displayWindow(false)
	arg0_26:clearMovie()
end

function var0_0.clearMovie(arg0_27)
	if arg0_27.mvGo then
		arg0_27.mvManaCpkUI:SetPlayEndHandler(nil)
		arg0_27.mvManaCpkUI:StopCpk()
		destroy(arg0_27.mvGo)

		arg0_27.mvManaCpkUI = nil
		arg0_27.mvGo = nil
		arg0_27.mvName = nil
	end
end

function var0_0.GetProgressColor(arg0_28)
	return "#FF6868", "#604D49"
end

function var0_0.loadMv(arg0_29)
	arg0_29:clearMovie()

	if arg0_29.isLoading then
		return
	end

	local var0_29 = "psplive_" .. arg0_29.mvIndex

	arg0_29.isLoading = true

	PoolMgr.GetInstance():GetUI(var0_29, true, function(arg0_30)
		arg0_29.mvGo = arg0_30
		arg0_29.mvName = var0_29
		arg0_29.mvManaCpkUI = GetComponent(findTF(arg0_29.mvGo, "video/cpk"), typeof(CriManaCpkUI))

		arg0_29.mvManaCpkUI:SetPlayEndHandler(System.Action(function()
			arg0_29:mvComplete()

			if arg0_29.playHandle then
				arg0_29.playHandle()

				arg0_29.playHandle = nil
			end
		end))
		setActive(arg0_29.btnPlay, false)
		setActive(arg0_29.btnStop, true)
		setActive(arg0_29.btnRepeat, false)

		if arg0_29.isLoading == false then
			arg0_29:clearMovie()
		else
			arg0_29.isLoading = false

			setParent(arg0_29.mvGo, arg0_29.mvContent)
			setActive(arg0_29.mvGo, true)
		end

		arg0_29.mvCompleteFlag = false

		arg0_29.mvManaCpkUI:PlayCpk()
	end)
end

function var0_0.mvComplete(arg0_32)
	print("播放完成")

	arg0_32.mvCompleteFlag = true

	arg0_32:onPlayerEnd()

	if arg0_32.mvIndex == arg0_32.nday then
		-- block empty
	end
end

function var0_0.onPlayerEnd(arg0_33)
	setActive(arg0_33.btnPlay, false)
	setActive(arg0_33.btnStop, false)
	setActive(arg0_33.btnRepeat, true)
end

function var0_0.onPlayerStop(arg0_34)
	setActive(arg0_34.btnPlay, true)
	setActive(arg0_34.btnStop, false)
	setActive(arg0_34.btnRepeat, false)
end

function var0_0.onPlayerStart(arg0_35)
	setActive(arg0_35.btnPlay, false)
	setActive(arg0_35.btnStop, true)
	setActive(arg0_35.btnRepeat, false)
end

return var0_0
