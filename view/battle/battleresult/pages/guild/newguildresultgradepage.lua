local var0 = class("NewGuildResultGradePage", import("..NewBattleResultGradePage"))

function var0.LoadBG(arg0, arg1)
	local var0 = "Victory"

	ResourceMgr.Inst:getAssetAsync("BattleResultItems/" .. var0, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited or IsNil(arg0) then
			if arg1 then
				arg1()
			end

			return
		end

		Object.Instantiate(arg0, arg0.bgTr).transform:SetAsFirstSibling()

		if arg1 then
			arg1()
		end
	end), false, false)
end

function var0.LoadGrade(arg0, arg1)
	local var0 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var0, arg0.gradeTxt, true)

	if arg1 then
		arg1()
	end
end

function var0.GetContributionPoint(arg0)
	local var0 = 0
	local var1 = pg.guildset.guild_damage_resource.key_value

	for iter0, iter1 in ipairs(arg0.contextData.drops) do
		if iter1.configId == var1 then
			var0 = iter1.count
		end
	end

	return var0
end

function var0.GetGetObjectives(arg0)
	local var0 = {}
	local var1 = i18n("battle_result_total_damage")

	table.insert(var0, {
		text = setColorStr(var1, "#FFFFFFFF"),
		value = setColorStr(arg0.contextData.statistics.specificDamage, COLOR_BLUE)
	})

	local var2 = i18n("battle_result_contribution")

	table.insert(var0, {
		text = setColorStr(var2, "#FFFFFFFF"),
		value = setColorStr(arg0:GetContributionPoint(), COLOR_YELLOW)
	})

	return var0
end

return var0
