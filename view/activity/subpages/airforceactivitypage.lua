local var0_0 = class("AirForceActivityPage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.btnBattle = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.iconAward = arg0_1:findTF("award", arg0_1.bg)
	arg0_1.iconGot = arg0_1:findTF("got_btn", arg0_1.bg)
	arg0_1.textStep = arg0_1:findTF("step", arg0_1.bg)
	arg0_1.textCount = arg0_1:findTF("count", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items", arg0_1.bg)
	arg0_1.blur = arg0_1:findTF("Blur")
	arg0_1.window = arg0_1:findTF("window", arg0_1.blur)
	arg0_1.textTitle = arg0_1:findTF("title", arg0_1.window)
	arg0_1.textContent = arg0_1:findTF("content", arg0_1.window)

	setActive(arg0_1.blur, false)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.linkActivity = getProxy(ActivityProxy):getActivityById(arg0_2.activity:getConfig("config_client").linkActID)
	arg0_2.taskIds = arg0_2.linkActivity:getConfig("config_data")

	local var0_2 = _.map(arg0_2.taskIds, function(arg0_3)
		return getProxy(TaskProxy):getTaskVO(arg0_3) or Task.New({
			id = arg0_3
		})
	end)

	arg0_2.summaryTask = _.detect(var0_2, function(arg0_4)
		return arg0_4:getConfig("sub_type") == 90
	end)
	arg0_2.subTasks = _.select(var0_2, function(arg0_5)
		return arg0_5:getConfig("sub_type") ~= 90
	end)
end

function var0_0.TrySubmitTask(arg0_6)
	if not arg0_6.summaryTask then
		return
	end

	if arg0_6.summaryTask:isFinish() and not arg0_6.summaryTask:isReceive() then
		pg.m02:sendNotification(GAME.SUBMIT_TASK, arg0_6.summaryTask.id)

		return true
	end
end

function var0_0.OnFirstFlush(arg0_7)
	onButton(arg0_7, arg0_7.btnBattle, function()
		arg0_7:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.AIRFORCE_DRAGONEMPERY)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.blur, function()
		arg0_7:CloseWindow()
		arg0_7:TrySubmitTask()
	end)

	for iter0_7 = 1, #arg0_7.subTasks do
		onButton(arg0_7, arg0_7.items:GetChild(iter0_7 - 1), function()
			local var0_10 = arg0_7.subTasks[iter0_7]

			if not var0_10:isReceive() then
				pg.m02:sendNotification(GAME.SUBMIT_TASK, var0_10.id)
			end

			setText(arg0_7.textTitle, i18n("airforce_title_" .. iter0_7))
			setText(arg0_7.textContent, i18n("airforce_desc_" .. iter0_7))
			pg.UIMgr.GetInstance():OverlayPanel(arg0_7.blur, {
				pbList = {
					arg0_7.blur
				}
			})
			setActive(arg0_7.blur, true)
		end, SFX_PANEL)
	end

	local var0_7 = arg0_7.summaryTask:getConfig("award_display")[1]
	local var1_7 = Drop.New({
		type = var0_7[1],
		id = var0_7[2],
		count = var0_7[3]
	})

	updateDrop(arg0_7.iconAward, var1_7)
	onButton(arg0_7, arg0_7.iconAward, function()
		arg0_7:emit(BaseUI.ON_DROP, var1_7)
	end, SFX_PANEL)
	arg0_7:TrySubmitTask()
end

function var0_0.OnUpdateFlush(arg0_12)
	local var0_12 = arg0_12.subTasks
	local var1_12 = 0

	for iter0_12 = 1, #var0_12 do
		local var2_12 = var0_12[iter0_12]:isReceive()

		setActive(arg0_12.items:GetChild(iter0_12 - 1):Find("viewed"), var2_12)

		if var2_12 then
			var1_12 = var1_12 + 1
		end
	end

	setText(arg0_12.textStep, var1_12 .. "/" .. #var0_12)
	setText(arg0_12.textCount, arg0_12:GetFightCount())
	setActive(arg0_12.iconGot, arg0_12.summaryTask:isReceive())
	setActive(arg0_12.btnBattle:Find("tip"), arg0_12.activity:readyToAchieve())
end

function var0_0.GetFightCount(arg0_13)
	local var0_13 = arg0_13.activity
	local var1_13 = var0_13:GetMaxProgress()
	local var2_13 = var0_13:GetPerDayCount()
	local var3_13 = 0
	local var4_13 = var0_13:GetLevelCount()

	for iter0_13 = 1, var4_13 do
		var3_13 = var3_13 + (var0_13:getKVPList(1, iter0_13) or 0)
	end

	local var5_13 = pg.TimeMgr.GetInstance()
	local var6_13 = var5_13:DiffDay(var0_13.data1, var5_13:GetServerTime()) + 1

	return math.min(var6_13 * var2_13, var1_13) - var3_13
end

function var0_0.CloseWindow(arg0_14)
	setActive(arg0_14.blur, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14.blur, arg0_14._tf)
end

function var0_0.ShowOrHide(arg0_15, arg1_15)
	if not arg1_15 and isActive(arg0_15.blur) then
		arg0_15:CloseWindow()
	end

	var0_0.super.ShowOrHide(arg0_15, arg1_15)
end

function var0_0.OnDestroy(arg0_16)
	if isActive(arg0_16.blur) then
		arg0_16:CloseWindow()
	end

	var0_0.super.OnDestroy(arg0_16)
end

return var0_0
