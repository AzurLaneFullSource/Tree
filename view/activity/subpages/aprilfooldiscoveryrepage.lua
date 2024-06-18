local var0_0 = class("AprilFoolDiscoveryRePage", import(".AprilFoolDiscoveryPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.bulin = arg0_1.bg:Find("bulin")
	arg0_1.bulinAnim = arg0_1.bulin:Find("bulin"):GetComponent("SpineAnimUI")

	setText(arg0_1.bulin:Find("Text"), i18n("super_bulin_tip"))
	setActive(arg0_1.bulin, false)

	arg0_1._funcsLink = {}
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

function var0_0.OnFirstFlush(arg0_7)
	local var0_7 = pg.activity_event_picturepuzzle[arg0_7.activity.id]

	assert(var0_7, "Can't Find activity_event_picturepuzzle 's ID : " .. arg0_7.activity.id)

	arg0_7.puzzleConfig = var0_7
	arg0_7.keyList = Clone(var0_7.pickup_picturepuzzle)

	table.insertto(arg0_7.keyList, var0_7.drop_picturepuzzle)
	assert(#arg0_7.keyList == #arg0_7.items, string.format("keyList has {0}, but items has 9", #arg0_7.keyList))
	table.sort(arg0_7.keyList)
	onButton(arg0_7, arg0_7.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.bulin_help.tip
		})
	end, SFX_PANEL)

	local var1_7 = arg0_7.activity.id

	onButton(arg0_7, arg0_7.btnBattle, function()
		if #arg0_7.activity.data2_list < #arg0_7.keyList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))

			return
		end

		arg0_7:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
			warnMsg = "bulin_tip_other3",
			stageId = arg0_7.puzzleConfig.chapter
		}, function()
			local var0_10 = getProxy(ActivityProxy)
			local var1_10 = var0_10:getActivityById(var1_7)

			if var1_10.data1 == 1 then
				return
			end

			var1_10.data3 = 1

			var0_10:updateActivity(var1_10)
		end)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.bulin, function()
		if arg0_7.activity.data1 >= 1 then
			seriesAsync({
				function(arg0_12)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("super_bulin"),
						onYes = arg0_12
					})
				end,
				function(arg0_13)
					arg0_7:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
						warnMsg = "bulin_tip_other3",
						stageId = arg0_7:GetLinkStage()
					}, function()
						local var0_14 = getProxy(ActivityProxy)
						local var1_14 = var0_14:getActivityById(var1_7)

						if var1_14.data1 == 2 then
							return
						end

						var1_14.data3 = 1

						var0_14:updateActivity(var1_14)
					end)
				end
			})
		end
	end)

	local var2_7 = arg0_7.activity:getConfig("config_client").guideName

	arg0_7:AddFunc(function(arg0_15)
		pg.SystemGuideMgr.GetInstance():PlayByGuideId(var2_7, nil, arg0_15)
	end)
end

local var1_0 = {
	"lock",
	"hint",
	"unlock"
}

function var0_0.OnUpdateFlush(arg0_16)
	local var0_16 = arg0_16.activity.data1 >= 1
	local var1_16 = #arg0_16.activity.data2_list == #arg0_16.keyList
	local var2_16 = var0_16 and "activity_bg_aprilfool_final" or "activity_bg_aprilfool_discovery"

	if var2_16 ~= arg0_16.bgName then
		setImageSprite(arg0_16.bg, LoadSprite("ui/activityuipage/AprilFoolDiscoveryRePage_atlas", var2_16))

		arg0_16.bg:GetComponent(typeof(Image)).enabled = true
		arg0_16.bgName = var2_16
	end

	local var3_16 = arg0_16.activity.data2_list
	local var4_16 = arg0_16.activity.data3_list

	for iter0_16, iter1_16 in ipairs(arg0_16.items) do
		local var5_16 = arg0_16.keyList[iter0_16]
		local var6_16 = table.contains(var3_16, var5_16) and 3 or table.contains(var4_16, var5_16) and 2 or 1

		onButton(arg0_16, iter1_16, function()
			if var6_16 >= 3 then
				return
			end

			if var6_16 == 2 then
				arg0_16.selectIndex = iter0_16

				arg0_16:UpdateSelection()

				return
			elseif var6_16 == 1 then
				if pg.TimeMgr.GetInstance():GetServerTime() < arg0_16.activity.data2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("bulin_tip_other2"))

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("bulin_tip_other1"),
					onYes = function()
						pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
							cmd = 3,
							actId = arg0_16.activity.id,
							id = var5_16
						})

						arg0_16.selectIndex = iter0_16
					end
				})
			end
		end)
		arg0_16.loader:GetSprite("UI/ActivityUIPage/AprilFoolDiscoveryRePage_atlas", var1_0[var6_16], iter1_16:Find("state"))
		setActive(iter1_16:Find("character"), var6_16 == 3)
	end

	setActive(arg0_16.btnBattle, var1_16)
	setActive(arg0_16.btnIncomplete, not var1_16)
	arg0_16:UpdateSelection()
	setActive(arg0_16.bulin, var0_16)

	if arg0_16.activity.data1 == 1 then
		local var7_16 = arg0_16.activity:getConfig("config_client").popStory

		arg0_16:AddFunc(function(arg0_19)
			pg.NewStoryMgr.GetInstance():Play(var7_16, arg0_19)
		end)
		arg0_16:AddFunc(function(arg0_20)
			local var0_20 = getProxy(PlayerProxy):getRawData()

			if PlayerPrefs.GetInt("SuperBurinPopUp_" .. var0_20.id, 0) == 0 then
				LoadContextCommand.LoadLayerOnTopContext(Context.New({
					mediator = SuperBulinPopMediator,
					viewComponent = SuperBulinPopView,
					data = {
						stageId = arg0_16:GetLinkStage(),
						actId = arg0_16.activity.id,
						onRemoved = arg0_20
					}
				}))
				PlayerPrefs.SetInt("SuperBurinPopUp_" .. var0_20.id, 1)
			end
		end)
	end
end

function var0_0.OnDestroy(arg0_21)
	var0_0.super.OnDestroy(arg0_21)
end

function var0_0.GetLinkStage(arg0_22)
	return arg0_22.activity:getConfig("config_client").lastChapter
end

return var0_0
