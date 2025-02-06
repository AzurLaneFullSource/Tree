local var0_0 = class("ShipSkinCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tr = arg1_1.transform
	arg0_1.painting = findTF(arg0_1.tr, "bg/mask/painting")
	arg0_1.nameBar = findTF(arg0_1.tr, "bg/desc/name_bar")
	arg0_1.name = findTF(arg0_1.nameBar, "name")
	arg0_1.effectBar = findTF(arg0_1.tr, "bg/desc/effect_bar")
	arg0_1.effect = findTF(arg0_1.effectBar, "effect")
	arg0_1.bgUsing = findTF(arg0_1.tr, "bg/bg_using")
	arg0_1.bgMark = findTF(arg0_1.tr, "bg/bg_mark")
	arg0_1.picNotBuy = findTF(arg0_1.bgMark, "bg/pic_not_buy")
	arg0_1.picActivity = findTF(arg0_1.bgMark, "bg/pic_activity")
	arg0_1.picPropose = findTF(arg0_1.bgMark, "bg/pic_propose")
	arg0_1.picShare = findTF(arg0_1.bgMark, "bg/pic_share")
	arg0_1.outline = findTF(arg0_1.tr, "bg/outline")
	arg0_1.tags = findTF(arg0_1.tr, "bg/tags")
	arg0_1.timelimitTag = findTF(arg0_1.tr, "bg/timelimit")
	arg0_1.timelimitTimeTxt = findTF(arg0_1.tr, "bg/timelimit_time")
	arg0_1.shareFlag = findTF(arg0_1.tr, "bg/share")
	arg0_1.changeSkinTF = findTF(arg0_1.tr, "bg/change_skin")
	arg0_1.changeSkinToggle = ChangeSkinToggle.New(findTF(arg0_1.changeSkinTF, "ToggleUI"))

	setActive(arg0_1.changeSkinTF, false)
	setActive(arg0_1.timelimitTag, false)
	setActive(arg0_1.timelimitTimeTxt, false)

	arg0_1.hideObjToggleTF = findTF(arg0_1.tr, "hideObjToggle")

	setActive(arg0_1.hideObjToggleTF, false)

	arg0_1.hideObjToggle = GetComponent(arg0_1.hideObjToggleTF, typeof(Toggle))

	setText(findTF(arg0_1.hideObjToggleTF, "Label"), i18n("paint_hide_other_obj_tip"))
end

function var0_0.updateSkin(arg0_2, arg1_2, arg2_2)
	if arg0_2.skin ~= arg1_2 or arg0_2.own ~= arg2_2 then
		arg0_2.skin = arg1_2
		arg0_2.own = arg2_2

		setActive(arg0_2.nameBar, true)
		setActive(arg0_2.effectBar, false)
		setActive(arg0_2.shareFlag, false)
		setText(arg0_2.name, shortenString(arg1_2.name, 7))

		local var0_2 = not arg2_2

		setActive(arg0_2.bgMark, var0_2)

		if var0_2 then
			setActive(arg0_2.picNotBuy, false)
			setActive(arg0_2.picActivity, false)
			setActive(arg0_2.picPropose, false)
			setActive(arg0_2.picShare, false)

			if arg1_2.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
				setActive(arg0_2.picPropose, true)
			elseif arg0_2.skin.shop_id > 0 then
				setActive(arg0_2.picNotBuy, true)
			elseif _.any(pg.activity_shop_template.all, function(arg0_3)
				local var0_3 = pg.activity_shop_template[arg0_3]

				return var0_3.commodity_type == DROP_TYPE_SKIN and var0_3.commodity_id == arg0_2.skin.id
			end) or _.any(pg.activity_shop_extra.all, function(arg0_4)
				local var0_4 = pg.activity_shop_extra[arg0_4]

				return var0_4.commodity_type == DROP_TYPE_SKIN and var0_4.commodity_id == arg0_2.skin.id
			end) then
				setActive(arg0_2.picActivity, true)
			else
				setActive(arg0_2.picActivity, true)
			end
		end

		setActive(arg0_2.tags, true)

		for iter0_2 = 0, arg0_2.tags.childCount - 1 do
			setActive(arg0_2.tags:GetChild(iter0_2), false)
		end

		_.each(arg1_2.tag, function(arg0_5)
			setActive(arg0_2.tags:Find("tag" .. arg0_5), true)
		end)
		arg0_2:flushSkin()
	end
end

function var0_0.updateData(arg0_6, arg1_6, arg2_6, arg3_6)
	if arg0_6.ship ~= arg1_6 or arg0_6.skin ~= arg2_6 or arg0_6.own ~= arg3_6 or arg0_6.skinId ~= arg2_6.id then
		arg0_6.ship = arg1_6
		arg0_6.skin = arg2_6
		arg0_6.own = arg3_6
		arg0_6.skinId = arg0_6.skin.id

		local var0_6 = ShipGroup.GetChangeSkinData(arg0_6.skin.id)

		if arg3_6 and var0_6 then
			setActive(arg0_6.changeSkinTF, true)
		else
			setActive(arg0_6.changeSkinTF, false)
		end

		if var0_6 then
			arg0_6.changeSkinToggle:setShipData(arg0_6.skin.id, arg0_6.ship.id)
		end

		setActive(arg0_6.nameBar, true)
		setActive(arg0_6.effectBar, false)
		setText(arg0_6.name, shortenString(arg2_6.name, 7))

		local var1_6 = arg0_6.skin.id == arg0_6.ship:getConfig("skin_id")
		local var2_6 = ShipSkin.IsShareSkin(arg0_6.ship, arg0_6.skin.id)
		local var3_6 = false

		if var2_6 then
			var3_6 = ShipSkin.CanUseShareSkinForShip(arg0_6.ship, arg0_6.skin.id)
		end

		setActive(arg0_6.shareFlag, var2_6)

		local var4_6 = not var1_6 and not arg3_6 or var2_6 and not var3_6

		setActive(arg0_6.bgMark, var4_6)

		if var4_6 then
			setActive(arg0_6.picNotBuy, false)
			setActive(arg0_6.picActivity, false)
			setActive(arg0_6.picPropose, false)
			setActive(arg0_6.picShare, false)

			if arg2_6.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
				setActive(arg0_6.picPropose, true)
			elseif not arg3_6 and arg0_6.skin.shop_id > 0 then
				setActive(arg0_6.picNotBuy, true)
			elseif not arg3_6 and (_.any(pg.activity_shop_template.all, function(arg0_7)
				local var0_7 = pg.activity_shop_template[arg0_7]

				return var0_7.commodity_type == DROP_TYPE_SKIN and var0_7.commodity_id == arg0_6.skin.id
			end) or _.any(pg.activity_shop_extra.all, function(arg0_8)
				local var0_8 = pg.activity_shop_extra[arg0_8]

				return var0_8.commodity_type == DROP_TYPE_SKIN and var0_8.commodity_id == arg0_6.skin.id
			end)) then
				setActive(arg0_6.picActivity, true)
			elseif var2_6 and not var3_6 then
				setActive(arg0_6.picShare, true)
			else
				setActive(arg0_6.picActivity, true)
			end
		end

		setActive(arg0_6.tags, true)

		for iter0_6 = 0, arg0_6.tags.childCount - 1 do
			setActive(arg0_6.tags:GetChild(iter0_6), false)
		end

		_.each(arg2_6.tag, function(arg0_9)
			setActive(arg0_6.tags:Find("tag" .. arg0_9), true)
		end)
		arg0_6:flushSkin()

		local var5_6 = getProxy(ShipSkinProxy):getSkinById(arg0_6.skin.id)
		local var6_6 = var5_6 and var5_6:isExpireType() and not var5_6:isExpired()

		setActive(arg0_6.timelimitTag, var6_6)
		setActive(arg0_6.timelimitTimeTxt, var6_6)

		if arg0_6.skinTimer then
			arg0_6.skinTimer:Stop()
		end

		if var6_6 then
			arg0_6.skinTimer = Timer.New(function()
				local var0_10 = skinTimeStamp(var5_6:getRemainTime())

				setText(arg0_6.timelimitTimeTxt:Find("Text"), var0_10)
			end, 1, -1)

			arg0_6.skinTimer:Start()
			arg0_6.skinTimer.func()
		end
	end
end

function var0_0.updateSelected(arg0_11, arg1_11)
	if arg0_11.selected ~= arg1_11 then
		arg0_11.selected = arg1_11

		setActive(arg0_11.outline, tobool(arg0_11.selected))
	end
end

function var0_0.updateUsing(arg0_12, arg1_12)
	if arg0_12.using ~= arg1_12 then
		arg0_12.using = arg1_12

		setActive(arg0_12.bgUsing, arg0_12.using)
	end
end

function var0_0.flushSkin(arg0_13)
	arg0_13:clearPainting()
	arg0_13:loadPainting()
end

function var0_0.clearPainting(arg0_14)
	if arg0_14.paintingName then
		retPaintingPrefab(arg0_14.painting, arg0_14.paintingName)

		arg0_14.paintingName = nil
	end
end

function var0_0.loadPainting(arg0_15)
	arg0_15.paintingName = arg0_15.skin and arg0_15.skin.painting or "unknown"

	local var0_15 = checkABExist("painting/" .. arg0_15.paintingName .. "_n")

	setActive(arg0_15.hideObjToggle, var0_15)

	arg0_15.hideObjToggle.isOn = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_15.paintingName, 0) ~= 0

	setPaintingPrefabAsync(arg0_15.painting, arg0_15.paintingName, "pifu")
end

function var0_0.clear(arg0_16)
	arg0_16:clearPainting()

	arg0_16.skin = nil
	arg0_16.selected = nil
	arg0_16.using = nil

	if arg0_16.skinTimer then
		arg0_16.skinTimer:Stop()

		arg0_16.skinTimer = nil
	end
end

return var0_0
