local var0_0 = class("MainRemoveNpcSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACT_NPC_SHIP_ID)
	local var1_1 = getProxy(BayProxy)

	if not var1_1.isClearNpc and (not var0_1 or var0_1:isEnd()) then
		local var2_1 = var1_1:getRawData()

		for iter0_1, iter1_1 in pairs(var2_1) do
			if iter1_1:isActivityNpc() then
				local var3_1 = iter1_1:clone()

				arg0_1:UnloadEquipments(var3_1)
				arg0_1:CheckChapters(var3_1)
				arg0_1:CheckFormations(var3_1)
				arg0_1:CheckNavTactics(var3_1)
				var1_1:removeShipById(var3_1.id)
			end
		end

		var1_1.isClearNpc = true
	end

	arg1_1()
end

function var0_0.UnloadEquipments(arg0_2, arg1_2)
	local var0_2 = getProxy(EquipmentProxy)
	local var1_2 = arg1_2.equipments

	for iter0_2, iter1_2 in pairs(var1_2) do
		if iter1_2 then
			arg1_2:updateEquip(iter0_2, nil)
			var0_2:addEquipmentById(iter1_2.id, 1)
		end

		if arg1_2:getEquipSkin(iter0_2) ~= 0 then
			arg1_2:updateEquipmentSkin(iter0_2, 0)
			var0_2:addEquipmentSkin(iter1_2.skinId, 1)
		end
	end

	local var2_2 = arg1_2:GetSpWeapon()

	if var2_2 then
		arg1_2:UpdateSpWeapon(nil)
		var0_2:AddSpWeapon(var2_2)
	end
end

function var0_0.CheckChapters(arg0_3, arg1_3)
	local var0_3 = getProxy(ChapterProxy):getActiveChapter()

	if var0_3 then
		local var1_3 = var0_3.fleets

		for iter0_3, iter1_3 in pairs(var1_3) do
			if iter1_3:containsShip(arg1_3.id) then
				pg.m02:sendNotification(GAME.CHAPTER_OP, {
					type = ChapterConst.OpRetreat
				})

				break
			end
		end
	end
end

function var0_0.CheckFormations(arg0_4, arg1_4)
	local var0_4 = getProxy(FleetProxy)
	local var1_4 = var0_4:getData()

	for iter0_4, iter1_4 in pairs(var1_4) do
		if iter1_4:containShip(arg1_4) then
			iter1_4:removeShip(arg1_4)
			var0_4:updateFleet(iter1_4)
		end
	end
end

function var0_0.CheckNavTactics(arg0_5, arg1_5)
	local var0_5 = getProxy(NavalAcademyProxy)
	local var1_5 = var0_5:getStudents()

	for iter0_5, iter1_5 in ipairs(var1_5) do
		if iter1_5.shipId == arg1_5.id then
			var0_5:deleteStudent(iter1_5.id)

			break
		end
	end
end

return var0_0
