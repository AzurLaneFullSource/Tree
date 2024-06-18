local var0_0 = class("AprilFoolDiscovery2023Page", import(".AprilFoolDiscoveryRePage"))
local var1_0 = "superburin"

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")

	local var0_1 = arg0_1:findTF("AD/list1")

	arg0_1.items = CustomIndexLayer.Clone2Full(var0_1, 5)

	table.insertto(arg0_1.items, CustomIndexLayer.Clone2Full(arg0_1:findTF("AD/list2"), 5))

	arg0_1.selectIndex = 0
	arg0_1.btnHelp = arg0_1.bg:Find("help_btn")
	arg0_1.btnBattle = arg0_1.bg:Find("battle_btn")
	arg0_1.tip = arg0_1.bg:Find("tip")
	arg0_1.slider = arg0_1.bg:Find("slider")
	arg0_1.leftTime = arg0_1.slider:Find("time")
	arg0_1.loader = AutoLoader.New()

	for iter0_1 = 1, #var1_0 do
		arg0_1.loader:GetSprite("ui/activityuipage/aprilfooldiscovery2023page_atlas", string.sub(var1_0, iter0_1, iter0_1), arg0_1.items[iter0_1]:Find("character"))
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
	assert(#arg0_4.keyList == #arg0_4.items, string.format("keyList has {0}, but items has 9", #arg0_4.keyList))
	table.sort(arg0_4.keyList)
	onButton(arg0_4, arg0_4.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.caibulin_help.tip
		})
	end, SFX_PANEL)

	local var1_4 = arg0_4.activity.id

	onButton(arg0_4, arg0_4.btnBattle, function()
		if #arg0_4.activity.data2_list < #arg0_4.keyList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("caibulin_tip11"))

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
end

function var0_0.OnUpdateFlush(arg0_8)
	local var0_8

	var0_8 = arg0_8.activity.data1 >= 1

	local var1_8 = #arg0_8.activity.data2_list == #arg0_8.keyList
	local var2_8 = arg0_8.activity.data2_list
	local var3_8 = arg0_8.activity.data3_list

	for iter0_8, iter1_8 in ipairs(arg0_8.items) do
		local var4_8 = arg0_8.keyList[iter0_8]
		local var5_8 = table.contains(var2_8, var4_8) and 3 or table.contains(var3_8, var4_8) and 2 or 1

		onButton(arg0_8, iter1_8, function()
			if var5_8 >= 3 then
				return
			end

			if var5_8 == 2 then
				arg0_8.selectIndex = iter0_8

				arg0_8:UpdateSelection()

				return
			elseif var5_8 == 1 then
				if pg.TimeMgr.GetInstance():GetServerTime() < arg0_8.activity.data2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("bulin_tip_other2"))

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("bulin_tip_other1"),
					onYes = function()
						pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
							cmd = 3,
							actId = arg0_8.activity.id,
							id = var4_8
						})

						arg0_8.selectIndex = iter0_8
					end
				})
			end
		end)
		setActive(iter1_8:Find("character"), var5_8 == 3)
		setActive(iter1_8:Find("Unlock"), var5_8 == 2)
		setActive(iter1_8:Find("Locked"), var5_8 == 1)
	end

	setGray(arg0_8.btnBattle, not var1_8)
	arg0_8:UpdateSelection()

	local var6_8 = pg.activity_event_picturepuzzle[arg0_8.activity.id]

	if #table.mergeArray(arg0_8.activity.data1_list, arg0_8.activity.data2_list, true) >= #var6_8.pickup_picturepuzzle + #var6_8.drop_picturepuzzle then
		local var7_8 = arg0_8.activity:getConfig("config_client").comStory

		arg0_8:AddFunc(function(arg0_11)
			pg.NewStoryMgr.GetInstance():Play(var7_8, arg0_11)
		end)
	end
end

function var0_0.UpdateSelection(arg0_12)
	local var0_12 = arg0_12.keyList[arg0_12.selectIndex]
	local var1_12 = table.contains(arg0_12.activity.data3_list, var0_12)

	setText(arg0_12.tip, var1_12 and i18n("caibulin_tip" .. arg0_12.selectIndex) or "")
	arg0_12:CreateCDTimer()
end

return var0_0
