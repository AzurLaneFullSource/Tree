local var0_0 = class("StarLightMedalAlbumView", import("view.base.BaseUI"))

var0_0.GROUP_ID = 5711

function var0_0.getUIName(arg0_1)
	return "MedalAlbumStarLightPage"
end

function var0_0.SetMedalGroupData(arg0_2, arg1_2)
	arg0_2.medalGroupList = arg1_2
	arg0_2.currentMedalGroup = arg0_2.medalGroupList[var0_0.GROUP_ID] or ActivityMedalGroup.New(var0_0.GROUP_ID)

	if arg0_2.currentMedalGroup:GetMedalGroupState() == ActivityMedalGroup.STATE_ACTIVE then
		arg0_2.medalTaskView:SetMedalGroup(arg0_2.currentMedalGroup)
	end

	arg0_2.medalDetailView:SetMedalGroup(arg0_2.currentMedalGroup)

	local var0_2 = arg0_2.currentMedalGroup:getConfig("activity_medal_ids")

	for iter0_2 = 1, 8 do
		local var1_2 = var0_2[iter0_2]

		LoadImageSpriteAsync("activitymedal/" .. var1_2 .. "_l", arg0_2.slots[iter0_2].slot, true)
		LoadImageSpriteAsync("activitymedal/" .. var1_2, arg0_2.slots[iter0_2].active, true)
	end
end

function var0_0.UpdateMedalList(arg0_3)
	return
end

function var0_0.init(arg0_4)
	arg0_4:FindUI()

	arg0_4.loader = AutoLoader.New()
end

function var0_0.FindUI(arg0_5)
	local var0_5 = arg0_5:findTF("Top")

	arg0_5.bg = arg0_5:findTF("mask")
	arg0_5.backBtn = arg0_5:findTF("BackBtn", var0_5)
	arg0_5.helpBtn = arg0_5:findTF("InfoBtn", var0_5)
	arg0_5.taskBtn = arg0_5:findTF("Desk/taskBtn")
	arg0_5.prevBtn = arg0_5:findTF("Desk/prevBtn")
	arg0_5.nextBtn = arg0_5:findTF("Desk/nextBtn")

	setActive(arg0_5.prevBtn, false)
	setActive(arg0_5.nextBtn, false)

	arg0_5.slots = {}

	for iter0_5 = 1, 8 do
		arg0_5.slots[iter0_5] = {
			slot = arg0_5._tf:Find("Desk/Slot" .. iter0_5),
			active = arg0_5._tf:Find("Desk/Slot" .. iter0_5 .. "/active"),
			tips = arg0_5._tf:Find("Desk/Slot" .. iter0_5 .. "/reddot"),
			click = arg0_5._tf:Find("Desk/Slot" .. iter0_5 .. "/Click")
		}
	end

	arg0_5.medalLock = arg0_5:findTF("Desk/medal")
	arg0_5.trophyLock = arg0_5:findTF("Desk/trophy")
	arg0_5.medalDetailView = MedalDetailPanel.New(arg0_5:findTF("DetailView"), arg0_5)
	arg0_5.medalTaskView = MedalTaskPanel.New(arg0_5:findTF("TaskView"), arg0_5)
end

function var0_0.didEnter(arg0_6)
	arg0_6:AddListener()
	arg0_6:UpdateView()
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
end

function var0_0.AddListener(arg0_7)
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:closeView()
	end, SFX_CANCEL)

	for iter0_7 = 1, 8 do
		onButton(arg0_7, arg0_7.slots[iter0_7].click, function()
			arg0_7:showMedalView(iter0_7)
		end)
	end

	onButton(arg0_7, arg0_7.taskBtn, function()
		arg0_7:showTaskView()
	end)
	onButton(arg0_7, arg0_7.bg, function()
		arg0_7:closeView()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_starLightAlbum.tip
		})
	end)
	onButton(arg0_7, arg0_7.medalLock, function()
		local var0_13 = arg0_7.currentMedalGroup:getConfig("item_show")[2]
		local var1_13 = {
			type = var0_13[1],
			id = var0_13[2],
			count = var0_13[3]
		}

		arg0_7:emit(BaseUI.ON_DROP, var1_13)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.trophyLock, function()
		local var0_14 = arg0_7.currentMedalGroup:getConfig("item_show")[1]
		local var1_14 = {
			type = var0_14[1],
			id = var0_14[2],
			count = var0_14[3]
		}

		arg0_7:emit(BaseUI.ON_DROP, var1_14)
	end, SFX_PANEL)
end

function var0_0.showMedalView(arg0_15, arg1_15)
	arg0_15.medalDetailView:SetCurrentIndex(arg1_15)
	arg0_15.medalDetailView:UpdateMedal()
	arg0_15.medalDetailView:SetActive(true)
end

function var0_0.showTaskView(arg0_16)
	arg0_16.medalTaskView:ShowMedalTask()
	arg0_16.medalTaskView:SetActive(true)
end

function var0_0.UpdateView(arg0_17)
	local var0_17 = arg0_17.currentMedalGroup:GetMedalList()

	for iter0_17 = 1, 8 do
		local var1_17 = arg0_17.currentMedalGroup:getConfig("activity_medal_ids")[iter0_17]
		local var2_17 = arg0_17.slots[iter0_17]

		if var0_17[var1_17].timeStamp then
			setActive(var2_17.active, true)
		else
			setActive(var2_17.active, false)
		end
	end

	local var3_17 = arg0_17.currentMedalGroup:getConfig("activity_link")[1][3][1]
	local var4_17 = getProxy(TaskProxy):getTaskById(var3_17)

	arg0_17.trophyLock:GetComponent(typeof(Image)).enabled = var4_17 ~= nil
	arg0_17.medalLock:GetComponent(typeof(Image)).enabled = var4_17 ~= nil

	setActive(arg0_17.taskBtn, arg0_17.currentMedalGroup:GetMedalGroupState() == ActivityMedalGroup.STATE_ACTIVE)
end

function var0_0.FlushTaskPanel(arg0_18)
	arg0_18.medalTaskView:SetMedalGroup(arg0_18.currentMedalGroup)
	arg0_18.medalTaskView:ShowMedalTask()
end

function var0_0.willExit(arg0_19)
	arg0_19.medalDetailView:SetActive(false)
	arg0_19.medalTaskView:SetActive(false)
	arg0_19.medalDetailView:Dispose()
	arg0_19.medalTaskView:Dispose()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_19._tf)
	arg0_19.loader:Clear()
end

return var0_0
