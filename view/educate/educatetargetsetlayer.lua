local var0 = class("EducateTargetSetLayer", import(".base.EducateBaseUI"))

function var0.getUIName(arg0)
	return "EducateTargetSetUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	arg0:initTargetList()

	arg0.selectedIndex = 1
end

function var0.initTargetList(arg0)
	local var0 = getProxy(EducateProxy)
	local var1 = var0:GetCharData()

	arg0.maxAttrId = var1:GetAttrSortIds()[1]

	local var2 = var1:GetStage()
	local var3 = var0:GetTaskProxy():GetTargetId() == 0 and 1 or var2 + 1
	local var4 = var0:GetPersonalityId()
	local var5 = {}
	local var6 = {}

	for iter0, iter1 in ipairs(pg.child_target_set.all) do
		if pg.child_target_set[iter1].stage == var3 then
			local var7 = pg.child_target_set[iter1].condition

			if var7 == "" or #var7 == 0 then
				table.insert(var5, iter1)
			elseif var4 == var7[2][1] then
				table.insert(var6, iter1)
			end
		end
	end

	table.sort(var6, CompareFuncs({
		function(arg0)
			local var0 = pg.child_target_set[arg0].condition[1][1]

			return -var1:GetAttrById(var0)
		end,
		function(arg0)
			return arg0
		end
	}))

	local var8 = 0

	arg0.targetList = {}

	for iter2, iter3 in ipairs(var6) do
		table.insert(arg0.targetList, iter3)

		var8 = var8 + 1

		if var8 == 4 then
			break
		end
	end

	if var8 < 4 then
		for iter4, iter5 in ipairs(var5) do
			table.insert(arg0.targetList, iter5)

			var8 = var8 + 1

			if var8 == 4 then
				break
			end
		end
	end
end

function var0.findUI(arg0)
	arg0.windowTF = arg0:findTF("anim_root/window")
	arg0.targetContent = arg0:findTF("content", arg0.windowTF)
	arg0.targetTpl = arg0:findTF("tpl", arg0.targetContent)

	setActive(arg0.targetTpl, false)

	arg0.sureBtn = arg0:findTF("sure_btn", arg0.windowTF)

	setText(arg0:findTF("Text", arg0.sureBtn), i18n("word_ok"))
end

function var0.addListener(arg0)
	onButton(arg0, arg0.sureBtn, function()
		local var0 = arg0.targetList[arg0.selectedIndex]
		local var1 = pg.child_target_set[var0].recommend_attr2
		local var2 = pg.child_attr[var1].name

		arg0:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_target_set_sure_tip", var2),
			onYes = function()
				arg0:emit(EducateTargetSetMediator.ON_TARGET_SET, {
					open = true,
					id = var0
				})

				local var0 = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
				local var1 = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

				var1:SetEndEvent(function()
					var1:SetEndEvent(nil)
					arg0:emit(var0.ON_CLOSE)
				end)
				var0:Play("anim_educate_targetset_out")
			end
		})
	end, SFX_PANEL)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:initTarget()
end

function var0.initTarget(arg0)
	for iter0 = 1, #arg0.targetList do
		local var0 = cloneTplTo(arg0.targetTpl, arg0.targetContent, tostring(iter0))
		local var1 = arg0.targetList[iter0]

		setImageSprite(arg0:findTF("animroot/icon/Image", var0), LoadSprite("educatetarget/" .. pg.child_target_set[var1].icon), true)
		setImageSprite(arg0:findTF("animroot/name", var0), LoadSprite("educatetarget/" .. pg.child_target_set[var1].pic), true)
		onButton(arg0, var0, function()
			if arg0.selectedIndex == iter0 then
				return
			end

			arg0.selectedIndex = iter0

			arg0:updateTarget()
		end, SFX_PANEL)

		local var2 = pg.child_target_set[var1].recommend_attr

		setActive(arg0:findTF("animroot/recommand", var0), var2 == arg0.maxAttrId)
	end

	arg0:updateTarget()

	local var3 = {}

	table.insert(var3, function(arg0)
		onDelayTick(function()
			arg0()
		end, 0.066)
	end)

	for iter1 = 1, #arg0.targetList do
		table.insert(var3, function(arg0)
			arg0:findTF(tostring(iter1), arg0.targetContent):GetComponent(typeof(Animation)):Play("anim_educate_targetset_tpl_in")
			onDelayTick(function()
				arg0()
			end, 0.066)
		end)
	end

	seriesAsync(var3, function()
		return
	end)
end

function var0.updateTarget(arg0)
	eachChild(arg0.targetContent, function(arg0)
		setActive(arg0:findTF("animroot/selected", arg0), arg0.selectedIndex == tonumber(arg0.name))
	end)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.onBackPressed(arg0)
	return
end

return var0
