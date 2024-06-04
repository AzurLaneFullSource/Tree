local var0 = class("IslandBuildPage")

function var0.Ctor(arg0, arg1, arg2)
	arg0.buildPanel = arg1
	arg0.activityId = ActivityConst.ISLAND_TASK_ID

	local var0 = pg.activity_template[arg0.activityId].config_client

	if var0.pt_id and var0.pt_id > 0 then
		arg0.ptId = var0.pt_id
		arg0.ptName = pg.player_resource[arg0.ptId].name
	end

	arg0.buffs = var0.buff
	arg0.maxNum = arg0.buffs[#arg0.buffs].pt[1]

	setActive(arg0.buildPanel, false)

	arg0.pointProgressText = findTF(arg0.buildPanel, "progressContent/progress")
	arg0.pointProgressSlider = findTF(arg0.buildPanel, "slider")
	arg0.pointStarTpl = findTF(arg0.buildPanel, "levelStar/starTpl")
	arg0.pointAdd = findTF(arg0.buildPanel, "add")
	arg0.pointLevelStar = findTF(arg0.buildPanel, "levelStar")
	arg0.pointStarTfs = {}

	local var1 = arg0.pointLevelStar.sizeDelta.x

	for iter0 = 1, #arg0.buffs do
		local var2 = tf(Instantiate(arg0.pointStarTpl))

		SetParent(var2, arg0.pointLevelStar)
		setActive(var2, true)
		setText(findTF(var2, "bg/text"), iter0)
		setImageSprite(findTF(var2, "img"), LoadSprite(IslandTaskScene.ui_atlas, "img_level_" .. iter0))

		local var3 = arg0.buffs[iter0].pt[1]

		var2.anchoredPosition = Vector3(var3 / arg0.maxNum * var1, 0, 0)

		table.insert(arg0.pointStarTfs, var2)

		if iter0 == 1 then
			setActive(var2, false)
		end
	end

	setText(findTF(arg0.buildPanel, "levelNum/text"), i18n(IslandTaskScene.island_build_level))
	setText(findTF(arg0.buildPanel, "levelBuff/text"), i18n(IslandTaskScene.island_build_level))
	setText(findTF(arg0.buildPanel, "buildDesc"), i18n(IslandTaskScene.island_build_desc))
	arg0:updatePoint()
end

function var0.updatePoint(arg0)
	local var0 = 0
	local var1 = 1

	if arg0.ptId then
		var0 = getProxy(PlayerProxy):getData()[arg0.ptName] or 0
	else
		var0 = arg0:getNum()
	end

	if var0 > arg0.maxNum then
		var0 = arg0.maxNum
	end

	local var2 = arg0:getBuildLv(var0)

	for iter0 = 1, #arg0.pointStarTfs do
		local var3 = arg0.pointStarTfs[iter0]

		if iter0 <= var2 then
			setActive(findTF(var3, "img"), true)
			setActive(findTF(var3, "lock"), false)

			GetComponent(var3, typeof(CanvasGroup)).alpha = 1
		else
			setActive(findTF(var3, "img"), false)
			setActive(findTF(var3, "lock"), true)

			GetComponent(var3, typeof(CanvasGroup)).alpha = 0.5
		end
	end

	local var4 = arg0.buffs[var2].benefit

	for iter1 = 1, #var4 do
		local var5 = var4[iter1]
		local var6 = pg.benefit_buff_template[var5].desc
		local var7 = findTF(arg0.buildPanel, "add/" .. iter1)

		if PLATFORM_CODE == PLATFORM_JP then
			findTF(var7, "img").sizeDelta = Vector2(450, 70)

			setText(findTF(var7, "text_jp"), var6)
		else
			setText(findTF(var7, "text"), var6)
		end
	end

	setSlider(arg0.pointProgressSlider, 0, arg0.maxNum, var0)
	setText(findTF(arg0.buildPanel, "levelNum/num"), "Lv." .. var2)
	setText(findTF(arg0.buildPanel, "levelBuff/num"), "Lv." .. var2)
	arg0:setProgressText()
end

function var0.getBuildLv(arg0, arg1)
	local var0 = 1

	for iter0 = #arg0.buffs, 1, -1 do
		var0 = arg1 >= arg0.buffs[iter0].pt[1] and var0 < iter0 and iter0 or var0
	end

	return var0
end

function var0.setProgressText(arg0)
	local var0 = arg0:getNum()
	local var1 = arg0.maxNum

	setText(arg0.pointProgressText, setColorStr(var0, "#C2695B") .. setColorStr("/" .. var1, "#9D6B59"))
end

function var0.getNum(arg0)
	return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2):GetBuildingLevelSum()
end

function var0.setActive(arg0, arg1)
	setActive(arg0.buildPanel, arg1)
end

function var0.dispose(arg0)
	return
end

return var0
