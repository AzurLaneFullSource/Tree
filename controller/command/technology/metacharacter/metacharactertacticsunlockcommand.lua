local var0 = class("MetaCharacterTacticsUnlockCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipID
	local var2 = var0.skillID
	local var3 = var0.materialIndex
	local var4 = var0.materialInfo

	print("63311 unlock skill", tostring(var1), tostring(var2), tostring(var3))
	pg.ConnectionMgr.GetInstance():Send(63311, {
		ship_id = var1,
		skill_id = var2,
		index = var3
	}, 63312, function(arg0)
		if arg0.result == 0 then
			print("63312 unlock success")

			local var0 = getProxy(BayProxy)
			local var1 = var0:getShipById(var1)
			local var2 = var1:isAllMetaSkillLock()

			var1:upSkillLevelForMeta(var2)
			var0:updateShip(var1)
			arg0:sendNotification(GAME.CONSUME_ITEM, Drop.New({
				type = DROP_TYPE_ITEM,
				id = var4.id,
				count = var4.count
			}))
			getProxy(MetaCharacterProxy):unlockMetaTacticsSkill(var1, var2, var2)
			arg0:sendNotification(GAME.TACTICS_META_UNLOCK_SKILL_DONE, {
				metaShipID = var1,
				unlockSkillID = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
