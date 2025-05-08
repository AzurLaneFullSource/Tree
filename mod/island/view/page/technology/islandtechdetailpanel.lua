local var0_0 = class("IslandTechDetailPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandTechDetailPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.selectedTF = arg0_2._tf:Find("selected")
	arg0_2.panel = arg0_2._tf:Find("panel")
	arg0_2.iconTF = arg0_2.panel:Find("icon")
	arg0_2.nameTF = arg0_2.panel:Find("title/Text")
	arg0_2.descTF = arg0_2.panel:Find("desc")
	arg0_2.unlockTF = arg0_2.panel:Find("unlock")
	arg0_2.unlockTextTF = arg0_2.unlockTF:Find("title")
	arg0_2.unlockUIList = UIItemList.New(arg0_2.unlockTF:Find("cost"), arg0_2.unlockTF:Find("cost/tpl"))
	arg0_2.timeTF = arg0_2.panel:Find("time")
	arg0_2.timeTextTF = arg0_2.timeTF:Find("content/Text")

	local var0_2 = arg0_2.panel:Find("status")

	arg0_2.statusTFs = {
		[IslandTechnology.STATUS.LOCK] = var0_2:Find("lock"),
		[IslandTechnology.STATUS.UNLOCK] = var0_2:Find("unlock"),
		[IslandTechnology.STATUS.NORMAL] = var0_2:Find("normal"),
		[IslandTechnology.STATUS.STUDYING] = var0_2:Find("studying"),
		[IslandTechnology.STATUS.RECEIVE] = var0_2:Find("receive"),
		[IslandTechnology.STATUS.FINISHED] = var0_2:Find("finished")
	}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("close"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3.unlockUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg0_3.unlockItemList[arg1_5 + 1]

			updateDrop(arg2_5, var0_5)
		end
	end)

	arg0_3.placeId = IslandTechnologyAgency.PLACE_ID
end

function var0_0.Flush(arg0_6, arg1_6)
	arg0_6:StopTimer()

	local var0_6 = getProxy(IslandProxy):GetIsland()

	arg0_6.buildingAgency = var0_6:GetBuildingAgency()
	arg0_6.techAgency = var0_6:GetTechnologyAgency()
	arg0_6.showTechVO = arg0_6.techAgency:GetTechnology(arg0_6.configId)

	LoadImageSpriteAsync("IslandTechnology/" .. arg0_6.showTechVO:getConfig("tech_icon"), arg0_6.iconTF, true)
	setText(arg0_6.nameTF, string.format("%s(%d)", arg0_6.showTechVO:getConfig("tech_name"), arg0_6.showTechVO:GetFinishedCnt()))
	setText(arg0_6.descTF, arg0_6.showTechVO:getConfig("tech_desc"))
	setText(arg0_6.unlockTextTF, arg0_6.showTechVO:getConfig("tech_unlock_desc"))

	arg0_6.unlockItemList = arg0_6.showTechVO:GetRecycleItemInfos()

	arg0_6.unlockUIList:align(#arg0_6.unlockItemList)

	local var1_6 = arg0_6.showTechVO:GetStatus()

	for iter0_6, iter1_6 in pairs(arg0_6.statusTFs) do
		setActive(iter1_6, iter0_6 == var1_6)
	end

	local var2_6 = var1_6 == IslandTechnology.STATUS.LOCK or var1_6 == IslandTechnology.STATUS.UNLOCK

	setActive(arg0_6.unlockTF, var2_6)
	setActive(arg0_6.timeTF, var1_6 ~= IslandTechnology.STATUS.FINISHED)
	setLocalPosition(arg0_6.timeTF, {
		x = 655,
		y = var2_6 and -120 or -75
	})
	switch(var1_6, {
		[IslandTechnology.STATUS.LOCK] = function()
			onButton(arg0_6, arg0_6.statusTFs[var1_6], function()
				pg.TipsMgr.GetInstance():ShowTips("不满足解锁条件")
			end, SFX_PANEL)
		end,
		[IslandTechnology.STATUS.UNLOCK] = function()
			onButton(arg0_6, arg0_6.statusTFs[var1_6], function()
				arg0_6:emit(IslandMediator.ON_UNLOCK_TECH, arg0_6.showTechVO.id)
			end, SFX_PANEL)
		end,
		[IslandTechnology.STATUS.NORMAL] = function()
			onButton(arg0_6, arg0_6.statusTFs[var1_6], function()
				if not arg0_6.techAgency:GetEmptySlotId() then
					pg.TipsMgr.GetInstance():ShowTips("没有空闲的岗位！")
				end

				existCall(arg0_6.contextData.onSelecteShip)
			end, SFX_PANEL)
		end,
		[IslandTechnology.STATUS.RECEIVE] = function()
			onButton(arg0_6, arg0_6.statusTFs[var1_6], function()
				arg0_6:emit(IslandMediator.GET_DELEGATION_AWARD, arg0_6.placeId, arg0_6.showTechVO:GetSlotId(), 2)
			end, SFX_PANEL)
		end
	}, function()
		return
	end)
	arg0_6:StartTimer()
	arg0_6:UpdateTime()

	arg0_6.selectedItemPos = arg1_6 or arg0_6.selectedItemPos

	setActive(arg0_6.selectedTF, arg0_6.selectedItemPos)

	if arg0_6.selectedItemPos then
		arg0_6:FlushSelectedItem(arg0_6.selectedItemPos)
	end
end

function var0_0.FlushSelectedItem(arg0_16, arg1_16)
	setAnchoredPosition(arg0_16.selectedTF, arg1_16)

	arg0_16.selectedTF.name = arg0_16.configId

	local var0_16 = arg0_16.techAgency:GetTechnology(arg0_16.configId)

	setText(arg0_16.selectedTF:Find("name"), var0_16:getConfig("tech_name"))

	local var1_16 = var0_16:GetStatus()
	local var2_16 = var1_16 == IslandTechnology.STATUS.FINISHED

	setTextColor(arg0_16.selectedTF:Find("name"), Color.NewHex(var2_16 and "1b3650" or "ffffff"))
	LoadImageSpriteAsync("IslandTechnology/" .. var0_16:getConfig("tech_icon"), arg0_16.selectedTF:Find("icon"), true)
	setImageColor(arg0_16.selectedTF:Find("icon"), Color.NewHex(var2_16 and "455a81" or "ffffff"))
	eachChild(arg0_16.selectedTF:Find("back"), function(arg0_17)
		setActive(arg0_17, arg0_17.name == var1_16)
	end)
	setActive(arg0_16.selectedTF:Find("back/normal"), not var2_16 and var1_16 ~= IslandTechnology.STATUS.STUDYING)
	eachChild(arg0_16.selectedTF:Find("front"), function(arg0_18)
		setActive(arg0_18, arg0_18.name == var1_16)
	end)
end

function var0_0.Show(arg0_19, arg1_19, arg2_19)
	var0_0.super.Show(arg0_19)

	arg0_19.configId = arg1_19
	arg0_19.timeMgr = pg.TimeMgr.GetInstance()

	arg0_19:Flush(arg2_19)
end

function var0_0.OnShipSelected(arg0_20, arg1_20)
	local var0_20 = arg0_20.techAgency:GetEmptySlotId()
	local var1_20 = arg0_20.showTechVO:GetFormulaId()

	arg0_20:emit(IslandMediator.START_DELEGATION, arg0_20.placeId, var0_20, arg1_20, var1_20, 1)
end

function var0_0.UpdateTime(arg0_21)
	local var0_21 = arg0_21.showTechVO:GetStatus()
	local var1_21 = arg0_21.buildingAgency:GetDelegationSlotDataByTechId(arg0_21.showTechVO.id)

	if var1_21 then
		if var1_21:GetSlotRewardData() then
			setText(arg0_21.timeTextTF, "00:00:00")
		else
			local var2_21 = var1_21:GetSlotRoleData():GetFinishTime() - arg0_21.timeMgr:GetServerTime()

			setText(arg0_21.timeTextTF, arg0_21.timeMgr:DescCDTime(var2_21))
		end
	else
		setText(arg0_21.timeTextTF, "??:??:??")
	end
end

function var0_0.StartTimer(arg0_22)
	arg0_22.timer = Timer.New(function()
		arg0_22:UpdateTime()
	end, 1, -1)

	arg0_22.timer:Start()
end

function var0_0.StopTimer(arg0_24)
	if arg0_24.timer ~= nil then
		arg0_24.timer:Stop()

		arg0_24.timer = nil
	end
end

function var0_0.OnHide(arg0_25)
	arg0_25:StopTimer()
end

function var0_0.OnDestroy(arg0_26)
	arg0_26:StopTimer()
end

return var0_0
