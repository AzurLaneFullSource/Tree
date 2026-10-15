local var0_0 = class("StarLightMedalAlbumView", import("view.base.BaseUI"))

var0_0.ICON_SCALE = 1.35
var0_0.MEDAL_COUNT = 8

local function var1_0(arg0_1)
	local var0_1 = pg.activity_template[arg0_1.id].config_data

	return _.any(var0_1, function(arg0_2)
		return Task.New({
			id = arg0_2
		}):HasActMedalAward()
	end)
end

local function var2_0()
	local var0_3 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASKS)

	for iter0_3, iter1_3 in ipairs(var0_3) do
		if var1_0(iter1_3) then
			return iter1_3
		end
	end

	return nil
end

function var0_0.GetHelpTips(arg0_4)
	local var0_4 = var2_0()

	if not var0_4 then
		return ""
	end

	local var1_4 = var0_4:GetActivityTimeStr()
	local var2_4 = string.split(var1_4, "-")
	local var3_4 = pg.gametip.help_starLightAlbum.tip

	_.each(var3_4, function(arg0_5)
		arg0_5.info = string.gsub(arg0_5.info, "$1", var2_4[2])
	end)

	return var3_4
end

function var0_0.getResource(arg0_6)
	local var0_6 = {}
	local var1_6 = arg0_6.GROUP_ID
	local var2_6 = var1_6 and pg.activity_medal_group[var1_6]

	if var2_6 and var2_6.item_show then
		local var3_6 = {}

		local function var4_6(arg0_7)
			if noEmptyStr(arg0_7) and not table.contains(var3_6, arg0_7) then
				table.insert(var3_6, arg0_7)
			end
		end

		for iter0_6, iter1_6 in ipairs(var2_6.item_show) do
			if iter1_6 and #iter1_6 > 0 then
				local var5_6 = Drop.New({
					type = iter1_6[1],
					id = iter1_6[2],
					count = iter1_6[3] or 1
				})
				local var6_6 = var5_6:getIcon()

				if var5_6.type == DROP_TYPE_FURNITURE then
					var6_6 = "furnitureicon/" .. var6_6
				end

				var4_6(var6_6)
			end
		end

		for iter2_6, iter3_6 in ipairs(var3_6) do
			table.insert(var0_6, iter3_6)
		end
	end

	table.insertto(var0_6, var0_0.super.getResource(arg0_6))

	return var0_6
end

function var0_0.SetMedalGroupData(arg0_8, arg1_8)
	arg0_8.medalGroupList = arg1_8
	arg0_8.currentMedalGroup = arg0_8.medalGroupList[arg0_8.GROUP_ID] or ActivityMedalGroup.New(arg0_8.GROUP_ID)

	if arg0_8.currentMedalGroup:GetMedalGroupState() == ActivityMedalGroup.STATE_ACTIVE then
		arg0_8.medalTaskView:SetMedalGroup(arg0_8.currentMedalGroup)
	end

	arg0_8.medalDetailView:SetMedalGroup(arg0_8.currentMedalGroup)

	local var0_8 = arg0_8.currentMedalGroup:GetMedalIds()

	for iter0_8 = 1, arg0_8.MEDAL_COUNT do
		local var1_8 = var0_8[iter0_8]

		LoadImageSpriteAsync("activitymedal/" .. var1_8 .. "_l", arg0_8.slots[iter0_8].slot, true)
		LoadImageSpriteAsync("activitymedal/" .. var1_8, arg0_8.slots[iter0_8].active, true)
	end
end

function var0_0.ShowPageBtn(arg0_9, arg1_9)
	setActive(arg0_9.prevBtn, false)
	setActive(arg0_9.nextBtn, false)
end

function var0_0.UpdateMedalList(arg0_10)
	return
end

function var0_0.init(arg0_11)
	arg0_11:FindUI()

	arg0_11.loader = AutoLoader.New()
end

function var0_0.FindUI(arg0_12)
	local var0_12 = arg0_12._tf:Find("Top")

	arg0_12.bg = arg0_12._tf:Find("mask")
	arg0_12.backBtn = var0_12:Find("BackBtn")
	arg0_12.helpBtn = var0_12:Find("InfoBtn")
	arg0_12.taskBtn = arg0_12._tf:Find("Desk/taskBtn")
	arg0_12.prevBtn = arg0_12._tf:Find("Desk/prevBtn")
	arg0_12.nextBtn = arg0_12._tf:Find("Desk/nextBtn")
	arg0_12.slots = {}

	for iter0_12 = 1, arg0_12.MEDAL_COUNT do
		arg0_12.slots[iter0_12] = {
			slot = arg0_12._tf:Find("Desk/Slot" .. iter0_12),
			active = arg0_12._tf:Find("Desk/Slot" .. iter0_12 .. "/active"),
			tips = arg0_12._tf:Find("Desk/Slot" .. iter0_12 .. "/reddot"),
			click = arg0_12._tf:Find("Desk/Slot" .. iter0_12 .. "/Click")
		}
	end

	arg0_12.medalLock = arg0_12._tf:Find("Desk/medal")
	arg0_12.trophyLock = arg0_12._tf:Find("Desk/trophy")
	arg0_12.medalDetailView = MedalDetailPanel.New(arg0_12._tf:Find("DetailView"), arg0_12)

	arg0_12.medalDetailView:SetIconScale(arg0_12.ICON_SCALE)

	arg0_12.medalTaskView = MedalTaskPanel.New(arg0_12._tf:Find("TaskView"), arg0_12)
end

function var0_0.didEnter(arg0_13)
	var0_0.super.didEnter(arg0_13)
	arg0_13:AddListener()
	arg0_13:UpdateView()
	pg.UIMgr.GetInstance():BlurPanel(arg0_13._tf)
end

function var0_0.AddListener(arg0_14)
	onButton(arg0_14, arg0_14.backBtn, function()
		arg0_14:closeView()
	end, SFX_CANCEL)

	for iter0_14 = 1, arg0_14.MEDAL_COUNT do
		onButton(arg0_14, arg0_14.slots[iter0_14].click, function()
			arg0_14:showMedalView(iter0_14)
		end)
	end

	onButton(arg0_14, arg0_14.taskBtn, function()
		arg0_14:showTaskView()
	end)
	onButton(arg0_14, arg0_14.bg, function()
		arg0_14:closeView()
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.helpBtn, function()
		local var0_19 = arg0_14:GetHelpTips()

		if not var0_19 or var0_19 == "" then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0_19
		})
	end)
	onButton(arg0_14, arg0_14.medalLock, function()
		local var0_20 = arg0_14.currentMedalGroup:getConfig("item_show")[2]
		local var1_20 = {
			type = var0_20[1],
			id = var0_20[2],
			count = var0_20[3]
		}

		arg0_14:emit(BaseUI.ON_DROP, var1_20)
	end, SFX_PANEL)

	if arg0_14.trophyLock then
		onButton(arg0_14, arg0_14.trophyLock, function()
			local var0_21 = arg0_14.currentMedalGroup:getConfig("item_show")[1]
			local var1_21 = {
				type = var0_21[1],
				id = var0_21[2],
				count = var0_21[3]
			}

			arg0_14:emit(BaseUI.ON_DROP, var1_21)
		end, SFX_PANEL)
	end
end

function var0_0.showMedalView(arg0_22, arg1_22)
	arg0_22.medalDetailView:SetCurrentIndex(arg1_22)
	arg0_22.medalDetailView:UpdateMedal()
	arg0_22.medalDetailView:SetActive(true)
end

function var0_0.showTaskView(arg0_23)
	arg0_23.medalTaskView:ShowMedalTask()
	arg0_23.medalTaskView:SetActive(true)
end

function var0_0.UpdateView(arg0_24)
	local var0_24 = arg0_24.currentMedalGroup:GetMedalIds()
	local var1_24 = arg0_24.currentMedalGroup:GetMedalList()

	for iter0_24 = 1, arg0_24.MEDAL_COUNT do
		local var2_24 = var0_24[iter0_24]
		local var3_24 = arg0_24.slots[iter0_24]

		if var1_24[var2_24].timeStamp then
			setActive(var3_24.active, true)
		else
			setActive(var3_24.active, false)
		end
	end

	if arg0_24.trophyLock then
		arg0_24.trophyLock:GetComponent(typeof(Image)).enabled = not arg0_24:OwnTrophy()
	end

	arg0_24.medalLock:GetComponent(typeof(Image)).enabled = not arg0_24:OwnMedal()

	setActive(arg0_24.taskBtn, arg0_24.currentMedalGroup:GetMedalGroupState() == ActivityMedalGroup.STATE_ACTIVE)
end

function var0_0.OwnTrophy(arg0_25)
	local var0_25 = arg0_25.currentMedalGroup:getConfig("task_show")
	local var1_25 = -1

	if var0_25 and type(var0_25) == "table" then
		var1_25 = var0_25[1]
	end

	if var1_25 <= 0 then
		return false
	end

	local var2_25 = pg.task_data_template[var1_25].award_display[1]

	return Task.OwnSpAward(var2_25)
end

function var0_0.OwnMedal(arg0_26)
	local var0_26 = arg0_26.currentMedalGroup:getConfig("task_show")
	local var1_26 = -1

	if var0_26 and type(var0_26) == "table" then
		var1_26 = var0_26[2]
	end

	if var1_26 <= 0 then
		return false
	end

	local var2_26 = pg.task_data_template[var1_26].award_display
	local var3_26 = var2_26[#var2_26]

	return Task.OwnSpAward(var3_26)
end

function var0_0.FlushTaskPanel(arg0_27)
	arg0_27.medalTaskView:SetMedalGroup(arg0_27.currentMedalGroup)
	arg0_27.medalTaskView:ShowMedalTask()
end

function var0_0.willExit(arg0_28)
	arg0_28.medalDetailView:SetActive(false)
	arg0_28.medalTaskView:SetActive(false)
	arg0_28.medalDetailView:Dispose()
	arg0_28.medalTaskView:Dispose()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_28._tf)
	arg0_28.loader:Clear()
end

return var0_0
