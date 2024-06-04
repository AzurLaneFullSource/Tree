local var0 = import(".MapBuilder")
local var1 = class("MapBuilderSkirmish", var0)

function var1.GetType(arg0)
	return var0.TYPESKIRMISH
end

function var1.getUIName(arg0)
	return "skirmish_levels"
end

function var1.Update(arg0, ...)
	local var0 = arg0._tf
	local var1 = 0.21875

	var0.pivot = Vector2(var1, 1)
	var0.anchorMin = Vector2(0.5, 1)
	var0.anchorMax = Vector2(0.5, 1)

	local var2 = (var1 - 0.5) * arg0._parentTf.rect.width

	var0.anchoredPosition = Vector2(var2, 0)
	arg0.map.pivot = Vector2(var1, 1)

	local var3 = arg0.map.rect.width / arg0.map.rect.height
	local var4 = arg0._parentTf.rect.width / arg0._parentTf.rect.height
	local var5

	if var3 < var4 then
		var5 = arg0._parentTf.rect.width / arg0._tf.rect.width
	else
		var5 = arg0._parentTf.rect.height / arg0._tf.rect.height
	end

	arg0._tf.localScale = Vector3(var5, var5, var5)

	var1.super.Update(arg0, ...)
end

local var2 = Vector2(-193.5, 120.6)
local var3 = Vector2(211.3, 116.5263)
local var4 = Vector2(0, -622)
local var5 = Vector2(-114, -372)

function var1.UpdateMapItems(arg0)
	var1.super.UpdateMapItems(arg0)

	local var0 = getProxy(SkirmishProxy)

	if var0:TryFetchNewTask() then
		return
	end

	local var1 = arg0._tf
	local var2 = var1:Find("skirmish_items")
	local var3 = var1:Find("point_Links")
	local var4 = var1:Find("levelinfo")

	var0:UpdateSkirmishProgress()

	local var5 = var0:getRawData()

	for iter0 = 1, var2.childCount do
		go(var2:GetChild(iter0 - 1)):SetActive(false)
	end

	for iter1 = 1, var3.childCount do
		go(var3:GetChild(iter1 - 1)):SetActive(false)
	end

	local var6 = 0
	local var7 = false
	local var8 = 0
	local var9 = 0

	for iter2, iter3 in ipairs(var5) do
		local var10 = iter3
		local var11 = var2:GetChild(iter2 - 1)

		if iter2 - 2 >= 0 then
			go(var3:GetChild(iter2 - 2)):SetActive(var10:GetState() > SkirmishVO.StateActive)
		end

		local var12 = iter3:GetState()

		setActive(var11, var12 > SkirmishVO.StateActive)
		setActive(var11:Find("flag"), var12 == SkirmishVO.StateWorking)
		setActive(var11:Find("clear"), var12 == SkirmishVO.StateClear)

		var8 = var12 > SkirmishVO.StateInactive and var8 + 1 or var8
		var9 = var12 == SkirmishVO.StateClear and var9 + 1 or var9

		if var12 == SkirmishVO.StateWorking then
			var6 = iter2
		end

		if var10.flagNew then
			var10.flagNew = nil

			if iter2 ~= 1 then
				go(var11):SetActive(false)

				var7 = true

				local var13 = var3:GetChild(iter2 - 2):GetComponent(typeof(Image))

				var13.fillAmount = 0

				LeanTween.value(go(var11), 0, 1, 2):setOnUpdate(System.Action_float(function(arg0)
					var13.fillAmount = arg0
				end)):setOnComplete(System.Action(function()
					go(var11):SetActive(true)
					go(var4):SetActive(true)
				end)):setDelay(0.5)
			end
		end

		local var14 = var10:getConfig("task_id")

		onButton(arg0.sceneParent, var11, function()
			if var12 ~= SkirmishVO.StateWorking then
				return
			end

			local var0 = var10:GetType()
			local var1 = var10:GetEvent()

			if var0 == SkirmishVO.TypeStoryOrExpedition then
				if tonumber(var1) then
					var1 = tonumber(var1)

					local var2 = arg0.sceneParent.contextData

					arg0:InvokeParent("emit", LevelMediator2.ON_PERFORM_COMBAT, var1, function()
						var2.preparedTaskList = var2.preparedTaskList or {}

						table.insert(var2.preparedTaskList, var14)
					end)
				else
					pg.NewStoryMgr.GetInstance():Play(var1, function()
						arg0:InvokeParent("emit", LevelMediator2.ON_SUBMIT_TASK, var14)
					end)
				end
			elseif var0 == SkirmishVO.TypeChapter then
				local var3 = tonumber(var1)
				local var4 = getProxy(ChapterProxy):getChapterById(var3)

				arg0:InvokeParent("TrySwitchChapter", var4)
			end
		end)
	end

	if var6 > 0 then
		setActive(var4, not var7)

		local var15 = var2:GetChild(var6 - 1)

		var4.anchoredPosition = var15.anchoredPosition:Add(var6 == 3 and var3 or var2)

		setActive(var4:Find("line1"), var6 ~= 3)
		setActive(var4:Find("line2"), var6 == 3)
		setText(var4:Find("info/position"), string.format("POSITION  %02d", var6))
		setText(var4:Find("info/name"), var5[var6]:getConfig("name"))
		onButton(arg0.sceneParent, var4, function()
			triggerButton(var15)
		end)
	else
		setActive(var4, false)
	end

	local var16 = var1:Find("cloud")

	var16.anchoredPosition = var4

	LeanTween.value(go(var16), var4, var5, 30):setOnUpdateVector2(function(arg0)
		var16.anchoredPosition = arg0
	end)

	arg0.sceneParent.skirmishBar:Find("text"):GetComponent(typeof(Text)).text = var8 - var9
end

function var1.OnShow(arg0)
	setActive(arg0.sceneParent.topChapter:Find("type_skirmish"), true)
	setActive(arg0.sceneParent.skirmishBar, true)
	setActive(arg0.sceneParent.leftChapter:Find("buttons"), false)
	setActive(arg0.sceneParent.eventContainer, false)
	setActive(arg0.sceneParent.rightChapter, false)
end

function var1.OnHide(arg0)
	setActive(arg0.sceneParent.topChapter:Find("type_skirmish"), false)
	setActive(arg0.sceneParent.skirmishBar, false)
	setActive(arg0.sceneParent.leftChapter:Find("buttons"), true)
	setActive(arg0.sceneParent.eventContainer, true)
	setActive(arg0.sceneParent.rightChapter, true)

	local var0 = arg0._tf:Find("skirmish_items")

	for iter0 = 1, var0.childCount do
		local var1 = var0:GetChild(iter0 - 1)

		LeanTween.cancel(go(var1))
	end

	local var2 = arg0._tf:Find("cloud")

	LeanTween.cancel(go(var2))
end

return var1
