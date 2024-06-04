local var0 = class("AprilFoolDiscoveryPage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.bgName = nil
	arg0.itemList = arg0:findTF("AD/list")
	arg0.items = CustomIndexLayer.Clone2Full(arg0.itemList, 9)
	arg0.selectIndex = 0
	arg0.btnHelp = arg0.bg:Find("help_btn")
	arg0.btnBattle = arg0.bg:Find("battle_btn")
	arg0.btnIncomplete = arg0.bg:Find("incomplete_btn")
	arg0.tip = arg0.bg:Find("tip")
	arg0.slider = arg0.bg:Find("slider")
	arg0.leftTime = arg0.slider:Find("time")
	arg0.loader = AutoLoader.New()
end

function var0.OnDataSetting(arg0)
	if arg0.activity.data1 == 0 and arg0.activity.data3 == 1 then
		arg0.activity.data3 = 0

		pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
			cmd = 1,
			actId = arg0.activity.id
		})

		return true
	end

	for iter0, iter1 in ipairs(arg0.activity.data1_list) do
		if not table.contains(arg0.activity.data2_list, iter1) then
			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = iter1,
				actId = arg0.activity.id
			})

			return true
		end
	end
end

function var0.OnFirstFlush(arg0)
	local var0 = pg.activity_event_picturepuzzle[arg0.activity.id]

	assert(var0, "Can't Find activity_event_picturepuzzle 's ID : " .. arg0.activity.id)

	arg0.puzzleConfig = var0
	arg0.keyList = Clone(var0.pickup_picturepuzzle)

	table.insertto(arg0.keyList, var0.drop_picturepuzzle)
	assert(#arg0.keyList == #arg0.items, string.format("keyList has {0}, but items has 9", #arg0.keyList))
	table.sort(arg0.keyList)
	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.bulin_help.tip
		})
	end, SFX_PANEL)

	local var1 = arg0.activity.id

	onButton(arg0, arg0.btnBattle, function()
		if #arg0.activity.data2_list < #arg0.keyList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))

			return
		end

		arg0:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
			warnMsg = "bulin_tip_other3",
			stageId = arg0.puzzleConfig.chapter
		}, function()
			local var0 = getProxy(ActivityProxy)
			local var1 = var0:getActivityById(var1)

			if var1.data1 == 1 then
				return
			end

			var1.data3 = 1

			var0:updateActivity(var1)
		end)
	end, SFX_PANEL)

	local var2 = arg0.activity:getConfig("config_client")

	pg.SystemGuideMgr.GetInstance():PlayByGuideId(var2.guideName)
end

local var1 = {
	"lock",
	"hint",
	"unlock"
}

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0 = arg0.activity.data1 > 0
	local var1 = #arg0.activity.data2_list == #arg0.keyList
	local var2 = var0 and "activity_bg_aprilfool_final" or "activity_bg_aprilfool_discovery"

	if var2 ~= arg0.bgName then
		setImageSprite(arg0.bg, LoadSprite("ui/activityuipage/AprilFoolDiscoveryPage_atlas", var2))

		arg0.bg:GetComponent(typeof(Image)).enabled = true
		arg0.bgName = var2
	end

	local var3 = arg0.activity.data2_list
	local var4 = arg0.activity.data3_list

	for iter0, iter1 in ipairs(arg0.items) do
		local var5 = arg0.keyList[iter0]
		local var6 = table.contains(var3, var5) and 3 or table.contains(var4, var5) and 2 or 1

		onButton(arg0, iter1, function()
			if var6 >= 3 then
				return
			end

			if var6 == 2 then
				arg0.selectIndex = iter0

				arg0:UpdateSelection()

				return
			elseif var6 == 1 then
				if pg.TimeMgr.GetInstance():GetServerTime() < arg0.activity.data2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("bulin_tip_other2"))

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("bulin_tip_other1"),
					onYes = function()
						pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
							cmd = 3,
							actId = arg0.activity.id,
							id = var5
						})

						arg0.selectIndex = iter0
					end
				})
			end
		end)
		arg0.loader:GetSprite("UI/ActivityUIPage/AprilFoolDiscoveryPage_atlas", var1[var6], iter1:Find("state"))
		setActive(iter1:Find("character"), var6 == 3)
	end

	setActive(arg0.btnBattle, var1)
	setActive(arg0.btnIncomplete, not var1)
	arg0:UpdateSelection()
end

function var0.UpdateSelection(arg0)
	local var0 = arg0.keyList[arg0.selectIndex]
	local var1 = table.contains(arg0.activity.data3_list, var0)

	setText(arg0.tip, var1 and i18n("bulin_tip" .. arg0.selectIndex) or "")
	arg0:CreateCDTimer()
end

function var0.CreateCDTimer(arg0)
	if arg0.CDTimer then
		return
	end

	if #arg0.activity.data2_list == #arg0.keyList or pg.TimeMgr.GetInstance():GetServerTime() >= arg0.activity.data2 then
		setActive(arg0.slider, false)
		arg0:RemoveCDTimer()

		return
	end

	setActive(arg0.slider, true)

	arg0.CDTimer = Timer.New(function()
		local var0 = arg0.activity.data2
		local var1 = pg.TimeMgr.GetInstance():GetServerTime()

		if var0 <= var1 then
			setActive(arg0.slider, false)
			arg0:RemoveCDTimer()

			return
		end

		local var2 = var0 - var1
		local var3 = math.floor(var2 / 60)
		local var4 = var2 % 60

		setText(arg0.leftTime, string.format("%d:%02d", var3, var4))

		local var5 = arg0.puzzleConfig.cd

		setSlider(arg0.slider, 0, 1, var2 / var5)
	end, 1, -1)

	arg0.CDTimer:Start()
	arg0.CDTimer.func()
end

function var0.RemoveCDTimer(arg0)
	if arg0.CDTimer then
		arg0.CDTimer:Stop()

		arg0.CDTimer = nil
	end
end

function var0.OnDestroy(arg0)
	arg0.loader:Clear()
	arg0:RemoveCDTimer()
	var0.super.OnDestroy(arg0)
end

return var0
