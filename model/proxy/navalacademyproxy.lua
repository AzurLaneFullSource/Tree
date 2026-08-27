local var0_0 = class("NavalAcademyProxy", import(".NetProxy"))

var0_0.COURSE_START = "NavalAcademyProxy:COURSE_START"
var0_0.COURSE_UPDATED = "NavalAcademyProxy:COURSE_UPDATED"
var0_0.COURSE_REWARD = "NavalAcademyProxy:COURSE_REWARD"
var0_0.COURSE_CANCEL = "NavalAcademyProxy:COURSE_CANCEL"
var0_0.RESOURCE_UPGRADE = "NavalAcademyProxy:RESOURCE_UPGRADE"
var0_0.RESOURCE_UPGRADE_DONE = "NavalAcademyProxy:RESOURCE_UPGRADE_DONE"
var0_0.BUILDING_FINISH = "NavalAcademyProxy:BUILDING_FINISH"
var0_0.START_LEARN_TACTICS = "NavalAcademyProxy:START_LEARN_TACTICS"
var0_0.CANCEL_LEARN_TACTICS = "NavalAcademyProxy:CANCEL_LEARN_TACTICS"
var0_0.SKILL_CLASS_POS_UPDATED = "NavalAcademyProxy:SKILL_CLASS_POS_UPDATED"

function var0_0.register(arg0_1)
	arg0_1.timers = {}
	arg0_1.students = {}
	arg0_1.course = AcademyCourse.New()
	arg0_1.recentShips = {}

	arg0_1:on(22001, function(arg0_2)
		local var0_2 = OilResourceField.New()

		var0_2:SetLevel(arg0_2.oil_well_level)
		var0_2:SetUpgradeTimeStamp(arg0_2.oil_well_lv_up_time)

		arg0_1._oilVO = var0_2

		local var1_2 = GoldResourceField.New()

		var1_2:SetLevel(arg0_2.gold_well_level)
		var1_2:SetUpgradeTimeStamp(arg0_2.gold_well_lv_up_time)

		arg0_1._goldVO = var1_2

		local var2_2 = ClassResourceField.New()

		var2_2:SetLevel(arg0_2.class_lv)
		var2_2:SetUpgradeTimeStamp(arg0_2.class_lv_up_time)

		arg0_1._classVO = var2_2

		arg0_1.course:update(arg0_2.class)

		local var3_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.skill_class_list) do
			local var4_2 = Student.New(iter1_2)

			var3_2[var4_2.id] = var4_2
		end

		arg0_1.skillClassNum = LOCK_CLASSROOM and 2 or arg0_2.skill_class_num or 2

		arg0_1:setStudents(var3_2)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inClass")
		arg0_1:CheckResFields()

		arg0_1.dailyFinsihCnt = arg0_2.daily_finish_buff_cnt or 0
	end)
	arg0_1:on(22013, function(arg0_3)
		arg0_1.course:SetProficiency(arg0_3.proficiency)

		local var0_3 = getProxy(PlayerProxy):getData()

		var0_3.expField = arg0_3.exp_in_well

		getProxy(PlayerProxy):updatePlayer(var0_3)
		arg0_1:sendNotification(var0_0.COURSE_UPDATED)
	end)
end

function var0_0.timeCall(arg0_4)
	return {
		[ProxyRegister.DayCall] = function(arg0_5)
			arg0_4:setCourse(arg0_4.course)
			arg0_4:sendNotification(GAME.CLASS_FORCE_UPDATE)
			getProxy(NavalAcademyProxy):resetUsedDailyFinishCnt()
		end
	}
end

function var0_0.GetRecentShips(arg0_6)
	if #arg0_6.recentShips > 0 then
		for iter0_6 = #arg0_6.recentShips, 1, -1 do
			local var0_6 = arg0_6.recentShips[iter0_6]
			local var1_6 = getProxy(BayProxy):RawGetShipById(var0_6)

			if not var1_6 or _.all(var1_6:getSkillList(), function(arg0_7)
				return ShipSkill.New(var1_6.skills[arg0_7]):IsMaxLevel()
			end) then
				table.remove(arg0_6.recentShips, iter0_6)
			end
		end

		return arg0_6.recentShips
	end

	local var2_6 = getProxy(PlayerProxy):getRawData().id
	local var3_6 = PlayerPrefs.GetString("NavTacticsRecentShipId" .. var2_6)
	local var4_6 = string.split(var3_6, "#")

	for iter1_6, iter2_6 in ipairs(var4_6) do
		local var5_6 = tonumber(iter2_6) or 0

		if var5_6 > 0 then
			local var6_6 = getProxy(BayProxy):RawGetShipById(var5_6)

			if var6_6 and not table.contains(arg0_6.recentShips, var5_6) and _.any(var6_6:getSkillList(), function(arg0_8)
				return not ShipSkill.New(var6_6.skills[arg0_8]):IsMaxLevel()
			end) then
				table.insert(arg0_6.recentShips, var5_6)
			end
		end
	end

	return arg0_6.recentShips
end

function var0_0.SaveRecentShip(arg0_9, arg1_9)
	if not table.contains(arg0_9.recentShips, arg1_9) then
		table.insert(arg0_9.recentShips, arg1_9)

		for iter0_9 = 1, #arg0_9.recentShips - 11 do
			table.remove(arg0_9.recentShips, iter0_9)
		end

		local var0_9 = table.concat(arg0_9.recentShips, "#")
		local var1_9 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString("NavTacticsRecentShipId" .. var1_9, var0_9)
		PlayerPrefs.Save()
	end
end

function var0_0.getSkillClassNum(arg0_10)
	return arg0_10.skillClassNum
end

var0_0.MAX_SKILL_CLASS_NUM = 4

function var0_0.inCreaseKillClassNum(arg0_11)
	arg0_11.skillClassNum = math.min(arg0_11.skillClassNum + 1, var0_0.MAX_SKILL_CLASS_NUM)

	arg0_11:sendNotification(var0_0.SKILL_CLASS_POS_UPDATED, arg0_11.skillClassNum)
end

function var0_0.onRemove(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.timers) do
		iter1_12:Stop()
	end

	arg0_12.timers = nil

	var0_0.super.onRemove(arg0_12)
end

function var0_0.ExistStudent(arg0_13, arg1_13)
	return arg0_13.students[arg1_13] ~= nil
end

function var0_0.getStudentById(arg0_14, arg1_14)
	if arg0_14.students[arg1_14] then
		return arg0_14.students[arg1_14]:clone()
	end
end

function var0_0.getStudentIdByShipId(arg0_15, arg1_15)
	for iter0_15, iter1_15 in pairs(arg0_15.students) do
		if iter1_15.shipId == arg1_15 then
			return iter1_15.id
		end
	end
end

function var0_0.getStudentByShipId(arg0_16, arg1_16)
	for iter0_16, iter1_16 in pairs(arg0_16.students) do
		if iter1_16.shipId == arg1_16 then
			return iter1_16
		end
	end
end

function var0_0.setStudents(arg0_17, arg1_17)
	arg0_17.students = arg1_17

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inTactics")
end

function var0_0.getStudents(arg0_18)
	return Clone(arg0_18.students)
end

function var0_0.RawGetStudentList(arg0_19)
	return arg0_19.students
end

function var0_0.addStudent(arg0_20, arg1_20)
	arg0_20.students[arg1_20.id] = arg1_20

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inTactics")
	arg0_20:sendNotification(var0_0.START_LEARN_TACTICS, Clone(arg1_20))
end

function var0_0.updateStudent(arg0_21, arg1_21)
	arg0_21.students[arg1_21.id] = arg1_21

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inTactics")
end

function var0_0.deleteStudent(arg0_22, arg1_22)
	arg0_22.students[arg1_22] = nil

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inTactics")
	arg0_22:sendNotification(var0_0.CANCEL_LEARN_TACTICS, arg1_22)
end

function var0_0.GetOilVO(arg0_23)
	return arg0_23._oilVO
end

function var0_0.GetGoldVO(arg0_24)
	return arg0_24._goldVO
end

function var0_0.GetClassVO(arg0_25)
	return arg0_25._classVO
end

function var0_0.getCourse(arg0_26)
	return Clone(arg0_26.course)
end

function var0_0.setCourse(arg0_27, arg1_27)
	arg0_27.course = arg1_27

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inClass")
end

function var0_0.GetShipIDs(arg0_28)
	return {}
end

function var0_0.CheckResFields(arg0_29)
	if arg0_29._oilVO:IsStarting() then
		arg0_29:AddResFieldListener(arg0_29._oilVO)
	end

	if arg0_29._goldVO:IsStarting() then
		arg0_29:AddResFieldListener(arg0_29._goldVO)
	end

	if arg0_29._classVO:IsStarting() then
		arg0_29:AddResFieldListener(arg0_29._classVO)
	end
end

function var0_0.StartUpGradeSuccess(arg0_30, arg1_30)
	local var0_30 = arg1_30:bindConfigTable()[arg1_30:GetLevel()].time

	arg1_30:SetUpgradeTimeStamp(pg.TimeMgr.GetInstance():GetServerTime() + var0_30)
	arg0_30:AddResFieldListener(arg1_30)
	arg0_30.facade:sendNotification(var0_0.RESOURCE_UPGRADE, {
		resVO = arg1_30
	})
end

function var0_0.AddResFieldListener(arg0_31, arg1_31)
	local var0_31 = arg1_31._upgradeTimeStamp - pg.TimeMgr.GetInstance():GetServerTime()

	if var0_31 > 0 then
		local var1_31 = arg1_31:GetUpgradeType()

		if arg0_31.timers[var1_31] then
			arg0_31.timers[var1_31]:Stop()

			arg0_31.timers[var1_31] = nil
		end

		arg0_31.timers[var1_31] = Timer.New(function()
			arg0_31:UpgradeFinish()
			arg0_31.timers[var1_31]:Stop()

			arg0_31.timers[var1_31] = nil
		end, var0_31, 1)

		arg0_31.timers[var1_31]:Start()
	end
end

function var0_0.UpgradeFinish(arg0_33)
	if arg0_33._goldVO:GetDuration() and arg0_33._goldVO:GetDuration() <= 0 then
		local var0_33 = arg0_33._goldVO:bindConfigTable()[arg0_33._goldVO:GetLevel()].store

		arg0_33._goldVO:SetLevel(arg0_33._goldVO:GetLevel() + 1)
		arg0_33._goldVO:SetUpgradeTimeStamp(0)

		local var1_33 = arg0_33._goldVO:bindConfigTable()[arg0_33._goldVO:GetLevel()].store

		arg0_33:sendNotification(var0_0.RESOURCE_UPGRADE_DONE, {
			field = arg0_33._goldVO,
			value = var1_33 - var0_33
		})
	end

	if arg0_33._oilVO:GetDuration() and arg0_33._oilVO:GetDuration() <= 0 then
		local var2_33 = arg0_33._oilVO:bindConfigTable()[arg0_33._oilVO:GetLevel()].store

		arg0_33._oilVO:SetLevel(arg0_33._oilVO:GetLevel() + 1)
		arg0_33._oilVO:SetUpgradeTimeStamp(0)

		local var3_33 = arg0_33._oilVO:bindConfigTable()[arg0_33._oilVO:GetLevel()].store

		arg0_33:sendNotification(var0_0.RESOURCE_UPGRADE_DONE, {
			field = arg0_33._oilVO,
			value = var3_33 - var2_33
		})
	end

	if arg0_33._classVO:GetDuration() and arg0_33._classVO:GetDuration() <= 0 then
		local var4_33 = arg0_33._classVO:bindConfigTable()[arg0_33._classVO:GetLevel()].store
		local var5_33 = arg0_33._classVO:bindConfigTable()[arg0_33._classVO:GetLevel()].proficency_get_percent
		local var6_33 = arg0_33._classVO:bindConfigTable()[arg0_33._classVO:GetLevel()].proficency_cost_per_min

		arg0_33._classVO:SetLevel(arg0_33._classVO:GetLevel() + 1)
		arg0_33._classVO:SetUpgradeTimeStamp(0)

		local var7_33 = arg0_33._classVO:bindConfigTable()[arg0_33._classVO:GetLevel()].store
		local var8_33 = arg0_33._classVO:bindConfigTable()[arg0_33._classVO:GetLevel()].proficency_get_percent
		local var9_33 = arg0_33._classVO:bindConfigTable()[arg0_33._classVO:GetLevel()].proficency_cost_per_min

		arg0_33:sendNotification(var0_0.RESOURCE_UPGRADE_DONE, {
			field = arg0_33._classVO,
			value = var7_33 - var4_33,
			rate = var8_33 - var5_33,
			exp = (var9_33 - var6_33) * 60
		})
	end
end

function var0_0.isResourceFieldUpgradeConditionSatisfy(arg0_34)
	local var0_34 = getProxy(PlayerProxy):getData()

	if arg0_34:GetOilVO():CanUpgrade(var0_34.level, var0_34.gold) or arg0_34:GetGoldVO():CanUpgrade(var0_34.level, var0_34.gold) or arg0_34:GetClassVO():CanUpgrade(var0_34.level, var0_34.gold) then
		return true
	end

	return false
end

function var0_0.AddCourseProficiency(arg0_35, arg1_35)
	local var0_35 = arg0_35:getCourse()
	local var1_35 = arg0_35:GetClassVO()
	local var2_35 = var1_35:GetExp2ProficiencyRatio() * var0_35:getExtraRate()
	local var3_35 = var0_35:GetProficiency() + math.floor(arg1_35 * var2_35 * 0.01)
	local var4_35 = math.min(var3_35, var1_35:GetMaxProficiency())

	var0_35:SetProficiency(var4_35)
	arg0_35:setCourse(var0_35)
end

function var0_0.AddProficiency(arg0_36, arg1_36)
	local var0_36 = arg0_36:getCourse()

	var0_36:SetProficiency(math.min(var0_36:GetProficiency() + arg1_36, arg0_36:GetClassVO():GetMaxProficiency()))
	arg0_36:setCourse(var0_36)
end

function var0_0.fillStudens(arg0_37, arg1_37)
	local var0_37 = pg.gameset.academy_random_ship_count.key_value
	local var1_37 = {}

	for iter0_37, iter1_37 in pairs(arg1_37) do
		var1_37[iter1_37.groupId] = true
		var0_37 = var0_37 - 1
	end

	local var2_37 = pg.gameset.academy_random_ship_coldtime.key_value

	if not arg0_37._timeStamp or var2_37 < os.time() - arg0_37._timeStamp then
		arg0_37._studentsFiller = nil
	end

	if not arg0_37._studentsFiller then
		local var3_37 = math.random(1, var0_37)

		arg0_37._timeStamp = os.time()
		arg0_37._studentsFiller = {}

		local var4_37 = getProxy(CollectionProxy):getGroups()
		local var5_37 = getProxy(BayProxy)
		local var6_37 = getProxy(ShipSkinProxy):getSkinList()
		local var7_37 = {}

		for iter2_37, iter3_37 in pairs(var4_37) do
			if not table.contains(var1_37, iter2_37) then
				var7_37[#var7_37 + 1] = iter2_37
			end
		end

		local var8_37 = #var7_37

		while var3_37 > 0 and var8_37 > 0 do
			local var9_37 = math.random(#var7_37)
			local var10_37 = var7_37[var9_37]
			local var11_37 = var4_37[var10_37]
			local var12_37 = var10_37 * 10 + 1
			local var13_37 = 10000000000 + var12_37
			local var14_37 = ShipGroup.getSkinList(var10_37)
			local var15_37 = {}
			local var16_37
			local var17_37 = {}

			for iter4_37, iter5_37 in ipairs(var14_37) do
				local var18_37 = iter5_37.skin_type

				if var18_37 == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var6_37, iter5_37.id) or var18_37 == ShipSkin.SKIN_TYPE_REMAKE and var11_37.trans or var18_37 == ShipSkin.SKIN_TYPE_PROPOSE and var11_37.married == 1 then
					var17_37[#var17_37 + 1] = iter5_37.id
				end

				var16_37 = var17_37[math.random(#var17_37)]
			end

			local var19_37 = {
				id = var13_37,
				groupId = var10_37,
				configId = var12_37,
				skin_id = var16_37
			}

			table.remove(var7_37, var9_37)

			var8_37 = var8_37 - 1
			var3_37 = var3_37 - 1
			arg0_37._studentsFiller[#arg0_37._studentsFiller + 1] = var19_37
		end
	end

	for iter6_37, iter7_37 in ipairs(arg0_37._studentsFiller) do
		arg1_37[#arg1_37 + 1] = Ship.New(iter7_37)
	end

	return arg1_37
end

function var0_0.IsShowTip(arg0_38)
	local var0_38 = getProxy(PlayerProxy)

	if var0_38 and var0_38:getData() and arg0_38:isResourceFieldUpgradeConditionSatisfy() then
		return true
	end

	local var1_38 = getProxy(ShopsProxy)

	if var1_38 then
		local var2_38 = var1_38:getShopStreet()

		if var2_38 and var2_38:isUpdateGoods() then
			return true
		end
	end

	local var3_38 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_38, iter1_38 in pairs(arg0_38.students) do
		if var3_38 >= iter1_38:getFinishTime() then
			return true
		end
	end

	if getProxy(CollectionProxy):unclaimTrophyCount() > 0 then
		return true
	end

	local var4_38 = getProxy(TaskProxy)

	if _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST), function(arg0_39)
		local var0_39 = arg0_39:getTaskShip()
		local var1_39 = var0_39 and var4_38:getAcademyTask(var0_39.groupId) or nil
		local var2_39 = var4_38:getTaskById(var1_39)
		local var3_39 = var4_38:getFinishTaskById(var1_39)

		return var0_39 and (var1_39 and not var2_39 and not var3_39 or var2_39 and var2_39:isFinish())
	end) then
		return true
	end

	return false
end

function var0_0.getDailyFinishCnt(arg0_40)
	local var0_40 = _.detect(BuffHelper.GetBuffsByActivityType(ActivityConst.ACTIVITY_TYPE_BUFF), function(arg0_41)
		return arg0_41:getConfig("benefit_type") == "skill_learn_time"
	end)

	return (var0_40 and tonumber(var0_40:getConfig("benefit_effect")) or 0) - arg0_40.dailyFinsihCnt
end

function var0_0.updateUsedDailyFinishCnt(arg0_42)
	arg0_42.dailyFinsihCnt = arg0_42.dailyFinsihCnt + 1
end

function var0_0.resetUsedDailyFinishCnt(arg0_43)
	arg0_43.dailyFinsihCnt = 0
end

return var0_0
