local var0_0 = class("NewEducateEndingLayer", import(".NewEducateCollectLayerTemplate"))

function var0_0.getUIName(arg0_1)
	return "NewEducateEndingUI"
end

function var0_0.initConfig(arg0_2)
	arg0_2.config = pg.child2_ending
	arg0_2.allIds = arg0_2.contextData.permanentData:GetAllEndingIds()
	arg0_2.unlockIds = arg0_2.contextData.permanentData:GetActivatedEndings()
	arg0_2.finishedIds = arg0_2.contextData.permanentData:GetFinishedEndings()
	arg0_2.char = getProxy(NewEducateProxy):GetChar(arg0_2.contextData.permanentData.id)
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("anim_root/close"), function()
		arg0_3:PlayAnimClose()
	end, SFX_PANEL)
	arg0_3:InitPageInfo()
	setText(arg0_3.performTF:Find("review_btn/Text"), i18n("child_btn_review"))
	setText(arg0_3.curCntTF, #arg0_3.unlockIds)
	setText(arg0_3.allCntTF, "/" .. #arg0_3.allIds)

	arg0_3.toggleTF = arg0_3.windowTF:Find("toggle")

	setText(arg0_3.toggleTF:Find("on/Text"), i18n("child2_endings_toggle_on"))
	setText(arg0_3.toggleTF:Find("off/Text"), i18n("child2_endings_toggle_off"))

	arg0_3.tpl = arg0_3.windowTF:Find("condition_tpl")

	onToggle(arg0_3, arg0_3.toggleTF, function(arg0_5)
		arg0_3:UpdatePage()
	end, SFX_PANEL)
	arg0_3:UpdatePage()
end

function var0_0.UpdateItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.config[arg1_6]
	local var1_6 = table.contains(arg0_6.unlockIds, var0_6.id)

	setActive(arg2_6:Find("unlock"), var1_6)
	setActive(arg2_6:Find("lock"), not var1_6)
	setActive(arg2_6:Find("finished"), table.contains(arg0_6.finishedIds, var0_6.id))
	setText(arg2_6:Find("name"), var1_6 and var0_6.name or "???")

	if var1_6 then
		LoadImageSpriteAsync("bg/" .. var0_6.pic, arg2_6:Find("unlock/mask/Image"))
		onButton(arg0_6, arg2_6, function()
			arg0_6:ShowPerformWindow(var0_6)
		end, SFX_PANEL)
	else
		removeOnButton(arg2_6)
	end

	local var2_6 = arg0_6.toggleTF:GetComponent(typeof(Toggle)).isOn
	local var3_6 = {}

	if var2_6 then
		setActive(arg2_6:Find("lock"), true)
		setActive(arg2_6:Find("lock/icon"), not var1_6)
		setActive(arg2_6:Find("mask"), var1_6)

		var3_6 = var0_6.condition_desc
	else
		setActive(arg2_6:Find("mask"), false)
	end

	arg0_6:UpdateConditions(var3_6, arg2_6:Find("lock/conditions"))
end

function var0_0.UpdateConditions(arg0_8, arg1_8, arg2_8)
	local var0_8 = 0

	for iter0_8 = 1, #arg1_8 do
		local var1_8 = arg1_8[iter0_8]

		var0_8 = var0_8 + 1

		local var2_8 = iter0_8 <= arg2_8.childCount and arg2_8:GetChild(iter0_8 - 1) or cloneTplTo(arg0_8.tpl, arg2_8)
		local var3_8 = arg0_8.char:LogicalOperator({
			operator = "||",
			conditions = var1_8[1]
		})

		setActive(var2_8:Find("icon/unlock"), var3_8)

		local var4_8 = var3_8 and "F59F48" or "888888"

		setTextColor(var2_8:Find("Text"), Color.NewHex(var4_8))
		setText(var2_8:Find("Text"), var1_8[2])
	end

	for iter1_8 = 1, arg2_8.childCount do
		setActive(arg2_8:GetChild(iter1_8 - 1), iter1_8 <= var0_8)
	end
end

function var0_0.ShowPerformWindow(arg0_9, arg1_9)
	local var0_9 = arg0_9.performTF:Find("Image")

	LoadImageSpriteAsync("bg/" .. arg1_9.pic, var0_9)
	setActive(arg0_9.performTF, true)
	onButton(arg0_9, var0_9, function()
		setActive(arg0_9.performTF, false)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.performTF:Find("review_btn"), function()
		pg.NewStoryMgr.GetInstance():Play(arg1_9.performance, nil, true)
	end, SFX_PANEL)
end

function var0_0.PlayAnimChange(arg0_12)
	arg0_12.anim:Stop()
	arg0_12.anim:Play("anim_educate_ending_change")
end

function var0_0.PlayAnimClose(arg0_13)
	arg0_13.anim:Play("anim_educate_ending_out")
end

return var0_0
