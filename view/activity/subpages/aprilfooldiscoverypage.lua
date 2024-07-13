local var0_0 = class("AprilFoolDiscoveryPage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.bgName = nil
	arg0_1.itemList = arg0_1:findTF("AD/list")
	arg0_1.items = CustomIndexLayer.Clone2Full(arg0_1.itemList, 9)
	arg0_1.selectIndex = 0
	arg0_1.btnHelp = arg0_1.bg:Find("help_btn")
	arg0_1.btnBattle = arg0_1.bg:Find("battle_btn")
	arg0_1.btnIncomplete = arg0_1.bg:Find("incomplete_btn")
	arg0_1.tip = arg0_1.bg:Find("tip")
	arg0_1.slider = arg0_1.bg:Find("slider")
	arg0_1.leftTime = arg0_1.slider:Find("time")
	arg0_1.loader = AutoLoader.New()
end

function var0_0.OnDataSetting(arg0_2)
	if arg0_2.activity.data1 == 0 and arg0_2.activity.data3 == 1 then
		arg0_2.activity.data3 = 0

		pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
			cmd = 1,
			actId = arg0_2.activity.id
		})

		return true
	end

	for iter0_2, iter1_2 in ipairs(arg0_2.activity.data1_list) do
		if not table.contains(arg0_2.activity.data2_list, iter1_2) then
			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = iter1_2,
				actId = arg0_2.activity.id
			})

			return true
		end
	end
end

function var0_0.OnFirstFlush(arg0_3)
	local var0_3 = pg.activity_event_picturepuzzle[arg0_3.activity.id]

	assert(var0_3, "Can't Find activity_event_picturepuzzle 's ID : " .. arg0_3.activity.id)

	arg0_3.puzzleConfig = var0_3
	arg0_3.keyList = Clone(var0_3.pickup_picturepuzzle)

	table.insertto(arg0_3.keyList, var0_3.drop_picturepuzzle)
	assert(#arg0_3.keyList == #arg0_3.items, string.format("keyList has {0}, but items has 9", #arg0_3.keyList))
	table.sort(arg0_3.keyList)
	onButton(arg0_3, arg0_3.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.bulin_help.tip
		})
	end, SFX_PANEL)

	local var1_3 = arg0_3.activity.id

	onButton(arg0_3, arg0_3.btnBattle, function()
		if #arg0_3.activity.data2_list < #arg0_3.keyList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))

			return
		end

		arg0_3:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
			warnMsg = "bulin_tip_other3",
			stageId = arg0_3.puzzleConfig.chapter
		}, function()
			local var0_6 = getProxy(ActivityProxy)
			local var1_6 = var0_6:getActivityById(var1_3)

			if var1_6.data1 == 1 then
				return
			end

			var1_6.data3 = 1

			var0_6:updateActivity(var1_6)
		end)
	end, SFX_PANEL)

	local var2_3 = arg0_3.activity:getConfig("config_client")

	pg.SystemGuideMgr.GetInstance():PlayByGuideId(var2_3.guideName)
end

local var1_0 = {
	"lock",
	"hint",
	"unlock"
}

function var0_0.OnUpdateFlush(arg0_7)
	var0_0.super.OnUpdateFlush(arg0_7)

	local var0_7 = arg0_7.activity.data1 > 0
	local var1_7 = #arg0_7.activity.data2_list == #arg0_7.keyList
	local var2_7 = var0_7 and "activity_bg_aprilfool_final" or "activity_bg_aprilfool_discovery"

	if var2_7 ~= arg0_7.bgName then
		setImageSprite(arg0_7.bg, LoadSprite("ui/activityuipage/AprilFoolDiscoveryPage_atlas", var2_7))

		arg0_7.bg:GetComponent(typeof(Image)).enabled = true
		arg0_7.bgName = var2_7
	end

	local var3_7 = arg0_7.activity.data2_list
	local var4_7 = arg0_7.activity.data3_list

	for iter0_7, iter1_7 in ipairs(arg0_7.items) do
		local var5_7 = arg0_7.keyList[iter0_7]
		local var6_7 = table.contains(var3_7, var5_7) and 3 or table.contains(var4_7, var5_7) and 2 or 1

		onButton(arg0_7, iter1_7, function()
			if var6_7 >= 3 then
				return
			end

			if var6_7 == 2 then
				arg0_7.selectIndex = iter0_7

				arg0_7:UpdateSelection()

				return
			elseif var6_7 == 1 then
				if pg.TimeMgr.GetInstance():GetServerTime() < arg0_7.activity.data2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("bulin_tip_other2"))

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("bulin_tip_other1"),
					onYes = function()
						pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
							cmd = 3,
							actId = arg0_7.activity.id,
							id = var5_7
						})

						arg0_7.selectIndex = iter0_7
					end
				})
			end
		end)
		arg0_7.loader:GetSprite("UI/ActivityUIPage/AprilFoolDiscoveryPage_atlas", var1_0[var6_7], iter1_7:Find("state"))
		setActive(iter1_7:Find("character"), var6_7 == 3)
	end

	setActive(arg0_7.btnBattle, var1_7)
	setActive(arg0_7.btnIncomplete, not var1_7)
	arg0_7:UpdateSelection()
end

function var0_0.UpdateSelection(arg0_10)
	local var0_10 = arg0_10.keyList[arg0_10.selectIndex]
	local var1_10 = table.contains(arg0_10.activity.data3_list, var0_10)

	setText(arg0_10.tip, var1_10 and i18n("bulin_tip" .. arg0_10.selectIndex) or "")
	arg0_10:CreateCDTimer()
end

function var0_0.CreateCDTimer(arg0_11)
	if arg0_11.CDTimer then
		return
	end

	if #arg0_11.activity.data2_list == #arg0_11.keyList or pg.TimeMgr.GetInstance():GetServerTime() >= arg0_11.activity.data2 then
		setActive(arg0_11.slider, false)
		arg0_11:RemoveCDTimer()

		return
	end

	setActive(arg0_11.slider, true)

	arg0_11.CDTimer = Timer.New(function()
		local var0_12 = arg0_11.activity.data2
		local var1_12 = pg.TimeMgr.GetInstance():GetServerTime()

		if var0_12 <= var1_12 then
			setActive(arg0_11.slider, false)
			arg0_11:RemoveCDTimer()

			return
		end

		local var2_12 = var0_12 - var1_12
		local var3_12 = math.floor(var2_12 / 60)
		local var4_12 = var2_12 % 60

		setText(arg0_11.leftTime, string.format("%d:%02d", var3_12, var4_12))

		local var5_12 = arg0_11.puzzleConfig.cd

		setSlider(arg0_11.slider, 0, 1, var2_12 / var5_12)
	end, 1, -1)

	arg0_11.CDTimer:Start()
	arg0_11.CDTimer.func()
end

function var0_0.RemoveCDTimer(arg0_13)
	if arg0_13.CDTimer then
		arg0_13.CDTimer:Stop()

		arg0_13.CDTimer = nil
	end
end

function var0_0.OnDestroy(arg0_14)
	arg0_14.loader:Clear()
	arg0_14:RemoveCDTimer()
	var0_0.super.OnDestroy(arg0_14)
end

return var0_0
