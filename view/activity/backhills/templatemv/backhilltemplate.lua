local var0_0 = class("BackHillTemplate", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return arg0_1.UIName
end

function var0_0.init(arg0_2)
	arg0_2.loader = AutoLoader.New()
end

function var0_0.willExit(arg0_3)
	arg0_3.loader:Clear()
end

function var0_0.InitFacility(arg0_4, arg1_4, arg2_4)
	onButton(arg0_4, arg1_4, arg2_4)
	onButton(arg0_4, arg1_4:Find("button"), arg2_4)
end

function var0_0.InitFacilityCross(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	onButton(arg0_5, arg1_5:Find(arg3_5), arg4_5, SFX_PANEL)
	onButton(arg0_5, arg2_5:Find(arg3_5), arg4_5, SFX_PANEL)
end

function var0_0.getStudents(arg0_6, arg1_6, arg2_6)
	local var0_6 = {}
	local var1_6 = getProxy(ActivityProxy):getActivityById(arg0_6)

	if not var1_6 then
		return var0_6
	end

	local var2_6 = var1_6:getConfig("config_client")

	var2_6 = var2_6 and var2_6.ships

	if var2_6 then
		local var3_6 = Clone(var2_6)
		local var4_6 = math.random(arg1_6, arg2_6)
		local var5_6 = #var3_6

		while var4_6 > 0 and var5_6 > 0 do
			local var6_6 = math.random(1, var5_6)

			table.insert(var0_6, var3_6[var6_6])

			var3_6[var6_6] = var3_6[var5_6]
			var5_6 = var5_6 - 1
			var4_6 = var4_6 - 1
		end
	end

	return var0_6
end

function var0_0.InitStudents(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = var0_0.getStudents(arg1_7, arg2_7, arg3_7)
	local var1_7 = {}

	for iter0_7, iter1_7 in pairs(arg0_7.graphPath.points) do
		if not iter1_7.outRandom then
			table.insert(var1_7, iter1_7)
		end
	end

	local var2_7 = #var1_7

	arg0_7.academyStudents = {}

	local var3_7 = {}

	for iter2_7, iter3_7 in pairs(var0_7) do
		if not arg0_7.academyStudents[iter2_7] then
			local var4_7 = cloneTplTo(arg0_7._shipTpl, arg0_7._map)

			var4_7.gameObject.name = iter2_7

			local var5_7 = arg0_7.ChooseRandomPos(var1_7, var2_7)

			var2_7 = (var2_7 - 2) % #var1_7 + 1

			local var6_7 = SummerFeastNavigationAgent.New(var4_7.gameObject)

			var6_7:attach()
			var6_7:setPathFinder(arg0_7.graphPath)
			var6_7:SetPositionTable(var3_7)
			var6_7:setCurrentIndex(var5_7 and var5_7.id)
			var6_7:SetOnTransEdge(function(arg0_8, arg1_8, arg2_8)
				arg1_8, arg2_8 = math.min(arg1_8, arg2_8), math.max(arg1_8, arg2_8)

				local var0_8 = arg0_7[arg0_7.edge2area[arg1_8 .. "_" .. arg2_8] or arg0_7.edge2area.default]

				arg0_8._tf:SetParent(var0_8)
			end)
			var6_7:updateStudent(iter3_7)

			arg0_7.academyStudents[iter2_7] = var6_7
		end
	end

	if #var0_7 > 0 then
		arg0_7.sortTimer = Timer.New(function()
			arg0_7:sortStudents()
		end, 0.2, -1)

		arg0_7.sortTimer:Start()
		arg0_7.sortTimer.func()
	end
end

function var0_0.ChooseRandomPos(arg0_10, arg1_10)
	local var0_10 = math.random(1, arg1_10)

	if not var0_10 then
		return nil
	end

	pg.Tool.Swap(arg0_10, var0_10, arg1_10)

	return arg0_10[arg1_10]
end

function var0_0.sortStudents(arg0_11)
	local var0_11 = arg0_11.containers

	for iter0_11, iter1_11 in pairs(var0_11) do
		if iter1_11.childCount > 1 then
			local var1_11 = {}

			for iter2_11 = 1, iter1_11.childCount do
				local var2_11 = iter1_11:GetChild(iter2_11 - 1)

				table.insert(var1_11, {
					tf = var2_11,
					index = iter2_11
				})
			end

			table.sort(var1_11, function(arg0_12, arg1_12)
				local var0_12 = arg0_12.tf.anchoredPosition.y - arg1_12.tf.anchoredPosition.y

				if math.abs(var0_12) < 1 then
					return arg0_12.index < arg1_12.index
				else
					return var0_12 > 0
				end
			end)

			for iter3_11, iter4_11 in ipairs(var1_11) do
				iter4_11.tf:SetSiblingIndex(iter3_11 - 1)
			end
		end
	end
end

function var0_0.clearStudents(arg0_13)
	if arg0_13.sortTimer then
		arg0_13.sortTimer:Stop()

		arg0_13.sortTimer = nil
	end

	if arg0_13.academyStudents then
		for iter0_13, iter1_13 in pairs(arg0_13.academyStudents) do
			iter1_13:detach()
			Destroy(iter1_13._go)
		end

		table.clear(arg0_13.academyStudents)
	end
end

function var0_0.AutoFitScreen(arg0_14)
	local var0_14 = Screen.width / Screen.height
	local var1_14 = 1.77777777777778
	local var2_14 = arg0_14._map.rect.width
	local var3_14 = arg0_14._map.rect.height
	local var4_14

	if var1_14 <= var0_14 then
		local var5_14 = 1080 * var0_14

		var4_14 = math.clamp(var5_14 / var2_14, 1, 2)
	else
		local var6_14 = 1920 / var0_14

		var4_14 = math.clamp(var6_14 / var3_14, 1, 2)
	end

	setLocalScale(arg0_14._map, {
		x = var4_14,
		y = var4_14,
		z = var4_14
	})
	setLocalScale(arg0_14._upper, {
		x = var4_14,
		y = var4_14,
		z = var4_14
	})
end

function var0_0.IsMiniActNeedTip(arg0_15)
	local var0_15 = getProxy(ActivityProxy):getActivityById(arg0_15)

	assert(var0_15)

	return Activity.IsActivityReady(var0_15)
end

function var0_0.UpdateActivity(arg0_16, arg1_16)
	return
end

function var0_0.BindItemActivityShop(arg0_17)
	arg0_17:InitFacilityCross(arg0_17._map, arg0_17._upper, "bujishangdian", function()
		arg0_17:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
end

function var0_0.BindItemSkinShop(arg0_19)
	arg0_19:InitFacilityCross(arg0_19._map, arg0_19._upper, "huanzhuangshangdian", function()
		arg0_19:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SKINSHOP)
	end)
end

function var0_0.BindItemBuildShip(arg0_21)
	arg0_21:InitFacilityCross(arg0_21._map, arg0_21._upper, "xianshijianzao", function()
		local var0_22
		local var1_22 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1)
		local var2_22 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILD)

		if var1_22 and not var1_22:isEnd() then
			var0_22 = BuildShipScene.PROJECTS.ACTIVITY
		elseif var2_22 and not var2_22:isEnd() then
			var0_22 = ({
				BuildShipScene.PROJECTS.SPECIAL,
				BuildShipScene.PROJECTS.LIGHT,
				BuildShipScene.PROJECTS.HEAVY
			})[var2_22:getConfig("config_client").id]
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_21:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = var0_22
		})
	end)
end

function var0_0.BindItemBattle(arg0_23)
	arg0_23:InitFacilityCross(arg0_23._map, arg0_23._upper, "tebiezuozhan", function()
		local var0_24 = getProxy(ChapterProxy)
		local var1_24, var2_24 = var0_24:getLastMapForActivity()

		if not var1_24 or not var0_24:getMapById(var1_24):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0_23:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_24,
				mapIdx = var1_24
			})
		end
	end)
end

function var0_0.UpdateBuildingTip(arg0_25, arg1_25, arg2_25)
	if not arg1_25 then
		return false
	end

	local var0_25 = arg1_25:GetBuildingLevel(arg2_25)
	local var1_25 = pg.activity_event_building[arg2_25]

	if not var1_25 or var0_25 >= #var1_25.buff then
		return false
	end

	local var2_25 = var1_25.material[var0_25]

	return _.all(var2_25, function(arg0_26)
		local var0_26 = arg0_26[1]
		local var1_26 = arg0_26[2]
		local var2_26 = arg0_26[3]
		local var3_26 = 0

		if var0_26 == DROP_TYPE_VITEM then
			local var4_26 = AcessWithinNull(Item.getConfigData(var1_26), "link_id")

			assert(var4_26 == arg1_25.id)

			var3_26 = arg1_25:GetMaterialCount(var1_26)
		elseif var0_26 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var5_26 = AcessWithinNull(pg.activity_drop_type[var0_26], "activity_id")

			assert(var5_26)

			bagAct = getProxy(ActivityProxy):getActivityById(var5_26)
			var3_26 = bagAct:getVitemNumber(var1_26)
		end

		return var2_26 <= var3_26
	end)
end

function var0_0.UpdateView(arg0_27)
	return
end

return var0_0
