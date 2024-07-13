local var0_0 = class("MetaCharacterTacticsUnlockCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipID
	local var2_1 = var0_1.skillID
	local var3_1 = var0_1.materialIndex
	local var4_1 = var0_1.materialInfo

	print("63311 unlock skill", tostring(var1_1), tostring(var2_1), tostring(var3_1))
	pg.ConnectionMgr.GetInstance():Send(63311, {
		ship_id = var1_1,
		skill_id = var2_1,
		index = var3_1
	}, 63312, function(arg0_2)
		if arg0_2.result == 0 then
			print("63312 unlock success")

			local var0_2 = getProxy(BayProxy)
			local var1_2 = var0_2:getShipById(var1_1)
			local var2_2 = var1_2:isAllMetaSkillLock()

			var1_2:upSkillLevelForMeta(var2_1)
			var0_2:updateShip(var1_2)
			arg0_1:sendNotification(GAME.CONSUME_ITEM, Drop.New({
				type = DROP_TYPE_ITEM,
				id = var4_1.id,
				count = var4_1.count
			}))
			getProxy(MetaCharacterProxy):unlockMetaTacticsSkill(var1_1, var2_1, var2_2)
			arg0_1:sendNotification(GAME.TACTICS_META_UNLOCK_SKILL_DONE, {
				metaShipID = var1_1,
				unlockSkillID = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
