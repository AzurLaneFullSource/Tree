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

function var0_0.OnTownUpgrade(arg0_12)
	arg0_12.townPanel:GetComponent(typeof(Animation)):Play("anim_cowboy_info_town_lvup")
	arg0_12:managedTween(LeanTween.delayedCall, function()
		arg0_12:FlushTownPanel()
	end, 0.265, nil)
	arg0_12:managedTween(LeanTween.delayedCall, function()
		arg0_12:Flush()
	end, 0.56, nil)
end

function var0_0.UpdateTownStatus(arg0_15)
	local var0_15, var1_15, var2_15 = arg0_15.activity:CanUpgradeTown()

	setActive(arg0_15.townTip, var0_15)
	eachChild(arg0_15.townUpgradeTF, function(arg0_16)
		setActive(arg0_16, arg0_16.name == var1_15)
	end)
	onButton(arg0_15, arg0_15:findTF("normal", arg0_15.townUpgradeTF), function()
		if not var0_15 then
			return
		end

		arg0_15:emit(TownMediator.UPGRADE_TOWN)
	end, SFX_PANEL)

	if var1_15 == "no_story" then
		setText(arg0_15:findTF("no_story/content/value/cur", arg0_15.townUpgradeTF), var2_15[1])
		setText(arg0_15:findTF("no_story/content/value/need", arg0_15.townUpgradeTF), "/" .. var2_15[2])
	elseif var1_15 == "no_exp_or_gold" then
		setTextColor(arg0_15:findTF("no_exp_or_gold/cost/Text", arg0_15.townUpgradeTF), Color.NewHex(var2_15 == "no_gold" and "FF756E" or "FFEBC9"))
	end
end

function var0_0.FlushTownPanel(arg0_18)
	arg0_18.townLv = arg0_18.activity:GetTownLevel()

	local var0_18 = arg0_18.activity:IsMaxTownLevel()

	setText(arg0_18.townLevelNow, "LV." .. (var0_18 and "MAX" or arg0_18.townLv))
	setText(arg0_18.townLevelNext, "LV." .. (var0_18 and "MAX" or arg0_18.townLv + 1))
	arg0_18:OnExpUpdate()

	local var1_18 = arg0_18.activity:GetGoldOutput()

	setText(arg0_18.goldOutput, string.format("+%s/H", TownActivity.GoldToShow(var1_18)))

	local var2_18 = arg0_18.activity:GetLimitGold()

	setText(arg0_18.goldLimit, TownActivity.GoldToShow(var2_18))

	local var3_18 = TownActivity.GoldToShow(pg.activity_town_level[arg0_18.townLv].gold)

	setText(arg0_18:findTF("normal/cost/Text", arg0_18.townUpgradeTF), var3_18)
	setText(arg0_18:findTF("no_exp_or_gold/cost/Text", arg0_18.townUpgradeTF), var3_18)
	arg0_18:UpdateTownStatus()
end

function var0_0.FlushShipPanel(arg0_19)
	arg0_19.shipIds = arg0_19.activity:GetShipIds()
	arg0_19.unlockCnt = arg0_19.activity:GetUnlockSlotCnt()

	arg0_19.shipUIList:align(var0_0.SLOT_CNT)
	setActive(arg0_19.shipTip, arg0_19.activity:HasEmptySlot())
end

function var0_0.UpdateShip(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg1_20 + 1
	local var1_20 = var0_20 > arg0_20.unlockCnt

	setActive(arg0_20:findTF("lock", arg2_20), var1_20)

	if var1_20 then
		setText(arg0_20:findTF("lock/Text", arg2_20), i18n("town_lock_level", "LV" .. arg0_20.slotUnlockLv[var0_20]))
	end

	local var2_20 = arg0_20.shipIds[var0_20]
	local var3_20 = not var2_20 or var2_20 == 0

	setActive(arg0_20:findTF("empty", arg2_20), var3_20)
	setActive(arg0_20:findTF("mask", arg2_20), not var3_20)

	local var4_20

	if not var3_20 then
		local var5_20 = getProxy(BayProxy):RawGetShipById(var2_20)

		if var5_20 then
			local var6_20 = LoadSprite("qicon/" .. var5_20:getPainting())

			setImageSprite(arg0_20:findTF("mask/icon", arg2_20), var6_20, true)
		else
			setActive(arg0_20:findTF("empty", arg2_20), true)
			setActive(arg0_20:findTF("mask", arg2_20), false)
		end
	end

	onButton(arg0_20, arg2_20, function()
		if var1_20 then
			return
		end

		arg0_20:emit(TownMediator.OPEN_CHUANWU, var0_20, var4_20)
	end, SFX_PANEL)
end

function var0_0.FlushPlacePanel(arg0_22)
	arg0_22.placeList = arg0_22.activity:GetPlaceList()

	table.sort(arg0_22.placeList, CompareFuncs({
		function(arg0_23)
			return arg0_23:GetNextId() and 0 or 1
		end,
		function(arg0_24)
			return arg0_24.id
		end
	}))
	arg0_22.placeUIList:align(#arg0_22.placeList)
end

function var0_0.UpdatePlaceStatus(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25:findTF("upgrade_status", arg2_25)
	local var1_25 = TownActivity.GoldToShow(arg1_25:GetCostGold())

	setText(arg0_25:findTF("normal/cost/Text", var0_25), var1_25)
	setText(arg0_25:findTF("no_gold/cost/Text", var0_25), var1_25)

	local var2_25, var3_25 = arg0_25.activity:CanUpgradePlace(arg1_25.id)

	if var2_25 then
		arg0_25.isShowPlaceTip = true
	end

	eachChild(var0_25, function(arg0_26)
		setActive(arg0_26, arg0_26.name == var3_25)
	end)
	onButton(arg0_25, arg0_25:findTF("normal", var0_25), function()
		if not var2_25 then
			return
		end

		arg0_25.upgradePlaceName = arg2_25.name

		arg0_25:emit(TownMediator.UPGRADE_WORKPLACE, arg1_25.id)
	end, SFX_PANEL)

	if var3_25 == "no_level" then
		setText(arg0_25:findTF("no_level/Text", var0_25), i18n("town_lock_level", "LV" .. arg1_25:GetNeedTownLv()))
	end
end

function var0_0.UpdatePlace(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28.placeList[arg1_28 + 1]

	arg2_28.name = arg1_28 + 1

	setImageSprite(arg0_28:findTF("info/icon", arg2_28), GetSpriteFromAtlas("ui/townui_atlas", var0_28:GetIcon()), true)
	setText(arg0_28:findTF("info/name", arg2_28), var0_28:GetName())
	setText(arg0_28:findTF("info/gold/Text", arg2_28), var0_28:GetEffectStr())
	seriesAsync({
		function(arg0_29)
			if arg0_28.upgradePlaceName and arg2_28.name == arg0_28.upgradePlaceName then
				arg2_28:GetComponent(typeof(Animation)):Play("anim_cowboy_info_place_lvup")
				arg0_28:managedTween(LeanTween.delayedCall, function()
					arg0_29()
				end, 0.2, nil)

				arg0_28.upgradePlaceName = nil
			else
				arg0_29()
			end
		end,
		function(arg0_31)
			local var0_31 = var0_28:GetNextId()
			local var1_31 = not var0_31

			setActive(arg0_28:findTF("next", arg2_28), not var1_31)

			if not var1_31 then
				setText(arg0_28:findTF("next/infos/exp/value", arg2_28), "+" .. var0_28:GetAddExp())

				local var2_31 = TownWorkplace.New(var0_31)

				setText(arg0_28:findTF("next/infos/gold/value", arg2_28), var2_31:GetEffectStr())
			end
		end
	}, function()
		return
	end)
	setActive(arg0_28:findTF("info/gold", arg2_28), var0_28:GetGroup() ~= arg0_28.specialWorkGroup)
	setActive(arg0_28:findTF("next/infos/gold", arg2_28), var0_28:GetGroup() ~= arg0_28.specialWorkGroup)
	arg0_28:UpdatePlaceStatus(var0_28, arg2_28)
end

function var0_0.OnUpdateTime(arg0_33)
	arg0_33:UpdateTownStatus()

	arg0_33.isShowPlaceTip = false

	for iter0_33, iter1_33 in ipairs(arg0_33.placeList) do
		arg0_33:UpdatePlaceStatus(iter1_33, arg0_33:findTF(iter0_33, arg0_33.placeUIList.container))
	end

	setActive(arg0_33.placeTip, arg0_33.isShowPlaceTip)
end

function var0_0.OnDestroy(arg0_34)
	return
end

return var0_0
