local var0_0 = class("SSSSMedalCollectionView", import("..TemplateMV.MedalCollectionTemplateView"))
local var1_0 = {
	"qvzhu",
	"qingxvn",
	"zhongxvn",
	"zhanlie",
	"hangmu",
	"jinghua"
}

var0_0.INDEX_CONVERT = {
	1,
	4,
	3,
	5,
	6,
	2
}

function var0_0.getUIName(arg0_1)
	return "SSSSMedalCollectionUI"
end

function var0_0.init(arg0_2)
	arg0_2:FindUI()

	arg0_2.loader = AutoLoader.New()
end

function var0_0.FindUI(arg0_3)
	local var0_3 = arg0_3:findTF("Top")

	arg0_3.backBtn = arg0_3:findTF("BackBtn", var0_3)
	arg0_3.helpBtn = arg0_3:findTF("HelpBtn", var0_3)
	arg0_3.progressText = arg0_3:findTF("ProgressText", var0_3)
	arg0_3.slots = {}

	for iter0_3 = 1, 6 do
		arg0_3.slots[iter0_3] = {
			char = arg0_3._tf:Find("Desk/Slot" .. iter0_3 .. "/Char"),
			point = arg0_3._tf:Find("Desk/Slot" .. iter0_3 .. "/Point"),
			pointEffect = arg0_3._tf:Find("Desk/Slot" .. iter0_3 .. "/Dengguang"),
			selected = arg0_3._tf:Find("Desk/Slot" .. iter0_3 .. "/Selected"),
			saoguang = arg0_3._tf:Find("Desk/Slot" .. iter0_3 .. "/Saoguang")
		}
	end

	arg0_3.medalTF = arg0_3._tf:Find("Desk/Slot8")
	arg0_3.infoArea1 = arg0_3._tf:Find("Desk/Info/Area1")
	arg0_3.infoArea2 = arg0_3._tf:Find("Desk/Info/Area2")
	arg0_3.infoIcon = arg0_3.infoArea1:Find("Unlock/Icon")
end

function var0_0.didEnter(arg0_4)
	var0_0.super.didEnter(arg0_4)
	arg0_4:AddListener()

	arg0_4.contextData.GKIndex = arg0_4.contextData.GKIndex or 1

	arg0_4:UpdateView()
end

function var0_0.AddListener(arg0_5)
	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ssss_medal_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.infoArea1, function()
		local var0_8 = var0_0.INDEX_CONVERT[arg0_5.contextData.GKIndex]
		local var1_8 = arg0_5.allIDList[2 * var0_8 - 1]

		if not table.contains(arg0_5.activeIDList, var1_8) and table.contains(arg0_5.activatableIDList, var1_8) then
			arg0_5:emit(MedalCollectionTemplateMediator.MEMORYBOOK_UNLOCK, {
				id = var1_8,
				actId = arg0_5.activityData.id
			})
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.infoArea2, function()
		local var0_9 = var0_0.INDEX_CONVERT[arg0_5.contextData.GKIndex]
		local var1_9 = arg0_5.allIDList[2 * var0_9]

		if not table.contains(arg0_5.activeIDList, var1_9) and table.contains(arg0_5.activatableIDList, var1_9) then
			arg0_5:emit(MedalCollectionTemplateMediator.MEMORYBOOK_UNLOCK, {
				id = var1_9,
				actId = arg0_5.activityData.id
			})
		end
	end, SFX_PANEL)

	for iter0_5 = 1, 6 do
		onButton(arg0_5, arg0_5._tf:Find("Desk/Slot" .. iter0_5 .. "/Click"), function()
			arg0_5.contextData.GKIndex = iter0_5

			arg0_5:UpdateView()
		end, SFX_PANEL)
	end
end

function var0_0.UpdateAfterSubmit(arg0_11, arg1_11)
	var0_0.super.UpdateAfterSubmit(arg0_11, arg1_11)

	local var0_11 = table.indexof(arg0_11.allIDList, arg1_11)
	local var1_11 = math.floor((var0_11 + 1) / 2)
	local var2_11 = table.indexof(var0_0.INDEX_CONVERT, var1_11)

	SetCompomentEnabled(arg0_11.slots[var2_11].char, typeof(Image), false)
	arg0_11:UpdateView()
	setActive(arg0_11.slots[var2_11].saoguang, false)
	setActive(arg0_11.slots[var2_11].saoguang, true)
end

function var0_0.UpdateAfterFinalMedal(arg0_12)
	var0_0.super.UpdateAfterFinalMedal(arg0_12)
	arg0_12:UpdateView()
end

function var0_0.UpdateView(arg0_13)
	for iter0_13 = 1, 6 do
		local var0_13 = 0
		local var1_13 = false
		local var2_13 = var0_0.INDEX_CONVERT[iter0_13]

		_.each({
			arg0_13.allIDList[2 * var2_13 - 1],
			arg0_13.allIDList[2 * var2_13]
		}, function(arg0_14)
			if table.contains(arg0_13.activeIDList, arg0_14) then
				var0_13 = var0_13 + 1
			elseif table.contains(arg0_13.activatableIDList, arg0_14) then
				var1_13 = true
			end
		end)
		arg0_13.loader:GetSpriteQuiet("ui/SSSSMedalCollectionUI_atlas", var0_13 == 2 and "point_green" or "point_red", arg0_13.slots[iter0_13].point)
		SetCompomentEnabled(arg0_13.slots[iter0_13].point, typeof(Animator), false)
		setActive(arg0_13.slots[iter0_13].pointEffect, var1_13)

		if not var1_13 then
			setImageColor(arg0_13.slots[iter0_13].point, Color(1, 1, 1))
		end

		setActive(arg0_13.slots[iter0_13].char, var0_13 ~= 0)

		if var0_13 == 1 then
			arg0_13.loader:GetSpriteQuiet("ui/SSSSMedalCollectionUI_atlas", "baimo_" .. var1_0[var2_13], arg0_13.slots[iter0_13].char)
		elseif var0_13 == 2 then
			arg0_13.loader:GetSpriteQuiet("ui/SSSSMedalCollectionUI_atlas", "wancheng_" .. var1_0[var2_13], arg0_13.slots[iter0_13].char)
		end

		setActive(arg0_13.slots[iter0_13].selected, iter0_13 == arg0_13.contextData.GKIndex)
	end

	local var3_13 = #arg0_13.activeIDList == #arg0_13.allIDList and arg0_13.activityData.data1 == 1

	setActive(arg0_13.medalTF:Find("Lock"), not var3_13)
	setActive(arg0_13.medalTF:Find("Unlock"), var3_13)
	arg0_13:UpdateInfo()
	setText(arg0_13.progressText, i18n("ssssmedal_tip", #arg0_13.activeIDList))
end

function var0_0.UpdateInfo(arg0_15)
	local var0_15 = var0_0.INDEX_CONVERT[arg0_15.contextData.GKIndex]

	;(function()
		local var0_16 = arg0_15.allIDList[2 * var0_15 - 1]
		local var1_16 = table.contains(arg0_15.activeIDList, var0_16)
		local var2_16 = not var1_16 and table.contains(arg0_15.activatableIDList, var0_16)
		local var3_16 = not var1_16 and not var2_16
		local var4_16 = arg0_15.infoArea1

		setActive(var4_16:Find("Lock"), var3_16)
		setActive(var4_16:Find("Unlockable"), var2_16)
		setActive(var4_16:Find("Unlock"), var1_16)

		if var1_16 then
			setText(var4_16:Find("Unlock/TextName"), i18n("ssssmedal_name") .. i18n("ssssmedal_name" .. var0_15))

			local var5_16 = i18n("ssssmedal_belonging") .. i18n("ssssmedal_belonging" .. (var0_15 == 6 and 2 or 1))

			setText(var4_16:Find("Unlock/TextDetail"), var5_16)
			arg0_15.loader:GetSpriteQuiet("ui/SSSSMedalCollectionUI_atlas", "icon_" .. var1_0[var0_15], arg0_15.infoIcon)
		elseif var3_16 then
			local var6_16 = arg0_15.activityData:getConfig("config_client").unlock_desc

			setText(var4_16:Find("Lock/BG/TextTip"), var6_16[2 * var0_15 - 1])
		end
	end)()
	;(function()
		local var0_17 = arg0_15.allIDList[2 * var0_15]
		local var1_17 = table.contains(arg0_15.activeIDList, var0_17)
		local var2_17 = not var1_17 and table.contains(arg0_15.activatableIDList, var0_17)
		local var3_17 = not var1_17 and not var2_17
		local var4_17 = arg0_15.infoArea2

		setActive(var4_17:Find("Lock"), var3_17)
		setActive(var4_17:Find("Unlockable"), var2_17)
		setActive(var4_17:Find("Unlock"), var1_17)

		if var1_17 then
			setText(var4_17:Find("Unlock"), i18n("ssssmedal_desc" .. var0_15))
		elseif var3_17 then
			local var5_17 = arg0_15.activityData:getConfig("config_client").unlock_desc

			setText(var4_17:Find("Lock"), var5_17[2 * var0_15])
		end
	end)()
end

function var0_0.willExit(arg0_18)
	arg0_18.loader:Clear()
end

return var0_0
