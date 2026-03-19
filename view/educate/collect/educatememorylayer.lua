local var0_0 = class("EducateMemoryLayer", import(".EducateCollectLayerTemplate"))
local var1_0 = {
	frame_1 = "frame1",
	frame_5 = "frame3",
	frame_3 = "frame2",
	frame_4 = "frame3",
	frame_2 = "frame3"
}

function var0_0.getUIName(arg0_1)
	return "EducateMemoryUI"
end

function var0_0.initConfig(arg0_2)
	arg0_2.config = pg.child_memory
end

function var0_0.didEnter(arg0_3)
	setText(arg0_3.windowTF:Find("tip"), i18n("child_buy_memory_tip"))
	setText(arg0_3.performTF:Find("review_btn/Text"), i18n("child_btn_review"))

	arg0_3.addPrice = pg.gameset.child_cg_add_price.key_value
	arg0_3.maxPrice = pg.gameset.child_cg_max_price.key_value

	arg0_3:Flush()
end

function var0_0.SetData(arg0_4)
	local var0_4 = getProxy(EducateProxy)

	arg0_4.memories = var0_4:GetMemories()
	arg0_4.gameCnt = var0_4:GetGameCnt()
	arg0_4.bugCnt = var0_4:GetMemoryBuyCnt()
end

function var0_0.Flush(arg0_5)
	arg0_5:SetData()
	setText(arg0_5.curCntTF, #arg0_5.memories)
	setText(arg0_5.allCntTF, "/" .. #arg0_5.config.all)
	arg0_5:updatePage()
end

function var0_0.updateItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = var1_0[arg2_6.name]

	GetImageSpriteFromAtlasAsync("ui/educatememoryui_atlas", var0_6 .. "_" .. arg1_6.sp_bg, arg2_6)
	LoadImageSpriteAsync("bg/" .. arg1_6.pic, arg2_6:Find("icon/Image"))
	setText(arg2_6:Find("unlock/name"), arg1_6.desc)
	setText(arg2_6:Find("lock/name"), arg1_6.lock_name)
	setText(arg2_6:Find("lock/desc/Text"), arg1_6.unlock_desc)

	local var1_6 = table.contains(arg0_6.memories, arg1_6.id)

	setActive(arg2_6:Find("icon/lock"), not var1_6)
	setActive(arg2_6:Find("lock"), not var1_6)
	setActive(arg2_6:Find("unlock"), var1_6)

	if var1_6 then
		setActive(arg2_6:Find("unlock/new"), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MEMORY, arg1_6.id))
		onButton(arg0_6, arg2_6, function()
			arg0_6:showPerformWindow(arg1_6)
		end, SFX_PANEL)
	else
		removeOnButton(arg2_6)

		local var2_6 = arg2_6:Find("lock/unlock_btn")

		setActive(var2_6, arg0_6.gameCnt > 1)
		onButton(arg0_6, var2_6, function()
			arg0_6:OnClickBuyBtn(arg1_6)
		end, SFX_PANEL)
	end
end

function var0_0.showPerformWindow(arg0_9, arg1_9)
	EducateTipHelper.ClearNewTip(EducateTipHelper.NEW_MEMORY, arg1_9.id)

	local var0_9 = arg0_9.performTF:Find("Image")

	LoadImageSpriteAsync("bg/" .. arg1_9.pic, var0_9)
	setActive(arg0_9.performTF, true)
	onButton(arg0_9, var0_9, function()
		setActive(arg0_9.performTF, false)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.performTF:Find("review_btn"), function()
		pg.PerformMgr.GetInstance():PlayOne(arg1_9.performance)
	end, SFX_PANEL)
end

function var0_0.OnClickBuyBtn(arg0_12, arg1_12)
	local var0_12 = arg1_12.lock_name
	local var1_12 = math.min(arg0_12.maxPrice, arg1_12.child_cg_basic_price + arg0_12.bugCnt * arg0_12.addPrice)

	arg0_12:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
		content = i18n("child_cg_buy", var1_12, var0_12),
		onYes = function()
			arg0_12:emit(EducateCollectMediatorTemplate.UNLOCK, {
				type = EducateBuyCollectCommand.TYPE.MEMORY,
				id = arg1_12.id,
				cost = var1_12
			})
		end
	})
end

function var0_0.playAnimChange(arg0_14)
	arg0_14.anim:Stop()
	arg0_14.anim:Play("anim_educate_memory_change")
end

function var0_0.playAnimClose(arg0_15)
	arg0_15.anim:Play("anim_educate_memory_out")
end

return var0_0
