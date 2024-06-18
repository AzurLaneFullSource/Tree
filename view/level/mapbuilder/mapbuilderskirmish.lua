local var0_0 = import(".MapBuilder")
local var1_0 = class("MapBuilderSkirmish", var0_0)

function var1_0.GetType(arg0_1)
	return var0_0.TYPESKIRMISH
end

function var1_0.getUIName(arg0_2)
	return "skirmish_levels"
end

function var1_0.Update(arg0_3, ...)
	local var0_3 = arg0_3._tf
	local var1_3 = 0.21875

	var0_3.pivot = Vector2(var1_3, 1)
	var0_3.anchorMin = Vector2(0.5, 1)
	var0_3.anchorMax = Vector2(0.5, 1)

	local var2_3 = (var1_3 - 0.5) * arg0_3._parentTf.rect.width

	var0_3.anchoredPosition = Vector2(var2_3, 0)
	arg0_3.map.pivot = Vector2(var1_3, 1)

	local var3_3 = arg0_3.map.rect.width / arg0_3.map.rect.height
	local var4_3 = arg0_3._parentTf.rect.width / arg0_3._parentTf.rect.height
	local var5_3

	if var3_3 < var4_3 then
		var5_3 = arg0_3._parentTf.rect.width / arg0_3._tf.rect.width
	else
		var5_3 = arg0_3._parentTf.rect.height / arg0_3._tf.rect.height
	end

	arg0_3._tf.localScale = Vector3(var5_3, var5_3, var5_3)

	var1_0.super.Update(arg0_3, ...)
end

local var2_0 = Vector2(-193.5, 120.6)
local var3_0 = Vector2(211.3, 116.5263)
local var4_0 = Vector2(0, -622)
local var5_0 = Vector2(-114, -372)

function var1_0.UpdateMapItems(arg0_4)
	var1_0.super.UpdateMapItems(arg0_4)

	local var0_4 = getProxy(SkirmishProxy)

	if var0_4:TryFetchNewTask() then
		return
	end

	local var1_4 = arg0_4._tf
	local var2_4 = var1_4:Find("skirmish_items")
	local var3_4 = var1_4:Find("point_Links")
	local var4_4 = var1_4:Find("levelinfo")

	var0_4:UpdateSkirmishProgress()

	local var5_4 = var0_4:getRawData()

	for iter0_4 = 1, var2_4.childCount do
		go(var2_4:GetChild(iter0_4 - 1)):SetActive(false)
	end

	for iter1_4 = 1, var3_4.childCount do
		go(var3_4:GetChild(iter1_4 - 1)):SetActive(false)
	end

	local var6_4 = 0
	local var7_4 = false
	local var8_4 = 0
	local var9_4 = 0

	for iter2_4, iter3_4 in ipairs(var5_4) do
		local var10_4 = iter3_4
		local var11_4 = var2_4:GetChild(iter2_4 - 1)

		if iter2_4 - 2 >= 0 then
			go(var3_4:GetChild(iter2_4 - 2)):SetActive(var10_4:GetState() > SkirmishVO.StateActive)
		end

		local var12_4 = iter3_4:GetState()

		setActive(var11_4, var12_4 > SkirmishVO.StateActive)
		setActive(var11_4:Find("flag"), var12_4 == SkirmishVO.StateWorking)
		setActive(var11_4:Find("clear"), var12_4 == SkirmishVO.StateClear)

		var8_4 = var12_4 > SkirmishVO.StateInactive and var8_4 + 1 or var8_4
		var9_4 = var12_4 == SkirmishVO.StateClear and var9_4 + 1 or var9_4

		if var12_4 == SkirmishVO.StateWorking then
			var6_4 = iter2_4
		end

		if var10_4.flagNew then
			var10_4.flagNew = nil

			if iter2_4 ~= 1 then
				go(var11_4):SetActive(false)

				var7_4 = true

				local var13_4 = var3_4:GetChild(iter2_4 - 2):GetComponent(typeof(Image))

				var13_4.fillAmount = 0

				LeanTween.value(go(var11_4), 0, 1, 2):setOnUpdate(System.Action_float(function(arg0_5)
					var13_4.fillAmount = arg0_5
				end)):setOnComplete(System.Action(function()
					go(var11_4):SetActive(true)
					go(var4_4):SetActive(true)
				end)):setDelay(0.5)
			end
		end

		local var14_4 = var10_4:getConfig("task_id")

		onButton(arg0_4.sceneParent, var11_4, function()
			if var12_4 ~= SkirmishVO.StateWorking then
				return
			end

			local var0_7 = var10_4:GetType()
			local var1_7 = var10_4:GetEvent()

			if var0_7 == SkirmishVO.TypeStoryOrExpedition then
				if tonumber(var1_7) then
					var1_7 = tonumber(var1_7)

					local var2_7 = arg0_4.sceneParent.contextData

					arg0_4:InvokeParent("emit", LevelMediator2.ON_PERFORM_COMBAT, var1_7, function()
						var2_7.preparedTaskList = var2_7.preparedTaskList or {}

						table.insert(var2_7.preparedTaskList, var14_4)
					end)
				else
					pg.NewStoryMgr.GetInstance():Play(var1_7, function()
						arg0_4:InvokeParent("emit", LevelMediator2.ON_SUBMIT_TASK, var14_4)
					end)
				end
			elseif var0_7 == SkirmishVO.TypeChapter then
				local var3_7 = tonumber(var1_7)
				local var4_7 = getProxy(ChapterProxy):getChapterById(var3_7)

				arg0_4:InvokeParent("TrySwitchChapter", var4_7)
			end
		end)
	end

	if var6_4 > 0 then
		setActive(var4_4, not var7_4)

		local var15_4 = var2_4:GetChild(var6_4 - 1)

		var4_4.anchoredPosition = var15_4.anchoredPosition:Add(var6_4 == 3 and var3_0 or var2_0)

		setActive(var4_4:Find("line1"), var6_4 ~= 3)
		setActive(var4_4:Find("line2"), var6_4 == 3)
		setText(var4_4:Find("info/position"), string.format("POSITION  %02d", var6_4))
		setText(var4_4:Find("info/name"), var5_4[var6_4]:getConfig("name"))
		onButton(arg0_4.sceneParent, var4_4, function()
			triggerButton(var15_4)
		end)
	else
		setActive(var4_4, false)
	end

	local var16_4 = var1_4:Find("cloud")

	var16_4.anchoredPosition = var4_0

	LeanTween.value(go(var16_4), var4_0, var5_0, 30):setOnUpdateVector2(function(arg0_11)
		var16_4.anchoredPosition = arg0_11
	end)

	arg0_4.sceneParent.skirmishBar:Find("text"):GetComponent(typeof(Text)).text = var8_4 - var9_4
end

function var1_0.OnShow(arg0_12)
	setActive(arg0_12.sceneParent.topChapter:Find("type_skirmish"), true)
	setActive(arg0_12.sceneParent.skirmishBar, true)
	setActive(arg0_12.sceneParent.leftChapter:Find("buttons"), false)
	setActive(arg0_12.sceneParent.eventContainer, false)
	setActive(arg0_12.sceneParent.rightChapter, false)
end

function var1_0.OnHide(arg0_13)
	setActive(arg0_13.sceneParent.topChapter:Find("type_skirmish"), false)
	setActive(arg0_13.sceneParent.skirmishBar, false)
	setActive(arg0_13.sceneParent.leftChapter:Find("buttons"), true)
	setActive(arg0_13.sceneParent.eventContainer, true)
	setActive(arg0_13.sceneParent.rightChapter, true)

	local var0_13 = arg0_13._tf:Find("skirmish_items")

	for iter0_13 = 1, var0_13.childCount do
		local var1_13 = var0_13:GetChild(iter0_13 - 1)

		LeanTween.cancel(go(var1_13))
	end

	local var2_13 = arg0_13._tf:Find("cloud")

	LeanTween.cancel(go(var2_13))
end

return var1_0
