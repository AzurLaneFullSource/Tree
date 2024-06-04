local var0 = class("MakeTeaPtPage", import(".TemplatePage.SkinTemplatePage"))
local var1 = 5
local var2 = {
	"caizhai",
	"tanfang",
	"shaqing",
	"huichao",
	"huiguo",
	"yincha"
}
local var3 = "ui/activityuipage/maketeaptpage_atlas"
local var4

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
end

function var0.initMv(arg0)
	arg0.showItemNum = arg0.activity.data3 < var1 and arg0.activity.data3 or var1
	arg0.mvTf = findTF(arg0._tf, "AD/mvPage")

	setActive(arg0.mvTf, false)

	arg0.mvContent = findTF(arg0._tf, "AD/mvPage/movie/view/content")
	arg0.movieWord = findTF(arg0._tf, "AD/mvPage/movie/movieWord")
	arg0.descClose = findTF(arg0._tf, "AD/mvPage/descClose")

	setText(arg0.descClose, i18n("island_act_tips1"))

	arg0.mvIndex = 1

	arg0:pageUpdate()

	arg0.mvBottom = findTF(arg0.mvTf, "bottom")
	arg0.btnPlay = findTF(arg0.mvTf, "movie/btnPlay")
	arg0.btnStop = findTF(arg0.mvTf, "movie/btnStop")
	arg0.btnRepeat = findTF(arg0.mvTf, "movie/btnRepeat")

	onButton(arg0, arg0.btnPlay, function()
		if var4 and Time.realtimeSinceStartup - var4 < 1 then
			return
		end

		var4 = Time.realtimeSinceStartup

		if arg0.mvManaCpkUI and not arg0.mvCompleteFlag then
			print("恢复播放")
			arg0.mvManaCpkUI:Pause(false)
			arg0:onPlayerStart()
		end
	end)
	onButton(arg0, arg0.btnStop, function()
		if var4 and Time.realtimeSinceStartup - var4 < 1 then
			return
		end

		var4 = Time.realtimeSinceStartup

		if arg0.mvManaCpkUI and not arg0.mvCompleteFlag then
			print("暂停播放")
			arg0.mvManaCpkUI:Pause(true)
			arg0:onPlayerStop()
		end
	end)
	onButton(arg0, arg0.btnRepeat, function()
		if var4 and Time.realtimeSinceStartup - var4 < 1 then
			return
		end

		var4 = Time.realtimeSinceStartup

		if arg0.mvManaCpkUI and arg0.mvCompleteFlag then
			print("重新播放")
			arg0:loadMv()
		end
	end)
	onButton(arg0, arg0.mvBottom, function()
		if var4 and Time.realtimeSinceStartup - var4 < 1 then
			return
		end

		var4 = Time.realtimeSinceStartup

		if arg0.isLoading then
			return
		end

		if arg0.playHandle then
			arg0.playHandle()

			arg0.playHandle = nil
		end

		arg0:displayWindow(false)
		arg0:clearMovie()
	end)
	onButton(arg0, findTF(arg0.mvTf, "left"), function()
		if var4 and Time.realtimeSinceStartup - var4 < 1 then
			return
		end

		var4 = Time.realtimeSinceStartup

		if arg0.mvIndex > 1 and not arg0.isLoading then
			arg0.mvIndex = arg0.mvIndex - 1

			arg0:pageChange()
		end
	end)
	onButton(arg0, findTF(arg0.mvTf, "right"), function()
		if var4 and Time.realtimeSinceStartup - var4 < 1 then
			return
		end

		var4 = Time.realtimeSinceStartup

		if arg0.mvIndex < arg0.showItemNum and not arg0.isLoading then
			arg0.mvIndex = arg0.mvIndex + 1

			arg0:pageChange()
		end
	end)

	for iter0 = 1, var1 do
		local var0 = iter0

		onButton(arg0, findTF(arg0.mvTf, "page/" .. iter0), function()
			if var4 and Time.realtimeSinceStartup - var4 < 1 then
				return
			end

			var4 = Time.realtimeSinceStartup

			if arg0.nday < 6 then
				return
			end

			if arg0.mvIndex ~= var0 and not arg0.isLoading then
				arg0.mvIndex = var0

				arg0:pageChange()
			end
		end)
		setActive(findTF(arg0.mvTf, "page/" .. iter0), iter0 <= arg0.showItemNum)
	end

	setActive(arg0.mvTf, false)
end

function var0.UpdateTask(arg0, arg1, arg2)
	var0.super.UpdateTask(arg0, arg1, arg2)

	local var0 = arg0:findTF("get_btn", arg2)
	local var1 = arg1 + 1
	local var2 = arg0.taskGroup[arg0.nday][var1]
	local var3 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)

	onButton(arg0, var0, function()
		if arg0.nday <= var1 then
			arg0.mvIndex = arg0.nday

			function arg0.playHandle()
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var3)
			end

			arg0:displayWindow(true)
		else
			local var0 = arg0.activity:getConfig("config_client").story

			if checkExist(var0, {
				arg0.nday
			}, {
				1
			}) then
				pg.NewStoryMgr.GetInstance():Play(var0[arg0.nday][1], function()
					arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var3)
				end)
			else
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var3)
			end
		end
	end, SFX_PANEL)

	local var4 = arg0:findTF("got_btn", arg2)

	onButton(arg0, var4, function()
		arg0:displayWindow(true)
	end, SFX_PANEL)
end

function var0.pageChange(arg0)
	arg0:pageUpdate()
	arg0:loadMv()
end

function var0.pageUpdate(arg0)
	for iter0 = 1, var1 do
		setActive(findTF(arg0.mvTf, "page/" .. iter0 .. "/selected"), arg0.mvIndex == iter0)
	end

	for iter1 = 1, #var2 do
		setActive(findTF(arg0.mvTf, "title_word/" .. iter1), iter1 == arg0.mvIndex)
	end
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	arg0.mvIndex = arg0.activity.data3 > var1 and 1 or arg0.activity.data3

	arg0:initMv()
end

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data3

	if arg0.dayTF then
		setText(arg0.dayTF, tostring(arg0.nday))
	end

	arg0.uilist:align(#arg0.taskGroup[arg0.nday])

	for iter0 = 1, #var2 do
		setActive(findTF(arg0._tf, "AD/word/" .. iter0), iter0 == arg0.nday)
	end
end

function var0.updateMvUI(arg0)
	arg0.showItemNum = arg0.activity.data3 < var1 and arg0.activity.data3 or var1

	if arg0.playHandle then
		setActive(findTF(arg0.mvTf, "left"), false)
		setActive(findTF(arg0.mvTf, "right"), false)
	else
		setActive(findTF(arg0.mvTf, "left"), arg0.showItemNum > 1)
		setActive(findTF(arg0.mvTf, "right"), arg0.showItemNum > 1)
	end

	for iter0 = 1, var1 do
		setActive(findTF(arg0.mvTf, "page/" .. iter0 .. "/selected"), arg0.mvIndex == iter0)
		setActive(findTF(arg0.mvTf, "page/" .. iter0), iter0 <= arg0.showItemNum)
		setActive(findTF(arg0.mvTf, "title_word/" .. iter0), iter0 == arg0.mvIndex)
	end
end

function var0.displayWindow(arg0, arg1)
	if not arg1 and not arg0.blurFlag then
		return
	end

	if arg0.isLoading then
		return
	end

	if arg0.blurFlag == arg1 then
		return
	end

	if arg1 then
		setActive(arg0.mvTf, true)

		local var0 = Screen.width
		local var1 = Screen.height

		setSizeDelta(findTF(arg0.mvTf, "bottom"), Vector2(Screen.width, Screen.height))
		pg.UIMgr.GetInstance():BlurPanel(arg0.mvTf, true)
		arg0:updateMvUI()
		arg0:loadMv()
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0.mvTf)
		setActive(arg0.mvTf, false)
	end

	arg0.blurFlag = arg1
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	arg0.isLoading = false

	arg0:displayWindow(false)
	arg0:clearMovie()
end

function var0.clearMovie(arg0)
	if arg0.mvGo then
		arg0.mvManaCpkUI:SetPlayEndHandler(nil)
		arg0.mvManaCpkUI:StopCpk()
		destroy(arg0.mvGo)

		arg0.mvManaCpkUI = nil
		arg0.mvGo = nil
		arg0.mvName = nil
	end
end

function var0.GetProgressColor(arg0)
	return "#57896D", "#A1AAA1"
end

function var0.loadMv(arg0)
	arg0:clearMovie()

	if arg0.isLoading then
		return
	end

	local var0 = "paocha" .. arg0.mvIndex

	arg0.isLoading = true

	PoolMgr.GetInstance():GetUI(var0, true, function(arg0)
		arg0.mvGo = arg0
		arg0.mvName = var0
		arg0.mvManaCpkUI = GetComponent(findTF(arg0.mvGo, "video/cpk"), typeof(CriManaCpkUI))

		arg0.mvManaCpkUI:SetPlayEndHandler(System.Action(function()
			arg0:mvComplete()

			if arg0.playHandle then
				arg0.playHandle()

				arg0.playHandle = nil
			end
		end))
		setActive(arg0.btnPlay, false)
		setActive(arg0.btnStop, true)
		setActive(arg0.btnRepeat, false)
		setText(arg0.movieWord, i18n("mktea_" .. arg0.mvIndex))

		if arg0.isLoading == false then
			arg0:clearMovie()
		else
			arg0.isLoading = false

			setParent(arg0.mvGo, arg0.mvContent)
			setActive(arg0.mvGo, true)
		end

		arg0.mvCompleteFlag = false

		arg0.mvManaCpkUI:PlayCpk()
	end)
end

function var0.mvComplete(arg0)
	print("播放完成")

	arg0.mvCompleteFlag = true

	arg0:onPlayerEnd()

	if arg0.mvIndex == arg0.nday then
		-- block empty
	end
end

function var0.onPlayerEnd(arg0)
	setActive(arg0.btnPlay, false)
	setActive(arg0.btnStop, false)
	setActive(arg0.btnRepeat, true)
end

function var0.onPlayerStop(arg0)
	setActive(arg0.btnPlay, true)
	setActive(arg0.btnStop, false)
	setActive(arg0.btnRepeat, false)
end

function var0.onPlayerStart(arg0)
	setActive(arg0.btnPlay, false)
	setActive(arg0.btnStop, true)
	setActive(arg0.btnRepeat, false)
end

return var0
