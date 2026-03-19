local var0_0 = class("EducateEndingLayer", import(".EducateCollectLayerTemplate"))
local var1_0 = {
	frame_1 = "frame1",
	frame_5 = "frame3",
	frame_3 = "frame2",
	frame_4 = "frame3",
	frame_2 = "frame2"
}

function var0_0.getUIName(arg0_1)
	return "EducateEndingUI"
end

function var0_0.initConfig(arg0_2)
	arg0_2.config = pg.child_ending
end

function var0_0.didEnter(arg0_3)
	setText(arg0_3.windowTF:Find("tip"), i18n("child_buy_ending_tip"))
	setText(arg0_3.performTF:Find("review_btn/Text"), i18n("child_btn_review"))

	arg0_3.tpl = arg0_3.windowTF:Find("condition_tpl")
	arg0_3.addPrice = pg.gameset.child_cg_add_price.key_value
	arg0_3.maxPrice = pg.gameset.child_cg_max_price.key_value

	arg0_3:Flush()
end

function var0_0.SetData(arg0_4)
	local var0_4 = getProxy(EducateProxy)

	arg0_4.endings = var0_4:GetAllEndings()
	arg0_4.completeEndings = var0_4:GetCompleteEndings()
	arg0_4.char = var0_4:GetCharData()
	arg0_4.gameCnt = var0_4:GetGameCnt()
	arg0_4.bugCnt = var0_4:GetEndingBuyCnt()
end

function var0_0.Flush(arg0_5)
	arg0_5:SetData()
	setText(arg0_5.curCntTF, #arg0_5.endings)
	setText(arg0_5.allCntTF, "/" .. #arg0_5.config.all)
	arg0_5:updatePage()
end

function var0_0.updateItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = var1_0[arg2_6.name]

	GetImageSpriteFromAtlasAsync("ui/educateendingui_atlas", var0_6 .. "_" .. arg1_6.sp_bg, arg2_6)
	LoadImageSpriteAsync("bg/" .. arg1_6.pic, arg2_6:Find("icon/Image"))
	setText(arg2_6:Find("unlock/name"), arg1_6.name)
	setText(arg2_6:Find("lock/name"), arg1_6.lock_name)

	local var1_6 = table.contains(arg0_6.endings, arg1_6.id)

	setActive(arg2_6:Find("icon/lock"), not var1_6)
	setActive(arg2_6:Find("unlock"), var1_6)
	setActive(arg2_6:Find("lock"), not var1_6)

	if var1_6 then
		onButton(arg0_6, arg2_6, function()
			arg0_6:showPerformWindow(arg1_6)
		end, SFX_PANEL)
		setActive(arg2_6:Find("unlock/complete"), table.contains(arg0_6.completeEndings, arg1_6.id))
	else
		removeOnButton(arg2_6)

		local var2_6 = arg2_6:Find("lock/desc/conditions")
		local var3_6 = arg1_6.condition

		arg0_6:updateConditions(var3_6, var2_6)
		setActive(var2_6, #arg1_6.condition > 0)

		local var4_6 = arg2_6:Find("lock/desc/Text")

		setText(var4_6, arg1_6.unlock_desc)
		setActive(var4_6, arg1_6.unlock_desc ~= "")

		local var5_6 = arg2_6:Find("lock/unlock_btn")

		setActive(var5_6, arg0_6.gameCnt > 1)
		onButton(arg0_6, var5_6, function()
			arg0_6:OnClickBuyBtn(arg1_6)
		end, SFX_PANEL)
	end
end

function var0_0.updateConditions(arg0_9, arg1_9, arg2_9)
	local var0_9 = 0

	for iter0_9 = 1, #arg1_9 do
		local var1_9 = arg1_9[iter0_9]

		if var1_9[1] == EducateConst.DROP_TYPE_ATTR then
			var0_9 = var0_9 + 1

			local var2_9 = iter0_9 <= arg2_9.childCount and arg2_9:GetChild(iter0_9 - 1) or cloneTplTo(arg0_9.tpl, arg2_9)
			local var3_9 = false
			local var4_9 = ""

			if var1_9[3] then
				var3_9 = arg0_9.char:GetAttrById(var1_9[2]) >= var1_9[3]
				var4_9 = pg.child_attr[var1_9[2]].name .. " > " .. var1_9[3]
			else
				var3_9 = arg0_9.char:GetPersonalityId() == var1_9[2]
				var4_9 = i18n("child_nature_title") .. pg.child_attr[var1_9[2]].name
			end

			setActive(var2_9:Find("icon/unlock"), var3_9)

			local var5_9 = var3_9 and "F59F48" or "FFFFFF"

			setTextColor(var2_9:Find("Text"), Color.NewHex(var5_9))
			setText(var2_9:Find("Text"), var4_9)
		end
	end

	for iter1_9 = 1, arg2_9.childCount do
		setActive(arg2_9:GetChild(iter1_9 - 1), iter1_9 <= var0_9)
	end
end

function var0_0.showPerformWindow(arg0_10, arg1_10)
	local var0_10 = arg0_10.performTF:Find("Image")

	LoadImageSpriteAsync("bg/" .. arg1_10.pic, var0_10)
	setActive(arg0_10.performTF, true)
	onButton(arg0_10, var0_10, function()
		setActive(arg0_10.performTF, false)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.performTF:Find("review_btn"), function()
		pg.PerformMgr.GetInstance():PlayGroup(arg1_10.performance)
	end, SFX_PANEL)
end

function var0_0.OnClickBuyBtn(arg0_13, arg1_13)
	local var0_13 = arg1_13.lock_name
	local var1_13 = math.min(arg0_13.maxPrice, arg1_13.child_cg_basic_price + arg0_13.bugCnt * arg0_13.addPrice)

	arg0_13:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
		content = i18n("child_cg_buy", var1_13, var0_13),
		onYes = function()
			arg0_13:emit(EducateCollectMediatorTemplate.UNLOCK, {
				type = EducateBuyCollectCommand.TYPE.ENDING,
				id = arg1_13.id,
				cost = var1_13
			})
		end
	})
end

function var0_0.playAnimChange(arg0_15)
	arg0_15.anim:Stop()
	arg0_15.anim:Play("anim_educate_ending_change")
end

function var0_0.playAnimClose(arg0_16)
	arg0_16.anim:Play("anim_educate_ending_out")
end

return var0_0
