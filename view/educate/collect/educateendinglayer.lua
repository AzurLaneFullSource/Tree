local var0_0 = class("EducateEndingLayer", import(".EducateCollectLayerTemplate"))

function var0_0.getUIName(arg0_1)
	return "EducateEndingUI"
end

function var0_0.initConfig(arg0_2)
	arg0_2.config = pg.child_ending
end

function var0_0.didEnter(arg0_3)
	setText(arg0_3:findTF("review_btn/Text", arg0_3.performTF), i18n("child_btn_review"))

	arg0_3.endings = getProxy(EducateProxy):GetFinishEndings()
	arg0_3.char = getProxy(EducateProxy):GetCharData()
	arg0_3.tpl = arg0_3:findTF("condition_tpl", arg0_3.windowTF)

	setText(arg0_3.curCntTF, #arg0_3.endings)
	setText(arg0_3.allCntTF, "/" .. #arg0_3.config.all)
	arg0_3:updatePage()
end

function var0_0.updateItem(arg0_4, arg1_4, arg2_4)
	local var0_4 = table.contains(arg0_4.endings, arg1_4.id)

	if var0_4 then
		LoadImageSpriteAsync("bg/" .. arg1_4.pic, arg0_4:findTF("unlock/mask/Image", arg2_4))
		setText(arg0_4:findTF("unlock/name", arg2_4), arg1_4.name)
		onButton(arg0_4, arg2_4, function()
			arg0_4:showPerformWindow(arg1_4)
		end, SFX_PANEL)
	else
		removeOnButton(arg2_4)

		local var1_4 = arg0_4:findTF("lock/conditions", arg2_4)
		local var2_4 = arg1_4.condition

		arg0_4:updateConditions(var2_4, var1_4)
	end

	setActive(arg0_4:findTF("unlock", arg2_4), var0_4)
	setActive(arg0_4:findTF("lock", arg2_4), not var0_4)
end

function var0_0.updateConditions(arg0_6, arg1_6, arg2_6)
	local var0_6 = 0

	for iter0_6 = 1, #arg1_6 do
		local var1_6 = arg1_6[iter0_6]

		if var1_6[1] == EducateConst.DROP_TYPE_ATTR then
			var0_6 = var0_6 + 1

			local var2_6 = iter0_6 <= arg2_6.childCount and arg2_6:GetChild(iter0_6 - 1) or cloneTplTo(arg0_6.tpl, arg2_6)
			local var3_6 = false
			local var4_6 = ""

			if var1_6[3] then
				var3_6 = arg0_6.char:GetAttrById(var1_6[2]) >= var1_6[3]
				var4_6 = pg.child_attr[var1_6[2]].name .. " > " .. var1_6[3]
			else
				var3_6 = arg0_6.char:GetPersonalityId() == var1_6[2]
				var4_6 = i18n("child_nature_title") .. pg.child_attr[var1_6[2]].name
			end

			setActive(arg0_6:findTF("icon/unlock", var2_6), var3_6)

			local var5_6 = var3_6 and "F59F48" or "888888"

			setTextColor(arg0_6:findTF("Text", var2_6), Color.NewHex(var5_6))
			setText(arg0_6:findTF("Text", var2_6), var4_6)
		end
	end

	for iter1_6 = 1, arg2_6.childCount do
		setActive(arg2_6:GetChild(iter1_6 - 1), iter1_6 <= var0_6)
	end
end

function var0_0.showPerformWindow(arg0_7, arg1_7)
	local var0_7 = arg0_7:findTF("Image", arg0_7.performTF)

	LoadImageSpriteAsync("bg/" .. arg1_7.pic, var0_7)
	setActive(arg0_7.performTF, true)
	onButton(arg0_7, var0_7, function()
		setActive(arg0_7.performTF, false)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7:findTF("review_btn", arg0_7.performTF), function()
		pg.PerformMgr.GetInstance():PlayGroup(arg1_7.performance)
	end, SFX_PANEL)
end

function var0_0.playAnimChange(arg0_10)
	arg0_10.anim:Stop()
	arg0_10.anim:Play("anim_educate_ending_change")
end

function var0_0.playAnimClose(arg0_11)
	arg0_11.anim:Play("anim_educate_ending_out")
end

return var0_0
