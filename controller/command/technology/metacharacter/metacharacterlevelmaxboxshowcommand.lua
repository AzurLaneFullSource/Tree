local var0_0 = class("MetaCharacterLevelMaxBoxShowCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(MetaCharacterProxy)

	if not var1_1 then
		return
	end

	local var2_1 = getProxy(ChapterProxy)
	local var3_1 = var2_1:getActiveChapter()
	local var4_1

	if var3_1 then
		var4_1 = var2_1:GetChapterAutoFlag(var3_1.id) == 1
	end

	if var4_1 then
		return
	end

	local var5_1 = var1_1:getMetaSkillLevelMaxInfoList()

	if var5_1 and #var5_1 > 0 then
		local var6_1 = ""

		for iter0_1, iter1_1 in ipairs(var5_1) do
			local var7_1 = iter1_1.metaShipVO
			local var8_1 = iter1_1.metaSkillID
			local var9_1 = var7_1:getName()
			local var10_1 = setColorStr(var9_1, COLOR_GREEN)

			if iter0_1 < #var5_1 then
				var6_1 = var6_1 .. var10_1 .. "、"
			else
				var6_1 = var6_1 .. var10_1
			end
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("meta_skill_maxtip", var6_1),
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
					autoOpenTactics = true,
					autoOpenShipConfigID = var5_1[1].metaShipVO.configId
				})
			end,
			onClose = function()
				if var0_1.closeFunc then
					var0_1.closeFunc()
				end
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end

	var1_1:clearMetaSkillLevelMaxInfoList()
end

return var0_0
