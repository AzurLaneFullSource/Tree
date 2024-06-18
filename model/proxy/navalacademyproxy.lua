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

function var0_0.GetRecentShips(arg0_4)
	if #arg0_4.recentShips > 0 then
		for iter0_4 = #arg0_4.recentShips, 1, -1 do
			local var0_4 = arg0_4.recentShips[iter0_4]
			local var1_4 = getProxy(BayProxy):RawGetShipById(var0_4)

			if not var1_4 or _.all(var1_4:getSkillList(), function(arg0_5)
				return ShipSkill.New(var1_4.skills[arg0_5]):IsMaxLevel()
			end) then
				table.remove(arg0_4.recentShips, iter0_4)
			end
		end

		return arg0_4.recentShips
	end

	local var2_4 = getProxy(PlayerProxy):getRawData().id
	local var3_4 = PlayerPrefs.GetString("NavTacticsRecentShipId" .. var2_4)
	local var4_4 = string.split(var3_4, "#")

	for iter1_4, iter2_4 in ipairs(var4_4) do
		local var5_4 = tonumber(iter2_4) or 0

		if var5_4 > 0 then
			local var6_4 = getProxy(BayProxy):RawGetShipById(var5_4)

			if var6_4 and not table.contains(arg0_4.recentShips, var5_4) and _.any(var6_4:getSkillList(), function(arg0_6)
				return not ShipSkill.New(var6_4.skills[arg0_6]):IsMaxLevel()
			end) then
				table.insert(arg0_4.recentShips, var5_4)
			end
		end
	end

	return arg0_4.recentShips
end

function var0_0.SaveRecentShip(arg0_7, arg1_7)
	if not table.contains(arg0_7.recentShips, arg1_7) then
		table.insert(arg0_7.recentShips, arg1_7)

		for iter0_7 = 1, #arg0_7.recentShips - 11 do
			table.remove(arg0_7.recentShips, iter0_7)
		end

		local var0_7 = table.concat(arg0_7.recentShips, "#")
		local var1_7 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString("NavTacticsRecentShipId" .. var1_7, var0_7)
		PlayerPrefs.Save()
	end
end

function var0_0.getSkillClassNum(arg0_8)
	return arg0_8.skillClassNum
end

var0_0.MAX_SKILL_CLASS_NUM = 4

function var0_0.inCreaseKillClassNum(arg0_9)
	arg0_9.skillClassNum = math.min(arg0_9.skillClassNum + 1, var0_0.MAX_SKILL_CLASS_NUM)

	arg0_9:sendNotification(var0_0.SKILL_CLASS_POS_UPDATED, arg0_9.skillClassNum)
end

function var0_0.onRemove(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10.timers) do
		iter1_10:Stop()
	end

	arg0_10.timers = nil

	var0_0.super.onRemove(arg0_10)
end

function var0_0.ExistStudent(arg0_11, arg1_11)
	return arg0_11.students[arg1_11] ~= nil
end

function var0_0.getStudentById(arg0_12, arg1_12)
	if arg0_12.students[arg1_12] then
		return arg0_12.students[arg1_12]:clone()
	end
end

function var0_0.getStudentIdByShipId(arg0_13, arg1_13)
	for iter0_13, iter1_13 in pairs(arg0_13.students) do
		if iter1_13.shipId == arg1_13 then
			return iter1_13.id
		end
	end
end

function var0_0.getStudentByShipId(arg0_14, arg1_14)
	for iter0_14, iter1_14 in pairs(arg0_14.students) do
		if iter1_14.shipId == arg1_14 then
			return iter1_14
		end
	end
end

function var0_0.setStudents(arg0_15, arg1_15)
	arg0_15.students = arg1_15

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inTactics")
end

function var0_0.getStudents(arg0_16)
	return Clone(arg0_16.students)
end

function var0_0.RawGetStudentList(arg0_17)
	return arg0_17.students
end

function var0_0.addStudent(arg0_18, arg1_18)
	arg0_18.students[arg1_18.id] = arg1_18

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inTactics")
	arg0_18:sendNotification(var0_0.START_LEARN_TACTICS, Clone(arg1_18))
end

function var0_0.updateStudent(arg0_19, arg1_19)
	arg0_19.students[arg1_19.id] = arg1_19

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inTactics")
end

function var0_0.deleteStudent(arg0_20, arg1_20)
	arg0_20.students[arg1_20] = nil

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inTactics")
	arg0_20:sendNotification(var0_0.CANCEL_LEARN_TACTICS, arg1_20)
end

function var0_0.GetOilVO(arg0_21)
	return arg0_21._oilVO
end

function var0_0.GetGoldVO(arg0_22)
	return arg0_22._goldVO
end

function var0_0.GetClassVO(arg0_23)
	return arg0_23._classVO
end

function var0_0.getCourse(arg0_24)
	return Clone(arg0_24.course)
end

function var0_0.setCourse(arg0_25, arg1_25)
	arg0_25.course = arg1_25

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inClass")
end

function var0_0.GetShipIDs(arg0_26)
	return {}
end

function var0_0.CheckResFields(arg0_27)
	if arg0_27._oilVO:IsStarting() then
		arg0_27:AddResFieldListener(arg0_27._oilVO)
	end

	if arg0_27._goldVO:IsStarting() then
		arg0_27:AddResFieldListener(arg0_27._goldVO)
	end

	if arg0_27._classVO:IsStarting() then
		arg0_27:AddResFieldListener(arg0_27._classVO)
	end
end

function var0_0.StartUpGradeSuccess(arg0_28, arg1_28)
	local var0_28 = arg1_28:bindConfigTable()[arg1_28:GetLevel()].time

	arg1_28:SetUpgradeTimeStamp(pg.TimeMgr.GetInstance():GetServerTime() + var0_28)
	arg0_28:AddResFieldListener(arg1_28)
	arg0_28.facade:sendNotification(var0_0.RESOURCE_UPGRADE, {
		resVO = arg1_28
	})
end

function var0_0.AddResFieldListener(arg0_29, arg1_29)
	local var0_29 = arg1_29._upgradeTimeStamp - pg.TimeMgr.GetInstance():GetServerTime()

	if var0_29 > 0 then
		local var1_29 = arg1_29:GetUpgradeType()

		if arg0_29.timers[var1_29] then
			arg0_29.timers[var1_29]:Stop()

			arg0_29.timers[var1_29] = nil
		end

		arg0_29.timers[var1_29] = Timer.New(function()
			arg0_29:UpgradeFinish()
			arg0_29.timers[var1_29]:Stop()

			arg0_29.timers[var1_29] = nil
		end, var0_29, 1)

		arg0_29.timers[var1_29]:Start()
	end
end

function var0_0.UpgradeFinish(arg0_31)
	if arg0_31._goldVO:GetDuration() and arg0_31._goldVO:GetDuration() <= 0 then
		local var0_31 = arg0_31._goldVO:bindConfigTable()[arg0_31._goldVO:GetLevel()].store

		arg0_31._goldVO:SetLevel(arg0_31._goldVO:GetLevel() + 1)
		arg0_31._goldVO:SetUpgradeTimeStamp(0)

		local var1_31 = arg0_31._goldVO:bindConfigTable()[arg0_31._goldVO:GetLevel()].store

		arg0_31:sendNotification(var0_0.RESOURCE_UPGRADE_DONE, {
			field = arg0_31._goldVO,
			value = var1_31 - var0_31
		})
	end

	if arg0_31._oilVO:GetDuration() and arg0_31._oilVO:GetDuration() <= 0 then
		local var2_31 = arg0_31._oilVO:bindConfigTable()[arg0_31._oilVO:GetLevel()].store

		arg0_31._oilVO:SetLevel(arg0_31._oilVO:GetLevel() + 1)
		arg0_31._oilVO:SetUpgradeTimeStamp(0)

		local var3_31 = arg0_31._oilVO:bindConfigTable()[arg0_31._oilVO:GetLevel()].store

		arg0_31:sendNotification(var0_0.RESOURCE_UPGRADE_DONE, {
			field = arg0_31._oilVO,
			value = var3_31 - var2_31
		})
	end

	if arg0_31._classVO:GetDuration() and arg0_31._classVO:GetDuration() <= 0 then
		local var4_31 = arg0_31._classVO:bindConfigTable()[arg0_31._classVO:GetLevel()].store
		local var5_31 = arg0_31._classVO:bindConfigTable()[arg0_31._classVO:GetLevel()].proficency_get_percent
		local var6_31 = arg0_31._classVO:bindConfigTable()[arg0_31._classVO:GetLevel()].proficency_cost_per_min

		arg0_31._classVO:SetLevel(arg0_31._classVO:GetLevel() + 1)
		arg0_31._classVO:SetUpgradeTimeStamp(0)

		local var7_31 = arg0_31._classVO:bindConfigTable()[arg0_31._classVO:GetLevel()].store
		local var8_31 = arg0_31._classVO:bindConfigTable()[arg0_31._classVO:GetLevel()].proficency_get_percent
		local var9_31 = arg0_31._classVO:bindConfigTable()[arg0_31._classVO:GetLevel()].proficency_cost_per_min

		arg0_31:sendNotification(var0_0.RESOURCE_UPGRADE_DONE, {
			field = arg0_31._classVO,
			value = var7_31 - var4_31,
			rate = var8_31 - var5_31,
			exp = (var9_31 - var6_31) * 60
		})
	end
end

function var0_0.isResourceFieldUpgradeConditionSatisfy(arg0_32)
	local var0_32 = getProxy(PlayerProxy):getData()

	if arg0_32:GetOilVO():CanUpgrade(var0_32.level, var0_32.gold) or arg0_32:GetGoldVO():CanUpgrade(var0_32.level, var0_32.gold) or arg0_32:GetClassVO():CanUpgrade(var0_32.level, var0_32.gold) then
		return true
	end

	return false
end

function var0_0.AddCourseProficiency(arg0_33, arg1_33)
	local var0_33 = arg0_33:getCourse()
	local var1_33 = arg0_33:GetClassVO()
	local var2_33 = var1_33:GetExp2ProficiencyRatio() * var0_33:getExtraRate()
	local var3_33 = var0_33:GetProficiency() + math.floor(arg1_33 * var2_33 * 0.01)
	local var4_33 = math.min(var3_33, var1_33:GetMaxProficiency())

	var0_33:SetProficiency(var4_33)
	arg0_33:setCourse(var0_33)
end

function var0_0.fillStudens(arg0_34, arg1_34)
	local var0_34 = pg.gameset.academy_random_ship_count.key_value
	local var1_34 = {}

	for iter0_34, iter1_34 in pairs(arg1_34) do
		var1_34[iter1_34.groupId] = true
		var0_34 = var0_34 - 1
	end

	local var2_34 = pg.gameset.academy_random_ship_coldtime.key_value

	if not arg0_34._timeStamp or var2_34 < os.time() - arg0_34._timeStamp then
		arg0_34._studentsFiller = nil
	end

	if not arg0_34._studentsFiller then
		local var3_34 = math.random(1, var0_34)

		arg0_34._timeStamp = os.time()
		arg0_34._studentsFiller = {}

		local var4_34 = getProxy(CollectionProxy):getGroups()
		local var5_34 = getProxy(BayProxy)
		local var6_34 = getProxy(ShipSkinProxy):getSkinList()
		local var7_34 = {}

		for iter2_34, iter3_34 in pairs(var4_34) do
			if not table.contains(var1_34, iter2_34) then
				var7_34[#var7_34 + 1] = iter2_34
			end
		end

		local var8_34 = #var7_34

		while var3_34 > 0 and var8_34 > 0 do
			local var9_34 = math.random(#var7_34)
			local var10_34 = var7_34[var9_34]
			local var11_34 = var4_34[var10_34]
			local var12_34 = var10_34 * 10 + 1
			local var13_34 = 10000000000 + var12_34
			local var14_34 = ShipGroup.getSkinList(var10_34)
			local var15_34 = {}
			local var16_34
			local var17_34 = {}

			for iter4_34, iter5_34 in ipairs(var14_34) do
				local var18_34 = iter5_34.skin_type

				if var18_34 == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var6_34, iter5_34.id) or var18_34 == ShipSkin.SKIN_TYPE_REMAKE and var11_34.trans or var18_34 == ShipSkin.SKIN_TYPE_PROPOSE and var11_34.married == 1 then
					var17_34[#var17_34 + 1] = iter5_34.id
				end

				var16_34 = var17_34[math.random(#var17_34)]
			end

			local var19_34 = {
				id = var13_34,
				groupId = var10_34,
				configId = var12_34,
				skin_id = var16_34
			}

			table.remove(var7_34, var9_34)

			var8_34 = var8_34 - 1
			var3_34 = var3_34 - 1
			arg0_34._studentsFiller[#arg0_34._studentsFiller + 1] = var19_34
		end
	end

	for iter6_34, iter7_34 in ipairs(arg0_34._studentsFiller) do
		arg1_34[#arg1_34 + 1] = Ship.New(iter7_34)
	end

	return arg1_34
end

function var0_0.IsShowTip(arg0_35)
	local var0_35 = getProxy(PlayerProxy)

	if var0_35 and var0_35:getData() and arg0_35:isResourceFieldUpgradeConditionSatisfy() then
		return true
	end

	local var1_35 = getProxy(ShopsProxy)

	if var1_35 then
		local var2_35 = var1_35:getShopStreet()

		if var2_35 and var2_35:isUpdateGoods() then
			return true
		end
	end

	local var3_35 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_35, iter1_35 in pairs(arg0_35.students) do
		if var3_35 >= iter1_35:getFinishTime() then
			return true
		end
	end

	if getProxy(CollectionProxy):unclaimTrophyCount() > 0 then
		return true
	end

	local var4_35 = getProxy(TaskProxy)

	if _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST), function(arg0_36)
		local var0_36 = arg0_36:getTaskShip()
		local var1_36 = var0_36 and var4_35:getAcademyTask(var0_36.groupId) or nil
		local var2_36 = var4_35:getTaskById(var1_36)
		local var3_36 = var4_35:getFinishTaskById(var1_36)

		return var0_36 and (var1_36 and not var2_36 and not var3_36 or var2_36 and var2_36:isFinish())
	end) then
		return true
	end

	return false
end

function var0_0.getDailyFinishCnt(arg0_37)
	local var0_37 = _.detect(BuffHelper.GetBuffsByActivityType(ActivityConst.ACTIVITY_TYPE_BUFF), function(arg0_38)
		return arg0_38:getConfig("benefit_type") == "skill_learn_time"
	end)

	return (var0_37 and tonumber(var0_37:getConfig("benefit_effect")) or 0) - arg0_37.dailyFinsihCnt
end

function var0_0.updateUsedDailyFinishCnt(arg0_39)
	arg0_39.dailyFinsihCnt = arg0_39.dailyFinsihCnt + 1
end

function var0_0.resetUsedDailyFinishCnt(arg0_40)
	arg0_40.dailyFinsihCnt = 0
end

return var0_0
