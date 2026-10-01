local var0_0 = class("StarLightMedalAlbumView", import("view.base.BaseUI"))

var0_0.ICON_SCALE = 1.35
var0_0.MEDAL_COUNT = 8

function var0_0.getResource(arg0_1, arg1_1)
	local var0_1 = {}
	local var1_1 = arg0_1.GROUP_ID
	local var2_1 = var1_1 and pg.activity_medal_group[var1_1]

	if var2_1 and var2_1.item_show then
		local var3_1 = {}

		local function var4_1(arg0_2)
			if noEmptyStr(arg0_2) and not table.contains(var3_1, arg0_2) then
				table.insert(var3_1, arg0_2)
			end
		end

		for iter0_1, iter1_1 in ipairs(var2_1.item_show) do
			if iter1_1 and #iter1_1 > 0 then
				local var5_1 = Drop.New({
					type = iter1_1[1],
					id = iter1_1[2],
					count = iter1_1[3] or 1
				})
				local var6_1 = var5_1:getIcon()

				if var5_1.type == DROP_TYPE_FURNITURE then
					var6_1 = "furnitureicon/" .. var6_1
				end

				var4_1(var6_1)
			end
		end

		for iter2_1, iter3_1 in ipairs(var3_1) do
			table.insert(var0_1, iter3_1)
		end
	end

	table.insertto(var0_1, var0_0.super.getResource(arg0_1, arg1_1))

	return var0_1
end

function var0_0.SetMedalGroupData(arg0_3, arg1_3)
	arg0_3.medalGroupList = arg1_3
	arg0_3.currentMedalGroup = arg0_3.medalGroupList[arg0_3.GROUP_ID] or ActivityMedalGroup.New(arg0_3.GROUP_ID)

	if arg0_3.currentMedalGroup:GetMedalGroupState() == ActivityMedalGroup.STATE_ACTIVE then
		arg0_3.medalTaskView:SetMedalGroup(arg0_3.currentMedalGroup)
	end

	arg0_3.medalDetailView:SetMedalGroup(arg0_3.currentMedalGroup)

	local var0_3 = arg0_3.currentMedalGroup:GetMedalIds()

	for iter0_3 = 1, arg0_3.MEDAL_COUNT do
		local var1_3 = var0_3[iter0_3]

		LoadImageSpriteAsync("activitymedal/" .. var1_3 .. "_l", arg0_3.slots[iter0_3].slot, true)
		LoadImageSpriteAsync("activitymedal/" .. var1_3, arg0_3.slots[iter0_3].active, true)
	end
end

function var0_0.ShowPageBtn(arg0_4, arg1_4)
	setActive(arg0_4.prevBtn, false)
	setActive(arg0_4.nextBtn, false)
end

function var0_0.UpdateMedalList(arg0_5)
	return
end

function var0_0.init(arg0_6)
	arg0_6:FindUI()

	arg0_6.loader = AutoLoader.New()
end

function var0_0.FindUI(arg0_7)
	local var0_7 = arg0_7._tf:Find("Top")

	arg0_7.bg = arg0_7._tf:Find("mask")
	arg0_7.backBtn = var0_7:Find("BackBtn")
	arg0_7.helpBtn = var0_7:Find("InfoBtn")
	arg0_7.taskBtn = arg0_7._tf:Find("Desk/taskBtn")
	arg0_7.prevBtn = arg0_7._tf:Find("Desk/prevBtn")
	arg0_7.nextBtn = arg0_7._tf:Find("Desk/nextBtn")
	arg0_7.slots = {}

	for iter0_7 = 1, arg0_7.MEDAL_COUNT do
		arg0_7.slots[iter0_7] = {
			slot = arg0_7._tf:Find("Desk/Slot" .. iter0_7),
			active = arg0_7._tf:Find("Desk/Slot" .. iter0_7 .. "/active"),
			tips = arg0_7._tf:Find("Desk/Slot" .. iter0_7 .. "/reddot"),
			click = arg0_7._tf:Find("Desk/Slot" .. iter0_7 .. "/Click")
		}
	end

	arg0_7.medalLock = arg0_7._tf:Find("Desk/medal")
	arg0_7.trophyLock = arg0_7._tf:Find("Desk/trophy")
	arg0_7.medalDetailView = MedalDetailPanel.New(arg0_7._tf:Find("DetailView"), arg0_7)

	arg0_7.medalDetailView:SetIconScale(arg0_7.ICON_SCALE)

	arg0_7.medalTaskView = MedalTaskPanel.New(arg0_7._tf:Find("TaskView"), arg0_7)
end

function var0_0.didEnter(arg0_8)
	var0_0.super.didEnter(arg0_8)
	arg0_8:AddListener()
	arg0_8:UpdateView()
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf)
end

function var0_0.AddListener(arg0_9)
	onButton(arg0_9, arg0_9.backBtn, function()
		arg0_9:closeView()
	end, SFX_CANCEL)

	for iter0_9 = 1, arg0_9.MEDAL_COUNT do
		onButton(arg0_9, arg0_9.slots[iter0_9].click, function()
			arg0_9:showMedalView(iter0_9)
		end)
	end

	onButton(arg0_9, arg0_9.taskBtn, function()
		arg0_9:showTaskView()
	end)
	onButton(arg0_9, arg0_9.bg, function()
		arg0_9:closeView()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_9.HELP_TIPS].tip
		})
	end)
	onButton(arg0_9, arg0_9.medalLock, function()
		local var0_15 = arg0_9.currentMedalGroup:getConfig("item_show")[2]
		local var1_15 = {
			type = var0_15[1],
			id = var0_15[2],
			count = var0_15[3]
		}

		arg0_9:emit(BaseUI.ON_DROP, var1_15)
	end, SFX_PANEL)

	if arg0_9.trophyLock then
		onButton(arg0_9, arg0_9.trophyLock, function()
			local var0_16 = arg0_9.currentMedalGroup:getConfig("item_show")[1]
			local var1_16 = {
				type = var0_16[1],
				id = var0_16[2],
				count = var0_16[3]
			}

			arg0_9:emit(BaseUI.ON_DROP, var1_16)
		end, SFX_PANEL)
	end
end

function var0_0.showMedalView(arg0_17, arg1_17)
	arg0_17.medalDetailView:SetCurrentIndex(arg1_17)
	arg0_17.medalDetailView:UpdateMedal()
	arg0_17.medalDetailView:SetActive(true)
end

function var0_0.showTaskView(arg0_18)
	arg0_18.medalTaskView:ShowMedalTask()
	arg0_18.medalTaskView:SetActive(true)
end

function var0_0.UpdateView(arg0_19)
	local var0_19 = arg0_19.currentMedalGroup:GetMedalIds()
	local var1_19 = arg0_19.currentMedalGroup:GetMedalList()

	for iter0_19 = 1, arg0_19.MEDAL_COUNT do
		local var2_19 = var0_19[iter0_19]
		local var3_19 = arg0_19.slots[iter0_19]

		if var1_19[var2_19].timeStamp then
			setActive(var3_19.active, true)
		else
			setActive(var3_19.active, false)
		end
	end

	if arg0_19.trophyLock then
		arg0_19.trophyLock:GetComponent(typeof(Image)).enabled = not arg0_19:OwnTrophy()
	end

	arg0_19.medalLock:GetComponent(typeof(Image)).enabled = not arg0_19:OwnMedal()

	setActive(arg0_19.taskBtn, arg0_19.currentMedalGroup:GetMedalGroupState() == ActivityMedalGroup.STATE_ACTIVE)
end

function var0_0.OwnTrophy(arg0_20)
	local var0_20 = arg0_20.currentMedalGroup:getConfig("task_show")
	local var1_20 = -1

	if var0_20 and type(var0_20) == "table" then
		var1_20 = var0_20[1]
	end

	if var1_20 <= 0 then
		return false
	end

	local var2_20 = pg.task_data_template[var1_20].award_display[1]

	return Task.OwnSpAward(var2_20)
end

function var0_0.OwnMedal(arg0_21)
	local var0_21 = arg0_21.currentMedalGroup:getConfig("task_show")
	local var1_21 = -1

	if var0_21 and type(var0_21) == "table" then
		var1_21 = var0_21[2]
	end

	if var1_21 <= 0 then
		return false
	end

	local var2_21 = pg.task_data_template[var1_21].award_display
	local var3_21 = var2_21[#var2_21]

	return Task.OwnSpAward(var3_21)
end

function var0_0.FlushTaskPanel(arg0_22)
	arg0_22.medalTaskView:SetMedalGroup(arg0_22.currentMedalGroup)
	arg0_22.medalTaskView:ShowMedalTask()
end

function var0_0.willExit(arg0_23)
	arg0_23.medalDetailView:SetActive(false)
	arg0_23.medalTaskView:SetActive(false)
	arg0_23.medalDetailView:Dispose()
	arg0_23.medalTaskView:Dispose()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_23._tf)
	arg0_23.loader:Clear()
end

return var0_0
