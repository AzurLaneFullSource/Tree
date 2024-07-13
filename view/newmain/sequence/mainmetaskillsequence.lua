local var0_0 = class("MainMetaSkillSequence")

function var0_0.Execute(arg0_1, arg1_1)
	arg1_1 = arg1_1 or function()
		return
	end

	local var0_1 = getProxy(MetaCharacterProxy)

	if not var0_1 then
		arg1_1()

		return
	end

	local var1_1 = getProxy(ChapterProxy)
	local var2_1 = var1_1:getActiveChapter()
	local var3_1

	if var2_1 then
		var3_1 = var1_1:GetChapterAutoFlag(var2_1.id) == 1
	end

	if var3_1 then
		arg1_1()

		return
	end

	local var4_1 = var0_1:getMetaSkillLevelMaxInfoList()

	if var4_1 and #var4_1 > 0 then
		local var5_1 = arg0_1:GetShipName(var4_1)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("meta_skill_maxtip", var5_1),
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
					autoOpenTactics = true,
					autoOpenShipConfigID = var4_1[1].metaShipVO.configId
				})
			end,
			onClose = arg1_1,
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		arg1_1()
	end

	var0_1:clearMetaSkillLevelMaxInfoList()
end

function var0_0.GetShipName(arg0_4, arg1_4)
	local var0_4 = ""

	for iter0_4, iter1_4 in ipairs(arg1_4) do
		local var1_4 = iter1_4.metaShipVO
		local var2_4 = iter1_4.metaSkillID
		local var3_4 = var1_4:getName()
		local var4_4 = setColorStr(var3_4, COLOR_GREEN)

		if iter0_4 < #arg1_4 then
			var0_4 = var0_4 .. var4_4 .. "、"
		else
			var0_4 = var0_4 .. var4_4
		end
	end

	return var0_4
end

return var0_0
