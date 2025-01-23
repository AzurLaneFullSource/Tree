local var0_0 = class("NewEducatePolaroidLayer", import(".NewEducateCollectLayerTemplate"))

function var0_0.getUIName(arg0_1)
	return "NewEducatePolaroidUI"
end

function var0_0.initConfig(arg0_2)
	arg0_2.config = pg.child2_polaroid
	arg0_2.allIds = arg0_2.contextData.permanentData:GetAllPolaroidGroups()
	arg0_2.unlockIds = arg0_2.contextData.permanentData:GetUnlockPolaroidGroups()
	arg0_2.polaroidGroup2Ids = arg0_2.contextData.permanentData:GetPolaroidGroup2Ids()
	arg0_2.polaroids = arg0_2.contextData.permanentData:GetPolaroids()
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitPageInfo()
	setText(arg0_3.curCntTF, #arg0_3.unlockIds)
	setText(arg0_3.allCntTF, "/" .. #arg0_3.allIds)
	onButton(arg0_3, arg0_3.performTF, function()
		setActive(arg0_3.performTF, false)
	end, SFX_PANEL)
	arg0_3:InitShowList()
	arg0_3:UpdatePage()
end

function var0_0.InitShowList(arg0_5)
	arg0_5.showIds = {}
	arg0_5.selectedIndex = 1
	arg0_5.groupsTF = arg0_5.performTF:Find("bg/groups")
	arg0_5.showList = UIItemList.New(arg0_5.groupsTF, arg0_5.groupsTF:Find("tpl"))

	arg0_5.showList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = arg0_5.showIds[arg1_6 + 1]
			local var1_6 = arg0_5:IsUnlock(var0_6)

			setText(arg2_6:Find("unlock/unselected/Text"), var0_6)
			setText(arg2_6:Find("unlock/selected/Text"), var0_6)
			setActive(arg2_6:Find("lock"), not var1_6)
			setActive(arg2_6:Find("unlock"), var1_6)
			setActive(arg2_6:Find("unlock/selected"), arg0_5.selectedIndex == arg1_6 + 1)
			setActive(arg2_6:Find("unlock/unselected"), arg0_5.selectedIndex ~= arg1_6 + 1)
			onButton(arg0_5, arg2_6, function(arg0_7)
				if var1_6 then
					arg0_5.selectedIndex = arg1_6 + 1

					arg0_5:UpdatePerform(var0_6)
					arg0_5.showList:align(#arg0_5.showIds)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("child_polaroid_lock_tip"))
				end
			end)
		end
	end)
end

function var0_0.IsUnlock(arg0_8, arg1_8)
	return true
end

function var0_0.UpdateItem(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.polaroidGroup2Ids[arg1_9]

	table.sort(var0_9, CompareFuncs({
		function(arg0_10)
			return table.contains(arg0_9.polaroids, arg0_10) and 0 or 1
		end,
		function(arg0_11)
			return arg0_11
		end
	}))

	local var1_9 = arg0_9.config[var0_9[1]]
	local var2_9 = table.contains(arg0_9.unlockIds, arg1_9)

	setActive(arg2_9:Find("lock"), not var2_9)
	setActive(arg2_9:Find("unlock"), var2_9)

	if var2_9 then
		LoadImageSpriteAsync("neweducateicon/" .. var1_9.pic, arg2_9:Find("unlock/mask/Image"), true)
		setText(arg2_9:Find("unlock/name"), var1_9.title)
		onButton(arg0_9, arg2_9, function()
			arg0_9:ShowPerformWindow(var0_9)
		end, SFX_PANEL)
	else
		removeOnButton(arg2_9)
		setText(arg2_9:Find("lock/Text"), var1_9.condition)
	end
end

function var0_0.ShowPerformWindow(arg0_13, arg1_13, arg2_13)
	arg0_13.showIds = arg1_13

	arg0_13.showList:align(#arg0_13.showIds)
	triggerButton(arg0_13.groupsTF:GetChild(0))
	setActive(arg0_13.performTF, true)
end

function var0_0.UpdatePerform(arg0_14, arg1_14)
	local var0_14 = arg0_14.config[arg1_14]

	LoadImageSpriteAsync("neweducateicon/" .. var0_14.pic_2, arg0_14.performTF:Find("bg/mask/Image"), true)
	setText(arg0_14.performTF:Find("bg/Text"), var0_14.title)
end

function var0_0.PlayAnimChange(arg0_15)
	arg0_15.anim:Stop()
	arg0_15.anim:Play("anim_educate_Polaroid_change")
end

function var0_0.PlayAnimClose(arg0_16)
	arg0_16.anim:Play("anim_educate_Polaroid_out")
end

return var0_0
