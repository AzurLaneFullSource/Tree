local var0_0 = class("MetaProgress", import("..BaseVO"))

var0_0.STATE_LESS_PT = 1
var0_0.STATE_LESS_STORY = 2
var0_0.STATE_CAN_AWARD = 3
var0_0.STATE_CAN_FINISH = 4
var0_0.STATE_GOT_SHIP = 5

function var0_0.bindConfigTable(arg0_1)
	return pg.ship_strengthen_meta
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id
	arg0_2.metaType = arg0_2:getConfig("type")
	arg0_2.actID = arg0_2:getConfig("activity_id")
	arg0_2.metaShipVO = nil

	if arg0_2:isPtType() then
		arg0_2.unlockPTNum = arg0_2:getConfig("synchronize")
		arg0_2.unlockPTLevel = nil
		arg0_2.metaPtData = MetaPTData.New({
			group_id = arg0_2.id
		})

		local var0_2

		for iter0_2, iter1_2 in ipairs(pg.world_joint_boss_template.all) do
			local var1_2 = pg.world_joint_boss_template[iter1_2]

			if var1_2.meta_id == arg0_2.id then
				var0_2 = var1_2

				break
			end
		end

		if var0_2 then
			arg0_2.timeConfig = var0_2.state
		end
	end
end

function var0_0.updateMetaPtData(arg0_3, arg1_3)
	if arg0_3.metaPtData then
		arg0_3.metaPtData:Update(arg1_3)
	end
end

function var0_0.getSynRate(arg0_4)
	local var0_4, var1_4, var2_4 = arg0_4.metaPtData:GetResProgress()

	return var0_4 / arg0_4.unlockPTNum
end

function var0_0.getStoryIndexList(arg0_5)
	return arg0_5:getConfig("unlock_story") or {
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	}
end

function var0_0.getCurLevelStoryIndex(arg0_6)
	local var0_6, var1_6, var2_6 = arg0_6.metaPtData:GetLevelProgress()

	return arg0_6:getStoryIndexList()[var0_6]
end

function var0_0.isFinishCurLevelStory(arg0_7)
	local var0_7 = arg0_7:getCurLevelStoryIndex()
	local var1_7 = false

	if var0_7 == 0 then
		var1_7 = true
	else
		local var2_7 = pg.NewStoryMgr.GetInstance()
		local var3_7 = var2_7:StoryName2StoryId(var0_7)

		if var2_7:IsPlayed(var3_7) then
			var1_7 = true
		end
	end

	return var1_7
end

function var0_0.getCurLevelStoryName(arg0_8)
	local var0_8 = arg0_8:getCurLevelStoryIndex()

	return pg.memory_template[var0_8].title
end

function var0_0.isCanGetAward(arg0_9)
	local var0_9 = arg0_9.metaPtData:CanGetAward()
	local var1_9 = arg0_9:getCurLevelStoryIndex()
	local var2_9 = false

	if var1_9 == 0 then
		var2_9 = true
	else
		local var3_9 = pg.NewStoryMgr.GetInstance()
		local var4_9 = var3_9:GetStoryByName("index")[var1_9]

		if var3_9:IsPlayed(var1_9) then
			var2_9 = true
		end
	end

	return var0_9 and var2_9
end

function var0_0.getMetaProgressPTState(arg0_10)
	local var0_10 = arg0_10.metaPtData:CanGetAward()
	local var1_10 = arg0_10:isFinishCurLevelStory()
	local var2_10 = arg0_10:isUnlocked()
	local var3_10 = arg0_10.metaPtData.level + 1

	if var3_10 < arg0_10.unlockPTLevel then
		if not var0_10 then
			return var0_0.STATE_LESS_PT
		elseif var1_10 == false then
			return var0_0.STATE_LESS_STORY
		elseif var1_10 == true then
			return var0_0.STATE_CAN_AWARD
		end
	elseif var3_10 == arg0_10.unlockPTLevel then
		if not var0_10 then
			return var0_0.STATE_LESS_PT
		elseif var1_10 == false then
			return var0_0.STATE_LESS_STORY
		elseif var1_10 == true then
			return var0_0.STATE_CAN_FINISH
		end
	elseif var3_10 > arg0_10.unlockPTLevel then
		return var0_0.STATE_GOT_SHIP
	end
end

function var0_0.IsGotAllAwards(arg0_11)
	return arg0_11:isInAct() and arg0_11:isInArchive() and not arg0_11.metaPtData:CanGetNextAward()
end

function var0_0.getRepairRateFromMetaCharacter(arg0_12)
	assert(arg0_12.metaShipVO, "metaShipVO is null")

	local var0_12 = arg0_12.metaShipVO.metaCharacter

	assert(var0_12, "metaCharacterVO is null")

	return (var0_12:getRepairRate())
end

function var0_0.isPtType(arg0_13)
	return arg0_13.metaType == MetaCharacterConst.Meta_Type_Act_PT
end

function var0_0.isPassType(arg0_14)
	return arg0_14.metaType == MetaCharacterConst.Meta_Type_Pass
end

function var0_0.isBuildType(arg0_15)
	return arg0_15.metaType == MetaCharacterConst.Meta_Type_Build
end

function var0_0.isInAct(arg0_16)
	if arg0_16:isPtType() then
		return WorldBossConst.IsCurrBoss(arg0_16.id)
	elseif arg0_16:isPassType() or arg0_16:isBuildType() then
		local var0_16 = arg0_16:getConfig("activity_id")
		local var1_16 = getProxy(ActivityProxy):getActivityById(var0_16)

		return var1_16 and not var1_16:isEnd()
	end
end

function var0_0.isInArchive(arg0_17)
	return WorldBossConst.IsAchieveBoss(arg0_17.id)
end

function var0_0.isUnlocked(arg0_18)
	return arg0_18.metaShipVO ~= nil
end

function var0_0.isShow(arg0_19)
	local var0_19 = arg0_19:isInAct()
	local var1_19 = arg0_19:isInArchive()
	local var2_19 = arg0_19:isUnlocked()
	local var3_19 = true

	if var2_19 then
		return true
	elseif var1_19 then
		return true
	elseif var0_19 then
		if arg0_19:isPtType() and var3_19 then
			return true
		elseif arg0_19:isPassType() or arg0_19:isBuildType() then
			return true
		else
			return false
		end
	else
		return false
	end
end

function var0_0.getMetaShipFromBayProxy(arg0_20)
	local var0_20 = getProxy(BayProxy):getMetaShipByGroupId(arg0_20.configId)

	arg0_20.metaShipVO = var0_20

	return var0_20
end

function var0_0.getShip(arg0_21)
	return arg0_21.metaShipVO
end

function var0_0.updateShip(arg0_22, arg1_22)
	assert(arg1_22, "metaShipVO can not be null!")

	arg0_22.metaShipVO = arg1_22
end

function var0_0.setDataBeforeGet(arg0_23)
	arg0_23.metaShipVO = arg0_23:getMetaShipFromBayProxy()

	if arg0_23:isPtType() and arg0_23.metaPtData and not arg0_23.unlockPTLevel then
		local var0_23 = arg0_23.metaPtData.targets

		for iter0_23, iter1_23 in ipairs(var0_23) do
			if iter1_23 == arg0_23.unlockPTNum then
				arg0_23.unlockPTLevel = iter0_23

				break
			end
		end
	end

	if (arg0_23:isPassType() or arg0_23:isBuildType()) and not arg0_23.timeConfig then
		local var1_23 = arg0_23:getConfig("activity_id")
		local var2_23 = getProxy(ActivityProxy):getActivityById(var1_23)

		if var2_23 then
			arg0_23.timeConfig = {
				var2_23:getConfig("time")[2],
				var2_23:getConfig("time")[3]
			}
		end
	end
end

function var0_0.updateDataAfterAddShip(arg0_24)
	arg0_24.metaShipVO = arg0_24:getMetaShipFromBayProxy()
end

function var0_0.addPT(arg0_25, arg1_25)
	if arg0_25:isPtType() and arg0_25.metaPtData then
		arg0_25.metaPtData:addPT(arg1_25)
	end
end

function var0_0.updatePTLevel(arg0_26, arg1_26)
	if arg0_26:isPtType() and arg0_26.metaPtData then
		arg0_26.metaPtData:updateLevel(arg1_26)
	end
end

function var0_0.getPaintPathAndName(arg0_27)
	local var0_27 = arg0_27:isUnlocked()
	local var1_27, var2_27 = MetaCharacterConst.GetMetaCharacterPaintPath(arg0_27.configId, var0_27)

	return var1_27, var2_27
end

function var0_0.getBannerPathAndName(arg0_28)
	local var0_28, var1_28 = MetaCharacterConst.GetMetaCharacterBannerPath(arg0_28.configId)

	return var0_28, var1_28
end

function var0_0.getBGNamePathAndName(arg0_29)
	local var0_29, var1_29 = MetaCharacterConst.GetMetaCharacterNamePath(arg0_29.configId)

	return var0_29, var1_29
end

function var0_0.getPtIconPath(arg0_30)
	assert(arg0_30:isPtType() and arg0_30.metaPtData)

	return Item.getConfigData(arg0_30.metaPtData.resId).icon
end

return var0_0
