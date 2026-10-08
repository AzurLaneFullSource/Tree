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

function var0_0.SetMedalGroupData(arg0_6, arg1_6)
	arg0_6.medalGroupList = arg1_6
	arg0_6.currentMedalGroup = arg0_6.medalGroupList[arg0_6.GROUP_ID] or ActivityMedalGroup.New(arg0_6.GROUP_ID)

	if arg0_6.currentMedalGroup:GetMedalGroupState() == ActivityMedalGroup.STATE_ACTIVE then
		arg0_6.medalTaskView:SetMedalGroup(arg0_6.currentMedalGroup)
	end

	arg0_6.medalDetailView:SetMedalGroup(arg0_6.currentMedalGroup)

	local var0_6 = arg0_6.currentMedalGroup:GetMedalIds()

	for iter0_6 = 1, arg0_6.MEDAL_COUNT do
		local var1_6 = var0_6[iter0_6]

		LoadImageSpriteAsync("activitymedal/" .. var1_6 .. "_l", arg0_6.slots[iter0_6].slot, true)
		LoadImageSpriteAsync("activitymedal/" .. var1_6, arg0_6.slots[iter0_6].active, true)
	end
end

function var0_0.ShowPageBtn(arg0_7, arg1_7)
	setActive(arg0_7.prevBtn, false)
	setActive(arg0_7.nextBtn, false)
end

function var0_0.UpdateMedalList(arg0_8)
	return
end

function var0_0.init(arg0_9)
	arg0_9:FindUI()

	arg0_9.loader = AutoLoader.New()
end

function var0_0.FindUI(arg0_10)
	local var0_10 = arg0_10._tf:Find("Top")

	arg0_10.bg = arg0_10._tf:Find("mask")
	arg0_10.backBtn = var0_10:Find("BackBtn")
	arg0_10.helpBtn = var0_10:Find("InfoBtn")
	arg0_10.taskBtn = arg0_10._tf:Find("Desk/taskBtn")
	arg0_10.prevBtn = arg0_10._tf:Find("Desk/prevBtn")
	arg0_10.nextBtn = arg0_10._tf:Find("Desk/nextBtn")
	arg0_10.slots = {}

	for iter0_10 = 1, arg0_10.MEDAL_COUNT do
		arg0_10.slots[iter0_10] = {
			slot = arg0_10._tf:Find("Desk/Slot" .. iter0_10),
			active = arg0_10._tf:Find("Desk/Slot" .. iter0_10 .. "/active"),
			tips = arg0_10._tf:Find("Desk/Slot" .. iter0_10 .. "/reddot"),
			click = arg0_10._tf:Find("Desk/Slot" .. iter0_10 .. "/Click")
		}
	end

	arg0_10.medalLock = arg0_10._tf:Find("Desk/medal")
	arg0_10.trophyLock = arg0_10._tf:Find("Desk/trophy")
	arg0_10.medalDetailView = MedalDetailPanel.New(arg0_10._tf:Find("DetailView"), arg0_10)

	arg0_10.medalDetailView:SetIconScale(arg0_10.ICON_SCALE)

	arg0_10.medalTaskView = MedalTaskPanel.New(arg0_10._tf:Find("TaskView"), arg0_10)
end

function var0_0.didEnter(arg0_11)
	var0_0.super.didEnter(arg0_11)
	arg0_11:AddListener()
	arg0_11:UpdateView()
	pg.UIMgr.GetInstance():BlurPanel(arg0_11._tf)
end

function var0_0.AddListener(arg0_12)
	onButton(arg0_12, arg0_12.backBtn, function()
		arg0_12:closeView()
	end, SFX_CANCEL)

	for iter0_12 = 1, arg0_12.MEDAL_COUNT do
		onButton(arg0_12, arg0_12.slots[iter0_12].click, function()
			arg0_12:showMedalView(iter0_12)
		end)
	end

	onButton(arg0_12, arg0_12.taskBtn, function()
		arg0_12:showTaskView()
	end)
	onButton(arg0_12, arg0_12.bg, function()
		arg0_12:closeView()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.helpBtn, function()
		local var0_17 = arg0_12:GetHelpTips()

		if not var0_17 or var0_17 == "" then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0_17
		})
	end)
	onButton(arg0_12, arg0_12.medalLock, function()
		local var0_18 = arg0_12.currentMedalGroup:getConfig("item_show")[2]
		local var1_18 = {
			type = var0_18[1],
			id = var0_18[2],
			count = var0_18[3]
		}

		arg0_12:emit(BaseUI.ON_DROP, var1_18)
	end, SFX_PANEL)

	if arg0_12.trophyLock then
		onButton(arg0_12, arg0_12.trophyLock, function()
			local var0_19 = arg0_12.currentMedalGroup:getConfig("item_show")[1]
			local var1_19 = {
				type = var0_19[1],
				id = var0_19[2],
				count = var0_19[3]
			}

			arg0_12:emit(BaseUI.ON_DROP, var1_19)
		end, SFX_PANEL)
	end
end

function var0_0.showMedalView(arg0_20, arg1_20)
	arg0_20.medalDetailView:SetCurrentIndex(arg1_20)
	arg0_20.medalDetailView:UpdateMedal()
	arg0_20.medalDetailView:SetActive(true)
end

function var0_0.showTaskView(arg0_21)
	arg0_21.medalTaskView:ShowMedalTask()
	arg0_21.medalTaskView:SetActive(true)
end

function var0_0.UpdateView(arg0_22)
	local var0_22 = arg0_22.currentMedalGroup:GetMedalIds()
	local var1_22 = arg0_22.currentMedalGroup:GetMedalList()

	for iter0_22 = 1, arg0_22.MEDAL_COUNT do
		local var2_22 = var0_22[iter0_22]
		local var3_22 = arg0_22.slots[iter0_22]

		if var1_22[var2_22].timeStamp then
			setActive(var3_22.active, true)
		else
			setActive(var3_22.active, false)
		end
	end

	if arg0_22.trophyLock then
		arg0_22.trophyLock:GetComponent(typeof(Image)).enabled = not arg0_22:OwnTrophy()
	end

	arg0_22.medalLock:GetComponent(typeof(Image)).enabled = not arg0_22:OwnMedal()

	setActive(arg0_22.taskBtn, arg0_22.currentMedalGroup:GetMedalGroupState() == ActivityMedalGroup.STATE_ACTIVE)
end

function var0_0.OwnTrophy(arg0_23)
	local var0_23 = arg0_23.currentMedalGroup:getConfig("task_show")
	local var1_23 = -1

	if var0_23 and type(var0_23) == "table" then
		var1_23 = var0_23[1]
	end

	if var1_23 <= 0 then
		return false
	end

	local var2_23 = pg.task_data_template[var1_23].award_display[1]

	return Task.OwnSpAward(var2_23)
end

function var0_0.OwnMedal(arg0_24)
	local var0_24 = arg0_24.currentMedalGroup:getConfig("task_show")
	local var1_24 = -1

	if var0_24 and type(var0_24) == "table" then
		var1_24 = var0_24[2]
	end

	if var1_24 <= 0 then
		return false
	end

	local var2_24 = pg.task_data_template[var1_24].award_display
	local var3_24 = var2_24[#var2_24]

	return Task.OwnSpAward(var3_24)
end

function var0_0.FlushTaskPanel(arg0_25)
	arg0_25.medalTaskView:SetMedalGroup(arg0_25.currentMedalGroup)
	arg0_25.medalTaskView:ShowMedalTask()
end

function var0_0.willExit(arg0_26)
	arg0_26.medalDetailView:SetActive(false)
	arg0_26.medalTaskView:SetActive(false)
	arg0_26.medalDetailView:Dispose()
	arg0_26.medalTaskView:Dispose()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_26._tf)
	arg0_26.loader:Clear()
end

return var0_0
