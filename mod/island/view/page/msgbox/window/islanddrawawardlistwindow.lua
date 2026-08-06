local var0_0 = class("IslandDrawAwardListWindow", import("Mod.Island.View.page.msgbox.window.IslandBaseMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandDrawAwardListMsgBox"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	setText(arg0_3.rtTitle, i18n("island_draw_S_order_title"))
	onButton(arg0_3, arg0_3.btnClose, function()
		arg0_3:Hide()
	end, SFX_CANCEL)

	arg0_3.toggleList = UIItemList.New(arg0_3.rtToggles, arg0_3.rtToggleTpl)

	arg0_3.toggleList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventUpdate then
			local var0_5, var1_5 = unpack(arg0_3.countAwardList[arg1_5])

			arg2_5.name = var0_5

			local var2_5 = pg.island_draw_reward[var0_5]
			local var3_5 = Drop.New({
				type = var2_5.drop_type,
				id = var2_5.drop_id
			})

			IslandShopDrawAwardPage.ShowDropInfo(var3_5, arg2_5:Find("mask/Image"))
			setScrollText(arg2_5:Find("name/Text"), var3_5:getName())
			setText(arg2_5:Find("got/got/Text"), i18n("island_draw_get"))
			setActive(arg2_5:Find("got"), not var1_5)
			arg0_3:detachOnCardButton(arg2_5)

			if var1_5 then
				arg0_3:attachOnCardButton(arg2_5)
			end
		end
	end)

	arg0_3.marksList = UIItemList.New(arg0_3.rtMarks, arg0_3.rtMakrsTpl)

	arg0_3.marksList:make(function(arg0_6, arg1_6, arg2_6)
		arg1_6 = arg1_6 + 1

		if arg0_6 == UIItemList.EventUpdate then
			local var0_6, var1_6 = unpack(arg0_3.countAwardList[arg1_6])

			setActive(arg2_6:Find("mark"), var1_6)
			setText(arg2_6:Find("mark/Text"), arg1_6)
		end
	end)
	setText(arg0_3.btnConfirm:Find("Text"), i18n("word_ok"))
	onButton(arg0_3, arg0_3.btnConfirm, function()
		arg0_3:emit(IslandMediator.DRAW_AWARD_OPERATION, {
			op = "set_list",
			activity_id = arg0_3.activity.id,
			list = underscore(arg0_3.countAwardList):chain():filter(function(arg0_8)
				return arg0_8[2]
			end):map(function(arg0_9)
				return arg0_9[1]
			end):value()
		})
		arg0_3:Hide()
	end, SFX_CONFIRM)
end

function var0_0.detachOnCardButton(arg0_10, arg1_10)
	local var0_10 = GetOrAddComponent(arg1_10, "EventTriggerListener")

	var0_10:RemovePointClickFunc()
	var0_10:RemoveBeginDragFunc()
	var0_10:RemoveDragFunc()
	var0_10:RemoveDragEndFunc()
end

function var0_0.attachOnCardButton(arg0_11, arg1_11)
	local var0_11 = GetOrAddComponent(arg1_11, "EventTriggerListener")
	local var1_11 = arg1_11.parent
	local var2_11 = {}

	var0_11:AddBeginDragFunc(function()
		if arg0_11.carddrag then
			return
		end

		arg0_11._currentDragDelegate = var0_11
		arg0_11.carddrag = arg1_11

		for iter0_12 = 1, arg0_11.count do
			var2_11[iter0_12] = var1_11:GetChild(iter0_12 - 1).localPosition.x
		end

		arg0_11.before = arg1_11:GetSiblingIndex() + 1
		arg0_11.after = arg0_11.before
		arg0_11.copyCard = cloneTplTo(arg1_11, var1_11, "copy")

		arg0_11.copyCard:SetSiblingIndex(arg0_11.before - 1)

		GetOrAddComponent(arg0_11.copyCard, typeof(CanvasGroup)).alpha = 0
		GetOrAddComponent(arg1_11, typeof(LayoutElement)).ignoreLayout = true

		arg1_11:SetAsLastSibling()
		LeanTween.scale(arg1_11, Vector3(1.1, 1.1, 1), 0.3)
	end)
	var0_11:AddDragFunc(function(arg0_13, arg1_13)
		if arg0_11.carddrag ~= arg1_11 then
			return
		end

		local var0_13 = arg1_11.localPosition

		var0_13.x = math.clamp(arg0_11:change2ScrPos(var1_11, arg1_13.position).x, var2_11[1], var2_11[#var2_11])
		arg1_11.localPosition = var0_13

		local var1_13 = 1

		for iter0_13, iter1_13 in ipairs(var2_11) do
			if not var2_11[iter0_13 + 1] or var0_13.x < (iter1_13 + var2_11[iter0_13 + 1]) / 2 then
				var1_13 = iter0_13

				break
			end
		end

		if var1_13 ~= arg0_11.after then
			arg0_11.after = var1_13

			arg0_11.copyCard:SetSiblingIndex(arg0_11.after - 1)
		end
	end)
	var0_11:AddDragEndFunc(function(arg0_14, arg1_14)
		if arg0_11.carddrag ~= arg1_11 then
			return
		end

		local var0_14 = arg0_11._forceDropCharacter

		arg0_11._forceDropCharacter = nil
		arg0_11._currentDragDelegate = nil
		var0_11.enabled = false

		local var1_14 = {}

		table.insert(var1_14, function(arg0_15)
			if var0_14 then
				arg1_11.localScale = Vector3(1, 1, 1)

				arg0_15()
			else
				parallelAsync({
					function(arg0_16)
						local var0_16 = math.min(math.abs(arg1_11.localPosition.x - var2_11[arg0_11.after]) / 200, 1) * 0.3

						LeanTween.moveLocalX(arg1_11.gameObject, var2_11[arg0_11.after], var0_16):setEase(LeanTweenType.easeOutCubic):setOnComplete(System.Action(arg0_16))
					end,
					function(arg0_17)
						LeanTween.scale(arg1_11, Vector3(1, 1, 1), 0.3):setOnComplete(System.Action(arg0_17))
					end
				}, arg0_15)
			end
		end)
		seriesAsync(var1_14, function()
			Destroy(arg0_11.copyCard)

			arg0_11.copyCard = nil

			arg1_11:SetSiblingIndex(arg0_11.after - 1)

			GetOrAddComponent(arg1_11, typeof(LayoutElement)).ignoreLayout = false

			table.insert(arg0_11.countAwardList, arg0_11.after, table.remove(arg0_11.countAwardList, arg0_11.before))

			arg0_11.before = nil
			arg0_11.after = nil
			var0_11.enabled = true
			arg0_11.carddrag = nil
		end)
	end)
end

function var0_0.ForceDropChar(arg0_19)
	if arg0_19._currentDragDelegate then
		arg0_19._forceDropCharacter = true

		LuaHelper.triggerEndDrag(arg0_19._currentDragDelegate)
	end
end

function var0_0.change2ScrPos(arg0_20, arg1_20, arg2_20)
	local var0_20 = pg.UIMgr.GetInstance().overlayCameraComp

	return (LuaHelper.ScreenToLocal(arg1_20, arg2_20, var0_20))
end

function var0_0.OnShow(arg0_21)
	var0_0.super.OnShow(arg0_21)
	arg0_21:UpdateActivity(arg0_21.settings.activity)
end

function var0_0.UpdateActivity(arg0_22, arg1_22)
	arg0_22.activity = arg1_22
	arg0_22.countAwardList = arg1_22:GetList()

	mergeSort(arg0_22.countAwardList, CompareFuncs({
		function(arg0_23)
			return arg0_23[2] and 0 or 1
		end
	}, true))

	arg0_22.count = #underscore.filter(arg0_22.countAwardList, function(arg0_24)
		return arg0_24[2]
	end)

	arg0_22.toggleList:align(#arg0_22.countAwardList)
	arg0_22.marksList:align(#arg0_22.countAwardList)
	setText(arg0_22.rtCountWord, i18n("island_draw_S_order"))
end

return var0_0
