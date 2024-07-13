local var0_0 = class("EducatePolaroidLayer", import(".EducateCollectLayerTemplate"))

function var0_0.getUIName(arg0_1)
	return "EducatePolaroidUI"
end

function var0_0.initConfig(arg0_2)
	arg0_2.config = pg.child_polaroid
end

function var0_0.initGroups(arg0_3)
	arg0_3.groupIds = {}
	arg0_3.group2polaroidIds = {}

	for iter0_3, iter1_3 in pairs(pg.child_polaroid.get_id_list_by_group) do
		table.insert(arg0_3.groupIds, iter0_3)

		arg0_3.group2polaroidIds[iter0_3] = iter1_3
	end

	table.sort(arg0_3.groupIds)
end

function var0_0.initUnlockAttr(arg0_4)
	arg0_4.unlockAttrs = {}
	arg0_4.endings = getProxy(EducateProxy):GetFinishEndings()

	underscore.each(arg0_4.endings, function(arg0_5)
		local var0_5 = pg.child_ending[arg0_5].polaroid_condition

		if var0_5 ~= 0 and not table.contains(arg0_4.unlockAttrs, var0_5) then
			table.insert(arg0_4.unlockAttrs, var0_5)
		end
	end)
end

function var0_0.didEnter(arg0_6)
	arg0_6:initUnlockAttr()
	arg0_6:initGroups()

	arg0_6.polaroidData = getProxy(EducateProxy):GetPolaroidData()

	local var0_6, var1_6 = getProxy(EducateProxy):GetPolaroidGroupCnt()

	setText(arg0_6.curCntTF, var0_6)
	setText(arg0_6.allCntTF, "/" .. var1_6)
	onButton(arg0_6, arg0_6.performTF, function()
		setActive(arg0_6.performTF, false)
	end, SFX_PANEL)
	arg0_6:initShowList()

	arg0_6.pages = math.ceil(#arg0_6.groupIds / arg0_6.onePageCnt)

	arg0_6:updatePage()
	EducateTipHelper.ClearNewTip(EducateTipHelper.NEW_POLAROID)
end

function var0_0.initShowList(arg0_8)
	arg0_8.showIds = {}
	arg0_8.selectedIndex = 1
	arg0_8.groupsTF = arg0_8:findTF("bg/groups", arg0_8.performTF)
	arg0_8.showList = UIItemList.New(arg0_8.groupsTF, arg0_8:findTF("tpl", arg0_8.groupsTF))

	arg0_8.showList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg0_8.showIds[arg1_9 + 1]
			local var1_9 = arg0_8:IsUnlock(var0_9)

			setText(arg0_8:findTF("unlock/unselected/Text", arg2_9), var0_9)
			setText(arg0_8:findTF("unlock/selected/Text", arg2_9), var0_9)
			setActive(arg0_8:findTF("lock", arg2_9), not var1_9)
			setActive(arg0_8:findTF("unlock", arg2_9), var1_9)
			setActive(arg0_8:findTF("unlock/selected", arg2_9), arg0_8.selectedIndex == arg1_9 + 1)
			setActive(arg0_8:findTF("unlock/unselected", arg2_9), arg0_8.selectedIndex ~= arg1_9 + 1)
			onButton(arg0_8, arg2_9, function(arg0_10)
				if var1_9 then
					arg0_8.selectedIndex = arg1_9 + 1

					arg0_8:updatePerform(var0_9)
					arg0_8.showList:align(#arg0_8.showIds)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("child_polaroid_lock_tip"))
				end
			end)
		end
	end)
end

function var0_0.IsUnlock(arg0_11, arg1_11)
	if arg0_11.polaroidData[arg1_11] then
		return true
	end

	if #arg0_11.endings > 0 then
		local var0_11 = arg0_11.config[arg1_11].stage

		if var0_11[1] == 2 or var0_11[1] == 3 then
			return true
		elseif var0_11[1] == 4 then
			local var1_11 = arg0_11.config[arg1_11].xingge[1]

			return table.contains(arg0_11.unlockAttrs, var1_11)
		end
	end

	return false
end

function var0_0.updatePage(arg0_12)
	setActive(arg0_12.nextBtn, arg0_12.pages ~= 1 and arg0_12.curPageIndex < arg0_12.pages)
	setActive(arg0_12.lastBtn, arg0_12.pages ~= 1 and arg0_12.curPageIndex > 1)
	setText(arg0_12.paginationTF, arg0_12.curPageIndex .. "/" .. arg0_12.pages)

	local var0_12 = (arg0_12.curPageIndex - 1) * arg0_12.onePageCnt

	for iter0_12 = 1, arg0_12.onePageCnt do
		local var1_12 = arg0_12:findTF("frame_" .. iter0_12, arg0_12.pageTF)
		local var2_12 = arg0_12.groupIds[var0_12 + iter0_12]

		if var2_12 then
			setActive(var1_12, true)
			arg0_12:updateItem(var2_12, var1_12)
		else
			setActive(var1_12, false)
		end
	end
end

function var0_0.updateItem(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.group2polaroidIds[arg1_13]

	table.sort(var0_13, CompareFuncs({
		function(arg0_14)
			return arg0_13.polaroidData[arg0_14] and 0 or 1
		end,
		function(arg0_15)
			return arg0_13.polaroidData[arg0_15] and arg0_13.polaroidData[arg0_15]:GetTimeWeight() or 1
		end,
		function(arg0_16)
			return arg0_16
		end
	}))

	local var1_13 = arg0_13.config[var0_13[1]]
	local var2_13 = arg0_13.polaroidData[var0_13[1]]

	setActive(arg0_13:findTF("lock", arg2_13), not var2_13)
	setActive(arg0_13:findTF("unlock", arg2_13), var2_13)

	if var2_13 then
		local var3_13 = arg0_13.polaroidData[var0_13[1]]

		LoadImageSpriteAsync("educatepolaroid/" .. var1_13.pic, arg0_13:findTF("unlock/mask/Image", arg2_13))
		setText(arg0_13:findTF("unlock/name", arg2_13), var1_13.title)
		onButton(arg0_13, arg2_13, function()
			arg0_13:showPerformWindow(var0_13)
		end, SFX_PANEL)
	else
		removeOnButton(arg2_13)
		setText(arg0_13:findTF("lock/Text", arg2_13), var1_13.condition)
	end
end

function var0_0.showPerformWindow(arg0_18, arg1_18, arg2_18)
	arg0_18.showIds = arg1_18

	arg0_18.showList:align(#arg0_18.showIds)
	triggerButton(arg0_18.groupsTF:GetChild(0))
	setActive(arg0_18.performTF, true)
end

function var0_0.updatePerform(arg0_19, arg1_19)
	local var0_19 = arg0_19.config[arg1_19]

	LoadImageSpriteAsync("educatepolaroid/" .. var0_19.pic, arg0_19:findTF("bg/mask/Image", arg0_19.performTF))
	setText(arg0_19:findTF("bg/Text", arg0_19.performTF), var0_19.title)
end

function var0_0.playAnimChange(arg0_20)
	arg0_20.anim:Stop()
	arg0_20.anim:Play("anim_educate_Polaroid_change")
end

function var0_0.playAnimClose(arg0_21)
	arg0_21.anim:Play("anim_educate_Polaroid_out")
end

return var0_0
