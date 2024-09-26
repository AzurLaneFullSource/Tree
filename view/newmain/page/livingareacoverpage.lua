local var0_0 = class("LivingAreaCoverPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LivingAreaCoverUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.tpl = arg0_2:findTF("bg/tpl")

	setActive(arg0_2.tpl, false)

	arg0_2.frameTF = arg0_2:findTF("bg/frame")
	arg0_2.contentTF = arg0_2:findTF("view/content", arg0_2.frameTF)
	arg0_2.unlockTF = arg0_2:findTF("unlock", arg0_2.contentTF)

	setText(arg0_2:findTF("title/Text", arg0_2.unlockTF), i18n("word_unlock"))

	arg0_2.unlockUIList = UIItemList.New(arg0_2:findTF("list", arg0_2.unlockTF), arg0_2.tpl)
	arg0_2.lockTF = arg0_2:findTF("lock", arg0_2.contentTF)

	setText(arg0_2:findTF("title/Text", arg0_2.lockTF), i18n("word_lock"))

	arg0_2.lockUIList = UIItemList.New(arg0_2:findTF("list", arg0_2.lockTF), arg0_2.tpl)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:CheckSet()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("close", arg0_3.frameTF), function()
		arg0_3:CheckSet()
	end, SFX_PANEL)
	arg0_3.unlockUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_3:updateItem(arg1_6, arg2_6, "unlock")
		end
	end)
	arg0_3.lockUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_3:updateItem(arg1_7, arg2_7, "lock")
		end
	end)
end

function var0_0.updateItem(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg1_8 + 1
	local var1_8 = arg3_8 == "unlock"
	local var2_8 = var1_8 and arg0_8.unlockList[var0_8] or arg0_8.lockList[var0_8]

	LoadImageSpriteAsync(var2_8:GetIcon(), arg0_8:findTF("icon", arg2_8), true)
	setText(arg0_8:findTF("lock/Image/Text", arg2_8), var2_8:GetUnlockText())
	setActive(arg0_8:findTF("lock", arg2_8), not var1_8)
	setActive(arg0_8:findTF("selected", arg2_8), var1_8)
	onButton(arg0_8, arg2_8, function()
		if not var1_8 then
			return
		end

		if arg0_8.selectedIdx ~= var0_8 then
			if var2_8:IsNew() then
				var2_8:ClearNew()
				getProxy(LivingAreaCoverProxy):UpdateCover(var2_8)
			end

			arg0_8.selectedIdx = var0_8

			arg0_8.unlockUIList:align(#arg0_8.unlockList)

			if arg0_8.contextData and arg0_8.contextData.onSelected then
				arg0_8.contextData.onSelected(var2_8)
			end
		end
	end, SFX_CONFIRM)
	setActive(arg0_8:findTF("new", arg2_8), var2_8:IsNew())
	setActive(arg0_8:findTF("selected", arg2_8), var1_8 and arg0_8.selectedIdx == var0_8)
end

function var0_0.Show(arg0_10)
	var0_0.super.Show(arg0_10)

	local var0_10 = getProxy(LivingAreaCoverProxy)

	arg0_10.coverId = var0_10:GetCoverId()
	arg0_10.unlockList = var0_10:GetUnlockList()
	arg0_10.lockList = var0_10:GetLockList()

	arg0_10:Sort()

	arg0_10.selectedIdx = 1

	arg0_10.unlockUIList:align(#arg0_10.unlockList)
	arg0_10.lockUIList:align(#arg0_10.lockList)
	quickPlayAnimation(arg0_10._tf, "anim_dorm3d_areacover_in")
end

function var0_0.Sort(arg0_11)
	table.sort(arg0_11.unlockList, CompareFuncs({
		function(arg0_12)
			return arg0_12.id == arg0_11.coverId and 0 or 1
		end,
		function(arg0_13)
			return arg0_13.id
		end
	}))
	table.sort(arg0_11.lockList, CompareFuncs({
		function(arg0_14)
			return arg0_14.id
		end
	}))
end

function var0_0.CheckSet(arg0_15)
	local var0_15 = arg0_15.unlockList[arg0_15.selectedIdx].id

	if var0_15 ~= arg0_15.coverId then
		pg.m02:sendNotification(GAME.CHANGE_LIVINGAREA_COVER, {
			coverId = var0_15,
			callback = function()
				arg0_15:Hide()
			end
		})
	else
		arg0_15:Hide()
	end
end

function var0_0.Hide(arg0_17)
	if arg0_17:isShowing() and not arg0_17.inExitAnim then
		arg0_17.inExitAnim = nil

		quickPlayAnimation(arg0_17._tf, "anim_dorm3d_areacover_out")
		onDelayTick(function()
			arg0_17.inExitAnim = nil

			if arg0_17.contextData and arg0_17.contextData.onHide then
				arg0_17.contextData.onHide()
			end

			var0_0.super.Hide(arg0_17)
		end, 0.2)
	end
end

function var0_0.OnDestroy(arg0_19)
	arg0_19:Hide()
end

return var0_0
