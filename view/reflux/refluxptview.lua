local var0_0 = class("RefluxPTView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "RefluxPTUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:updateUI()
end

function var0_0.OnDestroy(arg0_3)
	return
end

function var0_0.OnBackPress(arg0_4)
	arg0_4:Hide()
end

function var0_0.initData(arg0_5)
	arg0_5.refluxProxy = getProxy(RefluxProxy)
end

function var0_0.initUI(arg0_6)
	arg0_6.nextBtn = arg0_6:findTF("NextBtn")
	arg0_6.countText = arg0_6:findTF("PTCount")

	local var0_6 = arg0_6.countText:GetComponent(typeof(Text))

	var0_6.material = Object.Instantiate(var0_6.material)
	arg0_6.faceSpriteList = {}

	local var1_6 = arg0_6:findTF("Face")

	for iter0_6 = 0, var1_6.childCount - 1 do
		local var2_6 = var1_6:GetChild(iter0_6)
		local var3_6 = getImageSprite(var2_6)

		table.insert(arg0_6.faceSpriteList, var3_6)
	end

	arg0_6.scrollViewTF = arg0_6:findTF("ScrollRect")
	arg0_6.viewportTF = arg0_6.scrollViewTF
	arg0_6.tpl = arg0_6:findTF("StepTpl")
	arg0_6.tplContainerTF = arg0_6:findTF("ScrollRect/Container")
	arg0_6.stepUIIList = UIItemList.New(arg0_6.tplContainerTF, arg0_6.tpl)

	arg0_6.stepUIIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg1_7 = arg1_7 + 1

			arg0_6:updateTpl(arg2_7, arg1_7)
		end
	end)
end

function var0_0.updateData(arg0_8)
	return
end

function var0_0.updateUI(arg0_9)
	arg0_9:updateTplList()
	arg0_9:ScrollPt(arg0_9.refluxProxy.ptStage - 1)
	setText(arg0_9.countText, arg0_9.refluxProxy.ptNum)
end

function var0_0.updateOutline(arg0_10)
	local var0_10 = arg0_10.countText:GetComponent(typeof(Text))

	var0_10.material = Object.Instantiate(var0_10.material)
end

function var0_0.updateTpl(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11:findTF("item", arg1_11)
	local var1_11 = arg0_11:findTF("award", var0_11)
	local var2_11 = arg0_11:findTF("text_unlock", var0_11)
	local var3_11 = arg0_11:findTF("text_pt", var0_11)
	local var4_11 = arg0_11:findTF("checked", arg1_11)
	local var5_11 = arg0_11:findTF("face", arg1_11)
	local var6_11 = arg0_11:findTF("progress", arg1_11)
	local var7_11 = arg0_11:findTF("text", var6_11)
	local var8_11 = arg0_11:findTF("Fill Area", var6_11)
	local var9_11 = arg0_11:findTF("achieve", arg1_11)
	local var10_11 = pg.return_pt_template[arg2_11]
	local var11_11 = arg0_11.refluxProxy.ptNum
	local var12_11 = var10_11.pt_require
	local var13_11 = arg0_11.refluxProxy.ptStage + 1
	local var14_11 = arg0_11.refluxProxy.ptStage
	local var15_11 = arg0_11:getAwardForShow(arg2_11)

	updateDrop(var1_11, var15_11, {
		Q = true
	})
	setText(var2_11, i18n("reflux_word_2"))
	setText(var3_11, var12_11 .. "PT")
	setActive(var4_11, arg2_11 < var13_11)

	local var16_11 = arg2_11 < var13_11 and Color.gray or Color.white
	local var17_11 = arg1_11:GetComponentsInChildren(typeof(Image))

	for iter0_11 = 0, var17_11.Length - 1 do
		var17_11[iter0_11].color = var16_11
	end

	setImageColor(var0_11, var16_11)

	local var18_11, var19_11 = arg0_11:getPTMinAndMax(arg2_11)

	var6_11.sizeDelta = Vector2(125, 20)

	setSlider(var6_11, var18_11, var19_11, var11_11)
	setActive(var8_11, var18_11 < var11_11)
	setText(var7_11, var12_11 .. "PT")

	local var20_11 = arg2_11 == var13_11 and var12_11 <= var11_11

	setActive(var9_11, var20_11)

	if var20_11 then
		onButton(arg0_11, arg1_11, function()
			arg0_11:onStepClick(arg2_11)
		end, SFX_PANEL)
	else
		removeOnButton(arg1_11)
	end

	local var21_11 = (arg2_11 - 1) % 10 + 1
	local var22_11 = arg0_11.faceSpriteList[var21_11]

	setImageSprite(var5_11, var22_11)
end

function var0_0.updateTplList(arg0_13)
	arg0_13.stepUIIList:align(#pg.return_pt_template.all)
end

function var0_0.updateAfterServer(arg0_14)
	local var0_14 = #pg.return_pt_template.all
	local var1_14 = arg0_14.refluxProxy.ptStage + 1
	local var2_14 = var1_14 - 1

	if var1_14 <= var0_14 and var1_14 >= 1 then
		local var3_14 = arg0_14.tplContainerTF:GetChild(var1_14 - 1)

		arg0_14:updateTpl(var3_14, var1_14)
	end

	if var2_14 <= var0_14 and var2_14 >= 1 then
		local var4_14 = arg0_14.tplContainerTF:GetChild(var2_14 - 1)

		arg0_14:updateTpl(var4_14, var2_14)
	end

	arg0_14:ScrollPt(arg0_14.refluxProxy.ptStage - 1)
end

function var0_0.ScrollPt(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = arg0_15.tplContainerTF:GetComponent(typeof(HorizontalLayoutGroup))
	local var1_15 = arg0_15.tpl:GetComponent(typeof(LayoutElement))
	local var2_15 = math.max(arg1_15 * (var1_15.preferredWidth + var0_15.spacing) - arg0_15.viewportTF.rect.width * 0.5 + var1_15.preferredWidth, 0)
	local var3_15 = arg0_15.tplContainerTF.childCount * var1_15.preferredWidth + (arg0_15.tplContainerTF.childCount - 1) * var0_15.spacing - arg0_15.viewportTF.rect.width
	local var4_15 = math.clamp(var2_15 / var3_15, 0, 1)

	arg0_15.scrollViewTF:GetComponent(typeof(ScrollRect)).horizontalNormalizedPosition = var4_15
end

function var0_0.onStepClick(arg0_16, arg1_16)
	local function var0_16()
		pg.m02:sendNotification(GAME.REFLUX_GET_PT_AWARD)
	end

	local var1_16 = arg0_16:getAwardForShow(arg1_16)

	var1_16[1] = var1_16.type
	var1_16[2] = var1_16.id
	var1_16[3] = var1_16.count

	local var2_16 = {
		var1_16
	}
	local var3_16, var4_16 = Task.StaticJudgeOverflow(false, false, false, true, true, var2_16)

	if var3_16 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("award_max_warning"),
			items = var4_16,
			onYes = var0_16
		})
	else
		var0_16()
	end
end

function var0_0.getAwardForShow(arg0_18, arg1_18)
	local var0_18 = pg.return_pt_template[arg1_18]
	local var1_18 = var0_18.level
	local var2_18 = arg0_18.refluxProxy.returnLV
	local var3_18

	for iter0_18, iter1_18 in ipairs(var1_18) do
		local var4_18 = iter1_18[1]
		local var5_18 = iter1_18[2]

		if var4_18 <= var2_18 and var2_18 <= var5_18 then
			var3_18 = iter0_18
		end
	end

	local var6_18 = var0_18.award_display[var3_18]

	return {
		type = var6_18[1],
		id = var6_18[2],
		count = var6_18[3]
	}
end

function var0_0.getPTMinAndMax(arg0_19, arg1_19)
	local var0_19
	local var1_19
	local var2_19 = pg.return_pt_template[arg1_19].pt_require
	local var3_19 = arg1_19 - 1
	local var4_19 = pg.return_pt_template[var3_19]

	if var4_19 then
		var0_19 = var4_19.pt_require
	else
		var0_19 = 0
	end

	return var0_19, var2_19
end

function var0_0.isAnyPTCanGetAward()
	local var0_20 = #pg.return_pt_template.all
	local var1_20 = getProxy(RefluxProxy)
	local var2_20 = var1_20.ptStage + 1

	if var2_20 <= var0_20 then
		return pg.return_pt_template[var2_20].pt_require <= var1_20.ptNum
	else
		return false
	end
end

return var0_0
