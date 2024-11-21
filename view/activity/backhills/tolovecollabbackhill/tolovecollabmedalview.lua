local var0_0 = class("ToLoveCollabMedalView", import("..TemplateMV.MedalCollectionTemplateView"))

function var0_0.getUIName(arg0_1)
	return "ToLoveCollabMedalPage"
end

function var0_0.init(arg0_2)
	arg0_2:FindUI()

	arg0_2.loader = AutoLoader.New()
end

function var0_0.FindUI(arg0_3)
	local var0_3 = arg0_3:findTF("Top")

	arg0_3.bg = arg0_3:findTF("mask")
	arg0_3.backBtn = arg0_3:findTF("BackBtn", var0_3)
	arg0_3.slots = {}

	for iter0_3 = 1, 6 do
		arg0_3.slots[iter0_3] = {
			char = arg0_3._tf:Find("Desk/Slot" .. iter0_3 .. "/Char"),
			selected = arg0_3._tf:Find("Desk/Slot" .. iter0_3 .. "/Selected"),
			tips = arg0_3._tf:Find("Desk/Slot" .. iter0_3 .. "/reddot")
		}
	end

	arg0_3.medalTF = arg0_3._tf:Find("Desk/trophy")
	arg0_3.syncBtn = arg0_3._tf:Find("Desk/syncBtn")
	arg0_3.task = arg0_3._tf:Find("Desk/task")
	arg0_3.taskBGGo = arg0_3.task:Find("bg_go")
	arg0_3.taskBGGot = arg0_3.task:Find("bg_got")
	arg0_3.taskBtnGo = arg0_3.task:Find("go_btn")
	arg0_3.taskBtnGot = arg0_3.task:Find("got_btn")
	arg0_3.taskBtnGet = arg0_3.task:Find("get_btn")
	arg0_3.taskDesc = arg0_3.task:Find("desc")
	arg0_3.taskReward = arg0_3.task:Find("award/mask")
	arg0_3.taskRewardName = arg0_3.task:Find("name")
end

function var0_0.didEnter(arg0_4)
	arg0_4.taskList, arg0_4.dropInfoList = {}, {}

	local var0_4 = arg0_4.activityData:getConfig("config_client").item_task

	for iter0_4 = 1, 6 do
		arg0_4.taskList[iter0_4] = Task.New({
			id = var0_4[iter0_4][2]
		})
		arg0_4.dropInfoList[iter0_4] = {
			type = DROP_TYPE_VITEM,
			id = var0_4[iter0_4][1]
		}
	end

	arg0_4:AddListener()

	arg0_4.contextData.ChipIndex = arg0_4.contextData.ChipIndex or 1

	arg0_4:UpdateView()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_4._tf, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.AddListener(arg0_5)
	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.taskBtnGet, function()
		local var0_7 = arg0_5.allIDList[arg0_5.contextData.ChipIndex]

		if not table.contains(arg0_5.activeIDList, var0_7) and table.contains(arg0_5.activatableIDList, var0_7) then
			arg0_5:emit(MedalCollectionTemplateMediator.MEMORYBOOK_UNLOCK, {
				id = var0_7,
				actId = arg0_5.activityData.id
			})
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.taskBtnGo, function()
		local var0_8 = arg0_5.taskList[arg0_5.contextData.ChipIndex]

		arg0_5:emit(MedalCollectionTemplateMediator.MEMORYBOOK_GO, var0_8)
	end, SFX_PANEL)

	for iter0_5 = 1, 6 do
		onButton(arg0_5, arg0_5._tf:Find("Desk/Slot" .. iter0_5 .. "/Click"), function()
			arg0_5.contextData.ChipIndex = iter0_5

			arg0_5:UpdateView()
		end, SFX_PANEL)
	end

	onButton(arg0_5, arg0_5.syncBtn, function()
		arg0_5:CheckAward()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.bg, function()
		arg0_5:closeView()
	end, SFX_PANEL)
end

function var0_0.UpdateAfterSubmit(arg0_12, arg1_12)
	arg0_12:UpdateView()
end

function var0_0.UpdateAfterFinalMedal(arg0_13)
	var0_0.super.UpdateAfterFinalMedal(arg0_13)
	arg0_13:UpdateView()
end

function var0_0.UpdateView(arg0_14)
	for iter0_14 = 1, 6 do
		local var0_14 = 0
		local var1_14 = false

		for iter1_14 = 1, #arg0_14.slots do
			local var2_14 = table.contains(arg0_14.activeIDList, arg0_14.allIDList[iter1_14])

			setActive(arg0_14.slots[iter1_14].char, var2_14)
			setActive(arg0_14.slots[iter1_14].tips, table.contains(arg0_14.activatableIDList, arg0_14.allIDList[iter1_14]) and not var2_14)
		end

		setActive(arg0_14.slots[iter0_14].selected, iter0_14 == arg0_14.contextData.ChipIndex)
	end

	local var3_14 = #arg0_14.activeIDList == #arg0_14.allIDList
	local var4_14 = var3_14 and arg0_14.activityData.data1 == 1

	setActive(arg0_14.medalTF:Find("Lock"), not var4_14)
	setActive(arg0_14.medalTF:Find("Unlock"), var4_14)
	setActive(arg0_14.syncBtn:Find("notSync"), not var3_14)
	setActive(arg0_14.syncBtn:Find("synced"), var4_14)

	arg0_14.syncBtn:GetComponent(typeof(Image)).enabled = var3_14 and not var4_14

	setActive(arg0_14.syncBtn:Find("reddot"), var3_14 and not var4_14)
	arg0_14:UpdateInfo()
end

function var0_0.UpdateInfo(arg0_15)
	local var0_15 = arg0_15.allIDList[arg0_15.contextData.ChipIndex]
	local var1_15 = table.contains(arg0_15.activeIDList, var0_15)
	local var2_15 = not var1_15 and table.contains(arg0_15.activatableIDList, var0_15)

	setActive(arg0_15.taskBGGo, not var1_15)
	setActive(arg0_15.taskBGGot, var1_15)
	setActive(arg0_15.taskBtnGot, var1_15)
	setActive(arg0_15.taskBtnGet, var2_15)
	setActive(arg0_15.taskBtnGo, not var2_15)
	setText(arg0_15.taskDesc, arg0_15.taskList[arg0_15.contextData.ChipIndex]:getConfig("desc"))
	updateDrop(arg0_15.taskReward, arg0_15.dropInfoList[arg0_15.contextData.ChipIndex])
	setText(arg0_15.taskRewardName, pg.item_virtual_data_statistics[arg0_15.dropInfoList[arg0_15.contextData.ChipIndex].id].name)
end

function var0_0.willExit(arg0_16)
	arg0_16.loader:Clear()
end

return var0_0
