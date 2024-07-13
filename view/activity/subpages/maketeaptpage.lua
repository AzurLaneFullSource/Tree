local var0_0 = class("MakeTeaPtPage", import(".TemplatePage.SkinTemplatePage"))
local var1_0 = 5
local var2_0 = {
	"caizhai",
	"tanfang",
	"shaqing",
	"huichao",
	"huiguo",
	"yincha"
}
local var3_0 = "ui/activityuipage/maketeaptpage_atlas"
local var4_0

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
end

function var0_0.initMv(arg0_2)
	arg0_2.showItemNum = arg0_2.activity.data3 < var1_0 and arg0_2.activity.data3 or var1_0
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
		if var4_0 and Time.realtimeSinceStartup - var4_0 < 1 then
			return
		end

		var4_0 = Time.realtimeSinceStartup

		if arg0_2.mvManaCpkUI and not arg0_2.mvCompleteFlag then
			print("恢复播放")
			arg0_2.mvManaCpkUI:Pause(false)
			arg0_2:onPlayerStart()
		end
	end)
	onButton(arg0_2, arg0_2.btnStop, function()
		if var4_0 and Time.realtimeSinceStartup - var4_0 < 1 then
			return
		end

		var4_0 = Time.realtimeSinceStartup

		if arg0_2.mvManaCpkUI and not arg0_2.mvCompleteFlag then
			print("暂停播放")
			arg0_2.mvManaCpkUI:Pause(true)
			arg0_2:onPlayerStop()
		end
	end)
	onButton(arg0_2, arg0_2.btnRepeat, function()
		if var4_0 and Time.realtimeSinceStartup - var4_0 < 1 then
			return
		end

		var4_0 = Time.realtimeSinceStartup

		if arg0_2.mvManaCpkUI and arg0_2.mvCompleteFlag then
			print("重新播放")
			arg0_2:loadMv()
		end
	end)
	onButton(arg0_2, arg0_2.mvBottom, function()
		if var4_0 and Time.realtimeSinceStartup - var4_0 < 1 then
			return
		end

		var4_0 = Time.realtimeSinceStartup

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
		if var4_0 and Time.realtimeSinceStartup - var4_0 < 1 then
			return
		end

		var4_0 = Time.realtimeSinceStartup

		if arg0_2.mvIndex > 1 and not arg0_2.isLoading then
			arg0_2.mvIndex = arg0_2.mvIndex - 1

			arg0_2:pageChange()
		end
	end)
	onButton(arg0_2, findTF(arg0_2.mvTf, "right"), function()
		if var4_0 and Time.realtimeSinceStartup - var4_0 < 1 then
			return
		end

		var4_0 = Time.realtimeSinceStartup

		if arg0_2.mvIndex < arg0_2.showItemNum and not arg0_2.isLoading then
			arg0_2.mvIndex = arg0_2.mvIndex + 1

			arg0_2:pageChange()
		end
	end)

	for iter0_2 = 1, var1_0 do
		local var0_2 = iter0_2

		onButton(arg0_2, findTF(arg0_2.mvTf, "page/" .. iter0_2), function()
			if var4_0 and Time.realtimeSinceStartup - var4_0 < 1 then
				return
			end

			var4_0 = Time.realtimeSinceStartup

			if arg0_2.nday < 6 then
				return
			end

			if arg0_2.mvIndex ~= var0_2 and not arg0_2.isLoading then
				arg0_2.mvIndex = var0_2

				arg0_2:pageChange()
			end
		end)
		setActive(findTF(arg0_2.mvTf, "page/" .. iter0_2), iter0_2 <= arg0_2.showItemNum)
	end

	setActive(arg0_2.mvTf, false)
end

function var0_0.UpdateTask(arg0_10, arg1_10, arg2_10)
	var0_0.super.UpdateTask(arg0_10, arg1_10, arg2_10)

	local var0_10 = arg0_10:findTF("get_btn", arg2_10)
	local var1_10 = arg1_10 + 1
	local var2_10 = arg0_10.taskGroup[arg0_10.nday][var1_10]
	local var3_10 = arg0_10.taskProxy:getTaskById(var2_10) or arg0_10.taskProxy:getFinishTaskById(var2_10)

	onButton(arg0_10, var0_10, function()
		if arg0_10.nday <= var1_0 then
			arg0_10.mvIndex = arg0_10.nday

			function arg0_10.playHandle()
				arg0_10:emit(ActivityMediator.ON_TASK_SUBMIT, var3_10)
			end

			arg0_10:displayWindow(true)
		else
			local var0_11 = arg0_10.activity:getConfig("config_client").story

			if checkExist(var0_11, {
				arg0_10.nday
			}, {
				1
			}) then
				pg.NewStoryMgr.GetInstance():Play(var0_11[arg0_10.nday][1], function()
					arg0_10:emit(ActivityMediator.ON_TASK_SUBMIT, var3_10)
				end)
			else
				arg0_10:emit(ActivityMediator.ON_TASK_SUBMIT, var3_10)
			end
		end
	end, SFX_PANEL)

	local var4_10 = arg0_10:findTF("got_btn", arg2_10)

	onButton(arg0_10, var4_10, function()
		arg0_10:displayWindow(true)
	end, SFX_PANEL)
end

function var0_0.pageChange(arg0_15)
	arg0_15:pageUpdate()
	arg0_15:loadMv()
end

function var0_0.pageUpdate(arg0_16)
	for iter0_16 = 1, var1_0 do
		setActive(findTF(arg0_16.mvTf, "page/" .. iter0_16 .. "/selected"), arg0_16.mvIndex == iter0_16)
	end

	for iter1_16 = 1, #var2_0 do
		setActive(findTF(arg0_16.mvTf, "title_word/" .. iter1_16), iter1_16 == arg0_16.mvIndex)
	end
end

function var0_0.OnFirstFlush(arg0_17)
	var0_0.super.OnFirstFlush(arg0_17)

	arg0_17.mvIndex = arg0_17.activity.data3 > var1_0 and 1 or arg0_17.activity.data3

	arg0_17:initMv()
end

function var0_0.OnUpdateFlush(arg0_18)
	arg0_18.nday = arg0_18.activity.data3

	if arg0_18.dayTF then
		setText(arg0_18.dayTF, tostring(arg0_18.nday))
	end

	arg0_18.uilist:align(#arg0_18.taskGroup[arg0_18.nday])

	for iter0_18 = 1, #var2_0 do
		setActive(findTF(arg0_18._tf, "AD/word/" .. iter0_18), iter0_18 == arg0_18.nday)
	end
end

function var0_0.updateMvUI(arg0_19)
	arg0_19.showItemNum = arg0_19.activity.data3 < var1_0 and arg0_19.activity.data3 or var1_0

	if arg0_19.playHandle then
		setActive(findTF(arg0_19.mvTf, "left"), false)
		setActive(findTF(arg0_19.mvTf, "right"), false)
	else
		setActive(findTF(arg0_19.mvTf, "left"), arg0_19.showItemNum > 1)
		setActive(findTF(arg0_19.mvTf, "right"), arg0_19.showItemNum > 1)
	end

	for iter0_19 = 1, var1_0 do
		setActive(findTF(arg0_19.mvTf, "page/" .. iter0_19 .. "/selected"), arg0_19.mvIndex == iter0_19)
		setActive(findTF(arg0_19.mvTf, "page/" .. iter0_19), iter0_19 <= arg0_19.showItemNum)
		setActive(findTF(arg0_19.mvTf, "title_word/" .. iter0_19), iter0_19 == arg0_19.mvIndex)
	end
end

function var0_0.displayWindow(arg0_20, arg1_20)
	if not arg1_20 and not arg0_20.blurFlag then
		return
	end

	if arg0_20.isLoading then
		return
	end

	if arg0_20.blurFlag == arg1_20 then
		return
	end

	if arg1_20 then
		setActive(arg0_20.mvTf, true)

		local var0_20 = Screen.width
		local var1_20 = Screen.height

		setSizeDelta(findTF(arg0_20.mvTf, "bottom"), Vector2(Screen.width, Screen.height))
		pg.UIMgr.GetInstance():BlurPanel(arg0_20.mvTf, true)
		arg0_20:updateMvUI()
		arg0_20:loadMv()
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_20.mvTf)
		setActive(arg0_20.mvTf, false)
	end

	arg0_20.blurFlag = arg1_20
end

function var0_0.OnDestroy(arg0_21)
	var0_0.super.OnDestroy(arg0_21)

	arg0_21.isLoading = false

	arg0_21:displayWindow(false)
	arg0_21:clearMovie()
end

function var0_0.clearMovie(arg0_22)
	if arg0_22.mvGo then
		arg0_22.mvManaCpkUI:SetPlayEndHandler(nil)
		arg0_22.mvManaCpkUI:StopCpk()
		destroy(arg0_22.mvGo)

		arg0_22.mvManaCpkUI = nil
		arg0_22.mvGo = nil
		arg0_22.mvName = nil
	end
end

function var0_0.GetProgressColor(arg0_23)
	return "#57896D", "#A1AAA1"
end

function var0_0.loadMv(arg0_24)
	arg0_24:clearMovie()

	if arg0_24.isLoading then
		return
	end

	local var0_24 = "paocha" .. arg0_24.mvIndex

	arg0_24.isLoading = true

	PoolMgr.GetInstance():GetUI(var0_24, true, function(arg0_25)
		arg0_24.mvGo = arg0_25
		arg0_24.mvName = var0_24
		arg0_24.mvManaCpkUI = GetComponent(findTF(arg0_24.mvGo, "video/cpk"), typeof(CriManaCpkUI))

		arg0_24.mvManaCpkUI:SetPlayEndHandler(System.Action(function()
			arg0_24:mvComplete()

			if arg0_24.playHandle then
				arg0_24.playHandle()

				arg0_24.playHandle = nil
			end
		end))
		setActive(arg0_24.btnPlay, false)
		setActive(arg0_24.btnStop, true)
		setActive(arg0_24.btnRepeat, false)
		setText(arg0_24.movieWord, i18n("mktea_" .. arg0_24.mvIndex))

		if arg0_24.isLoading == false then
			arg0_24:clearMovie()
		else
			arg0_24.isLoading = false

			setParent(arg0_24.mvGo, arg0_24.mvContent)
			setActive(arg0_24.mvGo, true)
		end

		arg0_24.mvCompleteFlag = false

		arg0_24.mvManaCpkUI:PlayCpk()
	end)
end

function var0_0.mvComplete(arg0_27)
	print("播放完成")

	arg0_27.mvCompleteFlag = true

	arg0_27:onPlayerEnd()

	if arg0_27.mvIndex == arg0_27.nday then
		-- block empty
	end
end

function var0_0.onPlayerEnd(arg0_28)
	setActive(arg0_28.btnPlay, false)
	setActive(arg0_28.btnStop, false)
	setActive(arg0_28.btnRepeat, true)
end

function var0_0.onPlayerStop(arg0_29)
	setActive(arg0_29.btnPlay, true)
	setActive(arg0_29.btnStop, false)
	setActive(arg0_29.btnRepeat, false)
end

function var0_0.onPlayerStart(arg0_30)
	setActive(arg0_30.btnPlay, false)
	setActive(arg0_30.btnStop, true)
	setActive(arg0_30.btnRepeat, false)
end

return var0_0
