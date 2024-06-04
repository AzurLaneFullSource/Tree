local var0 = class("EducatePolaroidLayer", import(".EducateCollectLayerTemplate"))

function var0.getUIName(arg0)
	return "EducatePolaroidUI"
end

function var0.initConfig(arg0)
	arg0.config = pg.child_polaroid
end

function var0.initGroups(arg0)
	arg0.groupIds = {}
	arg0.group2polaroidIds = {}

	for iter0, iter1 in pairs(pg.child_polaroid.get_id_list_by_group) do
		table.insert(arg0.groupIds, iter0)

		arg0.group2polaroidIds[iter0] = iter1
	end

	table.sort(arg0.groupIds)
end

function var0.initUnlockAttr(arg0)
	arg0.unlockAttrs = {}
	arg0.endings = getProxy(EducateProxy):GetFinishEndings()

	underscore.each(arg0.endings, function(arg0)
		local var0 = pg.child_ending[arg0].polaroid_condition

		if var0 ~= 0 and not table.contains(arg0.unlockAttrs, var0) then
			table.insert(arg0.unlockAttrs, var0)
		end
	end)
end

function var0.didEnter(arg0)
	arg0:initUnlockAttr()
	arg0:initGroups()

	arg0.polaroidData = getProxy(EducateProxy):GetPolaroidData()

	local var0, var1 = getProxy(EducateProxy):GetPolaroidGroupCnt()

	setText(arg0.curCntTF, var0)
	setText(arg0.allCntTF, "/" .. var1)
	onButton(arg0, arg0.performTF, function()
		setActive(arg0.performTF, false)
	end, SFX_PANEL)
	arg0:initShowList()

	arg0.pages = math.ceil(#arg0.groupIds / arg0.onePageCnt)

	arg0:updatePage()
	EducateTipHelper.ClearNewTip(EducateTipHelper.NEW_POLAROID)
end

function var0.initShowList(arg0)
	arg0.showIds = {}
	arg0.selectedIndex = 1
	arg0.groupsTF = arg0:findTF("bg/groups", arg0.performTF)
	arg0.showList = UIItemList.New(arg0.groupsTF, arg0:findTF("tpl", arg0.groupsTF))

	arg0.showList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.showIds[arg1 + 1]
			local var1 = arg0:IsUnlock(var0)

			setText(arg0:findTF("unlock/unselected/Text", arg2), var0)
			setText(arg0:findTF("unlock/selected/Text", arg2), var0)
			setActive(arg0:findTF("lock", arg2), not var1)
			setActive(arg0:findTF("unlock", arg2), var1)
			setActive(arg0:findTF("unlock/selected", arg2), arg0.selectedIndex == arg1 + 1)
			setActive(arg0:findTF("unlock/unselected", arg2), arg0.selectedIndex ~= arg1 + 1)
			onButton(arg0, arg2, function(arg0)
				if var1 then
					arg0.selectedIndex = arg1 + 1

					arg0:updatePerform(var0)
					arg0.showList:align(#arg0.showIds)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("child_polaroid_lock_tip"))
				end
			end)
		end
	end)
end

function var0.IsUnlock(arg0, arg1)
	if arg0.polaroidData[arg1] then
		return true
	end

	if #arg0.endings > 0 then
		local var0 = arg0.config[arg1].stage

		if var0[1] == 2 or var0[1] == 3 then
			return true
		elseif var0[1] == 4 then
			local var1 = arg0.config[arg1].xingge[1]

			return table.contains(arg0.unlockAttrs, var1)
		end
	end

	return false
end

function var0.updatePage(arg0)
	setActive(arg0.nextBtn, arg0.pages ~= 1 and arg0.curPageIndex < arg0.pages)
	setActive(arg0.lastBtn, arg0.pages ~= 1 and arg0.curPageIndex > 1)
	setText(arg0.paginationTF, arg0.curPageIndex .. "/" .. arg0.pages)

	local var0 = (arg0.curPageIndex - 1) * arg0.onePageCnt

	for iter0 = 1, arg0.onePageCnt do
		local var1 = arg0:findTF("frame_" .. iter0, arg0.pageTF)
		local var2 = arg0.groupIds[var0 + iter0]

		if var2 then
			setActive(var1, true)
			arg0:updateItem(var2, var1)
		else
			setActive(var1, false)
		end
	end
end

function var0.updateItem(arg0, arg1, arg2)
	local var0 = arg0.group2polaroidIds[arg1]

	table.sort(var0, CompareFuncs({
		function(arg0)
			return arg0.polaroidData[arg0] and 0 or 1
		end,
		function(arg0)
			return arg0.polaroidData[arg0] and arg0.polaroidData[arg0]:GetTimeWeight() or 1
		end,
		function(arg0)
			return arg0
		end
	}))

	local var1 = arg0.config[var0[1]]
	local var2 = arg0.polaroidData[var0[1]]

	setActive(arg0:findTF("lock", arg2), not var2)
	setActive(arg0:findTF("unlock", arg2), var2)

	if var2 then
		local var3 = arg0.polaroidData[var0[1]]

		LoadImageSpriteAsync("educatepolaroid/" .. var1.pic, arg0:findTF("unlock/mask/Image", arg2))
		setText(arg0:findTF("unlock/name", arg2), var1.title)
		onButton(arg0, arg2, function()
			arg0:showPerformWindow(var0)
		end, SFX_PANEL)
	else
		removeOnButton(arg2)
		setText(arg0:findTF("lock/Text", arg2), var1.condition)
	end
end

function var0.showPerformWindow(arg0, arg1, arg2)
	arg0.showIds = arg1

	arg0.showList:align(#arg0.showIds)
	triggerButton(arg0.groupsTF:GetChild(0))
	setActive(arg0.performTF, true)
end

function var0.updatePerform(arg0, arg1)
	local var0 = arg0.config[arg1]

	LoadImageSpriteAsync("educatepolaroid/" .. var0.pic, arg0:findTF("bg/mask/Image", arg0.performTF))
	setText(arg0:findTF("bg/Text", arg0.performTF), var0.title)
end

function var0.playAnimChange(arg0)
	arg0.anim:Stop()
	arg0.anim:Play("anim_educate_Polaroid_change")
end

function var0.playAnimClose(arg0)
	arg0.anim:Play("anim_educate_Polaroid_out")
end

return var0
