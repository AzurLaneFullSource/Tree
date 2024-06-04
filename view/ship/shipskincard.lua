local var0 = class("ShipSkinCard")

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.tr = arg1.transform
	arg0.painting = findTF(arg0.tr, "bg/mask/painting")
	arg0.nameBar = findTF(arg0.tr, "bg/desc/name_bar")
	arg0.name = findTF(arg0.nameBar, "name")
	arg0.effectBar = findTF(arg0.tr, "bg/desc/effect_bar")
	arg0.effect = findTF(arg0.effectBar, "effect")
	arg0.bgUsing = findTF(arg0.tr, "bg/bg_using")
	arg0.bgMark = findTF(arg0.tr, "bg/bg_mark")
	arg0.picNotBuy = findTF(arg0.bgMark, "bg/pic_not_buy")
	arg0.picActivity = findTF(arg0.bgMark, "bg/pic_activity")
	arg0.picPropose = findTF(arg0.bgMark, "bg/pic_propose")
	arg0.picShare = findTF(arg0.bgMark, "bg/pic_share")
	arg0.outline = findTF(arg0.tr, "bg/outline")
	arg0.tags = findTF(arg0.tr, "bg/tags")
	arg0.timelimitTag = findTF(arg0.tr, "bg/timelimit")
	arg0.timelimitTimeTxt = findTF(arg0.tr, "bg/timelimit_time")
	arg0.shareFlag = findTF(arg0.tr, "bg/share")

	setActive(arg0.timelimitTag, false)
	setActive(arg0.timelimitTimeTxt, false)

	arg0.hideObjToggleTF = findTF(arg0.tr, "hideObjToggle")

	setActive(arg0.hideObjToggleTF, false)

	arg0.hideObjToggle = GetComponent(arg0.hideObjToggleTF, typeof(Toggle))

	setText(findTF(arg0.hideObjToggleTF, "Label"), i18n("paint_hide_other_obj_tip"))
end

function var0.updateSkin(arg0, arg1, arg2)
	if arg0.skin ~= arg1 or arg0.own ~= arg2 then
		arg0.skin = arg1
		arg0.own = arg2

		setActive(arg0.nameBar, true)
		setActive(arg0.effectBar, false)
		setActive(arg0.shareFlag, false)
		setText(arg0.name, shortenString(arg1.name, 7))

		local var0 = not arg2

		setActive(arg0.bgMark, var0)

		if var0 then
			setActive(arg0.picNotBuy, false)
			setActive(arg0.picActivity, false)
			setActive(arg0.picPropose, false)
			setActive(arg0.picShare, false)

			if arg1.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
				setActive(arg0.picPropose, true)
			elseif arg0.skin.shop_id > 0 then
				setActive(arg0.picNotBuy, true)
			elseif _.any(pg.activity_shop_template.all, function(arg0)
				local var0 = pg.activity_shop_template[arg0]

				return var0.commodity_type == DROP_TYPE_SKIN and var0.commodity_id == arg0.skin.id
			end) or _.any(pg.activity_shop_extra.all, function(arg0)
				local var0 = pg.activity_shop_extra[arg0]

				return var0.commodity_type == DROP_TYPE_SKIN and var0.commodity_id == arg0.skin.id
			end) then
				setActive(arg0.picActivity, true)
			else
				setActive(arg0.picActivity, true)
			end
		end

		setActive(arg0.tags, true)

		for iter0 = 0, arg0.tags.childCount - 1 do
			setActive(arg0.tags:GetChild(iter0), false)
		end

		_.each(arg1.tag, function(arg0)
			setActive(arg0.tags:Find("tag" .. arg0), true)
		end)
		arg0:flushSkin()
	end
end

function var0.updateData(arg0, arg1, arg2, arg3)
	if arg0.ship ~= arg1 or arg0.skin ~= arg2 or arg0.own ~= arg3 then
		arg0.ship = arg1
		arg0.skin = arg2
		arg0.own = arg3

		setActive(arg0.nameBar, true)
		setActive(arg0.effectBar, false)
		setText(arg0.name, shortenString(arg2.name, 7))

		local var0 = arg0.skin.id == arg0.ship:getConfig("skin_id")
		local var1 = ShipSkin.IsShareSkin(arg0.ship, arg0.skin.id)
		local var2 = false

		if var1 then
			var2 = ShipSkin.CanUseShareSkinForShip(arg0.ship, arg0.skin.id)
		end

		setActive(arg0.shareFlag, var1)

		local var3 = not var0 and not arg3 or var1 and not var2

		setActive(arg0.bgMark, var3)

		if var3 then
			setActive(arg0.picNotBuy, false)
			setActive(arg0.picActivity, false)
			setActive(arg0.picPropose, false)
			setActive(arg0.picShare, false)

			if arg2.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
				setActive(arg0.picPropose, true)
			elseif not arg3 and arg0.skin.shop_id > 0 then
				setActive(arg0.picNotBuy, true)
			elseif not arg3 and (_.any(pg.activity_shop_template.all, function(arg0)
				local var0 = pg.activity_shop_template[arg0]

				return var0.commodity_type == DROP_TYPE_SKIN and var0.commodity_id == arg0.skin.id
			end) or _.any(pg.activity_shop_extra.all, function(arg0)
				local var0 = pg.activity_shop_extra[arg0]

				return var0.commodity_type == DROP_TYPE_SKIN and var0.commodity_id == arg0.skin.id
			end)) then
				setActive(arg0.picActivity, true)
			elseif var1 and not var2 then
				setActive(arg0.picShare, true)
			else
				setActive(arg0.picActivity, true)
			end
		end

		setActive(arg0.tags, true)

		for iter0 = 0, arg0.tags.childCount - 1 do
			setActive(arg0.tags:GetChild(iter0), false)
		end

		_.each(arg2.tag, function(arg0)
			setActive(arg0.tags:Find("tag" .. arg0), true)
		end)
		arg0:flushSkin()

		local var4 = getProxy(ShipSkinProxy):getSkinById(arg0.skin.id)
		local var5 = var4 and var4:isExpireType() and not var4:isExpired()

		setActive(arg0.timelimitTag, var5)
		setActive(arg0.timelimitTimeTxt, var5)

		if arg0.skinTimer then
			arg0.skinTimer:Stop()
		end

		if var5 then
			arg0.skinTimer = Timer.New(function()
				local var0 = skinTimeStamp(var4:getRemainTime())

				setText(arg0.timelimitTimeTxt:Find("Text"), var0)
			end, 1, -1)

			arg0.skinTimer:Start()
			arg0.skinTimer.func()
		end
	end
end

function var0.updateSelected(arg0, arg1)
	if arg0.selected ~= arg1 then
		arg0.selected = arg1

		setActive(arg0.outline, tobool(arg0.selected))
	end
end

function var0.updateUsing(arg0, arg1)
	if arg0.using ~= arg1 then
		arg0.using = arg1

		setActive(arg0.bgUsing, arg0.using)
	end
end

function var0.flushSkin(arg0)
	arg0:clearPainting()
	arg0:loadPainting()
end

function var0.clearPainting(arg0)
	if arg0.paintingName then
		retPaintingPrefab(arg0.painting, arg0.paintingName)

		arg0.paintingName = nil
	end
end

function var0.loadPainting(arg0)
	arg0.paintingName = arg0.skin and arg0.skin.painting or "unknown"

	local var0 = checkABExist("painting/" .. arg0.paintingName .. "_n")

	setActive(arg0.hideObjToggle, var0)

	arg0.hideObjToggle.isOn = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0.paintingName, 0) ~= 0

	setPaintingPrefabAsync(arg0.painting, arg0.paintingName, "pifu")
end

function var0.clear(arg0)
	arg0:clearPainting()

	arg0.skin = nil
	arg0.selected = nil
	arg0.using = nil

	if arg0.skinTimer then
		arg0.skinTimer:Stop()

		arg0.skinTimer = nil
	end
end

return var0
