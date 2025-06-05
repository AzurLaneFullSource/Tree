local var0_0 = class("BossSingleBattleFleetSelectSubPanelLite", import("view.base.BaseSubPanel"))

function var0_0.getUIName(arg0_1)
	return "BossSingleFleetSelectView"
end

function var0_0.OnInit(arg0_2)
	arg0_2.tfShipTpl = arg0_2:findTF("panel/shiptpl")
	arg0_2.tfEmptyTpl = arg0_2:findTF("panel/emptytpl")
	arg0_2.tfFleets = {
		[FleetType.Normal] = {
			arg0_2:findTF("panel/fleet/1"),
			arg0_2:findTF("panel/fleet/2")
		},
		[FleetType.Submarine] = {
			arg0_2:findTF("panel/sub/1")
		}
	}
	arg0_2.limitList = arg0_2:findTF("panel/limit_list")
	arg0_2.btnBack = arg0_2:findTF("panel/btnBack")
	arg0_2.btnGo = arg0_2:findTF("panel/start_button")
	arg0_2.btnTry = arg0_2:findTF("panel/try_button")
	arg0_2.btnASHelp = arg0_2:findTF("panel/title/ASvalue")
	arg0_2.commanderToggle = arg0_2:findTF("panel/commander_btn")
	arg0_2.formationToggle = arg0_2:findTF("panel/formation_btn")
	arg0_2.toggleMask = arg0_2:findTF("mask")
	arg0_2.toggleList = arg0_2:findTF("mask/list")
	arg0_2.toggles = {}

	for iter0_2 = 0, arg0_2.toggleList.childCount - 1 do
		table.insert(arg0_2.toggles, arg0_2.toggleList:Find("item" .. iter0_2 + 1))
	end

	arg0_2.btnSp = arg0_2:findTF("panel/sp")
	arg0_2.spMask = arg0_2:findTF("mask_sp")

	setActive(arg0_2.tfShipTpl, false)
	setActive(arg0_2.tfEmptyTpl, false)
	setActive(arg0_2.toggleMask, false)
	setActive(arg0_2.btnSp, false)
	setActive(arg0_2.spMask, false)
	setActive(arg0_2.btnASHelp, false)
	setActive(arg0_2.commanderToggle, false)
	setActive(arg0_2.btnTry, false)
	setActive(arg0_2.limitList, false)
	setText(arg0_2:findTF("panel/formation_btn/text"), i18n("autofight_formation"))
	setText(arg0_2:findTF("panel/commander_btn/text"), i18n("autofight_cat"))
	setText(arg0_2._tf:Find("panel/title/Image/text"), i18n("fleet_select_title"))
	arg0_2:InitInteractable()
end

function var0_0.InitInteractable(arg0_3)
	onButton(arg0_3, arg0_3.btnGo, function()
		arg0_3:OnCombat()
		arg0_3:OnHide()
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_3, arg0_3.btnBack, function()
		arg0_3:OnHide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:OnHide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.toggleMask, function()
		arg0_3:hideToggleMask()
	end, SFX_CANCEL)
end

function var0_0.SetFleets(arg0_8, arg1_8)
	arg0_8.selectIds = {
		[FleetType.Normal] = {
			1
		},
		[FleetType.Submarine] = {}
	}
	arg0_8.fleets = _(_.values(arg1_8)):chain():filter(function(arg0_9)
		return arg0_9:isRegularFleet()
	end):sort(function(arg0_10, arg1_10)
		return arg0_10.id < arg1_10.id
	end):value()
end

function var0_0.SetSettings(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11)
	arg0_11.groupNum = arg1_11
	arg0_11.submarineNum = arg2_11
	arg0_11.stageID = arg3_11
	arg0_11.system = arg4_11
	arg0_11.actID = arg5_11
end

function var0_0.UpdateView(arg0_12)
	arg0_12:clearFleets()
	arg0_12:UpdateFleets()
end

function var0_0.getLimitNums(arg0_13, arg1_13)
	local var0_13 = 0

	if arg1_13 == FleetType.Normal then
		var0_13 = arg0_13.groupNum
	elseif arg1_13 == FleetType.Submarine then
		var0_13 = arg0_13.submarineNum
	end

	return var0_13 or 0
end

function var0_0.UpdateFleets(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.tfFleets) do
		for iter2_14 = 1, #iter1_14 do
			arg0_14:updateFleet(iter0_14, iter2_14)
		end
	end
end

function var0_0.showToggleMask(arg0_15, arg1_15, arg2_15)
	setActive(arg0_15.toggleMask, true)

	local var0_15 = _.filter(arg0_15.fleets, function(arg0_16)
		return arg0_16:getFleetType() == arg1_15
	end)

	for iter0_15, iter1_15 in ipairs(arg0_15.toggles) do
		local var1_15 = var0_15[iter0_15]

		setActive(iter1_15, var1_15)

		if var1_15 then
			local var2_15 = iter1_15:GetComponent(typeof(Toggle))
			local var3_15 = iter1_15:Find("lock")
			local var4_15, var5_15 = var1_15:isUnlock()

			setToggleEnabled(iter1_15, var4_15)
			setActive(var3_15, not var4_15)

			local var6_15 = table.contains(arg0_15.selectIds[arg1_15], var1_15.id)

			setActive(iter1_15:Find("on"), var6_15)
			setActive(iter1_15:Find("off"), not var6_15)

			if var4_15 then
				var2_15.isOn = false

				onToggle(arg0_15, iter1_15, function(arg0_17)
					if arg0_17 then
						setActive(arg0_15.toggleMask, false)
						arg2_15(var1_15.id)
					end
				end, SFX_UI_TAG)
			else
				onButton(arg0_15, var3_15, function()
					pg.TipsMgr.GetInstance():ShowTips(var5_15)
				end, SFX_UI_CLICK)
			end
		end
	end
end

function var0_0.hideToggleMask(arg0_19)
	setActive(arg0_19.toggleMask, false)
end

function var0_0.updateFleet(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg2_20 <= arg0_20:getLimitNums(arg1_20)
	local var1_20 = arg0_20.selectIds[arg1_20][arg2_20]
	local var2_20 = arg0_20:getFleetById(var1_20)
	local var3_20 = arg0_20.tfFleets[arg1_20][arg2_20]
	local var4_20 = findTF(var3_20, "bg/name")
	local var5_20 = arg0_20:findTF(TeamType.Main, var3_20)
	local var6_20 = arg0_20:findTF(TeamType.Vanguard, var3_20)
	local var7_20 = arg0_20:findTF(TeamType.Submarine, var3_20)

	setActive(arg0_20:findTF("btn_recom", var3_20), false)

	local var8_20 = arg0_20:findTF("btn_clear", var3_20)

	setActive(var8_20, false)

	local var9_20 = arg0_20:findTF("btn_select", var3_20)

	setActive(var9_20, var0_20)

	local var10_20 = arg0_20:findTF("selected", var3_20)
	local var11_20 = arg0_20:findTF("commander", var3_20)

	setActive(var10_20, false)
	setText(var4_20, "")

	if var5_20 then
		setActive(var5_20, var0_20 and var2_20)
	end

	if var6_20 then
		setActive(var6_20, var0_20 and var2_20)
	end

	if var7_20 then
		setActive(var7_20, var0_20 and var2_20)
	end

	if var0_20 and var2_20 then
		setText(var4_20, var2_20 and var2_20:GetName() or "")

		if arg1_20 == FleetType.Submarine then
			arg0_20:updateShips(var7_20, var2_20.subShips, var2_20.id, TeamType.Submarine)
		else
			arg0_20:updateShips(var5_20, var2_20.mainShips, var2_20.id, TeamType.Main)
			arg0_20:updateShips(var6_20, var2_20.vanguardShips, var2_20.id, TeamType.Vanguard)
		end
	end

	onButton(arg0_20, var9_20, function()
		arg0_20.toggleList.position = (var9_20.position + var8_20.position) / 2
		arg0_20.toggleList.anchoredPosition = arg0_20.toggleList.anchoredPosition + Vector2(-arg0_20.toggleList.rect.width / 2, -var9_20.rect.height / 2)

		arg0_20:showToggleMask(arg1_20, function(arg0_22)
			arg0_20:hideToggleMask()
			arg0_20:selectFleet(arg1_20, arg2_20, arg0_22)
		end)
	end, SFX_UI_CLICK)
end

function var0_0.getFleetById(arg0_23, arg1_23)
	return _.detect(arg0_23.fleets, function(arg0_24)
		return arg0_24.id == arg1_23
	end)
end

function var0_0.updateShips(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25)
	removeAllChildren(arg1_25)

	local var0_25 = getProxy(BayProxy)

	for iter0_25 = 1, 3 do
		local var1_25 = var0_25:getShipById(arg2_25[iter0_25])

		if var1_25 then
			local var2_25 = var1_25 and arg0_25.tfShipTpl
			local var3_25 = cloneTplTo(var2_25, arg1_25)

			setActive(var3_25, true)

			if var1_25 then
				updateShip(var3_25, var1_25)
				setActive(var3_25:Find("event_block"), false)
			end

			setActive(arg0_25:findTF("ship_type", var3_25), false)
		end
	end
end

function var0_0.selectFleet(arg0_26, arg1_26, arg2_26, arg3_26)
	local var0_26 = arg0_26.selectIds[arg1_26]

	if arg3_26 > 0 and table.contains(var0_26, arg3_26) then
		return
	end

	if arg1_26 == FleetType.Normal and arg0_26:getLimitNums(arg1_26) > 0 and arg3_26 == 0 and #_.filter(var0_26, function(arg0_27)
		return arg0_27 > 0
	end) == 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_lease_one_ship"))

		return
	end

	local var1_26 = arg0_26:getFleetById(arg3_26)

	if var1_26 then
		if not var1_26:isUnlock() then
			return
		end

		if var1_26:isLegalToFight() ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_not_enough"))

			return
		end
	end

	var0_26[arg2_26] = arg3_26

	arg0_26:updateFleet(arg1_26, arg2_26)
end

function var0_0.clearFleets(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28.tfFleets) do
		_.each(iter1_28, function(arg0_29)
			arg0_28:clearFleet(arg0_29)
		end)
	end
end

function var0_0.clearFleet(arg0_30, arg1_30)
	local var0_30 = arg0_30:findTF(TeamType.Main, arg1_30)
	local var1_30 = arg0_30:findTF(TeamType.Vanguard, arg1_30)
	local var2_30 = arg0_30:findTF(TeamType.Submarine, arg1_30)

	if var0_30 then
		removeAllChildren(var0_30)
	end

	if var1_30 then
		removeAllChildren(var1_30)
	end

	if var2_30 then
		removeAllChildren(var2_30)
	end
end

function var0_0.OnShow(arg0_31)
	pg.UIMgr.GetInstance():BlurPanel(arg0_31._tf)
	setActive(arg0_31._tf, true)
end

function var0_0.OnHide(arg0_32)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_32._tf, arg0_32.viewParent._tf)
	setActive(arg0_32._tf, false)
end

function var0_0.OnCombat(arg0_33)
	local var0_33 = {
		arg0_33.fleets[arg0_33.selectIds[FleetType.Normal][1]]
	}

	arg0_33:emit(ActivityMediator.GO_SINGLE_PRECOMBAT, {
		system = arg0_33.system,
		stageId = arg0_33.stageID,
		activityID = arg0_33.actID,
		fleets = var0_33
	})
end

return var0_0
