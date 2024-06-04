local var0 = class("EducateEndingLayer", import(".EducateCollectLayerTemplate"))

function var0.getUIName(arg0)
	return "EducateEndingUI"
end

function var0.initConfig(arg0)
	arg0.config = pg.child_ending
end

function var0.didEnter(arg0)
	setText(arg0:findTF("review_btn/Text", arg0.performTF), i18n("child_btn_review"))

	arg0.endings = getProxy(EducateProxy):GetFinishEndings()
	arg0.char = getProxy(EducateProxy):GetCharData()
	arg0.tpl = arg0:findTF("condition_tpl", arg0.windowTF)

	setText(arg0.curCntTF, #arg0.endings)
	setText(arg0.allCntTF, "/" .. #arg0.config.all)
	arg0:updatePage()
end

function var0.updateItem(arg0, arg1, arg2)
	local var0 = table.contains(arg0.endings, arg1.id)

	if var0 then
		LoadImageSpriteAsync("bg/" .. arg1.pic, arg0:findTF("unlock/mask/Image", arg2))
		setText(arg0:findTF("unlock/name", arg2), arg1.name)
		onButton(arg0, arg2, function()
			arg0:showPerformWindow(arg1)
		end, SFX_PANEL)
	else
		removeOnButton(arg2)

		local var1 = arg0:findTF("lock/conditions", arg2)
		local var2 = arg1.condition

		arg0:updateConditions(var2, var1)
	end

	setActive(arg0:findTF("unlock", arg2), var0)
	setActive(arg0:findTF("lock", arg2), not var0)
end

function var0.updateConditions(arg0, arg1, arg2)
	local var0 = 0

	for iter0 = 1, #arg1 do
		local var1 = arg1[iter0]

		if var1[1] == EducateConst.DROP_TYPE_ATTR then
			var0 = var0 + 1

			local var2 = iter0 <= arg2.childCount and arg2:GetChild(iter0 - 1) or cloneTplTo(arg0.tpl, arg2)
			local var3 = false
			local var4 = ""

			if var1[3] then
				var3 = arg0.char:GetAttrById(var1[2]) >= var1[3]
				var4 = pg.child_attr[var1[2]].name .. " > " .. var1[3]
			else
				var3 = arg0.char:GetPersonalityId() == var1[2]
				var4 = i18n("child_nature_title") .. pg.child_attr[var1[2]].name
			end

			setActive(arg0:findTF("icon/unlock", var2), var3)

			local var5 = var3 and "F59F48" or "888888"

			setTextColor(arg0:findTF("Text", var2), Color.NewHex(var5))
			setText(arg0:findTF("Text", var2), var4)
		end
	end

	for iter1 = 1, arg2.childCount do
		setActive(arg2:GetChild(iter1 - 1), iter1 <= var0)
	end
end

function var0.showPerformWindow(arg0, arg1)
	local var0 = arg0:findTF("Image", arg0.performTF)

	LoadImageSpriteAsync("bg/" .. arg1.pic, var0)
	setActive(arg0.performTF, true)
	onButton(arg0, var0, function()
		setActive(arg0.performTF, false)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("review_btn", arg0.performTF), function()
		pg.PerformMgr.GetInstance():PlayGroup(arg1.performance)
	end, SFX_PANEL)
end

function var0.playAnimChange(arg0)
	arg0.anim:Stop()
	arg0.anim:Play("anim_educate_ending_change")
end

function var0.playAnimClose(arg0)
	arg0.anim:Play("anim_educate_ending_out")
end

return var0
