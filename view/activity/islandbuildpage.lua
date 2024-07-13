local var0_0 = class("IslandBuildPage")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.buildPanel = arg1_1
	arg0_1.activityId = ActivityConst.ISLAND_TASK_ID

	local var0_1 = pg.activity_template[arg0_1.activityId].config_client

	if var0_1.pt_id and var0_1.pt_id > 0 then
		arg0_1.ptId = var0_1.pt_id
		arg0_1.ptName = pg.player_resource[arg0_1.ptId].name
	end

	arg0_1.buffs = var0_1.buff
	arg0_1.maxNum = arg0_1.buffs[#arg0_1.buffs].pt[1]

	setActive(arg0_1.buildPanel, false)

	arg0_1.pointProgressText = findTF(arg0_1.buildPanel, "progressContent/progress")
	arg0_1.pointProgressSlider = findTF(arg0_1.buildPanel, "slider")
	arg0_1.pointStarTpl = findTF(arg0_1.buildPanel, "levelStar/starTpl")
	arg0_1.pointAdd = findTF(arg0_1.buildPanel, "add")
	arg0_1.pointLevelStar = findTF(arg0_1.buildPanel, "levelStar")
	arg0_1.pointStarTfs = {}

	local var1_1 = arg0_1.pointLevelStar.sizeDelta.x

	for iter0_1 = 1, #arg0_1.buffs do
		local var2_1 = tf(Instantiate(arg0_1.pointStarTpl))

		SetParent(var2_1, arg0_1.pointLevelStar)
		setActive(var2_1, true)
		setText(findTF(var2_1, "bg/text"), iter0_1)
		setImageSprite(findTF(var2_1, "img"), LoadSprite(IslandTaskScene.ui_atlas, "img_level_" .. iter0_1))

		local var3_1 = arg0_1.buffs[iter0_1].pt[1]

		var2_1.anchoredPosition = Vector3(var3_1 / arg0_1.maxNum * var1_1, 0, 0)

		table.insert(arg0_1.pointStarTfs, var2_1)

		if iter0_1 == 1 then
			setActive(var2_1, false)
		end
	end

	setText(findTF(arg0_1.buildPanel, "levelNum/text"), i18n(IslandTaskScene.island_build_level))
	setText(findTF(arg0_1.buildPanel, "levelBuff/text"), i18n(IslandTaskScene.island_build_level))
	setText(findTF(arg0_1.buildPanel, "buildDesc"), i18n(IslandTaskScene.island_build_desc))
	arg0_1:updatePoint()
end

function var0_0.updatePoint(arg0_2)
	local var0_2 = 0
	local var1_2 = 1

	if arg0_2.ptId then
		var0_2 = getProxy(PlayerProxy):getData()[arg0_2.ptName] or 0
	else
		var0_2 = arg0_2:getNum()
	end

	if var0_2 > arg0_2.maxNum then
		var0_2 = arg0_2.maxNum
	end

	local var2_2 = arg0_2:getBuildLv(var0_2)

	for iter0_2 = 1, #arg0_2.pointStarTfs do
		local var3_2 = arg0_2.pointStarTfs[iter0_2]

		if iter0_2 <= var2_2 then
			setActive(findTF(var3_2, "img"), true)
			setActive(findTF(var3_2, "lock"), false)

			GetComponent(var3_2, typeof(CanvasGroup)).alpha = 1
		else
			setActive(findTF(var3_2, "img"), false)
			setActive(findTF(var3_2, "lock"), true)

			GetComponent(var3_2, typeof(CanvasGroup)).alpha = 0.5
		end
	end

	local var4_2 = arg0_2.buffs[var2_2].benefit

	for iter1_2 = 1, #var4_2 do
		local var5_2 = var4_2[iter1_2]
		local var6_2 = pg.benefit_buff_template[var5_2].desc
		local var7_2 = findTF(arg0_2.buildPanel, "add/" .. iter1_2)

		if PLATFORM_CODE == PLATFORM_JP then
			findTF(var7_2, "img").sizeDelta = Vector2(450, 70)

			setText(findTF(var7_2, "text_jp"), var6_2)
		else
			setText(findTF(var7_2, "text"), var6_2)
		end
	end

	setSlider(arg0_2.pointProgressSlider, 0, arg0_2.maxNum, var0_2)
	setText(findTF(arg0_2.buildPanel, "levelNum/num"), "Lv." .. var2_2)
	setText(findTF(arg0_2.buildPanel, "levelBuff/num"), "Lv." .. var2_2)
	arg0_2:setProgressText()
end

function var0_0.getBuildLv(arg0_3, arg1_3)
	local var0_3 = 1

	for iter0_3 = #arg0_3.buffs, 1, -1 do
		var0_3 = arg1_3 >= arg0_3.buffs[iter0_3].pt[1] and var0_3 < iter0_3 and iter0_3 or var0_3
	end

	return var0_3
end

function var0_0.setProgressText(arg0_4)
	local var0_4 = arg0_4:getNum()
	local var1_4 = arg0_4.maxNum

	setText(arg0_4.pointProgressText, setColorStr(var0_4, "#C2695B") .. setColorStr("/" .. var1_4, "#9D6B59"))
end

function var0_0.getNum(arg0_5)
	return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2):GetBuildingLevelSum()
end

function var0_0.setActive(arg0_6, arg1_6)
	setActive(arg0_6.buildPanel, arg1_6)
end

function var0_0.dispose(arg0_7)
	return
end

return var0_0
