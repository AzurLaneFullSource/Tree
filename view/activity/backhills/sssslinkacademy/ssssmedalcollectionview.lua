local var0 = class("SSSSMedalCollectionView", import("..TemplateMV.MedalCollectionTemplateView"))
local var1 = {
	"qvzhu",
	"qingxvn",
	"zhongxvn",
	"zhanlie",
	"hangmu",
	"jinghua"
}

var0.INDEX_CONVERT = {
	1,
	4,
	3,
	5,
	6,
	2
}

function var0.getUIName(arg0)
	return "SSSSMedalCollectionUI"
end

function var0.init(arg0)
	arg0:FindUI()

	arg0.loader = AutoLoader.New()
end

function var0.FindUI(arg0)
	local var0 = arg0:findTF("Top")

	arg0.backBtn = arg0:findTF("BackBtn", var0)
	arg0.helpBtn = arg0:findTF("HelpBtn", var0)
	arg0.progressText = arg0:findTF("ProgressText", var0)
	arg0.slots = {}

	for iter0 = 1, 6 do
		arg0.slots[iter0] = {
			char = arg0._tf:Find("Desk/Slot" .. iter0 .. "/Char"),
			point = arg0._tf:Find("Desk/Slot" .. iter0 .. "/Point"),
			pointEffect = arg0._tf:Find("Desk/Slot" .. iter0 .. "/Dengguang"),
			selected = arg0._tf:Find("Desk/Slot" .. iter0 .. "/Selected"),
			saoguang = arg0._tf:Find("Desk/Slot" .. iter0 .. "/Saoguang")
		}
	end

	arg0.medalTF = arg0._tf:Find("Desk/Slot8")
	arg0.infoArea1 = arg0._tf:Find("Desk/Info/Area1")
	arg0.infoArea2 = arg0._tf:Find("Desk/Info/Area2")
	arg0.infoIcon = arg0.infoArea1:Find("Unlock/Icon")
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)
	arg0:AddListener()

	arg0.contextData.GKIndex = arg0.contextData.GKIndex or 1

	arg0:UpdateView()
end

function var0.AddListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ssss_medal_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.infoArea1, function()
		local var0 = var0.INDEX_CONVERT[arg0.contextData.GKIndex]
		local var1 = arg0.allIDList[2 * var0 - 1]

		if not table.contains(arg0.activeIDList, var1) and table.contains(arg0.activatableIDList, var1) then
			arg0:emit(MedalCollectionTemplateMediator.MEMORYBOOK_UNLOCK, {
				id = var1,
				actId = arg0.activityData.id
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.infoArea2, function()
		local var0 = var0.INDEX_CONVERT[arg0.contextData.GKIndex]
		local var1 = arg0.allIDList[2 * var0]

		if not table.contains(arg0.activeIDList, var1) and table.contains(arg0.activatableIDList, var1) then
			arg0:emit(MedalCollectionTemplateMediator.MEMORYBOOK_UNLOCK, {
				id = var1,
				actId = arg0.activityData.id
			})
		end
	end, SFX_PANEL)

	for iter0 = 1, 6 do
		onButton(arg0, arg0._tf:Find("Desk/Slot" .. iter0 .. "/Click"), function()
			arg0.contextData.GKIndex = iter0

			arg0:UpdateView()
		end, SFX_PANEL)
	end
end

function var0.UpdateAfterSubmit(arg0, arg1)
	var0.super.UpdateAfterSubmit(arg0, arg1)

	local var0 = table.indexof(arg0.allIDList, arg1)
	local var1 = math.floor((var0 + 1) / 2)
	local var2 = table.indexof(var0.INDEX_CONVERT, var1)

	SetCompomentEnabled(arg0.slots[var2].char, typeof(Image), false)
	arg0:UpdateView()
	setActive(arg0.slots[var2].saoguang, false)
	setActive(arg0.slots[var2].saoguang, true)
end

function var0.UpdateAfterFinalMedal(arg0)
	var0.super.UpdateAfterFinalMedal(arg0)
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	for iter0 = 1, 6 do
		local var0 = 0
		local var1 = false
		local var2 = var0.INDEX_CONVERT[iter0]

		_.each({
			arg0.allIDList[2 * var2 - 1],
			arg0.allIDList[2 * var2]
		}, function(arg0)
			if table.contains(arg0.activeIDList, arg0) then
				var0 = var0 + 1
			elseif table.contains(arg0.activatableIDList, arg0) then
				var1 = true
			end
		end)
		arg0.loader:GetSpriteQuiet("ui/SSSSMedalCollectionUI_atlas", var0 == 2 and "point_green" or "point_red", arg0.slots[iter0].point)
		SetCompomentEnabled(arg0.slots[iter0].point, typeof(Animator), false)
		setActive(arg0.slots[iter0].pointEffect, var1)

		if not var1 then
			setImageColor(arg0.slots[iter0].point, Color(1, 1, 1))
		end

		setActive(arg0.slots[iter0].char, var0 ~= 0)

		if var0 == 1 then
			arg0.loader:GetSpriteQuiet("ui/SSSSMedalCollectionUI_atlas", "baimo_" .. var1[var2], arg0.slots[iter0].char)
		elseif var0 == 2 then
			arg0.loader:GetSpriteQuiet("ui/SSSSMedalCollectionUI_atlas", "wancheng_" .. var1[var2], arg0.slots[iter0].char)
		end

		setActive(arg0.slots[iter0].selected, iter0 == arg0.contextData.GKIndex)
	end

	local var3 = #arg0.activeIDList == #arg0.allIDList and arg0.activityData.data1 == 1

	setActive(arg0.medalTF:Find("Lock"), not var3)
	setActive(arg0.medalTF:Find("Unlock"), var3)
	arg0:UpdateInfo()
	setText(arg0.progressText, i18n("ssssmedal_tip", #arg0.activeIDList))
end

function var0.UpdateInfo(arg0)
	local var0 = var0.INDEX_CONVERT[arg0.contextData.GKIndex]

	;(function()
		local var0 = arg0.allIDList[2 * var0 - 1]
		local var1 = table.contains(arg0.activeIDList, var0)
		local var2 = not var1 and table.contains(arg0.activatableIDList, var0)
		local var3 = not var1 and not var2
		local var4 = arg0.infoArea1

		setActive(var4:Find("Lock"), var3)
		setActive(var4:Find("Unlockable"), var2)
		setActive(var4:Find("Unlock"), var1)

		if var1 then
			setText(var4:Find("Unlock/TextName"), i18n("ssssmedal_name") .. i18n("ssssmedal_name" .. var0))

			local var5 = i18n("ssssmedal_belonging") .. i18n("ssssmedal_belonging" .. (var0 == 6 and 2 or 1))

			setText(var4:Find("Unlock/TextDetail"), var5)
			arg0.loader:GetSpriteQuiet("ui/SSSSMedalCollectionUI_atlas", "icon_" .. var1[var0], arg0.infoIcon)
		elseif var3 then
			local var6 = arg0.activityData:getConfig("config_client").unlock_desc

			setText(var4:Find("Lock/BG/TextTip"), var6[2 * var0 - 1])
		end
	end)()
	;(function()
		local var0 = arg0.allIDList[2 * var0]
		local var1 = table.contains(arg0.activeIDList, var0)
		local var2 = not var1 and table.contains(arg0.activatableIDList, var0)
		local var3 = not var1 and not var2
		local var4 = arg0.infoArea2

		setActive(var4:Find("Lock"), var3)
		setActive(var4:Find("Unlockable"), var2)
		setActive(var4:Find("Unlock"), var1)

		if var1 then
			setText(var4:Find("Unlock"), i18n("ssssmedal_desc" .. var0))
		elseif var3 then
			local var5 = arg0.activityData:getConfig("config_client").unlock_desc

			setText(var4:Find("Lock"), var5[2 * var0])
		end
	end)()
end

function var0.willExit(arg0)
	arg0.loader:Clear()
end

return var0
