local var0_0 = class("AprilFoolDiscovery2025Page", import(".AprilFoolDiscoveryRePage"))
local var1_0 = "burinteam"

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
	arg0_1.slider = arg0_1.bg:Find("slider")
	arg0_1.leftTime = arg0_1.slider:Find("time")
	arg0_1.loader = AutoLoader.New()

	for iter0_1 = 1, #var1_0 do
		arg0_1.loader:GetSprite("ui/activityuipage/AprilFoolDiscovery2025Page_atlas", string.sub(var1_0, iter0_1, iter0_1), arg0_1.items[iter0_1]:Find("Character"))
	end

	arg0_1._funcsLink = {}
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = var0_0.super.OnDataSetting(arg0_2)

	local function var1_2()
		if arg0_2.activity.data1 == 1 and arg0_2.activity.data3 == 1 then
			arg0_2.activity.data3 = 0

			pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
				cmd = 4,
				actId = arg0_2.activity.id
			})

			return true
		end
	end

	var0_2 = var0_2 or var1_2()

	return var0_2
end

function var0_0.OnFirstFlush(arg0_4)
	local var0_4 = pg.activity_event_picturepuzzle[arg0_4.activity.id]

	assert(var0_4, "Can't Find activity_event_picturepuzzle 's ID : " .. arg0_4.activity.id)

	arg0_4.puzzleConfig = var0_4
	arg0_4.keyList = Clone(var0_4.pickup_picturepuzzle)

	table.insertto(arg0_4.keyList, var0_4.drop_picturepuzzle)
	assert(#arg0_4.keyList == #arg0_4.items, string.format("keyList has {0}, but items has {1}", #arg0_4.keyList, #arg0_4.items))
	table.sort(arg0_4.keyList)
	onButton(arg0_4, arg0_4.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.SuperBulin2_help.tip
		})
	end, SFX_PANEL)

	local var1_4 = arg0_4.activity.id

	onButton(arg0_4, arg0_4.btnBattle, function()
		if #arg0_4.activity.data2_list < #arg0_4.keyList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("caibulin_lock_tip"))

			return
		end

		local var0_6 = arg0_4.puzzleConfig.chapter

		arg0_4:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
			warnMsg = "bulin_tip_other3",
			stageId = var0_6
		}, function()
			if not pg.NewStoryMgr.GetInstance():IsPlayed(tostring(var0_6), true) then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = tostring(var0_6)
				})
			end

			local var0_7 = getProxy(ActivityProxy)
			local var1_7 = var0_7:getActivityById(var1_4)

			if var1_7.data1 == 1 then
				return
			end

			var1_7.data3 = 1

			var0_7:updateActivity(var1_7)
		end)
	end, SFX_PANEL)

	local var2_4 = arg0_4.activity:getConfig("config_client").guideName

	arg0_4:AddFunc(function(arg0_8)
		pg.NewStoryMgr.GetInstance():Play(var2_4[1], arg0_8)
	end)
end

function var0_0.OnUpdateFlush(arg0_9)
	local var0_9

	var0_9 = arg0_9.activity.data1 >= 1

	local var1_9 = #arg0_9.activity.data2_list == #arg0_9.keyList
	local var2_9 = arg0_9.activity.data2_list
	local var3_9 = arg0_9.activity.data3_list

	for iter0_9, iter1_9 in ipairs(arg0_9.items) do
		local var4_9 = arg0_9.keyList[iter0_9]
		local var5_9 = table.contains(var2_9, var4_9) and 3 or table.contains(var3_9, var4_9) and 2 or 1

		onButton(arg0_9, iter1_9, function()
			if var5_9 >= 3 then
				return
			end

			if var5_9 == 2 then
				arg0_9.selectIndex = iter0_9

				arg0_9:UpdateSelection()

				return
			elseif var5_9 == 1 then
				if pg.TimeMgr.GetInstance():GetServerTime() < arg0_9.activity.data2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("bulin_tip_other2"))

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("bulin_tip_other1"),
					onYes = function()
						pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
							cmd = 3,
							actId = arg0_9.activity.id,
							id = var4_9
						})

						arg0_9.selectIndex = iter0_9
					end
				})
			end
		end)
		setActive(iter1_9:Find("Character"), var5_9 == 3)
		setActive(iter1_9:Find("Unlock"), var5_9 == 2)
		setActive(iter1_9:Find("Locked"), var5_9 == 1)
	end

	SetActive(arg0_9.battle_btn, not var1_9)
	SetActive(arg0_9.btnBattle, var1_9)
	arg0_9:UpdateSelection()

	local var6_9 = pg.activity_event_picturepuzzle[arg0_9.activity.id]

	if #table.mergeArray(arg0_9.activity.data1_list, arg0_9.activity.data2_list, true) >= #var6_9.pickup_picturepuzzle + #var6_9.drop_picturepuzzle then
		local var7_9 = arg0_9.activity:getConfig("config_client").comStory

		arg0_9:AddFunc(function(arg0_12)
			pg.NewStoryMgr.GetInstance():Play(var7_9, arg0_12)
		end)
	end
end

function var0_0.UpdateSelection(arg0_13)
	local var0_13 = arg0_13.keyList[arg0_13.selectIndex]
	local var1_13 = table.contains(arg0_13.activity.data3_list, var0_13)

	setText(arg0_13.tip, var1_13 and i18n("SuperBulin2_tip" .. arg0_13.selectIndex) or "")
	arg0_13:CreateCDTimer()
end

return var0_0
