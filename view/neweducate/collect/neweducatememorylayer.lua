local var0_0 = class("NewEducateMemoryLayer", import(".NewEducateCollectLayerTemplate"))

function var0_0.getUIName(arg0_1)
	return "NewEducateMemoryUI"
end

function var0_0.initConfig(arg0_2)
	arg0_2.config = pg.child2_memory
	arg0_2.allIds = arg0_2.contextData.permanentData:GetAllMemoryIds()
	arg0_2.unlockIds = arg0_2.contextData.permanentData:GetUnlockMemoryIds()
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitPageInfo()
	setText(arg0_3.performTF:Find("review_btn/Text"), i18n("child_btn_review"))
	setText(arg0_3.curCntTF, #arg0_3.unlockIds)
	setText(arg0_3.allCntTF, "/" .. #arg0_3.allIds)
	arg0_3:UpdatePage()
end

function var0_0.UpdateItem(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4.config[arg1_4]
	local var1_4 = table.contains(arg0_4.unlockIds, var0_4.id)

	setActive(arg2_4:Find("lock"), not var1_4)
	setActive(arg2_4:Find("unlock"), var1_4)
	setActive(arg2_4:Find("unlock/new"), false)

	if var1_4 then
		LoadImageSpriteAsync("bg/" .. var0_4.pic, arg2_4:Find("unlock/mask/Image"))
		setText(arg2_4:Find("unlock/name"), var0_4.desc)
		onButton(arg0_4, arg2_4, function()
			arg0_4:ShowPerformWindow(var0_4)
		end, SFX_PANEL)
	else
		removeOnButton(arg2_4)
		setText(arg2_4:Find("lock/Text"), i18n("child_collect_lock"))
	end
end

function var0_0.ShowPerformWindow(arg0_6, arg1_6)
	local var0_6 = arg0_6.performTF:Find("Image")

	LoadImageSpriteAsync("bg/" .. arg1_6.pic, var0_6)
	setActive(arg0_6.performTF, true)
	onButton(arg0_6, var0_6, function()
		setActive(arg0_6.performTF, false)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.performTF:Find("review_btn"), function()
		pg.NewStoryMgr.GetInstance():Play(arg1_6.lua, nil, true)
	end, SFX_PANEL)
end

function var0_0.PlayAnimChange(arg0_9)
	arg0_9.anim:Stop()
	arg0_9.anim:Play("anim_educate_memory_change")
end

function var0_0.PlayAnimClose(arg0_10)
	arg0_10.anim:Play("anim_educate_memory_out")
end

return var0_0
