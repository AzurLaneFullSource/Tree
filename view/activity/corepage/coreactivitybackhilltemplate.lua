local var0_0 = class("CoreActivityBackHillTemplate", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.loader = AutoLoader.New()
end

function var0_0.InitFacility(arg0_2, arg1_2, arg2_2)
	onButton(arg0_2, arg1_2, arg2_2)
	onButton(arg0_2, arg1_2:Find("button"), arg2_2)
end

function var0_0.InitFacilityCross(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	onButton(arg0_3, arg1_3:Find(arg3_3), arg4_3, SFX_PANEL)
	onButton(arg0_3, arg2_3:Find(arg3_3), arg4_3, SFX_PANEL)
end

function var0_0.getStudents(arg0_4, arg1_4, arg2_4)
	local var0_4 = {}
	local var1_4 = getProxy(ActivityProxy):getActivityById(arg0_4)

	if not var1_4 then
		return var0_4
	end

	local var2_4 = var1_4:getConfig("config_client")

	var2_4 = var2_4 and var2_4.ships

	if var2_4 then
		local var3_4 = Clone(var2_4)
		local var4_4 = math.random(arg1_4, arg2_4)
		local var5_4 = #var3_4

		while var4_4 > 0 and var5_4 > 0 do
			local var6_4 = math.random(1, var5_4)

			table.insert(var0_4, var3_4[var6_4])

			var3_4[var6_4] = var3_4[var5_4]
			var5_4 = var5_4 - 1
			var4_4 = var4_4 - 1
		end
	end

	return var0_4
end

function var0_0.InitStudents(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = var0_0.getStudents(arg1_5, arg2_5, arg3_5)
	local var1_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.graphPath.points) do
		if not iter1_5.outRandom then
			table.insert(var1_5, iter1_5)
		end
	end

	local var2_5 = #var1_5

	arg0_5.academyStudents = {}

	local var3_5 = {}

	for iter2_5, iter3_5 in pairs(var0_5) do
		if not arg0_5.academyStudents[iter2_5] then
			local var4_5 = cloneTplTo(arg0_5._shipTpl, arg0_5._map)

			var4_5.gameObject.name = iter2_5

			local var5_5 = arg0_5.ChooseRandomPos(var1_5, var2_5)

			var2_5 = (var2_5 - 2) % #var1_5 + 1

			local var6_5 = SummerFeastNavigationAgent.New(var4_5.gameObject)

			var6_5:attach()
			var6_5:setPathFinder(arg0_5.graphPath)
			var6_5:SetPositionTable(var3_5)
			var6_5:setCurrentIndex(var5_5 and var5_5.id)
			var6_5:SetOnTransEdge(function(arg0_6, arg1_6, arg2_6)
				arg1_6, arg2_6 = math.min(arg1_6, arg2_6), math.max(arg1_6, arg2_6)

				local var0_6 = arg0_5[arg0_5.edge2area[arg1_6 .. "_" .. arg2_6] or arg0_5.edge2area.default]

				arg0_6._tf:SetParent(var0_6)
			end)
			var6_5:updateStudent(iter3_5)

			arg0_5.academyStudents[iter2_5] = var6_5
		end
	end

	if #var0_5 > 0 then
		arg0_5.sortTimer = Timer.New(function()
			arg0_5:sortStudents()
		end, 0.2, -1)

		arg0_5.sortTimer:Start()
		arg0_5.sortTimer.func()
	end
end

function var0_0.ChooseRandomPos(arg0_8, arg1_8)
	local var0_8 = math.random(1, arg1_8)

	if not var0_8 then
		return nil
	end

	pg.Tool.Swap(arg0_8, var0_8, arg1_8)

	return arg0_8[arg1_8]
end

function var0_0.sortStudents(arg0_9)
	local var0_9 = arg0_9.containers

	for iter0_9, iter1_9 in pairs(var0_9) do
		if iter1_9.childCount > 1 then
			local var1_9 = {}

			for iter2_9 = 1, iter1_9.childCount do
				local var2_9 = iter1_9:GetChild(iter2_9 - 1)

				table.insert(var1_9, {
					tf = var2_9,
					index = iter2_9
				})
			end

			table.sort(var1_9, function(arg0_10, arg1_10)
				local var0_10 = arg0_10.tf.anchoredPosition.y - arg1_10.tf.anchoredPosition.y

				if math.abs(var0_10) < 1 then
					return arg0_10.index < arg1_10.index
				else
					return var0_10 > 0
				end
			end)

			for iter3_9, iter4_9 in ipairs(var1_9) do
				iter4_9.tf:SetSiblingIndex(iter3_9 - 1)
			end
		end
	end
end

function var0_0.clearStudents(arg0_11)
	if arg0_11.sortTimer then
		arg0_11.sortTimer:Stop()

		arg0_11.sortTimer = nil
	end

	if arg0_11.academyStudents then
		for iter0_11, iter1_11 in pairs(arg0_11.academyStudents) do
			iter1_11:detach()
			Destroy(iter1_11._go)
		end

		table.clear(arg0_11.academyStudents)
	end
end

function var0_0.AutoFitScreen(arg0_12)
	local var0_12 = Screen.width / Screen.height
	local var1_12 = 1.77777777777778
	local var2_12 = arg0_12._map.rect.width
	local var3_12 = arg0_12._map.rect.height
	local var4_12

	if var1_12 <= var0_12 then
		local var5_12 = 1080 * var0_12

		var4_12 = math.clamp(var5_12 / var2_12, 1, 2)
	else
		local var6_12 = 1920 / var0_12

		var4_12 = math.clamp(var6_12 / var3_12, 1, 2)
	end

	setLocalScale(arg0_12._map, {
		x = var4_12,
		y = var4_12,
		z = var4_12
	})
	setLocalScale(arg0_12._upper, {
		x = var4_12,
		y = var4_12,
		z = var4_12
	})
end

function var0_0.IsMiniActNeedTip(arg0_13)
	local var0_13 = getProxy(ActivityProxy):getActivityById(arg0_13)

	assert(var0_13)

	return Activity.IsActivityReady(var0_13)
end

function var0_0.UpdateActivity(arg0_14, arg1_14)
	return
end

function var0_0.BindItemActivityShop(arg0_15)
	arg0_15:InitFacilityCross(arg0_15._map, arg0_15._upper, "bujishangdian", function()
		arg0_15:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
end

function var0_0.BindItemSkinShop(arg0_17)
	arg0_17:InitFacilityCross(arg0_17._map, arg0_17._upper, "huanzhuangshangdian", function()
		arg0_17:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SKINSHOP)
	end)
end

function var0_0.BindItemBuildShip(arg0_19)
	arg0_19:InitFacilityCross(arg0_19._map, arg0_19._upper, "xianshijianzao", function()
		local var0_20
		local var1_20 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1)
		local var2_20 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILD)

		if var1_20 and not var1_20:isEnd() then
			var0_20 = BuildShipScene.PROJECTS.ACTIVITY
		elseif var2_20 and not var2_20:isEnd() then
			var0_20 = ({
				BuildShipScene.PROJECTS.SPECIAL,
				BuildShipScene.PROJECTS.LIGHT,
				BuildShipScene.PROJECTS.HEAVY
			})[var2_20:getConfig("config_client").id]
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_19:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = var0_20
		})
	end)
end

function var0_0.BindItemBattle(arg0_21)
	arg0_21:InitFacilityCross(arg0_21._map, arg0_21._upper, "tebiezuozhan", function()
		local var0_22 = getProxy(ChapterProxy)
		local var1_22, var2_22 = var0_22:getLastMapForActivity()

		if not var1_22 or not var0_22:getMapById(var1_22):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0_21:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_22,
				mapIdx = var1_22
			})
		end
	end)
end

function var0_0.UpdateBuildingTip(arg0_23, arg1_23, arg2_23)
	if not arg1_23 then
		return false
	end

	local var0_23 = arg1_23:GetBuildingLevel(arg2_23)
	local var1_23 = pg.activity_event_building[arg2_23]

	if not var1_23 or var0_23 >= #var1_23.buff then
		return false
	end

	local var2_23 = var1_23.material[var0_23]

	return _.all(var2_23, function(arg0_24)
		local var0_24 = arg0_24[1]
		local var1_24 = arg0_24[2]
		local var2_24 = arg0_24[3]
		local var3_24 = 0

		if var0_24 == DROP_TYPE_VITEM then
			local var4_24 = AcessWithinNull(Item.getConfigData(var1_24), "link_id")

			assert(var4_24 == arg1_23.id)

			var3_24 = arg1_23:GetMaterialCount(var1_24)
		elseif var0_24 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var5_24 = AcessWithinNull(pg.activity_drop_type[var0_24], "activity_id")

			assert(var5_24)

			bagAct = getProxy(ActivityProxy):getActivityById(var5_24)
			var3_24 = bagAct:getVitemNumber(var1_24)
		end

		return var2_24 <= var3_24
	end)
end

function var0_0.UpdateView(arg0_25)
	return
end

return var0_0
