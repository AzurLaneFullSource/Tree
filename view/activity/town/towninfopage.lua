local var0_0 = class("TownInfoPage", import("view.base.BaseSubView"))

var0_0.SLOT_CNT = 9

function var0_0.getUIName(arg0_1)
	return "TownInfoPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.togglesTF = arg0_2:findTF("frame/toggles")

	eachChild(arg0_2.togglesTF, function(arg0_3)
		onToggle(arg0_2, arg0_3, function(arg0_4)
			setImageColor(arg0_2:findTF("name", arg0_3), Color.NewHex(arg0_4 and "F5ECDD" or "796464"))
		end, SFX_PANEL)
	end)

	arg0_2.townTip = arg0_2:findTF("town/tip", arg0_2.togglesTF)
	arg0_2.placeTip = arg0_2:findTF("place/tip", arg0_2.togglesTF)
	arg0_2.shipTip = arg0_2:findTF("ship/tip", arg0_2.togglesTF)
	arg0_2.townPanel = arg0_2:findTF("frame/panels/town_panel")
	arg0_2.townLevelNow = arg0_2:findTF("lvmask/level_now", arg0_2.townPanel)
	arg0_2.townLevelNext = arg0_2:findTF("lvmask/level_next", arg0_2.townPanel)
	arg0_2.curExp = arg0_2:findTF("infos/exp/value/cur", arg0_2.townPanel)
	arg0_2.needExp = arg0_2:findTF("infos/exp/value/need", arg0_2.townPanel)
	arg0_2.goldOutput = arg0_2:findTF("infos/output/value", arg0_2.townPanel)
	arg0_2.goldLimit = arg0_2:findTF("infos/limit/value", arg0_2.townPanel)
	arg0_2.townUpgradeTF = arg0_2:findTF("upgrade_status", arg0_2.townPanel)
	arg0_2.shipPanel = arg0_2:findTF("frame/panels/ship_panel")
	arg0_2.shipUIList = UIItemList.New(arg0_2:findTF("content", arg0_2.shipPanel), arg0_2:findTF("content/tpl", arg0_2.shipPanel))

	arg0_2.shipUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_2:UpdateShip(arg1_5, arg2_5)
		end
	end)

	arg0_2.placePanel = arg0_2:findTF("frame/panels/place_panel")

	setText(arg0_2:findTF("view/content/tpl/next/title", arg0_2.placePanel), i18n("town_place_next_title"))

	arg0_2.placeUIList = UIItemList.New(arg0_2:findTF("view/content", arg0_2.placePanel), arg0_2:findTF("view/content/tpl", arg0_2.placePanel))

	arg0_2.placeUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_2:UpdatePlace(arg1_6, arg2_6)
		end
	end)

	arg0_2.specialWorkGroup = pg.gameset.activity_town_special_work.key_value
end

function var0_0.SetActivity(arg0_7, arg1_7)
	arg0_7.activity = arg1_7 or getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN)

	assert(arg0_7.activity and not arg0_7.activity:isEnd(), "not exist town act, type: " .. ActivityConst.ACTIVITY_TYPE_TOWN)
end

function var0_0.OnInit(arg0_8)
	arg0_8:SetActivity()

	arg0_8.slotUnlockLv = {}

	;(function()
		for iter0_9, iter1_9 in ipairs(pg.activity_town_level.all) do
			local var0_9 = pg.activity_town_level[iter1_9].unlock_chara

			for iter2_9 = 1, var0_9 do
				if not arg0_8.slotUnlockLv[iter2_9] then
					arg0_8.slotUnlockLv[iter2_9] = iter1_9
				end

				if arg0_8.slotUnlockLv[var0_0.SLOT_CNT] then
					return
				end
			end
		end
	end)()
	triggerToggle(arg0_8:findTF("town", arg0_8.togglesTF), true)
end

function var0_0.Flush(arg0_10)
	arg0_10:FlushTownPanel()
	arg0_10:FlushShipPanel()
	arg0_10:FlushPlacePanel()
	arg0_10:Show()
end

function var0_0.OnExpUpdate(arg0_11)
	local var0_11 = arg0_11.activity:GetExp()
	local var1_11 = pg.activity_town_level[arg0_11.townLv].exp

	setText(arg0_11.curExp, var0_11)
	setTextColor(arg0_11.curExp, Color.NewHex(not isMaxLv and var0_11 < var1_11 and "CC3A33" or "63423E"))
	setText(arg0_11.needExp, "/" .. (isMaxLv and 0 or var1_11))
end

function var0_0.OnTownUpgrade(arg0_12, arg1_12)
	local var0_12 = arg0_12.townPanel:GetComponent(typeof(DftAniEvent))

	var0_12:SetEndEvent(function()
		if arg1_12 then
			arg1_12()
		end

		arg0_12.inTownAnim = false

		var0_12:SetEndEvent(nil)
	end)
	var0_12:SetTriggerEvent(function()
		arg0_12:Flush()
		var0_12:SetTriggerEvent(nil)
	end)
	arg0_12.townPanel:GetComponent(typeof(Animation)):Play("anim_cowboy_info_town_lvup")

	arg0_12.inTownAnim = true

	arg0_12:managedTween(LeanTween.delayedCall, function()
		arg0_12:FlushTownWithoutLv()
	end, 0.265, nil)
end

function var0_0.OnPlaceUpgrade(arg0_16, arg1_16)
	arg0_16.townUpgradeCb = arg1_16

	arg0_16:Flush()
end

function var0_0.UpdateTownStatus(arg0_17)
	local var0_17, var1_17, var2_17 = arg0_17.activity:CanUpgradeTown()

	setActive(arg0_17.townTip, var0_17)
	eachChild(arg0_17.townUpgradeTF, function(arg0_18)
		setActive(arg0_18, arg0_18.name == var1_17)
	end)
	onButton(arg0_17, arg0_17:findTF("normal", arg0_17.townUpgradeTF), function()
		if not var0_17 or arg0_17.inTownAnim then
			return
		end

		arg0_17:emit(TownMediator.UPGRADE_TOWN)
	end, SFX_PANEL)

	if var1_17 == "no_story" then
		setText(arg0_17:findTF("no_story/content/value/cur", arg0_17.townUpgradeTF), var2_17[1])
		setText(arg0_17:findTF("no_story/content/value/need", arg0_17.townUpgradeTF), "/" .. var2_17[2])
	elseif var1_17 == "no_exp_or_gold" then
		setTextColor(arg0_17:findTF("no_exp_or_gold/cost/Text", arg0_17.townUpgradeTF), Color.NewHex(var2_17 == "no_gold" and "FF756E" or "FFEBC9"))
	end
end

function var0_0.FlushTownWithoutLv(arg0_20)
	arg0_20:OnExpUpdate()

	local var0_20 = arg0_20.activity:GetGoldOutput()

	setText(arg0_20.goldOutput, string.format("+%s/H", TownActivity.GoldToShow(var0_20)))

	local var1_20 = arg0_20.activity:GetLimitGold()

	setText(arg0_20.goldLimit, TownActivity.GoldToShow(var1_20))

	local var2_20 = TownActivity.GoldToShow(pg.activity_town_level[arg0_20.townLv].gold)

	setText(arg0_20:findTF("normal/cost/Text", arg0_20.townUpgradeTF), var2_20)
	setText(arg0_20:findTF("no_exp_or_gold/cost/Text", arg0_20.townUpgradeTF), var2_20)
	arg0_20:UpdateTownStatus()
end

function var0_0.FlushTownPanel(arg0_21)
	arg0_21.townLv = arg0_21.activity:GetTownLevel()

	local var0_21 = arg0_21.activity:IsMaxTownLevel()

	setText(arg0_21.townLevelNow, "LV." .. (var0_21 and "MAX" or arg0_21.townLv))
	setText(arg0_21.townLevelNext, "LV." .. (var0_21 and "MAX" or arg0_21.townLv + 1))
	arg0_21:FlushTownWithoutLv()
end

function var0_0.FlushShipPanel(arg0_22)
	arg0_22.shipIds = arg0_22.activity:GetShipIds()
	arg0_22.unlockCnt = arg0_22.activity:GetUnlockSlotCnt()

	arg0_22.shipUIList:align(var0_0.SLOT_CNT)
	setActive(arg0_22.shipTip, arg0_22.activity:HasEmptySlot())
end

function var0_0.UpdateShip(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg1_23 + 1
	local var1_23 = var0_23 > arg0_23.unlockCnt

	setActive(arg0_23:findTF("lock", arg2_23), var1_23)

	if var1_23 then
		setText(arg0_23:findTF("lock/Text", arg2_23), i18n("town_lock_level", "LV" .. arg0_23.slotUnlockLv[var0_23]))
	end

	local var2_23 = arg0_23.shipIds[var0_23]
	local var3_23 = not var2_23 or var2_23 == 0

	setActive(arg0_23:findTF("empty", arg2_23), var3_23)
	setActive(arg0_23:findTF("mask", arg2_23), not var3_23)

	local var4_23

	if not var3_23 then
		local var5_23 = getProxy(BayProxy):RawGetShipById(var2_23)

		if var5_23 then
			local var6_23 = LoadSprite("qicon/" .. var5_23:getPainting())

			setImageSprite(arg0_23:findTF("mask/icon", arg2_23), var6_23, true)
		else
			setActive(arg0_23:findTF("empty", arg2_23), true)
			setActive(arg0_23:findTF("mask", arg2_23), false)
		end
	end

	onButton(arg0_23, arg2_23, function()
		if var1_23 then
			return
		end

		arg0_23:emit(TownMediator.OPEN_CHUANWU, var0_23, var4_23)
	end, SFX_PANEL)
end

function var0_0.FlushPlacePanel(arg0_25)
	arg0_25.placeList = arg0_25.activity:GetPlaceList()

	table.sort(arg0_25.placeList, CompareFuncs({
		function(arg0_26)
			return arg0_26:GetNextId() and 0 or 1
		end,
		function(arg0_27)
			return arg0_27.id
		end
	}))
	arg0_25.placeUIList:align(#arg0_25.placeList)
end

function var0_0.UpdatePlaceStatus(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28:findTF("upgrade_status", arg2_28)
	local var1_28 = TownActivity.GoldToShow(arg1_28:GetCostGold())

	setText(arg0_28:findTF("normal/cost/Text", var0_28), var1_28)
	setText(arg0_28:findTF("no_gold/cost/Text", var0_28), var1_28)

	local var2_28, var3_28 = arg0_28.activity:CanUpgradePlace(arg1_28.id)

	if var2_28 then
		arg0_28.isShowPlaceTip = true
	end

	eachChild(var0_28, function(arg0_29)
		setActive(arg0_29, arg0_29.name == var3_28)
	end)
	onButton(arg0_28, arg0_28:findTF("normal", var0_28), function()
		if not var2_28 or arg0_28.inPlaceAnim then
			return
		end

		arg0_28.upgradePlaceName = arg2_28.name

		arg0_28:emit(TownMediator.UPGRADE_WORKPLACE, arg1_28.id)
	end, SFX_PANEL)

	if var3_28 == "no_level" then
		setText(arg0_28:findTF("no_level/Text", var0_28), i18n("town_lock_level", "LV" .. arg1_28:GetNeedTownLv()))
	end
end

function var0_0.UpdatePlace(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31.placeList[arg1_31 + 1]

	arg2_31.name = arg1_31 + 1

	setImageSprite(arg0_31:findTF("info/icon", arg2_31), GetSpriteFromAtlas("ui/townui_atlas", var0_31:GetIcon()), true)
	setText(arg0_31:findTF("info/name", arg2_31), var0_31:GetName())
	setText(arg0_31:findTF("info/gold/Text", arg2_31), var0_31:GetEffectStr())
	seriesAsync({
		function(arg0_32)
			if arg0_31.upgradePlaceName and arg2_31.name == arg0_31.upgradePlaceName then
				local var0_32 = arg2_31:GetComponent(typeof(DftAniEvent))

				var0_32:SetEndEvent(function()
					if arg0_31.townUpgradeCb then
						arg0_31.townUpgradeCb()

						arg0_31.townUpgradeCb = nil
					end

					arg0_31.inPlaceAnim = false

					var0_32:SetEndEvent(nil)
				end)
				arg2_31:GetComponent(typeof(Animation)):Play("anim_cowboy_info_place_lvup")

				arg0_31.inPlaceAnim = true

				arg0_31:managedTween(LeanTween.delayedCall, function()
					arg0_32()
				end, 0.2, nil)

				arg0_31.upgradePlaceName = nil
			else
				arg0_32()
			end
		end,
		function(arg0_35)
			local var0_35 = var0_31:GetNextId()
			local var1_35 = not var0_35

			setActive(arg0_31:findTF("next", arg2_31), not var1_35)

			if not var1_35 then
				setText(arg0_31:findTF("next/infos/exp/value", arg2_31), "+" .. var0_31:GetAddExp())

				local var2_35 = TownWorkplace.New(var0_35)

				setText(arg0_31:findTF("next/infos/gold/value", arg2_31), var2_35:GetEffectStr())
			end
		end
	}, function()
		return
	end)
	setActive(arg0_31:findTF("info/gold", arg2_31), var0_31:GetGroup() ~= arg0_31.specialWorkGroup)
	setActive(arg0_31:findTF("next/infos/gold", arg2_31), var0_31:GetGroup() ~= arg0_31.specialWorkGroup)
	arg0_31:UpdatePlaceStatus(var0_31, arg2_31)
end

function var0_0.OnUpdateTime(arg0_37)
	arg0_37:UpdateTownStatus()

	arg0_37.isShowPlaceTip = false

	for iter0_37, iter1_37 in ipairs(arg0_37.placeList) do
		arg0_37:UpdatePlaceStatus(iter1_37, arg0_37:findTF(iter0_37, arg0_37.placeUIList.container))
	end

	setActive(arg0_37.placeTip, arg0_37.isShowPlaceTip)
end

function var0_0.OnDestroy(arg0_38)
	return
end

return var0_0
