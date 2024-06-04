local var0 = class("MetaCharacterLevelMaxBoxShowCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(MetaCharacterProxy)

	if not var1 then
		return
	end

	local var2 = getProxy(ChapterProxy)
	local var3 = var2:getActiveChapter()
	local var4

	if var3 then
		var4 = var2:GetChapterAutoFlag(var3.id) == 1
	end

	if var4 then
		return
	end

	local var5 = var1:getMetaSkillLevelMaxInfoList()

	if var5 and #var5 > 0 then
		local var6 = ""

		for iter0, iter1 in ipairs(var5) do
			local var7 = iter1.metaShipVO
			local var8 = iter1.metaSkillID
			local var9 = var7:getName()
			local var10 = setColorStr(var9, COLOR_GREEN)

			if iter0 < #var5 then
				var6 = var6 .. var10 .. "、"
			else
				var6 = var6 .. var10
			end
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("meta_skill_maxtip", var6),
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
					autoOpenTactics = true,
					autoOpenShipConfigID = var5[1].metaShipVO.configId
				})
			end,
			onClose = function()
				if var0.closeFunc then
					var0.closeFunc()
				end
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end

	var1:clearMetaSkillLevelMaxInfoList()
end

return var0
