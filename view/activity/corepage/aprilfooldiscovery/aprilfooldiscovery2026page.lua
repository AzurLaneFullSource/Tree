local var0_0 = class("AprilFoolDiscovery2026Page", import("view.activity.CorePage.CoreActivityAprilFoolDiscoveryPage"))
local var1_0 = "magicbuli"

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")

	local var0_1 = arg0_1._tf:Find("AD/List")

	arg0_1.items = CustomIndexLayer.Clone2Full(var0_1, 9)
	arg0_1.selectIndex = 0
	arg0_1.btnHelp = arg0_1.bg:Find("help_btn")
	arg0_1.btnBattle = arg0_1.bg:Find("battle_btn")
	arg0_1.battle_btn = arg0_1.bg:Find("battle_btn_1")
	arg0_1.btnIncomplete = arg0_1.bg:Find("incomplete_btn")
	arg0_1.tip = arg0_1.bg:Find("tip")
	arg0_1.tip_bg = arg0_1.bg:Find("tipbg")
	arg0_1.slider = arg0_1.bg:Find("slider")
	arg0_1.leftTime = arg0_1.slider:Find("time")
	arg0_1.sliderbg = arg0_1.bg:Find("sliderbg")
	arg0_1.loader = AutoLoader.New()

	for iter0_1 = 1, #var1_0 do
		arg0_1.loader:GetSprite("UI/AprilFoolDiscovery2026Page_atlas", string.sub(var1_0, iter0_1, iter0_1), arg0_1.items[iter0_1]:Find("Character"), true)
	end

	arg0_1._funcsLink = {}

	setText(arg0_1.slider:Find("timetext"), i18n("aprilfool_2026_cd"))
end

function var0_0.AddFunc(arg0_2, arg1_2)
	table.insert(arg0_2._funcsLink, arg1_2)

	if #arg0_2._funcsLink > 1 then
		return
	end

	arg0_2:PlayFuncsLink()
end

function var0_0.PlayFuncsLink(arg0_3)
	local var0_3 = false
	local var1_3

	local function var2_3(...)
		if var0_3 then
			table.remove(arg0_3._funcsLink, 1)
		end

		var0_3 = true

		local var0_4 = arg0_3._funcsLink[1]

		if var0_4 then
			var0_4(var2_3, ...)
		end
	end

	var2_3()
end

function var0_0.OnDataSetting(arg0_5)
	local var0_5 = var0_0.super.OnDataSetting(arg0_5)

	local function var1_5()
		if arg0_5.activity.data1 == 1 and arg0_5.activity.data3 == 1 then
			arg0_5.activity.data3 = 0

			pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
				cmd = 4,
				actId = arg0_5.activity.id
			})

			return true
		end
	end

	var0_5 = var0_5 or var1_5()

	return var0_5
end

function var0_0.CreateCDTimer(arg0_7)
	if arg0_7.CDTimer then
		return
	end

	if #arg0_7.activity.data2_list == #arg0_7.keyList or pg.TimeMgr.GetInstance():GetServerTime() >= arg0_7.activity.data2 then
		setActive(arg0_7.slider, false)
		setActive(arg0_7.sliderbg, false)
		arg0_7:RemoveCDTimer()

		return
	end

	setActive(arg0_7.slider, true)
	setActive(arg0_7.sliderbg, true)

	arg0_7.CDTimer = Timer.New(function()
		local var0_8 = arg0_7.activity.data2
		local var1_8 = pg.TimeMgr.GetInstance():GetServerTime()

		if var0_8 <= var1_8 then
			setActive(arg0_7.slider, false)
			setActive(arg0_7.sliderbg, false)
			arg0_7:RemoveCDTimer()

			return
		end

		local var2_8 = var0_8 - var1_8
		local var3_8 = math.floor(var2_8 / 60)
		local var4_8 = var2_8 % 60

		setText(arg0_7.leftTime, string.format("%d:%02d", var3_8, var4_8))

		local var5_8 = arg0_7.puzzleConfig.cd

		setSlider(arg0_7.slider, 0, 1, var2_8 / var5_8)
	end, 1, -1)

	arg0_7.CDTimer:Start()
	arg0_7.CDTimer.func()
end

function var0_0.OnFirstFlush(arg0_9)
	local var0_9 = pg.activity_event_picturepuzzle[arg0_9.activity.id]

	assert(var0_9, "Can't Find activity_event_picturepuzzle 's ID : " .. arg0_9.activity.id)

	arg0_9.puzzleConfig = var0_9
	arg0_9.keyList = Clone(var0_9.pickup_picturepuzzle)

	table.insertto(arg0_9.keyList, var0_9.drop_picturepuzzle)
	assert(#arg0_9.keyList == #arg0_9.items, string.format("keyList has {0}, but items has {1}", #arg0_9.keyList, #arg0_9.items))
	table.sort(arg0_9.keyList)
	onButton(arg0_9, arg0_9.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.SuperBulin2_help.tip
		})
	end, SFX_PANEL)

	local var1_9 = arg0_9.activity.id

	onButton(arg0_9, arg0_9.btnBattle, function()
		if #arg0_9.activity.data2_list < #arg0_9.keyList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("caibulin_lock_tip"))

			return
		end

		local var0_11 = arg0_9.puzzleConfig.chapter

		arg0_9:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
			warnMsg = "bulin_tip_other3",
			stageId = var0_11
		}, function()
			if not pg.NewStoryMgr.GetInstance():IsPlayed(tostring(var0_11), true) then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = tostring(var0_11)
				})
			end

			local var0_12 = getProxy(ActivityProxy)
			local var1_12 = var0_12:getActivityById(var1_9)

			if var1_12.data1 == 1 then
				return
			end

			var1_12.data3 = 1

			var0_12:updateActivity(var1_12)
		end)
	end, SFX_PANEL)

	local var2_9 = arg0_9.activity:getConfig("config_client").guideName

	arg0_9:AddFunc(function(arg0_13)
		pg.NewStoryMgr.GetInstance():Play(var2_9[1], arg0_13)
	end)
end

function var0_0.OnUpdateFlush(arg0_14)
	local var0_14

	var0_14 = arg0_14.activity.data1 >= 1

	local var1_14 = #arg0_14.activity.data2_list == #arg0_14.keyList
	local var2_14 = arg0_14.activity.data2_list
	local var3_14 = arg0_14.activity.data3_list

	for iter0_14, iter1_14 in ipairs(arg0_14.items) do
		local var4_14 = arg0_14.keyList[iter0_14]
		local var5_14 = table.contains(var2_14, var4_14) and 3 or table.contains(var3_14, var4_14) and 2 or 1

		onButton(arg0_14, iter1_14, function()
			if var5_14 >= 3 then
				return
			end

			if var5_14 == 2 then
				arg0_14.selectIndex = iter0_14

				arg0_14:UpdateSelection()

				return quickPlayAnimation(iter1_14:Find("Unlock"), "im_AprilFoolDiscovery2026Page_Unlock")
			elseif var5_14 == 1 then
				if pg.TimeMgr.GetInstance():GetServerTime() < arg0_14.activity.data2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("bulin_tip_other2"))

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("bulin_tip_other1"),
					onYes = function()
						pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
							cmd = 3,
							actId = arg0_14.activity.id,
							id = var4_14
						})

						arg0_14.selectIndex = iter0_14
					end
				})
			end
		end)
		setActive(iter1_14:Find("Character"), var5_14 == 3)

		if var5_14 == 3 then
			quickPlayAnimation(iter1_14, "anim_AprilFoolDiscovery2026Page_open")
		end

		setActive(iter1_14:Find("Selected"), var5_14 == 2)

		if var5_14 == 2 then
			setActive(iter1_14:Find("Unlock"), true)
		end

		setActive(iter1_14:Find("Locked"), var5_14 == 1)
	end

	SetActive(arg0_14.battle_btn, not var1_14)
	SetActive(arg0_14.btnBattle, var1_14)
	arg0_14:UpdateSelection()

	local var6_14 = pg.activity_event_picturepuzzle[arg0_14.activity.id]

	if #table.mergeArray(arg0_14.activity.data1_list, arg0_14.activity.data2_list, true) >= #var6_14.pickup_picturepuzzle + #var6_14.drop_picturepuzzle then
		local var7_14 = arg0_14.activity:getConfig("config_client").comStory

		arg0_14:AddFunc(function(arg0_17)
			pg.NewStoryMgr.GetInstance():Play(var7_14, arg0_17)
		end)
	end
end

function var0_0.UpdateSelection(arg0_18)
	local var0_18 = arg0_18.keyList[arg0_18.selectIndex]
	local var1_18 = table.contains(arg0_18.activity.data3_list, var0_18)

	SetActive(arg0_18.tip, var1_18 and i18n("SuperBulin2_tip" .. arg0_18.selectIndex) or false)
	SetActive(arg0_18.tip_bg, var1_18 and i18n("SuperBulin2_tip" .. arg0_18.selectIndex) or false)
	setText(arg0_18.tip, var1_18 and i18n("SuperBulin2_tip" .. arg0_18.selectIndex) or "")
	arg0_18:CreateCDTimer()
end

return var0_0
