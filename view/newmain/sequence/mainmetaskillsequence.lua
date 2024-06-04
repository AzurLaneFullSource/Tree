local var0 = class("MainMetaSkillSequence")

function var0.Execute(arg0, arg1)
	arg1 = arg1 or function()
		return
	end

	local var0 = getProxy(MetaCharacterProxy)

	if not var0 then
		arg1()

		return
	end

	local var1 = getProxy(ChapterProxy)
	local var2 = var1:getActiveChapter()
	local var3

	if var2 then
		var3 = var1:GetChapterAutoFlag(var2.id) == 1
	end

	if var3 then
		arg1()

		return
	end

	local var4 = var0:getMetaSkillLevelMaxInfoList()

	if var4 and #var4 > 0 then
		local var5 = arg0:GetShipName(var4)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("meta_skill_maxtip", var5),
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
					autoOpenTactics = true,
					autoOpenShipConfigID = var4[1].metaShipVO.configId
				})
			end,
			onClose = arg1,
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		arg1()
	end

	var0:clearMetaSkillLevelMaxInfoList()
end

function var0.GetShipName(arg0, arg1)
	local var0 = ""

	for iter0, iter1 in ipairs(arg1) do
		local var1 = iter1.metaShipVO
		local var2 = iter1.metaSkillID
		local var3 = var1:getName()
		local var4 = setColorStr(var3, COLOR_GREEN)

		if iter0 < #arg1 then
			var0 = var0 .. var4 .. "、"
		else
			var0 = var0 .. var4
		end
	end

	return var0
end

return var0
