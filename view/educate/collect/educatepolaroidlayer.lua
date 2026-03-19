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
	arg0_4.endings = getProxy(EducateProxy):GetAllEndings()

	underscore.each(arg0_4.endings, function(arg0_5)
		local var0_5 = pg.child_ending[arg0_5].polaroid_condition

		if var0_5 ~= 0 and not table.contains(arg0_4.unlockAttrs, var0_5) then
			table.insert(arg0_4.unlockAttrs, var0_5)
		end
	end)
end

function var0_0.didEnter(arg0_6)
	arg0_6:initGroups()
	arg0_6:initShowList()
	onButton(arg0_6, arg0_6.performTF, function()
		setActive(arg0_6.performTF, false)
	end, SFX_PANEL)

	arg0_6.pages = math.ceil(#arg0_6.groupIds / arg0_6.onePageCnt)

	EducateTipHelper.ClearNewTip(EducateTipHelper.NEW_POLAROID)

	local var0_6 = arg0_6.performTF:Find("bg/lock/unlock_btn/Text")

	var0_6:GetComponent("RichText"):AddSprite("gold", arg0_6._tf:Find("res/gold"):GetComponent(typeof(Image)).sprite)
	setText(var0_6, i18n("child_could_buy"))
	setText(arg0_6.windowTF:Find("tip"), i18n("child_buy_polaroid_tip"))

	arg0_6.basePrice = pg.gameset.child_polaroid_basic_price.key_value
	arg0_6.addPrice = pg.gameset.child_polaroid_add_price.key_value
	arg0_6.maxPrice = pg.gameset.child_polaroid_max_price.key_value

	arg0_6:Flush()
end

function var0_0.initShowList(arg0_8)
	arg0_8.showIds = {}
	arg0_8.selectedIndex = 1
	arg0_8.groupsTF = arg0_8.performTF:Find("bg/groups")
	arg0_8.showList = UIItemList.New(arg0_8.groupsTF, arg0_8.groupsTF:Find("tpl"))

	arg0_8.showList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg0_8.showIds[arg1_9 + 1]
			local var1_9 = arg0_8:IsUnlock(var0_9)

			setText(arg2_9:Find("unlock/unselected/Text"), var0_9)
			setText(arg2_9:Find("unlock/selected/Text"), var0_9)
			setActive(arg2_9:Find("lock"), not var1_9)
			setActive(arg2_9:Find("unlock"), var1_9)
			setActive(arg2_9:Find("unlock/selected"), arg0_8.selectedIndex == arg1_9 + 1)
			setActive(arg2_9:Find("unlock/unselected"), arg0_8.selectedIndex ~= arg1_9 + 1)
			onButton(arg0_8, arg2_9, function(arg0_10)
				arg0_8.selectedIndex = arg1_9 + 1

				arg0_8:updatePerform(var0_9, var1_9)
				arg0_8.showList:align(#arg0_8.showIds)

				if not var1_9 then
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

function var0_0.SetData(arg0_12)
	local var0_12 = getProxy(EducateProxy)

	arg0_12.polaroidData = var0_12:GetPolaroidData()
	arg0_12.gameCnt = var0_12:GetGameCnt()
	arg0_12.bugCnt = var0_12:GetPolaroidBuyCnt()

	arg0_12:initUnlockAttr()
end

function var0_0.Flush(arg0_13)
	arg0_13:SetData()

	local var0_13, var1_13 = getProxy(EducateProxy):GetPolaroidGroupCnt()

	setText(arg0_13.curCntTF, var0_13)
	setText(arg0_13.allCntTF, "/" .. var1_13)
	arg0_13:updatePage()

	if isActive(arg0_13.performTF) then
		local var2_13 = arg0_13.showIds[arg0_13.selectedIndex]
		local var3_13 = arg0_13:IsUnlock(var2_13)

		arg0_13:updatePerform(var2_13, var3_13)
		arg0_13.showList:align(#arg0_13.showIds)
	end
end

function var0_0.updatePage(arg0_14)
	setActive(arg0_14.nextBtn, arg0_14.pages ~= 1 and arg0_14.curPageIndex < arg0_14.pages)
	setActive(arg0_14.lastBtn, arg0_14.pages ~= 1 and arg0_14.curPageIndex > 1)
	setText(arg0_14.paginationTF, arg0_14.curPageIndex .. "/" .. arg0_14.pages)

	local var0_14 = (arg0_14.curPageIndex - 1) * arg0_14.onePageCnt

	for iter0_14 = 1, arg0_14.onePageCnt do
		local var1_14 = arg0_14.pageTF:Find("frame_" .. iter0_14)
		local var2_14 = arg0_14.groupIds[var0_14 + iter0_14]

		if var2_14 then
			setActive(var1_14, true)
			arg0_14:updateItem(var2_14, var1_14)
		else
			setActive(var1_14, false)
		end
	end
end

function var0_0.updateItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.group2polaroidIds[arg1_15]

	table.sort(var0_15, CompareFuncs({
		function(arg0_16)
			return arg0_15.polaroidData[arg0_16] and 0 or 1
		end,
		function(arg0_17)
			return arg0_15.polaroidData[arg0_17] and arg0_15.polaroidData[arg0_17]:GetTimeWeight() or 1
		end,
		function(arg0_18)
			return arg0_18
		end
	}))

	local var1_15 = arg0_15.config[var0_15[1]]
	local var2_15 = arg0_15.polaroidData[var0_15[1]]

	setActive(arg2_15:Find("lock"), not var2_15)
	setActive(arg2_15:Find("unlock"), var2_15)

	if var2_15 then
		local var3_15 = arg0_15.polaroidData[var0_15[1]]

		LoadImageSpriteAsync("educatepolaroid/" .. var1_15.pic, arg2_15:Find("unlock/mask/Image"))
		setText(arg2_15:Find("unlock/name"), var1_15.title)
		onButton(arg0_15, arg2_15, function()
			arg0_15:showPerformWindow(var0_15)
		end, SFX_PANEL)
	else
		removeOnButton(arg2_15)
		setText(arg2_15:Find("lock/desc/Text"), var1_15.condition)

		local var4_15 = arg2_15:Find("lock/unlock_btn")

		setActive(var4_15, arg0_15.gameCnt > 1)
		onButton(arg0_15, var4_15, function()
			arg0_15:OnClickBuyBtn(var1_15)
		end, SFX_PANEL)
	end
end

function var0_0.showPerformWindow(arg0_21, arg1_21, arg2_21)
	arg0_21.showIds = arg1_21

	arg0_21.showList:align(#arg0_21.showIds)
	triggerButton(arg0_21.groupsTF:GetChild(0))
	setActive(arg0_21.performTF, true)
end

function var0_0.updatePerform(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.config[arg1_22]

	LoadImageSpriteAsync("educatepolaroid/" .. var0_22.pic, arg0_22.performTF:Find("bg/icon/Image"))
	setActive(arg0_22.performTF:Find("bg/icon/lock"), not arg2_22)
	setText(arg0_22.performTF:Find("bg/Text"), arg2_22 and var0_22.title or "")
	setActive(arg0_22.performTF:Find("bg/lock"), not arg2_22)

	if not arg2_22 then
		setText(arg0_22.performTF:Find("bg/lock/desc/Text"), var0_22.condition)

		local var1_22 = arg0_22.performTF:Find("bg/lock/unlock_btn")

		setActive(var1_22, arg0_22.gameCnt > 1)
		onButton(arg0_22, var1_22, function()
			arg0_22:OnClickBuyBtn(var0_22)
		end, SFX_PANEL)
	end
end

function var0_0.OnClickBuyBtn(arg0_24, arg1_24)
	local var0_24 = arg1_24.title
	local var1_24 = math.min(arg0_24.maxPrice, arg0_24.basePrice + arg0_24.bugCnt * arg0_24.addPrice)

	arg0_24:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
		content = i18n("child_polaroid_buy", var1_24, var0_24),
		onYes = function()
			arg0_24:emit(EducateCollectMediatorTemplate.UNLOCK, {
				type = EducateBuyCollectCommand.TYPE.POLAROID,
				id = arg1_24.id,
				cost = var1_24
			})
		end
	})
end

function var0_0.playAnimChange(arg0_26)
	arg0_26.anim:Stop()
	arg0_26.anim:Play("anim_educate_Polaroid_change")
end

function var0_0.playAnimClose(arg0_27)
	arg0_27.anim:Play("anim_educate_Polaroid_out")
end

return var0_0
