local var0_0 = class("EducateTargetSetLayer", import(".base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateTargetSetUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	arg0_3:initTargetList()

	arg0_3.selectedIndex = 1
end

function var0_0.initTargetList(arg0_4)
	local var0_4 = getProxy(EducateProxy)
	local var1_4 = var0_4:GetCharData()

	arg0_4.maxAttrId = var1_4:GetAttrSortIds()[1]

	local var2_4 = var1_4:GetStage()
	local var3_4 = var0_4:GetTaskProxy():GetTargetId() == 0 and 1 or var2_4 + 1
	local var4_4 = var0_4:GetPersonalityId()
	local var5_4 = {}
	local var6_4 = {}

	for iter0_4, iter1_4 in ipairs(pg.child_target_set.all) do
		if pg.child_target_set[iter1_4].stage == var3_4 then
			local var7_4 = pg.child_target_set[iter1_4].condition

			if var7_4 == "" or #var7_4 == 0 then
				table.insert(var5_4, iter1_4)
			elseif var4_4 == var7_4[2][1] then
				table.insert(var6_4, iter1_4)
			end
		end
	end

	table.sort(var6_4, CompareFuncs({
		function(arg0_5)
			local var0_5 = pg.child_target_set[arg0_5].condition[1][1]

			return -var1_4:GetAttrById(var0_5)
		end,
		function(arg0_6)
			return arg0_6
		end
	}))

	local var8_4 = 0

	arg0_4.targetList = {}

	for iter2_4, iter3_4 in ipairs(var6_4) do
		table.insert(arg0_4.targetList, iter3_4)

		var8_4 = var8_4 + 1

		if var8_4 == 4 then
			break
		end
	end

	if var8_4 < 4 then
		for iter4_4, iter5_4 in ipairs(var5_4) do
			table.insert(arg0_4.targetList, iter5_4)

			var8_4 = var8_4 + 1

			if var8_4 == 4 then
				break
			end
		end
	end
end

function var0_0.findUI(arg0_7)
	arg0_7.windowTF = arg0_7:findTF("anim_root/window")
	arg0_7.targetContent = arg0_7:findTF("content", arg0_7.windowTF)
	arg0_7.targetTpl = arg0_7:findTF("tpl", arg0_7.targetContent)

	setActive(arg0_7.targetTpl, false)

	arg0_7.sureBtn = arg0_7:findTF("sure_btn", arg0_7.windowTF)

	setText(arg0_7:findTF("Text", arg0_7.sureBtn), i18n("word_ok"))
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.sureBtn, function()
		local var0_9 = arg0_8.targetList[arg0_8.selectedIndex]
		local var1_9 = pg.child_target_set[var0_9].recommend_attr2
		local var2_9 = pg.child_attr[var1_9].name

		arg0_8:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_target_set_sure_tip", var2_9),
			onYes = function()
				arg0_8:emit(EducateTargetSetMediator.ON_TARGET_SET, {
					open = true,
					id = var0_9
				})

				local var0_10 = arg0_8:findTF("anim_root"):GetComponent(typeof(Animation))
				local var1_10 = arg0_8:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

				var1_10:SetEndEvent(function()
					var1_10:SetEndEvent(nil)
					arg0_8:emit(var0_0.ON_CLOSE)
				end)
				var0_10:Play("anim_educate_targetset_out")
			end
		})
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_12)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
	arg0_12:initTarget()
end

function var0_0.initTarget(arg0_13)
	for iter0_13 = 1, #arg0_13.targetList do
		local var0_13 = cloneTplTo(arg0_13.targetTpl, arg0_13.targetContent, tostring(iter0_13))
		local var1_13 = arg0_13.targetList[iter0_13]

		setImageSprite(arg0_13:findTF("animroot/icon/Image", var0_13), LoadSprite("educatetarget/" .. pg.child_target_set[var1_13].icon), true)
		setImageSprite(arg0_13:findTF("animroot/name", var0_13), LoadSprite("educatetarget/" .. pg.child_target_set[var1_13].pic), true)
		onButton(arg0_13, var0_13, function()
			if arg0_13.selectedIndex == iter0_13 then
				return
			end

			arg0_13.selectedIndex = iter0_13

			arg0_13:updateTarget()
		end, SFX_PANEL)

		local var2_13 = pg.child_target_set[var1_13].recommend_attr

		setActive(arg0_13:findTF("animroot/recommand", var0_13), var2_13 == arg0_13.maxAttrId)
	end

	arg0_13:updateTarget()

	local var3_13 = {}

	table.insert(var3_13, function(arg0_15)
		onDelayTick(function()
			arg0_15()
		end, 0.066)
	end)

	for iter1_13 = 1, #arg0_13.targetList do
		table.insert(var3_13, function(arg0_17)
			arg0_13:findTF(tostring(iter1_13), arg0_13.targetContent):GetComponent(typeof(Animation)):Play("anim_educate_targetset_tpl_in")
			onDelayTick(function()
				arg0_17()
			end, 0.066)
		end)
	end

	seriesAsync(var3_13, function()
		return
	end)
end

function var0_0.updateTarget(arg0_20)
	eachChild(arg0_20.targetContent, function(arg0_21)
		setActive(arg0_20:findTF("animroot/selected", arg0_21), arg0_20.selectedIndex == tonumber(arg0_21.name))
	end)
end

function var0_0.willExit(arg0_22)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_22._tf)
end

function var0_0.onBackPressed(arg0_23)
	return
end

return var0_0
