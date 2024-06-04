local var0 = class("RefluxPTView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "RefluxPTUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:updateUI()
end

function var0.OnDestroy(arg0)
	return
end

function var0.OnBackPress(arg0)
	arg0:Hide()
end

function var0.initData(arg0)
	arg0.refluxProxy = getProxy(RefluxProxy)
end

function var0.initUI(arg0)
	arg0.nextBtn = arg0:findTF("NextBtn")
	arg0.countText = arg0:findTF("PTCount")

	local var0 = arg0.countText:GetComponent(typeof(Text))

	var0.material = Object.Instantiate(var0.material)
	arg0.faceSpriteList = {}

	local var1 = arg0:findTF("Face")

	for iter0 = 0, var1.childCount - 1 do
		local var2 = var1:GetChild(iter0)
		local var3 = getImageSprite(var2)

		table.insert(arg0.faceSpriteList, var3)
	end

	arg0.scrollViewTF = arg0:findTF("ScrollRect")
	arg0.viewportTF = arg0.scrollViewTF
	arg0.tpl = arg0:findTF("StepTpl")
	arg0.tplContainerTF = arg0:findTF("ScrollRect/Container")
	arg0.stepUIIList = UIItemList.New(arg0.tplContainerTF, arg0.tpl)

	arg0.stepUIIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			arg0:updateTpl(arg2, arg1)
		end
	end)
end

function var0.updateData(arg0)
	return
end

function var0.updateUI(arg0)
	arg0:updateTplList()
	arg0:ScrollPt(arg0.refluxProxy.ptStage - 1)
	setText(arg0.countText, arg0.refluxProxy.ptNum)
end

function var0.updateOutline(arg0)
	local var0 = arg0.countText:GetComponent(typeof(Text))

	var0.material = Object.Instantiate(var0.material)
end

function var0.updateTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF("item", arg1)
	local var1 = arg0:findTF("award", var0)
	local var2 = arg0:findTF("text_unlock", var0)
	local var3 = arg0:findTF("text_pt", var0)
	local var4 = arg0:findTF("checked", arg1)
	local var5 = arg0:findTF("face", arg1)
	local var6 = arg0:findTF("progress", arg1)
	local var7 = arg0:findTF("text", var6)
	local var8 = arg0:findTF("Fill Area", var6)
	local var9 = arg0:findTF("achieve", arg1)
	local var10 = pg.return_pt_template[arg2]
	local var11 = arg0.refluxProxy.ptNum
	local var12 = var10.pt_require
	local var13 = arg0.refluxProxy.ptStage + 1
	local var14 = arg0.refluxProxy.ptStage
	local var15 = arg0:getAwardForShow(arg2)

	updateDrop(var1, var15, {
		Q = true
	})
	setText(var2, i18n("reflux_word_2"))
	setText(var3, var12 .. "PT")
	setActive(var4, arg2 < var13)

	local var16 = arg2 < var13 and Color.gray or Color.white
	local var17 = arg1:GetComponentsInChildren(typeof(Image))

	for iter0 = 0, var17.Length - 1 do
		var17[iter0].color = var16
	end

	setImageColor(var0, var16)

	local var18, var19 = arg0:getPTMinAndMax(arg2)

	var6.sizeDelta = Vector2(125, 20)

	setSlider(var6, var18, var19, var11)
	setActive(var8, var18 < var11)
	setText(var7, var12 .. "PT")

	local var20 = arg2 == var13 and var12 <= var11

	setActive(var9, var20)

	if var20 then
		onButton(arg0, arg1, function()
			arg0:onStepClick(arg2)
		end, SFX_PANEL)
	else
		removeOnButton(arg1)
	end

	local var21 = (arg2 - 1) % 10 + 1
	local var22 = arg0.faceSpriteList[var21]

	setImageSprite(var5, var22)
end

function var0.updateTplList(arg0)
	arg0.stepUIIList:align(#pg.return_pt_template.all)
end

function var0.updateAfterServer(arg0)
	local var0 = #pg.return_pt_template.all
	local var1 = arg0.refluxProxy.ptStage + 1
	local var2 = var1 - 1

	if var1 <= var0 and var1 >= 1 then
		local var3 = arg0.tplContainerTF:GetChild(var1 - 1)

		arg0:updateTpl(var3, var1)
	end

	if var2 <= var0 and var2 >= 1 then
		local var4 = arg0.tplContainerTF:GetChild(var2 - 1)

		arg0:updateTpl(var4, var2)
	end

	arg0:ScrollPt(arg0.refluxProxy.ptStage - 1)
end

function var0.ScrollPt(arg0, arg1, arg2, arg3)
	local var0 = arg0.tplContainerTF:GetComponent(typeof(HorizontalLayoutGroup))
	local var1 = arg0.tpl:GetComponent(typeof(LayoutElement))
	local var2 = math.max(arg1 * (var1.preferredWidth + var0.spacing) - arg0.viewportTF.rect.width * 0.5 + var1.preferredWidth, 0)
	local var3 = arg0.tplContainerTF.childCount * var1.preferredWidth + (arg0.tplContainerTF.childCount - 1) * var0.spacing - arg0.viewportTF.rect.width
	local var4 = math.clamp(var2 / var3, 0, 1)

	arg0.scrollViewTF:GetComponent(typeof(ScrollRect)).horizontalNormalizedPosition = var4
end

function var0.onStepClick(arg0, arg1)
	local function var0()
		pg.m02:sendNotification(GAME.REFLUX_GET_PT_AWARD)
	end

	local var1 = arg0:getAwardForShow(arg1)

	var1[1] = var1.type
	var1[2] = var1.id
	var1[3] = var1.count

	local var2 = {
		var1
	}
	local var3, var4 = Task.StaticJudgeOverflow(false, false, false, true, true, var2)

	if var3 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("award_max_warning"),
			items = var4,
			onYes = var0
		})
	else
		var0()
	end
end

function var0.getAwardForShow(arg0, arg1)
	local var0 = pg.return_pt_template[arg1]
	local var1 = var0.level
	local var2 = arg0.refluxProxy.returnLV
	local var3

	for iter0, iter1 in ipairs(var1) do
		local var4 = iter1[1]
		local var5 = iter1[2]

		if var4 <= var2 and var2 <= var5 then
			var3 = iter0
		end
	end

	local var6 = var0.award_display[var3]

	return {
		type = var6[1],
		id = var6[2],
		count = var6[3]
	}
end

function var0.getPTMinAndMax(arg0, arg1)
	local var0
	local var1
	local var2 = pg.return_pt_template[arg1].pt_require
	local var3 = arg1 - 1
	local var4 = pg.return_pt_template[var3]

	if var4 then
		var0 = var4.pt_require
	else
		var0 = 0
	end

	return var0, var2
end

function var0.isAnyPTCanGetAward()
	local var0 = #pg.return_pt_template.all
	local var1 = getProxy(RefluxProxy)
	local var2 = var1.ptStage + 1

	if var2 <= var0 then
		return pg.return_pt_template[var2].pt_require <= var1.ptNum
	else
		return false
	end
end

return var0
