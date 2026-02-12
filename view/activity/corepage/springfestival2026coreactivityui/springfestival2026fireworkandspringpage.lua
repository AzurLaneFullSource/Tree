local var0_0 = class("SpringFestival2026FireworkAndSpringPage", import("view.activity.CorePage.CoreActivityBackHillTemplate"))

var0_0.edge2area = {
	default = "_SDPlace"
}
var0_0.EffectPoolCnt = 3
var0_0.Id2EffectName = {
	[65842] = "yanhua_xiaojiajia",
	[65841] = "yanhua_xinxin",
	[65840] = "yanhua_jiezhi",
	[65839] = "yanhua_huangji",
	[65838] = "yanhua_chuanmao",
	[65837] = "yanhua_hongbao",
	[65836] = "yanhua_denglong",
	[65835] = "yanhua_maomao",
	[65834] = "yanhua_02",
	[65833] = "yanhua_01",
	[65844] = "yanhua_ma",
	[65843] = "yanhua_2026",
	[65531] = "yanhua_hongbao",
	[70178] = "yanhua_denglong"
}
var0_0.FireworkRange = Vector2(300, 300)
var0_0.EffectPosLimit = {
	limitX = {
		-700,
		700
	},
	limitY = {
		250,
		500
	}
}
var0_0.EffectInterval = 1
var0_0.DelayPop = 2.5
var0_0.SFX_LIST = {
	"event:/ui/firework1",
	"event:/ui/firework2",
	"event:/ui/firework3",
	"event:/ui/firework4"
}

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1._map = arg0_1._tf:Find("BG/map")
	arg0_1._shipTpl = arg0_1._tf:Find("BG/ship")
	arg0_1.fireworksTF = arg0_1._tf:Find("BG/fireworks")
	arg0_1._SDPlace = arg0_1._tf:Find("BG/SDPlace")
	arg0_1.containers = {
		arg0_1._SDPlace
	}
	arg0_1.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.FireworkAndSpringGraph"))
	arg0_1.backBtn = arg0_1._tf:Find("BG/panel/btn_back")
	arg0_1.tipBtn = arg0_1._tf:Find("BG/panel/btn_tip")
	arg0_1.ptBtn = arg0_1._tf:Find("BG/panel/btn_pt")
	arg0_1.stage = arg0_1._tf:Find("BG/panel/btn_pt/stage")
	arg0_1.pt = arg0_1._tf:Find("BG/panel/btn_pt/pt")
	arg0_1.taskBtn = arg0_1._tf:Find("BG/panel/btn_task")
	arg0_1.fireworkBtn = arg0_1._tf:Find("BG/panel/btn_firework")
	arg0_1.springBtn = arg0_1._tf:Find("BG/panel/btn_spring")
	arg0_1.subPanel = arg0_1._tf:Find("BG/subPanel")
	arg0_1.subPanelPanel = arg0_1.subPanel:Find("panel")
	arg0_1.subLeft = arg0_1.subPanelPanel:Find("left")
	arg0_1.subRight = arg0_1.subPanelPanel:Find("right")
	arg0_1.subPtBtn = arg0_1.subLeft:Find("ptBtn")
	arg0_1.subTaskBtn = arg0_1.subLeft:Find("taskBtn")
	arg0_1.subFireworkBtn = arg0_1.subLeft:Find("fireworkBtn")
	arg0_1.subSpringBtn = arg0_1.subLeft:Find("springBtn")
	arg0_1.ptPanel = arg0_1.subRight:Find("ptPanel")
	arg0_1.taskPanel = arg0_1.subRight:Find("taskPanel")
	arg0_1.fireworkPanel = arg0_1.subRight:Find("fireworkPanel")
	arg0_1.springPanel = arg0_1.subRight:Find("springPanel")
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2:InitData()
	arg0_2:UpdateMainPt()

	arg0_2.firePools = {}

	arg0_2:PlayFireworks()
	arg0_2:InitStudents()
	arg0_2:SetTips()
	arg0_2:CloseSubPanel()

	arg0_2.hasClonedFireworkArrows = false

	onButton(arg0_2, arg0_2.backBtn, function()
		arg0_2:closeView()
	end)
	onButton(arg0_2, arg0_2.tipBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.firework_2025_tip.tip
		})
	end)
	onButton(arg0_2, arg0_2.ptBtn, function()
		arg0_2:OpenSubPanel(arg0_2.ptPanel)
		arg0_2:SetPtPanel()
	end)
	onButton(arg0_2, arg0_2.taskBtn, function()
		arg0_2:OpenSubPanel(arg0_2.taskPanel)
		arg0_2:SetTaskPanel()
	end)
	onButton(arg0_2, arg0_2.fireworkBtn, function()
		arg0_2:OpenSubPanel(arg0_2.fireworkPanel)
		arg0_2:SetFireWorkPanel()
	end)
	onButton(arg0_2, arg0_2.springBtn, function()
		arg0_2:OpenSubPanel(arg0_2.springPanel)
		arg0_2:SetSpringPanel()
	end)
	onButton(arg0_2, arg0_2.ptPanel:Find("btnClose"), function()
		arg0_2:CloseSubPanel()
		arg0_2:PlayFireworks()
	end)
	onButton(arg0_2, arg0_2.taskPanel:Find("btnClose"), function()
		arg0_2:CloseSubPanel()
		arg0_2:PlayFireworks()
	end)
	onButton(arg0_2, arg0_2.fireworkPanel:Find("btnClose"), function()
		arg0_2:CloseSubPanel()
		arg0_2:PlayFireworks()
	end)
	onButton(arg0_2, arg0_2.springPanel:Find("btnClose"), function()
		arg0_2:CloseSubPanel()
		arg0_2:PlayFireworks()
	end)
	onButton(arg0_2, arg0_2.subPtBtn, function()
		arg0_2:SetSubPanel(arg0_2.ptPanel)
		arg0_2:SetPtPanel()
	end)
	onButton(arg0_2, arg0_2.subTaskBtn, function()
		arg0_2:SetSubPanel(arg0_2.taskPanel)
		arg0_2:SetTaskPanel()
	end)
	onButton(arg0_2, arg0_2.subFireworkBtn, function()
		arg0_2:SetSubPanel(arg0_2.fireworkPanel)
		arg0_2:SetFireWorkPanel()
	end)
	onButton(arg0_2, arg0_2.subSpringBtn, function()
		arg0_2:SetSubPanel(arg0_2.springPanel)
		arg0_2:SetSpringPanel()
	end)
end

function var0_0.OnUpdateFlush(arg0_17)
	arg0_17:UpdateTaskData()
	arg0_17:UpdatePtData()
	arg0_17:UpdateMainPt()
	arg0_17:SetTaskPanel()
	arg0_17:UpdateSpringData()
	arg0_17:SetPtPanel()
	arg0_17:SetTips()
	arg0_17:UpdateFireworkData()
	arg0_17:SetFireWorkPanel()

	if isActive(arg0_17.springPanel) then
		arg0_17:UpdateSpringActivityAndUI()
	end
end

function var0_0.InitData(arg0_18)
	arg0_18.ptActId = ActivityConst.HorseYearSpringFestival2026_ID_1
	arg0_18.taskActId = ActivityConst.HorseYearSpringFestival2026_ID_2
	arg0_18.fireworkActId = ActivityConst.HorseYearSpringFestival2026_ID_4
	arg0_18.springActId = ActivityConst.HorseYearSpringFestival2026_ID_3

	arg0_18:UpdatePtData()
	arg0_18:UpdateTaskData()
	arg0_18:UpdateFireworkData()
	arg0_18:UpdateSpringData()
end

function var0_0.UpdatePtData(arg0_19)
	arg0_19.ptActivity = getProxy(ActivityProxy):getActivityById(arg0_19.ptActId)
	arg0_19.ptData = ActivityPtData.New(arg0_19.ptActivity)
end

function var0_0.UpdateTaskData(arg0_20)
	arg0_20.taskActivity = getProxy(ActivityProxy):getActivityById(arg0_20.taskActId)
	arg0_20.taskVOs = {}

	local var0_20 = arg0_20.taskActivity:getConfig("config_data")

	for iter0_20, iter1_20 in pairs(var0_20) do
		table.insert(arg0_20.taskVOs, getProxy(TaskProxy):getTaskVO(iter1_20))
	end

	arg0_20.canGetTaskVOs = {}
	arg0_20.canGetTaskIds = {}

	arg0_20:sort(arg0_20.taskVOs)
end

function var0_0.sort(arg0_21, arg1_21)
	local var0_21 = {}

	arg0_21.canGetTaskAward = false

	for iter0_21, iter1_21 in pairs(arg1_21) do
		if iter1_21:getTaskStatus() == 1 then
			table.insert(var0_21, iter1_21)
			table.insert(arg0_21.canGetTaskVOs, iter1_21)
			table.insert(arg0_21.canGetTaskIds, iter1_21.id)

			arg0_21.canGetTaskAward = true
		end
	end

	for iter2_21, iter3_21 in pairs(arg1_21) do
		if iter3_21:getTaskStatus() == 0 then
			table.insert(var0_21, iter3_21)
		end
	end

	for iter4_21, iter5_21 in pairs(arg1_21) do
		if iter5_21:getTaskStatus() == 2 then
			table.insert(var0_21, iter5_21)
		end
	end

	arg0_21.taskVOs = var0_21
end

function var0_0.UpdateFireworkData(arg0_22)
	arg0_22.fireworkActivity = getProxy(ActivityProxy):getActivityById(arg0_22.fireworkActId)
	arg0_22.fireworkUnlockIds = arg0_22.fireworkActivity.data1_list
	arg0_22.fireworkGotIds = arg0_22.fireworkActivity.data2_list
	arg0_22.fireworkAllIds = arg0_22.fireworkActivity:GetPicturePuzzleIds()
	arg0_22.playerId = getProxy(PlayerProxy):getData().id
	arg0_22.fireworkOrderIds = arg0_22:GetFireWorkLocalData()
end

function var0_0.GetFireWorkLocalData(arg0_23)
	local var0_23 = {}

	for iter0_23 = 1, #arg0_23.fireworkAllIds do
		local var1_23 = PlayerPrefs.GetInt("fireworks_" .. arg0_23.fireworkActId .. "_" .. arg0_23.playerId .. "_pos_" .. iter0_23)

		if var1_23 ~= 0 then
			table.insert(var0_23, var1_23)
		end
	end

	return var0_23
end

function var0_0.SetFireWorkLocalData(arg0_24)
	for iter0_24 = 1, #arg0_24.fireworkAllIds do
		local var0_24 = arg0_24.fireworkOrderIds[iter0_24] or 0

		PlayerPrefs.SetInt("fireworks_" .. arg0_24.fireworkActId .. "_" .. arg0_24.playerId .. "_pos_" .. iter0_24, var0_24)
	end
end

function var0_0.UpdateSpringData(arg0_25)
	arg0_25.springActivity = getProxy(ActivityProxy):getActivityById(arg0_25.springActId)
	arg0_25.springShipIds = _.map(arg0_25.springActivity:GetShipIds(), function(arg0_26)
		if getProxy(BayProxy):RawGetShipById(arg0_26) then
			return arg0_26
		else
			return 0
		end
	end)
	arg0_25.springMaxCnt = arg0_25.springActivity:GetSlotCount()
	arg0_25.springSlotLockList = {}
	arg0_25.springUnlockSlotCount = arg0_25.springActivity:getConfig("config_client").initialCount

	for iter0_25, iter1_25 in ipairs(arg0_25.springActivity:getConfig("config_client").unlockPt) do
		if iter1_25 <= arg0_25.ptData.count then
			arg0_25.springUnlockSlotCount = arg0_25.springUnlockSlotCount + 1
		end
	end

	for iter2_25 = 1, arg0_25.springMaxCnt do
		local var0_25 = iter2_25 > arg0_25.springUnlockSlotCount

		arg0_25.springSlotLockList[iter2_25] = var0_25
	end

	arg0_25.energyRecoverAddition = arg0_25.springActivity:GetEnergyRecoverAddition() * 10
end

function var0_0.OpenSubPanel(arg0_27, arg1_27)
	setActive(arg0_27.subPanel, true)
	arg0_27:SetSubPanel(arg1_27)
end

function var0_0.CloseSubPanel(arg0_28)
	setActive(arg0_28.subPanel, false)
end

function var0_0.SetSubPanel(arg0_29, arg1_29)
	setActive(arg0_29.ptPanel, false)
	setActive(arg0_29.taskPanel, false)
	setActive(arg0_29.fireworkPanel, false)
	setActive(arg0_29.springPanel, false)
	setActive(arg1_29, true)
	setActive(arg0_29.subPtBtn:Find("selected"), arg1_29 == arg0_29.ptPanel)
	setActive(arg0_29.subTaskBtn:Find("selected"), arg1_29 == arg0_29.taskPanel)
	setActive(arg0_29.subFireworkBtn:Find("selected"), arg1_29 == arg0_29.fireworkPanel)
	setActive(arg0_29.subSpringBtn:Find("selected"), arg1_29 == arg0_29.springPanel)
end

function var0_0.UpdateMainPt(arg0_30)
	setText(arg0_30.stage, "Lv." .. arg0_30.ptData:GetCurrLevel())

	if not arg0_30.ptData:IsMaxLevel() then
		setText(arg0_30.pt, arg0_30.ptData.count .. "/" .. arg0_30.ptData:GetNextLevelTarget())
	else
		setText(arg0_30.pt, "MAX")
	end
end

function var0_0.SetPtPanel(arg0_31)
	setText(arg0_31.ptPanel:Find("lvText"), arg0_31.ptData:GetCurrLevel())

	if not arg0_31.ptData:IsMaxLevel() then
		setText(arg0_31.ptPanel:Find("pt"), arg0_31.ptData.count .. "/" .. arg0_31.ptData:GetNextLevelTarget())
		setSlider(arg0_31.ptPanel:Find("slider"), 0, arg0_31.ptData:GetNextLevelTarget(), arg0_31.ptData.count)
	else
		setText(arg0_31.ptPanel:Find("pt"), "MAX")
		setSlider(arg0_31.ptPanel:Find("slider"), 0, 1, 1)
	end

	setText(arg0_31.ptPanel:Find("ptScroll/Viewport/Content/tpl/get/Text"), i18n("firework_2025_get"))
	setText(arg0_31.ptPanel:Find("ptScroll/Viewport/Content/tpl/got/Text"), i18n("firework_2025_got"))

	local var0_31 = UIItemList.New(arg0_31.ptPanel:Find("ptScroll/Viewport/Content"), arg0_31.ptPanel:Find("ptScroll/Viewport/Content/tpl"))

	var0_31:make(function(arg0_32, arg1_32, arg2_32)
		if arg0_32 == UIItemList.EventUpdate then
			local var0_32 = arg0_31.ptData.dropList[arg1_32 + 1]
			local var1_32 = arg0_31.ptData.targets[arg1_32 + 1]

			setText(arg2_32:Find("level"), i18n("firework_2025_level", arg1_32 + 1))

			local var2_32 = Drop.Create(var0_32)

			updateDrop(arg2_32:Find("award"), var2_32)
			onButton(arg0_31, arg2_32:Find("award"), function()
				arg0_31:emit(BaseUI.ON_DROP, var2_32)
			end, SFX_PANEL)

			local var3_32 = arg0_31.ptData:GetDroptItemState(arg1_32 + 1)

			if var3_32 == ActivityPtData.STATE_LOCK then
				setActive(arg2_32:Find("lock"), true)
				setActive(arg2_32:Find("get"), false)
				setActive(arg2_32:Find("got"), false)
			elseif var3_32 == ActivityPtData.STATE_CAN_GET then
				setActive(arg2_32:Find("lock"), false)
				setActive(arg2_32:Find("get"), true)
				setActive(arg2_32:Find("got"), false)
			else
				setActive(arg2_32:Find("lock"), false)
				setActive(arg2_32:Find("get"), false)
				setActive(arg2_32:Find("got"), true)
			end
		end
	end)
	var0_31:align(#arg0_31.ptData.dropList)

	local var1_31 = rtf(arg0_31.ptPanel:Find("ptScroll/Viewport/Content/tpl")).rect.width
	local var2_31 = arg0_31.ptPanel:Find("ptScroll/Viewport/Content"):GetComponent(typeof(HorizontalLayoutGroup)).spacing
	local var3_31 = rtf(arg0_31.ptPanel:Find("ptScroll/Viewport")).rect.width

	scrollTo(arg0_31.ptPanel:Find("ptScroll"), arg0_31.ptData.level * (var1_31 + var2_31) / (#arg0_31.ptData.targets * (var1_31 + var2_31) - var2_31 - var3_31), 0)

	local var4_31 = 6

	arg0_31.importants = arg0_31.ptActivity:getConfig("config_client").highValueItemSort
	arg0_31.importantsPos = {}

	for iter0_31, iter1_31 in ipairs(arg0_31.importants) do
		table.insert(arg0_31.importantsPos, (iter1_31 - var4_31 - 1) * (var1_31 + var2_31) / (#arg0_31.ptData.targets * (var1_31 + var2_31) - var2_31 - var3_31))
	end

	arg0_31:PtScrollToDo(arg0_31.ptData.level * (var1_31 + var2_31) / (#arg0_31.ptData.targets * (var1_31 + var2_31) - var2_31 - var3_31))
	onScroll(arg0_31, arg0_31.ptPanel:Find("ptScroll"), function(arg0_34)
		arg0_31:PtScrollToDo(arg0_34.x)
	end)

	if arg0_31.ptData:CanGetAward() then
		setActive(arg0_31.ptPanel:Find("btn_get"), true)
		onButton(arg0_31, arg0_31.ptPanel:Find("btn_get"), function()
			local var0_35 = {}
			local var1_35 = arg0_31.ptData:GetAllAvailableAwards()
			local var2_35 = getProxy(PlayerProxy):getRawData()
			local var3_35 = pg.gameset.urpt_chapter_max.description[1]
			local var4_35 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_35)
			local var5_35, var6_35 = Task.StaticJudgeOverflow(var2_35.gold, var2_35.oil, var4_35, true, true, var1_35)

			if var5_35 then
				table.insert(var0_35, function(arg0_36)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("award_max_warning"),
						items = var6_35,
						onYes = arg0_36
					})
				end)
			end

			seriesAsync(var0_35, function()
				local var0_37 = arg0_31.ptData:GetCurrTarget()

				arg0_31:emit(ActivityMediator.EVENT_PT_OPERATION, {
					cmd = 4,
					activity_id = arg0_31.ptData:GetId(),
					arg1 = var0_37
				})
			end)
		end, SFX_PANEL)
	else
		setActive(arg0_31.ptPanel:Find("btn_get"), false)
		removeOnButton(arg0_31.ptPanel:Find("btn_get"))
	end

	setText(arg0_31.ptPanel:Find("ptName"), i18n("firework_2025_pt"))
end

function var0_0.PtScrollToDo(arg0_38, arg1_38)
	local var0_38 = 0

	for iter0_38, iter1_38 in ipairs(arg0_38.importantsPos) do
		if arg1_38 < iter1_38 or iter0_38 == #arg0_38.importants then
			var0_38 = arg0_38.importants[iter0_38]

			break
		end
	end

	local var1_38 = Drop.Create(arg0_38.ptData.dropList[var0_38])

	updateDrop(arg0_38.ptPanel:Find("award"), var1_38)
	onButton(arg0_38, arg0_38.ptPanel:Find("award"), function()
		arg0_38:emit(BaseUI.ON_DROP, var1_38)
	end, SFX_PANEL)
	setText(arg0_38.ptPanel:Find("awardInfo/Text"), i18n("firework_2025_level", var0_38))
	setActive(arg0_38.ptPanel:Find("award/got"), var0_38 <= arg0_38.ptData.level)
end

function var0_0.SetTaskPanel(arg0_40)
	setText(arg0_40.taskPanel:Find("lvText"), arg0_40.ptData:GetCurrLevel())

	if not arg0_40.ptData:IsMaxLevel() then
		setText(arg0_40.taskPanel:Find("pt"), arg0_40.ptData.count .. "/" .. arg0_40.ptData:GetNextLevelTarget())
		setSlider(arg0_40.taskPanel:Find("slider"), 0, arg0_40.ptData:GetNextLevelTarget(), arg0_40.ptData.count)
	else
		setText(arg0_40.taskPanel:Find("pt"), "MAX")
		setSlider(arg0_40.taskPanel:Find("slider"), 0, 1, 1)
	end

	local var0_40 = UIItemList.New(arg0_40.taskPanel:Find("taskScroll/Viewport/Content"), arg0_40.taskPanel:Find("taskScroll/Viewport/Content/Tasktpl"))

	var0_40:make(function(arg0_41, arg1_41, arg2_41)
		if arg0_41 == UIItemList.EventUpdate then
			local var0_41 = arg0_40.taskVOs[arg1_41 + 1]

			setText(arg2_41:Find("frame/name"), var0_41:getConfig("name"))
			setText(arg2_41:Find("frame/desc"), var0_41:getConfig("desc"))

			local var1_41 = var0_41:getProgress()
			local var2_41 = var0_41:getConfig("target_num")
			local var3_41 = math.min(var1_41, var2_41)

			setText(arg2_41:Find("frame/progress"), var3_41 .. "/" .. var2_41)

			arg2_41:Find("frame/slider"):GetComponent(typeof(Slider)).value = var3_41 / var2_41

			local var4_41 = arg2_41:Find("frame/awards")
			local var5_41 = var4_41:GetChild(0)

			arg0_40:updateTaskAwards(var0_41:getConfig("award_display"), var4_41, var5_41)

			local var6_41 = arg2_41:Find("frame/go_btn")
			local var7_41 = arg2_41:Find("frame/get_btn")
			local var8_41 = arg2_41:Find("frame/got_btn")

			if var0_41:getTaskStatus() == 0 then
				setActive(var6_41, true)
				setActive(var7_41, false)
				setActive(var8_41, false)
			elseif var0_41:getTaskStatus() == 1 then
				setActive(var6_41, false)
				setActive(var7_41, true)
				setActive(var8_41, false)
			elseif var0_41:getTaskStatus() == 2 then
				setActive(var6_41, false)
				setActive(var7_41, false)
				setActive(var8_41, true)
			end

			onButton(arg0_40, var6_41, function()
				arg0_40:emit(ActivityMediator.ON_TASK_GO, var0_41)
			end, SFX_PANEL)
			onButton(arg0_40, var7_41, function()
				arg0_40:emit(ActivityMediator.ON_TASK_SUBMIT, var0_41)
			end, SFX_PANEL)
		end
	end)
	var0_40:align(#arg0_40.taskVOs)

	if arg0_40.canGetTaskAward then
		setActive(arg0_40.taskPanel:Find("btn_get"), true)
		onButton(arg0_40, arg0_40.taskPanel:Find("btn_get"), function()
			local var0_44 = {}
			local var1_44 = {}

			for iter0_44, iter1_44 in pairs(arg0_40.canGetTaskVOs) do
				local var2_44 = iter1_44:getConfig("award_display")

				for iter2_44, iter3_44 in ipairs(var2_44) do
					local var3_44 = iter3_44
					local var4_44 = false

					for iter4_44, iter5_44 in pairs(var1_44) do
						if iter5_44[1] == var3_44[1] and iter5_44[2] == var3_44[2] then
							var4_44 = true
							iter5_44[3] = iter5_44[3] + var3_44[3]

							break
						end
					end

					if not var4_44 then
						table.insert(var1_44, var3_44)
					end
				end
			end

			local var5_44 = getProxy(PlayerProxy):getRawData()
			local var6_44 = pg.gameset.urpt_chapter_max.description[1]
			local var7_44 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var6_44)
			local var8_44, var9_44 = Task.StaticJudgeOverflow(var5_44.gold, var5_44.oil, var7_44, true, true, var1_44)

			if var8_44 then
				table.insert(var0_44, function(arg0_45)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("award_max_warning"),
						items = var9_44,
						onYes = arg0_45
					})
				end)
			end

			seriesAsync(var0_44, function()
				arg0_40:emit(ActivityMediator.ON_ACTIVITY_TASK_LIST_SUBMIT, {
					activityId = arg0_40.taskActId,
					ids = arg0_40.canGetTaskIds
				})
			end)
		end, SFX_PANEL)
	else
		setActive(arg0_40.taskPanel:Find("btn_get"), false)
		removeOnButton(arg0_40.taskPanel:Find("btn_get"))
	end

	setText(arg0_40.taskPanel:Find("ptName"), i18n("firework_2025_pt"))
end

function var0_0.updateTaskAwards(arg0_47, arg1_47, arg2_47, arg3_47)
	local var0_47 = _.slice(arg1_47, 1, 3)

	for iter0_47 = arg2_47.childCount, #var0_47 - 1 do
		cloneTplTo(arg3_47, arg2_47)
	end

	local var1_47 = arg2_47.childCount

	for iter1_47 = 1, var1_47 do
		local var2_47 = arg2_47:GetChild(iter1_47 - 1)
		local var3_47 = iter1_47 <= #var0_47

		setActive(var2_47, var3_47)

		if var3_47 then
			local var4_47 = var0_47[iter1_47]
			local var5_47 = {
				type = var4_47[1],
				id = var4_47[2],
				count = var4_47[3]
			}

			updateDrop(var2_47, var5_47)
			onButton(arg0_47, var2_47, function()
				arg0_47:emit(BaseUI.ON_DROP, var5_47)
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetFireWorkPanel(arg0_49)
	local var0_49 = arg0_49.fireworkPanel:Find("left_panel")
	local var1_49 = arg0_49.fireworkPanel:Find("right_panel")
	local var2_49 = var1_49:Find("fire_btn")
	local var3_49 = var0_49:Find("scrollrect/content/item_tpl")
	local var4_49 = var0_49:Find("scrollrect/content")

	arg0_49.leftUIList = UIItemList.New(var4_49, var3_49)

	local var5_49 = var1_49:Find("content/item_tpl")
	local var6_49 = var1_49:Find("content")

	arg0_49.rightUIList = UIItemList.New(var6_49, var5_49)

	local var7_49 = var1_49:Find("arrows")

	onButton(arg0_49, var2_49, function()
		arg0_49:CloseSubPanel()
		arg0_49:PlayFireworks()
	end)
	setText(var1_49:Find("tip"), i18n("activity_yanhua_tip7"))
	setText(var0_49:Find("tip"), i18n("firework_2025_tip1"))
	arg0_49.leftUIList:make(function(arg0_51, arg1_51, arg2_51)
		if arg0_51 == UIItemList.EventUpdate then
			local var0_51 = arg0_49.fireworkAllIds[arg1_51 + 1]
			local var1_51 = arg2_51:Find("firework/icon")

			GetImageSpriteFromAtlasAsync(Item.getConfigData(var0_51).icon, "", var1_51)

			local var2_51 = arg2_51:Find("firework/selected")
			local var3_51 = table.contains(arg0_49.fireworkOrderIds, var0_51)

			setActive(var2_51, var3_51)

			if not table.contains(arg0_49.fireworkUnlockIds, var0_51) then
				setActive(arg2_51:Find("firework/lock"), true)
				setActive(arg2_51:Find("firework/get"), false)
			elseif not table.contains(arg0_49.fireworkGotIds, var0_51) then
				setActive(arg2_51:Find("firework/lock"), false)
				setActive(arg2_51:Find("firework/get"), true)
				onButton(arg0_49, arg2_51, function()
					warning("       self.fireworkActI         ", arg0_49.fireworkActId, PuzzleActivity.CMD_ACTIVATE, var0_51)
					arg0_49:emit(ActivityMediator.ACTIVITY_OPERATION, arg0_49.fireworkActId, PuzzleActivity.CMD_ACTIVATE, var0_51)
				end, SFX_PANEL)
			else
				setActive(arg2_51:Find("firework/lock"), false)
				setActive(arg2_51:Find("firework/get"), false)
				onButton(arg0_49, arg2_51, function()
					arg0_49:FireworkLeftClick(var0_51, var3_51)
				end, SFX_PANEL)
			end
		end
	end)
	arg0_49.leftUIList:align(#arg0_49.fireworkAllIds)

	if not arg0_49.hasClonedFireworkArrows then
		arg0_49.hasClonedFireworkArrows = true

		for iter0_49 = 1, #arg0_49.fireworkAllIds - 2 do
			cloneTplTo(var7_49:Find("tpl"), var7_49)
		end
	end

	arg0_49.rightUIList:make(function(arg0_54, arg1_54, arg2_54)
		if arg0_54 == UIItemList.EventUpdate then
			local var0_54 = arg1_54 + 1
			local var1_54 = arg2_54:Find("icon")

			setActive(arg2_54:Find("add"), var0_54 > #arg0_49.fireworkOrderIds)

			if var0_54 > #arg0_49.fireworkOrderIds then
				setActive(var1_54, false)
			else
				local var2_54 = arg0_49.fireworkOrderIds[var0_54]

				setActive(var1_54, true)
				GetImageSpriteFromAtlasAsync(Item.getConfigData(var2_54).icon, "", var1_54)
				onButton(arg0_49, var1_54, function()
					arg0_49:FireworkRightClick(var2_54)
				end, SFX_PANEL)
			end
		end
	end)
	arg0_49.rightUIList:align(#arg0_49.fireworkAllIds)
end

function var0_0.FireworkLeftClick(arg0_56, arg1_56, arg2_56)
	if arg2_56 then
		table.removebyvalue(arg0_56.fireworkOrderIds, arg1_56)
	else
		table.insert(arg0_56.fireworkOrderIds, arg1_56)
	end

	arg0_56:SetFireWorkLocalData()
	arg0_56.leftUIList:align(#arg0_56.fireworkAllIds)
	arg0_56.rightUIList:align(#arg0_56.fireworkAllIds)
end

function var0_0.FireworkRightClick(arg0_57, arg1_57)
	table.removebyvalue(arg0_57.fireworkOrderIds, arg1_57)
	arg0_57:SetFireWorkLocalData()
	arg0_57.leftUIList:align(#arg0_57.fireworkAllIds)
	arg0_57.rightUIList:align(#arg0_57.fireworkAllIds)
end

function var0_0.SetSpringPanel(arg0_58)
	arg0_58:CreateSpringUI()
	arg0_58:UpdateSpringUI()
end

function var0_0.CreateSpringUI(arg0_59)
	setText(arg0_59.springPanel:Find("list/iconTpl/lock/Text"), i18n("firework_2025_unlock_tip1"))

	arg0_59.springList = UIItemList.New(arg0_59.springPanel:Find("list"), arg0_59.springPanel:Find("list/iconTpl"))

	arg0_59.springList:make(function(arg0_60, arg1_60, arg2_60)
		if arg0_60 == UIItemList.EventUpdate then
			local var0_60 = arg0_59.springShipIds[arg1_60 + 1]
			local var1_60 = arg0_59.springSlotLockList[arg1_60 + 1]
			local var2_60 = var0_60 and var0_60 > 0

			setActive(arg2_60:Find("lock"), var1_60)
			setActive(arg2_60:Find("add"), not var1_60 and not var2_60)
			setActive(arg2_60:Find("ship"), not var1_60 and var2_60)

			if var1_60 then
				setText(arg2_60:Find("lock/taskText"), i18n("firework_2025_unlock_tip2", arg0_59.springActivity:getConfig("config_client").unlockPt[arg1_60 + 1 - arg0_59.springActivity:getConfig("config_client").initialCount]))
			end

			onButton(arg0_59, arg2_60, function()
				if var1_60 then
					return
				end

				local var0_61

				if var2_60 then
					var0_61 = getProxy(BayProxy):getShipById(var0_60)
				end

				local var1_61 = arg0_59.springUnlockSlotCount

				arg0_59:StopPlayFireworks()
				arg0_59:emit(CoreActivityMainMediator.OPEN_CHUANWU, arg0_59.springActId, arg1_60 + 1, var0_61, arg0_59.springUnlockSlotCount)
			end, SFX_PANEL)

			if not var2_60 then
				return
			end

			local var3_60 = getProxy(BayProxy):RawGetShipById(var0_60)
			local var4_60 = LoadSprite("shipyardicon/" .. var3_60:getPainting())

			setImageSprite(arg2_60:Find("ship/mask/icon"), var4_60)
			setScrollText(arg2_60:Find("ship/name/Text"), var3_60:getName())
		end
	end)
	setText(arg0_59.springPanel:Find("tipText1"), i18n("firework_2025_tip2"))
	setText(arg0_59.springPanel:Find("tipText2"), "+" .. arg0_59.energyRecoverAddition .. "/h")
end

function var0_0.UpdateSpringUI(arg0_62)
	arg0_62.springList:align(arg0_62.springMaxCnt)
end

function var0_0.UpdateSpringActivityAndUI(arg0_63)
	arg0_63:UpdateSpringData()
	arg0_63:UpdateSpringUI()
	arg0_63:clearStudents()
	arg0_63:InitStudents()
end

function var0_0.PlayFireworks(arg0_64)
	arg0_64.fireworks = Clone(arg0_64.fireworkOrderIds)

	if #arg0_64.fireworks == 0 then
		return
	end

	eachChild(arg0_64.fireworksTF, function(arg0_65)
		setActive(arg0_65, false)
	end)
	setActive(arg0_64.fireworksTF, true)
	arg0_64:StopFireworksTimer()

	arg0_64.fireworkIndex = 1
	arg0_64.fireworksTimer = Timer.New(function()
		arg0_64:PlayerOneFirework()
	end, var0_0.EffectInterval, #arg0_64.fireworks)

	arg0_64.fireworksTimer:Start()
end

function var0_0.PlayerOneFirework(arg0_67)
	if arg0_67.fireworkIndex == #arg0_67.fireworks then
		arg0_67:managedTween(LeanTween.delayedCall, function()
			if arg0_67.fireworks then
				arg0_67:StopPlayFireworks()
				arg0_67:PlayFireworks()
			end
		end, var0_0.DelayPop, nil)
	end

	local var0_67 = arg0_67.fireworks[arg0_67.fireworkIndex]
	local var1_67 = math.random(#var0_0.SFX_LIST)

	if arg0_67.firePools[var0_67] and #arg0_67.firePools[var0_67] >= var0_0.EffectPoolCnt then
		local var2_67 = arg0_67.firePools[var0_67][1]

		setLocalPosition(var2_67, arg0_67:GetFireworkPos())
		setActive(var2_67, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_0.SFX_LIST[var1_67])
		table.removebyvalue(arg0_67.firePools[var0_67], var2_67)
		table.insert(arg0_67.firePools[var0_67], var2_67)
	else
		arg0_67.loader:GetPrefab("ui/" .. var0_0.Id2EffectName[var0_67], "", function(arg0_69)
			pg.ViewUtils.SetSortingOrder(arg0_69, 1)
			setParent(arg0_69, arg0_67.fireworksTF)
			setLocalPosition(arg0_69, arg0_67:GetFireworkPos())
			setActive(arg0_69, true)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_0.SFX_LIST[var1_67])

			if not arg0_67.firePools[var0_67] then
				arg0_67.firePools[var0_67] = {}
			end

			table.insert(arg0_67.firePools[var0_67], arg0_69)
		end)
	end

	arg0_67.fireworkIndex = arg0_67.fireworkIndex + 1
end

function var0_0.GetFireworkPos(arg0_70)
	local var0_70 = Vector2(0, 0)

	if arg0_70.lastPos then
		local var1_70 = Vector2(arg0_70.lastPos.x, arg0_70.lastPos.y)
		local var2_70 = math.abs(var1_70.x - arg0_70.lastPos.x)
		local var3_70 = math.abs(var1_70.y - arg0_70.lastPos.y)

		while var2_70 < var0_0.FireworkRange.x / 2 and var3_70 < var0_0.FireworkRange.y or var3_70 < var0_0.FireworkRange.y / 2 and var2_70 < var0_0.FireworkRange.x do
			var1_70.x = math.random(var0_0.EffectPosLimit.limitX[1], var0_0.EffectPosLimit.limitX[2])
			var1_70.y = math.random(var0_0.EffectPosLimit.limitY[1], var0_0.EffectPosLimit.limitY[2])
			var2_70 = math.abs(var1_70.x - arg0_70.lastPos.x)
			var3_70 = math.abs(var1_70.y - arg0_70.lastPos.y)
		end

		var0_70 = var1_70
	else
		var0_70.x = math.random(var0_0.EffectPosLimit.limitX[1], var0_0.EffectPosLimit.limitX[2])
		var0_70.y = math.random(var0_0.EffectPosLimit.limitY[1], var0_0.EffectPosLimit.limitY[2])
	end

	arg0_70.lastPos = var0_70

	return var0_70
end

function var0_0.StopFireworksTimer(arg0_71)
	if arg0_71.fireworksTimer then
		arg0_71.fireworksTimer:Stop()

		arg0_71.fireworksTimer = nil
	end
end

function var0_0.StopPlayFireworks(arg0_72)
	arg0_72:StopFireworksTimer()

	arg0_72.fireworks = nil
	arg0_72.fireworkIndex = nil

	setActive(arg0_72.fireworksTF, false)
end

function var0_0.getStudents(arg0_73, arg1_73, arg2_73)
	local var0_73 = {}
	local var1_73 = {}

	if not arg0_73.springActivity then
		return var0_73
	end

	local var2_73 = arg0_73.springActivity:GetShipIds()

	for iter0_73 = 1, arg0_73.springMaxCnt do
		if var2_73[iter0_73] and var2_73[iter0_73] ~= 0 then
			local var3_73 = getProxy(BayProxy):RawGetShipById(var2_73[iter0_73])

			if var3_73 then
				table.insert(var1_73, var3_73)
			end
		end
	end

	if not arg1_73 or not arg2_73 then
		arg1_73 = #var1_73
		arg2_73 = #var1_73
	end

	local var4_73 = math.random(arg1_73, arg2_73)
	local var5_73 = #var1_73

	while var4_73 > 0 and var5_73 > 0 do
		local var6_73 = math.random(1, var5_73)

		table.insert(var0_73, var1_73[var6_73]:getPrefab())

		var1_73[var6_73] = var1_73[var5_73]
		var5_73 = var5_73 - 1
		var4_73 = var4_73 - 1
	end

	return var0_73
end

function var0_0.InitStudents(arg0_74, arg1_74, arg2_74)
	local var0_74 = arg0_74:getStudents(arg1_74, arg2_74)
	local var1_74 = {}

	for iter0_74, iter1_74 in pairs(arg0_74.graphPath.points) do
		if not iter1_74.outRandom then
			table.insert(var1_74, iter1_74)
		end
	end

	local var2_74 = #var1_74

	arg0_74.academyStudents = {}

	local var3_74 = {}

	for iter2_74, iter3_74 in pairs(var0_74) do
		if not arg0_74.academyStudents[iter2_74] then
			local var4_74 = cloneTplTo(arg0_74._shipTpl, arg0_74._map)

			var4_74.gameObject.name = iter2_74

			local var5_74 = arg0_74:ChooseRandomPos(var1_74, var2_74)

			var2_74 = (var2_74 - 2) % #var1_74 + 1

			local var6_74 = SummerFeastNavigationAgent.New(var4_74.gameObject)

			var6_74.normalSpeed = 100

			var6_74:attach()
			var6_74:setPathFinder(arg0_74.graphPath)
			var6_74:SetPositionTable(var3_74)
			var6_74:setCurrentIndex(var5_74 and var5_74.id)
			var6_74:SetOnTransEdge(function(arg0_75, arg1_75, arg2_75)
				arg1_75, arg2_75 = math.min(arg1_75, arg2_75), math.max(arg1_75, arg2_75)

				local var0_75 = arg0_74[arg0_74.edge2area[arg1_75 .. "_" .. arg2_75] or arg0_74.edge2area.default]

				arg0_75._tf:SetParent(var0_75)
			end)
			var6_74:updateStudent(iter3_74)

			arg0_74.academyStudents[iter2_74] = var6_74
		end
	end

	if #var0_74 > 0 then
		arg0_74.sortTimer = Timer.New(function()
			arg0_74:sortStudents()
		end, 0.2, -1)

		arg0_74.sortTimer:Start()
		arg0_74.sortTimer.func()
	end
end

function var0_0.ChooseRandomPos(arg0_77, arg1_77, arg2_77)
	local var0_77 = math.random(1, arg2_77)

	if not var0_77 then
		return nil
	end

	pg.Tool.Swap(arg1_77, var0_77, arg2_77)

	return arg1_77[arg2_77]
end

function var0_0.SetTips(arg0_78)
	arg0_78:SetPtTip()
	arg0_78:SetTaskTip()
	arg0_78:SetFireworkTip()
	arg0_78:SetSpringTip()
end

function var0_0.SetPtTip(arg0_79)
	local var0_79 = arg0_79.ptData:CanGetAward()

	setActive(arg0_79.ptBtn:Find("tip"), var0_79)
	setActive(arg0_79.subPtBtn:Find("tip"), var0_79)
end

function var0_0.SetTaskTip(arg0_80)
	local var0_80 = arg0_80.canGetTaskAward

	setActive(arg0_80.taskBtn:Find("tip"), var0_80)
	setActive(arg0_80.subTaskBtn:Find("tip"), var0_80)
end

function var0_0.SetFireworkTip(arg0_81)
	local var0_81 = #arg0_81.fireworkUnlockIds ~= #arg0_81.fireworkGotIds

	setActive(arg0_81.fireworkBtn:Find("tip"), var0_81)
	setActive(arg0_81.subFireworkBtn:Find("tip"), var0_81)
end

function var0_0.SetSpringTip(arg0_82)
	local var0_82 = false

	for iter0_82 = 1, arg0_82.springUnlockSlotCount do
		if arg0_82.springShipIds[iter0_82] == 0 then
			var0_82 = true

			break
		end
	end

	setActive(arg0_82.springBtn:Find("tip"), var0_82)
	setActive(arg0_82.subSpringBtn:Find("tip"), var0_82)
end

function var0_0.OnDestroy(arg0_83)
	arg0_83:CloseSubPanel()
	arg0_83:StopPlayFireworks()
	arg0_83:clearStudents()
	var0_0.super.OnDestroy(arg0_83)
end

return var0_0
