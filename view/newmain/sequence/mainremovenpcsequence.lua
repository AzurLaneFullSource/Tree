local var0 = class("MainRemoveNpcSequence")

function var0.Execute(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACT_NPC_SHIP_ID)
	local var1 = getProxy(BayProxy)

	if not var1.isClearNpc and (not var0 or var0:isEnd()) then
		local var2 = var1:getRawData()

		for iter0, iter1 in pairs(var2) do
			if iter1:isActivityNpc() then
				local var3 = iter1:clone()

				arg0:UnloadEquipments(var3)
				arg0:CheckChapters(var3)
				arg0:CheckFormations(var3)
				arg0:CheckNavTactics(var3)
				var1:removeShipById(var3.id)
			end
		end

		var1.isClearNpc = true
	end

	arg1()
end

function var0.UnloadEquipments(arg0, arg1)
	local var0 = getProxy(EquipmentProxy)
	local var1 = arg1.equipments

	for iter0, iter1 in pairs(var1) do
		if iter1 then
			arg1:updateEquip(iter0, nil)
			var0:addEquipmentById(iter1.id, 1)
		end

		if arg1:getEquipSkin(iter0) ~= 0 then
			arg1:updateEquipmentSkin(iter0, 0)
			var0:addEquipmentSkin(iter1.skinId, 1)
		end
	end

	local var2 = arg1:GetSpWeapon()

	if var2 then
		arg1:UpdateSpWeapon(nil)
		var0:AddSpWeapon(var2)
	end
end

function var0.CheckChapters(arg0, arg1)
	local var0 = getProxy(ChapterProxy):getActiveChapter()

	if var0 then
		local var1 = var0.fleets

		for iter0, iter1 in pairs(var1) do
			if iter1:containsShip(arg1.id) then
				pg.m02:sendNotification(GAME.CHAPTER_OP, {
					type = ChapterConst.OpRetreat
				})

				break
			end
		end
	end
end

function var0.CheckFormations(arg0, arg1)
	local var0 = getProxy(FleetProxy)
	local var1 = var0:getData()

	for iter0, iter1 in pairs(var1) do
		if iter1:containShip(arg1) then
			iter1:removeShip(arg1)
			var0:updateFleet(iter1)
		end
	end
end

function var0.CheckNavTactics(arg0, arg1)
	local var0 = getProxy(NavalAcademyProxy)
	local var1 = var0:getStudents()

	for iter0, iter1 in ipairs(var1) do
		if iter1.shipId == arg1.id then
			var0:deleteStudent(iter1.id)

			break
		end
	end
end

return var0
